# ADR-0002 — Authentification : Supabase Auth (Azure AD + email/MFA)

**Statut :** Accepté (2026-06-22) · **Contexte :** PEPITE / SI-2026-014

## Contexte
Deux populations distinctes : ~145 collaborateurs internes (déjà dans Azure AD/Entra) et
~3 500 clients externes. Données sensibles → MFA nécessaire. Supabase Auth (GoTrue) est déjà
opérationnel avec Azure AD et GitHub actifs, MFA TOTP par défaut, emails via relais MS Graph.

## Options
1. **Supabase Auth** : Azure AD (staff) + email/MFA (clients).
2. **Azure AD pour tous** : clients en comptes invités B2B.
3. **Auth custom (JWT maison)**.

## Décision
**Option 1.** Staff via Azure AD (SSO existant) ; clients via email/mot de passe + MFA TOTP,
confirmation par relais Microsoft Graph.

## Conséquences
- (+) Réutilise l'intégration Entra et le MFA déjà en place ; pas de code d'auth maison.
- (+) Séparation claire staff/clients dès l'authentification.
- (−) Dépendance au relais Graph (`Mail.Send` + secret) pour les emails clients — à activer.
- (−) Gérer le mapping claim `groups` Entra → rôle applicatif (hook/au login).
- Respecter les pièges Azure AD documentés (URL sans `/v2.0`, scope `email`, buffers nginx).

Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9353A3B9D9F;
	Mon, 11 May 2026 08:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489857; cv=none; b=bzMs+dzsPF5L3AiNrgxbd+DcVtPxOJsLuzkVKFoIyjcmwiix3igHNEkb9aU01JCIfKqOyps/A5s7IY3hKkvIdIcdqaHS7VF7Q7MY8LWz4F22FPSJZrRBw5DY6BQSMkZA5joKelw89jDlCmWM4+KYTT4eFKHYl7JWAtqf8LJFYZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489857; c=relaxed/simple;
	bh=yG1ZQpDp59m7GIi0rClPuRqEcexWJ1Je7cyz4dCBFJo=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=PkA69LxsItkabxug6wseisrdCSq2t6vQRK+u/DZryDZIN74lxG8EUiVjD4QxttVqrn4q6gzYqO/+i84aLvQ2AF1/ut9ExBOYeRcV8zzflwdykGuFwh080LDgCuIDgnWuN8MKPUNi4ivuYYdpFiE7qdH5b2QxlfK84gZs/uPO9ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZkLujkeH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZkLujkeH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
	From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zhkE8m1bTkpWiqGtlhKzD3LU8FaLp3DU7tLfKoKSNzw=; b=ZkLujkeHAdzl6TVM1LqDRAlsd1
	ycTRG8fgZlvV/cz+lwdyC1d9MmhT92AvmtvwPDkCSmX/jRcBy8TjWvGuZgpGCSp5rDNl4MtGRfns1
	rBw/mLxHqnvs7PniVjpXMC/jZQ1GTGxiXrQUWhWpakZpCaSJDJy5xdSeHp0rDDBSvvQLdh7UqAP5Y
	/BtGilO/fCFyw7GjFxbNWaJlEGjbknfad66mrQ6og6tB5TJsXqe/L4cZTHLpEb5lmW5juzcxW37rB
	shtNWc8IL2gVJIfKMTRVP+px06FVIJUHDPcZ+c0mOqRsH9d3qXHBcvzeyfOVQsi8Mdy4R5J7FsJZm
	5FvfZwoA==;
Received: from 54-240-197-234.amazon.com ([54.240.197.234] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMMS8-00000007t91-1uZE;
	Mon, 11 May 2026 08:57:29 +0000
Message-ID: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
Subject: [PATCH] Documentation: KVM: Document guest-visible compatibility
 expectations
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, Eric
 Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>,  Arnd Bergmann
 <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
Date: Mon, 11 May 2026 09:57:27 +0100
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-G9nCGITdCY7OEi2eGNSc"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-G9nCGITdCY7OEi2eGNSc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

Document the expectation that KVM maintains guest-visible compatibility
across host kernel upgrades and rollbacks.  Specifically:

 - State saved/restored via KVM ioctls must be sufficient for live
   migration (and live update) between kernel versions.

 - Where a new kernel introduces a guest-visible change, it provides a
   mechanism for userspace to select the previous behaviour.

 - This allows both forward migration (upgrade) and backward migration
   (rollback) of guests.

These expectations have been implicitly required on x86 but were not
explicitly documented. Harmonise the expectations across all of KVM.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst              | 14 ++++++++++++++
 Documentation/virt/kvm/review-checklist.rst | 20 ++++++++++++++------
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 269970221797..864f3daa7acb 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -97,6 +97,20 @@ Instead, kvm defines extension identifiers and a facilit=
y to query
 whether a particular extension identifier is available.  If it is, a
 set of ioctls is available for application use.
=20
+KVM will ensure that the state that can be saved and restored via the
+KVM ioctls is sufficient to allow migration of a running guest between
+host kernels while maintaining full compatibility of the guest-visible
+device model.  This includes migration to newer kernels (upgrade) and
+to older kernels (rollback), provided that the older kernel supports
+the set of features exposed to the guest.  Where a new kernel version
+introduces a guest-visible change, it will provide a mechanism (such
+as a capability or a device attribute) that allows userspace to select
+the previous behaviour.  This serves two purposes: guests migrated
+from an older kernel can continue to run with their original
+observable environment, and new guests launched on the newer kernel
+can be configured to match the feature set of the older kernel, so
+that they remain migratable to the older kernel in case of rollback.
+
=20
 4. API description
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/virt/kvm/review-checklist.rst b/Documentation/vi=
rt/kvm/review-checklist.rst
index 053f00c50d66..f0fbe1577a90 100644
--- a/Documentation/virt/kvm/review-checklist.rst
+++ b/Documentation/virt/kvm/review-checklist.rst
@@ -18,22 +18,30 @@ Review checklist for kvm patches
 5.  New features must default to off (userspace should explicitly request =
them).
     Performance improvements can and should default to on.
=20
-6.  New cpu features should be exposed via KVM_GET_SUPPORTED_CPUID2,
+6.  Guest-visible changes must not break migration compatibility.  A guest
+    migrated from an older kernel must be able to run with its original
+    observable environment, and a guest launched on a newer kernel must be
+    configurable to match the older kernel's feature set for rollback.
+    Where a change alters guest-visible behaviour, provide a mechanism
+    (capability, device attribute, etc.) for userspace to select the
+    previous behaviour.
+
+7.  New cpu features should be exposed via KVM_GET_SUPPORTED_CPUID2,
     or its equivalent for non-x86 architectures
=20
-7.  The feature should be testable (see below).
+8.  The feature should be testable (see below).
=20
-8.  Changes should be vendor neutral when possible.  Changes to common cod=
e
+9.  Changes should be vendor neutral when possible.  Changes to common cod=
e
     are better than duplicating changes to vendor code.
=20
-9.  Similarly, prefer changes to arch independent code than to arch depend=
ent
+10. Similarly, prefer changes to arch independent code than to arch depend=
ent
     code.
=20
-10. User/kernel interfaces and guest/host interfaces must be 64-bit clean
+11. User/kernel interfaces and guest/host interfaces must be 64-bit clean
     (all variables and sizes naturally aligned on 64-bit; use specific typ=
es
     only - u64 rather than ulong).
=20
-11. New guest visible features must either be documented in a hardware man=
ual
+12. New guest visible features must either be documented in a hardware man=
ual
     or be accompanied by documentation.
=20
 Testing of KVM code
--=20
2.43.0



--=-G9nCGITdCY7OEi2eGNSc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxMTA4NTcy
N1owLwYJKoZIhvcNAQkEMSIEILuqqeGsDMy8i+DSdQZhMFBb7wVvHxqewC+yF95XciBUMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAQFRU02bseifG
jLfYVzy1o4gcfJwYzr49oCGmvjRlw/kXB4Hj8fbl5jY/1SgQmphTQsqgx2b4zpAlJeuuYx0qj2+j
fyvjD81gl+r+ESymz1+kEVh3s66nLpP7lI/PbMtkE726vvpJP68lS51kSBjQ/nma56FPRo6gClVd
NipYrnCiYqk2G2QatSMxBM7q3864ENSphqDm39AXhOfIvOBZZUh841hDB68VT9MFoqDp8DcWQvaz
ubtNpqm75ZqLOI7+XlSPp6Fdr65ojpp2XpUJiLfHS/Ts62HjYGFaT3QPfbSHTXNAUlxajAQCMntF
yMfd9DE009goZu+6aKUF17GnSV2FyTuBrNPX21R1KeMnjAKqP5/loD6IWkHa5tJSGBHfnTtzPwet
YUo5YNEFlg3APxbHyVqZJbfYxsaQmSRWCODjk4rIzE8gbloNRl7TSC7t2Fvfvz++4lAIBfuXvIzp
VgV3kug2AKxLkNzklo8FrRmVZZOCY8raP0+86MzbeBRasMVzCAYEh1lAjOgXLm9VitGnqnWPr5CT
2IpR+as+YMePwA+Lv4BVadF7h6/uuJFSngm+6anIOc7qoQlrf+nlmkGyBibyeKgxYz9wfNW0uD/X
HSCwAFoKlDe4TIRdoPhXd5yiYgwRsbY7CoiefhAsmOQLnmofp3hhdSI6MbJ2xTMAAAAAAAA=


--=-G9nCGITdCY7OEi2eGNSc--

Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AEE3B637A;
	Mon, 11 May 2026 08:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778487267; cv=none; b=DFEb7VfChXOjYGH55KzQ26Sonq/Zx0ppEqBMidpHcS/MhGA9ljLkRQ3LkRQgcCCO0sskWY+2Iq2oX1gCbNsKD+u6BuKomq8bgxLRObvYPQ/04WOGNoonSWQPv4Fmx4MYfKYmHcP1ZkrohtMEuXp1c4GOTQwU9Nx0KEYFVJiC+go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778487267; c=relaxed/simple;
	bh=+f3NDp3JJnewBzZFvRTIpC5dH2ncWgD8NrNLO0oyfjc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tZtRX3Ome4O9DR9gpyDDOUyKpmpKEO7ONJGFzSse8MjBCzCgC/MVENWl93mNII+5yRrxcsF7FzFKjV+/t65Qm4vdvS4muutPTriPNqTlUUWnqanHAG9WtMSisbBI3oQsDCsSMDdeiRIoq92iV5Gqj8949Z8j1x31/hylTswGeys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RpaYWWTz; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RpaYWWTz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+f3NDp3JJnewBzZFvRTIpC5dH2ncWgD8NrNLO0oyfjc=; b=RpaYWWTz2QtPb599pSzE4kcVfl
	Q7cUOtLjR5nmZJdIfHBXa5Bh4j4aLPr2uQHBuJfmU9atDj43rJYP68jl6ccafd96EOYj5H4aTbhS1
	G51mCWt5Z8JThG1/DJz9XKojqLYyOJykVaEtJaSHn7DmbJ/umjz6vI370/9tAYC+TgK7fww8IHm1X
	V8saGxc2ycZBV/cYJFhKVqUps5tD0pzZw3PXYsyxwcKb6g6MFPaBpVUSfGONEMxwTB3dZMqo9p4Ks
	VXMJHRni0loDfvUlslXIsZpKBTcJ6P7GNoGwvvAD9eYxySq0njARLMXRR2XG4t0hkSIFHA+XNXINA
	2AAgXDMA==;
Received: from 54-240-197-234.amazon.com ([54.240.197.234] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMLm2-00000007pvS-3cpz;
	Mon, 11 May 2026 08:13:59 +0000
Message-ID: <f17cbc37a3d9856495449ade920f49bda713c7fe.camel@infradead.org>
Subject: Re: (subset) [PATCH 1/3] KVM: arm64: vgic: Fix IIDR revision field
 extracted from wrong value
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan
 <shuah@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, Eric Auger
 <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>, Arnd Bergmann
 <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
Date: Mon, 11 May 2026 09:13:57 +0100
In-Reply-To: <86ik8uxtue.wl-maz@kernel.org>
References: <20260407210949.2076251-1-dwmw2@infradead.org>
	 <20260407210949.2076251-2-dwmw2@infradead.org>
	 <177702878141.537738.13460155220731277452.b4-ty@kernel.org>
	 <106addd3f78918a9a584c43c181a9609aef1ceca.camel@infradead.org>
	 <f17a2d66e47fd15fc738d9f4ad89123a31d86eb3.camel@infradead.org>
	 <86ik8uxtue.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-oOragWL9efoIITVL6FW7"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-oOragWL9efoIITVL6FW7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-05-11 at 08:56 +0100, Marc Zyngier wrote:
> On Sun, 10 May 2026 22:28:50 +0100,
> David Woodhouse <dwmw2@infradead.org> wrote:
> >=20
> > [1=C2=A0 <text/plain; UTF-8 (quoted-printable)>]
> > On Fri, 2026-04-24 at 13:24 +0100, David Woodhouse wrote:
> > > On Fri, 2026-04-24 at 12:07 +0100, Marc Zyngier wrote:
> > > > On Tue, 07 Apr 2026 21:27:02 +0100, David Woodhouse wrote:
> > > > > The uaccess write handlers for GICD_IIDR in both GICv2 and GICv3
> > > > > extract the revision field from 'reg' (the current IIDR value rea=
d back
> > > > > from the emulated distributor) instead of 'val' (the value usersp=
ace is
> > > > > trying to write). This means userspace can never actually change =
the
> > > > > implementation revision =E2=80=94 the extracted value is always t=
he current one.
> > > > >=20
> > > > > Fix the FIELD_GET to use 'val' so that userspace can select a dif=
ferent
> > > > > revision for migration compatibility.
> > > > >=20
> > > > > [...]
> > > >=20
> > > > Applied to fixes, thanks!
> > > >=20
> > > > [1/3] KVM: arm64: vgic: Fix IIDR revision field extracted from wron=
g value
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 commit: a0e6ae45af17e8b2795883059579=
9c702ffbab8d
> > >=20
> > > There was a v2 of this series which also cleaned up the weird
> > > inconsistency of the IIDR value with the actual behaviour, and which
> > > fixed the fact that it's currently not possible to maintain guest
> > > compatibility when upgrading from a pre-d53c2c29ae0d kernel to a new
> > > one =E2=80=94 despite the fact that that kind of compatibility is *pr=
ecisely*
> > > what the revision field in the IIDR is designed for.
> > >=20
> > > https://lore.kernel.org/all/20260408113256.2095505-1-dwmw2@infradead.=
org/
> >=20
> > Is there a reason the rest of these fixes didn't make 7.1?
>=20
> I already explained why these changes are neither necessary (a guest
> that used to run still runs) nor desirable (reintroducing bugs we have
> fixed is a bad idea).
>=20
> I have therefore only taken the fix for the bug affecting userspace,
> as that was definitely something worth fixing.

You claimed that KVM/arm64 does not support migrating guests to older
(or even newer!!) kernels while maintaining compatibility.

That just *isn't* a cogent argument. I responded to it, in
https://lore.kernel.org/all/8cca18f332ea4bfb0c9f9d6775b2c1284816dd5f.camel@=
infradead.org/

KVM absolutely does need to support upgrading the kernel without
changing the environment that guests see. And sometimes it is sadly
also necessary to roll back an upgrade =E2=80=94 which means that guests
launched on the new kernel should not see anything new until the fleet
is past the point where a rollback might happen.

Guest-visible changes need to be optional, in the case of the vGIC that
is exactly what the IIDR is *for*. There's not much point in my patch
that allows it to be *set*, if we don't allow it to be set *to* the
previous versions that are needed.

This isn't exactly rocket science, and I don't know why you claim not
to understand it.

What's going on, Marc? This behaviour isn't OK.


--=-oOragWL9efoIITVL6FW7
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxMTA4MTM1
N1owLwYJKoZIhvcNAQkEMSIEIMc+zVoJmglHdNcFwKdylaxWDnI/3ICPVJ5KgwBwfNZ7MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAjfArC5AJRoH7
huM25AG2KgXbXUdLsSY6P8o9Szr+iQMKm4Ri/QJW0tWibVy/MUk3xTljIYeP38wmGZm+4ZI4GHqi
TSZIZuEyr6Re6Ts3SHL3l09l1/fFDydChk+yzimA4cEK3k08RctcP/sbqAlhAw8qlFelJZ78NJ5O
vcm02eyb3S9dGgcyDK8LrtMr6RJuEta7NavNdB7a1yYl7vdcBv5aIueMWNaZb2INT4kk4ml4g/sA
FPygqdfSxTp9gELolnbFs1gKiB4FzMLtc3KPLwqhCv56UOa1GeEdEtedeMsDSYVIZHEYOtG1bgXf
Ie/er8Y3CNmA+P85H7qcmyVsnEnvCFs91f7W9wl4zwIupw1fs7aqte+P1VEedV6J+DcHLOZvTkPu
vyvO/bEBSxSw+zVl2RnrpaCI2C5VsrI9vcIX3SFSWYZ4DyHiFgYdL0Ts2TKjii/8VCobQQvqRW1y
nMNvws2jbU9gB49UKUNrkS0i61MnxN9JDntWzC9e6agdktf2HFHlyZ0TkJJHjKMSyQHG2Qrsczjs
HZ/pxnUla6O70J1qJVMGX9EZR1+TUdXbp2Z0P/Xj9kQuVky0QTrqAxU9FWCCJfHybGYt9yK7BUnP
ulyXmAdgeyAcD/TihWx55dEtsSsg8sakavNmRBDmNnrql41MFdP9WA1CzRES7xEAAAAAAAA=


--=-oOragWL9efoIITVL6FW7--

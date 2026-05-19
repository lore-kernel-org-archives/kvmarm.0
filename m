Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DC94DD6FE;
	Tue, 19 May 2026 13:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779195606; cv=none; b=aqa4/q5Gw6TyrrQptMXejkoxeXrpWxwOykcuuPZ/ticztYR1N4bpLNJkrMvk2aL3nTMt3YD6eP+/d77wC/ovOBxjhJWYWZp37wevbbETz7O3lF4RNEwSmDRFbNYglnOjS9OtAx57vr6HDpj7pHe5G6IGuS1w/Xt9V/Be51yrXkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779195606; c=relaxed/simple;
	bh=oo7P3J2lPKnxh0ard7ivOkuTgp+n+5ilNxlLp9wqvgA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IkbSdZ1gN248TnVrxkinvSPGw00phPqZMxb3uW3A656a//1lSL8sF8OIpQOHwXZTH8lMCEvekCBB1iqDqLCVflikf7mFnmp0YQY46tVDH5g47tNqauBtEfWsbB3UDnkc1BZ4ImdNf2n/1PtxWC5+d/xkU2GQjKAIdeWdN17muxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tnC2K3WL; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tnC2K3WL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oo7P3J2lPKnxh0ard7ivOkuTgp+n+5ilNxlLp9wqvgA=; b=tnC2K3WLgHL8AYX97vzYiME6Jp
	LMzXao+hOy4jOUVecYxaDlkvi+djH0q0O0FE1jxI2NeN4Vucnxn/+LLPuip2tYAIfqt1q+a47sWwu
	Kvk/chfktNu0W/Yy5Bs4+JckTvHBajDY5UPlW/d0YgftgQS9fAtruj6YtQ0iDSCzo4VSsCrJn/X1W
	V7oOWaaOGT4rxQfc9SboJouZ1qH/PFj2Xio2IIo8ScrWGFLFc7VTHHNwsYQs5Sehp6AOA1rJP4DNb
	JNBTvj/d4YLO6NeGFCRZaZxFkm1QYQiaZxhJ4rFNUoclfykNnQhbgYiKtBJQMOjt+b0TBx7SMRKdG
	dkTSX0IQ==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPK3C-00000005vR9-230Y;
	Tue, 19 May 2026 12:59:58 +0000
Message-ID: <593a782c50f3c8656e13b36dfb975a67d43a908e.camel@infradead.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible
 compatibility expectations
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, kvm <kvm@vger.kernel.org>, Linux Doc
 Mailing List <linux-doc@vger.kernel.org>, "Kernel Mailing List, Linux"
 <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@kernel.org>, Joey
 Gouly <joey.gouly@arm.com>,  Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Eric Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>,  Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
 kvmarm@lists.linux.dev, linux-kselftest <linux-kselftest@vger.kernel.org>
Date: Tue, 19 May 2026 13:59:57 +0100
In-Reply-To: <86qzn7wp3y.wl-maz@kernel.org>
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
	 <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com>
	 <57bc082f4824d6114d3156744c25986effc29aca.camel@infradead.org>
	 <baff82ca-6321-4b16-aa61-b2d6d60b6535@redhat.com>
	 <86h5obya2r.wl-maz@kernel.org>
	 <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
	 <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com>
	 <d9d4471a7f5ec1e297b3ca07f42a59090aa91e15.camel@infradead.org>
	 <CABgObfaM-JtNn2MuYXaiadQnLfAhTEaoHAcTG9=J6LkMcQCJ3A@mail.gmail.com>
	 <3f9d731c3d26b0367600f1069e6425099bc34eac.camel@infradead.org>
	 <agxFbniU_6eQ98t2@willie-the-truck>
	 <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
	 <CABgObfacAYexR25SMi1kSZMRnHx3EDGj8=E84V1DumER66ibnQ@mail.gmail.com>
	 <86qzn7wp3y.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-hA914rn3EHlaahFdTxVS"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-hA914rn3EHlaahFdTxVS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-05-19 at 13:38 +0100, Marc Zyngier wrote:
>=20
> > But in this case there's an ID register that tells KVM if userspace
> > wants the old or the new behavior, independent of whether that old
> > behavior is architecturally valid or not.
>=20
> But the "old behaviour" makes no sense, and cannot be used by a guest:
>=20
> - either the guest doesn't use the alternative interrupt groups, then
> =C2=A0 it wasn't affected by the bug. That's 100% of the guests.
>=20
> - or the guest did try to use the alternative groups, and it *NEVER*
> =C2=A0 worked, as it wouldn't get any interrupt at all. What is the point
> =C2=A0 of preserving a "feature" that only results in a non-working guest=
?

Given how long this bug existed in KVM, it's entirely feasible that
some guests *check* for it and refrain from trying to use the
alternative groups if the registers aren't actually writable.

If such a guest boots on the new kernel and *does* use alternative
groups, and then the kernel is rolled back, it breaks.

Or some guest configurations which have only ever been tested under KVM
could have a bug where they *rely* on the registers not being writable,
and write values which are inconsistent with the rest of their
configuration. Which breaks the moment those registers become writable.

Even in that latter case, when we're hosting customer guests under KVM
and we make a change which breaks things, we don't get to tell
customers "you deserved it".

And those hypothetical cases *do* happen. All of the time. There's a
massive zoo of guest operating systems; not just the major players like
Linux, FreeBSD and Windows but a whole bunch of embedded home-grown and
network appliance kernels.

Nobody is claiming that we shouldn't fix any bug ever.

--=-hA914rn3EHlaahFdTxVS
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxOTEyNTk1
N1owLwYJKoZIhvcNAQkEMSIEIFnxe5BeKRwiLXSbhvRrjFAcQBbv3hrgmq8gFL+mpyHiMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAHDJJ0qCBBL+j
ZvyZWMOctXiROaA2UBab64EnCKf5ullOYMLcL40HKj8NAsNyMnUneZM0YSS4d5RHmRdkjfmLQF5s
R2BQpzf1XETuThBCIkR/lFhTFhTYzdvzrcZ+HwI1t/Y+qkc84IwubJaf7FJWlYAXpjRqgmU/cp/F
m2zmtAqH8OXcxJ9sbBLAMTZVVKTuCBONU494UpXRfZeRniBvRFGRw3I5Yb0ZPNdSEWY03KXZk689
cYzv6/lgkTB0dWbzTcF+GIQleoHCsA84/Qx2oqLdNDjI3Um4HzbVjl4zczFPR5ZmE6dpU6/0vRjl
KFPrbo/ndHFSsTmuEBukRDeIiB/Yt0FCWF3zbIpnow7vOr+j2W3cuDCvMFghsUIDrIhXCWQJ9EeP
LFLb1ItTjZVRZmpb1hZf4yBFfoJvxBy+lfrNrTOTozAPiJU9G1uRY6QWWn2zIoGtpKCLnwPQkCK9
IAzuTN7KRHkpweINTIbIyIprJlLM62cWaCwVpOvJDCFRvensQ9lFwJ34c+ncBjodOb/t96gN8Fpw
GZrfTQrYO7DsnLUCjzuW8bS8+MVujTvlj2OcOG8EUA/kaXEannUB/LmK5ndPMX0NtyDz8K9kONZH
a5FoDfurfFYaJ6agExOe2VjVEM6+2KKo7+kaNKvYIAecbm2jy+0UweuoqYXLxiEAAAAAAAA=


--=-hA914rn3EHlaahFdTxVS--

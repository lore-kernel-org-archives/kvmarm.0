Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A773E00BD;
	Tue, 19 May 2026 10:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779187297; cv=none; b=hwVp1TFkb54OzN0WTYWvstgEEj3WOJ8IxKaNlgVEpH0LE/UVEtpwu1L+arGL3IdqB678gLjpEAICT1A2w0BO2h+/fTykx5br6//ovXXyTpoBOZC6/WI9S/8k0yg2oGvF/B4i+ns8UwJk55yHrOBOd6g7IH7dlVLjqCt77dv6a+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779187297; c=relaxed/simple;
	bh=FTeLEJ+DBjyBA74en4sSbr/tA7gdfdq14UWkB81djkA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=acNsOLWA1minQNcsAV1XoU5yfX56pGCo31/ZMH9Ma/0+BB1DB756bHeXBIa5m6Xd43jyEz293YOuTh1LgOzZxbpMMbMemNaRHgdHF1KApaF6fKJlJeXBKDHHqZeAv6wQWCi6xOYm97QHNSWZdlvAsY+5Z0zKRjIcqc+srVY4T/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PjJdwhZC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PjJdwhZC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XgxjqnbsnE/azX8wgjK7JsLcG4H3KJRSlNZg2/kJsN8=; b=PjJdwhZCfZG6UrLoRGBgMsTBw0
	uq0mxv++Qo1dzXWmuKdTMUpeVzJ0S3h4uxKoupYzO5IxliblCeUagVi8z+BXZP3Vrfar8mGCMoaAw
	N8NX8ESrjS5WRFgcHQo21xmraC/a/3wphPpdN2Juu9cIkGlR66ekTiZb1aT37tT0wmNgjbaymO8jS
	POtFTC5Olln8ohdlRsNGnFIXQOE02KkskUDmtDLJP69jWEGYXP9pUhQMirVfFfiPah/nO5ot366OD
	oKVkmxp/5+2t8ChU4MrYbmBoZbhaySF88QSOS9i/rGBlkDIugz59rTdmjCk8CW4T6ySndJj4kjlz2
	hCUKmOPw==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPHtA-00000005oCo-2Vn3;
	Tue, 19 May 2026 10:41:28 +0000
Message-ID: <3f9d731c3d26b0367600f1069e6425099bc34eac.camel@infradead.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible
 compatibility expectations
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, kvm <kvm@vger.kernel.org>, Linux Doc
 Mailing List <linux-doc@vger.kernel.org>, "Kernel Mailing List, Linux"
 <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@kernel.org>, Joey
 Gouly <joey.gouly@arm.com>,  Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Raghavendra Rao
 Ananta <rananta@google.com>, Eric Auger <eric.auger@redhat.com>, Kees Cook
 <kees@kernel.org>,  Arnd Bergmann <arnd@arndb.de>, Nathan Chancellor
 <nathan@kernel.org>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.linux.dev,
 linux-kselftest <linux-kselftest@vger.kernel.org>
Date: Tue, 19 May 2026 11:41:26 +0100
In-Reply-To: <CABgObfaM-JtNn2MuYXaiadQnLfAhTEaoHAcTG9=J6LkMcQCJ3A@mail.gmail.com>
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
	 <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com>
	 <57bc082f4824d6114d3156744c25986effc29aca.camel@infradead.org>
	 <baff82ca-6321-4b16-aa61-b2d6d60b6535@redhat.com>
	 <86h5obya2r.wl-maz@kernel.org>
	 <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
	 <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com>
	 <d9d4471a7f5ec1e297b3ca07f42a59090aa91e15.camel@infradead.org>
	 <CABgObfaM-JtNn2MuYXaiadQnLfAhTEaoHAcTG9=J6LkMcQCJ3A@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-GXcp10WwKY3OAbs7DkMA"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-GXcp10WwKY3OAbs7DkMA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-05-13 at 18:24 +0200, Paolo Bonzini wrote:
>=20
> > See commit https://git.kernel.org/torvalds/c/49a1a2c70a7f=C2=A0which ad=
ds a
> > new guest-visible feature in revision 3, but allowed userspace to
> > restore the old behaviour by setting it to revision 2. All my patch
> >  above does, is make it possible to set it to revision 1 as
> > well. Because https://git.kernel.org/torvalds/c/d53c2c29ae0d=C2=A0previ=
ously
> > changed the behaviour and bumped the default to 2 *without* allowing
> > userspace to restore the prior behaviour, and we've been carrying a
> > *revert* of that patch.
> >=20
> > Why would we *not* accept such a patch?
>=20
> Agreed. Even ignoring your revert, there's no reason why any upgrade
> past 49a1a2c70a7f has to be from after d53c2c29ae0d.

So where do we go from here?

I assume you'll be taking this Documentation patch via the KVM tree?

But what about the actual fix at=20
https://lore.kernel.org/all/20260511113558.3325004-2-dwmw2@infradead.org/

This is a simple and unintrusive bug fix to make KVM/arm64 follow the
"common sense" requirement that the doc patch codifies, apparently
being rejected with the rather bizarre claim that KVM has no *need* to
maintain guest-visible compatibility across host kernel changes.

So... what next? Is one of the other KVM/arm64 maintainers going to
speak up? Paolo would you consider taking the fixes through your tree
directly?=20

Does Arm not actually *care* whether AArch64 is considered a stable and
mature platform for KVM hosting?

We don't have CONFIG_EXPERIMENTAL any more, do we? Or perhaps we could
mark it such. Is CONFIG_STAGING the right thing, for unstable things
which might violate the normal maturity expectations of the kernel?





--=-GXcp10WwKY3OAbs7DkMA
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxOTEwNDEy
NlowLwYJKoZIhvcNAQkEMSIEIGbFfQHqDf+7YiSuRxfIp28oRtj+P7K6ZE/9H/b+8riVMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAlQ2GQdnYT11v
T+/G9m+2GwlZWRpfE0iBFktgC0TqYxMu42AWZsy1Nr4U8oWRj8MIJKwG7D2UxeppRQa6e9R794fp
IEViCII+Po7Vhc6Xlo5PYKCMsi0fzqAKVGzogFHYDGaPNlxFsftN0gCD3dHwlRyN5V/z6SzuYriI
sHxHC6J6KhR66kx4za/tfWhmT6bhHdzrexAOunrPQzaRCLTObBh5uGT0Kcteqij9lvdmLJeqNq6Y
LkvAe38B1KuhRh74skzYTOqA6Ub3Zkzpf8KK/gvH+Oay3SMf4kcKTFLR1xZVDdXw+2bkh2CUZjnS
8ev/vAAkrpG3dp0lvdiW7+sSo7Pnt2dlNm8c/4ULSKKSlvQQF5CJsPCnPbxQVw2ezF00SqnylM30
vGfoHo85WmuMEhCcSksfJIWRH903UnaiGqmV1HQk+8rw2euONFk4Br/gM/JbMnAAH6+Bpo0HUlAi
WjHKWWKITFV41VWK+TFgEeuIKNZl2U0Nz53EK0zzKcAHWExbhL+Ggl2HtzpC5ODtT9N5okqL+b4X
7KVKcTRFpSGv/FlxnkmYEzASE6viimVHEDrKTpzIq6pArhtLSmOjm9Pq5zFXv5+l543OJ3TY9T/q
La8gAi1O4Xi/vNInUH0IraCOG7DQnChnkCJ5TQP105J6lwRLq/1LYXObu4CEMHMAAAAAAAA=


--=-GXcp10WwKY3OAbs7DkMA--

Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C4C233947;
	Tue, 19 May 2026 11:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191086; cv=none; b=uuyFzlx3QrJ3FM6hNnx4idlUov1g0Sz9c1/YVW8cZbyO3cD+WosUI3Xid+BpABLCwPjt1Vxgj9HzC0GKv47Cqsxlfz6A9QmHKFNNA1okVmAo8ytwgH2UpNRVEPVuBTaNBAPF95cH0/ynD7/w/mWmZ116/Bb5ocvLDMGsZTFlIw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191086; c=relaxed/simple;
	bh=Yu4thT1PicZEOD5m8O0d2eX0CmCh2+UBkP7CuZidmCw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bmx1R2C+vbcHAVQTCRSD4pr8AaP5RBgmub/Vy5a9cA8Rbe+ITejWsWoUyRmTpL3ikW5qWO1TBqorGFP8XLvp6y2kyRjPfRE+pO1ASnojwMy5IT9oCykPd8uBJBorSJNqA6lSf+dKj6U4wwiK4oKWgDxqulDZXTNuZ39Vgq1KllI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U0JTkMcR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U0JTkMcR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Yu4thT1PicZEOD5m8O0d2eX0CmCh2+UBkP7CuZidmCw=; b=U0JTkMcR0ysrTHCl2LGow0SOZm
	UsFkiyHRWIWgCdRzeABcX/FDMzb38IP5O8q+4k5QOHR16MQY4bDrBUbeNfHYD8fO3Rs0M1V/1Kz2C
	v3SflH0lfmj0TeRo02VRlOW66I2O5xqSp/QlfyONoNZlInOAVX/KagiredTUcS23C4qqAaYVw3sNf
	168CJM+BBG/qn7Yj1VgG+vn2kqbnwPV0ZleGof8Nos9EcE0TfXoHFnSt0v8bGm6tfQ3SD+Nc7DqWy
	A3mVHoFvy8py2qnvJb1F4p0YR/Eoe/if+93eZGP0BahdtcZ1R9LjsY0V1Dh0pxzWmVFb59LePwSa2
	0f0HMoKw==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPIsD-00000005reu-2Pp1;
	Tue, 19 May 2026 11:44:33 +0000
Message-ID: <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible
 compatibility expectations
From: David Woodhouse <dwmw2@infradead.org>
To: Will Deacon <will@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 kvm <kvm@vger.kernel.org>, Linux Doc Mailing List
 <linux-doc@vger.kernel.org>,  "Kernel Mailing List, Linux"
 <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@kernel.org>, Joey
 Gouly <joey.gouly@arm.com>,  Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Eric Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>,  Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
 kvmarm@lists.linux.dev, linux-kselftest <linux-kselftest@vger.kernel.org>
Date: Tue, 19 May 2026 12:44:32 +0100
In-Reply-To: <agxFbniU_6eQ98t2@willie-the-truck>
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
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-eJhS63SIL30DfqRjCqNY"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-eJhS63SIL30DfqRjCqNY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-05-19 at 12:11 +0100, Will Deacon wrote:
> On Tue, May 19, 2026 at 11:41:26AM +0100, David Woodhouse wrote:
> > On Wed, 2026-05-13 at 18:24 +0200, Paolo Bonzini wrote:
> > >=20
> > > > See commit https://git.kernel.org/torvalds/c/49a1a2c70a7f=C2=A0whic=
h adds a
> > > > new guest-visible feature in revision 3, but allowed userspace to
> > > > restore the old behaviour by setting it to revision 2. All my patch
> > > > =C2=A0above does, is make it possible to set it to revision 1 as
> > > > well. Because https://git.kernel.org/torvalds/c/d53c2c29ae0d=C2=A0p=
reviously
> > > > changed the behaviour and bumped the default to 2 *without* allowin=
g
> > > > userspace to restore the prior behaviour, and we've been carrying a
> > > > *revert* of that patch.
> > > >=20
> > > > Why would we *not* accept such a patch?
> > >=20
> > > Agreed. Even ignoring your revert, there's no reason why any upgrade
> > > past 49a1a2c70a7f has to be from after d53c2c29ae0d.
> >=20
> > So where do we go from here?
> >=20
> > I assume you'll be taking this Documentation patch via the KVM tree?
> >=20
> > But what about the actual fix at=20
> > https://lore.kernel.org/all/20260511113558.3325004-2-dwmw2@infradead.or=
g/
> >=20
> > This is a simple and unintrusive bug fix to make KVM/arm64 follow the
> > "common sense" requirement that the doc patch codifies, apparently
> > being rejected with the rather bizarre claim that KVM has no *need* to
> > maintain guest-visible compatibility across host kernel changes.
> >=20
> > So... what next? Is one of the other KVM/arm64 maintainers going to
> > speak up? Paolo would you consider taking the fixes through your tree
> > directly?=20
> >=20
> > Does Arm not actually *care* whether AArch64 is considered a stable and
> > mature platform for KVM hosting?
>=20
> Hey, come on. Marc cares more about this stuff than anybody else on the
> planet. He's been single-handedly maintaining the tree for the past
> couple of releases while Oliver was out and he's on the end of a _lot_
> of patches. I'm only cc'd on a fraction of the KVM/arm64 changes and
> it's bedlam.

I certainly wouldn't disagree with any of that. The depth of knowledge
and the amount of energy that Marc displays through this work is
impressive, and I'm sure we all have an enormous amount of respect for
it, and for him. I know I do.

Nevertheless, the specific technical decision to reject the simple bug
fix linked above is dead wrong.

Because the principle under which it was rejected =E2=80=94 the idea that K=
VM
has no responsibility to maintain compatibility of guest-visible
behaviour from one kernel version to the next =E2=80=94 is also dead wrong.

If KVM on arm64 doesn't aspire to maintain guest compatibility across
host kernel changes =E2=80=94 regardless of whether the previous kernel's
behaviour was "blessed" by the architecture specification or not =E2=80=94 =
then
it does not meet the expectation that we have of KVM implementations in
the Linux kernel.

Or indeed the standards that we've held for Linux kernel ABIs for the
last 35 years.

--=-eJhS63SIL30DfqRjCqNY
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxOTExNDQz
MlowLwYJKoZIhvcNAQkEMSIEIAGQ01CMqEM882kkXzxqQFNyWyjXqqoyNMZCGUsasrrCMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAOOVpYs6zY+A1
qyUGQERi0tBlHOJyhOJ1Pbncx5RcQR4cdh1hdoa+aF0W5lRCQQgAm2Ino/l2V9FSCc89DglfW0DN
YMNn1HtPeV90KXjaE1wPMlV7L7Qbxicvwo1RRHFI/BXj0X1L1tZSBPraesSrvV8EyN1XJ8PGWoRs
khj9PaeR4CSt10SmCMYPVY3PWT5D4NAETh6vXGkwUyM9A5NAFHNX7V0YVZzqZpWj3ebsjU0HULih
NelmDd3xLkFmrAw4CtGjLYigF2qAm78DYnq2KS4RM8WnHzR9Mkkdi3r1dGELNjM6R0r0xYpWF6hb
rCkNDVH/Qvp6vHciZrpfl85KdzTm5SDdiLhIWa3ZaZ9Izj1bhGtK8QUuq1NHzijF4LBHz67nEwJZ
N9L5RG+ZTwRAfmbai0NoL7mlqctua9LVteoqM0uZqExUTSyWDum28oO5+1qRSUreZxVomrVWs7os
vjCRjhNXcledZsfarpxyjZ8wBbNpP1I1v6Rv4ud051q+h3V4zXYWugiJLGfMchYjLPwsBPhV/eu6
CwLvUpoOGCPWU6WSNUw5lbe4PqxrOSkyFnhxkKv8LRATQyzlQcgYd8nPPMx17efzXmZLC6Tgd+bp
bt/NZrTZTknc8HguMfQw/ynOr2evOpjRgunxKxu5fFSEpZ1xohtqOLqjUTqHBbcAAAAAAAA=


--=-eJhS63SIL30DfqRjCqNY--

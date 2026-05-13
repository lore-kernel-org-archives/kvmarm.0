Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE272BD01B;
	Wed, 13 May 2026 09:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778664272; cv=none; b=axQ8gicZEfuUxKnuDpJ59lIjPljK7gYQyUHz0az9Eqym3WNUjJjR16L8JL61ToihkvAdvOdqj+HtKEM869iam/59DoT3uciAdEFprp+eGG0wcAO02zL6Z0KrYiBu39ziInEqz0xFUARBHQm7C+ULkCfkVZJYJcJXaKM3N+2TH84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778664272; c=relaxed/simple;
	bh=gxFlYdGnyDdeiZ+pt7cxAH/hIYWR8MtIGFvh3GLEONo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KPjC9MxYRyvjVbkp2vnpGHZxx2OVPLNTPfJ1VJfd3UYFBRpF9/zB5xOONvQu3z6FarvTu7RjWymmzsA8JJJgBJuExaQJXN2lF5i12dNGR/NlaCIbuSBCMA78y4jzZswV7L8hvcyIh8lL86i1v5JJthSn7t3GMnnZh0kIY2ogmLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mNufZOlL; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mNufZOlL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gxFlYdGnyDdeiZ+pt7cxAH/hIYWR8MtIGFvh3GLEONo=; b=mNufZOlL434k08nHpzcQbaJs/3
	J6nggb196ldaCjj/Gis8TPyzh9lM/lB10/YORxoSC3qeBvxo13I1Oxp9wcExidEtaZmruGkgRd+VD
	2EjdQvKqzS+MbOLwtCzroLtw2xAWB2OYQTK9dg1GyKrdI47bRLFnhVHJ8tEYJt1kobPNpEp8HZtvs
	/tIS9u3Ikqi/U5cjjLcYqXxL7sRdSIw1TkLp4kL6ioZOwPPYLfmeYpfLMV05emPNfXs/HaLv2KevT
	ghxxaik6qL6sBK3G8YcrEixujLFAJ03kLtJ3puzKc7duvwXEY24m517117JoHxjE0nYFEJWZr8hnN
	dGxS8rfg==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN5pD-0000000BOTz-1Fdw;
	Wed, 13 May 2026 09:24:19 +0000
Message-ID: <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible
 compatibility expectations
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,  Sean
 Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>,
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>, Eric Auger
 <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>,  Arnd Bergmann
 <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
Date: Wed, 13 May 2026 10:24:19 +0100
In-Reply-To: <86h5obya2r.wl-maz@kernel.org>
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
	 <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com>
	 <57bc082f4824d6114d3156744c25986effc29aca.camel@infradead.org>
	 <baff82ca-6321-4b16-aa61-b2d6d60b6535@redhat.com>
	 <86h5obya2r.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-h/BrL4MwuVDnU5E/d7hR"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-h/BrL4MwuVDnU5E/d7hR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-05-13 at 09:42 +0100, Marc Zyngier wrote:
> On Mon, 11 May 2026 17:56:15 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> >=20
> > On 5/11/26 18:38, David Woodhouse wrote:
> > > Not *everything* is in CPUID; one recent exception that comes to mind
> > > is the SUPPRESS_EOI_BROADCAST quirk. But on x86 we preserve the
> > > existing behaviour of older kernels =E2=80=94 even when that behaviou=
r doesn't
> > > make much sense, as with SUPPRESS_EOI_BROADCAST where older KVM would
> > > *advertise* the feature, but not actually *implement* it. Nevertheles=
s,
> > > that remains the default behaviour of future kernels unless userspace
> > > explicitly opts in to fully enable (or disable) the feature.
> > >=20
> > > But this documentation update isn't even asking for that compatible-b=
y-
> > > default behaviour, even though that is the right thing to do. It's on=
ly
> > > asking that it be *possible* to reinstate the old behaviour, for
> > > userspace that *knows* about the change and explicitly wants to go ba=
ck
> > > to the old way to remain compatible.
> >=20
> > Yep, these are the "quirks"---if it's too early for Arm to commit to
> > that, I guess it's fine.
>=20
> Compatible by default means nothing, because userspace needs to
> discover the combined capabilities of the host and KVM. This is not a
> "CPU model" architecture.
>=20
> If userspace is not a total joke, it will read all the ID registers,
> and configure what it wants to see, assuming it is a feature that can
> be configured (not everything can, because the architecture itself is
> not fully backward compatible).
>=20
> Yes, this is buggy at times, because the combinatorial explosion of
> CPU capabilities and supported features makes it pretty hard to test
> (and really nobody actually does). But overall, it works, and QEMU is
> growing an infrastructure to manage it in a "user friendly" way.

Yes, that is precisely what I'm asking for. I'm prepared to deal with
the fact that KVM/Arm64 is not a stable and mature platform like x86
is, and that userspace has to find all the random changes from one
version to the next, and explicitly pin things down to be compatible.

All I'm asking for is that KVM makes it *possible* to pin things down
to the behaviour of previously released Linux/KVM kernels.

> But really, this isn't what David is asking. He's demanding "bug for
> bug" compatibility. For that, we have two possible cases:

No, I am not asking you to meet that bar. I merely observed that x86
does and that it would be nice. But we are a *long* way from that.

> - this is a behaviour that, while undesirable, is allowed by the
> =C2=A0 architecture: fine, we preserve the behaviour and add another way =
to
> =C2=A0 expose the one we really want. it is ugly, but we manage.
>=20
> - this is a behaviour that is not allowed by the architecture: we fix
> =C2=A0 it for good. We do that on every release. Some minor, some much mo=
re
> =C2=A0 visible. And there is no way we will add this sort of "bring the
> =C2=A0 bugs back" type of behaviours. Specially when it is really obvious
> =C2=A0 that no SW can make any reasonable use of the defect. We allow
> =C2=A0 userspace to keep behaving as before, but the guest will not see a
> =C2=A0 non-compliant behaviour.
>=20
> That being said, there is a way out of that: convince people in charge
> of the architecture that the non-compliant KVM behaviour is actually
> valuable, and deserves to be tolerated. This has happened before (VHE
> only and NV2 only, just to name two recent changes).
>=20
> Other terrible hacks (such as GICv3's GICD_TYPER.num_LPIs which KVM
> doesn't support) were added at the request of cloud vendors that David
> might be familiar with, so it isn't like it is a brand new process.
>=20
> And once it is in the architecture, it becomes a behaviour that is
> allowed to be exposed to a guest, for better or worse.

Marc, this is complete nonsense and you should know better.

Once a behaviour is present in a released version of Linux/KVM, we
can't just declare it "wrong" and unilaterally impose a change in
guest-visible behaviour on *running* guests as a side-effect of a
kernel upgrade.

The criterion for *KVM* to remain compatible is "once it has been in a
released version of the kernel". Not "once it is in the architecture".

> These are the rules we have followed since we started KVM/arm, and I
> intend to stick to them.

Then KVM/arm is falling far short of the standards we expect of KVM and
of Linux in general.

Please do better.



--=-h/BrL4MwuVDnU5E/d7hR
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxMzA5MjQx
OVowLwYJKoZIhvcNAQkEMSIEIMYNExREPTxgjNQkLMNCyI3BC37RY5FnbppSTlndvTYLMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAxALZ7Z/O0OoT
NMfeB1RUO8uNWzbEqzwEaU1ZsHvOZ2mGD7S45p9j3PzzPLrx/a3yfxSAN+0obk4M69Qj3VXsrBOG
u+wLh+fJKPCtyOH9OwGl6mhdqSDjegKmvhshceCgsunFqOxdFa41GPaEcO0e2cZYs7sVwUYv9r8a
Q0xtjzgTUeWo86gockDFDFMpe3fxDtIrfih05noDJlrdt63DjwJ9SGL9x+reaxv5KNZY93xmO2qX
WuoNqdQufV03ONRu9eUv9joSADTkU3+S7iUnfr/xhrWEA9FLyNFgnkosj/ykvbjW6OaRCtwFwQ8A
yKgFDda6c18Fnu9vVvQSgNnJC44SU2rurly1hFaYDw4JBPYpF3A4zXEYONWZtL97y1keFg0wDarP
rRVFHyr0K627ApHUbJh+QQuseIqUFtIuyJz7eu/gxMwIFDF1lEt8K6wtoxbNYLtBRDxXbnVXSWh1
M6SMAlOpyoO2XU96cUCRuVqfc2ai2T4ZpmWIOLxN7C9hT45SqRFn2zr+HGo2spYW4nbgZunbztve
C0DV5G5nmok5EZ6gATCYGrJPV+qi0qlBl9NO6tSM0fmRBuldTToLyFP7ReXqvJFY8gojSHMkkSmP
f7merLz2mKzm7Ng1yrlxD7ZAy2iqElFND9g03thhtMikUPTL0QGyzhnu5hlrdKAAAAAAAAA=


--=-h/BrL4MwuVDnU5E/d7hR--

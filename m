Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320DA2D876B;
	Wed, 13 May 2026 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680662; cv=none; b=SqUq+VBLLglCjD8FlJV5jMcsqU/5HnXYv+ye+bWths9g1L244PC8bGFuz0LGP1dXMwi9t3X2v0vsYQ+N3hfWRIaKS2AazkXSaU2cytXp6E1qRRJOXwVE73aZ9xeMU6CMkzeQmeB0pvQlQ4eQggmRFB9yQ6zpnB/gr2kZb0C1irc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680662; c=relaxed/simple;
	bh=WrrzkkXmW9/JJRydVb+33JBT+lGsMTBln8KmVYL1kl4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rJ4u7QYn2JsikhEHUVsjEmXC1S7pM5JF6vJiKt6dxlr3tYz+lpKGkXZtNg4l6iwfDtmHwZZDoxT8bhd83kCUI+HAtvMiJz03xLTyN7gGc6bVh92mrLUEgTwM+Tl72YINlCn7X5s56JSrh43UKC49oUdDbQY8/vfqpEgM62c0yjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HzrzncgN; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HzrzncgN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WrrzkkXmW9/JJRydVb+33JBT+lGsMTBln8KmVYL1kl4=; b=HzrzncgNHHm/ieuIGK+wbTgPUM
	yh0DSk+0Y4PZxYzyiHOOY9gsKY7yso/+anRmqKPXHyQMLFsQuXCZ26wJsuTD6b6Set6H3K3onLH6P
	uLldoeE2awVpEgl6uZLoyQ9upWoTlmoG9osnARTCgLik95swdPMpp13RCLUB/4KaxXG6aOGlCUlu7
	hZbHyKLLM8wpZif6WVTz9sma2xuFbKVGsSUFm+5O4dbdZAdN/PbDuwGZE99a2wWNaTTHSvo/mofvz
	JzhEopOE0uJo00/dGNbguGYsuiGu6r0N8vgLXHMLbydDbK3kmzm0Vv2HGq2fZ8V0BX4ZJlatdMNgG
	A0sl1lAQ==;
Received: from 54-240-197-236.amazon.com ([54.240.197.236] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNA5Y-0000000BhcF-2lZN;
	Wed, 13 May 2026 13:57:28 +0000
Message-ID: <d9d4471a7f5ec1e297b3ca07f42a59090aa91e15.camel@infradead.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible
 compatibility expectations
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
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
Date: Wed, 13 May 2026 14:57:27 +0100
In-Reply-To: <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com>
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
	 <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com>
	 <57bc082f4824d6114d3156744c25986effc29aca.camel@infradead.org>
	 <baff82ca-6321-4b16-aa61-b2d6d60b6535@redhat.com>
	 <86h5obya2r.wl-maz@kernel.org>
	 <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
	 <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-e5BhHGK/BH1nijaPhsdl"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-e5BhHGK/BH1nijaPhsdl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-05-13 at 14:43 +0200, Paolo Bonzini wrote:
> On 5/13/26 11:24, David Woodhouse wrote:
> > On Wed, 2026-05-13 at 09:42 +0100, Marc Zyngier wrote:
> > > If userspace is not a total joke, it will read all the ID registers,
> > > and configure what it wants to see, assuming it is a feature that can
> > > be configured (not everything can, because the architecture itself is
> > > not fully backward compatible).
> > >=20
> > > Yes, this is buggy at times, because the combinatorial explosion of
> > > CPU capabilities and supported features makes it pretty hard to test
> > > (and really nobody actually does). But overall, it works, and QEMU is
> > > growing an infrastructure to manage it in a "user friendly" way.
> >=20
> > Yes, that is precisely what I'm asking for. I'm prepared to deal with
> > the fact that KVM/Arm64 is not a stable and mature platform like x86
> > is, and that userspace has to find all the random changes from one
> > version to the next, and explicitly pin things down to be compatible.
> >=20
> > All I'm asking for is that KVM makes it *possible* to pin things down
> > to the behaviour of previously released Linux/KVM kernels.
> >=20
> > > But really, this isn't what David is asking. He's demanding "bug for
> > > bug" compatibility. For that, we have two possible cases:
> >=20
> > No, I am not asking you to meet that bar. I merely observed that x86
> > does and that it would be nice. But we are a *long* way from that.
>=20
> x86 doesn't do bug-for-bug compatibility, thankfully - we have quirks
> but only 11 of them, or about one per year since we started adding them.=
=20
> =C2=A0 We only add quirks, generally speaking, when 1) we change the way =
file=20
> descriptors are initialized, 2) guests in the wild were relying on it,=
=20
> or 3) it prevends restoring state saved from an old kernel.=C2=A0 Is ther=
e
> anything else?
>=20
> So you're asking something not really far from this:
>=20
> > > - this is a behaviour that is not allowed by the architecture: we fix
> > > =C2=A0=C2=A0 it for good. We do that on every release. Some minor, so=
me much more
> > > =C2=A0=C2=A0 visible. And there is no way we will add this sort of "b=
ring the
> > > =C2=A0=C2=A0 bugs back" type of behaviours. Specially when it is real=
ly obvious
> > > =C2=A0=C2=A0 that no SW can make any reasonable use of the defect. We=
 allow
> > > =C2=A0=C2=A0 userspace to keep behaving as before, but the guest will=
 not see a
> > > =C2=A0=C2=A0 non-compliant behaviour.
>=20
> ... where for example=20
> https://lore.kernel.org/kvm/e03f092dfbb7d391a6bf2797ba01e122ba080bcd.came=
l@infradead.org/=C2=A0
> is an example of a bug that "no SW can make any reasonable use of".

I actually believe that the focus on ICEBP was triggered by some weird
gaming software's anti-DRM mechanism, and that it *did* affect actual
guests in the wild?

But yeah, *fixing* it should not have any adverse effects. That's the
key.

> > Marc, this is complete nonsense and you should know better.
> > Once a behaviour is present in a released version of Linux/KVM, we
> > can't just declare it "wrong" and unilaterally impose a change in
> > guest-visible behaviour on *running* guests as a side-effect of a
> > kernel upgrade.
> >=20
> > The criterion for *KVM* to remain compatible is "once it has been in a
> > released version of the kernel". Not "once it is in the architecture".
>=20
> That is *also* obviously nonsense though, isn't it (see example above)?=
=20
> The truth is in the middle, "once it is in the architecture" is likely=
=20
> too narrow but "once it is in a Linux release" is way too broad.

How about "once it is in a Linux release and guest visible, and unless
we *know* that changing it in either direction underneath running
guests cannot cause problems".

> And besides, both miss the point of *configurability* which is the basis =
of=20
> it all.

Hm, configurability *is* the point, I thought. I'm not asking for the
*default* to remain compatible. I only ask that a VMM *can* ask KVM for
guest-visible things to remain the same as before.

> The main difference between x86 and Arm is the default state at=20
> creation; x86 defaults to a blank slate, mostly; and when we didn't do=
=20
> that, we regretted it later (cue the STUFF_FEATURE_MSRS quirk).=C2=A0 It'=
s
> too late to change the behavior for Arm, but I think we can agree that=
=20
> patches such as=20
> https://lore.kernel.org/kvm/20260511113558.3325004-2-dwmw2@infradead.org/=
=C2=A0
> ("KVM: arm64: vgic: Allow userspace to set IIDR revision 1") are what
> the letter and spirit of this proposal is about.

Yes. That *exact* patch.

> Marc did not mention having to deal with guests in the wild.=C2=A0 Let's=
=20
> ignore it for now because even defining "guests in the wild" is hard;
> and anyway it's not related to the patch that triggered the discussion.
>
> So we have the third case, "restoring state saved from an old kernel".=
=20
> If this case arises, I do believe that Arm will have to deal with it and=
=20
> introduce quirks or KVM_GET/SET_REG hacks.=C2=A0 Maybe it hasn't happened=
=20
> yet, lucky you.

We literally have those mechanisms already. That's exactly what the
revision field in the IIDR is used for:=20
https://developer.arm.com/documentation/111107/2026-03/External-Registers/G=
ICD-IIDR--Distributor-Implementer-Identification-Register

See commit https://git.kernel.org/torvalds/c/49a1a2c70a7f which adds a
new guest-visible feature in revision 3, but allowed userspace to
restore the old behaviour by setting it to revision 2. (Or at least
intended to; there was a separate bug which stopped it working, which I
already fixed last week.)

All my patch above does, is make it possible to set it to revision 1 as
well. Because https://git.kernel.org/torvalds/c/d53c2c29ae0d previously
changed the behaviour and bumped the default to 2 *without* allowing
userspace to restore the prior behaviour, and we've been carrying a
*revert* of that patch.

So the patch we're arguing about is just making that earlier guest-
visible change optional in precisely the way that is already designed
into KVM, and has been used for the subsequent change.

Why would we *not* accept such a patch?=20

It's not like I'm trying to upstream something like
https://david.woodhou.se/0001-Allow-writes-via-newly-readonly-PTE-for-buggy=
-Ubuntu.patch
... but yes, those *are* the lengths we have to go to sometimes to
ensure that when we upgrade the hosting environment, guests which have
worked for years don't suddenly break =E2=80=94 however much they DESERVE t=
o :)

> Overall, even if we may disagree about the details, are we really on=20
> terribly distant grounds, or are we not?

I genuinely have no idea.

On one hand, no we are not terribly distant. All the mechanisms to do
this properly already *exist*, and the fix I'm asking for is not much
more than a one-liner to fix up the previous oversight.

But on the other hand, Marc seems terribly insistent that we SHOULD NOT
restore the behaviour that older KVM offered to guests, and we MUST
change it unconditionally underneath running guests, making these
registers writable on upgrade... and reverting them to read-only for
running guests on a rollback.

And there we do have a very different viewpoint.

--=-e5BhHGK/BH1nijaPhsdl
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxMzEzNTcy
N1owLwYJKoZIhvcNAQkEMSIEIBBzsSkwkcPImtD9zV5nHr4vO8a7uWMde8glwTgdTTzjMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIABzA9vzghovLM
BqMCQY/loB5c3q4o1wAMAnac7vbeEjyW3hpZeVnDoH6hpRXk2KmelIsI7Be5uxT7g2pziIyraxNM
uIpXZwZo/LhuA2eXKnTxVVIKe1e1hNAW1r684m9PlnN9ipZqnadh7TBTRREvAkl82Q4VspyZQnob
KStPjQdagp6nXr3RyRWW5C24l2oA2dTWRVCqToJAWpajwtRILPD+wZcHcN/CqTKnq946mnNApoDa
Kc7e0rRoBc2j3AShToHBOsStH4g0fwFVSPJs+BQPb6jeNFXBcJSOpfUYJewUb1ILu2bQXqe+frZ/
KqCJ6IwBQJkJR5GWBm9DRllefk9PP+Ax35vC5VYVxp9cXB93V6NdXyz+b4ifiMVaDlt02c0Vfvl7
c0O6s04lARgu38Ukub0HxH0o9ZXMUKD18TjTv8hoZx2w6WxsYmtKAYg2lC6Y2FFzB2C5DFNSb4gS
Y7n4DkxTJAchM9/1NJCvtNpQanSc7SJ3o5m7tcjCsYzZbm+nI02hghlcDW8uku5grZ8N64+oYX12
S0+7yhQxDRgwXmV+jlvZjyGtWEYwZPwTvP3kLkop9zdJgrieHXG8bVfT6UJ0mIJq2/SnTnBUKeMQ
KgFAMEokJDgTRpjfbyl5MMOPr0yE1ODWin5s+RAU99r1TE9wzwgwSKAV/8ysfYAAAAAAAAA=


--=-e5BhHGK/BH1nijaPhsdl--

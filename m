Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AE81B652E;
	Wed, 13 May 2026 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778696817; cv=none; b=L/XtstQyQc9cdxCAiOIi2JF/e67JGTm974HZXhoqTKQ1zhMzJosURH7zBgC3h+a07eu3PGTl4NMZub4VsAaBpu/2+aFXf7Wt52caXl0pZ3sKUvWBTucG9UzTujI2GJTXnCIm4EdLt6S97fqhkrYLzTW5dOmRYXk9icopQ+5fJ4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778696817; c=relaxed/simple;
	bh=clnJtWJasHFx+KKfjBIgMipxjlx72ONnIo8zI8FF8rw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=npaEER2hsJec3q1ZmXePc1SzGWMVTftH7RnL+qlvKyO7Z5iDNZKXT/3kTRaUm/G3s5f5zt89fnLobyhN400b9L0wcWoJNVqI+iBrtkEclBbCD0kJDrlAlzgqhan8xJ2HLhkfXtuuMSylF9bEzwUrPtio0k8PeHgJVJxZfhiL5hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JiB/Vb/w; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JiB/Vb/w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=clnJtWJasHFx+KKfjBIgMipxjlx72ONnIo8zI8FF8rw=; b=JiB/Vb/wPfgkIt93JXwHaLoY2W
	A8TyP3PgDmKlQw8/YaN/ChxRpbSwn6mJtIMhnpGBkEj11d/GJjXE8nOnSHJ+m+06cHZnpnY2KHx+U
	FBTsVQBuz1aUPYdzRkjnkRHb3HM37m7LBVDScJTz2H6Gx7PajOrsT6bkB06ztwQWypDmvZpNR+gC2
	B8yIgWej63/qpTmmLjcicXW7Q7ad5ITV04LuqSNEzm6E2eWgfExCbeFo856KNVq1suRhexTGs/Hjl
	MHDFR61K2htwqGKAWfiOdz5kEOe/i7PTuKk8mAi4xjNLTEgsiFUcPTH1oe0Dgl2yVb4W5TAvJsNlf
	ovy3sn3w==;
Received: from 54-240-197-236.amazon.com ([54.240.197.236] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNEI8-0000000Byzv-1jWn;
	Wed, 13 May 2026 18:26:44 +0000
Message-ID: <95e411c3f238e29e29aa36331a7cc964c7393d2f.camel@infradead.org>
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
Date: Wed, 13 May 2026 19:26:42 +0100
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
	boundary="=-z2xhXgi/QSz0pyBgNgRN"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-z2xhXgi/QSz0pyBgNgRN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-05-13 at 18:24 +0200, Paolo Bonzini wrote:
> Il mer 13 mag 2026, 15:57 David Woodhouse <dwmw2@infradead.org> ha scritt=
o:
> > > x86 doesn't do bug-for-bug compatibility, thankfully - we have quirks
> > > but only 11 of them, or about one per year since we started adding th=
em.
> > > =C2=A0 We only add quirks, generally speaking, when 1) we change the =
way file
> > > descriptors are initialized, 2) guests in the wild were relying on it=
,
> > > or 3) it prevends restoring state saved from an old kernel.=C2=A0 Is =
there
> > > anything else?
> > >=20
> > > https://lore.kernel.org/kvm/e03f092dfbb7d391a6bf2797ba01e122ba080bcd.=
camel@infradead.org/
> > > is an example of a bug that "no SW can make any reasonable use of".
> >=20
> > I actually believe that the focus on ICEBP was triggered by some weird
> > gaming software's anti-DRM mechanism, and that it *did* affect actual
> > guests in the wild?
> >=20
> > But yeah, *fixing* it should not have any adverse effects. That's the
> > key.
>=20
> Yep, so "bug for bug" is not it.

Of course. I'm not discriminating between 'bugs' and 'features'. In
this context I only care about guest-visible behaviour changes,
whatever the reason.

What I said was:
> > > > Once a behaviour is present in a released version of Linux/KVM, we
> > > > can't just declare it "wrong" and unilaterally impose a change in
> > > > guest-visible behaviour on *running* guests as a side-effect of a
> > > > kernel upgrade.

And yes, you're technically right to challenge that phrasing of it. It
does need the additional caveat of "...unless we are sure that changing
it in either direction underneath running guests cannot cause
problems", as discussed. That's the key for the ICEBP thing.

> >=20
> > > And besides, both miss the point of *configurability* which is the ba=
sis of
> > > it all.
> >=20
> > Hm, configurability *is* the point, I thought.
>=20
> Yes, and configurability goes way beyond bugs/quirks, which are to
> some extent a red herring. Configurability for example says that "KVM:
> arm64: vgic: Allow userspace to set IIDR revision 1" shouldn't be
> controversial at all.

Indeed it shouldn't. And yet here we are.

> > > So we have the third case, "restoring state saved from an old kernel"=
.
> > > If this case arises, I do believe that Arm will have to deal with it =
and
> > > introduce quirks or KVM_GET/SET_REG hacks.=C2=A0 Maybe it hasn't happ=
ened
> > > yet, lucky you.
> >=20
> > We literally have those mechanisms already.
>=20
> I am not talking about guest-visible changes across save/restore here,
> but rather about round-trips through userspace. For example, see the
> effect of KVM_X2APIC_API_USE_32BIT_IDS on KVM_GET/SET_LAPIC: it
> couldn't be made the default, because userspace expects to take old
> data returned by KVM_GET_LAPIC and shove it into KVM_SET_LAPIC. Sucks
> but can't be avoided.

Yes, you're right. And I fully expect and trust x86 to get that right
and not break existing userspace in any way at all.

But honestly, the bar for Arm is so low right now that anything I
physically *can* work around in userspace, I'm prepared to tolerate.

If KVM/arm did the equivalent of just changing the KVM_[SG]ET_LAPIC
data without the KVM_X2APIC_API_USE_32BIT_IDS trick, I wouldn't even
bat an eyelid; I'd just accommodate it and move on.

> > See commit https://git.kernel.org/torvalds/c/49a1a2c70a7f=C2=A0which ad=
ds a
> > new guest-visible feature in revision 3, but allowed userspace to
> > restore the old behaviour by setting it to revision 2. All my patch abo=
ve does, is make it possible to set it to revision 1 as
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
>=20
> > Marc seems terribly insistent that we SHOULD NOT
> > restore the behaviour that older KVM offered to guests, and we MUST
> > change it unconditionally underneath running guests, making these
> > registers writable on upgrade... and reverting them to read-only for
> > running guests on a rollback.
> >=20
> > And there we do have a very different viewpoint.
>=20
> That's the design decision I mentioned, of not starting the guest
> configuration from a clean slate. I believe it complicates things
> because you have to design from the beginning with the ability to
> rollback to old versions and to potentially detect conflicts
> introduced by the rollback. This is exactly why
> KVM_X86_QUIRK_STUFF_FEATURE_MSRS was introduced: "KVM's initialization
> of feature MSRs during vCPU creation results in a failed save/restore
> of PERF_CAPABILITIES. If userspace configures the VM to _not_ have a
> PMU, because KVM initializes the vCPU's PERF_CAPABILITIES, trying to
> save/restore the non-zero value will be rejected by the destination."
> (https://lkml.org/lkml/2024/8/2/1032)

No, I don't think this is like that. In that case, IIUC it was at least
*possible* for userspace to manually filter out capabilities and adjust
things. But it kind of sucked if we *made* userspace do that and broke
things for existing userspace, so of *course* x86 did better.

I'm not even *dreaming* about a world where KVM/arm meets that bar.

> For Arm, however, it may be too late to change it; if not, I'll
> happily watch you argue with Marc about it.=C2=A0

I'm not even going to try. You're right that it's the better option,
and it most certainly *isn't* too late for Arm to choose to be a stable
and mature platform providing continuity to userspace like x86 does.

But we are *so* far from that right now; we're fighting even to have
the *possibility* for userspace to remain compatible =E2=80=94 even if
userspace *is* updated to know everything that the latest kernel
changed underneath it.

> But even without that,
> this doc patch (and the idea that "Where a new kernel introduces a
> guest-visible change, it provides a mechanism for userspace to select
> the previous behaviour") should be uncontroversial.

Indeed. And again, if you really want then you can add the caveat
discussed above, "unless you're really sure it won't make *any*
difference to the zoo of possible guests running Linux, Windows,
FreeBSD, or any number of random home-grown or network appliance
operating systems".

Although I didn't think it really needed spelling out in the doc, just
as I didn't think it needed spelling out earlier today (although you
called my sentence nonsense purely because it lacked that obvious
caveat, AFAICT).


--=-z2xhXgi/QSz0pyBgNgRN
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxMzE4MjY0
MlowLwYJKoZIhvcNAQkEMSIEIDWa/wjM+JevO2SVdN9XcsfTvGPPU6ITNWhxBJljPklPMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAbxPu8r9Vmj/o
vsJpgkdCEI+kmoZylwgpteXwA7sMtfMY47NwDvpSJCx/nGD/QMN0I8EteOZu4useWb9Ol6XJQvzJ
abEwNsMxY5MhUERwLMo9LfY0aZoB56E/rfyD0GCSttJ9p8cFeCP+9mv9VAXneb8CSH1ozpMH3sJB
fZz1uEvVXr9Oz22C3a/kAXsJbbPXqc3t8QAI16vxFB6TsSnYeyes1mD5dbC0z6xsJmlfGWVz/qob
P8e/NSTIpDwz9JneRS8nssM82/FyEp8lyL8X1ldjqbdSEjGVUy+UvwpoMdYXEtZEn+etvPNGCXlb
QeTywON/RcMwbx/zJkKskJtsK7WmD1s6QJglavZ1lllWv3MP3Qs7iXKt1qY1SGf4HZfFGJV/Vcgu
wiIARdRSwCejuVNt88U38pFn9fQHdp+NT6E4qjhSXQikUaMsBljOUhiBvkD3NgmZC0dDrUO0EeUf
Bz8H3nES4ba3XjkfLU7iwICMoIGCDIlE0JUA/K/vKSo/qnRKmQXh7kPNhypzSsbahs/nL5M7GL4z
atEgaArWIrnJp7h/ca5ne5FiZSrvxRuqTABPKIma1xiUgUKTi2k61tQjAmDaMoQgbDzkDWbOGP5L
kpYNrsXg+VY0zKcd1rQzChZ+N4tBJiIUfYKp618lgT9Zq/s2NG1LHhrgEJ4BzJ8AAAAAAAA=


--=-z2xhXgi/QSz0pyBgNgRN--

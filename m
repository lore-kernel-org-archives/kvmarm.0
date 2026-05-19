Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7FE3BD643;
	Tue, 19 May 2026 21:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779227901; cv=none; b=KB4iKdVgZax1VoZMZXQRhyKwuXQOmqcfY3c4sdtyNPSYk1xir6jV+pQ47q6lhX402344T9Jj8w1YNO2LYaycplk80H/jAKPNknHkkv21CZXCAtdisxbcnFn7Z9HxqGIcDG/epACWmsBH3vulCl98eiZnYIlPYTOgeqS2vPu0WhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779227901; c=relaxed/simple;
	bh=T1xaPYw7HAdNJJnhry3obFcjstVn57uQb3z4yT0oMh8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nwGSN+JCb0iyKZ9wTKVn12h1jvkzmGsjGfFcE4wAwjhuiOspC/30kJ/lzey6ypxvDP3+JA+KqBkR86Oey4kDodh5fnUoOZbQIupUifXRv3CxFBxilQWdP8GKLUMxYpauKbBTKiUg/Xfj3HftibPd5HRkiS27Gs5iVODC+Rb2C7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iXdabF8v; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iXdabF8v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u66R6+u6QEN5FG9jyQWIzz8+3zqABf7d9bn5ERNHxKo=; b=iXdabF8vRzpa30SCwM9ZIVYL50
	Xo9R57ATnUd40A1HkfJA0P/fjEOYlYmiCBaSPh46PIMLcq52hiU9xk1P6JeoSaUeMGi9AbkSsKFfg
	2sn38y+R9av4GHhtijOmphszq8tysbP2N7b7POKJHTvc8wV3U9CDoQ1W/AGmUwLZy9V4nzE+ZNsS6
	bWIyYQJzki9liZI9LnVvCnBVsresY/Gvq8fjSECkDipj8rOCGTjVKwK+J0KOdi1WOOcHVkR2tLIDi
	rDfERw9cqbeXzDYe12vcGJe+oZ9jLIkMdRlya3/mw7HGjemvHKCj89oVLn7xpuvuNJN7nUESKyvib
	JXtsh/Sw==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPSRz-00000006KvO-0CEI;
	Tue, 19 May 2026 21:58:07 +0000
Message-ID: <1243d375846c4f4e20c229a6f09300126188fc8b.camel@infradead.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible
 compatibility expectations
From: David Woodhouse <dwmw2@infradead.org>
To: Oliver Upton <oupton@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Will
 Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  kvm <kvm@vger.kernel.org>, Linux Doc Mailing
 List <linux-doc@vger.kernel.org>, "Kernel Mailing List, Linux"
 <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Jim Mattson <jmattson@google.com>, Joey Gouly <joey.gouly@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Raghavendra Rao Ananta
 <rananta@google.com>, Eric Auger <eric.auger@redhat.com>, Kees Cook
 <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,  Nathan Chancellor
 <nathan@kernel.org>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>,  kvmarm@lists.linux.dev,
 linux-kselftest <linux-kselftest@vger.kernel.org>
Date: Tue, 19 May 2026 22:58:05 +0100
In-Reply-To: <agzR2kaJsNa8X9lF@kernel.org>
References: <d9d4471a7f5ec1e297b3ca07f42a59090aa91e15.camel@infradead.org>
	 <CABgObfaM-JtNn2MuYXaiadQnLfAhTEaoHAcTG9=J6LkMcQCJ3A@mail.gmail.com>
	 <3f9d731c3d26b0367600f1069e6425099bc34eac.camel@infradead.org>
	 <agxFbniU_6eQ98t2@willie-the-truck>
	 <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
	 <CABgObfacAYexR25SMi1kSZMRnHx3EDGj8=E84V1DumER66ibnQ@mail.gmail.com>
	 <86qzn7wp3y.wl-maz@kernel.org>
	 <593a782c50f3c8656e13b36dfb975a67d43a908e.camel@infradead.org>
	 <CABgObfbS-z3OphDna5W_JQPvw+OK=yXJurVMHp1ANZ5uGEgVhQ@mail.gmail.com>
	 <9d0429ddbe4d8c6993e74237c4395697f80092d6.camel@infradead.org>
	 <agzR2kaJsNa8X9lF@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-ZGJMbawr+MEa7CQO3eIx"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-ZGJMbawr+MEa7CQO3eIx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-05-19 at 14:10 -0700, Oliver Upton wrote:
> On Tue, May 19, 2026 at 03:13:30PM +0100, David Woodhouse wrote:
> > On Tue, 2026-05-19 at 15:53 +0200, Paolo Bonzini wrote:
> > > On Tue, May 19, 2026 at 3:00=E2=80=AFPM David Woodhouse <dwmw2@infrad=
ead.org> wrote:
> > > > Or some guest configurations which have only ever been tested under=
 KVM
> > > > could have a bug where they *rely* on the registers not being writa=
ble,
> > > > and write values which are inconsistent with the rest of their
> > > > configuration. Which breaks the moment those registers become writa=
ble.
> > >=20
> > > Yeah, just having guests that worked by utter chance - but you still
> > > don't want to break them - is the case that is most likely. Crappy
> > > code that runs only under emulation/virtualization appears with
> > > probability 1 over time.
> > >=20
> > > Is this likely in this specific case---probably not, honestly.
> > > Christoffer's patch dates back to 2018 (commit d53c2c29ae0d); *back
> > > then* KVM/Arm was a lot less mature, and people developing for Arm on
> > > vanilla upstream kernels have moved on from Linux 4.19.
> >=20
> > It's not really 2018 though. EC2 is still running kernels with that
> > older commit reverted because of the breaking change that it
> > introduced.
> >=20
> > So the behaviour corresponding to GICD_IIDR.implementation_rev=3D1 is
> > still current for *millions* of guests.
> >=20
> > I'm now finding that revert in our tree during a *later* kernel upgrade
> > and trying to eliminate it.=20
>=20
> Still, as far as upstream is concerned this is damn near a decade old.
> Decisions that you or your peers made in the downstream doesn't change
> that.
>
> > And sure, I have given the engineers responsible for that a very hard
> > stare and suggested that they should have fixed it 'properly' in the
> > first place with a patch like the one we're discussing right now.
> >=20
> > And they're looking at this thread and saying "haha no, if fixing
> > things properly for Arm is this hard then we'll stick with the crappy
> > approach".
>=20
> The appropriate time to ask for accomodation was a *very* long time ago.
>=20
> And in the absence of clear evidence of a guest depending on the broken
> IGROUPR behavior, I don't see how the guest-side changes of Christoffer's
> series are any different from the multitude of bug fixes that we take
> every single release cycle. It is an unfortunate bug and I concur with
> Marc that it doesn't seem like the sort of thing a guest could rely
> upon.

I find this concerning, because I've already explained this.

There is a very real possibility of guests simply not *noticing* that
they had bugs in this area, as it didn't *matter* what they wrote to
these registers since it never worked.

There is an even larger possibility of guests having worked around the
original issue by *detecting* whether the registers were actually
writable before choosing to use the alternative groups. And if such a
guest launches on a new kernel and then needs to be rolled back to an
older kernel, that will also break.

> Because it is very much a bug fix, it should've happened without a
> change to the revision number.

No. Changing the revision number in conjunction with the guest-visible
behaviour change is *absolutely* the right thing to do.

> Now, the handling of GICD_IIDR itself is a separate issue. By my count,
> the series broke UAPI on three separate occasions. Before b489edc36169
> IIDR was RAZ/WI from userspace. And of course dd6251e463d3 and d53c2c29ae=
0d
> changed the revision with no way of restoring the old value.
>=20
> And really, IIDR should've *never* been used as a buy in for new UAPI
> because it unnecessarily becomes guest visible. 49a1a2c70a7f ("KVM: arm64=
:
> vgic-v3: Advertise GICR_CTLR.{IR, CES} as a new GICD_IIDR revision") is
> a much better example for IIDR going forward as it gates *guest-side*
> behavior.

Yes, 49a1a2c70a7f is the exemplar. The guest-visible behaviour changes,
so we get a new IIDR revision and the ability to preserve the previous
behaviour by setting IIDR to the old value. That is exactly how it
should always be done.

> > I do not want them to be right. I don't think any of us want that.
> >=20
> > > I would still lean towards accepting the code considering the limited
> > > complexity of the addition (in fact I like it more now that it uses
> > > IIDR instead of v2_groups_user_writable, but that's taste).=C2=A0
> >=20
> > I'm absolutely prepared to have a separate technical discussion about
> > the v2_groups_user_writable thing for GICv2, which is the second part
> > of that series.
> >=20
> > It seems like the right thing to do, and as far as I can tell, this
> > code *never* worked with QEMU. But I'm not sure who even cares about
> > GICv2 any more. I couldn't find hardware and I had to test the whole
> > thing inside qemu-tcg.
> >=20
> > But the 'IIDR defaults to 3 but the *behaviour* doesn't match until you
> > explicitly *set* it to 3' thing seemed so *egregiously* wrong to me,
> > that I fixed it anyway.
>=20
> Wrong or not, this behavior is documented unambiguously. From the VGICv2
> UAPI documentation:
>=20
> """
> Userspace should set GICD_IIDR before setting any other registers (both
> KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_CPU_REGS) to ensu=
re
> the expected behavior. Unless GICD_IIDR has been set from userspace, writ=
es
> to the interrupt group registers (GICD_IGROUPR) are ignored.
> """
>=20
> I'm not inclined to change that.

That'll all very well... but as far as I can tell, QEMU *doesn't* set
GICD_IIDR, so it still gets the bizarre behaviour where the *guest* can
write the registers, but userspace can't. So it looks like it'll work
except migration will fail. Am I missing something?

But honestly, I don't care one iota about GICv2; I was only trying to
do the cleanup while I was there. Feel free to drop that part entirely.

>  As a way out of this whole mess, can we
> instead:
>=20
> =C2=A0- Allow userspace to set IIDR.Revision to 1
>=20
> =C2=A0- Drop any bug emulation from the handling of IGROUPR registers

It doesn't make sense to allow setting IIDR.Revision to 1 *without* the
one-liner that actually implements the corresponding behaviour change
in the IGROUPR registers. And as explained at least twice now, it's the
behaviour change that's *important* here.

The fact that it's a long-standing bug in KVM which downstream has been
working around for a long time doesn't matter. The unconditional
behavioural change *is* a bug and we should fix it.

> =C2=A0- Special-case the stupid GICv2 UAPI where IGROUPR are only writabl=
e if
> =C2=A0=C2=A0 the VMM has written to IIDR and the revision >=3D 2

That already *is* a special case, right? And you'd rather leave it as it is=
?

--=-ZGJMbawr+MEa7CQO3eIx
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxOTIxNTgw
NVowLwYJKoZIhvcNAQkEMSIEIKbGBgZ3nv2ze+Txo23teSJzZh+CY/8E7ocgTMoa7yvZMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAStV8DJeMg+jS
gQXWuet0RmAcWXA1PmtKdpNj/KL71M/t6D26Iz1oo1y7rf8XPSQFpLED01gkkIk03AohH6Tgb/HJ
fHG527K9bIer82weqiezP/arU3m0ztOj6HEdO07whp+tRXgr34tD38l9zSDi4YeQUV2d/HJBb3/z
gFlvC3F+ju5qYbX/pqrLH85CDbmeHwxII7/X4U8Y16veMIdF94pfjYlllrcFCsazr3OrKhW6UI7W
iIZTGHqCO0fkoRUPHFUIEMDCeHXvz4VcWFUsyUvXmWbdLuD/CmMZfeEwXylVe6Frk23sbOQWOQ8v
0pS6nw+LrZYhmrqFEkhS0+yfLlDwVZSDLeaAY4YX3Z3CQTpAracxiNL026ImL3ZRqfjvgzzqcn76
XQo5QgqYbVULqid6Pue9EUEp2YZdO5VudBhQ/GOp50YTVJD8mfcJVqbGuCsETazWK9/DGv3aNeWn
bLCpwyOfZWd1Pm+pIH65LWM1NUjE4tyY6d0NAkPxFZNjXKIVBVs/2tKU8KJDbyUlImvUgbRj44w4
DA3bvbq27vZ/07Ya3YEOwnVfgb2hEw9yCG3BevIegkFPbRfJ2HitOaU8W2TYoYwNGnvVuQp7vgqQ
/aX1YKxJXnajnw2PKKVXUePy2+suX+C6feLOFr4/3EONC67lExvm0EAGN389n9YAAAAAAAA=


--=-ZGJMbawr+MEa7CQO3eIx--

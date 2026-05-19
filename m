Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2752B384256;
	Tue, 19 May 2026 23:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779233645; cv=none; b=QVn1Naj4G5Cpi077N61kH0rI/2WERbbRrsvbzfw5g2GG0rJqk6rhCpgy2J/0eB4kbxZczwjCNtANV4RyFMiAvQ4rUgL5Ca6jW14NFfePXvMYgqrOhZR2b2kuOu02SOZ2BVyhn69yIBkA0nwke5R4fwIFKXKZv1N+SAxknS7XcQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779233645; c=relaxed/simple;
	bh=wToOAFFueTVGAcKCrvnJhfPLzohMujY5kkZvVSCYWIE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nyzbdhgkOY9R8znh2hh6IXQ9IENHeENUXDE5A5hVH3q0f9FTVExbUJiLpkfgzQTNMhZVeJ1WHjkOSWE81o7UR9T8CekOfk6vo/4aJ9JPZolACHpK+Vvz2Ar5ivqAwYFigH0nnghcL+/DA1Y7MEHIw9fIP26HRHdDBI19jnAG2JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RMMJ1ZPV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RMMJ1ZPV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wToOAFFueTVGAcKCrvnJhfPLzohMujY5kkZvVSCYWIE=; b=RMMJ1ZPVZ6Gz64yllEe9b9vX9F
	mwJyeyslKPxLYIsS1e61WgJ/g8f4vhQNJ7/01hYNztXxarO+RlUbaeurlUNJfobyBX1cLNJko1Sob
	E7JAv8Uhy3YR6qjkVHR3hMS8eJb1o5THibFVET8yeRiIH9lciQB5Mda+ci/0wzVXOlcn1zxNqip8m
	YyBLOHUSs/VMc5m1bg1KDXr6rWB15yonWeaVxQFAmmpmhQD5MJUmPB1yeShLVmO/qPxaho2dtOtCl
	lNRwtRQFVDael+bXXX8ZiFZXIV5kvhwsbw/jdFhOqwRlvsivSrMcEoKXuw8Sw+BVvQkC97QX/wN8h
	drxLUqsA==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPTwf-00000006R84-3Yfi;
	Tue, 19 May 2026 23:33:54 +0000
Message-ID: <add71b6f61edc6357e1fddad83273b2cba697d10.camel@infradead.org>
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
Date: Wed, 20 May 2026 00:33:52 +0100
In-Reply-To: <agzq5kwzuJvd7Mh5@kernel.org>
References: <3f9d731c3d26b0367600f1069e6425099bc34eac.camel@infradead.org>
	 <agxFbniU_6eQ98t2@willie-the-truck>
	 <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
	 <CABgObfacAYexR25SMi1kSZMRnHx3EDGj8=E84V1DumER66ibnQ@mail.gmail.com>
	 <86qzn7wp3y.wl-maz@kernel.org>
	 <593a782c50f3c8656e13b36dfb975a67d43a908e.camel@infradead.org>
	 <CABgObfbS-z3OphDna5W_JQPvw+OK=yXJurVMHp1ANZ5uGEgVhQ@mail.gmail.com>
	 <9d0429ddbe4d8c6993e74237c4395697f80092d6.camel@infradead.org>
	 <agzR2kaJsNa8X9lF@kernel.org>
	 <1243d375846c4f4e20c229a6f09300126188fc8b.camel@infradead.org>
	 <agzq5kwzuJvd7Mh5@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-TAaU+Wf4Qs0Gd5EH9iBY"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-TAaU+Wf4Qs0Gd5EH9iBY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-05-19 at 15:57 -0700, Oliver Upton wrote:
> On Tue, May 19, 2026 at 10:58:05PM +0100, David Woodhouse wrote:
> > On Tue, 2026-05-19 at 14:10 -0700, Oliver Upton wrote:
> > > And in the absence of clear evidence of a guest depending on the brok=
en
> > > IGROUPR behavior, I don't see how the guest-side changes of Christoff=
er's
> > > series are any different from the multitude of bug fixes that we take
> > > every single release cycle. It is an unfortunate bug and I concur wit=
h
> > > Marc that it doesn't seem like the sort of thing a guest could rely
> > > upon.
> >=20
> > I find this concerning, because I've already explained this.
> >=20
> > There is a very real possibility of guests simply not *noticing* that
> > they had bugs in this area, as it didn't *matter* what they wrote to
> > these registers since it never worked.
> >=20
> > There is an even larger possibility of guests having worked around the
> > original issue by *detecting* whether the registers were actually
> > writable before choosing to use the alternative groups. And if such a
> > guest launches on a new kernel and then needs to be rolled back to an
> > older kernel, that will also break.
>=20
> The onus is on you to substantiate this claim. I would imagine after
> carrying the revert for so long that there must be at least one example
> of such a guest?

What? No. We have *avoided* having the bug, specifically so that we do
not find out the consequences of the bug.

> What ifs and maybes do not meet the bar, in my opinion, for preserving
> bug emulation in KVM. Of course there could be a little flexibility with
> that but we need to have some way of discriminating between bug fixes
> and genuine guest expectations around the behavior of virtual hardware.

I believe you have this completely backwards.

The expectation of KVM is that do not change guest visible behaviour if
there's any reasonable chance that it might cause problems.

A stable and mature platform doesn't get to play in its ivory tower and
randomly inflict breakage on guests because they "deserve it".

I've literally explained the potential failure modes, including the one
on rollback if a guest *does* change the group configuration and then
needs to be rolled back to the older kernel that doesn't support it.

And yes, "ifs and maybes" absolutely *are* the quality bar expected by
KVM because =E2=80=94 again, as already explained more than once =E2=80=94 =
as we
accumulate a bunch of such "unlikely" breakages in a fleet upgrade
from, say, 6.1 to 6.12, the likelihood of *one* of them actually
turning out to afflict *one* of the zoo of guest operating systems
approaches 1.

We don't get to just YOLO it.

> > > Wrong or not, this behavior is documented unambiguously. From the VGI=
Cv2
> > > UAPI documentation:
> > >=20
> > > """
> > > Userspace should set GICD_IIDR before setting any other registers (bo=
th
> > > KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_CPU_REGS) to =
ensure
> > > the expected behavior. Unless GICD_IIDR has been set from userspace, =
writes
> > > to the interrupt group registers (GICD_IGROUPR) are ignored.
> > > """
> > >=20
> > > I'm not inclined to change that.
> >=20
> > That'll all very well... but as far as I can tell, QEMU *doesn't* set
> > GICD_IIDR, so it still gets the bizarre behaviour where the *guest* can
> > write the registers, but userspace can't. So it looks like it'll work
> > except migration will fail. Am I missing something?
>=20
> That's exactly it, and why I said tying up UAPI opt-in with
> guest-visible registers is a really bad idea.
>=20
> > But honestly, I don't care one iota about GICv2; I was only trying to
> > do the cleanup while I was there. Feel free to drop that part entirely.
> >=20
> > > =C2=A0As a way out of this whole mess, can we
> > > instead:
> > >=20
> > > =C2=A0- Allow userspace to set IIDR.Revision to 1
> > >=20
> > > =C2=A0- Drop any bug emulation from the handling of IGROUPR registers
> >=20
> > It doesn't make sense to allow setting IIDR.Revision to 1 *without* the
> > one-liner that actually implements the corresponding behaviour change
> > in the IGROUPR registers.
>=20
> As I described earlier, this whole IIDR crap inarguably broke UAPI and
> obviously normal guest behavior (i.e. reading the register). At minimum
> we need to permit previously-valid values for IIDR, even if they carry
> no implied behaviors.

But the whole *point* of IIDR is to preserve the behaviour. To set the
IIDR and *not* have the corresponding behaviour is insanity.


> > And as explained at least twice now, it's the
> > behaviour change that's *important* here.
> >=20
> > The fact that it's a long-standing bug in KVM which downstream has been
> > working around for a long time doesn't matter. The unconditional
> > behavioural change *is* a bug and we should fix it.
>=20
> That is the nature of a bug fix. If you can provide some concrete
> evidence of a guest depending on the RAZ/WI behavior then I agree we
> need to preserve the old behavior.
>=20
> Otherwise I see this as a matter of principle in how we do bug fixes to
> KVM. Even if upstream took the strictest possible stance towards behavior
> changes we will invariably fail to account for some minutia.

No. Don't pretend that this is hard. KVM on x86 has been quietly
getting this right for years.

Yes, there is sometimes *some* subjectivity around it, and it's
sometimes reasonable to just unilaterally change behaviours. This is
not, and was not, once of those cases.

> > > =C2=A0- Special-case the stupid GICv2 UAPI where IGROUPR are only wri=
table if
> > > =C2=A0=C2=A0 the VMM has written to IIDR and the revision >=3D 2
> >=20
> > That already *is* a special case, right? And you'd rather leave it as i=
t is?
>=20
> Left as documented, yes. With the exception that revision =3D=3D 1 writes
> not be considered opt-in to restorable IGROUPR.

Don't do that. Just leave it broken, with QEMU not even working. I'm
beyond caring about GICv2 now.

--=-TAaU+Wf4Qs0Gd5EH9iBY
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxOTIzMzM1
MlowLwYJKoZIhvcNAQkEMSIEIN6inSCxRMXT5tpgmx0yDwHe+Fpm9NXqeYg7Cd/UJQdaMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAJy1gxgZxXtfk
zejMPtSbl4XtkTuNk8ngRS+X1ZMVTeMDFFYsZhkvOmc1wEUVktEJ8e+bXljVtquUhA8w0igBCrz4
7tIR9JVT2lTmiYvlc2xLyuKjO2rCez7rh7QZkkPApOe8RrBHX9ecSxTQnVIj2LM79mmsCYEjJERa
pj8t5is2RkXHskJ+FDlbhVeAK+JNyS+ln/79HM4uKEkLP9ZYh/NBbMAbp78N/m9rIftCJltMjvG0
HFRLtgTuEyuXakO9BatOfKCubwWSkQUXGDDESN6JMUIEWPPNBChXChV8+uZ4R6v6lATMWvJG8Bhh
dNLzh4gulWYJDLLzu3jb0WbcbwpUJfW0cQ5hLvmFNBcN8bJLYYk6MSJ7hmT9SPw7Qde+fyMErNYh
CXuscM6UKkqJafSpal13D18NBVhmo5SB/5cZdvouRLeOd0Cn+xNaYGro13FCUptuVJSXDarQzwSS
vPHpzbndk9sehNWCWeFVls4OVew30B/Gz3GnU6FANX8T5pk2qYajC8zYTLmFdofU+cv89g+zppwG
X5W8XJlCHNSTLNMgiwA53kG4HgbZ40kJiZm/LuimQQbav1MpeVGOHdBacEDv0cfwnI3ybUVnCXoX
2eYnYzKQKRI1RS4kAtZ4BhPhmenbDPCQC4vNSoTWfvaXkqcaOtVMjaw/NezuuDUAAAAAAAA=


--=-TAaU+Wf4Qs0Gd5EH9iBY--

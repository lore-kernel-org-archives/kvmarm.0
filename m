Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BF32D3EC1;
	Thu,  9 Apr 2026 17:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756959; cv=none; b=kZ8o/AdqNhq28FwBVj/KIQea1Y7ZscXPHO66+8c3hOJqOx6d0yKXnN+iumgsaD9ywF/XMMSD32pf9+h/rJ7UXQiQl9DSU6fMSCdXCQ6OY9xihbf9uFzm8CD0tMR85uX52ua4Hw0SiDttrT2mkXvWfXROz1OgEeilX1gW+gY1CXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756959; c=relaxed/simple;
	bh=OzK1sIJjsCRyFdmQC8juz0EAICzue9C786JRw21cJBY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f8ecVWdxsD3zVY9dvcubHFQ0RnrdiHkwpkx0oWrNfQJvshSozTuh9jMZn1bBN4n/42BtkQA7rg/6NksE7oJu1Q8/HocENcYkLOjgLkyxHFN7Mh00pEZUCvZrtT0KJh9uUnjIKyt16hUS6v5bqkud4C8GfEhLbO0UZh9pfV2wbBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QqRupec1; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QqRupec1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qGs61kKWlyg5aSvMvL1JO3HcvmBnSdYhJLX2u4HC90U=; b=QqRupec1HR1Xia8ODVCYXABS9h
	Dj2UFVaQxQYESg5AFqpBYv/QVX4JLj2rLUSgD8ahY68UbxzZUCJIk6Nekm9Fd2HZMGgMOFpMM+bZg
	iPH4DON5js918NzeXTpmjEjIJcfJORVxLexKXmdhKF0OFjf5OvOgFTB1Rw1/H+J/m2637485FrBgz
	kObJib7YX2rZQGbTf12fem+QG0TH9xo8j0Sx/kP6gNnY2askRxsg/YxfjuPuaiAigvjQos3TaQjp+
	ifsVw1IjA5+Jdkg1jAUdP6BlaUrymXvPEaETgTpziQdBhozVsDJb8fPIRChRoIXtFU+iYOIA5Kn7K
	eQhHbZ6Q==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAtV7-0000000CDWU-3EY9;
	Thu, 09 Apr 2026 17:49:10 +0000
Message-ID: <584931abfa8c6f6c9c8a1379d26ef6beb58db1cd.camel@infradead.org>
Subject: Re: [PATCH] KVM: arm64: Add KVM_CAP_ARM_NATIVE_CACHE_CONFIG vcpu
 capability
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>
Cc: "Gutierrez Cantu, Bernardo" <bercantu@amazon.de>, 
 alexandru.elisei@arm.com, alyssa@rosenzweig.io, asahi@lists.linux.dev, 
 broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, 
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, marcan@marcan.st, mathieu.poirier@linaro.org,
  oliver.upton@linux.dev, suzuki.poulose@arm.com, sven@svenpeter.dev, 
 will@kernel.org
Date: Thu, 09 Apr 2026 18:49:09 +0100
In-Reply-To: <86se942hbv.wl-maz@kernel.org>
References: <b71910e202ac4a56a87c0e34df13cce058d46a76.camel@infradead.org>
	 <7fb7b823c68e04321eb532a5b8ae21a818d4926d.camel@infradead.org>
	 <86se942hbv.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-BUtoEEHWtjgzs84gLrzz"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-BUtoEEHWtjgzs84gLrzz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-04-09 at 18:07 +0100, Marc Zyngier wrote:
> On Thu, 09 Apr 2026 16:29:06 +0100,
> David Woodhouse <dwmw2@infradead.org> wrote:
> >=20
> > [1=C2=A0 <text/plain; UTF-8 (quoted-printable)>]
> > From: David Woodhouse <dwmw@amazon.co.uk>
> >=20
> > Commit 7af0c2534f4c5 ("KVM: arm64: Normalize cache configuration")
> > fabricates CLIDR_EL1 and CCSIDR_EL1 values instead of using the real
> > hardware values. While this provides consistent values across
> > heterogeneous CPUs, it does cause visible changes in the CPU model
> > exposed to guests.
> >=20
> > The commit claims that userspace can restore the original values, but
> > there is no way for userspace to obtain the real CLIDR_EL1 register
> > value =E2=80=94 it is not fully reconstructible from sysfs, which lacks=
 the
> > LoC, LoUU, and LoUIS fields.
> >=20
> > Add a per-vcpu KVM_CAP_ARM_NATIVE_CACHE_CONFIG capability that reads
> > the real CLIDR_EL1 and all CCSIDR_EL1 values from the current physical
> > CPU and sets them on the vcpu.
> >=20
> > This allows hypervisors to present the real hardware cache configuratio=
n
> > to guests, which is important for consistency of the environment across
> > kernel versions and for migration compatibility with hosts running
> > older kernels that exposed the real values.
> >=20
> > Fixes: 7af0c2534f4c ("KVM: arm64: Normalize cache configuration")
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > ---
> > =C2=A0Documentation/virt/kvm/api.rst=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 23 ++++++++
> > =C2=A0arch/arm64/include/asm/kvm_host.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> > =C2=A0arch/arm64/kvm/arm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 17 ++++++
> > =C2=A0arch/arm64/kvm/sys_regs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 26 ++++++++++
> > =C2=A0include/uapi/linux/kvm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 1 +
> > =C2=A0tools/testing/selftests/kvm/Makefile.kvm=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 1 +
> > =C2=A0.../selftests/kvm/arm64/native_cache_config.c | 52 ++++++++++++++=
+++++
> > =C2=A07 files changed, 121 insertions(+)
> > =C2=A0create mode 100644 tools/testing/selftests/kvm/arm64/native_cache=
_config.c
> >=20
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index e3b3bd9edeec..ee47dc07ceac 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -8930,6 +8930,29 @@ no-op.
> > =C2=A0
> > =C2=A0``KVM_CHECK_EXTENSION`` returns the bitmask of exits that can be =
disabled.
> > =C2=A0
> > +7.48 KVM_CAP_ARM_NATIVE_CACHE_CONFIG
> > +-------------------------------------
> > +
> > +:Architecture: arm64
> > +:Target: vcpu
> > +:Parameters: none
> > +:Returns: 0 on success, -ENOMEM on allocation failure, -EINVAL if
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 args[0] or flag=
s are non-zero.
> > +
> > +This per-vcpu capability reads the real CLIDR_EL1 and CCSIDR_EL1 value=
s
> > +from the physical CPU on which the ioctl is executed, and sets them on
> > +the vcpu. This replaces the fabricated cache configuration that KVM
> > +provides by default.
> > +
> > +The caller should ensure the vcpu thread is pinned to the desired
> > +physical CPU before invoking this capability, so that the correct cach=
e
> > +topology is captured. On heterogeneous systems, different physical CPU=
s
> > +may have different cache configurations.
> > +
> > +After this capability is enabled, the vcpu's CLIDR_EL1 and CCSIDR_EL1
> > +values can still be overridden individually via ``KVM_SET_ONE_REG`` an=
d
> > +the ``KVM_REG_ARM_DEMUX`` interface.
> > +
> > =C2=A08. Other capabilities.
> > =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > =C2=A0
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index a1bb025c641f..c9713a472c47 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1296,6 +1296,7 @@ void kvm_sys_regs_create_debugfs(struct kvm *kvm)=
;
> > =C2=A0void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
> > =C2=A0
> > =C2=A0int __init kvm_sys_reg_table_init(void);
> > +int kvm_vcpu_set_native_cache_config(struct kvm_vcpu *vcpu);
> > =C2=A0struct sys_reg_desc;
> > =C2=A0int __init populate_sysreg_config(const struct sys_reg_desc *sr,
> > =C2=A0				=C2=A0 unsigned int idx);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 326a99fea753..579583e8dc5c 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -393,6 +393,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, =
long ext)
> > =C2=A0	case KVM_CAP_ARM_DISABLE_EXITS:
> > =C2=A0		r =3D KVM_ARM_DISABLE_VALID_EXITS;
> > =C2=A0		break;
> > +	case KVM_CAP_ARM_NATIVE_CACHE_CONFIG:
> > +	case KVM_CAP_ENABLE_CAP:
> > +		r =3D 1;
> > +		break;
> > =C2=A0	case KVM_CAP_SET_GUEST_DEBUG2:
> > =C2=A0		return KVM_GUESTDBG_VALID_MASK;
> > =C2=A0	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> > @@ -1793,6 +1797,19 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> > =C2=A0		r =3D kvm_arch_vcpu_ioctl_vcpu_init(vcpu, &init);
> > =C2=A0		break;
> > =C2=A0	}
> > +	case KVM_ENABLE_CAP: {
> > +		struct kvm_enable_cap cap;
> > +
> > +		r =3D -EFAULT;
> > +		if (copy_from_user(&cap, argp, sizeof(cap)))
> > +			break;
> > +
> > +		r =3D -EINVAL;
> > +		if (cap.cap =3D=3D KVM_CAP_ARM_NATIVE_CACHE_CONFIG &&
> > +		=C2=A0=C2=A0=C2=A0 !cap.args[0] && !cap.flags)
> > +			r =3D kvm_vcpu_set_native_cache_config(vcpu);
> > +		break;
> > +	}
> > =C2=A0	case KVM_SET_ONE_REG:
> > =C2=A0	case KVM_GET_ONE_REG: {
> > =C2=A0		struct kvm_one_reg reg;
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1b4cacb6e918..c19d84e48f8b 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -484,6 +484,32 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 c=
sselr, u32 val)
> > =C2=A0	return 0;
> > =C2=A0}
> > =C2=A0
> > +int kvm_vcpu_set_native_cache_config(struct kvm_vcpu *vcpu)
> > +{
> > +	u32 csselr;
> > +
> > +	if (!vcpu->arch.ccsidr) {
> > +		vcpu->arch.ccsidr =3D kmalloc_array(CSSELR_MAX, sizeof(u32),
> > +						=C2=A0 GFP_KERNEL_ACCOUNT);
> > +		if (!vcpu->arch.ccsidr)
> > +			return -ENOMEM;
> > +	}
>=20
> Well, no.
>=20
> The moment you decide to expose all of the host's crap, you really
> need to put everything on the table. It means fully handling
> FEAT_CCIDX, which we were careful not to expose anywhere because it is
> a terrible idea.

The intent here is not to "expose all of the host's crap", but to
maintain compatibility with what the kernel did before commit
7af0c2534f4c. No need to expose FEAT_CCIDX.

> > +	for (csselr =3D 0; csselr < CSSELR_MAX; csselr++) {
> > +		write_sysreg(csselr, csselr_el1);
> > +		isb();
> > +		vcpu->arch.ccsidr[csselr] =3D read_sysreg(ccsidr_el1);
>=20
> That's not how the selection register works. CLIDR_EL1 tells you what
> each cache level is (Instructions, Data, Unified, Tags), and that must
> be combined with the index (which doesn't start at bit 0).

Ack, thanks. I'll rework that based on the old is_valid_cache()
function.

> I also wonder how you reconcile not exposing MTE when the cache
> hierarchy indicate support for tags. That clearly contradicts "report
> what the HW has".

If that was an issue then it would already have been an issue before
commit 7af0c2534f4 (and in kernels with that commit reverted), hosting
millions of guests today.

This isn't about introducing *new* behaviour; it's about allowing the
existing established behaviour to be maintained so that we can have a
*managed* transition to the new model (for new launches) rather than an
unconditional uncontrolled change as the kernel gets upgraded.

--=-BUtoEEHWtjgzs84gLrzz
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDQwOTE3NDkw
OVowLwYJKoZIhvcNAQkEMSIEIML3+/pb+uNwJPTCApRGqyBU+nV+PbaR6TCvQ5iY2AqWMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAwXD79QprztK5
wl1xtJt7mtg575ug+dJwe6z9tUNQH4iTeAeLqa1Dv1NKGO8Fm8GsZkT+Xl0pU6TGvg3n0BmB9rj2
zWg6kj33QnQpQwltjatpUJtnckUdLW9ETgk0xp+nBZC9Hoe2xd5eXJXGAHt6wgTy3wCQFAxAIKJY
D7tjwCbKtXUBw+YqLkt2MufWponYTAiwkAM3bD22iuNaNdCMVvGr0BvCbuDuKLglcJ0IB0QFAyMs
6bTl78npYpwGfWRi03LX/AqXByr9DwYa35TE2sdc0dgc9cbSQ++UWCJblM3ReaIrGrmr5XhUTmkm
V7XOR2adwBPx9vZ/DULDbOuq17OOeY8ObOPpHgmEHxFdjsh8EnqfEPYgOrwwIZMMGeybNXUdxM65
St1RxaRlyD0TcXQxx/UW5LbTQ732stQuNWNfSs22jRVE6ZSuj3M2onecC9PWg9uA7mc190lq9qJF
hJruvOixj+/dB1Md4V9w4/rlYP25QmJkdeNCxado4Lmoj/znzHwe3Bp6t2hXRc0HUFFaBuS9NxVL
r0o2OVwKMvdr+dafK8QUtKblJXHfWbCQTz07Sba4y5mhvOgcS7j8P4v+urzqrWAg/dc5ybCAZrvd
dMQPKjpPJDS3SyNtsrfpyk6dUTr1q6SJGZIq03359QV9cXg4AlFN4JRjfsdo1T0AAAAAAAA=


--=-BUtoEEHWtjgzs84gLrzz--

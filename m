Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6403FC5C4;
	Fri, 24 Jul 2026 12:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895347; cv=none; b=q+cZAFPiaolMSFTxoLZIYh65zgTKWAKeY9vhAxbpBnZ1xgHf+H3WF9zSG7ME9j5fJASJemfBfe70O82NCSxB1bkSLKAS/E8LJOG5eGTE5IK5+etaz8jFHZfG2HLi0lT8mttlbxrC8OiHfitk14LAYbSqUOxPW9/Tntu2r6l3qoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895347; c=relaxed/simple;
	bh=kCMRlGrEiU5VwIcqlGeA1xQE0c7GqdvgjFxChWoBR78=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B7Zbt6R9115V0mUAW1kMyuH9BSM3U00eAWg7gdDBso3C0Fz23PTK37HlpkH7KZZ9751p7jrPijuKthwUDRUWEaCAqz/rkt55UzKaJPxeE0mv73qcuCsMsED77ymN/ypAWlzeUyGSJ30PiOLUWYhZy6PIguvMEyihp3oC0pJ7uxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBY/EnOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBY/EnOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3811F000E9;
	Fri, 24 Jul 2026 12:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784895345;
	bh=bXA3xverf5H7syisI6zb6A3muFeVRdwvylNTl51M+KU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CBY/EnOMj7hQk7WyCZ79pDO3wIcR/X00ihT7FTOhMrcmjujo+mT9Ael58aSGS+hBZ
	 hbRroO5JnajQJPb9pBZupYQswtDgIwJbG+MXkcVzn3CYEnvZz8eUROZyRn2x8e4ECD
	 a9oTPWtOaRYc0YJ3Ah1kBitM3q4NE1LeEHoY7qbmpMqjYuAaJM2XbgUsmVKDiiveiW
	 wkmgXOKrD+gjao4pz33oPbb0LuR7n1EuVFUyqfeYW3UIFqoDhLreskI5/XY4fUP1BF
	 keXupP+YKYxJR63YqnbDovLSL/fGAdNR0B3GCH7Pewa1617OgxmWws8PNyfQ/KomSd
	 D1drYrC8bxf1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 46/48] KVM: selftests: Add VGICv5 SPI injection tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260724104819.1296803-47-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-47-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 12:15:44 +0000
Message-Id: <20260724121545.7B3811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Writes to GICv5 control-plane system registers are missing the m=
andatory immediate isb() synchronization.
--

--- Patch [46]: [PATCH v4 46/48] KVM: selftests: Add VGICv5 SPI injection t=
ests ---
commit 194658b92777c0e76e825f04069b3e506ee164f3
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 SPI injection tests

Add VGICv5 SPI delivery coverage through KVM_IRQ_LINE. SPIs are
configured through the virtual IRS and delivered through the GICv5 CPU
interface, so the test needs to exercise both the userspace injection
path and the guest-side IRS programming path.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index 22ae726b17be8..cec994a77c993 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
[ ... ]
> @@ -41,7 +44,71 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *s=
pi_ist, size_t spi_size,
>  	};
>  }
> =20
> +static void gicv5_setup_and_enable_hwirq(u64 hwirq, u32 target_vpe)
> +{
> +	u64 val;
> +
> +	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDPRI_PRIORITY_MASK,
> +				 GICV5_IRQ_DEFAULT_PRI);
> +	gic_insn(val, CDPRI);
> +
> +	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDAFF_IAFFID_MASK, target_vpe);
> +	gic_insn(val, CDAFF);
> +
> +	gic_insn(hwirq, CDEN);

[Severity: Medium]
Are isb() barriers required after these control-plane system register write=
s?

Unless these specific GICv5 CD registers are architecturally defined as
self-synchronizing, ARM64 requires an immediate isb() after every
control-plane system register write to ensure the CPU pipeline observes
the new configuration state.

> +}
[ ... ]
> +static void guest_spi_irq_handler(struct ex_regs *regs)
> +{
> +	bool valid;
> +	u32 hwirq;
> +	u64 ia;
> +
> +	ia =3D gicr_insn(CDIA);
> +	valid =3D GICV5_GICR_CDIA_VALID(ia);
> +
> +	if (!valid)
> +		return;
> +
> +	gsb_ack();
> +	isb();
> +
> +	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
> +
> +	GUEST_ASSERT_EQ(hwirq, gicv5_spi_hwirq(READ_ONCE(spi_line_expected)));
> +
> +	gic_insn(hwirq, CDDI);
> +	gic_insn(0, CDEOI);

[Severity: Medium]
Should these system register writes also be followed by isb() barriers?

Similar to the above, without explicit synchronization, the pipeline
might not immediately observe the updated state before the exception
handler completes.

> +
> +	GUEST_DONE();
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D46

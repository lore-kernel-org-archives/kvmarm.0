Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98DC4ED199;
	Fri, 16 Oct 2026 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167758; cv=none; b=EAwuR5m8ybn4PGSSV+i+RkTrNWRzUbaa+isy2KmHCzAE3x4mCZu72gnOZ80jE/qn4LhfGb3lXFSyhSPB9yeJrb2DFHzX+w5l5pt+reJsWrTbuXtyg4i8W9eWFDi+ASfDgS1yZoYUuhI9w+2/fOhc32mmUVyjUFeOGx+xg+sT/+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167758; c=relaxed/simple;
	bh=4A5pDB6ZEeWv4rh8gzEo33CPoxq5UeBNJnutcQ6EPYE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=D1NZeMbNB8N4IhsWdvoXHiQ1iOPpZwsRzQFY1MRBVPCQSq7tb++g5h9ZIw+Oe1wL6vLg1u12rI2qfaFFqNwXdjBvgyoRyFM7UKT79Nk/sPLubxaG8Uu+VZGLDpDuhI1lnMFSs5j7qut/h/diugndRwpYHjlZe/G7xhXfBM8ADWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEy8ryUF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEy8ryUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26201F000C6;
	Fri, 16 Oct 2026 16:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167754;
	bh=IM7cd1g397rwGeO1v/7urCs0eQ4C+vEw38RjF2hK70s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LEy8ryUFIuUlFCZOWlEV2UumgAftd+tbiNbNHxKkWVvXVuR2yWupa0e4uKRJKaegY
	 8MQqW3Ie+UDZZn5fJ3ztuC0rC/y8DjftTP24ur/vmHfpmFwpNv6PGYkPlxhZKQb3y1
	 AXizvgfcx5r8EgicbbauE2BdrTuFy3tMrv2TbOiSy7CANCgtVUnPPZguL6YiSHSogw
	 Oyu+kAAe+mfxrjWR7hvvmGNXi7+umLGmmGB+nfDACzQthPjiS4bzfOfSBWIaT2LbsC
	 1ufa+QI9wKYJCoNZOy+eYktq8gB/aQsfr3znYGZXyctcLyUcGR+OHtW0B+i5RqQQ30
	 yIRaoMcxttV0w==
Message-ID: <sashiko-outbox-174630@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/16] KVM: selftests: Add VGICv5 ITS translation cache
 tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-16-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-16-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:22:33 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] vgic_v5: missing ITS_STATUSR/ITS_GEN_EVENT_STATUSR completion poll
- [High] vgic_v5: priority drop coupled with deactivation in ITS IRQ handler
--

commit fe8f40c11d68589dddb7ff395093f6a131cf59d8
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: selftests: Add VGICv5 ITS translation cache tests

This commit adds end-to-end coverage for VGICv5 ITS translation and cache
invalidation. It verifies that KVM can parse guest-provided linear DT and
ITT state and use it to deliver LPIs through guest GEN_EVENTR and
KVM_SIGNAL_MSI. The test builds a two-VPE VM with IRS, ITS, and an LPI IST.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index b7fb002a64f6c..6ea6aef4f0f46 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c

[ ... ]

> +/* Inject a manually triggered translation via the ITS_GEN_EVENTR */
> +static void gicv5_send_its_gen_event(u32 device_id, u32 event_id)
> +{
> +	u64 val;
> +
> +	val =3D FIELD_PREP(GICV5_ITS_GEN_EVENT_DIDR_DEVICEID, device_id);
> +	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_GEN_EVENT_DIDR);
> +
> +	val =3D FIELD_PREP(GICV5_ITS_GEN_EVENT_EIDR_EVENTID, event_id);
> +	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_GEN_EVENT_EIDR);
> +
> +	writel(GICV5_ITS_GEN_EVENTR_R |
> +	       FIELD_PREP(GICV5_ITS_GEN_EVENTR_TARGET_DOMAIN, 0),
> +	       GICV5_ITS_BASE_GVA + GICV5_ITS_GEN_EVENTR);

[Severity: High]
Does this operation require polling for completion? In gicv5_send_its_gen_e=
vent,
the event generation command is issued asynchronously by writing to
GICV5_ITS_GEN_EVENTR without a subsequent poll of the ITS_GEN_EVENT_STATUSR
IDLE bit.

Since the test subsequently yields to the host via GUEST_SYNC and expects t=
he
event to be delivered, failing to wait for the virtual hardware to complete
introduces a race condition. The host might act before the virtual ITS fini=
shes
processing, leading to flaky test execution.

> +}
> +
> +static void gicv5_invalidate_its_event(u32 device_id, u32 event_id)
> +{
> +	u64 val;
> +
> +	val =3D FIELD_PREP(GICV5_ITS_DIDR_DEVICEID, device_id);
> +	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_DIDR);
> +
> +	val =3D FIELD_PREP(GICV5_ITS_EIDR_EVENTID, event_id);
> +	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_EIDR);
> +
> +	writel(GICV5_ITS_INV_EVENTR_I,
> +	       GICV5_ITS_BASE_GVA + GICV5_ITS_INV_EVENTR);

[Severity: High]
Should this function poll ITS_STATUSR IDLE after invalidating the event?

In gicv5_invalidate_its_event, the event invalidation command is issued
without a subsequent completion poll. The GICv5 guidelines state that an
ITS table entry invalidated without polling ITS_STATUSR IDLE is a bug, as
the host might act before the virtual ITS finishes processing the
invalidation.

> +}
> +
> +static void gicv5_invalidate_its_device(u32 device_id, u32 event_id_bits)
> +{
> +	u64 val;
> +
> +	val =3D FIELD_PREP(GICV5_ITS_DIDR_DEVICEID, device_id);
> +	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_DIDR);
> +
> +	val =3D GICV5_ITS_INV_DEVICER_I |
> +	      FIELD_PREP(GICV5_ITS_INV_DEVICER_EVENTID_BITS, event_id_bits);
> +	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_INV_DEVICER);

[Severity: High]
Similar to the event invalidation above, should gicv5_invalidate_its_device
wait for the device invalidation to complete by polling ITS_STATUSR IDLE
before returning? Failing to do so can race with the host side.

> +}

[ ... ]

> +static void guest_its_irq_handler(struct ex_regs *regs)
> +{
> +	u64 expected_hwirq =3D gicv5_lpi_hwirq(READ_ONCE(its_expected_lpi));
> +	u32 hwirq;
> +	u64 ia;
> +
> +	ia =3D gicr_insn(CDIA);
> +	if (!GICV5_GICR_CDIA_VALID(ia))
> +		return;
> +
> +	gsb_ack();
> +	isb();
> +
> +	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
> +	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
> +
> +	gic_insn(hwirq, CDDI);
> +	gic_insn(0, CDEOI);

[Severity: High]
Can we separate the priority drop from the deactivation in this handler?

In guest_its_irq_handler, the priority drop instruction (CDEOI) is
executed back-to-back with deactivation (CDDI) at the end of the handler.
The GICv5 architecture strictly enforces a split-EOI model where the
priority drop must be performed immediately after the acknowledge and
synchronization barriers, before dispatching to the main handler logic.

Deferring the priority drop until the end blocks all interrupts of equal
or lower priority for the handler's duration.

> +
> +	GUEST_SYNC(GUEST_CMD_ITS_LPI_DELIVERED);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D15

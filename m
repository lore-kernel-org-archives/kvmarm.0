Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645349;
	b=nBqX2OOxpbdF3+dKGbI6eAbWYEbcNF4vhLHtMFGjgZp6UMjeYCBP3zj+7KbMf+YpBtA3
	 E39xqfwmZNHHzHFba98X+aigCnwWLikbsZ6rmn589MhtL6hC13+E1M2nBenP2kZqqC1cg
	 mlML/xo7L6/C+ib5C7WVIKnH24uVBh1GkAXOLjnxIyIguUzz152SVowf1WJW8d+JmA1A/
	 ejAv+jV6hRXsNLTkC5ApswH8tWA9PiTLxtgScZKh92TQ0b2c8AGn+yDQiXW6nWAGYQZGQ
	 Q2RUVEbvKoOm/01y5HKRMBi209fvsmUTiH7kVeNpjOQ2J0dZNMx3xliPbbCDh2kbxZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645349;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=n7o3SIXEgY1AZum4i/LM2rBPqStfgk/ecjxWJ8N54rk=;
	b=MWdytq46H8spyoLtdOs1+D31pFnVXO46mzbxDx4mq7kuWUHEZjF2ro8wpnTi3fWd47HF
	 hBiXvTxHtIEUJQR92rTwHhNx/SHurKgjEUH2mEj+wpwmF3EqDCYtfgnj4AqqWu1yP0YUt
	 BVPZO0VonxcGzppt9dClK2CdlUNBPsaDD+UwSTKzeuLhkwee3Ye04QM7Seuf6FKUzd/VN
	 4G9e4YMZJpXzlQT9AP19uQPOOGkURuzcI/4RcMGy2LXnyKudCszNfSOgcKI2Boolf/+KG
	 UIU9GlB2VkuR0Q+TNJmWH647uoN9jVg7YcTdDVgDHT6BzSwW9OvXJtd7ZSRWI0PYuCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GTQZT+v7;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4005C606A326;
	Mon,  2 Nov 2026 18:49:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4005C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GTQZT+v7
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27D9A1FC4;
	Mon,  2 Nov 2026 10:49:05 -0800 (PST)
Received: from [10.57.89.36] (unknown [10.57.89.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F10E3F673;
	Mon,  2 Nov 2026 10:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793645348; bh=Pcr+BiS/TLBeuOURNXAbQTQWOpwhSvgvlq1SaHDLKY4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GTQZT+v7sl58fUyY76BbeAlLMUzHOqQXEPs8V26JNeZ9hmG0NOrkaKsv5gXVrdVH9
	 AvgYyHJulEjKyOJsu6ERrGMIOZMRKwyeNnYcPjdxCSv2JNcgRokd8O86LvpT5r7aoI
	 SVdiJc8TPbLulskPQSxuKJRU2CKGLofIf1zY3bLY=
Message-ID: <1d2ad2f1-90bc-419f-9be3-176edc0472cb@arm.com>
Date: Mon, 2 Nov 2026 18:49:05 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/16] KVM: selftests: Add VGICv5 ITS translation cache
 tests
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-16-sascha.bischoff@arm.com>
 <sashiko-outbox-174630@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174630@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 17:22, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] vgic_v5: missing ITS_STATUSR/ITS_GEN_EVENT_STATUSR completion poll
> - [High] vgic_v5: priority drop coupled with deactivation in ITS IRQ handler
> --
> 
> commit fe8f40c11d68589dddb7ff395093f6a131cf59d8
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> KVM: selftests: Add VGICv5 ITS translation cache tests
> 
> This commit adds end-to-end coverage for VGICv5 ITS translation and cache
> invalidation. It verifies that KVM can parse guest-provided linear DT and
> ITT state and use it to deliver LPIs through guest GEN_EVENTR and
> KVM_SIGNAL_MSI. The test builds a two-VPE VM with IRS, ITS, and an LPI IST.
> 
>> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/selftests/kvm/arm64/vgic_v5.c
>> index b7fb002a64f6c..6ea6aef4f0f46 100644
>> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
>> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
> 
> [ ... ]
> 
>> +/* Inject a manually triggered translation via the ITS_GEN_EVENTR */
>> +static void gicv5_send_its_gen_event(u32 device_id, u32 event_id)
>> +{
>> +	u64 val;
>> +
>> +	val = FIELD_PREP(GICV5_ITS_GEN_EVENT_DIDR_DEVICEID, device_id);
>> +	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_GEN_EVENT_DIDR);
>> +
>> +	val = FIELD_PREP(GICV5_ITS_GEN_EVENT_EIDR_EVENTID, event_id);
>> +	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_GEN_EVENT_EIDR);
>> +
>> +	writel(GICV5_ITS_GEN_EVENTR_R |
>> +	       FIELD_PREP(GICV5_ITS_GEN_EVENTR_TARGET_DOMAIN, 0),
>> +	       GICV5_ITS_BASE_GVA + GICV5_ITS_GEN_EVENTR);
> 
> [Severity: High]
> Does this operation require polling for completion? In gicv5_send_its_gen_event,
> the event generation command is issued asynchronously by writing to
> GICV5_ITS_GEN_EVENTR without a subsequent poll of the ITS_GEN_EVENT_STATUSR
> IDLE bit.
> 
> Since the test subsequently yields to the host via GUEST_SYNC and expects the
> event to be delivered, failing to wait for the virtual hardware to complete
> introduces a race condition. The host might act before the virtual ITS finishes
> processing, leading to flaky test execution.

The virtual GEN_EVENTR handler resolves the translation and issues 
VDPEND before the trapped write returns; the receiving vCPU then waits 
for the interrupt handler's GUEST_SYNC. The virtual status register 
always reads idle, so I've left out a poll that would add no ordering.

This isn't an issue, so I've not changed anything.

> 
>> +}
>> +
>> +static void gicv5_invalidate_its_event(u32 device_id, u32 event_id)
>> +{
>> +	u64 val;
>> +
>> +	val = FIELD_PREP(GICV5_ITS_DIDR_DEVICEID, device_id);
>> +	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_DIDR);
>> +
>> +	val = FIELD_PREP(GICV5_ITS_EIDR_EVENTID, event_id);
>> +	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_EIDR);
>> +
>> +	writel(GICV5_ITS_INV_EVENTR_I,
>> +	       GICV5_ITS_BASE_GVA + GICV5_ITS_INV_EVENTR);
> 
> [Severity: High]
> Should this function poll ITS_STATUSR IDLE after invalidating the event?
> 
> In gicv5_invalidate_its_event, the event invalidation command is issued
> without a subsequent completion poll. The GICv5 guidelines state that an
> ITS table entry invalidated without polling ITS_STATUSR IDLE is a bug, as
> the host might act before the virtual ITS finishes processing the
> invalidation.

KVM removes the cached translation before the virtual INV_EVENTR write 
returns (similar to the case above), and the following GUEST_SYNC 
precedes the host's next MSI. Again, the status register always reads 
idle, so I've left this test unchanged.

If we want the selftests to be proper reference code, I am happy to 
change this, but I don't see much of a point in polling state that we 
know the state of in this case.

> 
>> +}
>> +
>> +static void gicv5_invalidate_its_device(u32 device_id, u32 event_id_bits)
>> +{
>> +	u64 val;
>> +
>> +	val = FIELD_PREP(GICV5_ITS_DIDR_DEVICEID, device_id);
>> +	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_DIDR);
>> +
>> +	val = GICV5_ITS_INV_DEVICER_I |
>> +	      FIELD_PREP(GICV5_ITS_INV_DEVICER_EVENTID_BITS, event_id_bits);
>> +	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_INV_DEVICER);
> 
> [Severity: High]
> Similar to the event invalidation above, should gicv5_invalidate_its_device
> wait for the device invalidation to complete by polling ITS_STATUSR IDLE
> before returning? Failing to do so can race with the host side.

And this is the third one of these. The virtual INV_DEVICER write 
removes matching cached translations before returning, and the host acts 
only after GUEST_SYNC. I've left out the status poll because it nothing 
in this case.

> 
>> +}
> 
> [ ... ]
> 
>> +static void guest_its_irq_handler(struct ex_regs *regs)
>> +{
>> +	u64 expected_hwirq = gicv5_lpi_hwirq(READ_ONCE(its_expected_lpi));
>> +	u32 hwirq;
>> +	u64 ia;
>> +
>> +	ia = gicr_insn(CDIA);
>> +	if (!GICV5_GICR_CDIA_VALID(ia))
>> +		return;
>> +
>> +	gsb_ack();
>> +	isb();
>> +
>> +	hwirq = FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
>> +	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
>> +
>> +	gic_insn(hwirq, CDDI);
>> +	gic_insn(0, CDEOI);
> 
> [Severity: High]
> Can we separate the priority drop from the deactivation in this handler?
> 
> In guest_its_irq_handler, the priority drop instruction (CDEOI) is
> executed back-to-back with deactivation (CDDI) at the end of the handler.
> The GICv5 architecture strictly enforces a split-EOI model where the
> priority drop must be performed immediately after the acknowledge and
> synchronization barriers, before dispatching to the main handler logic.
> 
> Deferring the priority drop until the end blocks all interrupts of equal
> or lower priority for the handler's duration.

The architecture permits software to choose the order of GIC CDEOI and 
GIC CDDI - they are explicitly split for that exact reason. It might be 
that software wants to deactivate before doing the priority drop, or it 
might want to drop the priority before deactivating. That's for software 
to decide and use as required.

This handler has no interrupt nesting requirement, so keeping the 
priority active until its end is prefectly valid. I've left the handler 
unchanged.

> 
>> +
>> +	GUEST_SYNC(GUEST_CMD_ITS_LPI_DELIVERED);
>> +}
> 

Thanks,
Sascha

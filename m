Return-Path: <SRS0=tVNh=FB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E52DC3E8C5
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 19:36:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E2B624137
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 19:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="aS2EkXcF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E2B624137
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB88C4B26B;
	Fri, 27 Nov 2020 14:35:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NK2tWLZmuc6N; Fri, 27 Nov 2020 14:35:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5920A4B27D;
	Fri, 27 Nov 2020 14:35:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14EC44B27D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 14:35:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a6fDRDqwfkCZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2020 14:35:55 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9A584B26B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 14:35:55 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7EAEA23A65;
 Fri, 27 Nov 2020 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606505754;
 bh=qAyiJMDugLMVaAz3cNXZ59D9GoVbVfoHSqH6nkCL8t8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=aS2EkXcFqYDXG/sZZ0mUsKhj6P03SHRr3gHBzmtQ8j6eKqgO9eiF3KV227EyPrK0w
 GibP7bAywkj9dOm8w+KvOgCflrle6xD2BYIp0b0G/dmcmWY7o0YhISYgRsCscxDKw5
 ljLqzH1Pu7W1pU+Wk+sWFe+6pIVyGNN0mb1tq2yQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kijX6-00E92T-7y; Fri, 27 Nov 2020 19:35:52 +0000
MIME-Version: 1.0
Date: Fri, 27 Nov 2020 19:35:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [PATCH] irqchip/gic-v4.1: Optimize the wait for the completion of
 the analysis of the VPT
In-Reply-To: <20200923063543.1920-1-lushenming@huawei.com>
References: <20200923063543.1920-1-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7d0c6bfe7485094154a05bfb2de03640@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, tglx@linutronix.de,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, eric.auger@redhat.com, christoffer.dall@arm.com,
 wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Shenming,

Somehow this patch ended up in the wrong folder.
Apologies for the delay reviewing it.

On 2020-09-23 07:35, Shenming Lu wrote:
> Right after a vPE is made resident, the code starts polling the
> GICR_VPENDBASER.Dirty bit until it becomes 0, where the delay_us
> is set to 10. But in our measurement, it takes only hundreds of
> nanoseconds, or 1~2 microseconds, to finish parsing the VPT in most
> cases. And we also measured the time from vcpu_load() (include it)
> to __guest_enter() on Kunpeng 920. On average, it takes 2.55 
> microseconds
> (not first run && the VPT is empty). So 10 microseconds delay might
> really hurt performance.
> 
> To avoid this, we can set the delay_us to 1, which is more appropriate
> in this situation and universal. Besides, we can delay the execution
> of its_wait_vpt_parse_complete() (call it from kvm_vgic_flush_hwstate()
> corresponding to vPE resident), giving the GIC a chance to work in
> parallel with the CPU on the entry path.
> 
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v4.c      | 18 ++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.c         |  2 ++
>  drivers/irqchip/irq-gic-v3-its.c   | 14 +++++++++++---
>  drivers/irqchip/irq-gic-v4.c       | 11 +++++++++++
>  include/kvm/arm_vgic.h             |  3 +++
>  include/linux/irqchip/arm-gic-v4.h |  4 ++++
>  6 files changed, 49 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c 
> b/arch/arm64/kvm/vgic/vgic-v4.c
> index b5fa73c9fd35..1d5d2d6894d3 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -353,6 +353,24 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
>  	return err;
>  }
> 
> +void vgic_v4_wait_vpt(struct kvm_vcpu *vcpu)

I'd like something a bit more abstract as a name.

vgic_v4_commit() seems more appropriate, and could be used for other
purposes.

> +{
> +	struct its_vpe *vpe;
> +
> +	if (kvm_vgic_global_state.type == VGIC_V2 ||

Why do you test for GICv2? Isn't the vgic_supports_direct_msis() test 
enough?
And the test should be moved to kvm_vgic_flush_hwstate(), as we already 
have
similar checks there.

> !vgic_supports_direct_msis(vcpu->kvm))
> +		return;
> +
> +	vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
> +
> +	if (vpe->vpt_ready)
> +		return;
> +
> +	if (its_wait_vpt(vpe))
> +		return;

How can that happen?

> +
> +	vpe->vpt_ready = true;

This is nasty. You need to explain what happens with this state (you are
trying not to access VPENDBASER across a shallow exit, as only a 
vcpu_put
will invalidate the GIC state). And something like vpe_ready is more
generic (we try not to have too much of the GICv4 gunk in the KVM code).

> +}
> +
>  static struct vgic_its *vgic_get_its(struct kvm *kvm,
>  				     struct kvm_kernel_irq_routing_entry *irq_entry)
>  {
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index c3643b7f101b..ed810a80cda2 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -915,6 +915,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
> 
>  	if (can_access_vgic_from_kernel())
>  		vgic_restore_state(vcpu);
> +
> +	vgic_v4_wait_vpt(vcpu);
>  }
> 
>  void kvm_vgic_load(struct kvm_vcpu *vcpu)
> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
> b/drivers/irqchip/irq-gic-v3-its.c
> index 548de7538632..b7cbc9bcab9d 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3803,7 +3803,7 @@ static void its_wait_vpt_parse_complete(void)
>  	WARN_ON_ONCE(readq_relaxed_poll_timeout_atomic(vlpi_base + 
> GICR_VPENDBASER,
>  						       val,
>  						       !(val & GICR_VPENDBASER_Dirty),
> -						       10, 500));
> +						       1, 500));

This really should be in a separate patch.

>  }
> 
>  static void its_vpe_schedule(struct its_vpe *vpe)
> @@ -3837,7 +3837,7 @@ static void its_vpe_schedule(struct its_vpe *vpe)
>  	val |= GICR_VPENDBASER_Valid;
>  	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
> 
> -	its_wait_vpt_parse_complete();
> +	vpe->vpt_ready = false;

This really belongs to the deschedule path, doesn't it? Given that
it can only be set from vgic_flush_hwstate(), it should be fairly
foolproof.

>  }
> 
>  static void its_vpe_deschedule(struct its_vpe *vpe)
> @@ -3881,6 +3881,10 @@ static int its_vpe_set_vcpu_affinity(struct
> irq_data *d, void *vcpu_info)
>  		its_vpe_schedule(vpe);
>  		return 0;
> 
> +	case WAIT_VPT:

COMMIT_VPE seems a better name.

> +		its_wait_vpt_parse_complete();
> +		return 0;
> +
>  	case DESCHEDULE_VPE:
>  		its_vpe_deschedule(vpe);
>  		return 0;
> @@ -4047,7 +4051,7 @@ static void its_vpe_4_1_schedule(struct its_vpe 
> *vpe,
> 
>  	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
> 
> -	its_wait_vpt_parse_complete();
> +	vpe->vpt_ready = false;
>  }
> 
>  static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
> @@ -4118,6 +4122,10 @@ static int its_vpe_4_1_set_vcpu_affinity(struct
> irq_data *d, void *vcpu_info)
>  		its_vpe_4_1_schedule(vpe, info);
>  		return 0;
> 
> +	case WAIT_VPT:
> +		its_wait_vpt_parse_complete();
> +		return 0;
> +
>  	case DESCHEDULE_VPE:
>  		its_vpe_4_1_deschedule(vpe, info);
>  		return 0;
> diff --git a/drivers/irqchip/irq-gic-v4.c 
> b/drivers/irqchip/irq-gic-v4.c
> index 0c18714ae13e..36be42569872 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -258,6 +258,17 @@ int its_make_vpe_resident(struct its_vpe *vpe,
> bool g0en, bool g1en)
>  	return ret;
>  }
> 
> +int its_wait_vpt(struct its_vpe *vpe)

its_commit_vpe()

> +{
> +	struct its_cmd_info info = { };
> +
> +	WARN_ON(preemptible());
> +
> +	info.cmd_type = WAIT_VPT;

Please write it as:

         struct its_cmd_info = {
                 .cmd_type = COMMIT_VPE,
         };

as for most of the commands.

> +
> +	return its_send_vpe_cmd(vpe, &info);
> +}
> +
>  int its_invall_vpe(struct its_vpe *vpe)
>  {
>  	struct its_cmd_info info = {
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index a8d8fdcd3723..b55a835d28a8 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -402,6 +402,9 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, 
> int irq,
>  				 struct kvm_kernel_irq_routing_entry *irq_entry);
> 
>  int vgic_v4_load(struct kvm_vcpu *vcpu);
> +
> +void vgic_v4_wait_vpt(struct kvm_vcpu *vcpu);
> +
>  int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
> 
>  #endif /* __KVM_ARM_VGIC_H */
> diff --git a/include/linux/irqchip/arm-gic-v4.h
> b/include/linux/irqchip/arm-gic-v4.h
> index 6976b8331b60..68ac2b7b9309 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -75,6 +75,8 @@ struct its_vpe {
>  	u16			vpe_id;
>  	/* Pending VLPIs on schedule out? */
>  	bool			pending_last;
> +	/* VPT parse complete */
> +	bool			vpt_ready;
>  };
> 
>  /*
> @@ -103,6 +105,7 @@ enum its_vcpu_info_cmd_type {
>  	PROP_UPDATE_VLPI,
>  	PROP_UPDATE_AND_INV_VLPI,
>  	SCHEDULE_VPE,
> +	WAIT_VPT,
>  	DESCHEDULE_VPE,
>  	INVALL_VPE,
>  	PROP_UPDATE_VSGI,
> @@ -128,6 +131,7 @@ struct its_cmd_info {
>  int its_alloc_vcpu_irqs(struct its_vm *vm);
>  void its_free_vcpu_irqs(struct its_vm *vm);
>  int its_make_vpe_resident(struct its_vpe *vpe, bool g0en, bool g1en);
> +int its_wait_vpt(struct its_vpe *vpe);
>  int its_make_vpe_non_resident(struct its_vpe *vpe, bool db);
>  int its_invall_vpe(struct its_vpe *vpe);
>  int its_map_vlpi(int irq, struct its_vlpi_map *map);

My comments are mostly cosmetic. If you can respin quickly, I'll
pick it up for 5.11.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

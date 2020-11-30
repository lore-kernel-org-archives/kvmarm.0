Return-Path: <SRS0=p1b3=FE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02414C64E7B
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 11:23:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40B562084C
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 11:23:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWqt3vc/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40B562084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 846434BC86;
	Mon, 30 Nov 2020 06:23:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id emxobGm7StGR; Mon, 30 Nov 2020 06:23:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5104C4BC94;
	Mon, 30 Nov 2020 06:23:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D75B14BC86
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 06:23:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6wQ5GqEf+Ijb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2020 06:23:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B8B94BC78
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 06:23:00 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D591A206C0;
 Mon, 30 Nov 2020 11:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606735379;
 bh=C/tX+/xIQfu/l2jRe/mauR07nHMptQk9G3sfbmqUn8c=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=SWqt3vc/2cb79JBviuv/tQctBHNF+l8ewM82n7RLPlThwl4d1/P1CH+bo0ypQO+82
 8CvtbVDyF2V2NQ72uub1BXGMk/PzVqrXve5FTO2drRb6hisUQHAiDvpWVjcT3js/0s
 ThB8ZxfOC/I+RCflReXiFXtp4lF8G8Q7p/rI5O7g=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kjhGi-00EfQ1-Jk; Mon, 30 Nov 2020 11:22:56 +0000
MIME-Version: 1.0
Date: Mon, 30 Nov 2020 11:22:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Delay the execution of the polling on
 the GICR_VPENDBASER.Dirty bit
In-Reply-To: <20201128141857.983-3-lushenming@huawei.com>
References: <20201128141857.983-1-lushenming@huawei.com>
 <20201128141857.983-3-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b2387410a28f9c5d9ece45e12feead94@kernel.org>
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

On 2020-11-28 14:18, Shenming Lu wrote:
> In order to further reduce the impact of the wait delay of the
> VPT analysis, we can delay the execution of the polling on the
> GICR_VPENDBASER.Dirty bit (call it from kvm_vgic_flush_hwstate()
> corresponding to vPE resident), let the GIC and the CPU work in
> parallel on the entry path.
> 
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v4.c      | 16 ++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.c         |  3 +++
>  drivers/irqchip/irq-gic-v3-its.c   | 16 ++++++++++++----
>  drivers/irqchip/irq-gic-v4.c       | 11 +++++++++++
>  include/kvm/arm_vgic.h             |  3 +++
>  include/linux/irqchip/arm-gic-v4.h |  4 ++++
>  6 files changed, 49 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c 
> b/arch/arm64/kvm/vgic/vgic-v4.c
> index b5fa73c9fd35..b0da74809187 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -353,6 +353,22 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
>  	return err;
>  }
> 
> +void vgic_v4_commit(struct kvm_vcpu *vcpu)
> +{
> +	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
> +
> +	/*
> +	 * No need to wait for the vPE to be ready across a shallow guest
> +	 * exit, as only a vcpu_put will invalidate it.
> +	 */
> +	if (vpe->vpe_ready)
> +		return;
> +
> +	its_commit_vpe(vpe);
> +
> +	vpe->vpe_ready = true;

This should be written as:

if (!ready)
      commit();

and ready being driven by the commit() call itself.

> +}
> +
>  static struct vgic_its *vgic_get_its(struct kvm *kvm,
>  				     struct kvm_kernel_irq_routing_entry *irq_entry)
>  {
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index c3643b7f101b..1c597c9885fa 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -915,6 +915,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
> 
>  	if (can_access_vgic_from_kernel())
>  		vgic_restore_state(vcpu);
> +
> +	if (vgic_supports_direct_msis(vcpu->kvm))
> +		vgic_v4_commit(vcpu);
>  }
> 
>  void kvm_vgic_load(struct kvm_vcpu *vcpu)
> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
> b/drivers/irqchip/irq-gic-v3-its.c
> index 22f427135c6b..f30aba14933e 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3842,8 +3842,6 @@ static void its_vpe_schedule(struct its_vpe *vpe)
>  	val |= vpe->idai ? GICR_VPENDBASER_IDAI : 0;
>  	val |= GICR_VPENDBASER_Valid;
>  	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
> -
> -	its_wait_vpt_parse_complete();
>  }
> 
>  static void its_vpe_deschedule(struct its_vpe *vpe)
> @@ -3855,6 +3853,8 @@ static void its_vpe_deschedule(struct its_vpe 
> *vpe)
> 
>  	vpe->idai = !!(val & GICR_VPENDBASER_IDAI);
>  	vpe->pending_last = !!(val & GICR_VPENDBASER_PendingLast);
> +
> +	vpe->vpe_ready = false;

This should be set from the its_make_vpe_non_resident() call.

>  }
> 
>  static void its_vpe_invall(struct its_vpe *vpe)
> @@ -3891,6 +3891,10 @@ static int its_vpe_set_vcpu_affinity(struct
> irq_data *d, void *vcpu_info)
>  		its_vpe_deschedule(vpe);
>  		return 0;
> 
> +	case COMMIT_VPE:
> +		its_wait_vpt_parse_complete();
> +		return 0;
> +
>  	case INVALL_VPE:
>  		its_vpe_invall(vpe);
>  		return 0;
> @@ -4052,8 +4056,6 @@ static void its_vpe_4_1_schedule(struct its_vpe 
> *vpe,
>  	val |= FIELD_PREP(GICR_VPENDBASER_4_1_VPEID, vpe->vpe_id);
> 
>  	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
> -
> -	its_wait_vpt_parse_complete();
>  }
> 
>  static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
> @@ -4091,6 +4093,8 @@ static void its_vpe_4_1_deschedule(struct its_vpe 
> *vpe,
>  					    GICR_VPENDBASER_PendingLast);
>  		vpe->pending_last = true;
>  	}
> +
> +	vpe->vpe_ready = false;
>  }
> 
>  static void its_vpe_4_1_invall(struct its_vpe *vpe)
> @@ -4128,6 +4132,10 @@ static int its_vpe_4_1_set_vcpu_affinity(struct
> irq_data *d, void *vcpu_info)
>  		its_vpe_4_1_deschedule(vpe, info);
>  		return 0;
> 
> +	case COMMIT_VPE:
> +		its_wait_vpt_parse_complete();
> +		return 0;
> +
>  	case INVALL_VPE:
>  		its_vpe_4_1_invall(vpe);
>  		return 0;
> diff --git a/drivers/irqchip/irq-gic-v4.c 
> b/drivers/irqchip/irq-gic-v4.c
> index 0c18714ae13e..6cea71a4e68b 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -258,6 +258,17 @@ int its_make_vpe_resident(struct its_vpe *vpe,
> bool g0en, bool g1en)
>  	return ret;
>  }
> 
> +int its_commit_vpe(struct its_vpe *vpe)
> +{
> +	struct its_cmd_info info = {
> +		.cmd_type = COMMIT_VPE,
> +	};
> +
> +	WARN_ON(preemptible());
> +
> +	return its_send_vpe_cmd(vpe, &info);
> +}
> +
>  int its_invall_vpe(struct its_vpe *vpe)
>  {
>  	struct its_cmd_info info = {
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index a8d8fdcd3723..f2170df6cf7c 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -401,7 +401,10 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, 
> int irq,
>  int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>  				 struct kvm_kernel_irq_routing_entry *irq_entry);
> 
> +void vgic_v4_commit(struct kvm_vcpu *vcpu);
> +
>  int vgic_v4_load(struct kvm_vcpu *vcpu);
> +

Spurious new lines.

>  int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
> 
>  #endif /* __KVM_ARM_VGIC_H */
> diff --git a/include/linux/irqchip/arm-gic-v4.h
> b/include/linux/irqchip/arm-gic-v4.h
> index 6976b8331b60..936d88e482a9 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -75,6 +75,8 @@ struct its_vpe {
>  	u16			vpe_id;
>  	/* Pending VLPIs on schedule out? */
>  	bool			pending_last;
> +	/* VPT parse complete */
> +	bool			vpe_ready;
>  };
> 
>  /*
> @@ -104,6 +106,7 @@ enum its_vcpu_info_cmd_type {
>  	PROP_UPDATE_AND_INV_VLPI,
>  	SCHEDULE_VPE,
>  	DESCHEDULE_VPE,
> +	COMMIT_VPE,
>  	INVALL_VPE,
>  	PROP_UPDATE_VSGI,
>  };
> @@ -129,6 +132,7 @@ int its_alloc_vcpu_irqs(struct its_vm *vm);
>  void its_free_vcpu_irqs(struct its_vm *vm);
>  int its_make_vpe_resident(struct its_vpe *vpe, bool g0en, bool g1en);
>  int its_make_vpe_non_resident(struct its_vpe *vpe, bool db);
> +int its_commit_vpe(struct its_vpe *vpe);
>  int its_invall_vpe(struct its_vpe *vpe);
>  int its_map_vlpi(int irq, struct its_vlpi_map *map);
>  int its_get_vlpi(int irq, struct its_vlpi_map *map);

In order to speed up the respin round-trip, I've taken the liberty
to refactor this patch myself. Please have a look at [1] and let
me know if you're OK with it.

Thanks,

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/misc-5.11&id=57e3cebd022fbc035dcf190ac789fd2ffc747f5b
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

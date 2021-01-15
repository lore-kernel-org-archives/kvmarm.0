Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6F5C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 14:08:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3FF9F23884
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 14:08:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FF9F23884
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D22394B1E2;
	Fri, 15 Jan 2021 09:08:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PZA47HHlQsY9; Fri, 15 Jan 2021 09:08:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFC9E4B1ED;
	Fri, 15 Jan 2021 09:08:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E26B84B1E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:08:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id USTQcfFVEhmB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 09:08:26 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC2104B1E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:08:26 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A8F2238E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 14:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1610719705;
 bh=L2laqXnYHrBuln6Ua+OUT6XchYLEf2Sn3jxjOMy8M8E=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=hajhTvJXBEyX7OXfAt5vrA5Ge+rtK1gA5EWlQ9J6YrgpTI6wpM3gkJHr5tsDB1S5h
 sGGu1KKyJ4yAWUCi6+Pp/qEBjgiU/RoEvyeUcd7Cr5TG3wOgD9mBzUK06HHzoGuG7L
 OgXC00mMIIfP5yeUOPshEja8ir3wititCdOWa3lco8cuR+trF0kTl8Un019TFeX62T
 8n6d2D933B5PVrxot3e5xYhoCkCMLoLy2JD11iPTJtdHdV2BsvQkVKuGMK6hbMvqpb
 LV+Tk6C+9AqLBlYOt8c/sLKaqysg4AaBrj/xOJRKZYJowgdHu7xnwxAtkxSBxUHPGX
 sLr+p5ypJFsSg==
Received: by mail-oi1-f171.google.com with SMTP id d203so9663421oia.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 06:08:25 -0800 (PST)
X-Gm-Message-State: AOAM5331ar32UVHQfpmXFHFU0LNp2axtZZze+E0MdbNZEhiCt1u35tJ9
 h0Fv77OVejVbb+7ZisK+gD5Mv0aY3OdwqUuYbrM=
X-Google-Smtp-Source: ABdhPJwdqaYEdo36QPp66mdnnEyEBVoJxTd0NWecEHmuy4hAxFaUxXynfOSVOOjDzbZjgHcYeDisgqf3W/misoGR8h8=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr5771727oig.33.1610719704883; 
 Fri, 15 Jan 2021 06:08:24 -0800 (PST)
MIME-Version: 1.0
References: <20210115140323.2682634-1-maz@kernel.org>
 <20210115140323.2682634-3-maz@kernel.org>
In-Reply-To: <20210115140323.2682634-3-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 15 Jan 2021 15:08:13 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHEMpypq54Vxr+JgL9b_zoj_y2azK3mgAhXhnXO6Bhygw@mail.gmail.com>
Message-ID: <CAMj1kXHEMpypq54Vxr+JgL9b_zoj_y2azK3mgAhXhnXO6Bhygw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Workaround firmware wrongly
 advertising GICv2-on-v3 compatibility
To: Marc Zyngier <maz@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, 15 Jan 2021 at 15:03, Marc Zyngier <maz@kernel.org> wrote:
>
> It looks like we have broken firmware out there that wrongly advertises
> a GICv2 compatibility interface, despite the CPUs not being able to deal
> with it.
>
> To work around this, check that the CPU initialising KVM is actually able
> to switch to MMIO instead of system registers, and use that as a
> precondition to enable GICv2 compatibility in KVM.
>
> Note that the detection happens on a single CPU. If the firmware is
> lying *and* that the CPUs are asymetric, all hope is lost anyway.
>
> Reported-by: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 35 +++++++++++++++++++++++++++++++--
>  arch/arm64/kvm/vgic/vgic-v3.c   |  8 ++++++--
>  2 files changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 005daa0c9dd7..ee3682b9873c 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -408,11 +408,42 @@ void __vgic_v3_init_lrs(void)
>  /*
>   * Return the GIC CPU configuration:
>   * - [31:0]  ICH_VTR_EL2
> - * - [63:32] RES0
> + * - [62:32] RES0
> + * - [63]    MMIO (GICv2) capable
>   */
>  u64 __vgic_v3_get_gic_config(void)
>  {
> -       return read_gicreg(ICH_VTR_EL2);
> +       u64 val, sre = read_gicreg(ICC_SRE_EL1);
> +       unsigned long flags = 0;
> +
> +       /*
> +        * To check whether we have a MMIO-based (GICv2 compatible)
> +        * CPU interface, we need to disable the system register
> +        * view. To do that safely, we have to prevent any interrupt
> +        * from firing (which would be deadly).
> +        *
> +        * Note that this only makes sense on VHE, as interrupts are
> +        * already masked for nVHE as part of the exception entry to
> +        * EL2.
> +        */
> +       if (has_vhe())
> +               flags = local_daif_save();
> +
> +       write_gicreg(0, ICC_SRE_EL1);
> +       isb();
> +
> +       val = read_gicreg(ICC_SRE_EL1);
> +
> +       write_gicreg(sre, ICC_SRE_EL1);
> +       isb();
> +
> +       if (has_vhe())
> +               local_daif_restore(flags);
> +
> +       val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
> +       val |= read_gicreg(ICH_VTR_EL2);
> +
> +       return val;
>  }
>
>  u64 __vgic_v3_read_vmcr(void)
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 8e7bf3151057..67b27b47312b 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -584,8 +584,10 @@ early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
>  int vgic_v3_probe(const struct gic_kvm_info *info)
>  {
>         u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
> +       bool has_v2;
>         int ret;
>
> +       has_v2 = ich_vtr_el2 >> 63;
>         ich_vtr_el2 = (u32)ich_vtr_el2;
>
>         /*
> @@ -605,13 +607,15 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>                          gicv4_enable ? "en" : "dis");
>         }
>
> +       kvm_vgic_global_state.vcpu_base = 0;
> +
>         if (!info->vcpu.start) {
>                 kvm_info("GICv3: no GICV resource entry\n");
> -               kvm_vgic_global_state.vcpu_base = 0;
> +       } else if (!has_v2) {
> +               pr_warn("CPU interface incapable of MMIO access\n");

Could we include FW_BUG here to stress that this is a firmware problem?

>         } else if (!PAGE_ALIGNED(info->vcpu.start)) {
>                 pr_warn("GICV physical address 0x%llx not page aligned\n",
>                         (unsigned long long)info->vcpu.start);
> -               kvm_vgic_global_state.vcpu_base = 0;
>         } else {
>                 kvm_vgic_global_state.vcpu_base = info->vcpu.start;
>                 kvm_vgic_global_state.can_emulate_gicv2 = true;
> --
> 2.29.2
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

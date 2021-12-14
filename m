Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77977C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 07:23:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA54A4B1F1;
	Tue, 14 Dec 2021 02:23:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d4sQ5bQH6B+8; Tue, 14 Dec 2021 02:23:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D38734B217;
	Tue, 14 Dec 2021 02:23:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11EA24B213
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 02:23:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AW+bHc004rLY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 02:23:51 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C65DB4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 02:23:51 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id
 nh10-20020a17090b364a00b001a69adad5ebso15382205pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 23:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Fxfb29GWggGEpzdwEa4V/YjcbFbmZfWcW/7RyGW59oo=;
 b=BZmaX5HEijb0yxVT6+M0Wi/IUyFZEf1LtAynj2B3PqJC/UfeW8zX+xv+OtFRif92Gl
 vRjdcO5jZCwqYLyi0wK1HptNa1U1skLGhwsdppZhCYtyU6YC0mgmQwTyjNnWL+L4Aiin
 Mw2wAxVVeO7+6TS67qNSSFJnMnMvDCfno3Z99QzrgpMiydveiEKCzUXlu8Z/2fAeDFQM
 R+ooTL6KKFPJmLeVqG6Ctowz36JI9IxGVtQsOhRsJvEqM5jNACx5+0dqDoMsTXwODkLL
 DPaWVculpXuQFc78iSPZaRagG5MeQGvfIv24xSs1LXm0RNiXq/pGaC215pMR4ADcUCPt
 psbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Fxfb29GWggGEpzdwEa4V/YjcbFbmZfWcW/7RyGW59oo=;
 b=7YNASmiqjDYPuzaqv23maZlh49OgSv4zY/9WWYXpORo8Ih8Ekv9/44uG2Wb3GbFwmc
 ICDLtdv+KO+MohXbJptNpTExHyqaM0Dfmtv3bsZxuP6QV36o8iJ/hTXdz+d/jKxkqC4i
 3esk3TSbva8zC8z322LVlRmXKn5QTZXgtRV4NQSENv6w5AYmzPIbmi7wYetaTfUhQ/Jv
 aWF2NqroIjHAdkZtaFe6tEO3es83VyV5q6+ivosGn9ZiAAShAMS5lgK3dLueLY6AhokQ
 mmzoD9UNfcrzdzhgUVNyzWnGM0Zqt2euzvcGupVXBnPz5I44QGayGyLieM712dfKJNPR
 8/1w==
X-Gm-Message-State: AOAM531M/2acWiY430Ri2OQEo6vhE3dAwZ/uXwyghoU5RMdpK15z/ycl
 La2M81TPZrkv+71PXujMvMGMF4MOJd/vJMKPBUr8X4hP9Te38Q==
X-Google-Smtp-Source: ABdhPJyPVMvQ7LNtAMHntKQQIhIHFF7dDEGbB8KAhBFiKcDWLekfOMnek+R9ZWyehwkQIA9M/7k4Pv/iQiAenT9RYqM=
X-Received: by 2002:a17:90b:380d:: with SMTP id
 mq13mr3780457pjb.110.1639466630716; 
 Mon, 13 Dec 2021 23:23:50 -0800 (PST)
MIME-Version: 1.0
References: <20211213152309.158462-1-alexandru.elisei@arm.com>
 <20211213152309.158462-3-alexandru.elisei@arm.com>
In-Reply-To: <20211213152309.158462-3-alexandru.elisei@arm.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 13 Dec 2021 23:23:34 -0800
Message-ID: <CAAeT=FyxN015zVC+xJbD8L6iE=zMhXts7_vvOuVLfeN-wF0eLg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] KVM: arm64: Keep a list of probed PMUs
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, mingo@redhat.com, tglx@linutronix.de, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Alex,

On Mon, Dec 13, 2021 at 7:23 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> The ARM PMU driver calls kvm_host_pmu_init() after probing to tell KVM that
> a hardware PMU is available for guest emulation. Heterogeneous systems can
> have more than one PMU present, and the callback gets called multiple
> times, once for each of them. Keep track of all the PMUs available to KVM,
> as they're going to be needed later.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 25 +++++++++++++++++++++++--
>  include/kvm/arm_pmu.h     |  5 +++++
>  2 files changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index a5e4bbf5e68f..eb4be96f144d 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -7,6 +7,7 @@
>  #include <linux/cpu.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
> +#include <linux/list.h>
>  #include <linux/perf_event.h>
>  #include <linux/perf/arm_pmu.h>
>  #include <linux/uaccess.h>
> @@ -14,6 +15,9 @@
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_vgic.h>
>
> +static LIST_HEAD(arm_pmus);
> +static DEFINE_MUTEX(arm_pmus_lock);
> +
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
>  static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx);
>  static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> @@ -742,9 +746,26 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>
>  void kvm_host_pmu_init(struct arm_pmu *pmu)
>  {
> -       if (pmu->pmuver != 0 && pmu->pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
> -           !kvm_arm_support_pmu_v3() && !is_protected_kvm_enabled())
> +       struct arm_pmu_entry *entry;
> +
> +       if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF ||
> +           is_protected_kvm_enabled())
> +               return;
> +
> +       mutex_lock(&arm_pmus_lock);
> +
> +       entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> +       if (!entry)
> +               goto out_unlock;

It might be better to get the lock after the kmalloc above is done ?
(the kmalloc might sleep, which will make the code hold the lock longer)
I don't think the current code will cause any problem though.

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji


> +
> +       if (list_empty(&arm_pmus))
>                 static_branch_enable(&kvm_arm_pmu_available);
> +
> +       entry->arm_pmu = pmu;
> +       list_add_tail(&entry->entry, &arm_pmus);
> +
> +out_unlock:
> +       mutex_unlock(&arm_pmus_lock);
>  }
>
>  static int kvm_pmu_probe_pmuver(void)
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 90f21898aad8..e249c5f172aa 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -36,6 +36,11 @@ struct kvm_pmu {
>         struct irq_work overflow_work;
>  };
>
> +struct arm_pmu_entry {
> +       struct list_head entry;
> +       struct arm_pmu *arm_pmu;
> +};
> +
>  #define kvm_arm_pmu_irq_initialized(v) ((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

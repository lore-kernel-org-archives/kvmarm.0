Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C338ECAAA3
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 04:34:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D10794E4E3;
	Fri, 26 Aug 2022 00:34:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NZhlgZtnDii8; Fri, 26 Aug 2022 00:34:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 894294E4E5;
	Fri, 26 Aug 2022 00:34:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D17C84E4D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 00:34:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o2MJfAtP4YT6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Aug 2022 00:34:17 -0400 (EDT)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com
 [209.85.222.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 925ED4E2A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 00:34:17 -0400 (EDT)
Received: by mail-ua1-f52.google.com with SMTP id i11so163327ual.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 21:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=4Hu0rO8zG72NHJho0aO6SAbm6Tq2VbIsxhqXb5H0q+o=;
 b=jX/fbSZgb102YlcVtGLQfgdzgGnMYamLbssIUN/GEPTAszBrleoBMFtyL240p5mHv0
 h2xxtWr8VA45O2ritPAxrh9MfAMooSJESzldSjhPJ2mu6s17jyuTRjwvWikq+p9uKXt7
 nyY/uVy4Dau4rwCkxnQSEtfdySr+pdT2ktasBzYTYYPbx9/kuMBPCBWidRaojMuZ3iaU
 u/hbIqBQdJHJ7hzXv3BzauJYGQgJPpdAuOE0fKOrdMe6VlOg2SlopZzODgy9epMordPY
 eqNFcW8Lkjb00Xc/6drZAeIV13aclpnoewJ9+qOnT6QlJCXSJ9iRmuYKQx+yRRfpY9G6
 AKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=4Hu0rO8zG72NHJho0aO6SAbm6Tq2VbIsxhqXb5H0q+o=;
 b=GaDFc4B+uHG03ngSmlaMi0b7dGGOXEe34UZBC6ZlXAj49kz2NmnL/F/RzUAXsho8Aj
 DBoLyN5D6w8CNqXqx1DphsIWiCwDK8pXFfbeQdvgANDYpe6Masr+l44ymtU2yPPnNY1C
 ysvrN7Pk3C2/A34HqSsGRNAPoNt+JRwqTtjuUuJ3DVlRFKFIgUpR4js3ooi1R0wyO+dr
 WoPNNeY7zI88xwUOfBtw8TNFfclfm/7xVGZWE8d4eRhcWqR9ATChy37r+WOA2+IL94K7
 y8Py7lcanQbpSdIoo5n2EadGuhxv2O1AP+O7AWh8RyXQhHWTcTnH9njm9jK/lPOVhuif
 ry5w==
X-Gm-Message-State: ACgBeo1AWTc482FNphqktHQ9Q5yv85yimtfQ6j2xkSYtBgqsTa2IJWRl
 gMVn7kTQevAK+/0aBx//6gT75hPIoWQ5A98GMrfthg==
X-Google-Smtp-Source: AA6agR7/RKAs0E6jrT0i52j7V9NOIYq3DwZJIFlTOaz7LTbxucLEE9/EHM8ghuH4Cw5QLQ1j5sI/C979ZNVWpAI0/c0=
X-Received: by 2002:ab0:13ed:0:b0:39a:2447:e4ae with SMTP id
 n42-20020ab013ed000000b0039a2447e4aemr2567135uae.37.1661488456875; Thu, 25
 Aug 2022 21:34:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-7-maz@kernel.org>
In-Reply-To: <20220805135813.2102034-7-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 25 Aug 2022 21:34:01 -0700
Message-ID: <CAAeT=FzXyr7D24QCcwGckgnPFuo8QtN3GrPg9h+s+3uGETE9Dw@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver
 limit to VM creation
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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

Hi Marc,

On Fri, Aug 5, 2022 at 6:58 AM Marc Zyngier <maz@kernel.org> wrote:
>
> As further patches will enable the selection of a PMU revision
> from userspace, sample the supported PMU revision at VM creation
> time, rather than building each time the ID_AA64DFR0_EL1 register
> is accessed.
>
> This shouldn't result in any change in behaviour.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/arm.c              |  6 ++++++
>  arch/arm64/kvm/pmu-emul.c         | 11 +++++++++++
>  arch/arm64/kvm/sys_regs.c         | 26 +++++++++++++++++++++-----
>  include/kvm/arm_pmu.h             |  6 ++++++
>  5 files changed, 45 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f38ef299f13b..411114510634 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -163,6 +163,7 @@ struct kvm_arch {
>
>         u8 pfr0_csv2;
>         u8 pfr0_csv3;
> +       u8 dfr0_pmuver;
>
>         /* Hypercall features firmware registers' descriptor */
>         struct kvm_smccc_features smccc_feat;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8fe73ee5fa84..e4f80f0c1e97 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -164,6 +164,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         set_default_spectre(kvm);
>         kvm_arm_init_hypercalls(kvm);
>
> +       /*
> +        * Initialise the default PMUver before there is a chance to
> +        * create an actual PMU.
> +        */
> +       kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_host_pmuver();
> +
>         return ret;
>  out_free_stage2_pgd:
>         kvm_free_stage2_pgd(&kvm->arch.mmu);
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index ddd79b64b38a..33a88ca7b7fd 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1021,3 +1021,14 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>         return -ENXIO;
>  }
> +
> +u8 kvm_arm_pmu_get_host_pmuver(void)

Nit: Since this function doesn't simply return the host's pmuver, but the
pmuver limit for guests, perhaps "kvm_arm_pmu_get_guest_pmuver_limit"
might be more clear (closer to what it does) ?

> +{
> +       u64 tmp;
> +
> +       tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> +       tmp = cpuid_feature_cap_perfmon_field(tmp,
> +                                             ID_AA64DFR0_PMUVER_SHIFT,
> +                                             ID_AA64DFR0_PMUVER_8_4);
> +       return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), tmp);
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 333efddb1e27..55451f49017c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1062,6 +1062,22 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>         return true;
>  }
>
> +static u8 pmuver_to_perfmon(const struct kvm_vcpu *vcpu)
> +{
> +       if (!kvm_vcpu_has_pmu(vcpu))
> +               return 0;
> +
> +       switch (vcpu->kvm->arch.dfr0_pmuver) {
> +       case ID_AA64DFR0_PMUVER_8_0:
> +               return ID_DFR0_PERFMON_8_0;
> +       case ID_AA64DFR0_PMUVER_IMP_DEF:
> +               return 0;
> +       default:
> +               /* Anything ARMv8.4+ has the same value. For now. */
> +               return vcpu->kvm->arch.dfr0_pmuver;
> +       }
> +}
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>                 struct sys_reg_desc const *r, bool raz)
> @@ -1112,10 +1128,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>                 /* Limit debug to ARMv8.0 */
>                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
>                 val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
> -               /* Limit guests to PMUv3 for ARMv8.4 */
> -               val = cpuid_feature_cap_perfmon_field(val,
> -                                                     ID_AA64DFR0_PMUVER_SHIFT,
> -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
> +               /* Set PMUver to the required version */
> +               val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
> +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
> +                                 kvm_vcpu_has_pmu(vcpu) ? vcpu->kvm->arch.dfr0_pmuver : 0);
>                 /* Hide SPE from guests */
>                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
>                 break;
> @@ -1123,7 +1139,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>                 /* Limit guests to PMUv3 for ARMv8.4 */

Nit: I think the comment above should be removed like you did for
ID_AA64DFR0_EL1 (or move it to kvm_arm_pmu_get_host_pmuver()?).

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji



>                 val = cpuid_feature_cap_perfmon_field(val,
>                                                       ID_DFR0_PERFMON_SHIFT,
> -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
> +                                                     pmuver_to_perfmon(vcpu));
>                 break;
>         }
>
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 96b192139a23..6bda9b071084 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -89,6 +89,8 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>                         vcpu->arch.pmu.events = *kvm_get_pmu_events();  \
>         } while (0)
>
> +u8 kvm_arm_pmu_get_host_pmuver(void);
> +
>  #else
>  struct kvm_pmu {
>  };
> @@ -154,6 +156,10 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>  static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> +static inline u8 kvm_arm_pmu_get_host_pmuver(void)
> +{
> +       return 0;
> +}
>
>  #endif
>
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

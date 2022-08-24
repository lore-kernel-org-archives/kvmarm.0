Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B7BBC00140
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 04:07:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCC664C1EB;
	Wed, 24 Aug 2022 00:07:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QDYW6OXoKyBA; Wed, 24 Aug 2022 00:07:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACD774C1DE;
	Wed, 24 Aug 2022 00:07:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E09F74C1D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 00:07:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ROYWZGDJAcqU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2022 00:07:44 -0400 (EDT)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com
 [209.85.217.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBA764C1D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 00:07:44 -0400 (EDT)
Received: by mail-vs1-f52.google.com with SMTP id 67so16389401vsv.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 21:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=ukyoAnmvcbI6w6tZqMe707q+h84BjnakUB+/IlncsVg=;
 b=SSG5i8AC1ReZYh3rnUzenRLWcEPdUNx/npUoFtyPwwtkmFmpL40T6PSy0hkrwhnqOF
 VdG2+QBhaOBGbtMndzxzhEIkPQUlAzVyQ21ZlglZZZbR7IOWuvoBmaBJtmmG0LnRA9Jr
 XxaWmYPZffIKu4OLGlc6d7V2FI4t/16l44JDIRiTo8y6CQX2J7EBDjF68guPUJg9lYNL
 ZWcwX5ZNjtq4VSCigFlO4P5ZD/qmw9h3kwLuXQpGt9hJWu7WUPIHxZbz2ymvl2DPxuhG
 FUnh3kgcYIjINJgXxUSKozrFMICssHcE1BdDiihZswDDXNBFUZdlvCG28zvR9gCJBYIh
 cc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=ukyoAnmvcbI6w6tZqMe707q+h84BjnakUB+/IlncsVg=;
 b=j5y2TSpSSpHr800HME7MDYl+8Qg1QivH6WMM63Lox+TyzrecZ2qqn5a10OnAe6oF2A
 Mc8amIoA7VLMNBIVayHcIz76yEtQDg7UmUpfNIR0FOaMAAldXvWwLB12Vdr1OX6OB2Hy
 oQ0LDw0TalAc7cFrYGQ39BmJmTkMockj2efBi4INVheK3s+C7t+0zfYmON5GhWrqn4ev
 cYB4a1rysRwTTw7ef8Y/33HxlIb9wQf8fqCnBKf7FaQhrHp/oaDKuss8TYBeQs8pCpg0
 0FgHJnboUAmysye7Pd1Xu5gRAhfu4kXnoxljh+/TZNY3ldA7Pm7a4CRBvrsvYtdBKopE
 5dHA==
X-Gm-Message-State: ACgBeo0BgIixoRsUsNV+e3yI4tpzeZgGo37n/OvMSnGYJ2bjcUVrv7hh
 m37L2NXmACqkHQTeJdPHLCq9zbuZiAvhoF9faPNDVA==
X-Google-Smtp-Source: AA6agR7Hn+KTQGYk4s8vmWz0LPxNEZbob6PfcYLRNYN99xLFE+sJydh8vKX0sKa5n1oU4YTygTiQ20by9OJ5n2cU4TI=
X-Received: by 2002:a67:de11:0:b0:390:4ef6:6a5f with SMTP id
 q17-20020a67de11000000b003904ef66a5fmr5767252vsk.58.1661314064203; Tue, 23
 Aug 2022 21:07:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-4-maz@kernel.org>
In-Reply-To: <20220805135813.2102034-4-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 23 Aug 2022 21:07:28 -0700
Message-ID: <CAAeT=Fyjc-ce1ABKVeBKYdCjiPDZ9OdS0r6_6q9QCLu8XoCxhw@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: PMU: Only narrow counters that are not
 64bit wide
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
> The current PMU emulation sometimes narrows counters to 32bit
> if the counter isn't the cycle counter. As this is going to
> change with PMUv3p5 where the counters are all 64bit, only
> perform the narrowing on 32bit counters.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 9040d3c80096..0ab6f59f433c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -149,22 +149,22 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>   */
>  static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
> -       u64 counter, reg, val;
> +       u64 counter, reg;
>
>         if (!pmc->perf_event)
>                 return;
>
>         counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>
> -       if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
> +       if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>                 reg = PMCCNTR_EL0;
> -               val = counter;
> -       } else {
> +       else
>                 reg = PMEVCNTR0_EL0 + pmc->idx;
> -               val = lower_32_bits(counter);
> -       }
>
> -       __vcpu_sys_reg(vcpu, reg) = val;
> +       if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> +               counter = lower_32_bits(counter);

It appears that narrowing the counter to 32bit here is unnecessary
because it is already done by kvm_pmu_get_counter_value().

Thank you,
Reiji

> +
> +       __vcpu_sys_reg(vcpu, reg) = counter;
>
>         kvm_pmu_release_perf_event(pmc);
>  }
> @@ -417,7 +417,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>
>                 /* Increment this counter */
>                 reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> -               reg = lower_32_bits(reg);
> +               if (!kvm_pmu_idx_is_64bit(vcpu, i))
> +                       reg = lower_32_bits(reg);
>                 __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
>
>                 if (reg) /* No overflow? move on */
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

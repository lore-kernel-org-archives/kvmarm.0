Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB8FC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 06:51:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BED304B7FC;
	Thu, 17 Nov 2022 01:51:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qJKw84SYZSE9; Thu, 17 Nov 2022 01:51:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 945E14B823;
	Thu, 17 Nov 2022 01:51:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34E184B7FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 01:51:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZW4q5z41UQuZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2022 01:51:05 -0500 (EST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 071984B7A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 01:51:04 -0500 (EST)
Received: by mail-pg1-f181.google.com with SMTP id h193so1153698pgc.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 22:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=0y7VdxwHLwhJHQkWTFwHzknojiHUon3RH8OwCo8MxdU=;
 b=COdBKeWciEUcxRjfv54pacO7y07o7BOLG2qNenQAwJZp0M8UcST5OLdENV5peqP150
 Lld+WqcJLCLA+svE//sI6HZ6boKGiC065GyL/C0UlhvdTHZ5Meyas0NOdL7b7ZTEU28Q
 QLyIkqxH2KQnHACOB7hgCx24pGu5v7lo6J9P8KPO1SdtyT1QdItekW+gmj2e75LB+Abb
 7Vz+f0D6/pT4wBL1tP/5/3ue0NtF0FKlpOScalgJvQq4lHJCJ3neX4zMR2gLkiQifGyx
 /CtxNEeSMt8duyrk6Q8s95bPhQFa4YdeIoinYBLMM+OR1Ywg6jMqEoVCkufjCJXEcqHY
 bHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=0y7VdxwHLwhJHQkWTFwHzknojiHUon3RH8OwCo8MxdU=;
 b=M3sqZv01/1MzS0qMPjfjMrxT1RHusoQbYoO64JY3jRgkJpD+hrbPzATIV8zWY3XTqq
 XpXdKg57kMG4jygGt21p5x4j6XP9/GIVt0LWEmG+Vu3JDqG0TLV7521KlDmsiZnitxdl
 j8rtqQdFbv6bheYLuOiMglWHc/Ezh4Jq+ef6iavMMtOXDa5MpNFaww2fvc2WBEKYNWy0
 14c/IadK04Nfihp1/wvT39dvnWBvv9faYjrn/xVrMANbQJujUS+5TK7Os7uUTroCMufp
 l6jbAF9F0lq96EfKyxHOrHzKozBgr6vOSRBCBSu41XIISVGjpeE76LzhItqNpaPovGze
 z7pw==
X-Gm-Message-State: ANoB5pn3LmpWK8Qqud1CWO2zqJYKh3mlHURKTbKCUP9Y7y3V+sdKuWEW
 jqC3cdCWtSqZIMurDK7gccsFhy9a//8KBI33ePKGgQ==
X-Google-Smtp-Source: AA0mqf7ZAaFwtnsQ/o31Qma+1YQJIdWkjS6YTmda5EJO78rYJYD90n/VB3W/Ch7Q9Uxv6tcnOHnWL1HG6hz+RkFwHUk=
X-Received: by 2002:a62:1b0b:0:b0:56d:384:e13a with SMTP id
 b11-20020a621b0b000000b0056d0384e13amr1555432pfb.75.1668667863849; Wed, 16
 Nov 2022 22:51:03 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-6-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-6-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 16 Nov 2022 22:50:47 -0800
Message-ID: <CAAeT=FzO4_bzOY3m6X=2a4VWxwfBPP8u0wQ0VTeK+64NVe+e3w@mail.gmail.com>
Subject: Re: [PATCH v4 05/16] KVM: arm64: PMU: Narrow the overflow checking
 when required
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> For 64bit counters that overflow on a 32bit boundary, make
> sure we only check the bottom 32bit to generate a CHAIN event.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index d050143326b5..9e6bc7edc4de 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -417,7 +417,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>                 reg = lower_32_bits(reg);
>                 __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
>
> -               if (reg) /* No overflow? move on */
> +               /* No overflow? move on */
> +               if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))

A few lines up, the 'reg' is unconditionally updated with
"lower_32_bits(reg)". So, the change initially confused me
(until I checked the following patch).  IMHO it might be more
clear if this patch and the next patch are folded into one patch.

Anyway:
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji



>                         continue;
>
>                 /* Mark overflow */
> --
> 2.34.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

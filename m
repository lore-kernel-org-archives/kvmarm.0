Return-Path: <SRS0=MZYq=ZV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BFAC432C0
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 07:53:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 92CE721721
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 07:53:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9UYstAa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92CE721721
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C54F24AEB9;
	Fri, 29 Nov 2019 02:53:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3+oRLRKmtyHY; Fri, 29 Nov 2019 02:53:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC64C4ACB7;
	Fri, 29 Nov 2019 02:53:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C61484AC7A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 02:53:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WuhCwdf6s9fb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Nov 2019 02:53:50 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC2954A7F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 02:53:50 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id y23so4533507wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 23:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=f1gpxuNh24lQFcttp3T24kzfWn/kvbMTIewYEDBYMKY=;
 b=d9UYstAaUZn4HQta3frKN/Y613skfSz1RKjxccxpdwlsyUgQuUkvlC0k1JDptRt9NI
 e198Oc1b8rLDxAWV4ABkPVlgolFmMbZnVwlS0AmmCsl5bL0Cxco1ShpcsZ0FpMKKsvE9
 axXKLRx4BJh59c086Gio87DrPL/AjVFsoaGEeVGqsy2xXynI8o4o/P7uBVzjvGu9WXM4
 IpkirL5ijgz0MRWySoVR+/9wfxmHCfaqzPEboIjsf036KQVsp+eaEpRq5qvP/C8wV06m
 IjJKQhdSHqrO7DDLSb3uYVMN9LqnBEyTBswZLxUoVUK1H4KiaRmXBv+S4XJ4K418B/gu
 5MMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=f1gpxuNh24lQFcttp3T24kzfWn/kvbMTIewYEDBYMKY=;
 b=Rse8l4yIoxUatVAXRizionQagSTMeyhfn6blIhlahHzsOwhknvlHvZ2QjX8vnOG1AA
 er5G8L7VGb0PvfR7Lp9+ASE66QW1n7hs1YMn/Eh4NcTOu4opg2kGJanom6mvjlifxZJn
 uCMJxRc8EdFEjjFO3bY4AMIlE2I2mO+2mssegqByRuv8VKei1e8VYzYy0gyOY/ufeQ2n
 v6PE7wL3AcsMenjKetj2y2hsWhe81wdVyCBTg0cwZrTpm5/sGuGzsuGcIXTfYc/lNm2C
 fAfAYBoid6nbafsY9Ui3Zfyt0cQgx/Dwp6OUrpKcs4ynUoOfuLV0QvfO9VKO9lAjqiuB
 7rnA==
X-Gm-Message-State: APjAAAUZ55t1y9c0TscIAhCsNvNOBMU7072dS/8lRcgl8bUL2YBadFQC
 9D/kan1TsrAr2c1WLDvsfXQ=
X-Google-Smtp-Source: APXvYqxZjuTyCyxmGl5/ynsNL/fOmqdRm2nIq6H1hDDO5Sru1NWfNBGqDJSQR4EpWb0Fc7MUMBdi0Q==
X-Received: by 2002:a1c:4b03:: with SMTP id y3mr2158247wma.91.1575014029542;
 Thu, 28 Nov 2019 23:53:49 -0800 (PST)
Received: from localhost (ec2-34-244-242-0.eu-west-1.compute.amazonaws.com.
 [34.244.242.0])
 by smtp.gmail.com with ESMTPSA id h2sm27425159wrt.45.2019.11.28.23.53.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Nov 2019 23:53:48 -0800 (PST)
Date: Fri, 29 Nov 2019 08:53:51 +0100
From: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] target/arm: Honor HCR_EL2.TID2 trapping requirements
Message-ID: <20191129075351.GD29312@toto>
References: <20191128161718.24361-1-maz@kernel.org>
 <20191128161718.24361-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191128161718.24361-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: richard.henderson@linaro.org, qemu-devel@nongnu.org,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Nov 28, 2019 at 04:17:16PM +0000, Marc Zyngier wrote:
> HCR_EL2.TID2 mandates that access from EL1 to CTR_EL0, CCSIDR_EL1,
> CCSIDR2_EL1, CLIDR_EL1, CSSELR_EL1 are trapped to EL2, and QEMU
> completely ignores it, making impossible for hypervisors to

Nit: "making it impossible"


> virtualize the cache hierarchy.
> 
> Do the right thing by trapping to EL2 if HCR_EL2.TID2 is set.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/helper.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 0bf8f53d4b..0b6887b100 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -1910,6 +1910,17 @@ static void scr_write(CPUARMState *env, const ARMCPRegInfo *ri, uint64_t value)
>      raw_write(env, ri, value);
>  }
>  
> +static CPAccessResult access_aa64_tid2(CPUARMState *env,
> +                                       const ARMCPRegInfo *ri,
> +                                       bool isread)
> +{
> +    if (arm_current_el(env) == 1 && (arm_hcr_el2_eff(env) & HCR_TID2)) {
> +        return CP_ACCESS_TRAP_EL2;
> +    }
> +
> +    return CP_ACCESS_OK;
> +}
> +
>  static uint64_t ccsidr_read(CPUARMState *env, const ARMCPRegInfo *ri)
>  {
>      ARMCPU *cpu = env_archcpu(env);
> @@ -2110,10 +2121,14 @@ static const ARMCPRegInfo v7_cp_reginfo[] = {
>        .writefn = pmintenclr_write },
>      { .name = "CCSIDR", .state = ARM_CP_STATE_BOTH,
>        .opc0 = 3, .crn = 0, .crm = 0, .opc1 = 1, .opc2 = 0,
> -      .access = PL1_R, .readfn = ccsidr_read, .type = ARM_CP_NO_RAW },
> +      .access = PL1_R,
> +      .accessfn = access_aa64_tid2,
> +      .readfn = ccsidr_read, .type = ARM_CP_NO_RAW },
>      { .name = "CSSELR", .state = ARM_CP_STATE_BOTH,
>        .opc0 = 3, .crn = 0, .crm = 0, .opc1 = 2, .opc2 = 0,
> -      .access = PL1_RW, .writefn = csselr_write, .resetvalue = 0,
> +      .access = PL1_RW,
> +      .accessfn = access_aa64_tid2,
> +      .writefn = csselr_write, .resetvalue = 0,
>        .bank_fieldoffsets = { offsetof(CPUARMState, cp15.csselr_s),
>                               offsetof(CPUARMState, cp15.csselr_ns) } },
>      /* Auxiliary ID register: this actually has an IMPDEF value but for now
> @@ -5204,6 +5219,11 @@ static CPAccessResult ctr_el0_access(CPUARMState *env, const ARMCPRegInfo *ri,
>      if (arm_current_el(env) == 0 && !(env->cp15.sctlr_el[1] & SCTLR_UCT)) {
>          return CP_ACCESS_TRAP;
>      }
> +
> +    if (arm_hcr_el2_eff(env) & HCR_TID2) {
> +        return CP_ACCESS_TRAP_EL2;
> +    }


Shouldn't we also be checking that we're in EL < 2 when trapping?

Also, I think we need to somehow hook in access_aa64_tid2() for the AArch32
view of CTR, don't we?

Cheers,
Edgar


> +
>      return CP_ACCESS_OK;
>  }
>  
> @@ -6184,7 +6204,9 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>          ARMCPRegInfo clidr = {
>              .name = "CLIDR", .state = ARM_CP_STATE_BOTH,
>              .opc0 = 3, .crn = 0, .crm = 0, .opc1 = 1, .opc2 = 1,
> -            .access = PL1_R, .type = ARM_CP_CONST, .resetvalue = cpu->clidr
> +            .access = PL1_R, .type = ARM_CP_CONST,
> +            .accessfn = access_aa64_tid2,
> +            .resetvalue = cpu->clidr
>          };
>          define_one_arm_cp_reg(cpu, &clidr);
>          define_arm_cp_regs(cpu, v7_cp_reginfo);
> -- 
> 2.20.1
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=99up=ZY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC617C432C0
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 13:52:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42C41206E1
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 13:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UogDa1+h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42C41206E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 940E14AEF2;
	Mon,  2 Dec 2019 08:52:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S-ihg9-iaXpV; Mon,  2 Dec 2019 08:52:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7931F4AEBC;
	Mon,  2 Dec 2019 08:52:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EE8D4AEA1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 08:52:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0PotAdS9elxT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Dec 2019 08:52:18 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 515784A8E0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 08:52:18 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id b11so21880186wmj.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Dec 2019 05:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=qzHvAtOXFnh2I6y4Y2DJQ+VkcEOnIcY6xOliHLRVbZY=;
 b=UogDa1+h7X/0DMuKD80ws3nrnJL3oXx/AaN7t0RjGZE+xiFrjAJAsNJF2OZ+Hn9XBZ
 h4/yh3E94hgxfXRjIfQLbpslcUItSRaXRog0oh6euU6XNrslieX+gO3D8qaYtUTgVTzh
 /ffod673V/CmANm0lTLXYcXyzZlRN1OHLwVryRgPW20wfTk25V9rFxBHYBCsz3DNtUJd
 3gaRb8wklixUJhZ11RfyqJeE4pRN7OeWOGn3R+rDJ8xENfp5f5757yi+bFNZzfDC2qyh
 9yVU5Mvg8rvHsHVk5V1hsdXseGseMeaxSFE2MUMEHAheJgoAQcbwdlJmUfgZEwfj9rLU
 Purw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=qzHvAtOXFnh2I6y4Y2DJQ+VkcEOnIcY6xOliHLRVbZY=;
 b=og/IU2n+y/4X9P7MKGZ25hsRztlymUOXm+no4p2k4SoSe8O+wppp8NdS2f++utJx0W
 KiQ7WcxePy8oySTpd7GlmYwYuWOrMyhZQzonOiw8G51/kdDk5LqbEZE7+VZ7rn29B9wA
 Pzr6M1ErmIKJ08UyRqlUrU506vOldkiQzsDprf0TNhCrhQInhIP1fHuXkQc5/pprficD
 +abWu2MzO/B3qG7tZtWTJrzc4porxAJDB9JC5HfmgrfWCs3yBli8wQ4RagCJ1qUXDGp8
 gx5cwC78fO/793cvLK0/RvMypPc21u7Roif5zQqmExPoHCj/qYc2J8vML/1v9hvAqMWt
 jKHw==
X-Gm-Message-State: APjAAAUD+BnaXps1tDK8zKes0EP9WCKVbdgNWMI6tc975EKSNl0clckX
 Bd6lRV3DEV9AFlAsTDokFV0=
X-Google-Smtp-Source: APXvYqzeGaJ4vwUvNMeKihisCiDAJV7PUvPo504vjJ0TmCpcZtJspTFspkE/M1n3jqp1gsUSSKj6xQ==
X-Received: by 2002:a1c:b4c6:: with SMTP id d189mr3949217wmf.176.1575294737140; 
 Mon, 02 Dec 2019 05:52:17 -0800 (PST)
Received: from localhost (ec2-34-244-242-0.eu-west-1.compute.amazonaws.com.
 [34.244.242.0])
 by smtp.gmail.com with ESMTPSA id z6sm27860074wrw.36.2019.12.02.05.52.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 02 Dec 2019 05:52:16 -0800 (PST)
Date: Mon, 2 Dec 2019 14:52:18 +0100
From: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/5] target/arm: Honor HCR_EL2.TID2 trapping
 requirements
Message-ID: <20191202135218.GE25295@toto>
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191201122018.25808-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Edgar E. Iglesias" <edgar.iglesias@xilinx.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
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

On Sun, Dec 01, 2019 at 12:20:14PM +0000, Marc Zyngier wrote:
> HCR_EL2.TID2 mandates that access from EL1 to CTR_EL0, CCSIDR_EL1,
> CCSIDR2_EL1, CLIDR_EL1, CSSELR_EL1 are trapped to EL2, and QEMU
> completely ignores it, making it impossible for hypervisors to
> virtualize the cache hierarchy.
> 
> Do the right thing by trapping to EL2 if HCR_EL2.TID2 is set.

Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>


> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/helper.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 0bf8f53d4b..1e546096b8 100644
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
> +    if (arm_current_el(env) < 2 && arm_hcr_el2_eff(env) & HCR_TID2) {
> +        return CP_ACCESS_TRAP_EL2;
> +    }
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
> @@ -6717,7 +6739,8 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>              /* These are common to v8 and pre-v8 */
>              { .name = "CTR",
>                .cp = 15, .crn = 0, .crm = 0, .opc1 = 0, .opc2 = 1,
> -              .access = PL1_R, .type = ARM_CP_CONST, .resetvalue = cpu->ctr },
> +              .access = PL1_R, .accessfn = ctr_el0_access,
> +              .type = ARM_CP_CONST, .resetvalue = cpu->ctr },
>              { .name = "CTR_EL0", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 3, .opc2 = 1, .crn = 0, .crm = 0,
>                .access = PL0_R, .accessfn = ctr_el0_access,
> -- 
> 2.20.1
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1395C432C0
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 08:00:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E07121774
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 08:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kUM/t9eN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E07121774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB5BB4A94D;
	Fri, 29 Nov 2019 03:00:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nFMjRiQbvXKK; Fri, 29 Nov 2019 03:00:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B8C14AC7A;
	Fri, 29 Nov 2019 03:00:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12AA34A946
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 03:00:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xRRyyxZD+Wh0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Nov 2019 03:00:15 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E819A4A8E8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 03:00:14 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id y5so13886947wmi.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 00:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=+ee4XCjoKvbrVyPiVj9oLKOCyeyLum3UV/GHyTlIxYM=;
 b=kUM/t9eNYO5Sj0IK08qF8PQQ3uaXFcMDeHjDR09kJr24eyxL361WeKH+MWmhYp2wQy
 1r3b0WIR7AtHvu8K5/0zpVt9KM3KKM2iRwiG6rCLZGCU1cqysANrWn1it1ux0dwlgB93
 9LE40KS+b7nnu/pRuB3n7hnolaq63YKMSJHDSPrRc3jGgyNDDOb1Zb+KejnOHTHs1hCO
 e+oORBIEuXvCC56Mbl96z5scxTX4BCW0JQTbl3SdEZCFdxmRZdMKQbxsYuZ8KyO+/YYN
 eGHcY0dgJboBRWNtrtyYjcCBhO+/rPZNuYmnz8gJ82fIqfh5I53gFs+mW/ECV+vLzZ8H
 JiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=+ee4XCjoKvbrVyPiVj9oLKOCyeyLum3UV/GHyTlIxYM=;
 b=rXRng8bFF2PuhltyTKsnoOkhVdQ/NJAN7OmUH0RldQEWynpEEybvjiggGadgzmGSnM
 3JmeqHAYeq+PjQtrWydKJuX5d/0ERB+ryDIx35nfp/QIl01Syal533vmy/Y+ZCrzOaSO
 TvKJOwtMgAqyjdihWyQqnkSoqYosIyBo1BaeXgtpSBwpphVX0klMahYjGCpslDzfHdWh
 7pElhft+gw9mKHalkr4n5Nn5ShFKn4pfSWLMcKh/GU40MhuG2nA9IA+cQlxrCB6T8CXv
 lIRHhU2Y6acVOnj0JjMcUWXVpp/09C8pLKe+TNR5lfx8d6AWI5bFv2s2cP+rnpBoT127
 VmJw==
X-Gm-Message-State: APjAAAX4PKEYqC1f0domFlFMQKrySmCyZKXXFJQp80EGbMwgb4rP5ZMn
 ZFmIv0QlAnh4uL9ej+7tkdE=
X-Google-Smtp-Source: APXvYqwe09tQue8nHFk39vsJX6xeXrU4LjnL73ldh1erXrGAbZkkczFZHKsgHhvq7oyW2aznTfQtgA==
X-Received: by 2002:a1c:3cd4:: with SMTP id j203mr8250680wma.90.1575014413834; 
 Fri, 29 Nov 2019 00:00:13 -0800 (PST)
Received: from localhost (ec2-34-244-242-0.eu-west-1.compute.amazonaws.com.
 [34.244.242.0])
 by smtp.gmail.com with ESMTPSA id i127sm13433594wma.35.2019.11.29.00.00.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 29 Nov 2019 00:00:13 -0800 (PST)
Date: Fri, 29 Nov 2019 09:00:15 +0100
From: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/3] target/arm: Honor HCR_EL2.TID1 trapping requirements
Message-ID: <20191129080015.GE29312@toto>
References: <20191128161718.24361-1-maz@kernel.org>
 <20191128161718.24361-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191128161718.24361-3-maz@kernel.org>
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

On Thu, Nov 28, 2019 at 04:17:17PM +0000, Marc Zyngier wrote:
> HCR_EL2.TID1 mandates that access from EL1 to REVIDR_EL1, AIDR_EL1
> (and their 32bit equivalents) as well as TCMTR, TLBTR are trapped
> to EL2. QEMU ignores it, naking it harder for a hypervisor to

Typo: "making it harder"


> virtualize the HW (though to be fair, no known hypervisor actually
> cares).
> 
> Do the right thing by trapping to EL2 if HCR_EL2.TID1 is set.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/helper.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 0b6887b100..9bff769692 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -1973,6 +1973,26 @@ static uint64_t isr_read(CPUARMState *env, const ARMCPRegInfo *ri)
>      return ret;
>  }
>  
> +static CPAccessResult access_aa64_tid1(CPUARMState *env, const ARMCPRegInfo *ri,
> +                                       bool isread)
> +{
> +    if (arm_hcr_el2_eff(env) & HCR_TID1) {
> +        return CP_ACCESS_TRAP_EL2;
> +    }

I think we need to check for EL1 here?

Otherwise:
Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>

Cheers,
Edgar


> +
> +    return CP_ACCESS_OK;
> +}
> +
> +static CPAccessResult access_aa32_tid1(CPUARMState *env, const ARMCPRegInfo *ri,
> +                                       bool isread)
> +{
> +    if (arm_feature(env, ARM_FEATURE_V8)) {
> +        return access_aa64_tid1(env, ri, isread);
> +    }
> +
> +    return CP_ACCESS_OK;
> +}
> +
>  static const ARMCPRegInfo v7_cp_reginfo[] = {
>      /* the old v6 WFI, UNPREDICTABLE in v7 but we choose to NOP */
>      { .name = "NOP", .cp = 15, .crn = 7, .crm = 0, .opc1 = 0, .opc2 = 4,
> @@ -2136,7 +2156,9 @@ static const ARMCPRegInfo v7_cp_reginfo[] = {
>       */
>      { .name = "AIDR", .state = ARM_CP_STATE_BOTH,
>        .opc0 = 3, .opc1 = 1, .crn = 0, .crm = 0, .opc2 = 7,
> -      .access = PL1_R, .type = ARM_CP_CONST, .resetvalue = 0 },
> +      .access = PL1_R, .type = ARM_CP_CONST,
> +      .accessfn = access_aa64_tid1,
> +      .resetvalue = 0 },
>      /* Auxiliary fault status registers: these also are IMPDEF, and we
>       * choose to RAZ/WI for all cores.
>       */
> @@ -6732,7 +6754,9 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>                .access = PL1_R, .resetvalue = cpu->midr },
>              { .name = "REVIDR_EL1", .state = ARM_CP_STATE_BOTH,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 0, .opc2 = 6,
> -              .access = PL1_R, .type = ARM_CP_CONST, .resetvalue = cpu->revidr },
> +              .access = PL1_R,
> +              .accessfn = access_aa64_tid1,
> +              .type = ARM_CP_CONST, .resetvalue = cpu->revidr },
>              REGINFO_SENTINEL
>          };
>          ARMCPRegInfo id_cp_reginfo[] = {
> @@ -6747,14 +6771,18 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>              /* TCMTR and TLBTR exist in v8 but have no 64-bit versions */
>              { .name = "TCMTR",
>                .cp = 15, .crn = 0, .crm = 0, .opc1 = 0, .opc2 = 2,
> -              .access = PL1_R, .type = ARM_CP_CONST, .resetvalue = 0 },
> +              .access = PL1_R,
> +              .accessfn = access_aa32_tid1,
> +              .type = ARM_CP_CONST, .resetvalue = 0 },
>              REGINFO_SENTINEL
>          };
>          /* TLBTR is specific to VMSA */
>          ARMCPRegInfo id_tlbtr_reginfo = {
>                .name = "TLBTR",
>                .cp = 15, .crn = 0, .crm = 0, .opc1 = 0, .opc2 = 3,
> -              .access = PL1_R, .type = ARM_CP_CONST, .resetvalue = 0,
> +              .access = PL1_R,
> +              .accessfn = access_aa32_tid1,
> +              .type = ARM_CP_CONST, .resetvalue = 0,
>          };
>          /* MPUIR is specific to PMSA V6+ */
>          ARMCPRegInfo id_mpuir_reginfo = {
> -- 
> 2.20.1
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

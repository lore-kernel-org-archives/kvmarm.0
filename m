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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214AFC432C0
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 08:28:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9DF6921781
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 08:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CbsBYa/q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DF6921781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 244CF4AEB5;
	Fri, 29 Nov 2019 03:28:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id axQuj7roAg9T; Fri, 29 Nov 2019 03:28:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDAE24AE87;
	Fri, 29 Nov 2019 03:28:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01C994A959
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 03:28:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0qlgIFcIZrsY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Nov 2019 03:28:05 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D04754A8E0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 03:28:05 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id b11so13186522wmj.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 00:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=MAPheqm9fDL+6EchxpNIte7qdz1SCmGvIuvUadZb4RA=;
 b=CbsBYa/qVf/pZtJInHky781HMCYepJUJTHclswnzm+KmeOTHit263+KrZIidzQ3TUP
 3NJ6XJN5mkLWQ8Pe3GA7rBX7uzd4cfPby9JiRjJ6yNq44tboB9SPjVz5StIhiuaY5xx0
 JWfH01xoybeoBNEwIoRd7F+Q3FSOmOkFyaJPLGTV/3bdOVf3KmtyPR79N2ZsnKTU/ImW
 Lp3F917XUYlN5Pb7gViIvM3QxYdsKv7SAVg9hqJBYIELnFExDoYBmkG5db1CXv3ZtYM2
 eX1iyM7+VUD0QfAfMiu/oIkszOvFMVM9M7bvZyNkNkqA4TpfgtFlSIkgKeOSfWDNx6hh
 yq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=MAPheqm9fDL+6EchxpNIte7qdz1SCmGvIuvUadZb4RA=;
 b=b5a3vcdOTorxJPgO2fo1hq2Ov9OLONFU3hfWZwa1agKGhKi+xzGSwrxADaBfSSubgW
 mGMThAFt3f9nTIkTioLokgPCZJmGpQ/3Qknjl7RiREmfGKQ1uac/SPwR4XTHc47mjlQI
 l04RN15Gvwil8kVSgJZQVaHDW3zEAh3q6/Q/StTUMm/3Bv9RM5imhXlJIKagtfhf0v8O
 7zKbDr61pEGXcbz86PJTf62i/Mt1pQbZN1bHxgWBRG9MTJQjuISlF8k4e5HJ+3c1Lu07
 BAAHZ4epcDe/+8GyzlG/yMNX1B7pE8hf93Pjcyl0tl/Njo3Is6dVFP+jHriQ6Q0H/QQN
 iMag==
X-Gm-Message-State: APjAAAV2pijm9Zv0fHelvW2lNfCDNXYlS+JuMZpHOqGEPQR7cmebeg63
 RBbIQ8K1kds53LK8TIrOq8s=
X-Google-Smtp-Source: APXvYqwGfxvoH0E3dhEh6XRs4IzuiGV3Eyg/V2Ot2EIyPq9BqQ7bZz4+SpsV+zaDDdubgA68t3VpJQ==
X-Received: by 2002:a05:600c:a:: with SMTP id
 g10mr13529311wmc.69.1575016084615; 
 Fri, 29 Nov 2019 00:28:04 -0800 (PST)
Received: from localhost (ec2-34-244-242-0.eu-west-1.compute.amazonaws.com.
 [34.244.242.0])
 by smtp.gmail.com with ESMTPSA id d20sm27625387wra.4.2019.11.29.00.28.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 29 Nov 2019 00:28:03 -0800 (PST)
Date: Fri, 29 Nov 2019 09:28:06 +0100
From: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/3] target/arm: Handle trapping to EL2 of AArch32 VMRS
 instructions
Message-ID: <20191129082806.GF29312@toto>
References: <20191128161718.24361-1-maz@kernel.org>
 <20191128161718.24361-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191128161718.24361-4-maz@kernel.org>
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

On Thu, Nov 28, 2019 at 04:17:18PM +0000, Marc Zyngier wrote:
> HCR_EL2.TID3 requires that AArch32 reads of MVFR[012] are trapped to
> EL2, and that HCR_EL2.TID0 does the same for reads of FPSID.
> In order to handle this, introduce a new TCG helper function that
> checks for these control bits before executing the VMRC instruction.
> 
> Tested with a hacked-up version of KVM/arm64 that sets the control
> bits for 32bit guests.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/helper-a64.h        |  2 ++
>  target/arm/internals.h         |  8 ++++++++
>  target/arm/translate-vfp.inc.c | 12 +++++++++---
>  target/arm/vfp_helper.c        | 27 +++++++++++++++++++++++++++
>  4 files changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/target/arm/helper-a64.h b/target/arm/helper-a64.h
> index a915c1247f..311ced44e6 100644
> --- a/target/arm/helper-a64.h
> +++ b/target/arm/helper-a64.h
> @@ -102,3 +102,5 @@ DEF_HELPER_FLAGS_3(autda, TCG_CALL_NO_WG, i64, env, i64, i64)
>  DEF_HELPER_FLAGS_3(autdb, TCG_CALL_NO_WG, i64, env, i64, i64)
>  DEF_HELPER_FLAGS_2(xpaci, TCG_CALL_NO_RWG_SE, i64, env, i64)
>  DEF_HELPER_FLAGS_2(xpacd, TCG_CALL_NO_RWG_SE, i64, env, i64)
> +
> +DEF_HELPER_3(check_hcr_el2_trap, void, env, int, int)
> diff --git a/target/arm/internals.h b/target/arm/internals.h
> index f5313dd3d4..5a55e960de 100644
> --- a/target/arm/internals.h
> +++ b/target/arm/internals.h
> @@ -430,6 +430,14 @@ static inline uint32_t syn_simd_access_trap(int cv, int cond, bool is_16bit)
>          | (cv << 24) | (cond << 20) | (1 << 5);
>  }
>  
> +static inline uint32_t syn_vmrs_trap(int rt, int reg)
> +{
> +    return (EC_FPIDTRAP << ARM_EL_EC_SHIFT)
> +        | ARM_EL_IL
> +        | (1 << 24) | (0xe << 20) | (7 << 14)
> +        | (reg << 10) | (rt << 5) | 1;
> +}
> +
>  static inline uint32_t syn_sve_access_trap(void)
>  {
>      return EC_SVEACCESSTRAP << ARM_EL_EC_SHIFT;
> diff --git a/target/arm/translate-vfp.inc.c b/target/arm/translate-vfp.inc.c
> index 85c5ef897b..4c435b6c35 100644
> --- a/target/arm/translate-vfp.inc.c
> +++ b/target/arm/translate-vfp.inc.c
> @@ -759,15 +759,21 @@ static bool trans_VMSR_VMRS(DisasContext *s, arg_VMSR_VMRS *a)
>      }
>  
>      if (a->l) {
> +        TCGv_i32 tcg_rt, tcg_reg;
> +
>          /* VMRS, move VFP special register to gp register */
>          switch (a->reg) {
> +        case ARM_VFP_MVFR0:
> +        case ARM_VFP_MVFR1:
> +        case ARM_VFP_MVFR2:
>          case ARM_VFP_FPSID:
> +            tcg_rt = tcg_const_i32(a->rt);
> +            tcg_reg = tcg_const_i32(a->reg);
> +            gen_helper_check_hcr_el2_trap(cpu_env, tcg_rt, tcg_reg);
> +            /* fall through */
>          case ARM_VFP_FPEXC:
>          case ARM_VFP_FPINST:
>          case ARM_VFP_FPINST2:
> -        case ARM_VFP_MVFR0:
> -        case ARM_VFP_MVFR1:
> -        case ARM_VFP_MVFR2:
>              tmp = load_cpu_field(vfp.xregs[a->reg]);
>              break;
>          case ARM_VFP_FPSCR:
> diff --git a/target/arm/vfp_helper.c b/target/arm/vfp_helper.c
> index 9710ef1c3e..44e538e51c 100644
> --- a/target/arm/vfp_helper.c
> +++ b/target/arm/vfp_helper.c
> @@ -1322,4 +1322,31 @@ float64 HELPER(frint64_d)(float64 f, void *fpst)
>      return frint_d(f, fpst, 64);
>  }
>  
> +void HELPER(check_hcr_el2_trap)(CPUARMState *env, int rt, int reg)
> +{
> +    if (arm_current_el(env) != 1) {
> +        return;
> +    }

I think we could move the EL1 check to translation time, couldn't we?

Other than that:
Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>



> +
> +    switch (reg) {
> +    case ARM_VFP_MVFR0:
> +    case ARM_VFP_MVFR1:
> +    case ARM_VFP_MVFR2:
> +        if (!(arm_hcr_el2_eff(env) & HCR_TID3)) {
> +            return;
> +        }
> +        break;
> +    case ARM_VFP_FPSID:
> +        if (!(arm_hcr_el2_eff(env) & HCR_TID0)) {
> +            return;
> +        }
> +        break;
> +    default:
> +        /* Shouldn't be here... */
> +        return;
> +    }
> +
> +    raise_exception(env, EXCP_HYP_TRAP, syn_vmrs_trap(rt, reg), 2);
> +}
> +
>  #endif
> -- 
> 2.20.1
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

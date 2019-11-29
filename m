Return-Path: <SRS0=MZYq=ZV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81350C432C3
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 09:24:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11F1421774
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 09:24:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11F1421774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67FF74AEC4;
	Fri, 29 Nov 2019 04:24:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NMc2QbU+1974; Fri, 29 Nov 2019 04:24:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0164AEAF;
	Fri, 29 Nov 2019 04:24:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B9C74ACB7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 04:24:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DGRJezKY97za for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Nov 2019 04:24:40 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89A224A542
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 04:24:40 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iacVy-0005Ch-9O; Fri, 29 Nov 2019 10:24:38 +0100
To: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: [PATCH 3/3] target/arm: Handle trapping to EL2 of AArch32 VMRS
 instructions
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Fri, 29 Nov 2019 09:24:37 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191129082806.GF29312@toto>
References: <20191128161718.24361-1-maz@kernel.org>
 <20191128161718.24361-4-maz@kernel.org> <20191129082806.GF29312@toto>
Message-ID: <3a53b096bd101f9627d4c61ecfd742de@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: edgar.iglesias@gmail.com, qemu-devel@nongnu.org,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019-11-29 08:28, Edgar E. Iglesias wrote:
> On Thu, Nov 28, 2019 at 04:17:18PM +0000, Marc Zyngier wrote:
>> HCR_EL2.TID3 requires that AArch32 reads of MVFR[012] are trapped to
>> EL2, and that HCR_EL2.TID0 does the same for reads of FPSID.
>> In order to handle this, introduce a new TCG helper function that
>> checks for these control bits before executing the VMRC instruction.
>>
>> Tested with a hacked-up version of KVM/arm64 that sets the control
>> bits for 32bit guests.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  target/arm/helper-a64.h        |  2 ++
>>  target/arm/internals.h         |  8 ++++++++
>>  target/arm/translate-vfp.inc.c | 12 +++++++++---
>>  target/arm/vfp_helper.c        | 27 +++++++++++++++++++++++++++
>>  4 files changed, 46 insertions(+), 3 deletions(-)
>>
>> diff --git a/target/arm/helper-a64.h b/target/arm/helper-a64.h
>> index a915c1247f..311ced44e6 100644
>> --- a/target/arm/helper-a64.h
>> +++ b/target/arm/helper-a64.h
>> @@ -102,3 +102,5 @@ DEF_HELPER_FLAGS_3(autda, TCG_CALL_NO_WG, i64, 
>> env, i64, i64)
>>  DEF_HELPER_FLAGS_3(autdb, TCG_CALL_NO_WG, i64, env, i64, i64)
>>  DEF_HELPER_FLAGS_2(xpaci, TCG_CALL_NO_RWG_SE, i64, env, i64)
>>  DEF_HELPER_FLAGS_2(xpacd, TCG_CALL_NO_RWG_SE, i64, env, i64)
>> +
>> +DEF_HELPER_3(check_hcr_el2_trap, void, env, int, int)
>> diff --git a/target/arm/internals.h b/target/arm/internals.h
>> index f5313dd3d4..5a55e960de 100644
>> --- a/target/arm/internals.h
>> +++ b/target/arm/internals.h
>> @@ -430,6 +430,14 @@ static inline uint32_t syn_simd_access_trap(int 
>> cv, int cond, bool is_16bit)
>>          | (cv << 24) | (cond << 20) | (1 << 5);
>>  }
>>
>> +static inline uint32_t syn_vmrs_trap(int rt, int reg)
>> +{
>> +    return (EC_FPIDTRAP << ARM_EL_EC_SHIFT)
>> +        | ARM_EL_IL
>> +        | (1 << 24) | (0xe << 20) | (7 << 14)
>> +        | (reg << 10) | (rt << 5) | 1;
>> +}
>> +
>>  static inline uint32_t syn_sve_access_trap(void)
>>  {
>>      return EC_SVEACCESSTRAP << ARM_EL_EC_SHIFT;
>> diff --git a/target/arm/translate-vfp.inc.c 
>> b/target/arm/translate-vfp.inc.c
>> index 85c5ef897b..4c435b6c35 100644
>> --- a/target/arm/translate-vfp.inc.c
>> +++ b/target/arm/translate-vfp.inc.c
>> @@ -759,15 +759,21 @@ static bool trans_VMSR_VMRS(DisasContext *s, 
>> arg_VMSR_VMRS *a)
>>      }
>>
>>      if (a->l) {
>> +        TCGv_i32 tcg_rt, tcg_reg;
>> +
>>          /* VMRS, move VFP special register to gp register */
>>          switch (a->reg) {
>> +        case ARM_VFP_MVFR0:
>> +        case ARM_VFP_MVFR1:
>> +        case ARM_VFP_MVFR2:
>>          case ARM_VFP_FPSID:
>> +            tcg_rt = tcg_const_i32(a->rt);
>> +            tcg_reg = tcg_const_i32(a->reg);
>> +            gen_helper_check_hcr_el2_trap(cpu_env, tcg_rt, 
>> tcg_reg);
>> +            /* fall through */
>>          case ARM_VFP_FPEXC:
>>          case ARM_VFP_FPINST:
>>          case ARM_VFP_FPINST2:
>> -        case ARM_VFP_MVFR0:
>> -        case ARM_VFP_MVFR1:
>> -        case ARM_VFP_MVFR2:
>>              tmp = load_cpu_field(vfp.xregs[a->reg]);
>>              break;
>>          case ARM_VFP_FPSCR:
>> diff --git a/target/arm/vfp_helper.c b/target/arm/vfp_helper.c
>> index 9710ef1c3e..44e538e51c 100644
>> --- a/target/arm/vfp_helper.c
>> +++ b/target/arm/vfp_helper.c
>> @@ -1322,4 +1322,31 @@ float64 HELPER(frint64_d)(float64 f, void 
>> *fpst)
>>      return frint_d(f, fpst, 64);
>>  }
>>
>> +void HELPER(check_hcr_el2_trap)(CPUARMState *env, int rt, int reg)
>> +{
>> +    if (arm_current_el(env) != 1) {
>> +        return;
>> +    }
>
> I think we could move the EL1 check to translation time, couldn't we?

I think that depends whether the translated code is tagged by EL
or not, or if an exception entry (and exception return) invalidates
the JIT-ed code (and it this case it would have to be CPU-private).

I can perfectly imagine the same piece of code being executed both
at EL0 and EL1, and this would fail if it was executed using the
same JIT-ed code.

So if QEMU gives us the above as a guarantee, we're good. Otherwise,
we need this check. How can I find out?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

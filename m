Return-Path: <SRS0=/xnR=7K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64533C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 12:51:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E46812075A
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 12:51:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FR1uGFO1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E46812075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8636B4B232;
	Thu, 28 May 2020 08:51:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FtNRFTUpTqzI; Thu, 28 May 2020 08:51:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A8164B226;
	Thu, 28 May 2020 08:51:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAE804B1C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 08:51:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pyj04I2R7gng for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2020 08:51:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78D144B0E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 08:51:36 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 61666206F1;
 Thu, 28 May 2020 12:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590670295;
 bh=VYAwSKnjlk0HjjtuNyDMxeRTHpbjzETtCwkNhHk4Ng4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=FR1uGFO1nVoZfGSGOEBbv/FaGlSPTalA/J0vbhrFo9BSzAtLtoADZRY2T/kpVR2Wh
 GXJ10jcmxZbPP8Ra8hF4b3ue+yXDDrEilmZk/hBt5FQ3noYN7GwNolBwsZrSFsToAf
 mwwgy6xtSy0ZFs4aFCuLcuqdwjOPRukPH3IZxYkU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jeI0T-00FzPb-SH; Thu, 28 May 2020 13:51:33 +0100
MIME-Version: 1.0
Date: Thu, 28 May 2020 13:51:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Add emulation for 32bit guests accessing
 ACTLR2
In-Reply-To: <20200526161834.29165-4-james.morse@arm.com>
References: <20200526161834.29165-1-james.morse@arm.com>
 <20200526161834.29165-4-james.morse@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <1da83682a9ba3704601cb2071e8b638d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi James,

On 2020-05-26 17:18, James Morse wrote:
> ACTLR_EL1 is a 64bit register while the 32bit ACTLR is obviously 32bit.
> For 32bit software, the extra bits are accessible via ACTLR2... which
> KVM doesn't emulate.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> I'm not convinced this is endian safe, but it does match what
> kvm_inject_undef32() do.
> 
> The alternative would be to always read the 64bit value, and generate
> the 32bit offets like access_vm_reg() does.
> 
>  arch/arm64/include/asm/kvm_host.h    |  1 +
>  arch/arm64/kvm/sys_regs_generic_v8.c | 16 +++++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index 32c8a675e5a4..5b7538663a8e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -185,6 +185,7 @@ enum vcpu_sysreg {
>  #define c0_CSSELR	(CSSELR_EL1 * 2)/* Cache Size Selection Register */
>  #define c1_SCTLR	(SCTLR_EL1 * 2)	/* System Control Register */
>  #define c1_ACTLR	(ACTLR_EL1 * 2)	/* Auxiliary Control Register */
> +#define c1_ACTLR2	(c1_ACTLR + 1)	/* ACTLR top 32 bits */
>  #define c1_CPACR	(CPACR_EL1 * 2)	/* Coprocessor Access Control */
>  #define c2_TTBR0	(TTBR0_EL1 * 2)	/* Translation Table Base Register 0 
> */
>  #define c2_TTBR0_high	(c2_TTBR0 + 1)	/* TTBR0 top 32 bits */
> diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c
> b/arch/arm64/kvm/sys_regs_generic_v8.c
> index 9cb6b4c8355a..ed77bbb48e64 100644
> --- a/arch/arm64/kvm/sys_regs_generic_v8.c
> +++ b/arch/arm64/kvm/sys_regs_generic_v8.c
> @@ -30,6 +30,18 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
>  	return true;
>  }
> 
> +static bool access_cp15_actlr(struct kvm_vcpu *vcpu,
> +			      struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		return ignore_write(vcpu, p);
> +
> +	p->regval = vcpu_cp15(vcpu, r->reg);
> +	return true;
> +
> +}
> +
>  static void reset_actlr(struct kvm_vcpu *vcpu, const struct 
> sys_reg_desc *r)
>  {
>  	__vcpu_sys_reg(vcpu, ACTLR_EL1) = read_sysreg(actlr_el1);
> @@ -46,7 +58,9 @@ static const struct sys_reg_desc genericv8_sys_regs[] 
> = {
>  static const struct sys_reg_desc genericv8_cp15_regs[] = {
>  	/* ACTLR */
>  	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b001),
> -	  access_actlr },
> +	  access_cp15_actlr, NULL, c1_ACTLR },
> +	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b011),
> +	  access_cp15_actlr, NULL, c1_ACTLR2 },
>  };
> 
>  static struct kvm_sys_reg_target_table genericv8_target_table = {

I'd get rid of any form of storage, and go with something like 
(untested, again):

diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c 
b/arch/arm64/kvm/sys_regs_generic_v8.c
index 9cb6b4c8355a..1b2bf2d37612 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -26,13 +26,16 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
  	if (p->is_write)
  		return ignore_write(vcpu, p);

-	p->regval = vcpu_read_sys_reg(vcpu, ACTLR_EL1);
-	return true;
-}
+	p->regval = read_sysreg(actlr_el1);

-static void reset_actlr(struct kvm_vcpu *vcpu, const struct 
sys_reg_desc *r)
-{
-	__vcpu_sys_reg(vcpu, ACTLR_EL1) = read_sysreg(actlr_el1);
+	if (p->aarch32) {
+		if (r->Op2 & 2)
+			p->regval = upper_32_bit(p->regval);
+		else
+			p->regval = lower_32_bit(p->regval);
+	}
+
+	return true;
  }

  /*
@@ -40,13 +43,13 @@ static void reset_actlr(struct kvm_vcpu *vcpu, const 
struct sys_reg_desc *r)
   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
   */
  static const struct sys_reg_desc genericv8_sys_regs[] = {
-	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
+	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, },
  };

  static const struct sys_reg_desc genericv8_cp15_regs[] = {
  	/* ACTLR */
-	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b001),
-	  access_actlr },
+	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b001), access_actlr },
+	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b011), access_actlr },
  };

  static struct kvm_sys_reg_target_table genericv8_target_table = {

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

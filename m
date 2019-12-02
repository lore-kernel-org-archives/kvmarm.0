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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C58C432C3
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 14:07:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A505220833
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 14:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vadQ1699"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A505220833
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E26A14AEED;
	Mon,  2 Dec 2019 09:07:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z1Z2fcXlujFD; Mon,  2 Dec 2019 09:07:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEEBB4AEC5;
	Mon,  2 Dec 2019 09:07:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D3524AEC5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 09:07:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X+Mvf3JXCxKz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Dec 2019 09:06:59 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 323134AEC0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 09:06:59 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id u8so7940273wmu.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Dec 2019 06:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=IIKgyVfXVR5KF65RgKGn7faumOnflo+l3cHUH3+arw8=;
 b=vadQ1699t34cdwlFzTAcNkyyHoc9j67rsP/t6+XXaVn2RJfYN8dxKvKeiBW4hYUm+m
 eKVsqY/rvTD2pqbk7C66HvgbUJKyrY61A9btoUGIeddx0w478tH1ZuiMVGkOWskRR7rZ
 zCn1I0SXeXD7iR+/BTq+HesmsTd6elieQHup9JAZUkqmYaulSY7l3XusJQkfsYxRBbjj
 kEMt0257Dc/qa1SzJRI7rA0JQe6HLl0foHvosa3sGsbFkf4FntmCy8k1g6RCQGitWcbV
 p7z6FlXjA7Bb3qkAgToGmx22P04xNnryCPRbjlVAoib5g4JAVMvyWJGtZPaXr7MDiIF9
 rCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=IIKgyVfXVR5KF65RgKGn7faumOnflo+l3cHUH3+arw8=;
 b=UxrtT8+NuWxjcFaG/r/rUhbqzMyHNHpLAd1mWX3CXAV2OVo7stEPxyFKQ5SiYlV7WX
 QejgSzRNs8x5l1y3b6iUrCwl/YDr9W2XANZYXhsXJmbJuc8eK9dh6yFS6mCo4a7IjDd3
 Z1N7tCMpiRjmRVvTziL5koTtXmRGd1E8ZoS5rXQh8f6pD0kKFUVc4Os5YjcLBP8jqm9M
 59vbPiXfnsiLhndr3N2LALxb9Dhnh/2O6vqKqoGypbhG1H+15Z0udqyYAIbdeCLZFHP/
 YJkO5g2p3UJGNwEVu0HmVzR5LZBRegeXCg0qQsbFklsDoU6ClkfTfxb47P6AMi/jr2My
 eUng==
X-Gm-Message-State: APjAAAWPXN+yX1zXg/Tj1OqXKbWbIVpyqaFKaaThLQH8oB9+OkESPXlV
 ra9Hr2ViKeeWtQqJ6afRJMY=
X-Google-Smtp-Source: APXvYqzUWGmvlmgYureNsbHYinBd5jGr7Ro6i7jQbSn4dPeLU1H3eaXspWtpviWQjsAlGzLXheT1IA==
X-Received: by 2002:a1c:9602:: with SMTP id y2mr27102618wmd.23.1575295618134; 
 Mon, 02 Dec 2019 06:06:58 -0800 (PST)
Received: from localhost (ec2-34-244-242-0.eu-west-1.compute.amazonaws.com.
 [34.244.242.0])
 by smtp.gmail.com with ESMTPSA id n1sm12274254wrw.52.2019.12.02.06.06.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 02 Dec 2019 06:06:57 -0800 (PST)
Date: Mon, 2 Dec 2019 15:07:00 +0100
From: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/5] target/arm: Add support for missing Jazelle
 system registers
Message-ID: <20191202140700.GF25295@toto>
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191201122018.25808-6-maz@kernel.org>
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

On Sun, Dec 01, 2019 at 12:20:18PM +0000, Marc Zyngier wrote:
> QEMU lacks the minimum Jazelle implementation that is required
> by the architecture (everything is RAZ or RAZ/WI). Add it
> together with the HCR_EL2.TID0 trapping that goes with it.


Looks good to me:
Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>


> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/helper.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 0ba08d550a..d6fc198a97 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -6040,6 +6040,16 @@ static CPAccessResult access_aa32_tid3(CPUARMState *env, const ARMCPRegInfo *ri,
>      return CP_ACCESS_OK;
>  }
>  
> +static CPAccessResult access_jazelle(CPUARMState *env, const ARMCPRegInfo *ri,
> +                                     bool isread)
> +{
> +    if (arm_current_el(env) == 1 && (arm_hcr_el2_eff(env) & HCR_TID0)) {
> +        return CP_ACCESS_TRAP_EL2;
> +    }
> +
> +    return CP_ACCESS_OK;
> +}
> +
>  void register_cp_regs_for_features(ARMCPU *cpu)
>  {
>      /* Register all the coprocessor registers based on feature bits */
> @@ -6057,6 +6067,23 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>          define_arm_cp_regs(cpu, not_v8_cp_reginfo);
>      }
>  
> +    if (cpu_isar_feature(jazelle, cpu)) {
> +        ARMCPRegInfo jazelle_regs[] = {
> +            { .name = "JIDR",
> +              .cp = 14, .crn = 0, .crm = 0, .opc1 = 7, .opc2 = 0,
> +              .access = PL1_R, .accessfn = access_jazelle,
> +              .type = ARM_CP_CONST, .resetvalue = 0 },
> +            { .name = "JOSCR",
> +              .cp = 14, .crn = 1, .crm = 0, .opc1 = 7, .opc2 = 0,
> +              .access = PL1_RW, .type = ARM_CP_CONST, .resetvalue = 0 },
> +            { .name = "JMCR",
> +              .cp = 14, .crn = 2, .crm = 0, .opc1 = 7, .opc2 = 0,
> +              .access = PL1_RW, .type = ARM_CP_CONST, .resetvalue = 0 },
> +            REGINFO_SENTINEL
> +        };
> +
> +        define_arm_cp_regs(cpu, jazelle_regs);
> +    }
>      if (arm_feature(env, ARM_FEATURE_V6)) {
>          /* The ID registers all have impdef reset values */
>          ARMCPRegInfo v6_idregs[] = {
> -- 
> 2.20.1
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

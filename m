Return-Path: <SRS0=LttP=ZO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B474C432C0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 14:30:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9567120715
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 14:30:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Co8ETjtf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9567120715
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ACD44AEC7;
	Fri, 22 Nov 2019 09:30:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m-c8JENdeeZG; Fri, 22 Nov 2019 09:30:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F15664AEA6;
	Fri, 22 Nov 2019 09:30:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 302874AEA6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 09:24:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YEBUFRlpf3Rf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Nov 2019 09:24:28 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23C5A4AEA4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 09:24:28 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id z19so7825608wmk.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 06:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=oajMw6bopBcn2xw4RMcvIlJVCq05RCeEnEeSre+FJVY=;
 b=Co8ETjtfV0gzR1QpdPPQwfPj/qjJmc6LaZb0KH0TKTTFFGXzlg2c8HEzo2uYP7J/9O
 fbr7cmk4pFng1feWQSXmuEtHpFJrr4LjzhNVEAn4aUgP3y2lpDCUD+zbEnJi/2GE+5oT
 0RurZR9KPaOtlGS/pv3GhLLalM4XayKkpLK8scoBCOmxJM4k29+XD+SRULGSG4Vb842d
 1DBdSePSMWzfm3EDZ0oAGKGerWvIo8uCUEj52Xh1uMuu6iRcnNGPcmum8hF2isq8EI/z
 bosCMSKqHFrW3MAIhnigaeQmqXcQdlqF5016weC8Xxv3+555Fqw/p9/6T2/3A4HNuCFF
 47ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=oajMw6bopBcn2xw4RMcvIlJVCq05RCeEnEeSre+FJVY=;
 b=M9ccl2Fo/l9e1V7mam7/QRHFHZt7/R726JzeXJ/46lsT7+ryZES4U/le6mLGOAxzWd
 i9wQTk0azV+Tr7LWhBoT7mPszEUB8u5F8BmkB/LGgmdpY9GlyQmOA3dRqaxV/yL+bxe5
 zH0K3oYValI0XYRQioWs5HVNMoTDv9QP+3y1iwrXw5pkSTD+6xRXBIJJ4cAc1j1hoME0
 i1TZMJq05TNWhy7te3jN5ThO07N2EtzP8zHLQATOS9g+wF9xVGU6rScfwMw3H6hdcrC1
 uO9cciDCVb0HhXepCnZIEO+QVufFwS0e1pt652CYFG+XT0FIjgR8coP02mE0yMxHIPJo
 eC7g==
X-Gm-Message-State: APjAAAW8J3IHR04fqqEvSNdh6NB+3VPlFuEeNSxcGIlqbOljeHoPBNpo
 knlL627tIHe5N8PItcYsR6s=
X-Google-Smtp-Source: APXvYqz661gn7qGvXXtqOvcBXZQU3HPmGxoswa3pCIdYFrLZ4fUJlrN2n7GywYn1L5CzCp7GskH2pw==
X-Received: by 2002:a1c:7911:: with SMTP id l17mr16085320wme.107.1574432666836; 
 Fri, 22 Nov 2019 06:24:26 -0800 (PST)
Received: from localhost (ec2-34-244-242-0.eu-west-1.compute.amazonaws.com.
 [34.244.242.0])
 by smtp.gmail.com with ESMTPSA id c12sm2671980wro.96.2019.11.22.06.24.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Nov 2019 06:24:25 -0800 (PST)
Date: Fri, 22 Nov 2019 15:24:27 +0100
From: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] target/arm: Fix ISR_EL1 tracking when executing at EL2
Message-ID: <20191122142427.GA29312@toto>
References: <20191122135833.28953-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191122135833.28953-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailman-Approved-At: Fri, 22 Nov 2019 09:30:49 -0500
Cc: Will Deacon <will@kernel.org>, qemu-devel@nongnu.org,
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

On Fri, Nov 22, 2019 at 01:58:33PM +0000, Marc Zyngier wrote:
> The ARMv8 ARM states when executing at EL2, EL3 or Secure EL1,
> ISR_EL1 shows the pending status of the physical IRQ, FIQ, or
> SError interrupts.
> 
> Unfortunately, QEMU's implementation only considers the HCR_EL2
> bits, and ignores the current exception level. This means a hypervisor
> trying to look at its own interrupt state actually sees the guest
> state, which is unexpected and breaks KVM as of Linux 5.3.
> 
> Instead, check for the running EL and return the physical bits
> if not running in a virtualized context.
> 
> Fixes: 636540e9c40b
> Reported-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>


Looks good to me:
Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>



> ---
>  target/arm/helper.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index a089fb5a69..027fffbff6 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -1934,8 +1934,11 @@ static uint64_t isr_read(CPUARMState *env, const ARMCPRegInfo *ri)
>      CPUState *cs = env_cpu(env);
>      uint64_t hcr_el2 = arm_hcr_el2_eff(env);
>      uint64_t ret = 0;
> +    bool allow_virt = (arm_current_el(env) == 1 &&
> +                       (!arm_is_secure_below_el3(env) ||
> +                        (env->cp15.scr_el3 & SCR_EEL2)));
>  
> -    if (hcr_el2 & HCR_IMO) {
> +    if (allow_virt && (hcr_el2 & HCR_IMO)) {
>          if (cs->interrupt_request & CPU_INTERRUPT_VIRQ) {
>              ret |= CPSR_I;
>          }
> @@ -1945,7 +1948,7 @@ static uint64_t isr_read(CPUARMState *env, const ARMCPRegInfo *ri)
>          }
>      }
>  
> -    if (hcr_el2 & HCR_FMO) {
> +    if (allow_virt && (hcr_el2 & HCR_FMO)) {
>          if (cs->interrupt_request & CPU_INTERRUPT_VFIQ) {
>              ret |= CPSR_F;
>          }
> -- 
> 2.17.1
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

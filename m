Return-Path: <SRS0=8LgP=AH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C569C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 15:39:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 002B920773
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 15:39:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 002B920773
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 245144B115;
	Fri, 26 Jun 2020 11:39:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PcFwuZw8uvKg; Fri, 26 Jun 2020 11:39:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C00324B110;
	Fri, 26 Jun 2020 11:39:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61CB44B10A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 11:39:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OXjiEoIeDYF2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jun 2020 11:39:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 013CA4B101
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 11:39:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53F771042;
 Fri, 26 Jun 2020 08:39:14 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F1E33F6CF;
 Fri, 26 Jun 2020 08:39:12 -0700 (PDT)
Subject: Re: [PATCH v2 06/17] KVM: arm64: Introduce accessor for ctxt->sys_reg
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-7-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a9c3a43e-7850-e74d-5383-905885721ab4@arm.com>
Date: Fri, 26 Jun 2020 16:39:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615132719.1932408-7-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Hi,

On 6/15/20 2:27 PM, Marc Zyngier wrote:
> In order to allow the disintegration of the per-vcpu sysreg array,
> let's introduce a new helper (ctxt_sys_reg()) that returns the
> in-memory copy of a system register, picked from a given context.
>
> __vcpu_sys_reg() is rewritten to use this helper.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e7fd03271e52..5314399944e7 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -405,12 +405,17 @@ struct kvm_vcpu_arch {
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  
>  /*
> - * Only use __vcpu_sys_reg if you know you want the memory backed version of a
> - * register, and not the one most recently accessed by a running VCPU.  For
> - * example, for userspace access or for system registers that are never context
> - * switched, but only emulated.
> + * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
> + * memory backed version of a register, and not the one most recently
> + * accessed by a running VCPU.  For example, for userspace access or
> + * for system registers that are never context switched, but only
> + * emulated.
>   */
> -#define __vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
> +#define __ctxt_sys_reg(c,r)	(&(c)->sys_regs[(r)])
> +
> +#define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
> +
> +#define __vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))

This is confusing - __vcpu_sys_reg() returns the value, but __ctxt_sys_reg()
return a pointer to the value. Because of that, I made the mistake of thinking
that __vcpu_sys_reg() returns a pointer when reviewing the next patch in the
series, and I got really worried that stuff was seriously broken (it was not).

I'm not sure what the reasonable solution is, or even if there is one.

Some thoughts: we could have just one macro, ctxt_sys_reg() and dereference that
when we want the value; we could keep both and swap the macro definitions; or we
could encode the fact that a macro returns a pointer in the macro name (so we
would end up with __ctxt_sys_reg() -> __ctxt_sys_regp() and ctxt_sys_reg ->
__ctxt_sys_reg()).

What do you think?

Thanks,
Alex
>  
>  u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
>  void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

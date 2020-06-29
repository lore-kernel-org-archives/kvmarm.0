Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4247FC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 10:32:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C085920874
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 10:32:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C085920874
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22C2D4B405;
	Mon, 29 Jun 2020 06:32:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id myOUW0LrKIXU; Mon, 29 Jun 2020 06:32:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E53274B3FD;
	Mon, 29 Jun 2020 06:32:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9BD4B16F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 06:32:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ITgqq24JBOo1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 06:32:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74CF34B3FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 06:32:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3C231042;
 Mon, 29 Jun 2020 03:32:15 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.20.135])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D422C3F71E;
 Mon, 29 Jun 2020 03:32:14 -0700 (PDT)
Date: Mon, 29 Jun 2020 11:32:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/2] kvm/arm64: Rename HSR to ESR
Message-ID: <20200629103208.GA59769@C02TD0UTHF1T.local>
References: <20200629091841.88198-1-gshan@redhat.com>
 <20200629091841.88198-2-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200629091841.88198-2-gshan@redhat.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jun 29, 2020 at 07:18:40PM +1000, Gavin Shan wrote:
> kvm/arm32 isn't supported since commit 541ad0150ca4 ("arm: Remove
> 32bit KVM host support"). So HSR isn't meaningful since then. This
> renames HSR to ESR accordingly. This shouldn't cause any functional
> changes:
> 
>    * Rename kvm_vcpu_get_hsr() to kvm_vcpu_get_esr() to make the
>      function names self-explanatory.
>    * Rename variables from @hsr to @esr to make them self-explanatory.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>

At a high-level, I agree that we should move to the `esr` naming to
match the architecture and minimize surprise. However, I think there are
some ABI changes here, which *are* funcitonal changes, and those need to
be avoided.

[...]

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index ba85bb23f060..d54345573a88 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -140,7 +140,7 @@ struct kvm_guest_debug_arch {
>  };
>  
>  struct kvm_debug_exit_arch {
> -	__u32 hsr;
> +	__u32 esr;
>  	__u64 far;	/* used for watchpoints */
>  };

This is userspace ABI, and changing this *will* break userspace. This
*is* a functional change.

NAK to this specifically. At best these should be a comment here that
this is naming is legacym but must stay for ABI reasons.

[...]

> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 4c71270cc097..ee4f691b16ff 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -42,7 +42,7 @@ TRACE_EVENT(kvm_exit,
>  		__entry->vcpu_pc		= vcpu_pc;
>  	),
>  
> -	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
> +	TP_printk("%s: ESR_EC: 0x%04x (%s), PC: 0x%08lx",
>  		  __print_symbolic(__entry->ret, kvm_arm_exception_type),
>  		  __entry->esr_ec,
>  		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class),

Likewise, isn't all the tracepoint format stuff ABI? I'm not comfortable
that we can change this.

Thanks,
Mark.

> @@ -50,27 +50,27 @@ TRACE_EVENT(kvm_exit,
>  );
>  
>  TRACE_EVENT(kvm_guest_fault,
> -	TP_PROTO(unsigned long vcpu_pc, unsigned long hsr,
> +	TP_PROTO(unsigned long vcpu_pc, unsigned long esr,
>  		 unsigned long hxfar,
>  		 unsigned long long ipa),
> -	TP_ARGS(vcpu_pc, hsr, hxfar, ipa),
> +	TP_ARGS(vcpu_pc, esr, hxfar, ipa),
>  
>  	TP_STRUCT__entry(
>  		__field(	unsigned long,	vcpu_pc		)
> -		__field(	unsigned long,	hsr		)
> +		__field(	unsigned long,	esr		)
>  		__field(	unsigned long,	hxfar		)
>  		__field(   unsigned long long,	ipa		)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->vcpu_pc		= vcpu_pc;
> -		__entry->hsr			= hsr;
> +		__entry->esr			= esr;
>  		__entry->hxfar			= hxfar;
>  		__entry->ipa			= ipa;
>  	),
>  
> -	TP_printk("ipa %#llx, hsr %#08lx, hxfar %#08lx, pc %#08lx",
> -		  __entry->ipa, __entry->hsr,
> +	TP_printk("ipa %#llx, esr %#08lx, hxfar %#08lx, pc %#08lx",
> +		  __entry->ipa, __entry->esr,
>  		  __entry->hxfar, __entry->vcpu_pc)
>  );
>  
> diff --git a/arch/arm64/kvm/trace_handle_exit.h b/arch/arm64/kvm/trace_handle_exit.h
> index 2c56d1e0f5bd..94ef1a98e609 100644
> --- a/arch/arm64/kvm/trace_handle_exit.h
> +++ b/arch/arm64/kvm/trace_handle_exit.h
> @@ -139,18 +139,18 @@ TRACE_EVENT(trap_reg,
>  );
>  
>  TRACE_EVENT(kvm_handle_sys_reg,
> -	TP_PROTO(unsigned long hsr),
> -	TP_ARGS(hsr),
> +	TP_PROTO(unsigned long esr),
> +	TP_ARGS(esr),
>  
>  	TP_STRUCT__entry(
> -		__field(unsigned long,	hsr)
> +		__field(unsigned long,	esr)
>  	),
>  
>  	TP_fast_assign(
> -		__entry->hsr = hsr;
> +		__entry->esr = esr;
>  	),
>  
> -	TP_printk("HSR 0x%08lx", __entry->hsr)
> +	TP_printk("ESR 0x%08lx", __entry->esr)
>  );
>  
>  TRACE_EVENT(kvm_sys_access,
> -- 
> 2.23.0
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

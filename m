Return-Path: <SRS0=uW/I=UL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D0FC31E47
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47A212173C
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47A212173C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE19E4A4F9;
	Wed, 12 Jun 2019 08:49:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VTNk4f3-LPx7; Wed, 12 Jun 2019 08:49:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 731274A4FB;
	Wed, 12 Jun 2019 08:49:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FBFD4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 08:49:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k9ekZpnTiZ4a for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jun 2019 08:49:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D24B34A4F0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 08:49:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 761CF28;
 Wed, 12 Jun 2019 05:49:18 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D64ED3F246;
 Wed, 12 Jun 2019 05:49:15 -0700 (PDT)
Subject: Re: [PATCH v1 2/5] KVM: arm/arm64: Adjust entry/exit and trap related
 tracepoints
To: Zenghui Yu <yuzenghui@huawei.com>
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
 <1560330526-15468-3-git-send-email-yuzenghui@huawei.com>
From: James Morse <james.morse@arm.com>
Message-ID: <977f8f8c-72b4-0287-4b1c-47a0d6f1fd6e@arm.com>
Date: Wed, 12 Jun 2019 13:49:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1560330526-15468-3-git-send-email-yuzenghui@huawei.com>
Content-Language: en-GB
Cc: acme@redhat.com, kvm@vger.kernel.org, marc.zyngier@arm.com,
 catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
 acme@kernel.org, linux-perf-users@vger.kernel.org, peterz@infradead.org,
 alexander.shishkin@linux.intel.com, mingo@redhat.com, linuxarm@huawei.com,
 ganapatrao.kulkarni@cavium.com, namhyung@kernel.org, jolsa@redhat.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 xiexiangyou@huawei.com
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

On 12/06/2019 10:08, Zenghui Yu wrote:
> Currently, we use trace_kvm_exit() to report exception type (e.g.,
> "IRQ", "TRAP") and exception class (ESR_ELx's bit[31:26]) together.

(They both caused an exit!)


> But hardware only saves the exit class to ESR_ELx on synchronous

EC is the 'Exception Class'. Exit is KVM/Linux's terminology.


> exceptions, not on asynchronous exceptions. When the guest exits
> due to external interrupts, we will get tracing output like:
> 
> 	"kvm_exit: IRQ: HSR_EC: 0x0000 (UNKNOWN), PC: 0xffff87259e30"
> 
> Obviously, "HSR_EC" here is meaningless.

I assume we do it this way so there is only one guest-exit tracepoint that catches all exits.
I don't think its a problem if user-space has to know the EC isn't set for asynchronous
exceptions, this is a property of the architecture and anything using these trace-points
is already arch specific.


> This patch splits "exit" and "trap" events by adding two tracepoints
> explicitly in handle_trap_exceptions(). Let trace_kvm_exit() report VM
> exit events, and trace_kvm_trap_exit() report VM trap events.
> 
> These tracepoints are adjusted also in preparation for supporting
> 'perf kvm stat' on arm64.

Because the existing tracepoints are ABI, I don't think we can change them.

We can add new ones if there is something that a user reasonably needs to trace, and can't
be done any other way.

What can't 'perf kvm stat' do with the existing trace points?


> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 516aead..af3c732 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -264,7 +264,10 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		exit_handle_fn exit_handler;
>  
>  		exit_handler = kvm_get_exit_handler(vcpu);
> +		trace_kvm_trap_enter(vcpu->vcpu_id,
> +				     kvm_vcpu_trap_get_class(vcpu));
>  		handled = exit_handler(vcpu, run);
> +		trace_kvm_trap_exit(vcpu->vcpu_id);
>  	}

Why are there two? Are you using this to benchmark the exit_handler()?

As we can't remove the EC from the exit event, I don't think this tells us anything new.


> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 90cedeb..9f63fd9 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -758,7 +758,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		/**************************************************************
>  		 * Enter the guest
>  		 */
> -		trace_kvm_entry(*vcpu_pc(vcpu));
> +		trace_kvm_entry(vcpu->vcpu_id, *vcpu_pc(vcpu));

Why do you need the PC? It was exported on exit.
(its mostly junk for user-space anyway, you can't infer anything from it)


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

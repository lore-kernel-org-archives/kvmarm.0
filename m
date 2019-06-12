Return-Path: <SRS0=uW/I=UL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C994C31E46
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A2FB20684
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A2FB20684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BDA34A523;
	Wed, 12 Jun 2019 08:48:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fLAnjFSL85-a; Wed, 12 Jun 2019 08:48:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 348B74A520;
	Wed, 12 Jun 2019 08:48:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57DA14A4FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 08:48:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wFjJzk1o9cnT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jun 2019 08:48:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E296B4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 08:48:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80036337;
 Wed, 12 Jun 2019 05:48:09 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 39D8E3F246;
 Wed, 12 Jun 2019 05:48:07 -0700 (PDT)
Subject: Re: [PATCH v1 1/5] KVM: arm/arm64: Remove kvm_mmio_emulate tracepoint
To: Zenghui Yu <yuzenghui@huawei.com>
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
 <1560330526-15468-2-git-send-email-yuzenghui@huawei.com>
From: James Morse <james.morse@arm.com>
Message-ID: <e915c19a-51df-be88-ea3a-7c9a211f4518@arm.com>
Date: Wed, 12 Jun 2019 13:48:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1560330526-15468-2-git-send-email-yuzenghui@huawei.com>
Content-Language: en-GB
Cc: acme@redhat.com, kvm@vger.kernel.org, marc.zyngier@arm.com,
 catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
 acme@kernel.org, linuxarm@huawei.com, linux-perf-users@vger.kernel.org,
 peterz@infradead.org, alexander.shishkin@linux.intel.com, mingo@redhat.com,
 xiexiangyou@huawei.com, ganapatrao.kulkarni@cavium.com, namhyung@kernel.org,
 jolsa@redhat.com, kvmarm@lists.cs.columbia.edu,
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

Hi,

On 12/06/2019 10:08, Zenghui Yu wrote:
> In current KVM/ARM code, no one will invoke trace_kvm_mmio_emulate().
> Remove this TRACE_EVENT definition.

Oooer. We can't just go removing these things, they are visible to user-space.

I recall an article on this: https://lwn.net/Articles/737530/
"Another attempt to address the tracepoint ABI problem"

I agree this is orphaned, it was added by commit 45e96ea6b369 ("KVM: ARM: Handle I/O
aborts"), but there never was a caller.

The problem with removing it is /sys/kernel/debug/tracing/events/kvm/kvm_mmio_emulate
disappears. Any program relying on that being present (but useless) is now broken.


Thanks,

James


> diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
> index 204d210..8b7dff2 100644
> --- a/virt/kvm/arm/trace.h
> +++ b/virt/kvm/arm/trace.h
> @@ -114,27 +114,6 @@
>  		  __entry->type, __entry->vcpu_idx, __entry->irq_num, __entry->level)
>  );
>  
> -TRACE_EVENT(kvm_mmio_emulate,
> -	TP_PROTO(unsigned long vcpu_pc, unsigned long instr,
> -		 unsigned long cpsr),
> -	TP_ARGS(vcpu_pc, instr, cpsr),
> -
> -	TP_STRUCT__entry(
> -		__field(	unsigned long,	vcpu_pc		)
> -		__field(	unsigned long,	instr		)
> -		__field(	unsigned long,	cpsr		)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->vcpu_pc		= vcpu_pc;
> -		__entry->instr			= instr;
> -		__entry->cpsr			= cpsr;
> -	),
> -
> -	TP_printk("Emulate MMIO at: 0x%08lx (instr: %08lx, cpsr: %08lx)",
> -		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
> -);
> -
>  TRACE_EVENT(kvm_unmap_hva_range,
>  	TP_PROTO(unsigned long start, unsigned long end),
>  	TP_ARGS(start, end),
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

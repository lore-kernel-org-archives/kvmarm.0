Return-Path: <SRS0=6J9q=BV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4DBC433DF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 10:47:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54A4520756
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 10:47:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54A4520756
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEF564B53A;
	Tue, 11 Aug 2020 06:47:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 09m4lm93XOyw; Tue, 11 Aug 2020 06:47:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 896F34B530;
	Tue, 11 Aug 2020 06:47:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1F5B4B52A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 06:47:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ErxiQnN97zEN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2020 06:47:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14B814B526
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 06:47:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BC0931B;
 Tue, 11 Aug 2020 03:47:46 -0700 (PDT)
Received: from [10.37.12.74] (unknown [10.37.12.74])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7CEC3F22E;
 Tue, 11 Aug 2020 03:47:42 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: Only reschedule if
 MMU_NOTIFIER_RANGE_BLOCKABLE is not set
To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200811102725.7121-1-will@kernel.org>
 <20200811102725.7121-3-will@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <1b326944-c4aa-eb52-b7dc-a77f9eecae63@arm.com>
Date: Tue, 11 Aug 2020 11:52:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200811102725.7121-3-will@kernel.org>
Content-Language: en-US
Cc: tsbogend@alpha.franken.de, maz@kernel.org, sean.j.christopherson@intel.com,
 paulus@ozlabs.org, stable@vger.kernel.org, pbonzini@redhat.com
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

On 08/11/2020 11:27 AM, Will Deacon wrote:
> When an MMU notifier call results in unmapping a range that spans multiple
> PGDs, we end up calling into cond_resched_lock() when crossing a PGD boundary,
> since this avoids running into RCU stalls during VM teardown. Unfortunately,
> if the VM is destroyed as a result of OOM, then blocking is not permitted
> and the call to the scheduler triggers the following BUG():
> 
>   | BUG: sleeping function called from invalid context at arch/arm64/kvm/mmu.c:394
>   | in_atomic(): 1, irqs_disabled(): 0, non_block: 1, pid: 36, name: oom_reaper
>   | INFO: lockdep is turned off.
>   | CPU: 3 PID: 36 Comm: oom_reaper Not tainted 5.8.0 #1
>   | Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
>   | Call trace:
>   |  dump_backtrace+0x0/0x284
>   |  show_stack+0x1c/0x28
>   |  dump_stack+0xf0/0x1a4
>   |  ___might_sleep+0x2bc/0x2cc
>   |  unmap_stage2_range+0x160/0x1ac
>   |  kvm_unmap_hva_range+0x1a0/0x1c8
>   |  kvm_mmu_notifier_invalidate_range_start+0x8c/0xf8
>   |  __mmu_notifier_invalidate_range_start+0x218/0x31c
>   |  mmu_notifier_invalidate_range_start_nonblock+0x78/0xb0
>   |  __oom_reap_task_mm+0x128/0x268
>   |  oom_reap_task+0xac/0x298
>   |  oom_reaper+0x178/0x17c
>   |  kthread+0x1e4/0x1fc
>   |  ret_from_fork+0x10/0x30
> 
> Use the new 'flags' argument to kvm_unmap_hva_range() to ensure that we
> only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is set in the notifier
> flags.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 8b3405e345b5 ("kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd")
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

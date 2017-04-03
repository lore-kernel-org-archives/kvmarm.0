From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v3] kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd
Date: Mon, 3 Apr 2017 15:25:58 +0100
Message-ID: <9b7c4903-9da1-4b08-a288-3a3bd0ae551c@arm.com>
References: <1491228763-23450-1-git-send-email-suzuki.poulose@arm.com>
 <20170403142211.GE18905@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170403142211.GE18905@leverpostej>
Sender: stable-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, andreyknvl@google.com, dvyukov@google.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, ard.biesheuvel@linaro.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/04/17 15:22, Mark Rutland wrote:
> Hi,
>
> On Mon, Apr 03, 2017 at 03:12:43PM +0100, Suzuki K Poulose wrote:
>> In kvm_free_stage2_pgd() we don't hold the kvm->mmu_lock while calling
>> unmap_stage2_range() on the entire memory range for the guest. This could
>> cause problems with other callers (e.g, munmap on a memslot) trying to
>> unmap a range. And since we have to unmap the entire Guest memory range
>> holding a spinlock, make sure we yield the lock if necessary, after we
>> unmap each PUD range.
>>
>> Fixes: commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
>> Cc: stable@vger.kernel.org # v3.10+
>> Cc: Paolo Bonzini <pbonzin@redhat.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> [ Avoid vCPU starvation and lockup detector warnings ]
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> ---
>> Changes since V2:
>>  - Restrict kvm->mmu_lock relaxation to bigger ranges in unmap_stage2_range(),
>>    to avoid possible issues like [0]
>>
>>  [0] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-March/498210.html
>
> Sorry if I'm being thick, but how does restricting this to a larger
> range help with the "sleeping function called from invalid context"
> issue?
>
> Surely that just makes it rarer?

The issue in [0] arises when we try to unmap a page at stage2, while holding a
different spinlock and we try to do cond_resched_lock(), thinking we might
spend too much time holding the lock. With this patch, we don't try to relax
the lock if we are dealing with smaller sizes and hence avoids cond_resched_lock().
So in effect it tries to avoid the cond_resched_lock() when we could finish
the operation soon enough.

Hope that helps.

Suzuki

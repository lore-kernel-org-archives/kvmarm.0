From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v4 05/20] kvm: arm64: Add helper for loading the stage2
 setting for a VM
Date: Mon, 3 Sep 2018 11:03:25 +0100
Message-ID: <d0349651-6c29-26d4-012e-01df601494e7@arm.com>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
 <1531905547-25478-6-git-send-email-suzuki.poulose@arm.com>
 <20180830093953.GA4029@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B9B4A1FF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 06:03:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MeSQ4xs3mBy3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 06:03:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03EA54A0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 06:03:31 -0400 (EDT)
In-Reply-To: <20180830093953.GA4029@e113682-lin.lund.arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/08/18 10:39, Christoffer Dall wrote:
> On Wed, Jul 18, 2018 at 10:18:48AM +0100, Suzuki K Poulose wrote:
>> We load the stage2 context of a guest for different operations,
>> including running the guest and tlb maintenance on behalf of the
>> guest. As of now only the vttbr is private to the guest, but this
>> is about to change with IPA per VM. Add a helper to load the stage2
>> configuration for a VM, which could do the right thing with the
>> future changes.
>>
>> Cc: Christoffer Dall <cdall@kernel.org>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v2:
>>   - New patch
>> ---
>>   arch/arm64/include/asm/kvm_hyp.h | 6 ++++++
>>   arch/arm64/kvm/hyp/switch.c      | 2 +-
>>   arch/arm64/kvm/hyp/tlb.c         | 4 ++--
>>   3 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
>> index 384c343..82f9994 100644
>> --- a/arch/arm64/include/asm/kvm_hyp.h
>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>> @@ -155,5 +155,11 @@ void deactivate_traps_vhe_put(void);
>>   u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
>>   void __noreturn __hyp_do_panic(unsigned long, ...);
>>   
>> +/* Must be called from hyp code running at EL2 */
> 
> more importantly than having to run this at EL2, is that it must have
> gone through the proper sequence of update_vttbr() and disabling
> interrupts to avoid using a stale VMID.

Right, I will update the comment.

Cheers
Suzuki

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 6/9] KVM: arm/arm64: Limit icache invalidation to
 prefetch aborts
Date: Thu, 02 Nov 2017 10:36:35 +0000
Message-ID: <87lgjpufv0.fsf@on-the-bus.cambridge.arm.com>
References: <20171023161122.15291-1-marc.zyngier@arm.com>
 <20171023161122.15291-7-marc.zyngier@arm.com>
 <20171101101727.ysc65qlxwsqe5sfq@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C091949D14
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 06:34:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cu5Sden2ZsKu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Nov 2017 06:34:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9536141185
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 06:34:58 -0400 (EDT)
In-Reply-To: <20171101101727.ysc65qlxwsqe5sfq@kamzik.brq.redhat.com> (Andrew
 Jones's message of "Wed, 1 Nov 2017 11:17:27 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 01 2017 at 11:17:27 am GMT, Andrew Jones <drjones@redhat.com> wrote:
> On Mon, Oct 23, 2017 at 05:11:19PM +0100, Marc Zyngier wrote:
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 2174244f6317..0417c8e2a81c 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1292,7 +1292,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  			  unsigned long fault_status)
>>  {
>>  	int ret;
>> -	bool write_fault, writable, hugetlb = false, force_pte = false;
>> +	bool write_fault, exec_fault, writable, hugetlb = false, force_pte = false;
>>  	unsigned long mmu_seq;
>>  	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
>>  	struct kvm *kvm = vcpu->kvm;
>> @@ -1304,7 +1304,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	unsigned long flags = 0;
>>  
>>  	write_fault = kvm_is_write_fault(vcpu);
>> -	if (fault_status == FSC_PERM && !write_fault) {
>> +	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
>> +	VM_BUG_ON(write_fault && exec_fault);
>
> This VM_BUG_ON can never fire as long as kvm_is_write_fault() is
> defined as
>
>  {
>    if (kvm_vcpu_trap_is_iabt(vcpu))
>        return false;
>    return kvm_vcpu_dabt_iswrite(vcpu);
>  }

That's indeed what I expect. But given that the code now relies on this
property, I chose to make it explicit.

Or are you seeing a better way of making this an invariant?

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 10/26] KVM: arm/arm64: Fix idmap size and alignment
Date: Fri, 16 Mar 2018 08:55:32 +0000
Message-ID: <6421e60d-1e11-5590-038f-71f09f02af30@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-11-marc.zyngier@arm.com> <5AAAC664.8070400@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5AAAC664.8070400@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/03/18 19:15, James Morse wrote:
> On 14/03/18 16:50, Marc Zyngier wrote:
>> Although the idmap section of KVM can only be at most 4kB and
>> must be aligned on a 4kB boundary, the rest of the code expects
>> it to be page aligned. Things get messy when tearing down the
>> HYP page tables when PAGE_SIZE is 64K, and the idmap section isn't
>> 64K aligned.
>>
>> Let's fix this by computing aligned boundaries that the HYP code
>> will use.
> 
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 0e5cfffb4c21..a9e0513868e9 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1815,7 +1815,9 @@ int kvm_mmu_init(void)
>>  	int err;
>>  
>>  	hyp_idmap_start = kvm_virt_to_phys(__hyp_idmap_text_start);
>> +	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
>>  	hyp_idmap_end = kvm_virt_to_phys(__hyp_idmap_text_end);
>> +	hyp_idmap_end = ALIGN(hyp_idmap_end, PAGE_SIZE);
>>  	hyp_idmap_vector = kvm_virt_to_phys(__kvm_hyp_init);
>>  
>>  	/*
> 
> 
> This makes the:
> | hyp_idmap_start != (unsigned long)__hyp_idmap_text_start
> 
> check below look funny, but that must be for 32bit which only has 4K pages (I
> think), so its behaviour hasn't changed.

Yes, that's to handle the 2/2 split on 32bit where some funnies may
happen, see d2896d4b55b2 ("arm: KVM: Fix idmap overlap detection when
the kernel is idmap'ed").

> Reviewed-by: James Morse <james.morse@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

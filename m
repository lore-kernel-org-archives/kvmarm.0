From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH 06/14] KVM: arm/arm64: Factor out VMID into struct kvm_vmid
Date: Fri, 22 Feb 2019 11:42:46 +0000
Message-ID: <44bd2df6-8011-c77f-a83a-95c3529287c0@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
 <20190124140032.8588-7-christoffer.dall@arm.com>
 <1978ee57-c7bd-e55a-4e77-ad0b4b62d1d1@arm.com>
 <20190222091848.21f7f8e6@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190222091848.21f7f8e6@why.wild-wind.fr.eu.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, Christoffer Dall <Christoffer.Dall@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 22/02/2019 09:18, Marc Zyngier wrote:
> On Thu, 21 Feb 2019 11:02:56 +0000
> Julien Grall <Julien.Grall@arm.com> wrote:
> 
> Hi Julien,
> 
>> Hi Christoffer,
>>
>> On 24/01/2019 14:00, Christoffer Dall wrote:
>>> Note that to avoid mapping the kvm_vmid_bits variable into hyp, we
>>> simply forego the masking of the vmid value in kvm_get_vttbr and rely on
>>> update_vmid to always assign a valid vmid value (within the supported
>>> range).
>>
>> [...]
>>
>>> -	kvm->arch.vmid = kvm_next_vmid;
>>> +	vmid->vmid = kvm_next_vmid;
>>>    	kvm_next_vmid++;
>>> -	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
>>> -
>>> -	/* update vttbr to be used with the new vmid */
>>> -	pgd_phys = virt_to_phys(kvm->arch.pgd);
>>> -	BUG_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm));
>>> -	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
>>> -	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid | cnp;
>>> +	kvm_next_vmid &= (1 << kvm_get_vmid_bits()) - 1;
>>
>> The arm64 version of kvm_get_vmid_bits does not look cheap. Indeed it required
>> to read the sanitized value of SYS_ID_AA64MMFR1_EL1 that is implemented using
>> the function bsearch.
>>
>> So wouldn't it be better to keep kvm_vmid_bits variable for use in update_vttbr()?
> 
> How often does this happen? Can you measure this overhead at all?
> 
> My understanding is that we hit this path on rollover only, having IPIed
> all CPUs and invalidated all TLBs. I seriously doubt you can observe
> any sort of overhead at all, given that it is so incredibly rare. But
> feel free to prove me wrong!

That would happen on roll-over and the first time you allocate VMID for the VM.

I am planning to run some test with 3-bit VMIDs and provide them next week.

Cheers,

-- 
Julien Grall

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/6] arm64: KVM: Add support for Stage-2 control of
 memory types and cacheability
Date: Tue, 12 Jun 2018 13:55:29 +0100
Message-ID: <f58e92f9-0c4c-0ca0-32a4-0fc7e8bae2ea@arm.com>
References: <20180530124706.25284-1-marc.zyngier@arm.com>
 <20180530124706.25284-2-marc.zyngier@arm.com>
 <20180531114938.2w4sbi2nkvqyc3jt@lakrids.cambridge.arm.com>
 <6675e8b0-7c34-ce1f-99e2-1f63566b3426@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <6675e8b0-7c34-ce1f-99e2-1f63566b3426@arm.com>
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
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 31/05/18 13:38, Marc Zyngier wrote:
> On 31/05/18 12:49, Mark Rutland wrote:
>> On Wed, May 30, 2018 at 01:47:01PM +0100, Marc Zyngier wrote:
>>> Up to ARMv8.3, the combinaison of Stage-1 and Stage-2 attributes
>>> results in the strongest attribute of the two stages.  This means
>>> that the hypervisor has to perform quite a lot of cache maintenance
>>> just in case the guest has some non-cacheable mappings around.
>>>
>>> ARMv8.4 solves this problem by offering a different mode (FWB) where
>>> Stage-2 has total control over the memory attribute (this is limited
>>> to systems where both I/O and instruction caches are coherent with
>>
>> s/caches/fetches/ -- the I-caches themselves aren't coherent with the
>> D-caches (or we could omit I-cache maintenance).
>>
>> i.e. this implies IDC, but not DIC.
> 
> It may imply IDC behaviour, but not quite IDC itself. I agree, this
> looks dodgy. I've asked for clarification on the spec.

I've now received confirmation that FWB implies the IDC behaviour. It
doesn't guarantee that CTR_EL0.IDC will be set though, only that
CLIDR_EL1.LOU{U,IS} are both 0.

> 
>>
>>> the dcache). This is achieved by having a different set of memory
>>> attributes in the page tables, and a new bit set in HCR_EL2.
>>>
>>> On such a system, we can then safely sidestep any form of dcache
>>> management.
>>>
>>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>
>>>  static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>>>  {
>>> @@ -268,7 +269,10 @@ static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
>>>  {
>>>  	void *va = page_address(pfn_to_page(pfn));
>>>  
>>> -	kvm_flush_dcache_to_poc(va, size);
>>> +	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>>> +		kvm_flush_dcache_to_poc(va, size);
>>> +	else
>>> +		kvm_flush_dcache_to_pou(va, size);
>>>  }
>>
>> Te commit message said instruction fetches were coherent, and that no
>> D-cache maintenance was necessary, so why do we need maintenance to the
>> PoU?
> 
> That maintenance will be elided if we actually have IDC set. I'm happy
> to drop it once I have confirmation that we have an identical behaviour.

Given the above, I'll drop the clean to PoU.

> 
>>
>>> +static void cpu_has_fwb(const struct arm64_cpu_capabilities *__unused)
>>> +{
>>> +	u64 val = read_sysreg_s(SYS_CLIDR_EL1);
>>> +
>>> +	/* Check that CLIDR_EL1.LOU{U,IS} are both 0 */
>>> +	WARN_ON(val & (7 << 27 | 7 << 21));
>>> +}
>>
>> What about CTR_EL0.IDC?
> 
> Again, that depends on whether FWB implies IDC or not.

The spec doesn't seem to guarantee IDC, but does mandate that
CLIDR_EL1.LOU{U,IS} are set 0.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

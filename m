From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v2 4/5] arm64: Use __tlbi_dsb() macros in KVM code
Date: Fri, 6 Jan 2017 10:51:53 -0500
Message-ID: <f5020a04-5fc7-26b5-1ded-c58e159bc722@codeaurora.org>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-4-cov@codeaurora.org>
 <20170103155756.GB14183@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170103155756.GB14183@leverpostej>
Sender: kvm-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, timur@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/03/2017 10:57 AM, Mark Rutland wrote:
> On Thu, Dec 29, 2016 at 05:43:34PM -0500, Christopher Covington wrote:
>> Refactor the KVM code to use the newly introduced __tlbi_dsb macros, which
>> will allow an errata workaround that repeats tlbi dsb sequences to only
>> change one location. This is not intended to change the generated assembly
>> and comparing before and after vmlinux objdump shows no functional changes.

@@ -32,7 +33,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	 * whole of Stage-1. Weep...
 	 */
 	ipa >>= 12;
-	asm volatile("tlbi ipas2e1is, %0" : : "r" (ipa));
+	__tlbi_dsb(ipas2e1is, ish, ipa);
 
 	/*
 	 * We have to ensure completion of the invalidation at Stage-2,

>> @@ -40,9 +41,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
>>  	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
>>  	 * the Stage-1 invalidation happened first.
>>  	 */
>> -	dsb(ish);
> 
> Looks like this got accidentally removed. AFAICT it is still necessary.

Not removed, just hoisted above the comment block to the previous patch hunk.

>> -	asm volatile("tlbi vmalle1is" : : );
>> -	dsb(ish);
>> +	__tlbi_dsb(vmalle1is, ish);
>>  	isb();

Thanks,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.

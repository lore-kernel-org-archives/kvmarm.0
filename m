From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/11] KVM/MMU: Flush tlb with range list in sync_page()
Date: Mon, 7 Jan 2019 17:07:58 +0100
Message-ID: <99e47cc1-43d6-ff05-46b8-6a96ebc34b2a@redhat.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
 <20190104085405.40356-7-Tianyu.Lan@microsoft.com>
 <20190104163035.GC11288@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2490E4A3EA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jan 2019 11:08:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X+ovNrDjVBPl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jan 2019 11:08:03 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F4264A3E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jan 2019 11:08:03 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id 96so1003434wrb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jan 2019 08:08:02 -0800 (PST)
In-Reply-To: <20190104163035.GC11288@linux.intel.com>
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
To: Sean Christopherson <sean.j.christopherson@intel.com>, lantianyu1986@gmail.com
Cc: kvm@vger.kernel.org, benh@kernel.crashing.org, will.deacon@arm.com, linux-mips@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, catalin.marinas@arm.com, jhogan@kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/01/19 17:30, Sean Christopherson wrote:
>> +
>> +		if (kvm_available_flush_tlb_with_range()
>> +		    && (tmp_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)) {
>> +			struct kvm_mmu_page *leaf_sp = page_header(sp->spt[i]
>> +					& PT64_BASE_ADDR_MASK);
>> +			list_add(&leaf_sp->flush_link, &flush_list);
>> +		}
>> +
>> +		set_spte_ret |= tmp_spte_ret;
>> +
>>  	}
>>  
>>  	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)
>> -		kvm_flush_remote_tlbs(vcpu->kvm);
>> +		kvm_flush_remote_tlbs_with_list(vcpu->kvm, &flush_list);
> This is a bit confusing and potentially fragile.  It's not obvious that
> kvm_flush_remote_tlbs_with_list() is guaranteed to call
> kvm_flush_remote_tlbs() when kvm_available_flush_tlb_with_range() is
> false, and you're relying on the kvm_flush_remote_tlbs_with_list() call
> chain to never optimize away the empty list case.  Rechecking
> kvm_available_flush_tlb_with_range() isn't expensive.
> 

Alternatively, do not check it during the loop: always build the
flush_list, and always call kvm_flush_remote_tlbs_with_list.  The
function can then check whether the list is empty, and the OR of
tmp_spte_ret on every iteration goes away.

Paolo

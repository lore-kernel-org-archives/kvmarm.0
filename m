Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2614137A2;
	Mon,  3 Aug 2026 14:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785769047; cv=none; b=TkTjwAzL1W70QZfMf28HfHnFsgQdN8n1L+MstccGeribYYlXYzE4ShMZQxxs33ZSbzNuDG8c0wuEBwx/5v5I6e2vOyxdGRtRxpzvn9+Z7eeOK5FdlKlvsj/UMZnjiRKamHp/prp/KUI2ps5MgjaY2MPADh9iIz4vhfXBBzrDjT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785769047; c=relaxed/simple;
	bh=rH7c4BNoFxNF7N2pE0+MsTz5GUCjv5A99uatFeYJsoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=raT1sg79PcuT20K1dSlT6wZJEykXxMhNos/S1ePTE1bfxW/4xi8BQahZw552xVPACbu0qOJmwt/rKVKoE7fOqMheMxbtmqJyneoQ81pPEH0IfkvW5HV9CvFuEYQvtaVR4Xv7a2B5vz5exqvCYMlw87NmV03YBm7tDEMsIdploEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UkPQsTy7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UkPQsTy7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82EFE1476;
	Mon,  3 Aug 2026 07:57:20 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61D353F632;
	Mon,  3 Aug 2026 07:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785769044; bh=rH7c4BNoFxNF7N2pE0+MsTz5GUCjv5A99uatFeYJsoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UkPQsTy7F4F7Sw+PcgXQWmJgS0Y0c4+Uc7ju4gI7wygzXEJ9KKWx61VdArwRpiq3Q
	 5Oy5gbKIDGgRFvvigvX0ICD4BlxWVXXF2AahOCix3X13zUFsjPr3LRIsVNC2pucRCO
	 mCmv832n0KwGGim8EhxcgDX3QDdr2eIgKqsQt0Rk=
Message-ID: <babcdee7-3180-4c36-8822-f9d027f432b9@arm.com>
Date: Mon, 3 Aug 2026 15:57:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 16/37] KVM: arm64: CCA: Handle realm MMIO emulation
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-17-steven.price@arm.com> <864ihbcul4.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <864ihbcul4.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/08/2026 12:27, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 15:28:18 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> MMIO emulation for a realm cannot be done directly with the VM's
>> registers as they are protected from the host. However, for emulatable
>> data aborts, the RMM uses GPRS[0] to provide the read/written value.
>> We can transfer this from/to the equivalent VCPU's register entry and
>> then depend on the generic MMIO handling code in KVM.
>>
>> For a MMIO read, the value is placed in the shared RecExit structure
>> during kvm_handle_mmio_return() rather than in the VCPU's register
>> entry.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v7:
>>  * New comment for rec_exit_sync_dabt() explaining the call to
>>    vcpu_set_reg().
>> Changes since v5:
>>  * Inject SEA to the guest is an emulatable MMIO access triggers a data
>>    abort.
>>  * kvm_handle_mmio_return() - disable kvm_incr_pc() for a REC (as the PC
>>    isn't under the host's control) and move the REC_ENTER_EMULATED_MMIO
>>    flag setting to this location (as that tells the RMM to skip the
>>    instruction).
>> ---
>>  arch/arm64/kvm/inject_fault.c |  4 +++-
>>  arch/arm64/kvm/mmio.c         | 16 ++++++++++++----
>>  arch/arm64/kvm/rmi-exit.c     | 15 +++++++++++++++
>>  3 files changed, 30 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
>> index 89982bd3345f..6492397b73d7 100644
>> --- a/arch/arm64/kvm/inject_fault.c
>> +++ b/arch/arm64/kvm/inject_fault.c
>> @@ -228,7 +228,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
>>  
>>  static void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
>>  {
>> -	if (vcpu_el1_is_32bit(vcpu))
>> +	if (unlikely(vcpu_is_rec(vcpu)))
>> +		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_INJECT_SEA;
>> +	else if (vcpu_el1_is_32bit(vcpu))
>>  		inject_abt32(vcpu, iabt, addr);
>>  	else
>>  		inject_abt64(vcpu, iabt, addr);
> 
> Why don't you let inject_dabt64() do its job and reconcile the REC
> stuff at run time?

Ok, one wrinkle is the __kvm_adjust_pc() path. But I can skip that and
leave the PENDING_EXCEPTION flag set on return to user space. That way
the flag is still set for the next entry and we can handle the RMM
specific parts there.

>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>> index e2285ed8c91d..a8c125205695 100644
>> --- a/arch/arm64/kvm/mmio.c
>> +++ b/arch/arm64/kvm/mmio.c
>> @@ -6,6 +6,7 @@
>>  
>>  #include <linux/kvm_host.h>
>>  #include <asm/kvm_emulate.h>
>> +#include <linux/arm-smccc-rmi.h>
>>  #include <trace/events/kvm.h>
>>  
>>  #include "trace.h"
>> @@ -138,14 +139,21 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>>  		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
>>  			       &data);
>>  		data = vcpu_data_host_to_guest(vcpu, data, len);
>> -		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
>> +
>> +		if (vcpu_is_rec(vcpu))
>> +			vcpu->arch.rec.run->enter.gprs[0] = data;
>> +		else
>> +			vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
> 
> This is yet another example of things I do not want to see. KVM works
> on the GPRs described in the vcpu structure. And that's it.
> 
> So let the ESR information be correct for CCA, the data being written
> back to x0, and once you're ready to enter the guest again, copy
> whatever you need into the CCA data structure.
> 
> But not any of this stuff.

Yes this is a bit silly. A while ago the RMM wasn't populating the ESR
information correctly which is where all these gprs[0] hacks came from.
That's been fixed and it should be possible to do this on entry.

>>  	}
>>  
>>  	/*
>>  	 * The MMIO instruction is emulated and should not be re-executed
>>  	 * in the guest.
>>  	 */
>> -	kvm_incr_pc(vcpu);
>> +	if (vcpu_is_rec(vcpu))
>> +		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_EMULATED_MMIO;
>> +	else
>> +		kvm_incr_pc(vcpu);
> 
> Same thing. kvm_incr_pc() sets a flag. Use that to reconcile the state
> with CCA.

It's not an ideal flag for this use (it's set in other places). But I
think it should be sufficient along with checking other state to
identify this condition.

Thanks,
Steve

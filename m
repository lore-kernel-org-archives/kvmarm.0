Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3AD62E7366;
	Mon,  8 Jun 2026 08:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780908573; cv=none; b=ul62i3VdcbnUPlMPAMQAlmPl5PFRatauOzbDLFLhq0Nca9Yb6BfNqsWsHmdXMATegGqQheDYnQFHoRYQH0ERdfyYomoJlnjpdLocFz6UVfm1Unk6odn0fw/JhEAKwO8B4uUpKy6admmRj1W0AmgYmTnuKNYimEngoc+jD6URoQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780908573; c=relaxed/simple;
	bh=qWIbo9Jph/VqJbQLKnGpxwigEGe2RpFukz/vUdfHRbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KR/iZ0XVZ+saMIh3NwP22fWjEzS/m/2uiK1EJAykjU+Avkkn0VSb8tIDArYBUHcR4ZizWLI/rAJWUv/69RccQmfhqAJJWluMqxaY5pgih6+8/mrqD06OfVHMynJANcADcFhZE6wjisgREcvrgu/CoAtRxhPiUR18DFNsjixU2Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h8xPaLJJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h8xPaLJJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C0621596;
	Mon,  8 Jun 2026 01:49:25 -0700 (PDT)
Received: from [10.57.28.93] (unknown [10.57.28.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3B043F62B;
	Mon,  8 Jun 2026 01:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780908570; bh=qWIbo9Jph/VqJbQLKnGpxwigEGe2RpFukz/vUdfHRbo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h8xPaLJJCRjZLDMWSuF+FYRCSpx0fOTs4+bUdTghjG+5rXEpQqPWn3P3D+ry8k7/R
	 G2TVLclRVYqoTNxBdcdovuvEkUBVpi85wsuA+AoBu4HoqyCcBpgfDmIdVqqVMONSGv
	 B8A0i/PwkdgdlyEiRYSSB1sf+RZUaN9jvedXyAuw=
Message-ID: <92882427-7ce4-4cb3-a25d-3942a9ec40c3@arm.com>
Date: Mon, 8 Jun 2026 09:49:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 24/44] KVM: arm64: Handle realm MMIO emulation
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-25-steven.price@arm.com>
 <8b648b59-c411-4126-be18-686d2927f24a@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8b648b59-c411-4126-be18-686d2927f24a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 28/05/2026 06:03, Gavin Shan wrote:
> Hi Steve,
> 
> On 5/13/26 11:17 PM, Steven Price wrote:
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
>>   * New comment for rec_exit_sync_dabt() explaining the call to
>>     vcpu_set_reg().
>> Changes since v5:
>>   * Inject SEA to the guest is an emulatable MMIO access triggers a data
>>     abort.
>>   * kvm_handle_mmio_return() - disable kvm_incr_pc() for a REC (as the PC
>>     isn't under the host's control) and move the REC_ENTER_EMULATED_MMIO
>>     flag setting to this location (as that tells the RMM to skip the
>>     instruction).
>> ---
>>   arch/arm64/kvm/inject_fault.c |  4 +++-
>>   arch/arm64/kvm/mmio.c         | 16 ++++++++++++----
>>   arch/arm64/kvm/rmi-exit.c     | 14 ++++++++++++++
>>   3 files changed, 29 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/
>> inject_fault.c
>> index 89982bd3345f..6492397b73d7 100644
>> --- a/arch/arm64/kvm/inject_fault.c
>> +++ b/arch/arm64/kvm/inject_fault.c
>> @@ -228,7 +228,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu,
>> bool is_pabt, u32 addr)
>>     static void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64
>> addr)
>>   {
>> -    if (vcpu_el1_is_32bit(vcpu))
>> +    if (unlikely(vcpu_is_rec(vcpu)))
>> +        vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_INJECT_SEA;
>> +    else if (vcpu_el1_is_32bit(vcpu))
>>           inject_abt32(vcpu, iabt, addr);
>>       else
>>           inject_abt64(vcpu, iabt, addr);
>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>> index e2285ed8c91d..6a8cb927fcca 100644
>> --- a/arch/arm64/kvm/mmio.c
>> +++ b/arch/arm64/kvm/mmio.c
>> @@ -6,6 +6,7 @@
>>     #include <linux/kvm_host.h>
>>   #include <asm/kvm_emulate.h>
>> +#include <asm/rmi_smc.h>
>>   #include <trace/events/kvm.h>
>>     #include "trace.h"
>> @@ -138,14 +139,21 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>>           trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
>>                      &data);
>>           data = vcpu_data_host_to_guest(vcpu, data, len);
>> -        vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
>> +
>> +        if (vcpu_is_rec(vcpu))
>> +            vcpu->arch.rec.run->enter.gprs[0] = data;
>> +        else
>> +            vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
>>       }
>>         /*
>>        * The MMIO instruction is emulated and should not be re-executed
>>        * in the guest.
>>        */
>> -    kvm_incr_pc(vcpu);
>> +    if (vcpu_is_rec(vcpu))
>> +        vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_EMULATED_MMIO;
>> +    else
>> +        kvm_incr_pc(vcpu);
>>         return 1;
>>   }
>> @@ -167,14 +175,14 @@ int io_mem_abort(struct kvm_vcpu *vcpu,
>> phys_addr_t fault_ipa)
>>        * No valid syndrome? Ask userspace for help if it has
>>        * volunteered to do so, and bail out otherwise.
>>        *
>> -     * In the protected VM case, there isn't much userspace can do
>> +     * In the protected/realm VM case, there isn't much userspace can do
>>        * though, so directly deliver an exception to the guest.
>>        */
>>       if (!kvm_vcpu_dabt_isvalid(vcpu)) {
>>           trace_kvm_mmio_nisv(*vcpu_pc(vcpu), esr,
>>                       kvm_vcpu_get_hfar(vcpu), fault_ipa);
>>   -        if (vcpu_is_protected(vcpu))
>> +        if (vcpu_is_protected(vcpu) || vcpu_is_rec(vcpu))
>>               return kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
>>             if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
>> diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
>> index e7c51b6cf6ce..8ec0d179eba2 100644
>> --- a/arch/arm64/kvm/rmi-exit.c
>> +++ b/arch/arm64/kvm/rmi-exit.c
>> @@ -25,6 +25,20 @@ static int rec_exit_reason_notimpl(struct kvm_vcpu
>> *vcpu)
>>     static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>>   {
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    /*
>> +     * In the case of a write, copy over gprs[0] to the target GPR,
>> +     * preparing to handle MMIO write fault. The content to be
>> written has
>> +     * been saved to gprs[0] by the RMM (even if another register was
>> used
>> +     * by the guest). In the case of normal memory access this is
>> redundant
>> +     * (the guest will replay the instruction), but the overhead is
>> +     * minimal.
>> +     */
>> +    if (kvm_vcpu_dabt_iswrite(vcpu) && kvm_vcpu_dabt_isvalid(vcpu))
>> +        vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu),
>> +                 rec->run->exit.gprs[0]);
>> +
> 
> { } is needed here.

Indeed - I'm surprised checkpatch didn't manage to flag that. I'll fix.

Thanks,
Steve

>>       return kvm_handle_guest_abort(vcpu);
>>   }
>>   
> 
> Thanks,
> Gavin
> 


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7272B1E8855;
	Mon, 12 May 2025 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747061127; cv=none; b=nej5UPRXmGAi+bshBiatF5qrSOGcIsvV2hnOGrU8n9JWUuAwvVKIy/m2uut0ne1wxPHNY497kEFOSm0ySjye521p794xxezGdt0Auz2fnS7LOzGeTZP3Ji5gULpfRgVD4rTCT0y/Mpex2e3ZxfgoHIhEWA8gtZnjSMd3ruSohcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747061127; c=relaxed/simple;
	bh=Ee7TVXRHpTI483XATox6XW7kAWNu8rFF48cimnraYqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZjWaHskRqCQkt8ZjC2RcmeNqL+hntDUThlN8UtwlirX3Z/2bxXLNYHgj55hEhoSLAvTc542GEoPYzx3AfQRcgKWwvkLHqZtA6W5RfMoXTxCGWuykwzhAQ/sQ6XeyRXezxN63fzDQQSQ22/YKclwj4yNX4Vr7O9WpHkYxQ4QP2cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DC3314BF;
	Mon, 12 May 2025 07:45:13 -0700 (PDT)
Received: from [10.57.21.218] (unknown [10.57.21.218])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C95E3F673;
	Mon, 12 May 2025 07:45:20 -0700 (PDT)
Message-ID: <956e661b-6dcf-49cb-a210-b0865588e04c@arm.com>
Date: Mon, 12 May 2025 15:45:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-17-steven.price@arm.com>
 <e6a69a4a-8014-44b4-aef6-37afe0fa8d29@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <e6a69a4a-8014-44b4-aef6-37afe0fa8d29@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 30/04/2025 12:55, Gavin Shan wrote:
> On 4/16/25 11:41 PM, Steven Price wrote:
>> Entering a realm is done using a SMC call to the RMM. On exit the
>> exit-codes need to be handled slightly differently to the normal KVM
>> path so define our own functions for realm enter/exit and hook them
>> in if the guest is a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v7:
>>   * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>>     been read (although that can never happen in the current code). Tidy
>>     up the condition to handle any future refactoring.
>> Changes since v6:
>>   * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>>     vcpu to the error.
>>   * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>>     this exit type.
>>   * Split code handling a RIPAS change triggered by the guest to the
>>     following patch.
>> Changes since v5:
>>   * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>>     change on next entry rather than immediately on the exit. This allows
>>     the VMM to 'reject' a RIPAS change by refusing to continue
>>     scheduling.
>> Changes since v4:
>>   * Rename handle_rme_exit() to handle_rec_exit()
>>   * Move the loop to copy registers into the REC enter structure from the
>>     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>>     where the handler exits to user space and user space wants to modify
>>     the GPRS.
>>   * Some code rearrangement in rec_exit_ripas_change().
>> Changes since v2:
>>   * realm_set_ipa_state() now provides an output parameter for the
>>     top_iap that was changed. Use this to signal the VMM with the correct
>>     range that has been transitioned.
>>   * Adapt to previous patch changes.
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |   3 +
>>   arch/arm64/kvm/Makefile          |   2 +-
>>   arch/arm64/kvm/arm.c             |  19 +++-
>>   arch/arm64/kvm/rme-exit.c        | 170 +++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/rme.c             |  19 ++++
>>   5 files changed, 207 insertions(+), 6 deletions(-)
>>   create mode 100644 arch/arm64/kvm/rme-exit.c
>>
> 
> One nitpick below.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks

[...]

>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>> new file mode 100644
>> index 000000000000..a1adf5610455
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rme-exit.c
>> @@ -0,0 +1,170 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <kvm/arm_hypercalls.h>
>> +#include <kvm/arm_psci.h>
>> +
>> +#include <asm/rmi_smc.h>
>> +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_rme.h>
>> +#include <asm/kvm_mmu.h>
>> +
>> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
>> +
>> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
>> +         rec->run->exit.esr);
>> +    return -ENXIO;
>> +}
>> +
>> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>> +{
>> +    return kvm_handle_guest_abort(vcpu);
>> +}
>> +
>> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
>> +         rec->run->exit.esr);
>> +    return -ENXIO;
>> +}
>> +
>> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long esr = kvm_vcpu_get_esr(vcpu);
>> +    int rt = kvm_vcpu_sys_get_rt(vcpu);
>> +    bool is_write = !(esr & 1);
>> +    int ret;
>> +
>> +    if (is_write)
>> +        vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
>> +
>> +    ret = kvm_handle_sys_reg(vcpu);
>> +    if (ret > 0 && !is_write)
>> +        rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
> 
> kvm_handle_sys_reg() always returns positive value, so it can be:
> 
>     if (!is_write)
>         rc->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);

I'm not sure the "always returns positive values" is a good
justification - that might change in the future (although I guess the
only reason it returns '1' is just to have the correct function
signature - so it's unlike to change).

However there isn't really any harm here in setting the 'enter' value
even if it fails. So I'll drop the "ret > 0" check.

Thanks,
Steve


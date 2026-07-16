Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F733F4DFC;
	Thu, 16 Jul 2026 09:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193456; cv=none; b=HqgqcdR4p/J/cUIpTYNo9h0nhorQym1q7Ns0EA9VwZRHtlmgQFqhQ5NIUR1bRFmnHMME0Xa087iFBQ/fXvxushR8Fmz4nMbgV2NonpN2R7H6IjkFWgDHPJP2y6pcO//pveL4uc3PT7Ti9+q6xzpJ9jkxEuVnN9EWK1pMvd67d0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193456; c=relaxed/simple;
	bh=tCEy7iD7MZ+3FGuXj/M08G4NU2HDUW0nKEXLgA8KTkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5SPBf1GcXeu3Xsl/djpi12Mfzz/qG6BoPlMknXSqlpoyVP+grf7cEowKspikOFGO37AB73CQubcu4EPzPmLi+9BoD4EAwamVuJuTrmSiyw8wDK/Rzx8AGlHiXlrE2oFch/bf3rq8Ealc3DDsREUbTUi5bgKgYhGK5ZYKYSeUIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=soLPUHJZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="soLPUHJZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E56AE1477;
	Thu, 16 Jul 2026 02:17:29 -0700 (PDT)
Received: from [10.1.25.27] (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 746CA3F905;
	Thu, 16 Jul 2026 02:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784193454; bh=tCEy7iD7MZ+3FGuXj/M08G4NU2HDUW0nKEXLgA8KTkM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=soLPUHJZLQvXa7OkOv1/AEoaPaptD9CpFTjVFUeFEx1FPj2Dg5bXzUIYUu4lin+06
	 h5AijQ/22lRO1N5KUkrvXbYXnhFytcxWaVMzlZQYN7N2HAuVQc9mRflRxK+vfKoIJW
	 seQtYK3S7FjBKbk2yQqjl9/6dNmn/Z33cUnGeNDc=
Message-ID: <9eb4e4c0-f1f6-4ab9-956a-0b233d1656c9@arm.com>
Date: Thu, 16 Jul 2026 10:17:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/37] KVM: arm64: CCA: Allow passing the machine type
 in KVM creation
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
 <20260715142841.80544-10-steven.price@arm.com> <87zezs44cf.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <87zezs44cf.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2026 17:14, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 15:28:11 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> Previously machine type was used purely for specifying the physical
>> address size of the guest. Reserve the higher bits to specify an ARM
>> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
>> used to create a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v13:
>>  * Rework to use the two top bits for the machine type now that pKVM has
>>    merged and used the top bit for KVM_VM_TYPE_ARM_PROTECTED.
>>  * Update the documentation to include KVM_VM_TYPE_ARM_PROTECTED as
>>    well.
>> Changes since v9:
>>  * Explictly set realm.state to REALM_STATE_NONE rather than rely on the
>>    zeroing of the structure.
>> Changes since v7:
>>  * Add some documentation explaining the new machine type.
>> Changes since v6:
>>  * Make the check for kvm_rme_is_available more visible and report an
>>    error code of -EPERM (instead of -EINVAL) to make it explicit that
>>    the kernel supports RME, but the platform doesn't.
>> ---
>>  Documentation/virt/kvm/api.rst | 18 ++++++++++++++++--
>>  arch/arm64/kvm/arm.c           | 11 +++++++++++
>>  include/uapi/linux/kvm.h       |  7 ++++++-
>>  3 files changed, 33 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index b38e090ad95d..e39d146b34a3 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -181,8 +181,22 @@ flag KVM_VM_MIPS_VZ.
>>  ARM64:
>>  ^^^^^^
>>  
>> -On arm64, the physical address size for a VM (IPA Size limit) is limited
>> -to 40bits by default. The limit can be configured if the host supports the
>> +On arm64, the machine type identifier is used to encode a type and the
>> +physical address size for the VM. The lower byte (bits[7-0]) encode the
>> +address size and the upper bits[30-31] encode a machine type. The machine
>> +types that might be available are:
>> +
>> + =========================   ============================================
>> + KVM_VM_TYPE_ARM_NORMAL      A standard VM
>> + KVM_VM_TYPE_ARM_REALM       A "Realm" VM using the Arm Confidential
>> +                             Compute extensions, the VM's memory is
>> +                             protected from the host.
>> + KVM_VM_TYPE_ARM_PROTECTED   A "protected" VM using pKVM to isolate the
>> +                             VM from the host.
>> + =========================   ============================================
>> +
> 
> Probably worth mentioning that REALM+PROTECTED is an illegal
> combination.

The original intention was that these were enum values not separate bit
fields. Having to adapt to the pKVM changes when they were merged has
somewhat messed this up. I'll add a clarification, but hopefully we
haven't actually burnt the combination in case we have a 4th type in the
future.

Thanks,
Steve


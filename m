Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEC8314B65;
	Mon, 26 Jan 2026 09:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769420288; cv=none; b=Xn6Mntwd39dGZfwVRsa0wNioAj1549Jsh4VNseKzeG44uP20IxSeMl0VEw7TBoXy2qAZi+PXVqVECYYOR3AO+Aiuaxo4cMclVx+xDkRL3Ob0CFXZts+tmRwN3ye+3oNBaGzfpe9GjD9AFVme9i8DdVw6mouE2j8mC2nQEhYxPh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769420288; c=relaxed/simple;
	bh=bPlCz6FJ7rX8Z5OmZuqzMLSzVV3SnTF6lYCixktKNII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJN6urm3WkVTuwAmQIxbZzMu191yoapemW6Bt+7Zxduf83jGEKH7diSIpchmbDLyyAA4b9RrCGcNmAtqYYOzMYNfQFeRV7LF6df5pMiIDpaZt1vFzT2LU54lBHH7srkLqGqNJaIUkJqSTIDSrPY5gO4cu5ePW+z2BC2e93y5Ml0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40972339;
	Mon, 26 Jan 2026 01:37:59 -0800 (PST)
Received: from [10.57.8.194] (unknown [10.57.8.194])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DF133F632;
	Mon, 26 Jan 2026 01:38:00 -0800 (PST)
Message-ID: <4b9070a2-0cb8-42ed-8ef3-d3c071fa14c3@arm.com>
Date: Mon, 26 Jan 2026 09:37:58 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/46] arm64: RMI: Define the user ABI
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-7-steven.price@arm.com>
 <a837d104-5df6-40bc-b129-eaf39fdab482@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <a837d104-5df6-40bc-b129-eaf39fdab482@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/01/2026 16:47, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 17/12/2025 10:10, Steven Price wrote:
>> There is one CAP which identified the presence of CCA, and two ioctls.
>> One ioctl is used to populate memory and the other is used when user
>> space is providing the PSCI implementation to identify the target of the
>> operation.
>>
> 
> Could we split these changes to the corresponding implementation patches
> ? That might give us a full picture of how these UAPIs fit in the bigger
> picture.

I could do that, but I was deliberately keeping this as a patch which
contains the uABI interface so that the whole uABI is visible in one
place. I was trying to reduce the amount to review for those who aren't
so interested in the implementation details (especially for this series
where we know it's going to change somewhat with the move to RMM v2.0).

>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v11:
>>   * Completely reworked to be more implicit. Rather than having explicit
>>     CAP operations to progress the realm construction these operations
>>     are done when needed (on populating and on first vCPU run).
>>   * Populate and PSCI complete are promoted to proper ioctls.
>> Changes since v10:
>>   * Rename symbols from RME to RMI.
>> Changes since v9:
>>   * Improvements to documentation.
>>   * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
>> Changes since v8:
>>   * Minor improvements to documentation following review.
>>   * Bump the magic numbers to avoid conflicts.
>> Changes since v7:
>>   * Add documentation of new ioctls
>>   * Bump the magic numbers to avoid conflicts
>> Changes since v6:
>>   * Rename some of the symbols to make their usage clearer and avoid
>>     repetition.
>> Changes from v5:
>>   * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>>     KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
>> ---
>>   Documentation/virt/kvm/api.rst | 57 ++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h       | 23 ++++++++++++++
>>   2 files changed, 80 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/
>> api.rst
>> index 01a3abef8abb..2d5dc7e48954 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6517,6 +6517,54 @@ the capability to be present.
>>     `flags` must currently be zero.
>>   +4.144 KVM_ARM_VCPU_RMI_PSCI_COMPLETE
>> +------------------------------------
>> +
>> +:Capability: KVM_CAP_ARM_RMI
>> +:Architectures: arm64
>> +:Type: vcpu ioctl
>> +:Parameters: struct kvm_arm_rmi_psci_complete (in)
>> +:Returns: 0 if successful, < 0 on error
>> +
>> +::
>> +
>> +  struct kvm_arm_rmi_psci_complete {
>> +    __u64 target_mpidr;
>> +    __u32 psci_status;
>> +    __u32 padding[3];
>> +  };
>> +
>> +Where PSCI functions are handled by user space, the RMM needs to be
>> informed of
>> +the target of the operation using `target_mpidr`, along with the status
>> +(`psci_status`). The RMM v1.0 specification defines two functions
>> that require
>> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
>> +
>> +If the kernel is handling PSCI then this is done automatically and
>> the VMM
>> +doesn't need to call this ioctl.
>> +
>> +4.145 KVM_ARM_RMI_POPULATE
>> +--------------------------
>> +
>> +:Capability: KVM_CAP_ARM_RMI
>> +:Architectures: arm64
>> +:Type: vm ioctl
>> +:Parameters: struct kvm_arm_rmi_populate (in)
>> +:Returns: number of bytes populated, < 0 on error
>> +
>> +::
>> +
>> +  struct kvm_arm_rmi_populate {
>> +    __u64 base;
>> +    __u64 size;
>> +    __u64 source_uaddr;
>> +    __u32 flags;
>> +    __u32 reserved;
>> +  };
>> +
>> +Populate a region of protected address space by copying the data from
>> the user
>> +space pointer provided. This is only valid before any VCPUs have been
>> run.
>> +The ioctl might not populate the entire region and user space may
>> have to
>> +repeatedly call it (with updated pointers) to populate the entire
>> region.
> 
> It may be a good idea to spill out the restrictions on calling this,
> right ? We expect that the source_uaddr is a separate memory area
> from the "DRAM" (in shared mode) ?

Yes - I'd tried to say that by mentioning it's a "user space pointer",
but I could make that more explicit.

> Can this be called before/after converting the entire memory of the
> Guest to Private ? I believe, it must be done after the "initial
> change all of DRAM to private" ?

It can be called before or after setting RIPAS and it implicitly sets
RIPAS to RAM (I'll add something to make that explicit).

With RMM v1.0 there's an ugly problem that INIT_RIPAS fails on a region
which is already RIPAS RAM. This should be fixed with RMM v2.0. There's
a workaround in patch 17 currently:

		/* FIXME: Ugly hack to skip regions which are
		 * already RIPAS_RAM
		 */

But that should go away.

Note that with this proposed uAPI there is no mechanism for user space
to directly set the RIPAS - it's assumed that all guestmem_fd regions
should be set to RIPAS RAM at the time of the first VCPU run - which
means the VMM doesn't need to do anything special.

In the future we could consider a guestmem_fd flag or extra ioctl to
allow the VMM to control RIPAS at a finer granularity. But so far we
don't seem to have any compelling reason to expose that.

Thanks,
Steve

> Suzuki
> 
>>     .. _kvm_run:
>>   @@ -8765,6 +8813,15 @@ helpful if user space wants to emulate
>> instructions which are not
>>   This capability can be enabled dynamically even if VCPUs were already
>>   created and are running.
>>   +7.47 KVM_CAP_ARM_RMI
>> +--------------------
>> +
>> +:Architectures: arm64
>> +:Target: VM
>> +:Parameters: None
>> +
>> +This capability indicates that support for CCA realms is available.
>> +
>>   8. Other capabilities.
>>   ======================
>>   diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index dddb781b0507..8e66ba9c81db 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -974,6 +974,7 @@ struct kvm_enable_cap {
>>   #define KVM_CAP_GUEST_MEMFD_FLAGS 244
>>   #define KVM_CAP_ARM_SEA_TO_USER 245
>>   #define KVM_CAP_S390_USER_OPEREXEC 246
>> +#define KVM_CAP_ARM_RMI 247
>>     struct kvm_irq_routing_irqchip {
>>       __u32 irqchip;
>> @@ -1628,4 +1629,26 @@ struct kvm_pre_fault_memory {
>>       __u64 padding[5];
>>   };
>>   +/* Available with KVM_CAP_ARM_RMI, only for VMs with
>> KVM_VM_TYPE_ARM_REALM  */
>> +struct kvm_arm_rmi_psci_complete {
>> +    __u64 target_mpidr;
>> +    __u32 psci_status;
>> +    __u32 padding[3];
>> +};
>> +
>> +#define KVM_ARM_VCPU_RMI_PSCI_COMPLETE    _IOW(KVMIO, 0xd6, struct
>> kvm_arm_rmi_psci_complete)
>> +
>> +/* Available with KVM_CAP_ARM_RMI, only for VMs with
>> KVM_VM_TYPE_ARM_REALM */
>> +struct kvm_arm_rmi_populate {
>> +    __u64 base;
>> +    __u64 size;
>> +    __u64 source_uaddr;
>> +    __u32 flags;
>> +    __u32 reserved;
>> +};
>> +
>> +#define KVM_ARM_RMI_POPULATE_FLAGS_MEASURE    (1 << 0)
>> +
>> +#define KVM_ARM_RMI_POPULATE    _IOW(KVMIO, 0xd7, struct
>> kvm_arm_rmi_populate)
>> +
>>   #endif /* __LINUX_KVM_H */
> 


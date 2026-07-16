Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B89347FC8;
	Thu, 16 Jul 2026 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784194808; cv=none; b=tyA2F6CFVe2/UqyXSuKkKUl+npW1f/rxOAsuLLH4gps/yBELY8/y5XCQ60tePm//OCtkGjh/FtxrHVDp8jqNgayJ4GCgmXsXaM0ZroO7qH8CWRCezK2/M83l6n2jN9kRebewFROMvEGoZhXabzxvVow3bY6+7AlS+L7HL7rwZOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784194808; c=relaxed/simple;
	bh=Vi6PaAstGdOIpufYh/LJ8ZAHKFeYxPSyuWcCmxj80tU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NDFO/1iLvRdoAzLWHbExrXfc2Qka2Y/49Nn3QHEdVvMADvrqBvzryXpJN1SUFn7MvBXjuWKAD7i5JsxpDIIGbjVlgiNv5CTfY2DAvWQvc6ywYeHfAHAa7A9YKobYjEDyMlDd3IkPmFcJvs+qfHc0JI5Y093jJM3q3PdPPWWruGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YBADHSsa; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YBADHSsa"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B1EA2F;
	Thu, 16 Jul 2026 02:40:01 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84A553F905;
	Thu, 16 Jul 2026 02:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784194805; bh=Vi6PaAstGdOIpufYh/LJ8ZAHKFeYxPSyuWcCmxj80tU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YBADHSsaLQTJSLSfd9CnTRcz+PoCO0RyrYniil6H8Rrh4JnQa/qEd6pDSAOMGNWbK
	 Rw9rWq+8ds7LsR+7L6M1XYCIhcbl/5la+JrM2c6sOzPxyyEwoxQ87T7nYSCJz4T/8C
	 ch9M0uKM18j0jD87hhmO6CAcMsS/h2AkBvtNYoME=
Message-ID: <807a34c3-6c29-473c-bcb2-0546c3df85a7@arm.com>
Date: Thu, 16 Jul 2026 10:40:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 06/37] KVM: arm64: CCA: Define the user ABI
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-7-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260715142841.80544-7-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/07/2026 15:28, Steven Price wrote:
> There is one CAP (KVM_CAP_ARM_RMI) which identifies the presence of CCA,
> and one ioctl.  The ioctl (KVM_ARM_RMI_POPULATE) is used to populate
> memory during creation of the realm as this requires the RMM to copy
> data from an unprotected address to the protected memory - CCA does not
> support shared <-> private memory conversion where the memory contents
> is preserved as this is incompatible with memory encryption.

May be we could add the above constraint to the Documentation to make it
clear from the source. The code later adds this restriction and it would
be good to reflect in the Documentation, given other CC architectures
seem to provide it.


Please see below.

> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v13:
>   * KVM_ARM_VCPU_RMI_PSCI_COMPLETE removed.
>   * KVM_ARM_RMI_POPULATE documentation updated to reflect that the
>     structure is written by the kernel.
>   * CAP number bumped.
> Changes since v12:
>   * Change KVM_ARM_RMI_POPULATE to update the structure with the amount
>     that has been progressed rather than return the number of bytes
>     populated.
>   * Describe the flag KVM_ARM_RMI_POPULATE_FLAGS_MEASURE.
>   * CAP number is bumped.
>   * NOTE: The PSCI ioctl may be removed in a future spec release.
> Changes since v11:
>   * Completely reworked to be more implicit. Rather than having explicit
>     CAP operations to progress the realm construction these operations
>     are done when needed (on populating and on first vCPU run).
>   * Populate and PSCI complete are promoted to proper ioctls.
> Changes since v10:
>   * Rename symbols from RME to RMI.
> Changes since v9:
>   * Improvements to documentation.
>   * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
> Changes since v8:
>   * Minor improvements to documentation following review.
>   * Bump the magic numbers to avoid conflicts.
> Changes since v7:
>   * Add documentation of new ioctls
>   * Bump the magic numbers to avoid conflicts
> Changes since v6:
>   * Rename some of the symbols to make their usage clearer and avoid
>     repetition.
> Changes from v5:
>   * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>     KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
> ---
>   Documentation/virt/kvm/api.rst | 41 ++++++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h       | 13 +++++++++++
>   2 files changed, 54 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 304b9c3209ae..b38e090ad95d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6642,6 +6642,38 @@ if the guest_memfd memory was pinned in IOMMU page tables.
>   
>   See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
>   
> +4.146 KVM_ARM_RMI_POPULATE
> +--------------------------
> +
> +:Capability: KVM_CAP_ARM_RMI
> +:Architectures: arm64
> +:Type: vm ioctl
> +:Parameters: struct kvm_arm_rmi_populate (in/out)
> +:Returns: 0 on success, < 0 on error
> +
> +::
> +
> +  struct kvm_arm_rmi_populate {
> +	__u64 base;
> +	__u64 size;
> +	__u64 source_uaddr;
> +	__u32 flags;
> +	__u32 reserved;
> +  };
> +
> +Populate a region of protected address space by copying the data from the
> +(non-protected) user space pointer provided into a protected region (backed by
> +guestmem_fd). It implicitly sets the destination region to RIPAS RAM. This is

minor nit: RIPAS_RAM for the sake of completeness. Also, I am wondering 
if this could confuse the reader to imply that the UABI implicitly
converts the region in guest_memfd to "PRIVATE". May be we could rewrite
this to make all the preconditions explicit ? Something like:

"
Populate the guest address region described by @base and @size, with the
data pointed to by the userspace pointer @source_uaddr. The guest_memfd
region backing the memory region must be PRIVATE. Arm CCA cannot
do in-place conversion, preserving the contents. Thus @source_uaddr must
be a valid pointer. This operation maps to RMI_RTT_DATA_INIT which also
converts the region to RIPAS_RAM.

"


Suzuki


> +only valid before any VCPUs have been run. The ioctl might not populate the
> +entire region and in this case the kernel updates the fields `base`, `size` and
> +`source_uaddr`. User space may have to repeatedly call it until `size` is 0 to
> +populate the entire region.



> +
> +`flags` can be set to `KVM_ARM_RMI_POPULATE_FLAGS_MEASURE` to request that the
> +populated data is hashed and added to the guest's Realm Initial Measurement
> +(RIM) stored by the RMM. This can then be retrieved by the guest (using the RSI
> +interface) to present to an attestation server.
> +
>   .. _kvm_run:
>   
>   5. The kvm_run structure
> @@ -9025,6 +9057,15 @@ enabled, cmma can't be enabled anymore and pfmfi and the storage key
>   interpretation are disabled. If cmma has already been enabled or the
>   hpage_2g module parameter is not set to 1, -EINVAL is returned.
>   
> +7.48 KVM_CAP_ARM_RMI
> +--------------------
> +
> +:Architectures: arm64
> +:Target: VM
> +:Parameters: None
> +
> +This capability indicates that support for CCA realms is available.
> +
>   8. Other capabilities.
>   ======================
>   
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 129d6f630325..0231ff174a50 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -998,6 +998,7 @@ struct kvm_enable_cap {
>   #define KVM_CAP_S390_VSIE_ESAMODE 248
>   #define KVM_CAP_S390_HPAGE_2G 249
>   #define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 250
> +#define KVM_CAP_ARM_RMI 251
>   
>   struct kvm_irq_routing_irqchip {
>   	__u32 irqchip;
> @@ -1686,4 +1687,16 @@ struct kvm_pre_fault_memory {
>   	__u64 padding[5];
>   };
>   
> +/* Available with KVM_CAP_ARM_RMI, only for VMs with KVM_VM_TYPE_ARM_REALM */
> +#define KVM_ARM_RMI_POPULATE	_IOWR(KVMIO, 0xd7, struct kvm_arm_rmi_populate)
> +#define KVM_ARM_RMI_POPULATE_FLAGS_MEASURE	(1 << 0)
> +
> +struct kvm_arm_rmi_populate {
> +	__u64 base;
> +	__u64 size;
> +	__u64 source_uaddr;
> +	__u32 flags;
> +	__u32 reserved;
> +};
> +
>   #endif /* __LINUX_KVM_H */


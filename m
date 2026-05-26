Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98663C2B92;
	Tue, 26 May 2026 22:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779833905; cv=none; b=LHWCwEpPHf0/Ljj/9shk2Dw57uHzcpdjbAOIgcV/NxtFVJPEYjI3P7D5auATalEKYmHF93urDt6y6obhyyGOMFFFhlsPPoWOOYce+7XbRmv/fQ7nmZNqpTdBmw2GfFujVdTvzEveEMxXYNEdZxz/PItAwQaCaG2/DnihqPyLZCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779833905; c=relaxed/simple;
	bh=sH/4XRqKpSw7y9WtrAKJyLr5ctF2ndal2b+tpCBDx2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NaFD9bnm0BiA427r76C+cMVwj/sl4MO8ejVYbU/QHFyXsJiwEp8ClTzAuVyHcckoo69dXw4Ms4Idxn22Gr+ul367Ywh3zbOQQwqP8wy3Av4USHKI++2g7SgZKs3AJrI9XR8OPcc50iyHV+F5IjkbNKy/I+fhpXnYw5H4+hCBxeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I2I6UptB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I2I6UptB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE9942BCD;
	Tue, 26 May 2026 15:18:15 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C76A43F7B4;
	Tue, 26 May 2026 15:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779833901; bh=sH/4XRqKpSw7y9WtrAKJyLr5ctF2ndal2b+tpCBDx2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I2I6UptBQvI3XkyOR3Fre00ZRn+sjAS1IDaOvaixuEbI0maXbjM96bPw8nn4OPuJZ
	 we05frOreqd2J9ktylS+TH8/sjxXuRCk6L4zD8hBTo7+vpfr771K9ykbLGXCKD7bHP
	 iA6fiMLhr85im0jkhneql6hy0M2QfCkC5/4bHmwE=
Date: Tue, 26 May 2026 23:17:54 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, Lorenzo.Pieralisi2@arm.com
Subject: Re: [PATCH v14 13/44] arm64: RMI: Define the user ABI
Message-ID: <vixej2afqamvr7eaksoepr3wmpwzp73rtgrageeyuawa6azotw@payxzyhymwbt>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-14-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513131757.116630-14-steven.price@arm.com>

On Wed, May 13, 2026 at 02:17:21PM +0100, Steven Price wrote:
> There is one CAP which identified the presence of CCA, and one ioctl.
> The ioctl is used to populate memory during creation of the realm as
> this requires the RMM to copy data from an unprotected address to the
> protected memory - CCA does not support memory conversion where the
> memory contents is preserved as this is incompatible with memory
> encryption.

Nit:
I believe spelling out the CAP and ioctl names can improve the commit
message. Also "memory conversion" is a little vague, maybe

... CCA does not support shared <-> private memory conversion where ...

would make this clearer?

Thanks,
Wei-Lin Chang

> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v13:
>  * KVM_ARM_VCPU_RMI_PSCI_COMPLETE removed.
>  * KVM_ARM_RMI_POPULATE documentation updated to reflect that the
>    structure is written by the kernel.
>  * CAP number bumped.
> Changes since v12:
>  * Change KVM_ARM_RMI_POPULATE to update the structure with the amount
>    that has been progressed rather than return the number of bytes
>    populated.
>  * Describe the flag KVM_ARM_RMI_POPULATE_FLAGS_MEASURE.
>  * CAP number is bumped.
>  * NOTE: The PSCI ioctl may be removed in a future spec release.
> Changes since v11:
>  * Completely reworked to be more implicit. Rather than having explicit
>    CAP operations to progress the realm construction these operations
>    are done when needed (on populating and on first vCPU run).
>  * Populate and PSCI complete are promoted to proper ioctls.
> Changes since v10:
>  * Rename symbols from RME to RMI.
> Changes since v9:
>  * Improvements to documentation.
>  * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
> Changes since v8:
>  * Minor improvements to documentation following review.
>  * Bump the magic numbers to avoid conflicts.
> Changes since v7:
>  * Add documentation of new ioctls
>  * Bump the magic numbers to avoid conflicts
> Changes since v6:
>  * Rename some of the symbols to make their usage clearer and avoid
>    repetition.
> Changes from v5:
>  * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>    KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
> ---
>  Documentation/virt/kvm/api.rst | 40 ++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h       | 13 +++++++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 52bbbb553ce1..ca68aae7faa2 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6553,6 +6553,37 @@ KVM_S390_KEYOP_SSKE
>    Sets the storage key for the guest address ``guest_addr`` to the key
>    specified in ``key``, returning the previous value in ``key``.
>  
> +4.145 KVM_ARM_RMI_POPULATE
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
> +only valid before any VCPUs have been run. The ioctl might not populate the
> +entire region and in this case the kernel updates the fields `base`, `size` and
> +`source_uaddr`. User space may have to repeatedly call it until `size` is 0 to
> +populate the entire region.
> +
> +`flags` can be set to `KVM_ARM_RMI_POPULATE_FLAGS_MEASURE` to request that the
> +populated data is hashed and added to the guest's Realm Initial Measurement
> +(RIM).
> +
>  .. _kvm_run:
>  
>  5. The kvm_run structure
> @@ -8904,6 +8935,15 @@ helpful if user space wants to emulate instructions which are not
>  This capability can be enabled dynamically even if VCPUs were already
>  created and are running.
>  
> +7.47 KVM_CAP_ARM_RMI
> +--------------------
> +
> +:Architectures: arm64
> +:Target: VM
> +:Parameters: None
> +
> +This capability indicates that support for CCA realms is available.
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6c8afa2047bf..b8cff0938041 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -996,6 +996,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_S390_USER_OPEREXEC 246
>  #define KVM_CAP_S390_KEYOP 247
>  #define KVM_CAP_S390_VSIE_ESAMODE 248
> +#define KVM_CAP_ARM_RMI 249
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> @@ -1669,4 +1670,16 @@ struct kvm_pre_fault_memory {
>  	__u64 padding[5];
>  };
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
>  #endif /* __LINUX_KVM_H */
> -- 
> 2.43.0
> 

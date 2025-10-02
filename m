Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E7F2FE04B;
	Thu,  2 Oct 2025 08:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394798; cv=none; b=UyDHTgv9ru7vocjZ4D79YUxmr6noWloHRJpRRQvFLdwmpyIjlySqubzzNl3S45kyQ8i6eb1PP2ThRe2Qv7sTUN/TfCqZub6oGEDDWxu1jeq5cXG/cnckuonbZq0CnjVWlL3wS9w8uG8eXLNeDa3iqb3p12iRyHRJsqgoVq+JDmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394798; c=relaxed/simple;
	bh=6F+DR4WRZKG0j8hQTKo5t/bxdCuQDOz0ydW2ZYJ1qT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jX5v/9Deqken6Cddu/E3pKtqcYc7OpH82TcV9Od3StsipIN8uX78SM/xvJDKaG/ttyM1aYj3K+/Vxvd770zthMcvTgpC3cMx6dMinWJBicblk1QCmchjNrxWcbx9ys0K2PV30kqYymb2boBkpaOX6DlGmir9abq7tyNeRAepAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2721C1692;
	Thu,  2 Oct 2025 01:46:27 -0700 (PDT)
Received: from [10.1.27.48] (unknown [10.1.27.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 584853F66E;
	Thu,  2 Oct 2025 01:46:31 -0700 (PDT)
Message-ID: <6d3953f3-14ce-4a58-a018-3636e77dbdf8@arm.com>
Date: Thu, 2 Oct 2025 09:46:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/43] arm64: RME: Define the user ABI
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-7-steven.price@arm.com> <86jz1eztz4.wl-maz@kernel.org>
 <47a7bc06-9d44-42f8-88df-f6db3bc997bc@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <47a7bc06-9d44-42f8-88df-f6db3bc997bc@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/10/2025 15:44, Steven Price wrote:
> On 01/10/2025 13:28, Marc Zyngier wrote:
>> On Wed, 20 Aug 2025 15:55:26 +0100,
>> Steven Price <steven.price@arm.com> wrote:
>>>
>>> There is one (multiplexed) CAP which can be used to create, populate and
>>> then activate the realm.
>>>
>>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>> ---
>>> Changes since v9:
>>>   * Improvements to documentation.
>>>   * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
>>> Changes since v8:
>>>   * Minor improvements to documentation following review.
>>>   * Bump the magic numbers to avoid conflicts.
>>> Changes since v7:
>>>   * Add documentation of new ioctls
>>>   * Bump the magic numbers to avoid conflicts
>>> Changes since v6:
>>>   * Rename some of the symbols to make their usage clearer and avoid
>>>     repetition.
>>> Changes from v5:
>>>   * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>>>     KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
>>> ---
>>>   Documentation/virt/kvm/api.rst    | 71 +++++++++++++++++++++++++++++++
>>>   arch/arm64/include/uapi/asm/kvm.h | 49 +++++++++++++++++++++
>>>   include/uapi/linux/kvm.h          | 10 +++++
>>>   3 files changed, 130 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index 6aa40ee05a4a..69c0a9eba6c5 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -3549,6 +3549,11 @@ Possible features:
>>>   	  Depends on KVM_CAP_ARM_EL2_E2H0.
>>>   	  KVM_ARM_VCPU_HAS_EL2 must also be set.
>>>   
>>> +	- KVM_ARM_VCPU_REC: Allocate a REC (Realm Execution Context) for this
>>> +	  VCPU. This must be specified on all VCPUs created in a Realm VM.
>>> +	  Depends on KVM_CAP_ARM_RME.
>>> +	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_REC).
>>> +
>>>   4.83 KVM_ARM_PREFERRED_TARGET
>>>   -----------------------------
>>>   
>>> @@ -5122,6 +5127,7 @@ Recognised values for feature:
>>>   
>>>     =====      ===========================================
>>>     arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
>>> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
>>>     =====      ===========================================
>>>   
>>>   Finalizes the configuration of the specified vcpu feature.
>>> @@ -6476,6 +6482,30 @@ the capability to be present.
>>>   
>>>   `flags` must currently be zero.
>>>   
>>> +4.144 KVM_ARM_VCPU_RMM_PSCI_COMPLETE
>>> +------------------------------------
>>> +
>>> +:Capability: KVM_CAP_ARM_RME
>>> +:Architectures: arm64
>>> +:Type: vcpu ioctl
>>> +:Parameters: struct kvm_arm_rmm_psci_complete (in)
>>> +:Returns: 0 if successful, < 0 on error
>>> +
>>> +::
>>> +
>>> +  struct kvm_arm_rmm_psci_complete {
>>> +	__u64 target_mpidr;
>>> +	__u32 psci_status;
>>> +	__u32 padding[3];
>>> +  };
>>> +
>>> +Where PSCI functions are handled by user space, the RMM needs to be informed of
>>> +the target of the operation using `target_mpidr`, along with the status
>>> +(`psci_status`). The RMM v1.0 specification defines two functions that require
>>> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
>>> +
>>> +If the kernel is handling PSCI then this is done automatically and the VMM
>>> +doesn't need to call this ioctl.
>>
>> Why should userspace involved in this? Why can't this be a
>> notification that the host delivers to the RMM when the vcpu is about
>> to run?
> 
> This is only when PSCI is being handled by user space. If the kernel
> (i.e KVM) is handling PSCI then indeed there's no user space involvement.
> 
> I'm not sure how we could avoid this when PSCI is being implemented in
> user space. Or am I missing something?

I think there is a bit of disconnect here.

The RMM doesn't track the RECs for a given vCPU. So, when it requires
the REC object for a given vCPU, the Host provides this via an 
RMI_PSCI_COMPLETE call. This is used for PSCI_CPU_ON and 
PSCI_AFFINITY_INFO today, where the RMM can do the book keeping
for the REC and emulate the PSCI. Now, the host does have a control
on whether to ACCEPT or REJECT a request (for CPU_ON).
The RMM requires the PSCI_COMPLETE call, before it can return the
PSCI_CPU_ON back to the caller and also before the target vCPU can
run. Thus, this cannot be delayed until the "new VCPU" is run.

Like Steven mentioned, this is only useful in the UABI if the VMM is
handling the PSCI. And this must be issued, before the target vCPU
can be scheduled.

Suzuki

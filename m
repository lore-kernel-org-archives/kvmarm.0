Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE9D42B72D;
	Wed,  1 Jul 2026 10:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903208; cv=none; b=VN6OCoXrOvwBhSsku2J96IFWROZw1L4FJPXXFSUOH8BZYU/mWtOBjt7jk+eYKz03pnYMHMcYT2dhCyMJJ29EH7pu0GsTjwe4pG6vJX6S7bw+Hp0WzygiaetwRU1RL1tbyyfxrAZrAoFndI8ZPL0jHOx/A9t9MNc0QoeI2XJcrZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903208; c=relaxed/simple;
	bh=JZ56j9O/E/kb3CIeJoDp5K9QusgKfml7k5WJLhXC098=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MtGyzdnO/hbL6xcGeeB9WBc2r7FYbvWL3sKHj97Zg4AObBFUft4Hz/ANOjgqcJ+JhFeejoGeEEUV5jH7Yic3o1E6zB+i9ybpU74sUyITd7LdHd3IMcxE5PmOTF2KAxGlZorAds0q2wFlSeY4muDDHvT7pzGzbHs6P+8kOLzc7dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kWk13RqK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kWk13RqK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5D242247;
	Wed,  1 Jul 2026 03:53:20 -0700 (PDT)
Received: from [10.57.37.248] (unknown [10.57.37.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22C093F85F;
	Wed,  1 Jul 2026 03:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782903205; bh=JZ56j9O/E/kb3CIeJoDp5K9QusgKfml7k5WJLhXC098=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kWk13RqKQ05yF/keJKKAoG2johPDXGZZNyWNrYJu6wcvzr07ub1fzAWpTdwka/E6q
	 Uq1BFIYlBLNqglC/uQ0SRczjha3tUTsAs/HJXvv8ybID9ynHz/NQIPxK+7xL/QRR+s
	 NlwIFfzy0G7AW2cO1hqgGlJ/eZ6wnw6/sj9T/I3Y=
Message-ID: <8c0e6a32-2de2-4b94-9fe2-e32f5e9bcc4a@arm.com>
Date: Wed, 1 Jul 2026 11:53:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 00/44] arm64: Support for Arm CCA in KVM
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
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
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <akR0eX0nCumIgnlh@FCCLS0092175.localdomain>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <akR0eX0nCumIgnlh@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/07/2026 03:15, Kohei Enju wrote:
> On 05/13 14:17, Steven Price wrote:
>> This series adds support for running protected VMs using KVM under the
>> Arm Confidential Compute Architecture (CCA).
>>
>> This is rebased on v7.1-rc1, but still targets RMM v2.0-bet1[1].
>>
>> The major updates from v13 remain but have been more fully implemented:
>> the RMM uses the host's page size, range based RMI APIs mean we don't
>> have to break everything down to base page sizes, the GIC state is
>> passed via system registers, and the uAPI has been simplified.
>>
>> The main changes since v13 are:
>>
>>  * The RMI definitions and wrappers have been fully updated for RMM
>>    v2.0-bet1. In particular the temporary RMM v1.0 SMC compatibility
>>    patch has been dropped.
>>
>>  * The PSCI completion ioctl has been removed. RMM v2.0-bet1 still
>>    requires the host to provide the target REC for PSCI calls which
>>    name another vCPU, but KVM now performs the RMI PSCI completion
>>    automatically before entering the REC again. Userspace no longer
>>    needs to issue KVM_ARM_VCPU_RMI_PSCI_COMPLETE. A future spec should
>>    remove the need for the host to provide the MPIDR mapping.
>>
>>  * The generic RMI init, RMM configuration, GPT setup,
>>    delegate/undelegate helpers and SRO infrastructure have moved out of
>>    KVM into arch/arm64/kernel/rmi.c. RMI is expected to be used by
>>    features outside KVM, so this code should be available even when KVM
>>    is not built.
>>
>>  * RMI_GRANULE_TRACKING_GET has been updated to work on a range, this
>>    allows it to work when the region is not aligned to the tracking
>>    size. Solves the problem reported by Mathieu[2].
>>
>>  * SRO support has been moved earlier in the series and improved. It
>>    provides a cleaner way for the host to provide the RMM with the extra
>>    memory it requires. However support is still incomplete where the
>>    TF-RMM code does not yet implement it. This is noted by FIXMEs in the
>>    code.
>>
>>  * The ARM VM type encoding has been reworked to coexist with the
>>    upstream pKVM KVM_VM_TYPE_ARM_PROTECTED bit.
>>
>>  * The private-memory documentation now notes that arm64 uses
>>    KVM_CAP_MEMORY_ATTRIBUTES.
>>
>>  * PMU support is dropped for now. It will be added later in a separate
>>    series. Similarly for selecting the hash algorithm and RPV.
> 
> Hi Steven,

Hi,

> Is there any plan to add support for selecting the MEC policy (shared or
> private)? We have been working on adding support for this on top of your
> series. If this is not already in the works, we may upstream our
> implementation later.

I've been trying to focus on getting the minimum useful series
upstreamed before looking at additional features (such as hash
algorithm, MEC policy etc). If you've already got support then yes
please do upstream it later when we've got this series landed.

Thanks,
Steve

> Thanks,
> Kohei
> 
>>
>> There are also the usual rebase updates and smaller fixes, including
>> changes to the RMM v2.0-bet1 range APIs, removal of REC auxiliary
>> granule handling, fixes to the address range descriptor encoding, and
>> cleanups around realm stage-2 teardown.
>>
>> Stateful RMI Operations
>> -----------------------
>>
>> The RMM v2.0 spec introduces Stateful RMI Operations (SROs), which allow
>> the RMM to complete an operation over several SMC calls while requesting
>> or returning memory to the host. This allows interrupts to be handled in
>> the middle of an operation and lets the RMM dynamically allocate memory
>> for internal tracking purposes. For example, RMI_REC_CREATE no longer
>> needs auxiliary granules to be provided up front, and can instead
>> request memory during the operation.
>>
>> This series includes the generic SRO infrastructure in
>> arch/arm64/kernel/rmi.c and uses it for REC create/destroy. The other
>> cases are not yet used by TF-RMM and a future revision will be needed to
>> finish those paths in Linux.
>>
>> This series is based on v7.1-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v14
>>
>> Work in progress changes for kvmtool are available from the git
>> repository below:
>>
>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v12
>>
>> The TF-RMM has not yet merged the RMM v2.0 support, so you will need to
>> use a branch with RMM v2.0-bet1 support. At the time of writing the
>> following branch is being used:
>>
>> https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc_2
>> (tested on commit 3340667a291a)
>>
>> There is a kvm-unit-test branch which has been updated to support the
>> attestation used in RMMv2.0 available here:
>>
>> https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/v4
>>
>> [1] https://developer.arm.com/documentation/den0137/2-0bet1/
>> [2] https://lore.kernel.org/all/acrj-cKphy4hJsEG@p14s/


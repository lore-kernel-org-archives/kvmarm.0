Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A6F21C168;
	Fri, 11 Oct 2024 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728656085; cv=none; b=F1gXpcbylqJHIeqSofQTl2UF3blrCu8VRtovp0Vf41xR5mZLF+NCuFUUgYmZHHlTePRxr8TtY9aeCfQKW5hlX/4zuY65SyT8LCVCoOR/n7pLTmGZ7kGfji8D3/bS/cVhpVSTxU7STdNmvym7c680QVsoW/gn8/THCpphrhCzUt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728656085; c=relaxed/simple;
	bh=hx3NqEpss88x2cPcLraT/sKCh3o4Zthu/vHlVDApes4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O4w4oCLIzqbp7gKLOuArYqT5+woSPz1l/DiMaNQTpP0agnDOWnXGaguEjbZz1LLskx4LTUBkwoCf3HsfNyt5V+P6hTd79PyG7iX18jNIx3J7wRoBFtAeN7HXLOkR4a5Ef2LqwPi8zZjehencqsegvuxduOWtAMdLM0yZmP/myko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9292E1570;
	Fri, 11 Oct 2024 07:15:11 -0700 (PDT)
Received: from [10.1.31.21] (e122027.cambridge.arm.com [10.1.31.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56A8C3F5A1;
	Fri, 11 Oct 2024 07:14:39 -0700 (PDT)
Message-ID: <846c43a8-9720-4dd5-b40a-73ec00b9a9a7@arm.com>
Date: Fri, 11 Oct 2024 15:14:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/11] arm64: Document Arm Confidential Compute
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
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
 <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-12-steven.price@arm.com>
 <20241008110549.GA1058742@myrica>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20241008110549.GA1058742@myrica>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/10/2024 12:05, Jean-Philippe Brucker wrote:
> On Fri, Oct 04, 2024 at 03:43:06PM +0100, Steven Price wrote:
>> Add some documentation on Arm CCA and the requirements for running Linux
>> as a Realm guest. Also update booting.rst to describe the requirement
>> for RIPAS RAM.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  Documentation/arch/arm64/arm-cca.rst | 67 ++++++++++++++++++++++++++++
>>  Documentation/arch/arm64/booting.rst |  3 ++
>>  Documentation/arch/arm64/index.rst   |  1 +
>>  3 files changed, 71 insertions(+)
>>  create mode 100644 Documentation/arch/arm64/arm-cca.rst
>>
>> diff --git a/Documentation/arch/arm64/arm-cca.rst b/Documentation/arch/arm64/arm-cca.rst
>> new file mode 100644
>> index 000000000000..ab7f90e64c2f
>> --- /dev/null
>> +++ b/Documentation/arch/arm64/arm-cca.rst
>> @@ -0,0 +1,67 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=====================================
>> +Arm Confidential Compute Architecture
>> +=====================================
>> +
>> +Arm systems that support the Realm Management Extension (RME) contain
>> +hardware to allow a VM guest to be run in a way which protects the code
>> +and data of the guest from the hypervisor. It extends the older "two
>> +world" model (Normal and Secure World) into four worlds: Normal, Secure,
>> +Root and Realm. Linux can then also be run as a guest to a monitor
>> +running in the Realm world.
>> +
>> +The monitor running in the Realm world is known as the Realm Management
>> +Monitor (RMM) and implements the Realm Management Monitor
>> +specification[1]. The monitor acts a bit like a hypervisor (e.g. it runs
>> +in EL2 and manages the stage 2 page tables etc of the guests running in
>> +Realm world), however much of the control is handled by a hypervisor
>> +running in the Normal World. The Normal World hypervisor uses the Realm
>> +Management Interface (RMI) defined by the RMM specification to request
>> +the RMM to perform operations (e.g. mapping memory or executing a vCPU).
>> +
>> +The RMM defines an environment for guests where the address space (IPA)
>> +is split into two. The lower half is protected - any memory that is
>> +mapped in this half cannot be seen by the Normal World and the RMM
>> +restricts what operations the Normal World can perform on this memory
>> +(e.g. the Normal World cannot replace pages in this region without the
>> +guest's cooperation). The upper half is shared, the Normal World is free
>> +to make changes to the pages in this region, and is able to emulate MMIO
>> +devices in this region too.
>> +
>> +A guest running in a Realm may also communicate with the RMM to request
>> +changes in its environment or to perform attestation about its
>> +environment. In particular it may request that areas of the protected
>> +address space are transitioned between 'RAM' and 'EMPTY' (in either
>> +direction). This allows a Realm guest to give up memory to be returned
>> +to the Normal World, or to request new memory from the Normal World.
>> +Without an explicit request from the Realm guest the RMM will otherwise
>> +prevent the Normal World from making these changes.
> 
> We could mention that this interface is "RSI", so readers know what to
> look for next

Good idea.

>> +
>> +Linux as a Realm Guest
>> +----------------------
>> +
>> +To run Linux as a guest within a Realm, the following must be provided
>> +either by the VMM or by a `boot loader` run in the Realm before Linux:
>> +
>> + * All protected RAM described to Linux (by DT or ACPI) must be marked
>> +   RIPAS RAM before handing over the Linux.
> 
> "handing control over to Linux", or something like that?

Indeed that actually makes grammatical sense! ;)

>> +
>> + * MMIO devices must be either unprotected (e.g. emulated by the Normal
>> +   World) or marked RIPAS DEV.
>> +
>> + * MMIO devices emulated by the Normal World and used very early in boot
>> +   (specifically earlycon) must be specified in the upper half of IPA.
>> +   For earlycon this can be done by specifying the address on the
>> +   command line, e.g.: ``earlycon=uart,mmio,0x101000000``
> 
> This is going to be needed frequently, so maybe we should explain in a
> little more detail how we come up with this value: "e.g. with an IPA size
> of 33 and the base address of the emulated UART at 0x1000000,
> ``earlycon=uart,mmio,0x101000000``"
> 
> (Because the example IPA size is rather unintuitive and specific to the
> kvmtool memory map)

Agreed.

Thanks,
Steve

> Thanks,
> Jean
> 
>> +
>> + * Linux will use bounce buffers for communicating with unprotected
>> +   devices. It will transition some protected memory to RIPAS EMPTY and
>> +   expect to be able to access unprotected pages at the same IPA address
>> +   but with the highest valid IPA bit set. The expectation is that the
>> +   VMM will remove the physical pages from the protected mapping and
>> +   provide those pages as unprotected pages.
>> +
>> +References
>> +----------
>> +[1] https://developer.arm.com/documentation/den0137/
>> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
>> index b57776a68f15..30164fb24a24 100644
>> --- a/Documentation/arch/arm64/booting.rst
>> +++ b/Documentation/arch/arm64/booting.rst
>> @@ -41,6 +41,9 @@ to automatically locate and size all RAM, or it may use knowledge of
>>  the RAM in the machine, or any other method the boot loader designer
>>  sees fit.)
>>  
>> +For Arm Confidential Compute Realms this includes ensuring that all
>> +protected RAM has a Realm IPA state (RIPAS) of "RAM".
>> +
>>  
>>  2. Setup the device tree
>>  -------------------------
>> diff --git a/Documentation/arch/arm64/index.rst b/Documentation/arch/arm64/index.rst
>> index 78544de0a8a9..12c243c3af20 100644
>> --- a/Documentation/arch/arm64/index.rst
>> +++ b/Documentation/arch/arm64/index.rst
>> @@ -10,6 +10,7 @@ ARM64 Architecture
>>      acpi_object_usage
>>      amu
>>      arm-acpi
>> +    arm-cca
>>      asymmetric-32bit
>>      booting
>>      cpu-feature-registers
>> -- 
>> 2.34.1
>>
>>


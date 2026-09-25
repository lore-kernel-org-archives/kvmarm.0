Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F373A403E9C;
	Fri, 25 Sep 2026 08:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790326217; cv=none; b=Pg4OriZaXN41AAUmPsHRAk4tb4LTMSOTK0HRuCyaALONkXEmjYn9XpbJ3L6BjKk79Udpv5eTUkozMrxbz7e8vZMUusklosnBGCZUNOu7o4sMc5+f6PJgKcN/xbYWGZgQWGqFZq2n5KZqsZ5W7HO5qe//gr8h9icTn1/gGmrbTR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790326217; c=relaxed/simple;
	bh=LjG3pnRJrIkzli/nj9tOlSO8QVv035Dy5xyI+7WVsA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uVMbuTIG9OOqudzY65XQEqRe6T4Ke+W7nd54FVS77cb2+V6vo9r0AyWTeJXw4D4Q41Ipj3ZGguxO+t+jmA8dPTD4Y2RNdHysATxHkaChJSsefT3QCEcNbPm94gWUbW4WmfKJN0ZOoZDJhDaIRISSrXvcVEx83JoGRUvviBpma3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aJpydRZq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aJpydRZq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 589D4497;
	Fri, 25 Sep 2026 01:50:09 -0700 (PDT)
Received: from [10.57.10.88] (unknown [10.57.10.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BA193F86C;
	Fri, 25 Sep 2026 01:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790326212; bh=LjG3pnRJrIkzli/nj9tOlSO8QVv035Dy5xyI+7WVsA0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aJpydRZqDX03ImCyUCSiuiaJMPCxRu8RyBwKnqoMoxxchYA2ksIiSqO+J+yXXVr16
	 vJpmt66PzxwTDksPTlstFNb6jkuHtnyHmvFP85TQGvulieFaQe1p7QWmYCHiGa7JQl
	 4EnkAbtaHXAl+0IaR+n8EJejUGC5F6xGKmwe3dKY=
Message-ID: <a5f54b02-3b44-4e7e-b043-a670f91c5421@arm.com>
Date: Fri, 25 Sep 2026 09:50:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 2/7] firmware: arm_rmm: Check for RMI support at init
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-3-suzuki.poulose@arm.com>
 <295014e8-24d7-494a-8f3e-0e17794d024f@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <295014e8-24d7-494a-8f3e-0e17794d024f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/09/2026 06:43, Gavin Shan wrote:
> On 9/24/26 11:51 PM, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> Query the RMI version number and check if it is a compatible version.
>> The first two feature registers are read and exposed for future code to
>> use.
>>
>> We only support this for Little Endian kernels, the Big Endian kernel
>> support is anyway marked BROKEN and is being removed.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> v19:
>>   * Read all implemented RmiFeatureRegisters - 5
>>   * Use ARRAY_SIZE(rmi_feat_reg_cache) for the loop in 
>> rmi_read_features()
>>   * Fold rmi_features() into rmi_read_features
>>   * Fix comment for rmi_smccc_invoke()
>>   * Drop default y
>>   * Add retry for RMI_BLOCKED and return to caller
>> v18:
>>   * Always use arm_smccc_1_2_invoke() for all RMIs making sure the 
>> unsused
>>     parameters are 0 - Sashiko
>>   * Move rmi_features() calls away from the arm-rmi-cmds.h to rmi.c - 
>> Gavin
>> v17:
>>   * Rename ARM_RMM to ARM_RMM_RMI to make it easier to add Guest 
>> facing RSI
>>     support, which is also in progress
>> v16:
>>   * Update Kconfig text to include PCIe TDISP.
>>   * Export rmi_feat_reg() here rather than in a later commit.
>> v15:
>>   * The code is moved again, this time into the 'firmware' directory.
>> v14:
>>   * This moves the basic RMI setup into the 'kernel' directory. This is
>>     because RMI will be used for some features outside of KVM so should
>>     be available even if KVM isn't compiled in.
>> ---
>>   arch/arm64/Kconfig                |   1 +
>>   arch/arm64/kernel/cpufeature.c    |   1 +
>>   drivers/firmware/Kconfig          |   1 +
>>   drivers/firmware/Makefile         |   1 +
>>   drivers/firmware/arm_rmm/Kconfig  |  25 +++++++
>>   drivers/firmware/arm_rmm/Makefile |   2 +
>>   drivers/firmware/arm_rmm/rmi.c    | 109 ++++++++++++++++++++++++++++++
>>   include/linux/arm-rmi-cmds.h      |  48 +++++++++++++
>>   8 files changed, 188 insertions(+)
>>   create mode 100644 drivers/firmware/arm_rmm/Kconfig
>>   create mode 100644 drivers/firmware/arm_rmm/Makefile
>>   create mode 100644 drivers/firmware/arm_rmm/rmi.c
>>   create mode 100644 include/linux/arm-rmi-cmds.h
>>
> 
> [...]
> 
>> diff --git a/drivers/firmware/arm_rmm/Makefile b/drivers/firmware/ 
>> arm_rmm/Makefile
>> new file mode 100644
>> index 0000000000000..65171988fdcae
>> --- /dev/null
>> +++ b/drivers/firmware/arm_rmm/Makefile
>> @@ -0,0 +1,2 @@
>> +
>> +obj-$(CONFIG_ARM_RMM_RMI)    = rmi.o
> 
> Unnecessary blank line at the top in Makefile. Besides, why doesn't this 
> come
> as below? :)
> 
> obj-$(CONFIG_ARM_RMM_RMI)    += rmi.o

Good point, now that the ARM_RMM_RSI is also getting merged there.

Cheers
Suzuki

> 
> Thanks,
> Gavin
> 
> 


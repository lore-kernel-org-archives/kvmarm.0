Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAE81B6553;
	Fri, 30 Aug 2024 15:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725033302; cv=none; b=V5h9Z1eY7DeZrOB9MguUw4O0s/GRHAY3tAurXWezjrg/kQ0F5bgVNkI/rCkOuaO3iqoo7bmLkHMxBIxOteBre7PAdx/pSS4YXEWqAi5y+15ROkilBRCJeMNvVVRMWlBO8NsC50AgV8BmE8b40nNI61YHcXhcmhuRdxICNI4fIeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725033302; c=relaxed/simple;
	bh=8nPUBbYoUtNAT80wKKkWO+YB8VEQnVa8FilYwX9Bjfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ki225nsBI5w65zE2oSFuqLF9MU1AHNNXRQsheWXVxfSZRawz28EdHQlrB9POkKtU0xqEjfTy023T+90tvBKoGOoKC/ixDFWRVPhkU04C3UIk1YS/ccn7b/iyxY9pCO7ymVi8YU+/LVYEN2rczXqg8Cu5K+19VSpJIP0pexU6LAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7194B1063;
	Fri, 30 Aug 2024 08:55:26 -0700 (PDT)
Received: from [10.1.30.22] (e122027.cambridge.arm.com [10.1.30.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C38F3F762;
	Fri, 30 Aug 2024 08:54:56 -0700 (PDT)
Message-ID: <5dfccae9-58c3-4159-b1df-1b783e513dfa@arm.com>
Date: Fri, 30 Aug 2024 16:54:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/19] firmware/psci: Add psci_early_test_conduit()
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-5-steven.price@arm.com>
 <20240823132918.GD32156@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20240823132918.GD32156@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23/08/2024 14:29, Will Deacon wrote:
> On Mon, Aug 19, 2024 at 02:19:09PM +0100, Steven Price wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> Add a function to test early if PSCI is present and what conduit it
>> uses. Because the PSCI conduit corresponds to the SMCCC one, this will
>> let the kernel know whether it can use SMC instructions to discuss with
>> the Realm Management Monitor (RMM), early enough to enable RAM and
>> serial access when running in a Realm.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> v4: New patch
>> ---
>>  drivers/firmware/psci/psci.c | 25 +++++++++++++++++++++++++
>>  include/linux/psci.h         |  5 +++++
>>  2 files changed, 30 insertions(+)
>>
>> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
>> index 2328ca58bba6..2b308f97ef2c 100644
>> --- a/drivers/firmware/psci/psci.c
>> +++ b/drivers/firmware/psci/psci.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/errno.h>
>>  #include <linux/linkage.h>
>>  #include <linux/of.h>
>> +#include <linux/of_fdt.h>
>>  #include <linux/pm.h>
>>  #include <linux/printk.h>
>>  #include <linux/psci.h>
>> @@ -769,6 +770,30 @@ int __init psci_dt_init(void)
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Test early if PSCI is supported, and if its conduit matches @conduit
>> + */
>> +bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit)
>> +{
>> +	int len;
>> +	int psci_node;
>> +	const char *method;
>> +	unsigned long dt_root;
>> +
>> +	/* DT hasn't been unflattened yet, we have to work with the flat blob */
>> +	dt_root = of_get_flat_dt_root();
>> +	psci_node = of_get_flat_dt_subnode_by_name(dt_root, "psci");
>> +	if (psci_node <= 0)
>> +		return false;
>> +
>> +	method = of_get_flat_dt_prop(psci_node, "method", &len);
>> +	if (!method)
>> +		return false;
>> +
>> +	return  (conduit == SMCCC_CONDUIT_SMC && strncmp(method, "smc", len) == 0) ||
>> +		(conduit == SMCCC_CONDUIT_HVC && strncmp(method, "hvc", len) == 0);
>> +}
> 
> This still looks incomplete to me as per my earlier comments:
> 
> https://lore.kernel.org/all/20240709104851.GE12978@willie-the-truck/
> 
> For the first implementation, can we punt the RIPAS_RAM to the bootloader
> and drop support for earlycon? Even if we manage to shoe-horn enough code
> into the early boot path, I think we'll regret it later on because there's
> always something that wants to be first and it inevitably ends up being
> a nightmare to maintain.

Short-answer: yes, although it has drawbacks.

I've never been keen on the RIPAS_RAM requirement, the logic behind it
is that it makes it easier to have varying amounts of RAM given to the
guest without affecting the attestation. But it's a weak argument and
I'd personally prefer to punt the responsibility to a bootloader/VMM.

earlycon should be fairly easy to remove - and it doesn't have to
actually kill earlycon because we can pass in the address with the top
bit set - it just requires fixing up the VMM.

EFI is the main issue.

I'll have a go at coming up with a cut down series - at the very least
I'll see if I can rearrange to have the troublesome parts at the end so
they can be dropped if necessary.

Steve


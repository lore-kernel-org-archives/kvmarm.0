Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6E03C3F7B;
	Thu, 10 Sep 2026 08:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789029805; cv=none; b=aml/WdPWOcFpZWgY4uwDbLEPuHk9C7ChZ6PGBPmgmzNhTHwA0tYFcczuMsXhhjcjg5Vms/pNTDj/sisaY9F3IyWD5O9epZ1Lis1ynfyRnk48o1f3QAKiJYvK5c7AHGNGWKOP0e+8N8lW6ZaDPyQhOhOowf/yOlf+YaXuiQawftY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789029805; c=relaxed/simple;
	bh=pZUMNn7G6bEmWkSQbLz54BigM3O4mPAIKyE7XJ1QN/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VYnQEzxZLN5GwxzTA4/kQtQpVl7LKa2XPeK61qg7yqIwhjx2w2KS9toxbQQEmjv/hdo9MSJBP//mMIlbD8/SIhmzYQ7TKo3ZOFLeDouDrgWX0UK2Rvi0By31qdQYRdUYmMg1273feRpUmm4E66tKi0o/39NBWnrfFWiNK2p1ECg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EHjRVZpn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EHjRVZpn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA6D81570;
	Thu, 10 Sep 2026 01:43:18 -0700 (PDT)
Received: from [10.0.129.245] (unknown [10.0.129.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A30433F7B4;
	Thu, 10 Sep 2026 01:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789029802; bh=pZUMNn7G6bEmWkSQbLz54BigM3O4mPAIKyE7XJ1QN/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EHjRVZpnJR2Yspv1pcvSj5E8gglrpU8NcIRqk/eLWDvSmVhmkEnt5wHKbiTXtnFSU
	 vm/P1PsmftSvQMuEhWVLOoJYES5EwyAheGCUV7Jar3sxHe6GayFDDE1GnvT012cb3G
	 h34jwHoi3ZpFOpzyb3GvlaGfqIIVa8VCneQYTc48=
Message-ID: <40d3312a-c695-44ed-857a-fc6bf293f3e6@arm.com>
Date: Thu, 10 Sep 2026 09:43:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 06/20] KVM: arm64: CCA: Add a new mode for supporting
 Realm guests
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-7-suzuki.poulose@arm.com>
 <e66698e1-e582-4ff8-9881-4ddda5bc1d94@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <e66698e1-e582-4ff8-9881-4ddda5bc1d94@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/09/2026 06:53, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 9/9/26 2:22 AM, Suzuki K Poulose wrote:
>> Add an explicit mode to support Arm CCA guests.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   Documentation/admin-guide/kernel-parameters.txt | 3 +++
>>   arch/arm64/include/asm/kvm_host.h               | 1 +
>>   arch/arm64/kvm/arm.c                            | 5 +++++
>>   3 files changed, 9 insertions(+)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/ 
>> Documentation/admin-guide/kernel-parameters.txt
>> index 68647ff4bdd24..1afe3df3b923e 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -3256,6 +3256,9 @@ Kernel parameters
>>               nested: VHE-based mode with support for nested
>>                   virtualization. Requires at least ARMv8.4
>>                   hardware (with FEAT_NV2).
>> +            rmm: Support for running confidential guests in Realm
>> +                 world using RMM, as defined by Arm Confidential
>> +                 Compute Architecture (CCA)
>>
> 
> I'm not sure, but 'realm' would be more appropriate name. rmm (Real 
> Management Monitor) is
> the term limited to the firmware to me. Besides, we have been using 
> 'realm' broadly in this
> series like kvm_vm_is_realm(), kvm_realm_state() and so on.

May be. But we use the "mode" of the hypervisor in question here, 
mostly. e.g., nvhe, vhe, protected etc. So, I went with RMM (in favor
of CCA). Does that make sense ? Also, we rely on firmware/arm_rmm for
the support. So, it kind of make sense to keep it "rmm" ?

Cheers
Suzuki

Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D962DEA77
	for <kvmarm@lists.linux.dev>; Wed, 18 Feb 2026 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771434137; cv=none; b=RzhXR7gpgNnO06yQl9x/RSXxDPrTg4dUCGwqG4mAZ2fhvgv87hW4IFZ03QS3xW7CuLRxIFsLeG6QWDcx+h/fmv5k5kYp6apfrgx1lZUnRL9QcaAqiiPhu4Vy2NG8IBRQ7YL5emGdJGvCB5tonDDsTX/Txsi4zVAB3+NCXZ7d3fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771434137; c=relaxed/simple;
	bh=FbspF4cZNt8xwQgfm66zQ000CMjwK09OZUhidFbe9Wc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WdL/GzdRBUIgDWnHlVchqrwTq1HKXGcR/qGJdrHiNvL4PqScgZoL3SzwKB6uBFbAmtUKPIJIpyNMiWThpiyNwltaHhjZK5CpYkpLB7Mq4y/GRddVgyB+1ndtekLNkMCGOf9SVp5L/aZ3s//t5aZ7dYFriBnpOf1XzjFhyPP9PKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97A0E339;
	Wed, 18 Feb 2026 09:02:09 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF5843F62B;
	Wed, 18 Feb 2026 09:02:10 -0800 (PST)
Message-ID: <9d0cc06b-f8cb-43bb-94da-98d106cb5798@arm.com>
Date: Wed, 18 Feb 2026 17:02:09 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 41/41] arm64: mpam: Add initial MPAM documentation
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-42-ben.horgan@arm.com>
 <20260205170557.00000d4d@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260205170557.00000d4d@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 2/5/26 17:05, Jonathan Cameron wrote:
> On Tue, 3 Feb 2026 21:43:42 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> MPAM (Memory Partitioning and Monitoring) is now exposed to user-space via
>> resctrl. Add some documentation so the user knows what features to expect.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes by Ben:
>> Some tidying, update for current heuristics
>> ---
>>  Documentation/arch/arm64/index.rst |  1 +
>>  Documentation/arch/arm64/mpam.rst  | 93 ++++++++++++++++++++++++++++++
>>  2 files changed, 94 insertions(+)
>>  create mode 100644 Documentation/arch/arm64/mpam.rst
>>
>> diff --git a/Documentation/arch/arm64/index.rst b/Documentation/arch/arm64/index.rst
>> index 6a012c98bdcd..189fa760dade 100644
>> --- a/Documentation/arch/arm64/index.rst
>> +++ b/Documentation/arch/arm64/index.rst
>> @@ -23,6 +23,7 @@ ARM64 Architecture
>>      memory
>>      memory-tagging-extension
>>      mops
>> +    mpam
>>      perf
>>      pointer-authentication
>>      ptdump
>> diff --git a/Documentation/arch/arm64/mpam.rst b/Documentation/arch/arm64/mpam.rst
>> new file mode 100644
>> index 000000000000..0769bccff25e
>> --- /dev/null
>> +++ b/Documentation/arch/arm64/mpam.rst
>> @@ -0,0 +1,93 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +====
>> +MPAM
>> +====
>> +
>> +What is MPAM
>> +============
> 
> 
>> +  MPAM (Memory Partitioning and Monitoring) is a feature in the CPUs and memory
> 
> I've not seen this style of indenting much in rst.  I checked a few
> files in this directory and it's not used in the ones I randomly picked.
> + it's not what the kernel-documentation.rst file suggests is standard
> formatting.

I seem to have needlessly invented a new style. I've not removed lots of
white space. It should match the rest now.

> 
> Other than that the content looks fine to me.
> 
> Jonathan

Thanks,

Ben


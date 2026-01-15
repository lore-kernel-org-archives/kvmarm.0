Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81B730AAD4
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768487864; cv=none; b=nXrqrtjVNLBg2FiaObrJ87LB2o/I54C6avVBJIDu0yG3yeL5MleAtw0YYULUaVYxCWag1QWyHT0Xdg3/geY508ic7wn4fCuEeJ1ao3cyNPykTavgPETF+klozJ1ub/by9fm/kNMMJFCFRpugMcGZpl4DIJIlheAZ7u2w9wcqWzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768487864; c=relaxed/simple;
	bh=td1PrujXoDUrovW6IQuY837sgXqpXqWHZRDHa3SZrqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PE5ctOl/tm59+HPCc/rIwgf5MQcSFWfEuKK6/GziZJZIuh03cn0IgnBsm51UpJY2pzJvrOX/GRYKXesv93JzKsJZl0Nxjuqn5CpybNGCGpkdzlr+Ey+KlmUcEWD8mlSBSa66atEipdeq0JHEdiOZdpAeeBgCoX+hUeu4NSE7EtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AFE1FEC;
	Thu, 15 Jan 2026 06:37:31 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3FE83F632;
	Thu, 15 Jan 2026 06:37:32 -0800 (PST)
Message-ID: <46047ccd-3b45-4bce-a71b-47dadc1eab88@arm.com>
Date: Thu, 15 Jan 2026 14:37:31 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v2 0/45] arm_mpam: Add KVM/arm64 and resctrl glue
 code
To: Zeng Heng <zengheng4@huawei.com>, james.morse@arm.com
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 catalin.marinas@arm.com, corbet@lwn.net, dave.martin@arm.com,
 david@kernel.org, dfustini@baylibre.com, fenghuay@nvidia.com,
 gshan@redhat.com, joey.gouly@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, kvmarm@lists.linux.dev, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 maz@kernel.org, oupton@kernel.org, peternewman@google.com,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 suzuki.poulose@arm.com, tan.shaopeng@fujitsu.com, will@kernel.org,
 sunnanyong@huawei.com, Babu Moger <bmoger@amd.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260114065149.1108631-1-zengheng4@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260114065149.1108631-1-zengheng4@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Zeng,

+CC Babu (Comments on PLZA)

On 1/14/26 06:51, Zeng Heng wrote:
>> From: Ben Horgan <ben.horgan@arm.com>
>> Date: Fri, 19 Dec 2025 18:11:02 +0000
>> Subject: [PATCH v2 00/45] arm_mpam: Add KVM/arm64 and resctrl glue code
>>
>> One major departure from the previous snapshot branches referenced in the
>> base driver series is that the same MPAM setting are used for kernel-space
>> and user-space. That is, MPAM1_EL1 is set to the same value as MPAM0_EL1
>> rather than keeping the default value. The advantages of this are that it
>> is closer to the x86 model where the closid is globally applicable, all
>> partids are usable from user-space and user-space can't bypass MPAM
>> controls by doing the work in the kernel. However, this causes some
>> priority inversion where a high priority task waits to take a mutex held by
>> another whose resources are restricted by MPAM. It also adds some extra
>> isb(). I would be interested in opinions/data on the policy for MPAM in
>> kernel space, i.e how MPAM1_EL1 is set.
> 
> Another advantage is that, given the small size of the L2 cache,
> frequent switching of MPAM configurations between kernel and user modes
> can cause cache-capacity jitter, making it difficult to isolate
> interference from noisy neighborhood.
> 
> However, in addition to the issues mentioned above, updating the
> MPAM1_EL1 configuration also exposes interrupt handling to the MPAM
> settings of the current task.

Makes sense, thanks for these two observations.

> 
> I still agree with the current modification of setting MPAM1_EL1 to the
> same value as MPAM0_EL1. However, the ARM MPAM hardware supports more
> flexible configuration schemes than x86 RDT and another approach is also
> worth considering: Software can let a control group choose whether
> kernel mode follows the user mode MPAM settings, or whether the kernel
> mode configuration is delegated to the default control group, though
> this may change the existing user interface.

I wonder if this would be possible in AMD PLZA as well. Babu?

> 
> At the LPC resctrl micro-conference, Babu also mentioned the PLZA proposal
> as an attempt to address the issues raised above. Seems like no clear
> interface was presented yet. Wait to see what new interface that solution
> will introduce.

Yes, I watched a recording of that. :)

> 
> One last thing, please add me to the CC list for future MPAM patch series.
> I'll provide timely testing on my local aarch64 environment and review
> feedback. Thanks.

Will do. Apologies for not doing this earlier and thank you for the
promise of testing and reviews :) There is a v3 which you have hopefully
seen.

> 
> 
> Best Regards,
> Zeng Heng
> 
> 

Thanks,

Ben


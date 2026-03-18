Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E320372EF1
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 11:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773832597; cv=none; b=l1al/sZR1I7M8KggY7/vD0aH5TporO/Z6WGEPlgQbbQToWwgZADZ8VnsldsdtQaDyGde413M4cv9PTUlAXn5QNPQFtENKwaFGaTBeJyEdIfCIYyE6F1BMqKjy6xskqPndmmpYrrc/jkQOTqVI29cam/QsOCyCkWSw7aNQ5MAvy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773832597; c=relaxed/simple;
	bh=yHF5z9WeHp6mIoOEgq2tupUKg1OMJm89pGwBRBf02aE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=okqNTBBUQ+UmIfCeEgRjTEzHXxa5NIMNrmbGuOwkFqofWGNGXUFjEIOQVE5GJkL7RWmbvCOINGBEgF76VwS3+hk8BLnKtuy+lAzw25ub1fzAtRrqU97DMeHTtICrFyzdBl356WL3GwIjAXsqvjnQwiIAgtXdPvEeEfwv4FskYoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 872DA1E2F;
	Wed, 18 Mar 2026 04:16:29 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17CF93F73B;
	Wed, 18 Mar 2026 04:16:30 -0700 (PDT)
Message-ID: <8dc8eb43-9bc5-46d3-8ce8-06d25fd5eeb7@arm.com>
Date: Wed, 18 Mar 2026 11:16:29 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v5 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
To: Howard Zhang <Howard.Zhang@arm.com>, James Morse <James.Morse@arm.com>
Cc: "amitsinght@marvell.com" <amitsinght@marvell.com>,
 "baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
 Catalin Marinas <Catalin.Marinas@arm.com>, "corbet@lwn.net"
 <corbet@lwn.net>, Dave Martin <Dave.Martin@arm.com>,
 "david@kernel.org" <david@kernel.org>,
 "dfustini@baylibre.com" <dfustini@baylibre.com>,
 "fenghuay@nvidia.com" <fenghuay@nvidia.com>,
 "gshan@redhat.com" <gshan@redhat.com>, Joey Gouly <Joey.Gouly@arm.com>,
 "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
 "kobak@nvidia.com" <kobak@nvidia.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "lcherian@marvell.com" <lcherian@marvell.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "punit.agrawal@oss.qualcomm.com" <punit.agrawal@oss.qualcomm.com>,
 "quic_jiles@quicinc.com" <quic_jiles@quicinc.com>,
 "reinette.chatre@intel.com" <reinette.chatre@intel.com>,
 Rohit Mathew <Rohit.Mathew@arm.com>,
 "scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
 "sdonthineni@nvidia.com" <sdonthineni@nvidia.com>,
 Suzuki Poulose <Suzuki.Poulose@arm.com>,
 "tan.shaopeng@fujitsu.com" <tan.shaopeng@fujitsu.com>,
 "will@kernel.org" <will@kernel.org>,
 "xhao@linux.alibaba.com" <xhao@linux.alibaba.com>,
 "zengheng4@huawei.com" <zengheng4@huawei.com>
References: <A76F5D3E-4AB1-4418-B250-2ED9DD1BBE56@arm.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <A76F5D3E-4AB1-4418-B250-2ED9DD1BBE56@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Howard,

On 3/18/26 09:52, Howard Zhang wrote:
> Hi Ben, James,
> 
> I have a few questions regarding MPAM support in the kernel:
> 
> Are there any plans to upstream L3 partitioning with capacity-based allocation (in addition to the existing way-based partitioning)?

Yes, there is some preliminary work required to establish how new schema will be added to
resctrl but I expect cache capacity, CMIN/CMAX, to be some of the first features to use it.
[1] has some discussion on now to introduce new schema.

[1] https://lore.kernel.org/lkml/aPtfMFfLV1l%2FRB0L@e133380.arm.com/

> 
> Thanks for your time.
> 
> Best regards,
> Howard

Thanks,

Ben

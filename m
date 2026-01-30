Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95EE91F09AD
	for <kvmarm@lists.linux.dev>; Fri, 30 Jan 2026 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769782667; cv=none; b=QW9+EQMhHt36ZauZAuJSI8Xe4QI3WMC36lhZiA85rmnkBUnTp+OqZsvpvfmeEW/jf2SlpSuEaJNtVtkIT6d5lFsqUbyB/XGAMCEY7l0j9jcpNrSz+r5e0G2717qvZEvd7rUPK+8MJNMWrJ7U4TF4wMtmLa8Eov8KnKdTaUAqpUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769782667; c=relaxed/simple;
	bh=XkYOyyNvkhlD0140j62Pxg9wbmWelZ5Fm9Qz2tT8pWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YJ9xOvTv4/qgwagde+f132SL2w1+//iuQJ9JwwKI5fvpVZ+bX9I/HahCHNPNuH4l+Gb3DT7aXC1jnomW1o6r35vw2sBi9kE4EaR8wW+z+/3vdZJZRIVMGVRGttqvVsKPF4x6bDkTwzaW1PJTaFSzmu9BWFb47hW+W5hedq3uW7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90DDA153B;
	Fri, 30 Jan 2026 06:17:38 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CDFD3F632;
	Fri, 30 Jan 2026 06:17:39 -0800 (PST)
Message-ID: <80db7035-07d3-4fb4-a228-f9c67d2df1f4@arm.com>
Date: Fri, 30 Jan 2026 14:17:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 41/47] arm_mpam: Generate a configuration for min
 controls
To: Jonathan Cameron <jonathan.cameron@huawei.com>,
 "fenghuay@nvidia.com" <fenghuay@nvidia.com>
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
 Zeng Heng <zengheng4@huawei.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-42-ben.horgan@arm.com>
 <20260113153938.00007d6e@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260113153938.00007d6e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fenghua, Jonathan,

On 1/13/26 15:39, Jonathan Cameron wrote:
> On Mon, 12 Jan 2026 16:59:08 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> From: James Morse <james.morse@arm.com>
>>
>> MPAM supports a minimum and maximum control for memory bandwidth. The
>> purpose of the minimum control is to give priority to tasks that are below
>> their minimum value. Resctrl only provides one value for the bandwidth
>> configuration, which is used for the maximum.
>>
>> The minimum control is always programmed to zero on hardware that supports
>> it.
>>
>> Generate a minimum bandwidth value that is 5% lower than the value provided
>> by resctrl. This means tasks that are not receiving their target bandwidth
>> can be prioritised by the hardware.
>>
>> For component reset reuse the same calculation so that the default is a
>> value resctrl can set.
>>
>> CC: Zeng Heng <zengheng4@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> 
> I'm interested to see how this plays out as a default choice
> vs what people elect to run.  Seems harmless to start with this.

I've realised it's not harmless :(

> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 

In the discussion on a platform quirk, arm_mpam: Add workaround for
T241-MPAM-4,  Fenghua raised the following issues.

"
MBW_MIN is 1% or 5% less than MBW_MAX.

The lower MBW_MIN hints hardware to lower mem bandwidth when mem access
contention. That causes memory performance degradation.

Is it possible to do the following changes to fix the performance issue?
1. By default min mbw is equal to max mbw. So hardware won't lower
performance unless it's needed. This can fix the current performance issue.
2. Add a new schemata line (e.g. MBI:<id>=x;<id>=y;...) to specify min
mbw just like max mbw specified by schemata line "MB:...". User can use
this line to change min mbw per partition per node. This could be added
in the future.
"

On 1.
Thinking about this again, I think adding any heuristic tied to mbw_max
to determine what mbw_min is undesirable. Loading the mpam driver or
mounting resctrl shouldn't change the defaults away from the defaults
for h/w partid 0 or performance characteristics may change unexpectedly.
The spec only gives us suggestions for these but we should go with
those. See table 3.8 in IH0099B.a Mpam System Component Specification.
The MBW_MIN that is 0xFFFF. Also, having mbw_min doesn't necessarily
mean that there is mbw_max. A system that doesn't advertise mbw_min
support to the user should act as if there is no mbw_min support.
On 2.
Yes, adding a new user interface in resctrl is the way to deal with
this. See [1] for a discussion on adding new schema.

Hence, I'll drop this patch, and update the mbw_min default to be 0xFFFF
and for the value not to change even if mbw_max changes. I think this
leaves us in the best position going forward without any heuristics that
may come back to bite us later when proper support for a schema
supporting mbw_min is added to resctrl.

[1] https://lore.kernel.org/lkml/aPtfMFfLV1l%2FRB0L@e133380.arm.com/

Thanks,

Ben


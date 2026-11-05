Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882186;
	b=KFp6FMui4+9G0Kf4MEUPnjabo3SEXaIS62yP9PQVfFeAqWplrnxG6GyiCNlJl9zFWXNx
	 a2XrA1o60LD11mr9LXddvOqSxpoqeoizetgJ2M4PuXcx3X6WcrK+Vpr7gmtIguIvSn0OS
	 AXjJ75cxbbB/DZr5tTygIpmIUqv6FiCXo1ti2DdBvcqeho4RpMZClOweVfiVIa1yPCURV
	 /y/VhWOpuD+wTmufBzrTUR4ghSXHm0HqY3wW/lgsuDrDlk253OqNhMjKItMXTciNsxQwr
	 LytCFzknsWGBgUKJTCDwjVjCEq7uhz3QBIXL7e08YmqI3qSSir8F37sZxOLnRHynCaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882186;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=/NsG0cyMzXROSstgbjVKXoEsL+g2CwtLRSNxnglyzKA=;
	b=SJv6/SYHbfJlN2Cpon6k7j2Tun2oxGeq5w0Fc5/rLONrF4R9+5GTm7UprPMpMXsMORq0
	 VfMbV18KjBlHjrXaJjKkWLB89VI7c3xaOUeW+sDNMXoBJY+M/pxacCsjiCsQKULER+BMd
	 CmAN8P8KzPaDswCPlSyX/8FqelsDS2XcB/XWKsoBO975YaNEdMLZYwSv4eDbFDCbhvr5s
	 GE/zEvPbUweKOUISovbpSb237xg+XcDHmirOnPEU9dceLE99S4pwCd/yMs6IAgfFxfo8M
	 gM9GHrYSXfWOq66Lvu5rGsew4KBFWZusG9yEyLL5rKmmyEdw5r6n+60a8FVFQO+Rakg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jHQeGkBo;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F05606A31B
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 12:36:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5F05606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jHQeGkBo
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF0331E8D;
	Thu,  5 Nov 2026 04:36:21 -0800 (PST)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 978DF3F673;
	Thu,  5 Nov 2026 04:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793882184; bh=Xy2a35D5lFs3xumDyQSNHeQOf3ovIJScDgtK1Ak0u04=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jHQeGkBozT/P4vps+KO9ztDP0/y2NBmMxgQj1XLDVLrgzbghOtq+A4YxSebRD114v
	 RaJDs7jmao2mC0baEwZGDmyQFlADuqFH5RLPwGmr+9yleq0uPMQig6k3EKtZF7sgzh
	 4hED0g3Z2l1Tf+AlvvQnAw+9ZkTlntjqurTZEDpM=
Message-ID: <6fb4ce7c-c173-4e86-8f8b-9bbc53751d8c@arm.com>
Date: Thu, 5 Nov 2026 12:36:19 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/40] arm64: mpam: Context switch the MPAM registers
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-7-ben.horgan@arm.com>
 <145b3c09-ff33-4fd7-935a-fa4f4c3c07b2@huawei.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <145b3c09-ff33-4fd7-935a-fa4f4c3c07b2@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Jinjie,

On 05/11/2026 12:20, Jinjie Ruan wrote:
> 
> 
> 在 2026/3/13 22:45, Ben Horgan 写道:

> 
> Hi, everyone,
> 
> We found a problem as below:
> 
> In an offline/online co-located setup, MPAM gives the offline group a
> smaller MBW share, a softirq serving an online service runs with the
> PARTID of the throttled offline task it interrupted and is throttled
> with it -- a priority inversion.
> 
> Is this a known limitation?

Yes. The initial MPAM support was introduced with the userspace and kernel PARTID changing in
lockstep so that it matched the standard x86 setup. This left the way open for a generic resctrl way
to express that they may be different.

> 
> I see the following patchset uses a separate closid for kernel.
> 
> https://lore.kernel.org/all/cover.1790867441.git.babu.moger@amd.com/
> 
MPAM should be able to work with that as outlined by Reinette [1].

[1] https://lore.kernel.org/lkml/2ab556af-095b-422b-9396-f845c6fd0342@intel.com/

Thanks,

Ben

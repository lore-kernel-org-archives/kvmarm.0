Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CA1303A04
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 21:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772053826; cv=none; b=jvzU70BBXdUclkZ9tIFQxC/WNOUrsMC6kUUjtG37lflcHWPOV/9VutxGQduEa09DudNFV0oN+LFlIRU0nMC+uR1w17hEJxkwUH0OeTSX2SqUVFD348VnTwCh7L64h8EWrT/Kf4uko563rtbprcMWum1J/0I9OQl3W/OvJ2gfHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772053826; c=relaxed/simple;
	bh=8XCjqIqgqb+TT5zPv7yUUkOxCIPmrD/tC0tZgAPxfak=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:To:
	 In-Reply-To:Content-Type; b=tqzTGo1Kq9wjKgJG6Czw/xIFRtPt3ksRz0tbYAvUfAZ19PH5Jk4tJj2r6cyIFGU/U2hrzpZwCKOkH3I8FTJ54etVpZzud+6QDUEIY2DAuZRISLtBw9k7TqKDBV8bB8GGwB5La+jcRnEM7z/zYu0S1es+uFl5GX9kUPOVD9bhy8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E585515A1;
	Wed, 25 Feb 2026 13:10:17 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A480F3F62B;
	Wed, 25 Feb 2026 13:10:19 -0800 (PST)
Message-ID: <6051a508-1e77-4216-9b41-4b93b21c18c3@arm.com>
Date: Wed, 25 Feb 2026 21:10:08 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
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
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260224175720.2663924-1-ben.horgan@arm.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
To: ben.horgan@arm.com
In-Reply-To: <20260224175720.2663924-1-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/24/26 17:56, Ben Horgan wrote:
> The main change in this version of the mpam missing pieces series is to
> update the cdp emulation to match the resctrl interface. L2 and L3
> resources can now enable cdp separately. Cdp can't be hidden correctly for
> memory bandwidth allocation, as max per partid can't be emulated with more
> partids, and so we hide this completely when cdp is enabled. There is a little
> restructuring and a few smaller changes.
> 
> Changelogs in patches
> 
> It would be great to get this series merged this cycle. For that we'll need
> more testing and reviewing. Thanks!
> 

There is a small build conflict with resctrl abmc precursors, [1]. The
last patch of that series applies on top of this series and if the abmc
precursors go first that patch should go with this series to fix the
build. Alternatively, if it's obvious ahead of time it can be squashed
into pathc 33 with the other empty resctrl arch hooks.

[1]
https://lore.kernel.org/lkml/20260225201905.3568624-5-ben.horgan@arm.com/


Thanks,

Ben


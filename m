Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB38B34E770
	for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 14:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776091327; cv=none; b=ggy7pasTmrB55jK2cqfJJacKdYadsbFaZ4UrUA1KYfrZIHv08KYltH+PlmitltDTM6xBF1f2MzQTLhULzstZetl1tfo2JlLcFOjJ40w/L2RGK8WmYSz4hAJG6zDQpMKYv5miNs+c73XeBVTDylFYmFS48XK3Nv1G+x528ZbbGWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776091327; c=relaxed/simple;
	bh=Vnrz228eSk/mptycnXQRjUy58RSHNsaULpU2FASTdWU=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:
	 In-Reply-To:Content-Type; b=QbVRKxkb5Xe1xUjp8F6tAFQpa81Q/OhgbwyoqyOL3iZguQhOYzpZaTbivzbK431inSRpcEPhYu6BAAKu3jbtIu8LXceKwcJG/gtf7dBIFYJFX++708pGcSTjPIPbpVs5VCQzw7yBz8qoyCnUdMZGFUM6L/TLvbwlS2fJP+PfB5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ox4XFWgT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ox4XFWgT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72055357A;
	Mon, 13 Apr 2026 07:41:59 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B13E63F641;
	Mon, 13 Apr 2026 07:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776091325; bh=Vnrz228eSk/mptycnXQRjUy58RSHNsaULpU2FASTdWU=;
	h=Date:Subject:Cc:References:From:In-Reply-To:From;
	b=Ox4XFWgTjz8OIRvYE2TPsgObpjTSWquTbGbtfyBurAHNFusQmwooU6ij0WBXa7ssY
	 GnGPNXrGAkuHQvNgAPIjjezUioQbP/LC8CiCugXqLSvDv2GCQUvKx5oWqo/z7e6M+5
	 Fm8LZpzkjKkkAhAny3/DQ/+SL7TkOWMlVPTepHMQ=
Message-ID: <fa463a9a-2dff-4f2b-931e-9e0a9ac3f9c9@arm.com>
Date: Mon, 13 Apr 2026 15:41:59 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
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
References: <20260313144617.3420416-1-ben.horgan@arm.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/26 14:45, Ben Horgan wrote:
> This version of the mpam missing pieces series sees a couple of things
> dropped or hidden. Memory bandwith utilization with free-running counters
> is dropped in preference of just always using 'mbm_event' mode (ABMC
> emulation) which simplifies the code and allows for, in the future,
> filtering by read/write traffic. So, for the interim, there is no memory
> bandwidth utilization support. CDP is hidden behind config expert as
> remount of resctrl fs could potentially lead to out of range PARTIDs being
> used and the fix requires a change in fs/resctrl. The setting of MPAM2_EL2
> (for pkvm/nvhe) is dropped as too expensive a write for not much value.
> 
> There are a couple of 'fixes' at the start of the series which address
> problems in the base driver but are only user visible due to this series.
> 
> Changelogs in patches
> 
> Thanks for all the reviewing and testing so far. Just a bit more to get this
> over the line.
> 
> There is a small build conflict with the MPAM abmc precursors series [1], which
> alters some of the resctrl arch hooks. I will shortly be posting a respin
> of that too.
> 
> [1] https://lore.kernel.org/lkml/20260225201905.3568624-1-ben.horgan@arm.com/
> 
> From James' cover letter:
> 
> This is the missing piece to make MPAM usable resctrl in user-space. This has
> shed its debugfs code and the read/write 'event configuration' for the monitors
> to make the series smaller.
> 
Thanks for all the help testing and reviewing. James has now sent a pull request to Catalin and he has picked it up.

Pull request:
https://lore.kernel.org/linux-arm-kernel/01f76011-f3c2-4dcb-b3bc-37c7d4de342e@arm.com/

branch in arm64:
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/mpam

Ben

Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 493B5314B71
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 11:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477017; cv=none; b=WA4MsewDWJFB66FhPe/ixLvOgSmgljtjOjPFBlas6FCm+vbEHhjig495WSIaB02OYJFz/+6xoWlQn8geLvs/8zUWvGanCTLzRDXzlrA7ore7Rd2CcPVOnf7xV+MEUQZBhj5OXZVWPNu7VGpkClTrD1QFQvMGkCXLDgpbWigCn9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477017; c=relaxed/simple;
	bh=aVqDQl7Lvv4CydiS25maDbhux0WcPxIG/Z10i5KXjcA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F99azOtCMVxa10Hl6kfZyFT9PnczmWqrTwfcRorH9MNUdVcXKdxRJNlyqHHnCem/HXhGp7JC6LiML0/XFD87IzLM0wxdLEhA0RrJzZ3XBQaBVY9YuURfGwfJLYF3XwbTlG6wBC2N95Ryh0EnODHAkmvL4uorNtJ6ZZ42wNGkC2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FA0FFEC;
	Thu, 15 Jan 2026 03:36:47 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DCC003F694;
	Thu, 15 Jan 2026 03:36:48 -0800 (PST)
Message-ID: <440ea311-67b7-4b7a-936c-845fce4919b5@arm.com>
Date: Thu, 15 Jan 2026 11:36:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/47] arm_mpam: Add KVM/arm64 and resctrl glue code
To: Peter Newman <peternewman@google.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <CALPaoCh=brY6+_oJZXJLfpv_Qkz0i0RuPfuRa+TgXLu_xV6rsQ@mail.gmail.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <CALPaoCh=brY6+_oJZXJLfpv_Qkz0i0RuPfuRa+TgXLu_xV6rsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Peter,

On 1/15/26 11:14, Peter Newman wrote:
> Hi Ben,
> 
> On Mon, Jan 12, 2026 at 5:59 PM Ben Horgan <ben.horgan@arm.com> wrote:
[...]
> 
> Like before, I applied the patches and successfully booted a kernel on
> a baremetal Google Cloud C4A instance. I was able to confirm that the
> resources we expect were present and I was able to successfully run
> the monitor assignment test cases I used to validate ABMC on AMD
> systems. (Though I had to hack the driver to pretend there were less
> MBWU monitors so that the counter assignment interfaces would become
> available.)
> 
> My use cases only cover resctrl in the host, so I didn't try any of
> the KVM integration, but I can at least say there wasn't any evidence
> that it interfered with resctrl.
> 
> Tested-by: Peter Newman <peternewman@google.com>

Thanks for the testing!

Ben


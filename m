Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59DE30C635
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 15:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774626168; cv=none; b=JKNo21kD59x/Oa4+gUGLukuJw4ELKNh9IJFrpxx2saDYQnPUOAQK4ZNa+jlCVv/Zs9E4xySM4Wpei72WH2dXA9sMm8D7M9amktUgeDBOOWFEE8j/XiVU17/2gcDof2vm7CPPp2btwy3sb244LMuGbZXW2yQMIblRIT0NCQevK8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774626168; c=relaxed/simple;
	bh=WKomjFgiI9EWoQTqUByarteYU8HUetB++8qWiidbEjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TgrjlbN4U7LqNiACmUYTV+8ys2c5DJKWYoUuE3A4n379Q24Yw2qgNtuMP1YmTaQCZ2K9eSkDkgsNTj0udGosp7BzDLLSpO1HIecJ5fpwHXxyRt+7Jny5zLfOtBKZna5j6+xsrzk9jPYxlsLkJsjs/Bsf0N427mMqaynsK40Ey+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XjE6ZGu2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XjE6ZGu2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CAED35CF;
	Fri, 27 Mar 2026 08:42:40 -0700 (PDT)
Received: from [10.1.196.96] (eglon.cambridge.arm.com [10.1.196.96])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C69043F99C;
	Fri, 27 Mar 2026 08:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774626166; bh=WKomjFgiI9EWoQTqUByarteYU8HUetB++8qWiidbEjE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XjE6ZGu25UcMDd9CEYApdI5QoWo1aAlYMk0PR3w+C9b43s9sUDQd+7HHIrsJCgYDl
	 94EVZeh7IL5KcC075y07B6tuIo7rEtNPE3ycEWVSqoKCvOS/q5EvJaCQMnrJXUZl0m
	 xo43b8eIHD2e+ZxyaQ6KFKjC8cFb9XlttcBEYhNE=
Message-ID: <0bcf0a48-fe1b-4132-9181-e8cd9f7cbcc2@arm.com>
Date: Fri, 27 Mar 2026 15:42:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/40] arm_mpam: Ensure in_reset_state is false after
 applying configuration
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-2-ben.horgan@arm.com>
Content-Language: en-GB
From: James Morse <james.morse@arm.com>
In-Reply-To: <20260313144617.3420416-2-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ben, Zeng,

On 13/03/2026 14:45, Ben Horgan wrote:
> From: Zeng Heng <zengheng4@huawei.com>
> 
> The per-RIS flag, in_reset_state, indicates whether or not the MSC
> registers are in reset state, and allows avoiding resetting when they are
> already in reset state. However, when mpam_apply_config() updates the
> configuration it doesn't update the in_reset_state flag and so even after
> the configuration update in_reset_state can be true and mpam_reset_ris()
> will skip the actual register restoration on subsequent resets.
> 
> Once resctrl has a MPAM backend it will use resctrl_arch_reset_all_ctrls()
> to reset the MSC configuration on unmount and, if the in_reset_state flag
> is bogusly true, fail to reset the MSC configuration. The resulting
> non-reset MSC configuration can lead to persistent performance restrictions
> even after resctrl is unmounted.
> 
> Fix by clearing in_reset_state to false immediately after successful
> configuration application, ensuring that the next reset operation
> properly restores MSC register defaults.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks!

James


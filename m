Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D6E2882D0
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316330; cv=none; b=FPvsHw3k+XkQKsfDstA+yEsWe4dkpU6LRqmGO6wNMD2G5Sk/J5sjYsrFX46EvGF/7H81cKRplECCIxzw1xK8yAZDY+Uslg1Ndhx8CShw8LggObM1CMDWYFlH654FGbf+G5fSypTllx76o1q2v3vkVAF8mALCE8c9vtO8oGkZtY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316330; c=relaxed/simple;
	bh=XO6zpk/GyK6Avz+i6ZbgdWO5qILrOZdnAspKxoqfbDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rxIwIqk6uYZfjXSBNlg+KujvzmOiX7YINLVlaG+NpYWt63JJhml3DKVO0NEq5i2X+xQM4ekiOBjB3hheFVcwCsv3pp+qKyhL6aoVIc0wThatxvi4838Sdl8xs1pjVMLKPYi3wkoF3C0qNF1/8Bp+tCSTMx1X2XTF6qozzBaMKT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA131497;
	Tue, 13 Jan 2026 06:58:41 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C2B23F632;
	Tue, 13 Jan 2026 06:58:43 -0800 (PST)
Message-ID: <de0e4d8b-c9d2-4493-9379-ec16de0af795@arm.com>
Date: Tue, 13 Jan 2026 14:58:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/47] arm_mpam: resctrl: Implement
 resctrl_arch_reset_all_ctrls()
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
 Zeng Heng <zengheng4@huawei.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-18-ben.horgan@arm.com>
 <20260113144635.00000755@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260113144635.00000755@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan, Zeng,

On 1/13/26 14:46, Jonathan Cameron wrote:
> On Mon, 12 Jan 2026 16:58:44 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> From: James Morse <james.morse@arm.com>
>>
>> We already have a helper for resetting an mpam class and component.  Hook
>> it up to resctrl_arch_reset_all_ctrls() and the domain offline path.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> 
> There was a question from Zhengheng on v2 that doesn't seem to be addressed
> and I'm not seeing a reply on list.  Maybe an email snafu?

Yes, sorry! For some reason I don't get his emails. :( It happened on
the base mpam driver series too. I'll keep a better look at lore and
reply to his v2 query.

> 
> https://lore.kernel.org/all/20260109034506.1176234-1-zengheng4@huawei.com/
> 
> Please +CC zhengheng on future versions if we need them!

Will do. Should be CC'd on this version too. I don't if there is an
email issue with that too.

Thanks,

Ben


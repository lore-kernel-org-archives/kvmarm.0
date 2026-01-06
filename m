Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B9B2989B7
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 11:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767697888; cv=none; b=eJJ5SX253czCZy4QR8u9/nBBiwoAodld42kRxClnBrlob8QuxCaAXBGfsfdijXtcr+VLS+mkEeQKTB+SZijAav6iHPziNXTLDV5ZDPaScfjw/IfW1WYGxpyYJVRd/SOrsbzyA33rK7/auaTDgKA/6zgucsDWOtbLygeRuYTqWGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767697888; c=relaxed/simple;
	bh=AfeFD9eVDdWaE1thLaRq/aanOSNDS/yo9SHLAbFEXUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eqTQ+Q6sTUhf9b96gUKwDiytyzx/Ns2MfY88GnV6AgQ/KiasT0TL7A18KizY3aKUEpCEkfMyXX8Jv8XWfqSavSq4hRmdgv1weEMzFbkgZWGe6HSrITJJSPi8mPH+eqkmbWgHE7QW32R+xJcbGbpdYXZNAjZkrCDnLvpJ6kjJOQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7564497;
	Tue,  6 Jan 2026 03:11:19 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B3AD3F5A1;
	Tue,  6 Jan 2026 03:11:21 -0800 (PST)
Message-ID: <397def6c-d730-4e10-8a8b-c7c30c07281f@arm.com>
Date: Tue, 6 Jan 2026 11:11:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/45] arm_mpam: Use non-atomic bitops when modifying
 feature bitmap
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
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-4-ben.horgan@arm.com>
 <20260105163305.00002306@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260105163305.00002306@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/5/26 16:34, Jonathan Cameron wrote:
> On Fri, 19 Dec 2025 18:11:05 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> In the test__props_mismatch() kunit test we rely on the struct mpam_props
>> being packed to ensure memcmp doesn't consider packing. Making it packed
>> reduces the alignment of the features bitmap and so breaks a requirement
>> for the use of atomics. As we don't rely on the set/clear of these bits
>> being atomic, just make them non-atomic.
> 
> oh. That's a bit horrible.
> 
> Whilst I guess no one is likely to 'upgrade' these it feels odd enough that
> I'd be tempted to leave a breadcrumb of a comment next to them on why
> they must be the non atomic versions.

Sure, I've added the comment:

The non-atomic get/set operations are used because if struct mpam_props
is packed, the alignment requirements for atomics aren't met.

> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 
> Jonathan
> 
> 
>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Thanks,

Ben


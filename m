Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B02E290DBB
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768314925; cv=none; b=W7R/eCz7K7hVNkbApd987jiJ/eNxOBVZoIYGGWX9gqYjm4f7dR13tcfXrdJ3hjPUkzokBGgdkVn1BK0pkzox5SPtEAcRQhNfsanisatiSfdJOEya6B+nTkETPLLvKctDuMwjk1GgtiqC3tAi5G7NNr2NOg4OGjF/4vYLusOZlkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768314925; c=relaxed/simple;
	bh=9xvcvwyX55e8TyKI4+FcqtOe0I0kIabCaHUbJ29dnaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uOGfjOpGxkmmb08TiaViKKWtLeaK90elwbmhHP/vgOIJ0Y4/oZXltVdf8deS51ikc7XCeSnf7GjbEq9/fakB/ZTNNFoztwwlVx2+8Hq+Y3bJUl78fr8KvRHb0hDFbAf4DG8xWVOg3znmyOcBBIhhgCvWMlMDqEk3CT8ynBWXDkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E56C7497;
	Tue, 13 Jan 2026 06:35:15 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C927D3F59E;
	Tue, 13 Jan 2026 06:35:17 -0800 (PST)
Message-ID: <1f5206a7-c7e0-4ac1-9921-9baafb596af4@arm.com>
Date: Tue, 13 Jan 2026 14:35:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/47] KVM: arm64: Use kernel-space partid
 configuration for hypercalls
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
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-14-ben.horgan@arm.com>
 <20260113142104.00002641@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260113142104.00002641@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/13/26 14:21, Jonathan Cameron wrote:
> On Mon, 12 Jan 2026 16:58:40 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> On nVHE systems whether or not MPAM is enabled, EL2 continues to use
>> partid-0 for hypercalls, even when the host may have configured its kernel
>> threads to use a different partid. 0 may have been assigned to another
>> task. Copy the EL1 MPAM register to EL2. This ensures hypercalls use the
>> same partid as the kernel thread does on the host.
>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> ---
>> Changes since v2:
>> Use mask
>> Use read_sysreg_el1 to cope with hvhe
> 
> nvhe

In this case, I do mean arm64_sw.hvhe which is the configuration when
kvm-arm.mode=protected. The aliasing of the registers when E2H is set
meant that the read_sysreg_s(SYS_MPAM1_EL1) was actually accessing
SYS_MPAM2_EL2 and so the read and write were for the same value.

Thanks,

Ben


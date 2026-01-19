Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171D4248867
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 20:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768856290; cv=none; b=SI7e++oev3YxXHYC5oh1gvt5qtPn8es6ZXPDZEUMVWgqVorYZvv4GiGA63cRqpemQ97WiU4SOaT7Q5VpYlLENu7n9fTdCIjgpfJ/Hsiemc0JVsAZXpJfpcoabaVQIH6sLJOfptfAL4W/ROHJ1bAe694gKxviQ+yfI//ivHkOLGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768856290; c=relaxed/simple;
	bh=CZ0DOJYJdFyCVt0yddMcZDg2nSzpM8fYLYFov0+zLYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gHHgZcKTpS5izF9ybRVwj7UaK816bPjd3xpEc4kHvBz8JBS8ZIss1EGlEAj32/CwhkpECLQL9PJeaSSabKQU1hXBKke1X5QhA03k92lSiPUANzB78Ma8fpsTiYbNAq0KAbPLRYMCEaw36hLxyLFFZXMuRjLT1INwGvN7R2ENGGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0307A497;
	Mon, 19 Jan 2026 12:58:02 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CCBB93F632;
	Mon, 19 Jan 2026 12:58:03 -0800 (PST)
Message-ID: <d6f1b1e7-1b90-45c7-9049-9528c1f1cdd1@arm.com>
Date: Mon, 19 Jan 2026 20:58:02 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 47/47] arm_mpam: Quirk CMN-650's CSU NRDY behaviour
To: Gavin Shan <gshan@redhat.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-48-ben.horgan@arm.com>
 <30b7483d-abaa-4668-95bd-93765c72a1f2@redhat.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <30b7483d-abaa-4668-95bd-93765c72a1f2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 1/19/26 12:18, Gavin Shan wrote:
> On 1/13/26 12:59 AM, Ben Horgan wrote:
> An error reported by checkpatch.pl as below.
> 
> ERROR: Macros with complex values should be enclosed in parentheses
> #105: FILE: drivers/resctrl/mpam_internal.h:255:
> +#define MPAM_IIDR_ARM_CMN_650   
> FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0)    | \
> +                FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)    | \
> +                FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)    | \
> +                FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x43b)
> 

Fixed

Thanks,

Ben


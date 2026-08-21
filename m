Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C6B30F927;
	Fri, 21 Aug 2026 03:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787283751; cv=none; b=trI8UIFWIXta7nqm7o55SYRlMa6R70lyzEC5l6ylNFhZ4R92TyT+/rlzEZdnwUwHdULluu+cAgG402YziOKh+c/UC8o+mXohn0iXUecU0TZQXFvUVbZ/d7v4gpC0IH+DIX0GXNkhUy3tLmzAgVbz6Mlw+1Ajb+9hB7Sn5LL71zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787283751; c=relaxed/simple;
	bh=iGDLWLBmuHaguIg1fif8pUs+Vwdf6nReTT4xsi+tWYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QVZax8MWR+5BEv51hk942H6HhGUUG+eZlqBTaffig3VVG4RPdV5dM2x/mU9B7CfZGrHI+Am3LCg8UrrMlLS/YyBfr31APbdPkPErxrvetmN6PyI095xF6bFRv46yN1sFQLheJP7DZvTxpUCTn+KjsfueNwVo2kztMrtjSGFxelc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Y5MrYufB; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Y5MrYufB"
Received: from [192.168.0.15] (unknown [4.194.122.162])
	by linux.microsoft.com (Postfix) with ESMTPSA id DEE4220B7128;
	Thu, 20 Aug 2026 20:41:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DEE4220B7128
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787283720;
	bh=gcge2qUWUjrfLVf+Vom7hfdT2yW5yXg+cm1A2GuzH7Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y5MrYufBFbdpjXo/97GZO4RQUeLoaCJUpVw5CUkj7N/WoHU9HNnYE3YY4wG0NDsg3
	 CBCKzJL8Lktrj6nWItyozwo/643jeKgmG3hY32hsODUNhd7DmAv2QbU9uwOK1ipPBQ
	 TW/TJvLorGp5Y1ILe7gC2vaLePTGxfe/S8Dcucu8=
Message-ID: <3b019c40-e91f-4670-86bb-10c2cd1047a8@linux.microsoft.com>
Date: Thu, 20 Aug 2026 20:42:19 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 03/11] coco: guest: arm64: Add Realm Host Interface
 and guest DA helper
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Cameron <jic23@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Samuel Ortiz <sameo@rivosinc.com>, Steven Price <steven.price@arm.com>,
 Suzuki K Poulose <Suzuki.Poulose@arm.com>, Will Deacon <will@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
 <20260427082805.931832-4-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Kameron Carr <kameroncarr@linux.microsoft.com>
In-Reply-To: <20260427082805.931832-4-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/2026 1:27 AM, Aneesh Kumar K.V (Arm) wrote:
> - Add  guest-side rhi-da helper that drives the vdev TDI state machine
>   via RHI host calls and translates the firmware status codes

...

> +
> +bool rhi_has_da_support(void)
> +{
> +	int ret;
> +
> +	struct rsi_host_call *rhi_call __free(kfree) =
> +		kmalloc(sizeof(*rhi_call), GFP_KERNEL);

Same comment as before that kzalloc is best practice for struct
rsi_host_call.

> +	if (!rhi_call)
> +		return -ENOMEM;

Returning an error value in a bool function will evaluate to true. This is
probably not your intended behavior.

Regards,
Kameron

> +
> +	rhi_call->imm = 0;
> +	rhi_call->gprs[0] = RHI_DA_FEATURES;
> +
> +	ret = rsi_host_call(rhi_call);
> +	if (ret != RSI_SUCCESS || rhi_call->gprs[0] == SMCCC_RET_NOT_SUPPORTED)
> +		return false;
> +
> +	/* For base DA to work we need these to be supported */
> +	if ((rhi_call->gprs[0] & RHI_DA_BASE_FEATURE) == RHI_DA_BASE_FEATURE)
> +		return true;
> +
> +	return false;
> +}...

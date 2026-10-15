Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6F44CEE52;
	Thu, 15 Oct 2026 13:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792070635; cv=none; b=odKQn5kHbB1/a9xj08C8e4iAZ3gRzTRejunEpulconsHsUDYFjvQxGmj9aB/DxJi+9et6D7v9P+y8O8xlGZFfKN/uiaPw2NlMOIlUocjzINIGdody2AMNWBESM5HF+y/OqKRMLNdf5WugAujTKvg9Ea0EHirNVSI5k8AJMAWq5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792070635; c=relaxed/simple;
	bh=W7dmmoeYfXU9p7GmPCCSxg8VG0+Bfz4uridye7MlSN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEaAdIzaIUYIUgXvnHSswAxsVMC91u+gI0IlXVHPk1x54tivd0jwK37d1LVmIOPIMKcwWvTC9wAuD6qhyFfCqnWjCuMntWS+I24ReWHyjXj9V23iOffkf7dG8K2gZq6hE0dDL9iw3zuyJe5vtIYzogS1jheTMICcE7MWrTK6Q00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VA/+0ZyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VA/+0ZyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920001F000C4;
	Thu, 15 Oct 2026 13:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792070634;
	bh=+eY/8SzCL1ecc1E0dSwRAQE+0x44i8QCx5GpklEFvyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VA/+0ZyT1W/3GVjxBq/7MbPKIu8VyMVho+se3aTX141PFcM5oRFgngzOxri2VltNG
	 unQOfMVuVV5vlGLFeHUJ7hMTAiAnRVeQg6Wucwn5hGIpwLntLb+zTwpjpQSzUO66VJ
	 z0AP1U+H/PZBgS8EDZMGZn46xuncawpSQ7l3euLYagD8thprcM9jJoHkzXGaeZwSUT
	 zZZilFktQbjJGGoITO7eDDdq12O+aXr9/XFfKvjRJ2VmQk9PELyoYI4rqhnFqrkNRE
	 +eZUfj3YjybTTZN5JO661blh7+kSnrFuccsXZLWyfaFw4TAOHwnpDKUvczs0V1zYzS
	 j1+9h6bgp+Vbw==
Date: Thu, 15 Oct 2026 14:23:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 01/28] arm64/sysreg: Add the nVM field to
 PMBLIMITR_EL1
Message-ID: <atDOmDNrAwLNC8_h@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-2-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-2-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:05:56PM +0100, Alexandru Elisei wrote:
> Define PMBLIMITR_EL1.nVM, to be used by KVM.

I see that is defined in [0].

>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

LGTM, matches the hardware spec and in line with other entries in the file,
so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/tools/sysreg | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 94bf065c8ac7..a11a968eb707 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3106,7 +3106,9 @@ EndSysreg
>
>  Sysreg	PMBLIMITR_EL1	3	0	9	10	0
>  Field	63:12	LIMIT
> -Res0	11:6
> +Res0	11:8

I can see from the diagram in the field descriptions section of [0] that 11->8
is res0...

> +Field	7	nVM

...and nVM is defined at bit 7...

> +Res0	6

...and res0 is at 6.

>  Field	5	PMFZ
>  Res0	4:3
>  Enum	2:1	FM

I also confirmed the existing fields are all correct too.

> --
> 2.43.0
>
>

--
Cheers, Lorenzo

[0]:https://support.arm.com/documentation/ddi0601/2026-09/AArch64-Registers/PMBLIMITR-EL1--Profiling-Buffer-Limit-Address-Register?lang=en

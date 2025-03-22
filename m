Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AAB1D63F8
	for <kvmarm@lists.linux.dev>; Sat, 22 Mar 2025 11:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742642883; cv=none; b=oM/cUBzIyDN/1K7foK8j3BdKGjbnyKDuTf1DznQbo/xzVvgmJw6Hd3EsOI4P84jhuVW+crc/bLtgW11D2y1C3uuo9/kyTGvMgt44wzE/OBKTUI9bnKqNMmjDWwRpIGYI79OPo6V2038DsrhpBRbVa1L/B5h2AZlFvn28vs7mIf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742642883; c=relaxed/simple;
	bh=0Pgi3i8yV0h20KBVFyzaF5PYmWazpZcpnf0txiuiGVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQ7L3rt3kDzPs70+4Pnc1WW1l6PLvBnVe/1HHgLDosIVU0sk+gff7IQty3lIGM96PIUjru1kDzU0I7Y0N6PokYtX3FBSHjEpPmHQ03znR960egRwQutBoIg1VywvjuYEg5z6CPJzsMYVONM+ESm8WvwhW3nc9BMjQx5DfWI3WA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TX2eRdgq; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TX2eRdgq"
Date: Sat, 22 Mar 2025 12:27:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742642879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OIOHPwdS2grkXZETZCyBEn9eNoWFlgKvyBxcmW/d7eY=;
	b=TX2eRdgq+l0TsCN5s39NiZc06KTANgjhVcFJedxZSWkLsjpBI7ng69B4RjPhLemSC6oa9l
	OviWqHItjrA9wlDiIuL0YbNkI2mH+Ohrb/VbShzMx3QBsyND9yaZzCaHRglAobvTe6IerF
	nZ/rEzmt49Ge/AV9brs1ZqMIV3xxhto=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] arm64: Use -cpu max as the default
 for TCG
Message-ID: <20250322-c669034d2100a75ab6e53882@orel>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-7-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314154904.3946484-7-jean-philippe@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 14, 2025 at 03:49:05PM +0000, Jean-Philippe Brucker wrote:
> In order to test all the latest features, default to "max" as the QEMU
> CPU type on arm64.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  arm/run | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/run b/arm/run
> index 561bafab..84232e28 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -45,7 +45,7 @@ if [ -z "$qemu_cpu" ]; then
>  			qemu_cpu+=",aarch64=off"
>  		fi
>  	elif [ "$ARCH" = "arm64" ]; then
> -		qemu_cpu="cortex-a57"
> +		qemu_cpu="max"
>  	else
>  		qemu_cpu="cortex-a15"

arm should also be able to default to 'max', right?

Thanks,
drew

>  	fi
> -- 
> 2.48.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B511E50E
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 12:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753966781; cv=none; b=QxVZNWg3mJxUHF9W8NqNUT6uGQayF9Ocz2a1JuAwugipkQh99bLSGwRFzlGpHiD8F8NA58ImDNdmTtKOHMpTlxd99dk2n3ED+L7W8zeaCg29UdennBiuel3jEtKkjiy3CnxWrPX5Nmx1IqMuCb/rm0ZqCbCVU9DYVf61UxaF7Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753966781; c=relaxed/simple;
	bh=OlwkJhUnVJSu0YQjxc1gQQ/f9ockLl7IL62ObEbC2yc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=mrBLJl63Sxq/jPv5tWJ3iveGtIz4ttk5LyXQL1gVEQRl6enEhua0CiLFnz7PuLFNe/hpj6hFgo2acFKl2HY4dU9mHOdWOPRKstUnYEOSNdrXXyC2zHFD09mRzOydrlabiLVpxxbfcNScWndgRtaYCfK6Qs4yjeLvDJvqmR4Rwmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xr+ARsGs; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xr+ARsGs"
Message-ID: <4a807c89-d57b-463a-9166-836301ee9947@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753966774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NH9FRiynBWmz+TuFtsldRHKl2P9Mf6GV3/ecDf9SulU=;
	b=xr+ARsGs90n+e4EJB2/aZZS3nAn0zrVWNbDfG6INi30wDzIw055GiHjsWFEJByRMfgqySw
	da8aMglDu+wCSn2Bv1HgLAb6f70bUY5JjTm/PYR2HWwdzlxONXV81GGWPL0a3LZ7gCM9M9
	AT7dE1spfAR2xHi8+H8xZxDcABzdCOU=
Date: Thu, 31 Jul 2025 20:58:44 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] KVM: arm64: Dump instruction on hyp panic
Content-Language: en-US
To: Mostafa Saleh <smostafa@google.com>
References: <20250717234744.2254371-1-smostafa@google.com>
 <20250717234744.2254371-2-smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kunwu Chan <kunwu.chan@linux.dev>
In-Reply-To: <20250717234744.2254371-2-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Mostafa,
On 2025/7/18 07:47, Mostafa Saleh wrote:

... ....

> +	/* Dump the faulting instruction */
> +	if (!is_protected_kvm_enabled() ||
> +	    IS_ENABLED(CONFIG_NVHE_EL2_DEBUG))
> +		dump_instr(panic_addr + kaslr_offset());
> +
This part seem like unnecessary, cause it'll be remove in patch 2(Only 
the comment left).

>   	/*
>   	 * Hyp has panicked and we're going to handle that by panicking the
>   	 * kernel. The kernel offset will be revealed in the panic so we're
Another confusion is that no similar wording to what you mentioned in 
the cover—specifically "Cannot dump pKVM nVHE stacktrace: 
!CONFIG_PROTECTED_NVHE_STACKTRACE"—has been found in the code.


-- 
Thanks,
        Kunwu Chan.


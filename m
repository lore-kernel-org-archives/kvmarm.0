Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC6837F745
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753199; cv=none; b=Oszg535FoMyosUBHe8zkLXwVL+jKjOV238hNkBftXIFcP3Fx7JtGNIV+OoBWLLck5lYijXWvWmhZKQp+wsl1eS69gydltygcAPdiGJjLfA6lo2lfmkM1NFcNsHBiNwQnt9xBTVS4smea4/eNoaWMnb7QCD1IhKLubFtVF7XG6lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753199; c=relaxed/simple;
	bh=mQbaH5tI+IruZWucS8AJeU4qoJiDpkOvFU79qqUCJGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2FYomL1eBAFuk/0m1yW70BDHbq2/XMtXu/1dswS+rpMRmtSmfMX6A8Xfs4FLt9dP48Bs08c61AdCzcMDgBSIjCwW3ZwoHVvNC9FdT/U1JqAWjJQElffacbYI5d+YrVM4TXboTPN1w4itPEl/ZsiZ+W+D4QcvBpPGIGpjTjE8lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G6eWP3Hb; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G6eWP3Hb"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f84023916so3230783f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785753196; x=1786357996; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kW6C1+4rNhE+0PMn+ucH4K3CUSEGpMH1odrzmczVGFM=;
        b=G6eWP3Hb+dlf5g+c/S3u1TR9NX9928IaF0Xs9dOjR40PcGndqeFRFczX6VQ9e5M8ox
         uMKOeuqI1L1RyZ+rfuRifUH+6+Qgyc1DWQMm1AmgUxcm5RC5JWswlzngqjX7S7ZAseos
         xFTSpVx8lp//eKQ13jMX5Fn/w/fEoxfNDKvxYkPUH5FQ6ZWkmmEaBhdbfnfE5Jbh236M
         U5gMuOGk4+kqcrPnBnuy5DjVVPBffXm2I+oQtAbKYk7ZTIJ7nAZunaOx03n/CUJ6qfHC
         7ejwBzqDBVd4mZenArGbA9dpIxkS0mumi2R5GT0e9kCRTgnvI1CrM5MgF2LHR/8W1dak
         +/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785753196; x=1786357996;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kW6C1+4rNhE+0PMn+ucH4K3CUSEGpMH1odrzmczVGFM=;
        b=SYzG0Nevn3NzYYT0Lc4orWLRXrQrMX/d+nNkFupIFl2pm4WB0jnRTEAu6Uo/IYCJt0
         M04W6iFJUWY07A5lGUBgja17C3xwxldHZrTMVUQqhp5HBQBlLy0Frk1KpF7QL4eGcPp5
         uzBlufTcZ3+P5NsDDZyIb/s6CecR6RldW4x1/RMxB8zpCOF7hC9TwrmWSEyHQX8xDCBO
         d6KVi8D0xN5yuG1ZHBd18vMXNUKxguPYy5dy7vKVlisuaNv6wVeKeVws497pCjlkT3Pn
         3Relr9yzsbdeAjfnTvMdZ+Ynj3TSznK3JczetWngQLYYoSiejKWYkL2qvlN5RDd5AV/f
         5J8g==
X-Forwarded-Encrypted: i=1; AHgh+Rrb2Pl5srRTBvQUDZ3mkjy2H0924zlyQX0M7SCnocvVLj2OD9W6nJt5bM9Uc43Y+3cmRMEpib4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyN7gxz5v9e9sIM+VUTflLrLgowv01/R2RUL7x2/wmeNZ8R+1Vo
	yj3czV3lov+jyv23Wthv8tmTA9XZX0A9vyslYJY/oC9kK5/X+7zC/5ssWOXrEwU7lg==
X-Gm-Gg: AR+sD131ozjTrOBVgqsDbTrvg+1DKOd6E3vRG94kxhVlKHpgY3mbpGq0qbEsQC5D5HG
	NiboL8s+BxQyYdkXD+jOE+r0HyxbdbsguJkIJnMt7GG9tTcCVxp5mTccWAVE7xpaxgJcJyCemen
	uC1BgnGRDGanwwJjKRyCfabTSmYqMyLLBegkMONYSaOwkjzDRMK55AqvZlJRECB1Qa1I641Dop9
	raXzF/rDrfKH2mNM2qM4WoOoCym+TpQrxNvc4oiIWXKyVMRZR1ECAyrxbAnEeNjG/isId7b8q+y
	l9+VHItM9IInNNc8G+CuBI5iMSmZYaLh69KfzsKUKf2TRBWnJ6c6/kGAU6t81cRr18CeS0SVMZr
	6RZh6A6JvagNmm9cEKVtmgIYG6D1LPHzzbC/DLRGXH6XkXRjigLGwy6gut57FFF/5JR+KWicKPO
	Y+xTvqmtdpDXVa3GmlYhuY8nRqftwdXqYNP74VZjhQIuDQKOil0g9CvWLGqGdI6M974G2Qo7ha3
	ZtlsU7hvLSf785Wdrs++OrJ36ksKC2f/PTC5+TUIDln
X-Received: by 2002:a05:600c:8711:b0:495:52a5:8829 with SMTP id 5b1f17b1804b1-4980c652515mr253557695e9.11.1785753195960;
        Mon, 03 Aug 2026 03:33:15 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b5f007sm209718545e9.6.2026.08.03.03.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 03:33:15 -0700 (PDT)
Date: Mon, 3 Aug 2026 11:33:11 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, alexandru.elisei@arm.com,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, qperret@google.com, ardb@kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	tabba@google.com
Subject: Re: [PATCH v1 03/11] KVM: arm64: nVHE: Declare the hyp event IDs
 before defining them
Message-ID: <anBuZwkjDQKRKVlr@google.com>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
 <20260720161343.1367007-4-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720161343.1367007-4-fuad.tabba@linux.dev>

On Mon, Jul 20, 2026 at 05:13:35PM +0100, Fuad Tabba wrote:
> The defining expansion of HYP_EVENT() in events.c is the first time
> its translation unit meets hyp_event_id_<name>, so sparse suggests
> making the symbols static. Include kvm_hypevents.h ahead of
> define_events.h so the extern declarations come first, as with the
> tracepoint headers.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/events.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/events.c b/arch/arm64/kvm/hyp/nvhe/events.c
> index add9383aadb5a..b845be0acd117 100644
> --- a/arch/arm64/kvm/hyp/nvhe/events.c
> +++ b/arch/arm64/kvm/hyp/nvhe/events.c
> @@ -7,6 +7,8 @@
>  #include <nvhe/mm.h>
>  #include <nvhe/trace.h>
>  
> +#include <asm/kvm_hypevents.h>
> +
>  #include <nvhe/define_events.h>
>  
>  int __tracing_enable_event(unsigned short id, bool enable)
> -- 
> 2.39.5
> 

-- 
Vincent

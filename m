Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6426B377AA9
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753322; cv=none; b=acZKb8QdosSt+XxMy0vyrF8PH8S/L0GXSVkYMHFOU0Ue+Ngy8VH0FXsBjTAiiy4YaP5BxnHLYcsRKZmVPdHmpHOyfUOQMqahfSYEsgLae5SoKmz1Vp8WYY1rK/xc5spFAJo1o3wk3/AsglA8wZDHbjHWXPtYoHEhZ9+rB5h/Q8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753322; c=relaxed/simple;
	bh=yeRlqgHQZa3hz5Qaq/3RS+NfWQ9WCl04KKECFw2GoZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZvw8bljOQiXTY9OvKmyiQFu+39Lju2D9Re0+gaeXvM7azJ+eLQhG0n10cFcKC8aOTc50NWAJLPLTXc3K05uf9rHkoFXKKmHHETKyVYyE/WMCAGnlwFjIR0d6xGlDnU0ajAC0f4RyNTHd0NDypkwVEHo7wCkeV3b3ixrv0F5DDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dsf2a86C; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dsf2a86C"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f633e6058so3043691f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785753319; x=1786358119; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FRWZR/aXzNRtlaANjzO2S5r0yF9L37fVJhN+JbqqSaQ=;
        b=Dsf2a86CzDASZd/eRknLK/ABmamVAGSMgIGdjqPUnh+JxjBW8ytWpN7T1k0/tk+YH6
         Z7K2+U5sHD9uKplwPI5XVoM5wN2yKerLUorGW2mMw+i5fe6eY78zrXKCrZ0gd5DrhXlw
         qSkJvDObSNt+HwP74Fhjp9RrYRSqeKwDMFw80f+MvLInFXSXbqgHg2+Q+Xft41jtEYkp
         2jAdk3nB85+76eDDbDQ8Rp79ix5ySH6ecea+8Yh9PhS2pgKW63lDWrSr6N/peroht3R8
         VznK+WZvVOgNAzVMM7VzO37V+K4Y9FHDVu9ZPYAjbOOlwPyuTvxhxY5ziP9hIyal56Oz
         insg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785753319; x=1786358119;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FRWZR/aXzNRtlaANjzO2S5r0yF9L37fVJhN+JbqqSaQ=;
        b=eduDMiq2X+luy0qbPHpxQETPFaqaw68jAENbdeiACAbYGiO5b7nwE6aX/+xumEPWsc
         T/Rawz2BQw3F3lY1SwhiFuzkKrd986n3nXLyLTLpIqVnTeg6lqmvFqs+zU3vQ9pTEMIn
         ZtA+jbD675st/MyUOLlXD741HDr7SdXIFWxuNCOz6shrkNmsPut6MIHiQ+9IjJxXYyE1
         witvc7/ryRso12kqW27X//J/mvGFmlpAUCBm5Z2b8qNcY04h7M4GUQp6w56B7KJgepNj
         CJ5mHSFrF8VlZghx+ZUpNyZxzsrxUetUlP4tYMiI2iXhyiaMFqnZwSSnk7RsRC4rB4qf
         QS3Q==
X-Forwarded-Encrypted: i=1; AHgh+RpAAXfth6LXmK/9qoMZGmLfDS76b/zr1RJc9k+wf9E5t1YSEOEOGcahF+N/rxOXv7m7QkAqMV0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtUAzlFQp7nT1A7ig5f7vVT5NtRfwlflsnYIX2wkM7QzSohRz9
	jd+hPuqFn2/2Ponyvv8VPggaNEJAQcScGSLVXu3ABcfmPaDtJM6lsI76uLKW1dAX5Q==
X-Gm-Gg: AR+sD10ty86Sqxz8468I2AVB5mTV1evuzBvBxWLtogi0jTCbMXYspoHkYDZuH95xPY4
	ebiaw5G7cwdHyJTvIMIgt3rPL5S9kSun1SNuTEcIspHlZvffb8oAZ/52PRKPcwC4H/KnqKzk6v6
	HuKbYCYS86Ttg4RkToOOBkstAOyykdANCGi1sdg9M7tc0+a94f+XJ5QGkz05Oy1+oIcMAaIhEe+
	Tn/GAkbzBM0InSdouBIO/5TAZH5jV4zF0J3kNYvFaKqPtkVqxD3bSelCeoNn93JShXlk/+CCysw
	Ey5MwmZVluVSdhfqzIOH+2ha2tNn8vaMDfan2Z1dNu8T7bD0XSdM/KJ/k8W+NMfvY1CZ6d6sWpr
	HyD/svWJ7tOlPTqtulG1tKln5nWMwH39ISgFzY++SkXXMQ8koMegBww/nmCt1hd0eBDD0P3Ml8P
	7VKaQZgDOVmhtNz4UMYRlpy+DDIWoErJ5H+dWtNqWhTskJ2qW5LDjAfdXN+rpmW4PzUtxDRS/sL
	TKc0NAJxFwTxTpppmweKtS0E1LSl9/F
X-Received: by 2002:a05:6000:471a:b0:47f:ddc0:602a with SMTP id ffacd0b85a97d-47fddc06087mr15422708f8f.18.1785753299369;
        Mon, 03 Aug 2026 03:34:59 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41d1a58sm31650490f8f.7.2026.08.03.03.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 03:34:58 -0700 (PDT)
Date: Mon, 3 Aug 2026 11:34:55 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, alexandru.elisei@arm.com,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, qperret@google.com, ardb@kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	tabba@google.com
Subject: Re: [PATCH v1 04/11] KVM: arm64: nVHE: Use NULL to reset the trace
 buffer backing pointer
Message-ID: <anBuzx3c2MJgLF8c@google.com>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
 <20260720161343.1367007-5-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720161343.1367007-5-fuad.tabba@linux.dev>

On Mon, Jul 20, 2026 at 05:13:36PM +0100, Fuad Tabba wrote:
> bpages_backing_start is a pointer; resetting it to plain 0 triggers a
> sparse warning.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Probably missed this when modifying the type for bpages_backing_start.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
> index e7e150ab265ff..177fe3d8fbb13 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> @@ -93,7 +93,7 @@ static void hyp_trace_buffer_unload_bpage_backing(struct hyp_trace_buffer *trace
>  
>  	__release_host_mem(start, size);
>  
> -	trace_buffer->bpages_backing_start = 0;
> +	trace_buffer->bpages_backing_start = NULL;
>  	trace_buffer->bpages_backing_size = 0;
>  }
>  
> -- 
> 2.39.5
> 

-- 
Vincent

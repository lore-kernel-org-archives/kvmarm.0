Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE7F242D88
	for <kvmarm@lists.linux.dev>; Sat, 15 Aug 2026 13:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786799266; cv=none; b=SENLWCK4eYHAlBq3fKjDhvJbzyEnYS9V3NyXj+JUHHZlb/rMukDlkk7ja8CQmBPjoH+TlYLpFe2b+M+inAW5GJPp8+KUHZcC82cITRAygvIcro0QF3XzP/yrXtcADGqxClJS23ONQpIHY3/YHSr1k/Vx8jGAEqDW36v8KqvBbuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786799266; c=relaxed/simple;
	bh=0jndbey5Pvjf3v9MX03JkuXQsBTNP/XZ6T3cuUpF9wc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RiB6an9fHqXpllM2RnaiPUXMqzGBoNG0xPRcJDVel+MKBguBFsbHPHnl/L9xPzzic9bDGnCCVQinCNtDXLd9MSLn4gEU44dGO7Ac8jLLNkSedJI9GQuQZQ3WvQPDXu35a5ue0ol5y5XZ1YvnFJ+l2rZX9GoouFakd4ANDcoUkHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O80q31eV; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O80q31eV"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4956242332dso19940785e9.2
        for <kvmarm@lists.linux.dev>; Sat, 15 Aug 2026 06:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786799262; x=1787404062; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2daFPoDS4/53WEkckbjnmN8AXIA4cD/WTxo7tO7xRQI=;
        b=O80q31eVI5GBVOSCVZyEVGKmJ6o/7Cakyom58DCZHBseTOH/GeA8iuuoV84yTxuJoV
         0EeAMzZ2KWQ3lmjpAgbmaZ7uf+Og2yWdDoiguZdY7RhD9JgJS9wMW/lABQMM/afFuWEg
         XJ4zt2rExgtWlgm0k/d9bFwenfM4Y/G0jE0KP/m9Q1D1TNBPIMyF05dtdsQ0v2mxWv5m
         9UN6EgYZJeeUXV2ZkNGaBAVf8kieCSMpEqX32vTt3RLESaBoa+ioUx5iAlv+C3Gt7yo/
         tmkQWHyOJLrtS4INIGhUhrc9o+bagWCBxQmr2JjSZvsyzGUB3njepF2Oq8IwwPw4+oCC
         z9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786799262; x=1787404062;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2daFPoDS4/53WEkckbjnmN8AXIA4cD/WTxo7tO7xRQI=;
        b=Owh/tECa1kHYnQzxCFX2+0CuklLm3Ql3HUy44mby+Gd5J63wguWZ4kXpRd01xBy3X5
         OGdY99dCnHAgxoMDA8kI9g0I+Gp6MHtIOzrckKPzn4JiK64Eznocv6Pe/Z3tYDXrvC65
         QIgxHpvyVMsXrib3QHjdOm3YSmnX79q2JzfLRCAfYuqCGe78KL7EvKvJHVmbUJvh5Y5N
         jsaEzFf/bE8Tbd0GWbusXtfJ4iJc3HstesJ8JtdlisKKxiy2qEuaQkevxC7ItfHRMOe4
         juhOFfy5N5tvhArAiQzLFV4zkqUuYxCylt/3myrek9ovgarfbxQV9gQNNcozajxd1HIv
         Gvkg==
X-Forwarded-Encrypted: i=1; AHgh+Rq5mbQKairgepzvmwYIIcsFLocIXvS5C1p4OzWHGhHmk6eomgYj8oaNNZB7diH/9svSnsiE0u0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2OpZPzzSJd/8g5hLjpVofjPdkZFdQMclZd5gdjNOcKnLZ7QCb
	B3a+f7VWGSxs2J5N4FiLGg3JcGrEwXKHNrTWIeA5n7+v/t1DpTE5M5zl
X-Gm-Gg: AR+sD13tF64p81Py107DrykNFZEDm0ufSQHIf/IPNsNDeGElDjZPWennqZqYXP7XG77
	FQOYpDKdg+vlv9tUrDF3+BPfwkK83KF8IrB/wB2iEh9y24JzEzU7iTW08mWBZCixLJ3JQXNlXPK
	NY2SPY4wVJpLwVM/5M8WKDclHXf/Cf3lptctWVcOxueJKRH6EPcO9DetoGS50EwAKMYdaFN5EMy
	W9B8V0ojiRylAHW1e8FCwSyGmhnuqgDN3IHOfyrSeawcQ4F0FVJUat0fsIu6ucJ9bBT8H68XEat
	Ho+15HSUzo7QCrXS7WKJ5UckPsA6T8p919TZAyYYpNFaoFU5lmWzy8jorgNTRd9dxdACldmqek/
	XbB5tUocUGOU5Bet42gU3riMxeyV5bVyQ7QmYLBURGX9M66lCqJoUa+O2XstDB2oB6jT/v88Q3n
	IXcy2QiVYPLL3NVpBr/NcL12TE2r+Om2FCZH7uCSjEnx9pDK4YmMwdInw5EqWqZRc/lYWYdIcUN
	9cYERvOwYPcvS/oQnoxOuaM0jKdgI1f3FsyzIIzuyrkTI7pvhT5ASsccGWkcOek5EU/wna/mrTu
	mbAwdwdgNWW37/v8IFh9IFbQT0S3VN+R+ojcvqszla9gfunsyl/8UjXRSO9mTaPUuw==
X-Received: by 2002:a05:600c:3b8f:b0:495:4491:b8c2 with SMTP id 5b1f17b1804b1-499906ce446mr55403245e9.3.1786799261853;
        Sat, 15 Aug 2026 06:07:41 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-aecb-d601-fc34-eb31-14a1-3704.310.pool.telefonica.de. [2a02:3100:aecb:d601:fc34:eb31:14a1:3704])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49988b1d33asm146700145e9.10.2026.08.15.06.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 06:07:40 -0700 (PDT)
Date: Sat, 15 Aug 2026 15:07:38 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, 
	Sascha Bischoff <sascha.bischoff@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Cameron <jic23@kernel.org>, Timothy Hayes <timothy.hayes@arm.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: KVM: Fix the GICv5 KVM_IRQ_LINE PPI range
Message-ID: <aoBhU6XIarXxeQYB@gmail.com>
References: <20260815092537.31737-1-kmehltretter@gmail.com>
 <86wltrzm5n.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wltrzm5n.wl-maz@kernel.org>

On Sat, Aug 15, 2026 at 11:57:24AM +0100, Marc Zyngier wrote:
> > +	       in-kernel GICv5: PPI, irq_id between 0 and 63 (incl.), and
> 
> No. Please understand the difference between *implementation* and
> *architecture*.

Got it. That distinction could perhaps be clearer in api.rst, but 0-127
is intentional, not a missed doc update.

> > +      Userspace must query this attribute after initializing the VGIC with
> > +      KVM_DEV_ARM_VGIC_CTRL_INIT.
> > +
> 
> Must? Why? Userspace can perfectly live with ever querying this.

Hah, yes. I meant "if you query this, you must do so after init
to get anything other than zero"

Please consider this patch withdrawn.

Thanks,
Karl

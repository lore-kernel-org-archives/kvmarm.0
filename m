Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D1B2989BF
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 15:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765554101; cv=none; b=S+59SSt3l1nOeyOekAtt1B5NC42KVffS/0+Xau8WbUdELTu9e5JJcwG+GX9YgBJ9atLlOuLObLgnhI4oGD/bypudEPvzeeQzOB1EDLADfOHahOBnjIMscVHWbjqooipu5XkRtULodv1Pdvj7LwbZs6QTekMiMoDhd7q1qs7x8WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765554101; c=relaxed/simple;
	bh=DXvytcOpbGo1jKvvdjOi6minbJGrWLE9ozhpxKSuBGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4kgpW5qUykqfVkuJ8a+yf19IUS5u0IzdAu0ALYNdlHvlkvRhprMopEw/nn1QU21k+oLdaAmETeFDjZwxACe31bdNo4d35aEgt6GAP9CgYi1/4wVCi5e0VzEZGKKA6uun527vJXT5pHRiSLL6hkS65/aCNkinoKn0Ot637kAbbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fLk+FYZB; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fLk+FYZB"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so165875e9.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 07:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765554098; x=1766158898; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yb0mpDrVWWr4Uchsh7e1JfdRTz6GJRCuX0Lg98K6TFs=;
        b=fLk+FYZBV0r6hDDC2QRuyKZWYawIVprIeA5M56oR/7EWg7TaeGkjFJi3ecG/xGF/kJ
         aORqJbpe/Cy1Hp6pmM6ToTd8Ealm1s17UzkmP68MqR4QaSSBLPiMJp+JdK/xmLWhrT/Z
         LBPB8g/+5Bb9OfgEx/vTA6xlTEdab62HJrQmNYculUmEm7XvLfJ/iuM4d96lWMpeRvBd
         1KK5jO9vyL9eu1/uJ/ZzUZm3zARSa9ummHoobrKjwUA9BeRtc2Q3wINN7XS7VELlzzTw
         HapYQll/5J+dEyYa9mudK1bMQiYqeEnWNRlhHOUQ2pC8mf2gJVt3sqDVIvx3SSR1ssnL
         nt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765554098; x=1766158898;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yb0mpDrVWWr4Uchsh7e1JfdRTz6GJRCuX0Lg98K6TFs=;
        b=P3+jfX4yHUBqml7OnVbCX+TD0B+OsaOR85f+7t1a1P4pFLaK8v41CC/j9coSjvUJHL
         ablHEWyUMSf8ffTb7OS6yNliw+K61CVLBz/KNLpYL6WvxEXMtU6YPp17rjyBNgOfvtrf
         ZruSj+INhJanfc1VDsureGEx05I3qsfWvxRwRgSVkhS70K/3Tclm8Rf/B9jQFvA/f0+I
         DJimM+EDwku8oSti3BNZw8ecJV1qMXaND8gVSURH/jpTfxev1wxmMmNXHx4+jT/cwiUF
         7zeXcf7NoLvCUxlKrEuz2Tgv0VeqA4Tigt8fnwxmj54z8KQGi8hM15RaR0ibRAEFf+x5
         jd6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUkAmxUiIw27gQX0tq10W1HTiBPTmHTDg90e1cpVhdE2iQS58lAjMH09UVlxkP7yhUbX5DApKc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcHn+n/vPVNkDN3N6yFFYCLwOD12ETam8VxP9rjcCizMxyzzES
	l0KbgdoCqgtqZocDe8m1eOe5vZk8uble2K6k2DWwkclfn0KuomuUkd+fZpeE5Ru24A==
X-Gm-Gg: AY/fxX5H6Rsyb+F898aY8aRRR98zHEphuTFIxixYJyCSgBGlrGvOdHQe76DFI7XLVzm
	COup+D/CsYcS0Ng5hejwvbZLxL3KDVpvfjBvkZBx19i5hU80ELMGYJK3Qln93V7hSM99JKzSjzU
	AVyBvcnYBZPgPcJiHNXC/Wfjd8vZgZrSJxbPhA1gfIgipTw4Lf3bJONF7X6/xgFrU1ATRiB/eHz
	XUXj7unQs+k1A25sHukery5o5bRZ+q5bZ+A+SwNm4zLx2r6H7U/7uRPxoOTTL/jDCoak4Ce3rGL
	X3DyY1El8fgC2/y0SOJhg6O8MJaKheo5pOmSTmIV+HyHg6yBhg5mwYDN0PgjdmXG9cTicWB+WMk
	jE/AsLT+ZwzoHSmDUvKCjYUnlRdEVIdSTq5iGlzxiPxvE0K2Z5upAxkKb45XV7ZTCGPxcT/0QKv
	0Ju0fI4b0LEGkSSas/Fe5IZw0I5Fps9fuaV9M7X7hAXBHF4iwFVg==
X-Google-Smtp-Source: AGHT+IE8Wx434r/TRdblX8cNOSB3Il2X+1GmWAuGcjE2WU7i1xwbelBfzCA/D0WahfUc0XUl/gS5rw==
X-Received: by 2002:a05:600c:8885:b0:477:2f6f:44db with SMTP id 5b1f17b1804b1-47a8980f38emr1011225e9.5.1765554097506;
        Fri, 12 Dec 2025 07:41:37 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f49da20sm36628515e9.5.2025.12.12.07.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:41:36 -0800 (PST)
Date: Fri, 12 Dec 2025 15:41:33 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Split code with hyp
Message-ID: <aTw3rS1Pp-Iqq7yU@google.com>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-6-smostafa@google.com>
 <20251128164655.GB812105@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251128164655.GB812105@ziepe.ca>

On Fri, Nov 28, 2025 at 12:46:55PM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 17, 2025 at 06:47:52PM +0000, Mostafa Saleh wrote:
> > The KVM SMMUv3 driver would re-use some of the cmdq code inside
> > the hypervisor, move these functions to a new common c file that
> > is shared between the host kernel and the hypervisor.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
> >  .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  | 114 +++++++++++++
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 161 ------------------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  61 +++++++
> 
> I would think these inlines should go in some -common.h instead of
> arm-smmu-v3.h for better clarity, and ideally pkvm stuff does not
> include arm-smmu-v3.h at all?

My thought was that we use “arm-smmu-v3.h” to avoid moving a lot of
code and messing up the git history, but I have no strong opinion,
splitting is fine also.

Thanks,
Mostafa

> 
> Jason

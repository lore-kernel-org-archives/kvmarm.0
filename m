Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDF723742
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 12:39:49 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3226cc3e324so9892140f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 05:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695818388; x=1696423188; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bTA1Nn/9nJiqE2dp6IAJC+LQ+4ngnD0zddI0+KHWMMU=;
        b=RPaIss2i8PNQy52Rhwhjyju0/I5S6hPcjS++/EHlXVpi+XgLQHiRSfbM1GS1aJMMuF
         mrpMcPvAB0Z1U/eDXNvY0Lkb96BFTcaRdZd81SLS0ZdSijQXV1nKpSGz8o4iDuNuDOy8
         25hRlwMsoaEdZGdHGSjUxh54mFIqXCdwodBAT1M87Q+rqz+zW/cA0JRHARTZcb7N7Tlf
         Ofh7IbX5hfju3Y3G64VmOXKrLYFtfsGetkGH/zTgc3SkkA7scKMBFEenUniOH2RDe0Z4
         iMjUFWUyovIoIESfUNJlCsp+Gacx6JHIh89wVDvkw2rAUMRCEEqn/Z4GRq3h/+7F+7aX
         912w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695818388; x=1696423188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bTA1Nn/9nJiqE2dp6IAJC+LQ+4ngnD0zddI0+KHWMMU=;
        b=SwvEoEBDYtU8M8NX/0asH/CwjI6075TmKkA9Z0qk+Q6ee1WBXjlB7QqcIDGp25nPfp
         SzXKPO+MxmggkFi0UQR7O7PgE8zw8n30CGsP59fNDYJyNUIxEwDRIFGStLIfX81c1mgo
         /YAKQs8jWb9hg2EkIEZvV7PzTxoRg4ZlB3JUzdN51LlrXOffY0W2uEuX/d6udrfs+Epl
         gFVcnbJQKD+GnAXwPvhJFHqPGaa3YKRsBlq3h+amcFaiTE0FBrgIBq2ZFITvThyeE8jc
         MHlg7S7VHsOnrGdgqDEw+zhYOCcaHW21BgCeAHhD5vcBzVxjlejthCwKJWQLlb26aljt
         Tlfg==
X-Gm-Message-State: AOJu0YzdyTnJvPJq+pJV4b99OEWbpO2Y0MEkfekkc/YzC8fElpxElYZC
	uiNL3zbI7McHnOShRP439VbAKA==
X-Google-Smtp-Source: AGHT+IFOfZDsaU2Wgb3xBaiFul+bsaxW9mNk2PdMLIdYcGcI0xasbJngjJZ+HmHKLZ1uS0jKT6rkIw==
X-Received: by 2002:a5d:67cd:0:b0:31a:e73f:3fe7 with SMTP id n13-20020a5d67cd000000b0031ae73f3fe7mr1853788wrw.3.1695818387830;
        Wed, 27 Sep 2023 05:39:47 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id h4-20020a056000000400b0031aef72a021sm17254092wrx.86.2023.09.27.05.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 05:39:47 -0700 (PDT)
Date: Wed, 27 Sep 2023 13:39:39 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
	will@kernel.org, willy@infradead.org
Subject: Re: [PATCH v1 0/2] KVM: arm64: Use folio for THP support
Message-ID: <ZRQii9II1zGJF4vw@google.com>
References: <20230926181932.1650692-1-vdonnefort@google.com>
 <ZRPMEFvQ-bt4rPDQ@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRPMEFvQ-bt4rPDQ@linux.dev>

On Wed, Sep 27, 2023 at 06:30:40AM +0000, Oliver Upton wrote:
> Vincent,
> 
> On Tue, Sep 26, 2023 at 07:19:30PM +0100, Vincent Donnefort wrote:
> > With the introduction of folios for transparent huge pages [1], we
> > can rely on this support to identify if a page is backed by a huge one,
> > saving a page table walk.
> 
> Better yet, this gets rid of a particular walk that has had some rather
> hairy bugs in the past :)
> 
> > [1] https://lkml.kernel.org/r/20220504182857.4013401-3-willy@infradead.org
> 
> nit: for the sake of posterity, it might be good to stick a reference to
> commit cb196ee1ef39 ("mm/huge_memory: convert do_huge_pmd_anonymous_page()
> to use vma_alloc_folio()") in the changelogs.

I'll add that reference in the following version.

> 
> -- 
> Thanks,
> Oliver

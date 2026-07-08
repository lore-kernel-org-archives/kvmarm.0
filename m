Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E963115AF
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 07:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783496642; cv=none; b=lMr09N23NCvplsVq8R0nMAtHvnK1Qk72qOXShFcC3T6EP+/aGG48fkS0k2e9piRAU0BnHGOL3hPpJVdNYAmA9TZLw3CkBvGYJyRpxVbFDS8qrrjDv/m8OpDCaaALLLns3YGwb2BRVCnlQGxXxKRNSaIDRIwMWC7mVLY6jtGNho4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783496642; c=relaxed/simple;
	bh=YU1TUKrNRfp8ojTfZTb63dnHOLC15tLJTvRpWDB2FPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/OKuCBGAXT47VFfglAquWOkovRi07f7SvMfy78BtsgJSFpB3rSOLVFFJscIySMgiPTokbvhMNjnm19AY2duK5rzg6bRHbbKuG1oSJCbS7ej+K/vnThLJIJ51c1gB17RrnyARvnu9UTOodihme0dXtzDqmQRL2Is627VfQPOlOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bp+SB2I4; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bp+SB2I4"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so309159f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 00:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783496629; x=1784101429; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n82prq6kBMNM74HC3u8a/YGx7R3skaf4VOdGW85odhg=;
        b=bp+SB2I4nvUaE3qRpPC9OT3lLxE6hpDNX2WwxXpCLVqbPFvGY4J3Gk00K3ClOYATLn
         5dNrrAOH//jzqeosqBzA6LFqonymk+wm91ALEKxo1KtZIjQ9qt5CDUvX8tuWrg9Qv+UG
         axBte0OK5l5Ui7K185iwzRByGXduushKRfC2nI9SrfRE4i4PGLKfvcdAtseGEkuXujEd
         Ga217PB63YUgvYhczxEbIjW//jQ1jj8nIXqVG8USWtcN4PNRq3TfuvFAoUarOwJVaDWA
         15mPCzTm60TdwnigN/GA13Agdj8pThvwGPAMhQ55jsIkr+vCht/DRsDC70ESE8hizArL
         O3WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783496629; x=1784101429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n82prq6kBMNM74HC3u8a/YGx7R3skaf4VOdGW85odhg=;
        b=hLaNyNYjX22LgC+jZC5QFjGpJA6Gpyl29nEo5/QGTtQdYsJ8eor2BYph1O7jwJYSIB
         mFKiQVg/XRnUFOY9hV34jEySmv1XQXFySdZFs6mKpEq/8VDDruOnt8W4wUDPA7PreYxi
         nkeiQ0obgaP/YLojbJW8HCLBrJzJhm9XSAn33shTAqr0ijtqGfxp4q/54i6t2slpqKqK
         3V3weHlabCBpII4ffxvWMZE4xjWdkVV1e4xi2xk0E64dk9kPo+v962UQN42s6jDAJeSc
         wPw7UnzLXJMMFNpZvGMOdv0+h/G/7+TufY4PBChR2aN52wK+qMbSGAtKY9ync6fWh/Q9
         8/pQ==
X-Forwarded-Encrypted: i=1; AHgh+RrEDFo8DPt0SDLUNSu+O2iaDoViYLD0lcDcSBCMDFNRfYl8LsU1DVLromZIbWA+bFuhZYWXXbA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzECHmCjCk6vOwApJZzDyNebPSRlzxOMkGWZGmoCqZhRIYCf9J7
	o+wZPDcyVmvIyaMpRGV0SY5FN7n5h1PKrAn1DesnbpuGXi2UC+CnCXk6kBb9RjHo4A==
X-Gm-Gg: AfdE7clkDqqZQK6woBCcNyyG8Xh1m1KaIkqhA4Isaycezn4+90CxD2BkqI1MN0cUjf9
	81CAlsvUMBU3lMQCI2UVmEEVjPtpvkyLRbboSb0dCfONw2D4kAWqtaoEmLRhPbv9IO2VqGMGnC2
	pI3+kvx0+P96Syl0HA3B1EWUlmtDkyp1zP2RHwk81NYaK3N00bLcts2RxgcGyddwXtHX88bVilM
	HXqPN3jSfFGubuU8m9uSEgKwxrm4v6ZzovG/1wFvgsPIv48aIN/mHDQ7QK2uoqo6gPflhYd/2Qs
	hLsqAqvYvDQ4doeQsW2AHjODstm1r5Jf0oebeVsgip7XmjDSaRSWaTlqx4gGnvK6JNKY0YTTD34
	4V/plhejuFGpr0z4d+I4pc9T1NvKKZ52sAfHhssIaQMKCYoMuSZuDPQHVng0jV4aELbS6cWg/+Q
	9ynkIlC96HuxnZXBQxE7VorlsVUmFt27GxVuunIrq7hnUgX9ci+okIxvUF9XZK+g==
X-Received: by 2002:a05:6000:290b:b0:47d:e50f:94d with SMTP id ffacd0b85a97d-47df073b177mr1317865f8f.11.1783496628970;
        Wed, 08 Jul 2026 00:43:48 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960af0sm37239696f8f.30.2026.07.08.00.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 00:43:48 -0700 (PDT)
Date: Wed, 8 Jul 2026 08:43:44 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix potential leak in
 hyp_trace_buffer_alloc_bpages_backing
Message-ID: <ak3_sKu616ZZBdYL@google.com>
References: <20260707165029.3410701-1-vdonnefort@google.com>
 <CA+EHjTx7C7BEmyoZgx6-PWvfAHpP8AWMOefTdwOQjw8NrPhLNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTx7C7BEmyoZgx6-PWvfAHpP8AWMOefTdwOQjw8NrPhLNQ@mail.gmail.com>

On Tue, Jul 07, 2026 at 07:32:44PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Tue, 7 Jul 2026 at 17:50, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > In the very unlikely event of a failure in __map_hyp, the allocated
> > backing pages are leaked in hyp_trace_buffer_alloc_bpages_backing(). Fix
> > this by freeing the pages on error.
> >
> > Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index 2411b4c32932..5fbbfd40376f 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> > @@ -160,6 +160,7 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
> >         int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
> >         size_t backing_size;
> >         void *start;
> > +       int ret;
> >
> >         backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
> >                                   num_possible_cpus());
> > @@ -171,7 +172,11 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
> >         trace_buffer->desc->bpages_backing_start = (unsigned long)start;
> >         trace_buffer->desc->bpages_backing_size = backing_size;
> >
> > -       return __map_hyp(start, backing_size);
> > +       ret = __map_hyp(start, backing_size);
> > +       if (ret)
> > +               free_pages_exact(start, backing_size);
> > +
> > +       return ret;
> >  }
> 
> nit: would be a bit cleaner to do move the desc assignment to after
> the check. Also, I think sashiko found another real bug, don't think
> it's serious but worth fixing.

Ha yes good point.

For the other bug, I saw it but that will be for the tracing ML

> 
> That said...
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Thanks

> 
> Cheers,
> /fuad
> 
> >
> >  static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
> >
> > base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
> > --
> > 2.55.0.rc2.803.g1fd1e6609c-goog
> >

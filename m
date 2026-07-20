Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CEA37E5FD
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 19:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784574188; cv=none; b=SxYcSrMURG+x6xvY3FZvVCkGQwQv2sN4bnb2MDhkXZ3kh0RzEDL1F0sdlc81+smV9iz6ZDpooe3ffMf2bTbHLin8mYKpzw+/oBdY2Fu6gyySVr8eM6vPbd60aP9yDSe9wju6Fh/U+MkZGIB92vshnJhhW2T4IWiXYmsXpu+HLfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784574188; c=relaxed/simple;
	bh=npO40HNu6G7vNoWH/xfhYoxvUV+rD3YxcTBJYjQ/ikQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYdcXkFTZb+bQ1pur5IrWGV2jgQzZFKOqp8k8owNKW+0+7h4hCT5ebls/GdoOAHUMMcE6Q4ukvi+KvQDN7glYbEfIqogH46IpAuW09VfkQlG7fYi6X3NT3mn/YPhDXBYMXkEf87Q5/j71CR1x0dKioI73ZngrgGtRxvzZMpAzpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LSWCMRtS; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LSWCMRtS"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so14206805e9.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 12:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784574184; x=1785178984; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ADiUitgJtlg1qZ/LHubhQUG1lGSN9jDviGJhaJgAv74=;
        b=LSWCMRtSYyFSvW+sDZ5yOAtX/rulF2JxRMAv+iL6MzcKrEb9mkAhHcW/PkDwsK4Rvu
         DEMR3dhhruCwtQVDFpEfVM980y3jIAJ+ZrBpBB8uKx2g6ZkM/SAruVr49lUSXqclpkhx
         piSv2k0EMwhmCtLkod7M3MX0y8gS8Lo2kYfELutEbS7y9Nb1QNfrZ56grF/dfZtMLNY6
         wNgg+vshE0GpYOYP3zfN3T8O98xxvT8GfGCNQHUaGjz1Fqc0jGemJJ83wkDCyhwfnax4
         9o9vAuzaS7kfdhV5kQfqerAEnW5ww9YkVym3TJFvBAyZo0MHhDflQ1/1oV7Gc93MO0vs
         aoHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784574184; x=1785178984;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ADiUitgJtlg1qZ/LHubhQUG1lGSN9jDviGJhaJgAv74=;
        b=q2Xh0IUn4t7+5ymijM5B7FQ2mujYN9EfK1yiHFTdUKxdc4cssnbeV6VxSjlZnsxbmh
         nj2wVx8pSFNBxYPBZWWEpTF8QJtTuqzgrk841UMyYI0nBGHBkLIJccKXBMLcWzBdkQUV
         WvU5rUhGRtu689hEKkCtu6sCf0RB95JWPZ8V+aJ2QeyjTgAXXvmXQ+is38Jtw+FsRdVL
         irf1tktMimGkUvgLAJNJVQhw2PA9CjRaH8NT7zXMVaid0OjGEnN4IfLG4utsLH1XsbUa
         ftk2uyaw/vEKnNQ0eWWebvkRl4oxuU3p8ZvdBgaJlKXr+LMqmBdD+4QV6Ieo1+MaMNqg
         KkpA==
X-Forwarded-Encrypted: i=1; AHgh+RoXwrimYTlD9IPny3tB0+INib8wdE6Ge6BVXpxBfqD6EtJpbvgSc8kUoNgrR3yqLmPozTnk9uY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxg3rnn3LFsvea7A34cLAw5T5AF2IYrUPJQW0fvb8O6IjdZgfuX
	k1EzBfUWRVMJ2oaoiBeXn/UgbVwBlTyodNaipimhWrebjD/Pqz5IgvEzOP9vjF16ng==
X-Gm-Gg: AfdE7cmsMBJeji/+OQLBeG5rAw1P1PtrY39eNcPDpzqPPNGrfNaXo0SOfKZV+jjt7Vo
	4eN1hUu5JtAlpEk7BB8MXh2ZNnolduQQL2Ie3ptX8Zr9JmzLOxS+L5wIJfg9WK8DtD+nf+UZYsu
	+Zoqd+GB0zp29pMDPAZrnwYgsEUdeRVlNCLJHai4faVicJp+tFRR4FvyqQlmabsOKrGm3PJuwEP
	Z9X2LgeoRYEVqZl+P7NdCAZQ/uVVxeEeTsQJFJP0PIPmyDOV8vtsnbC35e8LzO5EZWDyCr45sGd
	E+y2v3E+yUHV+jm2vWpAyEjVuhA1zB9S8Xi/TylBZnIVJtdEF6sGgDCMY9fYSmHlGZXn3e6G6Pn
	XHdtyhUzVkgZGBfFWWP99pkEQfQiZr+tzvEds0GCyLNa4RzuesVN47gFF7umepVwfsvbhW5idbz
	0EFo/JWEYeqHc5Wzn33K/9hvnCQgr+ClLv0eEbdU1F
X-Received: by 2002:a05:600c:3114:b0:493:f278:ba2f with SMTP id 5b1f17b1804b1-4954a3ed46bmr179664585e9.9.1784574183734;
        Mon, 20 Jul 2026 12:03:03 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956537c6besm9428245e9.8.2026.07.20.12.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:03:03 -0700 (PDT)
Date: Mon, 20 Jul 2026 20:02:59 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-kernel@vger.kernel.org, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Stop the hyp trace clock worker on disable
Message-ID: <al5w4wn9ZhPsZYUR@google.com>
References: <20260720184850.1826630-1-fuad.tabba@linux.dev>
 <al5wo9x7oUGzlbTo@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al5wo9x7oUGzlbTo@google.com>

On Mon, Jul 20, 2026 at 08:01:55PM +0100, Vincent Donnefort wrote:
> On Mon, Jul 20, 2026 at 07:48:50PM +0100, Fuad Tabba wrote:
> > When disabling, hyp_trace_clock_enable() cancels the clock work but then
> > falls through into the enable path, which re-schedules it and marks the
> > clock running again, so the worker never stops. Return once the work is
> > cancelled.
> > 
> > Fixes: b22888917fa41 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://lore.kernel.org/all/20260720172923.E4F161F000E9@smtp.kernel.org/
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> Done here already https://lore.kernel.org/all/alczBmnItMwq8xj4@google.com/

sorry I meant here:

https://lore.kernel.org/all/20260715105100.3178255-1-vdonnefort@google.com/


> 
> > ---
> >  arch/arm64/kvm/hyp_trace.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index 2411b4c32932c..27367843fd211 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> > @@ -116,6 +116,7 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
> >  	if (!enable) {
> >  		cancel_delayed_work_sync(&hyp_clock->work);
> >  		hyp_clock->running = false;
> > +		return;
> >  	}
> >  
> >  	ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
> > 
> > base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
> > -- 
> > 2.39.5
> > 

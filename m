Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47D448AE0C
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778081016; cv=none; b=eJbp9zpi4BSomB6w3PyD6EjUw+jq3lmYredB63tsWs0wTlVHvBgBF/bqfZ8YH6Ql4mBxntZSmAu8qTu6bapjfurvO2hgdVK3jonUnoif3KmNhAjjDAgLcSWg0U4ie7dGVZ8E0RYpKXrJZgM4dCFOrjPpS6wWFmcy83+JaDPSC+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778081016; c=relaxed/simple;
	bh=VG2/sxvDjWN0rZSNS6U6OvyRizkEs6ISsawgP8gZVvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AEji2c3bYyuQAPi4XiZSvyWqnSa8hkIo5stmwm0CqN8i9PubUrhV5ejHPZjzEb1i0LrBCoZ4gWeEv6J2VPW41Y3F2DaooqaQogC6HXA6njrTd8RSaIggMugxHCRztY/gqB4bfkPjHIPRKxulFKN/bDpVhroIasKS+4IBhT/JSfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wfyd8C8J; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wfyd8C8J"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488af9fdaa7so34960565e9.1
        for <kvmarm@lists.linux.dev>; Wed, 06 May 2026 08:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778081010; x=1778685810; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cTseNJ/2nD6TjREZvOS9tCHIBcGxqDugB7fH5uhKP20=;
        b=wfyd8C8J4611kGkq5yJFTeEKhX55PaUW4fD1LQYYWIN6m/2QGO1VDZlwwRPkZWRdGy
         EvJaeqj6DH3CN8R38s6xnPlsGLVqjfco8srBjIXAigacjO+ApScohFJGs/+tR6b0FuNt
         HCmI7QG9TpJpZLEjj3BzwJxF9n/tLiMpWmtN7brhzgGWKhDDz3gMfhlRsSqTU4P9pqgj
         PsEPzbeIl2F/xrXViwEiOf2sRdYZA6JN2Ns6VrE3gtkozjlJZV6EUVPm2N+NIj/liutT
         K9xwzXCBzUyXIA5OzuLqftkTnRX6HbzKKrCgTraq+D/SyJp9QiC3YhpKDkdxHHbtN3ns
         51ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778081010; x=1778685810;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cTseNJ/2nD6TjREZvOS9tCHIBcGxqDugB7fH5uhKP20=;
        b=VqGvKI0fvT3RxUlrwHcluk9dvBMy8H76+4/xFqXscXElmkCc09UlBLsE5BgSjpI3Yj
         SeJFu2tYt6RmdCEnZSERx9d1h6R1WAfv+w/Nqg/rSBmkw6ryd/jevDPlPUREnmrE2KaL
         JsEohcPjAc2hXV0zFAWOzpR+X4xHQ38kqbx/6SftNR/XwEQzR4VmWhROZNUd24wSXLex
         oD90TXKdztSp8ckPoP+7o3hqFrvQWwBUiOpsFfORe/uCgcIoNy5c65IiUXwkicbzC6RJ
         LxJXNkTak9bY8BnbjPYr2/3XSMg3EJ+WjeFE3AP52td9bJBmXouaXt1XB8u/h2z2lkxZ
         fx0A==
X-Forwarded-Encrypted: i=1; AFNElJ9AAGypXm7+kQVtwHk81gfRmXDSF18mz9esAogJrNmo0wAkIvtUYYpXMT0HSlvK+gvIF3EiDq4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwsYSKotf/Y8WzAL0aS3l/ahDHyhNos/Sfr77vZxh8QPw69cS0J
	tZBoXe1m01zdkv4iGJ08QMwROuaiiJojNXhvStx5rpMT41yP6t33lXwaVTbPYxEp1A==
X-Gm-Gg: AeBDietwhi1e1w/9sjrZuBaER5+5MrjWfjzy8kTiRvCO0hNT/ADRsOgGNvyDpAkxE2t
	hpCv1ilsuqwMXsdqebT1RbFaeohPHVRMfDmW7WRYPEI3pk4lot3Tf14Dt1yTAYuTy0q6+qwumA4
	w/PXr8YRqeETuaLeSvnXAA3jjNdXRILY0lYjp24Gw5U2B7hNLwKcG9nj2WLJcyG3PXke5vkAi2C
	zwzNdZH8ki0yroJFgCarRPOwC2L/NbFJ3FIArk+3GgzxDLuCQUFtWL9GLwzuYTsHjoLVeZmhx2V
	rOrijO6i8Q2UkuOB04RqthunfeiY+kUEvf9PvOBLnzLfLzok+3swXPRS4i1JJpJs5Uy5YsEEHoJ
	vtXN4z9tJVzvljt/2FOqSgNUQSBusDTOCWbchKvkTiqShKkTbAIf4Usi8QgUajgb0nrUF32Ywi5
	nifAogvvuuz7YC+1p0oRH7P9SQpi1CUQmP+nHozzxqz1ZVkKJsN6BleiAIJCuDkTpndECJyfpFd
	NMYzL1+AP4HqMA1
X-Received: by 2002:a05:600d:10:b0:489:a4:e555 with SMTP id 5b1f17b1804b1-48e51f36fc6mr55916045e9.21.1778081009725;
        Wed, 06 May 2026 08:23:29 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e538acf23sm52766815e9.8.2026.05.06.08.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 08:23:29 -0700 (PDT)
Date: Wed, 6 May 2026 16:23:26 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Harden clock for nvhe/pKVM
Message-ID: <aftc7n_-43ozFFbl@google.com>
References: <20260430103724.2151625-1-smostafa@google.com>
 <aftYT7BY_9ZdGxmA@google.com>
 <CAFgf54o7pGrtBY1mHuptnCNrRSGVPU=WHW=Qf5v+wGL6Gum-Dg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFgf54o7pGrtBY1mHuptnCNrRSGVPU=WHW=Qf5v+wGL6Gum-Dg@mail.gmail.com>

On Wed, May 06, 2026 at 04:10:20PM +0100, Mostafa Saleh wrote:
> On Wed, May 6, 2026 at 4:03 PM Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > On Thu, Apr 30, 2026 at 10:37:24AM +0000, Mostafa Saleh wrote:
> > > Sashiko(locally) reports possiblity of division by zero and
> > > out-of-bounds bitwise shift in trace_clock_update().
> > >
> > > Although the clock update is untrusted, we should at least have some
> > > basic checks to avoid the clock value getting out of sync if the host
> > > is buggy.

> >
> > I am not sure about the gain here. The host can still write values that will
> > make it out of sync anyway.
> >
> > The timestamp is ultimately fed and read by the host.
> >
> 
> This is not about having the clock in sync, but to avoid executing
> undefined behavior, such as division by zero or large shifts in cases
> if the host is buggy and not malicious.
> That was reported by Sashiko
> https://sashiko.dev/#/patchset/20260501111928.259252-1-smostafa%40google.com
> 
> Thanks,
> Mostafa

I would then reword that to make it clear it just prevents the host triggering
UB on the hypervisor. It doesn't really harden much, which is fine because that
data isn't relevant for the hypervisor.

Other than that:

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> 
> > >
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/clock.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
> > > index 32fc4313fe43..a7fc61976fd0 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/clock.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> > > @@ -35,6 +35,9 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
> > >       struct clock_data *clock = &trace_clock_data;
> > >       u64 bank = clock->cur ^ 1;
> > >
> > > +     if (!mult || shift >= 64)
> > > +             return;
> > > +
> > >       clock->data[bank].mult                  = mult;
> > >       clock->data[bank].shift                 = shift;
> > >       clock->data[bank].epoch_ns              = epoch_ns;
> > > --
> > > 2.54.0.545.g6539524ca2-goog
> > >

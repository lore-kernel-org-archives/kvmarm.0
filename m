Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF2D2DCF55
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784574288; cv=none; b=i1odkOfAr19R9W5QRb3chfdXc2QqKMopjdtIQ1H+Nt1UxKwlCt4cZhlwnHV3lz0qjSL3sxhEoLR259u3xgXF6fAdhUL4Sy1E/IMKz+7QH27CcoAlrbu3I47W5FZQugiE/bYwbjm8beXKDuh8Ozutg4zwmFXQR5sIhJbdgyg9g5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784574288; c=relaxed/simple;
	bh=dDG2LUTCIl+Bhgsm8XEc3ENucK8nev35VLJ+bqwTSpM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jBW9iWUu7gr1bXTONaL0FTLxSlO8gEwX4rw2nQV4hT91aSnFdSzy7wWCegU68BNjX38uA28B0ub+DCQ31wyRnj6hhcRbhjXJWlr+IYv1pXb5KEHwzKFYLcvMBW51jLYP6XLJlqcMVEDvkhRSOpxFpUsQktxQdv8s1ufaqNEeou0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UWNMU0Mp; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UWNMU0Mp"
X-Forwarded-Encrypted: i=1; AHgh+RpG79pwWV1p5hKH12pAJ8RzeO9r/UQqY+dUUMmEqcTxo8G1LOsDy86zb5xxg3Qp/fwqJsKBaJE=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784574284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4oc02UGdmLh31pih6zb2K/J1p4iSYx2HWoGM19eKbs=;
	b=UWNMU0Mp1mAKLF5w9p5oKMypeVCWxnZuMryJa5p6S1WcgQCJ4Lb5ufcJ959oSSgk6Kew+J
	oG72SLmtg6CdqmLAU3ghhfFkZDVXkFHUCHwHQAZ+tVtCOUKhVnK7rUTjzn2wmYJ7pIpkpC
	iQDdnktzo4WLRjBLjx8TDHj5gv0BzPs=
X-Gm-Message-State: AOJu0Yxm0NPfmwPgactm0RSoRZrtcG931HH+cjHcmpfJ8s9EzTkr8I9I
	v/wiXiCAVuAJfzs0KVPWHuFUSLsd8mB7QztwvwT1XQVO/mZCd1nhBUDQ0rfO1uisMSrSAHWoj8E
	KxljY0mjvV1kXyDCoQGDoYiz7XEMkrTk+FAeBeIa9
X-Received: by 2002:a05:622a:4a8d:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-5260069a309mr4824311cf.8.1784574280611; Mon, 20 Jul 2026
 12:04:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720184850.1826630-1-fuad.tabba@linux.dev>
 <al5wo9x7oUGzlbTo@google.com> <al5w4wn9ZhPsZYUR@google.com>
In-Reply-To: <al5w4wn9ZhPsZYUR@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 20 Jul 2026 20:04:03 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzbOcc0UpHYLCHzQyxWw7M2H0XaF_wcUBG=-xHqkezmPg@mail.gmail.com>
X-Gm-Features: AUfX_mwYfsJH3aB_tIRpzbGB-1UW5fTmJ9nimOTrdWhssuMgPDA252YmMYMb4GI
Message-ID: <CA+EHjTzbOcc0UpHYLCHzQyxWw7M2H0XaF_wcUBG=-xHqkezmPg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Stop the hyp trace clock worker on disable
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 20:03, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Mon, Jul 20, 2026 at 08:01:55PM +0100, Vincent Donnefort wrote:
> > On Mon, Jul 20, 2026 at 07:48:50PM +0100, Fuad Tabba wrote:
> > > When disabling, hyp_trace_clock_enable() cancels the clock work but then
> > > falls through into the enable path, which re-schedules it and marks the
> > > clock running again, so the worker never stops. Return once the work is
> > > cancelled.
> > >
> > > Fixes: b22888917fa41 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
> > > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > > Closes: https://lore.kernel.org/all/20260720172923.E4F161F000E9@smtp.kernel.org/
> > > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> >
> > Done here already https://lore.kernel.org/all/alczBmnItMwq8xj4@google.com/
>
> sorry I meant here:
>
> https://lore.kernel.org/all/20260715105100.3178255-1-vdonnefort@google.com/

Thanks, and sorry for the noise!
/fuad

>
>
> >
> > > ---
> > >  arch/arm64/kvm/hyp_trace.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > > index 2411b4c32932c..27367843fd211 100644
> > > --- a/arch/arm64/kvm/hyp_trace.c
> > > +++ b/arch/arm64/kvm/hyp_trace.c
> > > @@ -116,6 +116,7 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
> > >     if (!enable) {
> > >             cancel_delayed_work_sync(&hyp_clock->work);
> > >             hyp_clock->running = false;
> > > +           return;
> > >     }
> > >
> > >     ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
> > >
> > > base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
> > > --
> > > 2.39.5
> > >

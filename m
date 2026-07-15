Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D93339CD06
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 07:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784099601; cv=none; b=RBdUBeMk3E9CeFXZurHxNjQry7+fsPvp52r0Hexwa7slDqIAlJNvyuPRiGLmQwZ6Skxoj4QCCFcd4uTXrW9/WvlbNSuxt26nCOnXr1jEzRuRodNofk+MlWtvmEkCY/DL/0fN4MMJLkLqAfsovx6fDfo75I4/JrFsrKyZ5mQ5rO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784099601; c=relaxed/simple;
	bh=Ku6P9QRglu+E034KtnOCYHZeFKRhJWCQ9QbD82KeJlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdkq24Dxbr0dJzBkPu+RlWKA0l/3LZBcHgwAPCfcIZ8dva/ze3N/EmkSmGf/VbSwk5Cz2OcthVvdMXgZVFX+pQIgZJTvH9yqRBvqZ9UBGdmAXzn0n3iJBP9HVuDxdZ43cdRxeLQu3z26Bq+elvZdbJrBwQuHcSJsjkRQjM8kay0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nUb59QGv; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nUb59QGv"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47de008b020so896700f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 00:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784099595; x=1784704395; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7TWJCe8c9GeM3I4YT4k3ddXa9j/tTy1QCp8SnYXd2v4=;
        b=nUb59QGvM3uL18aQ0PjMxl02Gpj0ZVtJfWny5DO5LVeL+gMVzpG7WSEKFEscbSl7qb
         7H7RnDLFMBdQi+C50+DIBf01n9CTf777T1jgrvBvhHxHJR0y+4brL5O9Udm0hgtn7Zy0
         B3uqiGRfmHi6+5qeNRU7eh7woBDXNh7Y9OavhkjxqrFDHOdcf2+F40TtQvI0FxYmHz8R
         eGTXF1m2c5ko7eVYRjXa4ig03bdh0sMUWpCOvWNKpcZUucOGh4tYj5fkzUG2oe3rDoNL
         Co782fEyevSKZ1PFBxxDzXGa8UXZGjJjuy+EPelLJ+5Ys4wZLIEyxkJj5Qrz5YJ2m7+V
         4bLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784099595; x=1784704395;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7TWJCe8c9GeM3I4YT4k3ddXa9j/tTy1QCp8SnYXd2v4=;
        b=oqf0PR3cAXjmSCOifP7zi5+/wYjmUtD5P6q1JwBpU9BMY2tMdkR0fN93So3SYh+RUc
         eyOHaOJV8q+2LHyPxCOWgNPYSJp9sUbZmRlpx3JFyRK6JO1Z9+Z2YAZvHMcFyuXW/Y0Q
         FAltESoG5Ank+Z+jC3CD/JE0thfLPty7k2TwPJ3OfGXVUV3C5cUuIWRBibByT/Owv8f5
         Ay78uZQDKz5VzszE+f9/o5yWiLBPR0PGxXLPd6SPDUg1HS+FgGCtxZN2CB2HEewUkhEL
         yHAqzhvi0LBUI3BELdx/VeQBJIU1+ye/jk5TnNnyuOXQ8dUp+9qwFaqA19uv2D7zc4J/
         B9bQ==
X-Forwarded-Encrypted: i=1; AHgh+RrvC8ikVqopBs4fBEr/EZ1lKvthiwwU2I96778q+WhBs9ORXTJxjeX8SjLF0hBUuvSrKXYvxbk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxfi0STa+7yrlETkwoL2g8ZIIz/aWisSyRjMNFxtD4+9tEvB0Vf
	5890sE/BUGJwY+XPGCwQdZKEpnpMb8ABSKymrBGb9Yf0T8+g7o/1fw2/MCNPRh/MlQ==
X-Gm-Gg: AfdE7cnD9m288+mVmDaSXXO5lbWCVvyyL2afEqbUEmv/NbbwULniroZiLzgz/Qi6hXW
	wDxfjpA70rOhaudzfthy23cjTe+NE+NJ93Oiq4XYzlc/XLG/5O703RYiC1ZkO5Fv4QEGx/PD7HN
	/16KYb8cXYZ+rjpxa4Vd9/yrhAhMonFpvmddmQkowiwv8VXdb2fXTBrx/EpxvDmNBJawlhkhKCC
	tODI3AogkP0tNckyIqxsxbXWN0qI1ELZLOv3y45N53ZPmfdWi2RPafcaQDY2z9HNuFv3IFeVW8q
	jdES+Mzdff8xTNp/9pMoeVN70/lNX7WMmzTU8Yv83eDXubvB8RpugylB0mtTgwSngNpLxQ1HN4G
	YZ3C0UDo+khUbxnTQtLAQ7EjPyNOV3HlmvRl3nj4ign6bnZDdJjA1l3oAcBBBSMI8zyHCzKOHGO
	AquSLisSZDG49EjFR9G9/jZpJuompQg0ONKv4qnnwOWjVBnamCOeNWTzczSFdlwQ==
X-Received: by 2002:a05:6000:1acf:b0:47d:f6a5:1fbb with SMTP id ffacd0b85a97d-47f2dc934f5mr19483147f8f.13.1784099594702;
        Wed, 15 Jul 2026 00:13:14 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635082csm14635612f8f.7.2026.07.15.00.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 00:13:14 -0700 (PDT)
Date: Wed, 15 Jul 2026 08:13:10 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix hyp_trace clock disabling
Message-ID: <alczBmnItMwq8xj4@google.com>
References: <20260714181010.2527225-1-vdonnefort@google.com>
 <20260714182542.F33421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260714182542.F33421F000E9@smtp.kernel.org>

On Tue, Jul 14, 2026 at 06:25:42PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Missing cleanup in the error path of `hyp_trace_enable_tracing()` leaks the clock synchronization delayed work. Furthermore, this patch introduces a workqueue corruption if tracing is subsequently re-enabled.
> --
> 
> --- Patch [1]: [PATCH] KVM: arm64: Fix hyp_trace clock disabling ---
> commit c37a59b3ffe1e163385bedc8f21496d8af6fbc61
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Fix hyp_trace clock disabling
> 
> This commit fixes the disable path in hyp_trace_clock_enable() by returning
> early instead of re-initializing the clock. It also cleans up the unused
> lock and redundant running state from the clock structure.
> 
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index 2411b4c32932c..0b03117a38ecd 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> > @@ -37,8 +37,6 @@ static struct hyp_trace_clock {
> >  	u32			shift;
> >  	struct delayed_work	work;
> >  	struct completion	ready;
> > -	struct mutex		lock;
> > -	bool			running;
> >  } hyp_clock;
> 
> [ ... ]
> 
> > @@ -110,12 +108,9 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
> >  {
> >  	struct system_time_snapshot snap;
> >  
> > -	if (hyp_clock->running == enable)
> > -		return;
> > -
> >  	if (!enable) {
> >  		cancel_delayed_work_sync(&hyp_clock->work);
> > -		hyp_clock->running = false;
> > +		return;
> >  	}
> >  
> >  	ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
> > @@ -128,7 +123,6 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
> >  	INIT_DELAYED_WORK(&hyp_clock->work, __hyp_clock_work);
> 
> [Severity: Medium]
> Is it safe to remove the hyp_clock->running check above, considering how
> errors are handled in hyp_trace_enable_tracing()?
> 
> Looking at hyp_trace_enable_tracing(), if the hypercall fails, the error
> is propagated but the clock is not stopped:
> 
> static int hyp_trace_enable_tracing(bool enable, void *priv)
> {
> 	hyp_trace_clock_enable(&hyp_clock, enable);
> 
> 	return kvm_call_hyp_nvhe(__tracing_enable, enable);
> }
> 
> If the hypercall returns an error when enable is true, the user might
> try to enable tracing again. This would result in a second call to
> hyp_trace_clock_enable() with enable as true.

Sigh... Even though I don't believe this HVC can fail, it returns an error
nonetheless and I should handle the rollback properly here!

> 
> Without the running check returning early, the code will fall through and
> call INIT_DELAYED_WORK() on the already active hyp_clock->work item. Can
> this corrupt the workqueue list pointers?
> 
> Even though the hypercall might currently be prevented from failing due
> to the remote lock serialization, should we add a rollback to the error
> path in hyp_trace_enable_tracing() before dropping the running state check?
> 
> >  	schedule_delayed_work(&hyp_clock->work, msecs_to_jiffies(CLOCK_INIT_MS));
> >  	wait_for_completion(&hyp_clock->ready);
> > -	hyp_clock->running = true;
> >  }
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260714181010.2527225-1-vdonnefort@google.com?part=1

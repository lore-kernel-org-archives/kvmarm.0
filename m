Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BEF4779E
	for <kvmarm@lists.linux.dev>; Fri, 22 Mar 2024 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711117485; cv=none; b=HNxQ0cxtRTCu1zpolNsvue76qD9gWQdX5ayS5UX0gsI2E0rkZAhv1KAF+Kio4J+CYMEgTgPSWQx2GTWtKFKefuHm3FJL4HKvSnn+EGfmaeJqFcsaI4dEYcyyDvOIgW6nYR5wyao2QomXD1hXNSfr+hbaFZRPPuAQkx5224tWjZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711117485; c=relaxed/simple;
	bh=syPJCbEbMSsgWwjmffvYkDK0wMrVwE03bWzuwKneTX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lGyg/JyYu6L5lU5rmd/zQc0qtwmaWf6eFb1+ZGvaQT59qB7nDK1AGU/bMApP+e6r2mdfNmg0n1HoIy/DLHWtu/HXEJg3oEOY/IVJ3xNYK2XcmiMzQldpWK1fK0cu2fXMqo0FuvVmcmfucQfw6zuzCH6IaZCNgIoyJ/Mo+m28jwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J4V0qQ2e; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J4V0qQ2e"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56be0860060so990955a12.1
        for <kvmarm@lists.linux.dev>; Fri, 22 Mar 2024 07:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711117482; x=1711722282; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jpJ4vef/DM0XTXXII9U2wn8MVlRJg1M1abd5hGl+Ct4=;
        b=J4V0qQ2eK6AF9D1NsjPi3ZQhMyA40f3IZ2uCWye7XP4ZY7oVcKfVQ4F78z4K1J3oF+
         N+BbWNwqG8qngFcdnA0Tm7vjtg/CBzwduifqhLqJixJW2uzGd+GwXGpG6tJPMqFycv0P
         8gk9g+62/qglMKzEBLDQM14wnPozBI7+x0TVYDLr5jlTdcmv7pWznCtFIUzcfJ9j/VUr
         +yf7wwhtL191XAvevBW9xpGBFGmCOavTrU0WAloq+oWy31RALqMCmQo3iG9Pe7ue+pxv
         Fx5d+lQWXk+OmHtiZRJgGtJzh5dm6Aktm9QMI94ThRMjMCqOzna52B7Utis/rS1YQG0Q
         5DXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711117482; x=1711722282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpJ4vef/DM0XTXXII9U2wn8MVlRJg1M1abd5hGl+Ct4=;
        b=gJe9oZest5fB/uUYO0Xr7ZJutTT4AHJu3rIJCkeA2H4sNyq0wqv+sO41wbhIyaDk0A
         w0rx7P5yvimxnGpPZ/vImgMS+iHEyAZjrnydUa/1xtg31tNlGwFdjDvCqx7AGbMtnhEP
         XFHS1V7AE2oUNjwO9CqTnmlcL9+RzWU06UiA4VVFMRP5yOB8b2ymp3fwU2G0yV37aSz5
         Nrc7nyT6NLPMvnOZpGFkMpsgx92V/eAZOAfO/Xcr21nc5oN2cYLrcpesEGx1X/SCavLo
         P2lW31ac/uHIbRAUkov7KIvNS+kjdXocYJf8edGEqBxUC0k0xu6S8BBjzPoHz3HvkAEQ
         0MQA==
X-Forwarded-Encrypted: i=1; AJvYcCVaxBgAUgbYNuHp7eY98xu9qdoT7Y21WBL+5LISYdJphOk4vemculzL9jLZ6Iy1FZrJix78w7gUlQJWYlRf9TnyYZfM5m1z
X-Gm-Message-State: AOJu0YyGXgUqb451cf+s3/aNq4H/FfYgvnVT2426rW6oSEKT1ostl0zS
	TmSzinhL51HR8bLrOE9LRkY8qLD4LTjBOg4pa3yfM/vN4cTVd/6BJjhHiD58xA==
X-Google-Smtp-Source: AGHT+IHV7ZedVCo+7sdEER+uodJailEQLJUTasnzC10mtbi8r3xphXx/fdmPks0AX5p8D0JfI3tpTw==
X-Received: by 2002:a17:907:b9ce:b0:a46:af7d:28d3 with SMTP id xa14-20020a170907b9ce00b00a46af7d28d3mr1785337ejc.11.1711117481409;
        Fri, 22 Mar 2024 07:24:41 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id r16-20020a170906351000b00a46cddf1efbsm1065100eja.29.2024.03.22.07.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 07:24:40 -0700 (PDT)
Date: Fri, 22 Mar 2024 14:24:35 +0000
From: Quentin Perret <qperret@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Add KVM_CAP to control WFx trapping
Message-ID: <Zf2Uo1l0JgBEKRAL@google.com>
References: <20240319164341.1674863-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319164341.1674863-1-coltonlewis@google.com>

On Tuesday 19 Mar 2024 at 16:43:41 (+0000), Colton Lewis wrote:
> Add a KVM_CAP to control WFx (WFI or WFE) trapping based on scheduler
> runqueue depth. This is so they can be passed through if the runqueue
> is shallow or the CPU has support for direct interrupt injection. They
> may be always trapped by setting this value to 0. Technically this
> means traps will be cleared when the runqueue depth is 0, but that
> implies nothing is running anyway so there is no reason to care. The
> default value is 1 to preserve previous behavior before adding this
> option.

I recently discovered that this was enabled by default, but it's not
obvious to me everyone will want this enabled, so I'm in favour of
figuring out a way to turn it off (in fact we might want to make this
feature opt in as the status quo used to be to always trap).

There are a few potential issues I see with having this enabled:

 - a lone vcpu thread on a CPU will completely screw up the host
   scheduler's load tracking metrics if the vCPU actually spends a
   significant amount of time in WFI (the PELT signal will no longer
   be a good proxy for "how much CPU time does this task need");

 - the scheduler's decision will impact massively the behaviour of the
   vcpu task itself. Co-scheduling a task with a vcpu task (or not) will
   impact massively the perceived behaviour of the vcpu task in a way
   that is entirely unpredictable to the scheduler;

 - while the above problems might be OK for some users, I don't think
   this will always be true, e.g. when running on big.LITTLE systems the
   above sounds nightmare-ish;

 - the guest spending long periods of time in WFI prevents the host from
   being able to enter deeper idle states, which will impact power very
   negatively;

And probably a whole bunch of other things.

> Think about his option as a threshold. The instruction will be trapped
> if the runqueue depth is higher than the threshold.

So talking about the exact interface, I'm not sure exposing this to
userspace is really appropriate. The current rq depth is next to
impossible for userspace to control well.

My gut feeling tells me we might want to gate all of this on
PREEMPT_FULL instead, since PREEMPT_FULL is pretty much a way to say
"I'm willing to give up scheduler tracking accuracy to gain throughput
when I've got a task running alone on a CPU". Thoughts?

Thanks,
Quentin

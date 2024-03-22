Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787FA4643B
	for <kvmarm@lists.linux.dev>; Fri, 22 Mar 2024 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711118082; cv=none; b=cGSuYWDIZRf8lEy1svLukZyF41UgY2T5W1E5igrLuyKtZEWdnxqfXk2U/rfv8IsT8iGl7XdzWmV5gL2F3jr6EPthyp0KH2dCY4qQaJoE0Lns2zll2vfBLYU5/YT+g21YXLamyQB1N0ysykWttiL05XvUNsnE2aIwj0MkKtlgY5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711118082; c=relaxed/simple;
	bh=oQUQ9KkHO+Cn50yZmTu0a39sPxYSY6quGUNWqBxBzKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ci4GPyGnp+EAl4aNKMLdmXcIczvliKYTzbeIjdFoJ7n7c3Jz48mEt3JxHEchGNboJnUw6e8rgJjoCnVm2RzTEiTVyL068TaVU86jr31TAYUxlCG1RQ8CvZ1bkMbDLJvNx70XzFfeytT6nlVL8yvthO1FS3z68SPTOQg5+seV3Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sQhRFwav; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sQhRFwav"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a46cc947929so309802066b.1
        for <kvmarm@lists.linux.dev>; Fri, 22 Mar 2024 07:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711118079; x=1711722879; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HazYimjF8xR0j5uiuwvoaW7vTpuUwkSCXCP6Apf2dQs=;
        b=sQhRFwavIfgikcHWUVwqU+uIdCmWHCEPz8UOhmf6u5+RlFDlLrU+DdUe2AJYvTYwoz
         /cd6XI6L6SZhmZESqcf4g9Gn7K8VntMhA1imHfDcchNJJ96fZi7KyVLZVB3nNi5zqVaA
         Emk0dfnv2CzjWYKeRzdIFSMizT2+5SovnRYFPi6nQ63UR+O8mtlDyk7xcPzN7TUixmuD
         5ENKSmfwdfmAWdF4i1Sx57Wcd3/UTzXd7mM0fwnurGseqeNV+6DUvLw0tTEqTcrWZsVB
         gFGXoZTzPZd0Q9Y6dwfUiQCMmA0g0UYgrUIa/YFWCC+1tB2AUehRsp/hQ/2JiROtEmaO
         SUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711118079; x=1711722879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HazYimjF8xR0j5uiuwvoaW7vTpuUwkSCXCP6Apf2dQs=;
        b=pxBjhfAprxyn/bYhbNmg/tqZH4XM/naXbk2kOWjS63wn/xvctJvEQhoT0iwlFzyW2j
         rNzrWeBQd1GEtCACfbGN1PBIs/d3SbOzyCJU+Av4xRd/28I5RF7Ts3OI88zUHVaxq/Rw
         dpcVJ4pvGWYCt8C0Yvwde2/xJoAnH2ZSKCbkj4hOg6fc3LWHogAUWWPkQRRr5lKEaVzX
         81ut0yX8RZw0dubgW2sB3oWnw/p65Sh/Ii8+IBMGAq1Rx1eW0+lusQl2ZQeh4rwWcCCY
         INcRMtTWIZQG4EWbF23/CmW6LFa9XwSdCIb054zA2Pz28zz57ki/dqSzxpVQYB7yeEAW
         8tzA==
X-Forwarded-Encrypted: i=1; AJvYcCXChU5NA6hCrkLzC3ReQ3SOOosoAwAwysHvM+A6+s24UlrfnGpvgp7R4GzMxb0b/rKBNUpEeFohVXAxhAuXvTU5vu+lOb9k
X-Gm-Message-State: AOJu0Yw9VVwkjvK7COoSu+0iq5i6lmsgMZ+s5eAJMAzmbIM9BaF8A8So
	9h68qz3N65tZaO5F44U8SHrlVEETUKpibCDBxHfPZoCInByblrOsrR7ETiKavQ==
X-Google-Smtp-Source: AGHT+IGtReWAu4dOxnsh6dGzLvOkCiUJGth6MQj6uX9nKBz1cC9kFCHUfNkyYYI2Y/RW7tLAF1EQiw==
X-Received: by 2002:a17:907:8690:b0:a47:365f:647c with SMTP id qa16-20020a170907869000b00a47365f647cmr1103902ejc.0.1711118078581;
        Fri, 22 Mar 2024 07:34:38 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id jg4-20020a170907970400b00a4652efd795sm1085122ejc.83.2024.03.22.07.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 07:34:37 -0700 (PDT)
Date: Fri, 22 Mar 2024 14:34:35 +0000
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
Message-ID: <Zf2W-8duBlCk5LVm@google.com>
References: <20240319164341.1674863-1-coltonlewis@google.com>
 <Zf2Uo1l0JgBEKRAL@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf2Uo1l0JgBEKRAL@google.com>

On Friday 22 Mar 2024 at 14:24:35 (+0000), Quentin Perret wrote:
> On Tuesday 19 Mar 2024 at 16:43:41 (+0000), Colton Lewis wrote:
> > Add a KVM_CAP to control WFx (WFI or WFE) trapping based on scheduler
> > runqueue depth. This is so they can be passed through if the runqueue
> > is shallow or the CPU has support for direct interrupt injection. They
> > may be always trapped by setting this value to 0. Technically this
> > means traps will be cleared when the runqueue depth is 0, but that
> > implies nothing is running anyway so there is no reason to care. The
> > default value is 1 to preserve previous behavior before adding this
> > option.
> 
> I recently discovered that this was enabled by default, but it's not
> obvious to me everyone will want this enabled, so I'm in favour of
> figuring out a way to turn it off (in fact we might want to make this
> feature opt in as the status quo used to be to always trap).
> 
> There are a few potential issues I see with having this enabled:
> 
>  - a lone vcpu thread on a CPU will completely screw up the host
>    scheduler's load tracking metrics if the vCPU actually spends a
>    significant amount of time in WFI (the PELT signal will no longer
>    be a good proxy for "how much CPU time does this task need");
> 
>  - the scheduler's decision will impact massively the behaviour of the
>    vcpu task itself. Co-scheduling a task with a vcpu task (or not) will
>    impact massively the perceived behaviour of the vcpu task in a way
>    that is entirely unpredictable to the scheduler;
> 
>  - while the above problems might be OK for some users, I don't think
>    this will always be true, e.g. when running on big.LITTLE systems the
>    above sounds nightmare-ish;
> 
>  - the guest spending long periods of time in WFI prevents the host from
>    being able to enter deeper idle states, which will impact power very
>    negatively;
> 
> And probably a whole bunch of other things.
> 
> > Think about his option as a threshold. The instruction will be trapped
> > if the runqueue depth is higher than the threshold.
> 
> So talking about the exact interface, I'm not sure exposing this to
> userspace is really appropriate. The current rq depth is next to
> impossible for userspace to control well.
> 
> My gut feeling tells me we might want to gate all of this on
> PREEMPT_FULL instead, since PREEMPT_FULL is pretty much a way to say
> "I'm willing to give up scheduler tracking accuracy to gain throughput
> when I've got a task running alone on a CPU". Thoughts?

And obviously I meant s/PREEMPT_FULL/NOHZ_FULL, but hopefully that was
clear :-)

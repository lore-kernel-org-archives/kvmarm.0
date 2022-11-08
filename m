Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A93C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  8 Nov 2022 11:49:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04AC54B8C7;
	Tue,  8 Nov 2022 06:49:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PFPfJguqPgP3; Tue,  8 Nov 2022 06:49:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACBF54B875;
	Tue,  8 Nov 2022 06:49:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 285694B808
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 06:49:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n5N+pRm2kfHM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 06:49:40 -0500 (EST)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D92F44B7B5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 06:49:40 -0500 (EST)
Received: by mail-pg1-f178.google.com with SMTP id r18so13158531pgr.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Nov 2022 03:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=zfjKxjXUk1H8XvV8Joi7KrSFnmtiI6pTn2vr1B8zM+U=;
 b=BqUP7cf2VkeswKuK/Q76Q9SSNQ0qyv9NkFINWVV3RFyhGZsqVCcy3ekIipKPj6x1dr
 yxP8MFlaJ+WBY6dD7XPy82RD/wEVHkhif73yRTZbtPsxNheJMXaorL1/QoRhiGKfqa0h
 F4kzKKXeBsvx0OsW7FF37umqgGDj1gbKN8VJ3tgVLpCWKL1BrtjMU1PKqgKbqnD48F1u
 5QdpuLvi+dCbUSDWEyt2ILKxNCFpHhn83c4tt7xXUlkDSXn7TkoDOUTWGe24YHrWEv43
 zb+6pT8tS97Oy0EjMX8AwxkKnWD5Byz0JDWE7jHavUhBkiwiJNGqxl5ULMVk3Z95uh6p
 4mTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=zfjKxjXUk1H8XvV8Joi7KrSFnmtiI6pTn2vr1B8zM+U=;
 b=BxoGh0GIMBpdoeZxmhnXJfZ1YY9ywdmXoPotV8ExRJS26RtrXpY0hXNvExSe9pXPS8
 C9RN5Y4xgtqQnxeqsDZjihfgNDf+Nu6x5CC4pDmtIFzsunh+d3+W3xs1eOIiN6/+zOME
 bQllZ4w5WOGMhYyvo2KXZqAYXDcc0v4nfyms6cPwAEAKI9wBJ7h315Xyuk8OSH9gkAgg
 PqVgymIND1SZLBGJlmY2bUttUU6lMZ7aV+QMfmuTxzTkLIxrcgrtO2hEq19SiwJc1jVV
 BJV8qL7g8ZwTY7txS72C7vqgUl8yWYtNrIebAFqDPAjAYClCopQ6IJqdtHFmTWr43Z2t
 KxTg==
X-Gm-Message-State: ANoB5pmYaFvQvFB92u9vt2rqYOdRWLdnQtaJn0OneZ8Xidnmh1TMJ85W
 9U0e50+K+KER4C6CDyu9ZAT4ag==
X-Google-Smtp-Source: AA0mqf6vjDfIbDyVFeo3AvJ0KSgLGlwmsRKEpVVOPRuGdMbXRnbrm0st88ePvjQJeYvlXX5SXVgWWQ==
X-Received: by 2002:a63:4d52:0:b0:470:71df:a461 with SMTP id
 n18-20020a634d52000000b0047071dfa461mr10043218pgl.209.1667908179704; 
 Tue, 08 Nov 2022 03:49:39 -0800 (PST)
Received: from leoy-huanghe ([218.82.143.143])
 by smtp.gmail.com with ESMTPSA id
 d15-20020a17090a7bcf00b0020d51aefb82sm5933271pjl.19.2022.11.08.03.49.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Nov 2022 03:49:38 -0800 (PST)
Date: Tue, 8 Nov 2022 19:49:31 +0800
From: Leo Yan <leo.yan@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 3/3] perf arm64: Support virtual CPU ID for kvm-stat
Message-ID: <Y2pCS3gLqspzDgry@leoy-huanghe>
References: <20221105072311.8214-1-leo.yan@linaro.org>
 <20221105072311.8214-4-leo.yan@linaro.org>
 <868rkpr0mv.wl-maz@kernel.org> <Y2kabsQdddiX4G+O@leoy-huanghe.lan>
 <86y1smpyec.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86y1smpyec.wl-maz@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
 John Garry <john.garry@huawei.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
 Mike Leach <mike.leach@linaro.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, James Clark <james.clark@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Nov 07, 2022 at 03:39:07PM +0000, Marc Zyngier wrote:

[...]

> > > Please educate me: how useful is it to filter on a vcpu number across
> > > all VMs? What sense does it even make?
> > 
> > Now "perf kvm" tool is not sophisticated since it doesn't capture VMID
> > and virtual CPU ID together.
> 
> VMID is not a relevant indicator anyway, as it can change at any
> point.

Thanks for correction.  IIUC, VMID is not fixed for virtual machine, it
can be re-allocated after overflow.

> But that's only to show that everybody has a different view on
> what they need to collect. At which point, we need to provide an
> infrastructure for data extraction, and not the data itself.

Totally agree.

[...]

> > Option 3: As you suggested, I can bind KVM tracepoints with a eBPF
> > program and the eBPF program records perf events.
> > 
> > When I reviewed Arm64's kvm_entry / kvm_exit trace events, they don't
> > have vcpu context in the arguments, this means I need to add new trace
> > events for accessing "vcpu" context.
> 
> I'm not opposed to adding new trace{point,hook}s if you demonstrate
> that they are generic enough or will never need to evolve.
> 
> > 
> > Option 1 and 3 both need to add trace events; option 1 is more
> > straightforward solution and this is why it was choosed in current patch
> > set.
> > 
> > I recognized that I made a mistake, actually we can modify the trace
> > event's definition for kvm_entry / kvm_exit, note we only modify the
> > trace event's arguments, this will change the trace function's
> > definition but it will not break ABI (the format is exactly same for
> > the user space).  Below changes demonstrate what's my proposing:
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 94d33e296e10..16f6b61abfec 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -917,7 +917,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                 /**************************************************************
> >                  * Enter the guest
> >                  */
> > -               trace_kvm_entry(*vcpu_pc(vcpu));
> > +               trace_kvm_entry(vcpu);
> >                 guest_timing_enter_irqoff();
> >  
> >                 ret = kvm_arm_vcpu_enter_exit(vcpu);
> > diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> > index 33e4e7dd2719..9df4fd30093c 100644
> > --- a/arch/arm64/kvm/trace_arm.h
> > +++ b/arch/arm64/kvm/trace_arm.h
> > @@ -12,15 +12,15 @@
> >   * Tracepoints for entry/exit to guest
> >   */
> >  TRACE_EVENT(kvm_entry,
> > -       TP_PROTO(unsigned long vcpu_pc),
> > -       TP_ARGS(vcpu_pc),
> > +       TP_PROTO(struct kvm_vcpu *vcpu),
> > +       TP_ARGS(vcpu),
> >  
> >         TP_STRUCT__entry(
> >                 __field(        unsigned long,  vcpu_pc         )
> >         ),
> >  
> >         TP_fast_assign(
> > -               __entry->vcpu_pc                = vcpu_pc;
> > +               __entry->vcpu_pc                = *vcpu_pc(vcpu);
> >         ),
> >  
> >         TP_printk("PC: 0x%016lx", __entry->vcpu_pc)
> > 
> > Please let me know your opinion, if you don't object, I can move
> > forward with this approach.
> 
> I have no issue with this if this doesn't change anything else.

Thanks for confirmation.

> And if you can make use of this with a BPF program and get to the same
> result as your initial patch, then please submit it for inclusion in
> the kernel as an example. We can then point people to it next time
> this crop up (probably before Xmas).

Will do.

Just head up, if everything is going well, I will place the eBPF
program in the folder tools/perf/examples/bpf/, this can be easy for
integration and release with perf tool.

Thanks,
Leo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

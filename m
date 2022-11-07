Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF23C4332F
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 14:47:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07D2B4B89F;
	Mon,  7 Nov 2022 09:47:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o2j2I0Vbvj25; Mon,  7 Nov 2022 09:47:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BADD84B8A5;
	Mon,  7 Nov 2022 09:47:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E834B89F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 09:47:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9IrWDUPbz8ba for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 09:47:22 -0500 (EST)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57A864B877
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 09:47:22 -0500 (EST)
Received: by mail-pf1-f179.google.com with SMTP id b185so10818255pfb.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 06:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=/5c2uCvOxQ4QVOaWp4B05KhfDnp/A118lkPf9ZxjkfM=;
 b=BHWLwmctCDlaNT0qusEyo1UDPqVwY6BCsYN+ZkRNPDDaXx1xN/AjMeHydLIo6fGpzB
 RsnnM/cJknD6w0oYALVuMjiG7RICrDHv10jyhvtkBFHigvCl2Nh8LT5Ga9SYVWviWZhV
 bGIgRFl+AXoVNtdtAaMxC//pDkPCfJmv33laLHMPM1e/VU2wgB8fJMBCvv9whNuHOTl5
 dPrzOJRGSZFFDCzmVGYpY8FZY38iPJmD9Q3crEtM7J5y+Y/6d7cBMrEqZdWpjiKyixIs
 lRFa0oo1em2T0L2a7R9fB9+3x/a4z9FITnnlizMMueHJqhQqcyxXqDHANctriCoczZKl
 NPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=/5c2uCvOxQ4QVOaWp4B05KhfDnp/A118lkPf9ZxjkfM=;
 b=TuZ2aVIRJb3JPqd4V90sIZ2OgQCwSoRNgtuzVzcj90WUyPwxwtLGl+OlfWsTWOX81U
 /UVYay9sbxpechNymt+f5hPKxHkipUiXc6C4Mr95SPu9P+vfbIGhmzsCG1QDz/k+mlBW
 2Fbq6fAk6YTUkvfmNen1kXJ/2qVDBUlk13lvGTKfCWBNJB09icDVPrdWaHtkNc4ePuqr
 tSr1j1QrKF8ZnsBcMj7xRwW5i14FRKTJpbhBq9fddMqpPFnt9TIubxVOYXgGLAPcohZb
 zuGL+km0OWX7NT0ilqu8QGE2rJTdf82yudbeEIWQCGl6VRwNpB5ATwpcN7TueqwnmFr1
 0e1Q==
X-Gm-Message-State: ACrzQf2x3aYT4mxC1nVnEiNef3k0HFCtwKSQCA2BV4hPuuUO9ciZAhnn
 BvDLJgbPuHkx6g0GqlQhUtFNcA==
X-Google-Smtp-Source: AMsMyM52wRN4DEh0Zo2NexLCUfgd5bt8kOt5xmE2XXSSuELD9uW+be6OH9HyRY+1qMnACI7O4EbEXg==
X-Received: by 2002:a05:6a00:224c:b0:56c:40ff:7709 with SMTP id
 i12-20020a056a00224c00b0056c40ff7709mr50641719pfu.59.1667832440879; 
 Mon, 07 Nov 2022 06:47:20 -0800 (PST)
Received: from leoy-huanghe.lan (211-75-219-204.hinet-ip.hinet.net.
 [211.75.219.204]) by smtp.gmail.com with ESMTPSA id
 a17-20020aa794b1000000b0056eaa577eb0sm4572420pfl.215.2022.11.07.06.47.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 06:47:20 -0800 (PST)
Date: Mon, 7 Nov 2022 22:47:10 +0800
From: Leo Yan <leo.yan@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 3/3] perf arm64: Support virtual CPU ID for kvm-stat
Message-ID: <Y2kabsQdddiX4G+O@leoy-huanghe.lan>
References: <20221105072311.8214-1-leo.yan@linaro.org>
 <20221105072311.8214-4-leo.yan@linaro.org>
 <868rkpr0mv.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <868rkpr0mv.wl-maz@kernel.org>
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

On Sat, Nov 05, 2022 at 01:28:40PM +0000, Marc Zyngier wrote:

[...]

> > Before:
> > 
> >   # perf kvm stat report --vcpu 27
> > 
> >   Analyze events for all VMs, VCPU 27:
> > 
> >                VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time
> > 
> >   Total Samples:0, Total events handled time:0.00us.
> >
> > After:
> > 
> >   # perf kvm stat report --vcpu 27
> > 
> >   Analyze events for all VMs, VCPU 27:
> > 
> >                VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time
> > 
> >                  SYS64        808    98.54%    91.24%      0.00us    303.76us      3.46us ( +-  13.54% )
> >                    WFx         10     1.22%     7.79%      0.00us     69.48us     23.91us ( +-  25.91% )
> >                    IRQ          2     0.24%     0.97%      0.00us     22.64us     14.82us ( +-  52.77% )
> > 
> >   Total Samples:820, Total events handled time:3068.28us.
> 
> Please educate me: how useful is it to filter on a vcpu number across
> all VMs? What sense does it even make?

Now "perf kvm" tool is not sophisticated since it doesn't capture VMID
and virtual CPU ID together.

I think a case is we can spin a program on a specific virtual CPU with
taskset in VM, in this way we can check if any bottleneck is caused by
VM entry/exit, but I have to say that it's inaccurate if we only filter
on VCPU ID, we should consider tracing VMID and VCPU ID together in
later's enhancement.

> Conversely, what would be the purpose of filtering on a 5th thread of
> any process irrespective of what the process does? To me, this is the
> same level of non-sense.

I agree.

> AFAICT, this is just piling more arbitrary data extraction for no
> particular reason other than "just because we can", and there is
> absolutely no guarantee that this is fit for anyone else's purpose.
> 
> I'd rather you have a generic tracepoint taking the vcpu as a context
> and a BPF program that spits out the information people actually need,
> keeping things out of the kernel. Or even a tracehook (like the
> scheduler does), and let people load a module to dump whatever
> information they please.

Actually I considered three options:

Option 1: Simply add new version's trace events for recording more info.
This is not flexible and we even have risk to add more version's trace
event if later we might find that more data should traced.

This approach is straightforward and the implementation would be
simple.  This is main reason why finally I choosed to add new trace
events.

Option 2: use Kprobe to dynamically insert tracepoints; but this means
the user must have the corresponding vmlinux file, otherwise, perf
tool might inject tracepoint at an incorrect address.  This is the
main reason I didn't use Kprobe to add dynamic tracepoints.

Option 3: As you suggested, I can bind KVM tracepoints with a eBPF
program and the eBPF program records perf events.

When I reviewed Arm64's kvm_entry / kvm_exit trace events, they don't
have vcpu context in the arguments, this means I need to add new trace
events for accessing "vcpu" context.

Option 1 and 3 both need to add trace events; option 1 is more
straightforward solution and this is why it was choosed in current patch
set.

I recognized that I made a mistake, actually we can modify the trace
event's definition for kvm_entry / kvm_exit, note we only modify the
trace event's arguments, this will change the trace function's
definition but it will not break ABI (the format is exactly same for
the user space).  Below changes demonstrate what's my proposing:

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..16f6b61abfec 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -917,7 +917,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
                /**************************************************************
                 * Enter the guest
                 */
-               trace_kvm_entry(*vcpu_pc(vcpu));
+               trace_kvm_entry(vcpu);
                guest_timing_enter_irqoff();
 
                ret = kvm_arm_vcpu_enter_exit(vcpu);
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 33e4e7dd2719..9df4fd30093c 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -12,15 +12,15 @@
  * Tracepoints for entry/exit to guest
  */
 TRACE_EVENT(kvm_entry,
-       TP_PROTO(unsigned long vcpu_pc),
-       TP_ARGS(vcpu_pc),
+       TP_PROTO(struct kvm_vcpu *vcpu),
+       TP_ARGS(vcpu),
 
        TP_STRUCT__entry(
                __field(        unsigned long,  vcpu_pc         )
        ),
 
        TP_fast_assign(
-               __entry->vcpu_pc                = vcpu_pc;
+               __entry->vcpu_pc                = *vcpu_pc(vcpu);
        ),
 
        TP_printk("PC: 0x%016lx", __entry->vcpu_pc)

Please let me know your opinion, if you don't object, I can move
forward with this approach.

> But randomly adding new tracepoints to output a semi-useless field
> without any consideration for future-proofing? No, thank you.

Okay.  Thanks for review!

Leo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

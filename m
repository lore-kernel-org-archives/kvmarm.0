Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A591758D
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714573705; cv=none; b=JiqWPTHOIs5HHHptx6pfAfd5iRXNHIJRd4ypHvlGt5pRT5ZQ5g4Pgb8+HKHuasCRqhsgvWZ+i8+Rjn32XS74E6og2OzNyuxpORhe+dkHJE3yseicn+HWKEeVV2V9EFx6O8HBdYFYa1rbjohSpSPvVSptNIwmzr+C1l0zLOuqoPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714573705; c=relaxed/simple;
	bh=ejN7GdpXckHQzIXsC1FJGXtUzTE2KYdclj/fn/dJjrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WZntnB/le90MRoOi22DWhk0zLQGMtcPUD81bhoKZNyoPYez77Slyv1s1gPAhqASjev1voIp4ZJwPQKEnviEWednXVUazTDQdSBUBVQgYQAIZD5K1mOhTKqviMnwi9qkJHL0jquPR26HNvBQb3zj6HwVfc3XpC2z11sogX16Y/Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=danmOTLN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="danmOTLN"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de45c577ca9so1138447276.0
        for <kvmarm@lists.linux.dev>; Wed, 01 May 2024 07:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714573703; x=1715178503; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XN3PxGtZEQXNqntUnTfIz5xk/K9LwEoscNdYQ+/jCbc=;
        b=danmOTLNzSEHcdSoZstyXeBWMbYborLjBBglxov3Li7eaf/U8gnFgenR7Fsb3zZOFD
         NdLk7jSWrlmgloxe4+m/hT8hOpnwwxGpXqpgk8J4WaFPe+s4X/3VfberFITst5k7A/V2
         KCW6x2/Ma8H220ON3rLT7y5MeC+q4fbszHz3R2Wt9BZcoISgiSt20GAc3btT9dWobU7c
         ZIRv5J5hmr9JGFZCgoCI2QthdGDzAtBZfYPkjHCC/bXZRbTQlrX9qKHxauAYCdjXKFAl
         0T2Q/pXGzhZlnlAVDOIBBGK3yS1FpVkGA1hOPR60tys0sPV+yEvJM4gprdSXw7lwZLkM
         sKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714573703; x=1715178503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XN3PxGtZEQXNqntUnTfIz5xk/K9LwEoscNdYQ+/jCbc=;
        b=Bq5e5Dk51iXvl7ToqIKa0rDbFBfQOsAFfyQqDoLq/liXat+zBSCcFy9HFzieL+ud8W
         +UDXx7YkdqS7YAKY9QhBq7vPM9xZEXNTsLhFC3f/2UDpG+fcKYhBY2odAxcn2A9szjg7
         dtQ9zGZLXIQrde/mDyIvwG4hkTvWUsiuRFLcqiP7PZIHiM69LJFf3SYss2P2CEwKH9P9
         L9RjNFj+VHftaK1frr3YOyhy5SxxCUcTOD5LdU7cqls8+cfsjs6don7gsVPLTlrh742I
         OpAJDU2FGMPVXbbmvRHU6Otpd0HhswZBJsq9UnOsWwaH62DeyqsuSUuXroXWJv99CzBi
         VLDA==
X-Forwarded-Encrypted: i=1; AJvYcCVgJYbZz/2C3I0RWCNOlKx10+MByAFqZf1zBOdtE/zbmYoUyOsWEAHgnDw2TJHqk42lhrclfgXLmVUGpXAb1n8XHYGs2x57
X-Gm-Message-State: AOJu0Yy3TFGMTpMUdcHcASZc78fRLN0i1tihORU3wfvwKi4iF4Vc5V6X
	f7J7WIy5HlMXG9bXTBqYof47sYoZdtEMsBiZKvkkd79VH5FQ26m6dqqA21VCN0VHTbwBcCrKWy9
	4ow==
X-Google-Smtp-Source: AGHT+IHUezc4IZyZaMpXPcKS4Nl6spB8OORkXUO8w6Eu/n8Z2MEF5bQ0emcAkaZbOCNg6hB5INRjxf830ZQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a283:0:b0:de5:a44c:25af with SMTP id
 c3-20020a25a283000000b00de5a44c25afmr1319848ybi.5.1714573703105; Wed, 01 May
 2024 07:28:23 -0700 (PDT)
Date: Wed, 1 May 2024 07:28:21 -0700
In-Reply-To: <ZjGMn5tlq8edKZYv@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240430193157.419425-1-seanjc@google.com> <ZjGMn5tlq8edKZYv@linux.dev>
Message-ID: <ZjJRhQhX_12eBvY-@google.com>
Subject: Re: [PATCH 0/4] KVM: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, May 01, 2024, Oliver Upton wrote:
> On Tue, Apr 30, 2024 at 12:31:53PM -0700, Sean Christopherson wrote:
> > Drop kvm_arch_sched_in() and instead pass a @sched_in boolean to
> > kvm_arch_vcpu_load().
> > 
> > While fiddling with an idea for optimizing state management on AMD CPUs,
> > I wanted to skip re-saving certain host state when a vCPU is scheduled back
> > in, as the state (theoretically) shouldn't change for the task while it's
> > scheduled out.  Actually doing that was annoying and unnecessarily brittle
> > due to having a separate API for the kvm_sched_in() case (the state save
> > needed to be in kvm_arch_vcpu_load() for the common path).
> > 
> > E.g. I could have set a "temporary"-ish flag somewhere in kvm_vcpu, but (a)
> > that's gross and (b) it would rely on the arbitrary ordering between
> > sched_in() and vcpu_load() staying the same.
> 
> Another option would be to change the rules around kvm_arch_sched_in()
> where the callee is expected to load the vCPU context.
> 
> The default implementation could just call kvm_arch_vcpu_load() directly
> and the x86 implementation can order things the way it wants before
> kvm_arch_vcpu_load().
> 
> I say this because ...
> 
> > The only real downside I see is that arm64 and riscv end up having to pass
> > "false" for their direct usage of kvm_arch_vcpu_load(), and passing boolean
> > literals isn't ideal.  But that can be solved by adding an inner helper that
> > omits the @sched_in param (I almost added a patch to do that, but I couldn't
> > convince myself it was necessary).
> 
> Needing to pass @sched_in for other usage of kvm_arch_vcpu_load() hurts
> readability, especially when no other architecture besides x86 cares
> about it.

Yeah, that bothers me too.

I tried your suggestion of having x86's kvm_arch_sched_in() do kvm_arch_vcpu_load(),
and even with an added kvm_arch_sched_out() to provide symmetry, the x86 code is
kludgy, and even the common code is a bit confusing as it's not super obvious
that kvm_sched_{in,out}() is really just kvm_arch_vcpu_{load,put}().

Staring a bit more at the vCPU flags we have, adding a "bool scheduled_out" isn't
terribly gross if it's done in common code and persists across load() and put(),
i.e. isn't so blatantly a temporary field.  And because it's easy, it could be
set with WRITE_ONCE() so that if it can be read cross-task if there's ever a
reason to do so.

The x86 code ends up being less ugly, and adding future arch/vendor code for
sched_in() *or* sched_out() requires minimal churn, e.g. arch code doesn't need
to override kvm_arch_sched_in().

The only weird part is that vcpu->preempted and vcpu->ready have slightly
different behavior, as they are cleared before kvm_arch_vcpu_load().  But the
weirdness is really with those flags no having symmetry, not with scheduled_out
itself.

Thoughts?

static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
{
	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);

	WRITE_ONCE(vcpu->preempted, false);
	WRITE_ONCE(vcpu->ready, false);

	__this_cpu_write(kvm_running_vcpu, vcpu);
	kvm_arch_vcpu_load(vcpu, cpu);

	WRITE_ONCE(vcpu->scheduled_out, false);
}

static void kvm_sched_out(struct preempt_notifier *pn,
			  struct task_struct *next)
{
	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);

	WRITE_ONCE(vcpu->scheduled_out, true);

	if (current->on_rq) {
		WRITE_ONCE(vcpu->preempted, true);
		WRITE_ONCE(vcpu->ready, true);
	}
	kvm_arch_vcpu_put(vcpu);
	__this_cpu_write(kvm_running_vcpu, NULL);
}

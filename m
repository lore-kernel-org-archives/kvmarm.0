Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5A9221DAC
	for <kvmarm@lists.linux.dev>; Tue, 26 Aug 2025 00:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756168040; cv=none; b=GZULS0DA2YbbU68OMEesCt5ybahevfBRVnZK1Ryq+OyrXDX75iaOwVi1+TIpiuFZYn+yd6fgSq8W3cyM2hxR9gEzJSrBaPFkoNBZ4U7VHicaRpwlHMvlY1FiU9GIYHzfQ6lh65AzsunqoCO9vpX6L3EixLXZf99Q5gkRrEACFlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756168040; c=relaxed/simple;
	bh=5L/BYqW9WfoHeTEgYYwzNBfWpjlpn5EeY5J3QpRZyJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wn46mWlhFTeNpYe5tizylfUMJPS1UMklLl7YfqTh/UcW9aqEzMJbmUrHHOZaO8SJuX8HjaTIQQxBvscm3RcKKtYp+qMgBrq0WOEio1k1FVD40R75/JPctLUXPzgyjujjpX51w97GFBhUKBv8YVSCc9HLHqCF/mW/RkeWHPkdwac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=suNU1BZ7; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="suNU1BZ7"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-771e1451631so2878534b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 17:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756168038; x=1756772838; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4ctZNwYJMz9+Hk7ge9l8ZiYDw45Y30bqY3Iaj5/gqE=;
        b=suNU1BZ7W4CzNBuVKm/nc7VqXAfmq9IHBLaciWKHRiD+AeAYdd3AvNWDDlmPjmDwU7
         embG1WIXkEOJlKrUyscEJBK04EOEbEwimoMogPtDIrdzaz6zB4DyhGpz7b6DamcFjPwN
         vABjtwBOBZTQ2WTYfEjnp5xv82dyLu3gHwmTUMTcL50+zzRTEo/bom1ci6lbv8N6Kbc5
         2aiR9sF4GI6+XHkbOCeLqAKyce2lBYZfITvEYmBmq1c6gSU7ZupWmMjWAhITqt+Bz3b3
         YEcAQiz7haSo6Jbh6DlpaDsBwqCnN016rMfGsfUe/Iy+fK3QsSdDzH7HsF12p4hxlhIH
         4+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756168038; x=1756772838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U4ctZNwYJMz9+Hk7ge9l8ZiYDw45Y30bqY3Iaj5/gqE=;
        b=pBT6MHVSQX3/mktLKZRMLi+iIWpiLQ9FKCk1cAgO05t908PS8VCHbXBA1r77aZUD5D
         kkTr9qgZntmmWEic7pxdlfOlxJmAfIMnnGYcZW69iiET4fD9EKc9yw/hKaPcnNpL1VvH
         O/uyHReO87M1LXr/MQF3sn//trvbzaMvb5eaJo8N+7/6orgXPHuq1PGmPEsc/xzTvSjG
         o9iMPwAwGB/pFQ9YErZERrEoucFPZqFyURZBYhtQc93X2pHJXvER/QM5UdWzV0I9a9ws
         yU1uPg1YQXWe6z5ZOFPWX3uP3nobph6KFi0uDQc7onQdJc2htZYLQ6GwurwFwTn6ylZB
         lHwA==
X-Forwarded-Encrypted: i=1; AJvYcCUrwveKCWzklu1JTUOgf3YFlhVRATYqPz53e8gJhu9s0tOLonxCt6/K+ug3foU8UsvVFHHEOdU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/c0VUeRYOXJ3nIE1adN6pbvQLRcxt+NBwKSAHhfbaMb/mkQ2Y
	f/Qcf7494rZbbLPW2DGNA+yZqWQMFO0fZMIGOib5abWuXKRRbj2M9LOBepZJkLMT4zpGpDrtW1w
	cn5j/Wg==
X-Google-Smtp-Source: AGHT+IFw5Mjf6HTcAUWU+u7CL/B6QAA0945o29LTS2VrhL4i1mL+9cXlmfjB4AEyc0iYoyyJlQoJr1vqexM=
X-Received: from pjbsp15.prod.google.com ([2002:a17:90b:52cf:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a105:b0:230:8b26:9d47
 with SMTP id adf61e73a8af0-24340ab318emr21164734637.10.1756168038330; Mon, 25
 Aug 2025 17:27:18 -0700 (PDT)
Date: Mon, 25 Aug 2025 17:27:16 -0700
In-Reply-To: <3188ca61-2591-4576-9777-1671689b7235@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250825200622.3759571-1-seanjc@google.com> <3188ca61-2591-4576-9777-1671689b7235@linux.microsoft.com>
Message-ID: <aKz_ZMvvF0e9nwSn@google.com>
Subject: Re: [PATCH 0/5] Drivers: hv: Fix NEED_RESCHED_LAZY and use common APIs
From: Sean Christopherson <seanjc@google.com>
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-hyperv@vger.kernel.org, 
	rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 25, 2025, Nuno Das Neves wrote:
> On 8/25/2025 1:06 PM, Sean Christopherson wrote:
> > Fix a bug where MSHV root partitions don't honor NEED_RESCHED_LAZY, and then
> > deduplicate the TIF related MSHV code by turning the "kvm" entry APIs into
> > more generic "virt" APIs (which ideally would have been done when MSHV root
> > support was added).
> > 
> > Assuming all is well, maybe this could go through the tip tree?
> > 
> > The Hyper-V stuff and non-x86 architectures are compile-tested only.
> > 
> 
> Thanks Sean, I can test the root partition changes.
> 
> A similar change will be needed in mshv_vtl_main.c since it also calls
> mshv_do_pre_guest_mode_work() (hence the "common" in mshv_common.c).

Oof, more dependencies.  I suppose the easiest thing would be to send a series
against

  git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git queue

and then route everything through there?

Alternatively, frontload the MSHV fixes (which I'll do regardless) and take those
through hyperv and the rest through the tip tree?  That seems like an absurd
amount of juggling though, especially if we want to get the cleanups into 6.18.
And if none of these lands, it's MSHV that'll suffer the most, so betting it all
on the hyperv tree doesn't seem terrible.

> Also, is it possible to make all the mshv driver changes in a single patch?

It's certainly possible, but I'd prefer not do to that.

> It seems like it would be cleaner than refactoring it in patches 1 & 2 and
> then deleting all the refactored code in patch 5.

Only if you don't care about backporting fixes, bisection, or maintaining code.

E.g. if checking NEED_RESCHED_LAZY somehow causes issues, it would be really nice
for that to bisect to exactly that patch, not a patch that also switches to a
completely different set of APIs.

And if someone is wants the fixes in a pre-6.18 kernel, they don't need to
backport all of the KVM and entry code changes just to get the fix.

As for the maintenance headache, see above.

Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088E62F7442
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760120050; cv=none; b=C7HkXxvbyv3PL/QK9iidON0UZJ4xZTFU/0hYnC1E6T210XoUt4rt/tbbY7N1SbjsO9nTX5UXofnynDciXowuP0bmp07HUMzda42z+OCYfgcPYT7TFwQgqV7SQ7GTChdZyxgL6FsxJ7M+4w9f+KNoFKaCdYWdIBooURNaBgPr2j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760120050; c=relaxed/simple;
	bh=V0gMhKNlFvxaSiIwQX6I3iUUMqcn4Gj0ndcSzOb074I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mVNME9Z6T4aAZR3P1tmp8dNienT+Yl4q67Z7Cbr6xByC47fmF8+spHx7iboZ1sD/dzL7okVWonU7stBnfyqu9d9PExYGSIsJBhGxNc8xeLFhNTnjR65T/rD2ByNpQ0tiYJq2RmR6EKeQqTqu51q6ZdxReC1Hu8TlDnhuOyIEaks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JlH5ifyE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JlH5ifyE"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2699ebc0319so45173685ad.3
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 11:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760120048; x=1760724848; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RRqqebB5b3S+5bGOfhb1j8iKUMVMXWWcx0kI9eE51UQ=;
        b=JlH5ifyE58O0F/ACJiDZZEyD/anKufMeDk4H4Zm9pZsCSoVjsCGK2wP8/O5cdevcnE
         KTEj2b72u29yj6SQrwpveHKlhu1EEkAEfrwYqgSXKvEapuQRBQLP04U1YfEOBiL/mz42
         DDKxcE/U+XEoWeDQyaj42u1YUouRYDMjfQlz7a+6fh0d9S024I3Jb+QLfkuq/CsALj+x
         WEDp+oP8TEVtSV2kVWf69vIu8powGNBFrlQVV4XHBfABhhFavtaa24dB316VbuvZTiZI
         FrRtNoGiFb8JCqfTGr9Mh9iIKfYnUWBa73Tv/28mdmUkckrZeCODtOw4nXlu+yEWVOX3
         39Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760120048; x=1760724848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RRqqebB5b3S+5bGOfhb1j8iKUMVMXWWcx0kI9eE51UQ=;
        b=XMYjNg5zLcUwjiy8+n7VtICbAPWa83t8RtvzoEzxB9c+9CPHOoZNjdyCfrQGz4kfNM
         lNC/9Ow+4YJbdtNvKG1KhGULOCygCW4sHWfpVWp9e7sjiS1dVpnNSW43+4uEWBN8kqM0
         fjpx1T77plTvgXAP1ZVBoNjxbuTE1SIwcnVlj1KOV/svzDAEYAUGVvsGMCyOFl/zVWk+
         p3ufzfz47x91K9VqVQzBwoke4EFzWKyjmGU0g0TOgLLXT7HdV+mjmS8FhZPwpMGkNTDF
         s11oznrKgeiF1G4+K2ly+Jq40dE9Xue8MP/uuQr8V2g1hHLYQb3C1SercC+nz2BiuhA1
         LH9A==
X-Forwarded-Encrypted: i=1; AJvYcCWJNGoX5/tUVVfgyH4aRtedj2pmfq40/1iKFf+uEu6eU6A3c8ZiM+vUCiwCp7x9BDH/M3umaMg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyBZoOll/0iGlI4nPAUG+0gzKXXjI8IFIFv9wjmtiBqESk3Bue
	V26QOpuAyP57e2mtyDL4rH5wedd0g7Kc2Xe+hhYMcTErrW0eS9BH2GXykZYS4GMI0qUmvydhibA
	yJu7nkw==
X-Google-Smtp-Source: AGHT+IH7cFlVTSNM+0j4l/xFWY5dLqOboXxalLgs1PnQJ4K/8YINWNO1tWQ0AvtHmyKAMc8BcWffcUfPi8Q=
X-Received: from plkb3.prod.google.com ([2002:a17:903:fa3:b0:268:1af:fcff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54b:b0:265:47:a7b0
 with SMTP id d9443c01a7336-290272117f0mr156739855ad.10.1760120048173; Fri, 10
 Oct 2025 11:14:08 -0700 (PDT)
Date: Fri, 10 Oct 2025 11:14:06 -0700
In-Reply-To: <DDEJY5ON407O.2O7CMOY9311NV@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com> <20250930163635.4035866-10-vipinsh@google.com>
 <DDEJY5ON407O.2O7CMOY9311NV@google.com>
Message-ID: <aOlM7ngJJsEW-5sV@google.com>
Subject: Re: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, kvm-riscv <kvm-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 10, 2025, Brendan Jackman wrote:
> On Tue Sep 30, 2025 at 4:36 PM UTC, Vipin Sharma wrote:
> > @@ -0,0 +1,54 @@
> > +KVM Selftest Runner
> > +===================
> > +
> > +KVM selftest runner is highly configurable test executor that allows to run
> > +tests with different configurations (not just the default), parallely, save
> > +output to disk hierarchically, control what gets printed on console, provide
> > +execution status.

...

> I understand that for reasons of velocity

It's not just velocity, it's also for stability and maintainability.  Selftests are
the wild, wild west; there's no central authority, and many subsystems have "needs"
and opinions.  E.g. tools/testing/selftests/kselftest_harness.h is quite opionated,
_and_ it has fatally been broken multiple due to one subsystem making changes that
broke usage for other subsystems.  Obviously those bugs got sorted out, but it's a
painful experience.

I guess you could say those things are all about velocity in the end; but I want
to call out that it's not just about the initial velocity of landing the series,
it's also about the long-term velocity of being able to make changes to fit KVM's
needs without getting bogged down due to other susbystems adding requirements and
use cases that are irrelevant or at odds with KVM's.

> it might make sense to do this as a KVM-specific thing, but IIUC very little
> of this has anything to do with KVM in particular, right?

The actual implementation doesn't have any dependencies on KVM, but the design
and its goal are tailored to the needs of KVM.

> Is there an expectation to evolve in a more KVM-specific direction?

Sort of?  I don't think we'll ever pick up direct dependencies, but I do think
we'll continue to tailor the runner to the needs of the KVM community.

> (One thing that might be KVM-specific is the concurrency. I assume there
> are a bunch of KVM tests that are pretty isolated from one another and
> reasonable to run in parallel.

Every KVM selftest should be able to run in parallel.  That's actually a very
intentional design property of the runner: any system-level configuration needs
to be done by a "higher" authority, e.g. the human manually running the test, a
wrapper script, some form of CI infrastructure, etc.

> Testing _the_ mm like that just isn't gonna work most of the time. I still
> think this is really specific to individual sets of tests though, in a more
> mature system there would be a metadata mechanism for marking tests as
> parallelisable wrt each other.

Dependency and friendliness tracking is again something we specifically avoided
doing, because the KVM selftests need to be self-contained anyways.  E.g. if a
test requires KVM module param X to be enabled, then the test needs to skip.
The runner takes advantage of that behavior in order to simplify the code; it
really is just a "dumb" executor.

> I guess this patchset is part of an effort to have a more mature system that
> enables that kind of thing.).

Sort of?  My response to Marc covered more of the goals in detail:

https://lore.kernel.org/all/aN8gkEMHuvIVPcCt@google.com

> To avoid confusing people and potentially leave the door open to a
> cleaner integration, please can you add some bits here about how this
> relates to the rest of the kselftest infrastructure? Some questions I
> think are worth answering:
> 
> - As someone who runs KVM selftests, but doesn't work specifically on
>   KVM, to what extent do I need to know about this tool? Can I still run
>   the selftests "the old fashioned way" and if so what do I lose as
>   compared to using the KVM runner?

The runner is purely optional.  You'll lose whatever you don't have, that the
runner provides.  E.g. I have (hacky) scripts to run KVM selftests in parallel,
but without much of the niceties provided by this runner.

> - Does this system change the "data model" of the selftests at all, and
>   if so how? I.e. I think (but honestly I'm not sure) that kselftests
>   are a 2-tier hierarchy of $suite:$test without any further
>   parameterisation or nesting (where there is more detail, it's hidden
>   as implementation details of individual $tests). Do the KVM selftests
>   have this structure?

More or less.

>   If it differs, how does that effect the view from run_kselftest.sh?

AFAIK, nothing in KVM selftests is at odds with run_kselftest.sh.

> - I think (again, not very sure) that in kselftest that each $test is a
>   command executing a process. And this process communicates its status
>   by printing KTAP and returning an exit code. Is that stuff the same
>   for this runner?

Yes?  Except most KVM selftests don't support TAP (yet).

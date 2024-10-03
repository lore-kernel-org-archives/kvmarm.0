Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A188BF0
	for <kvmarm@lists.linux.dev>; Thu,  3 Oct 2024 18:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727979820; cv=none; b=kEgQSL6WKmGstYHNp5wBYMm+cIEd6FMQIaibaxqWXRFhvz9hgBKbHLmyPuIRDuRJEFH0eDStdLUxbS7FnnPHjy3pgXH2fR0ryz15BZX6InZ0iE0dSaLxcjTmcCOqPeEELamdGjVOMZrSD9AMbSksj5qmPxMZxIjhleFY0Bu3lXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727979820; c=relaxed/simple;
	bh=+Qwko865Dxb23zLYgBNY7MwA1Z4+ZEHBZf5jKMEL8/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fxv5BPdOf8GFXGSjtstvbGLua1WPtkLwpD49YDlyIVvn3ftxf9byTMQYV3YkW54lu60DllRWOTqnX5M6LBWcZq50z3WWvC0swldnv/btlOLj3LpgSeakFw+C0L7ssAminTIn/dcbjt+yL/IlxQN948du8OBTvA4/4IQJcdGZYa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BUje97N7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BUje97N7"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e0a47eb73fso1615495a91.0
        for <kvmarm@lists.linux.dev>; Thu, 03 Oct 2024 11:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727979818; x=1728584618; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ySmfm9Cr5pP5Ntea2x6oizdkkAlkeRhH8HqoIV51tqo=;
        b=BUje97N7sE2jQOA3Ct8ECXnbkMU4o0YdGAgpoNnndyFYzVXBxoZzNXT5zM+jq1LAok
         RHmOKo/kVrCTI104s/ZYJyVNP50r2dxZrPYIsZY8i84bk/1DwXOs0Morg6S1Ar/yihZJ
         DQuSauKUeiY4Teip0bIp8OH8RhnaFmXGdAqPdKvB5IggjeyYynrnyJIapWnN15BCwnce
         4iP9y5uEqxsbaOJNgS9/e/7WGqatTK9nylNT1z/JZ+7aVMp0zBh6VQ+haZbKSPYNi4Qr
         Gf9uHfzSr4RlbdipgpNNOX9aLAT2UwZDx3H9QtjJzYa+N2u0vGBGtjJj4PlrUHhXcXZ1
         wwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727979818; x=1728584618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ySmfm9Cr5pP5Ntea2x6oizdkkAlkeRhH8HqoIV51tqo=;
        b=Nu+0sDpjX08oGaRf3a2I8UW4pucKrAVwH52rfVeAFu7hJlAc/TycnUHG61myWo7Zfp
         okzVhwd2Lu+MU9HVUeIOREvgYICguTpj2hN2Nha8Ny5fcc0hMV8x2QY/OlJHOrT4fdw/
         bTyWVgqhb+7oKpgC72mm49ropG3G1DZu4QvtjlnTj1sd+/0fE2A1PwGiuuFfQlMVphYb
         55mMZjAKGxlpSQC1YyGIxZPA9MdpOmMsIiQrR8Yu1EqexSvP4fM7IqnEuygVockqc0iZ
         5xDLXm2E6Gy/+7EI3QMvNT7jRpkQwHUa0A1ZKWQ5kzA38rMS6nE1D5+0DsRGQVvr+hi7
         mkVA==
X-Forwarded-Encrypted: i=1; AJvYcCWOASF/qCcpiKlnXr37zuYbiIExrCJ22ssNKEuY63c7P22EMLfygbcS/kzHD7wTPicCnormzY4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywzk7x9RWfa8yRJQaFVQfZrnvVm6bGxOVxKlq8OcyPLTB7jDClx
	cB/lohDpOk/zGEryHbfQPSFM2zPmx7C/st1k2BXNYeN/D/gVduFMqW1DS9i6ek5MwuCLX25z1Cg
	0+A==
X-Google-Smtp-Source: AGHT+IFzhaffNkrbhAeC1oApOfdVpx2o3VOEWi7YxZsmOHqtBcaZJWVc8oCX7nOlCDNE0KMvFyo/4xUZC/g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b49:b0:2da:96a4:dadb with SMTP id
 98e67ed59e1d1-2e1849343b1mr26745a91.5.1727979818033; Thu, 03 Oct 2024
 11:23:38 -0700 (PDT)
Date: Thu, 3 Oct 2024 11:23:36 -0700
In-Reply-To: <Zv7Z4D0L3bnxJi8h@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZvxeeVn8LphHxWeS@linux.dev> <ZvyFkqsRFBAYwqP7@google.com>
 <86cykj75a0.wl-maz@kernel.org> <ZvyOcnZqNzfD7MZx@linux.dev>
 <ZvySjfDWOhl2O1IA@google.com> <865xqa6q0a.wl-maz@kernel.org>
 <Zv3fcT9lCSujib7J@linux.dev> <Zv3hgOhjaQGAuIOG@linux.dev> <Zv7KNFX4Mykff6I5@google.com>
 <Zv7Z4D0L3bnxJi8h@linux.dev>
Message-ID: <Zv7hKD_6Pvhg4ULY@google.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 03, 2024, Oliver Upton wrote:
> On Thu, Oct 03, 2024 at 09:45:40AM -0700, Sean Christopherson wrote:
> 
> [...[
> 
> > > > OTOH, our global TLBs don't model hardware exactly since a vCPU doing
> > > > rapid context switches trash the TLBs of *all* vCPUs in the system.
> > > > The cost of reusing an MMU is quite noticeable, since our unmap
> > > > implementation is slightly crap at the moment, the cost of which shows
> > > > up both on sides of the reclaim (victim and user).
> > > 
> > > Oh, and why unmap is crap:
> > 
> > Heh, isn't unmap by definition crap?  If KVM needs to unmap and rebuild an S2 MMU,
> > then KVM is already in a slow, sub-optimal situation.
> 
> Not really, the unmap plumbing is used for applying the intent of a
> guest TLBI too. Sub-optimal or not, it is exactly what the VM asked for,
> and it'd be in our interest to handle the unmap as expeditiously as
> possible.

Sorry, I meant "unnecessary unmap".

> > > > Still should drop the reference in most other cases, as I do *not* want
> > > > to entertain vCPUs holding a reference when they've gone out to
> > > > userspace.
> > 
> > Why not?  The vCPU is still running, keeping its S2 MMU resident is desirable, no?
> 
> How could we possibly know what the intent of userspace is? The VMM
> could just as well throw that vCPU fd on ice for an eternity.
> 
> For example, you could have a PSCI implementation that lives in
> userspace. Guest does CPU_OFF and the VMM decides to terminate the
> backing thread and keep the FD around for the next CPU_ON.

Yes, but we need to play the odds.  I.e. make the common case fast/efficient.
KVM obviously needs to not fallover or crater performance in the presence of edge
cases, but IMO, disallowing a vCPU from pinning a vCPU because it _might_ go
offline is the wrong tradeoff.

> Since KVM still views that fd as 'runnable', it'd sit on the reference
> that vCPU holds indefinitely. On top of that, it adds complexity to the
> implementation since we would need more refcount cleanup flows to handle
> these straggler references.

But only one flow, vCPU destruction, is mandatory.  Anything beyond that is pure
optimization.

> > Essentially all I'm suggesting is that instead of having a common pool of 2*vCPUs
> > TLBs per L1 VMM, have 2 (or however many) TLBs per L1 vCPU, plus maybe N extra
> > TLBs per L1 VMM.  I.e. mimic the hierarchical design of hardware caches and TLBs
> > to some extent.
> 
> Making TLBs private to the L1 vCPU is almost guaranteed to be a net loss
> in performance.

I'm not saying make TLBs private, I'm saying allow each vCPU to "pin" (i.e. hold
a reference) up to N TLBs/MMUs, regardless of "where" that vCPU is in the flow
of things.  Versus the proposed behavior of pinning TLBs only when it's absolutely
mandatory to do so for functional correctness.

Holding a reference across preemption would be the first step towards that model.

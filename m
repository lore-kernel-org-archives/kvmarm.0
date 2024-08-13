Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0940AD531
	for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 02:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723514761; cv=none; b=YG1oWYGUwsh1WPgC8tb7uhT9kJ5nyfzZ18numQqC4gjclYTI/xPbVY4CGkG8UHNcWQGz47hY2KDHTM6nPoepwDgNRc1VEoFnOz6gYH/vVhdbe/SOZw+oOpyBCS2+KTuiUS+SbmBE10IDRqGPzuMpQMt5xa9efU7YxV1S2XJmDrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723514761; c=relaxed/simple;
	bh=/hCQcM4Y08P6qJOn4vVha/UUYcfFhpNYaUuiBNAL/ng=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kRO3ir/0mkxcK6rJgQoXr9zSSjlOYp6/co2KgCWWXyj3j9wqVOemZiNueiZvhcouMLpB/YxoeD9r70KliWfwPrx2gIcYk3uM408gPc7mMDhL+yKBXeHebVIg+g+CYsGtf7AKhWXndDhD/Y6NVlQkXtgxaUV2LHHdSgCUkEmK6WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kZYfvT6X; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kZYfvT6X"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70f0a00eb16so3418611b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Aug 2024 19:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723514759; x=1724119559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JTrcYlNshYngPiSYeGYBD6ZRFP0rJ4yWLqR8htIj1GU=;
        b=kZYfvT6Xor13GVp9kJKxaiMfBNrxnZT3+Lu40PbaxuxdGXa8KJfdxijkJXavxYMKtV
         4nSKYwBMf/J9IVJywrgtYaS3oLDBFW/t41n5ZRI3WTQeg+UcarICQ9jldzTpR9DhTBKb
         smOfyUiJDzoYtiBkiiEsXo343WUQjv82sUQujhosEGFRNIGXwC+W3sNzb0J5GUg3j7gS
         Ny7bFjZL6JxzsrxZRnKVYakunzF+/lTROtVmlp9rj13hD3vPFNxEqUsKZzgphCqZ5Cum
         5g5HvIVwj7sIRKe7/ujr/+16PxsfsXzh1+/hPAqPU8Jq/d0SrznK/Yo07A8K5auA2UA1
         8XCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723514759; x=1724119559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JTrcYlNshYngPiSYeGYBD6ZRFP0rJ4yWLqR8htIj1GU=;
        b=imYoRC+uZn6fXwhdF7/naN1TNhsu85vByKPZYbOaWw5sH+9+kx9b9gqZzNyDBMWYe7
         n9uxvr3IqmREzQ38lMcKNEcOcXdMq8/Fkalpt0Svi5lSVmJDwzLfRp2S5XzkIjofIfyG
         F8CEA9D7wHyiZ/HiszWX+rAYU/VygNIOv6tLvpjz3AYjmogrD1Y+g8An2cPw2Lub5mWK
         gekhhKoSPysLVIsxD9HL5xgXpH+Q2unmX/7Y6T/b5paeLjVIV3e+vfcDVlrmMILStheS
         iVQKtsanJ9BogZKiynOjukbABSZK0gyXY+/DD3oTfloX8iMiwDybNzjo/E4utc2xwEcA
         xIjA==
X-Forwarded-Encrypted: i=1; AJvYcCUHi04fbkoIiydEZEfxGupiejK7DLC6cey4/hRS6w9X7GtFf/A+s/zg1KrvvbhDmJYRWuAfrbkNy1QIt5ninYRXELMsLHcL
X-Gm-Message-State: AOJu0YwGXP/njM1V0V4JLJv6jLQxRmolimuc5vqOrMad3/Gi9YSoE4aH
	9RJj/84yeXG1zqm5QiUss93sSouwLDD7n7LZjFqSNHpB7elr4EeaGm0MacTge72zfkOnOQUHuoa
	AYA==
X-Google-Smtp-Source: AGHT+IEw4KOWnUezKCb07r49r8VQShv4Y6sqr3v4rfwBcl9BYsQ7jzdYpBrfRXTk/LiFtqSR5qMGQ76wylw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6215:b0:710:4d39:c8f9 with SMTP id
 d2e1a72fcca58-7125551dce5mr5087b3a.6.1723514758712; Mon, 12 Aug 2024 19:05:58
 -0700 (PDT)
Date: Mon, 12 Aug 2024 19:05:57 -0700
In-Reply-To: <ZrZafa66bRxoVc0Z@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com> <20240802200136.329973-3-seanjc@google.com>
 <ZrKqrCnNpNQ_K_qi@linux.dev> <ZrK4x4LLz1wlwGQN@google.com> <ZrZafa66bRxoVc0Z@linux.dev>
Message-ID: <Zrq_hd5CkmmOl6jp@google.com>
Subject: Re: [PATCH 2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 09, 2024, Oliver Upton wrote:
> On Tue, Aug 06, 2024 at 04:59:03PM -0700, Sean Christopherson wrote:
> > > Can you nest this lock inside of the vcpu->mutex acquisition in
> > > kvm_vm_ioctl_create_vcpu() so lockdep gets the picture?
> > 
> > I don't think that's necessary.  Commit 42a90008f890 ("KVM: Ensure lockdep knows
> > about kvm->lock vs. vcpu->mutex ordering rule") added the lock+unlock in
> > kvm_vm_ioctl_create_vcpu() purely because actually taking vcpu->mutex inside
> > kvm->lock is rare, i.e. lockdep would be unable to detect issues except for very
> > specific VM types hitting very specific flows.
> 
> I don't think the perceived rarity matters at all w/ this.

Rarity definitely matters.  If KVM was splattered with code that takes vcpu->mutex
inside kvm->lock, then the mess that led to above commit likely would never had
happened.

> Beyond the lockdep benefits, it is a self-documenting way to describe lock
> ordering.

Lock acquisition alone won't suffice, many of the more unique locks in KVM need
comments/documentation, e.g. to explain additional rules, assumptions that make
things work, etc.  We could obviously add comments for everything, but I don't
see how that's clearly better than actual documentation.  E.g. pid_lock is taken
for read across vCPUs.  Acquiring vcpu->pid_lock inside vcpu->mutex doesn't
capture that at all.

It's also simply not realistic to enumerate every possible combination.  Many of
the combinations will likely never happen in practice, especially for spinlocks
since their usage is quite targeted.  Trying to document the "preferred" ordering
between the various spinlocks would be an exercise in futility as so many would
be 100% arbitrary due to lack of a use case.

KVM's mutexes are more interesting because they tend to be coarser, and thus are
more prone to nesting, so maybe we could have lockdep-enforced documentation for
those?  But if we want to do that, I think we should have a dedicated helper (and
possible arch hooks), not an ad hoc pile of locks in vCPU creation.

And we should have that discussion over here[*], because I was planning on posting
a patch to revert the lockdep-only lock "documentation".

[*] https://lore.kernel.org/all/ZrFYsSPaDWUHOl0N@google.com

> Dunno about you, but I haven't kept up with locking.rst at all :)

Heh, x86 has done a decent job of documenting its lock usage.  I would much rather
add an entry in locking.rst for this new lock than add a lock+unlock in vCPU
creation.  Especially since the usage is rather uncommon (guaranteed single writer,
readers are best-effort and cross-vCPU).

> Having said that, an inversion would still be *very* obvious, as it
> would be trying to grab a mutex while holding a spinlock...
> 
> -- 
> Thanks,
> Oliver

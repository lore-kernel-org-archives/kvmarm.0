Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC5C366806
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 12:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778071496; cv=none; b=qcSwYS92nGb0YdHJanMu6ABXUtoHwqnrBM/q/i6F1wIZU26JpwyaLDi1RqnBZmJbbEumd7Oeu+XtmoF7vvvTvGYJ4Vgu/3JS27MU1BNZ0QVh1ZLUrgZvQH1DEroxsbPdbRUvKiegttl4Sw62CrAKU5viyGsQbzx8YgHNmpoN5No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778071496; c=relaxed/simple;
	bh=iQ++M7xh0uoho1E9qjZxrSJVM2w1kxfFwdazrarRVKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=enfvo22T4ny8/K+8Labz51GxlRho284c4NDdSqThYzUaFg7xPkTrgzzb3jB+6bwh6ZXB41iHkeAiv/fqLv7mcsZnssOlXIzTxY5DnT/WZZf5nZO3UGnR1LSugUYYqPe39vTfRwti+tr6uinEaWvbNS6EzEDEqDYeU2D20ibhD0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h3E5rz48; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h3E5rz48"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c801ba7685cso1377167a12.1
        for <kvmarm@lists.linux.dev>; Wed, 06 May 2026 05:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778071495; x=1778676295; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+YdK4NbXs+ZsodRXvW6iokqWV0RltJ5UQ3bl9FDyjo=;
        b=h3E5rz48D89OUbW0EDwiJuc2Qrz/p2LSm3rHm43YAexx5jqvBYec0e5Bh2zdMgLtCC
         uW3gFM8Sx13aVBr1pbC+hcMXAzIq/H1os4WYNGrzTOEYoTFzzCV8ulz/n4+lTRzpdmkh
         6Bn57KFzYnCu3eaL/fKrw0lcs+J2NbtGWxvRfABH9z1+IiiCXhJ4bOK2EgqKmV8Txmh5
         wLiR8gNuF9Q+ZdF5ULXB1mFiE7UobvarRklL9dQSbBM3Ws2LFFvZEJwwiMFDfQLtayFo
         248tj8RwVeycuTa2xCzIEQD5OSJGA9pJ/aWWI4J5c9xHlzAxpAMkDiGNS0GtaVrK585Y
         OaJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778071495; x=1778676295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n+YdK4NbXs+ZsodRXvW6iokqWV0RltJ5UQ3bl9FDyjo=;
        b=nv+8dsVlQt1P55d5SUASgvtsWRdSVcxrlj9pyrZ7XWPHuYwOqMkficloNP7w+oYWQ+
         1l9qih8HjbmcKRqKSTOI5LFo/nKz1PaSkkkLT/UPJJ3Nuumws/TjDUggaJ4SzCbq8nw4
         fpObxJuT0CCUAvE8StjOh+zvrnrgL0slu2T/8b9aKvzLJxQfV46P9GL18ZsKtwGZJ6CE
         XvfLNOFFNsJDex+/FdukWYofKlsHHdlAL4ZcxcZDUYuM9tjg1z54DJZemsjtDTrOyckX
         ne9thXkLZXAihs76IDOZgLCXwP6HeJ6nPKFuHS/WdHAAMkcYLAX17Z3AaX2J9KeiuWwJ
         UTCg==
X-Forwarded-Encrypted: i=1; AFNElJ8L7nkguwBd/+FSsKI4Yeo4kK464N5DOeNm59cVov7yMweNnxFMU2PzVkcU3imRG86K54bPbgg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbtdGtn/l7dwkpSrEs3+epb0mN7My1J5FypXb+EGHP1HizEiad
	X6KAbfiJibk56amHLs6tbcWvrPbvU3HfISRfzcXjI7H8xUrw4yr92tdg5vrOxzQhoZJ11O4KHPt
	CGm91mQ==
X-Received: from pgbcx10.prod.google.com ([2002:a05:6a02:220a:b0:c79:22b6:a344])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:549d:b0:3a3:602d:a0d8
 with SMTP id adf61e73a8af0-3aa5a8c5818mr3174269637.17.1778071494440; Wed, 06
 May 2026 05:44:54 -0700 (PDT)
Date: Wed, 6 May 2026 05:44:50 -0700
In-Reply-To: <20260506105053.107404-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260506105053.107404-1-alexandru.elisei@arm.com>
Message-ID: <afs3wp7xBUf2jYK4@google.com>
Subject: Re: [RFC PATCH] KVM: arm64: Align KVM_EXIT_MEMORY_FAULT error codes
 with documentation
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	tabba@google.com, David.Hildenbrand@arm.com
Content-Type: text/plain; charset="us-ascii"

On Wed, May 06, 2026, Alexandru Elisei wrote:
> The documentation for KVM_EXIT_MEMORY_FAULT states:
> 
> 'Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that
> it accompanies a return code of '-1', not '0'!  errno will always be set to
> EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT, userspace
> should assume kvm_run.exit_reason is stale/undefined for all other error
> numbers'.
> 
> where a return code of '-1' is special because according to man 2 ioctl:
> 
> 'On error, -1 is returned, and errno is set to indicate the error'.
> 
> Putting the two together means that the ioctl KVM_RUN must 1) complete with
> an error and 2) that error must must be either EFAULT or EHWPOISON for
> userspace to detect a KVM_EXIT_MEMORY_FAULT VCPU exit.

Yes and no.  The key escape valve we (very deliberately) gave ourselves is this:

  userspace should assume kvm_run.exit_reason is stale/undefined for all other
  error numbers.

As arm64 already does, that clause allows KVM to "speculatively" set exit_reason
to KVM_EXIT_MEMORY_FAULT.  Which is by design.  The userspace flow is intended
to be "if KVM_RUN returns EFAULT or EHWPOISON, then check for KVM_EXIT_MEMORY_FAULT
to see if KVM provided more information about why the EFAULT/EHWPOISON error was
returned".

> On a kvm_gmem_get_pfn() error, gmem_abort() prepares the
> KVM_EXIT_MEMORY_FAULT exit_reason and propagates the error back to
> userspace. kvm_gmem_get_pfn() does not massage the error code, and if the
> error is not -EFAULT or -EHWPOISON, userspace implementing the ABI fails to
> detect the memory fault exit.
> 
> Things get more complicated with kvm_handle_vncr_abort().
> kvm_translate_vncr(), similar to gmem_abort(), prepares the VCPU to exit
> with KVM_EXIT_MEMORY_FAULT and propagates the error code from
> kvm_gmem_get_pfn(). Then kvm_handle_vncr_abort() does a number of things
> based on this specific error code:
> 
> - If it's -EAGAIN, KVM resumes the guest. Note that KVM, when handling a
>   *host* fault on a guest_memfd backed VMA, retries the fault handling if
>   kvm_gmem_get_pfn() returns -EAGAIN.

Totally fine.

> - If it's -ENOMEM, -EFAULT, -EIO or -EHWPOISON, it returns to userspace
>   with 0 (success), meaning that, according to the documentation, userspace
>   will not detect the memory fault exit.

Also totally fine, and working as intended.  KVM_EXIT_MEMORY_FAULT is provided
for scenarios where (a) the issue is likely related to the GPA and (b) userspace
can remedy the underlying issue using the information provided in kvm_run.memory_fault.

ENOMEM doesn't meet (a), and EIO doesn't meet (b) (and probably not (a) in the
vast majority of cases either).

> - If it's -EINVAL, -ENOENT, -EACCESS, KVM injects a synchronous exception
>   back to the guest.
> - If it's -EPERM, KVM injects a permission fault.
> - If the error code is something else, KVM resumes the guest.

All of these are totally fine.  The fact that KVM "scribbled" kvm_run a bit is
a non-issue, because KVM will fill kvm_run with the correct information on the
next userspace exit, or will exit with an error that doesn't utilize kvm_run (in
which case userspace shouldn't be looking at it), or KVM is buggy somewhere else.

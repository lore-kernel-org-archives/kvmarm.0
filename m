Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379772E6D23
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 19:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794087; cv=none; b=rgLKLWximtv36V/zdy26vvXXxvYRUdC3vc8o+iglqNGUAmI7wcclS14pZJELZUVBRnxCRIJIEmsThzt2jtAGNcZixHJVnqHLjZbFtVXlm4aVFcClGx7urk0Dmo1uMFctYQesNIphARafK8FfzmY+x7QyXqtaT/IqLVIWb33qofE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794087; c=relaxed/simple;
	bh=vQBizulpamY6aAnwr2Udqj2t0ugWwP7/x4nvzsw17Cw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sDOGbKd8/GXa/UEpIbTkSVwDr9OGevgF3eXCNmZfVc8Z5sDTN0e1pqX2bG5DTEwcNb+bPJHyocjdMDSunvJXZI7tDwwQVgRBg2acl1elxNMdtuAgIZCzn/2pTeAcy229cEPx/PYas0mpVaJBExzLP4a7y+c/WkUtc2w6EVaMRko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nwVZgfwu; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nwVZgfwu"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7491423658cso3144800b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 12:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794085; x=1751398885; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FUFFiUTwDIQTjkS/XGuKJUupkz/Ptibx0+U0nupMqZk=;
        b=nwVZgfwukqCPruUJrYyjezJ7LXTI9ArcZufrcGA0DMGDh+6hJPZUfF+1C8RZxorA7v
         FqqN8qHog11X+Z+6fWWvYDvk6Lpe1GFOODQYPHmCO+DVVvS/WtvQ6Ob6v8+MAmW6LEMX
         Hrney5sIZxF+p2kopeoaLgbuo7UPGgiB2MCr77XKjLP/EyXlFQ/i7/dm7ZlQpve7fmht
         hIwvhTvaVaQTMtlVwvDDvQ8OTUhLpOc/9fc3Um/TYic+2EG0v1drt/AJn8YYSszP4cxw
         KwVsQcMXW2Bdhs0DXxgZxSu3h1csBHWTrJiOTrbVGan/OAx+/wQiqL2n64c9BkfoRd6J
         lWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794085; x=1751398885;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FUFFiUTwDIQTjkS/XGuKJUupkz/Ptibx0+U0nupMqZk=;
        b=oUE674J3w7ZH5gSXUQN31/P8ngWGSUvTY+Gr8BYtoEVjst2MVVZvxac2dra/VtFLbf
         JGEM6VlNRyCIQgPtNOBT9Guatf2QsRDxWcgnPNsdZAuPMBYv5UR4bwEx6523h2dSi83M
         wrhaQT+fNK3afts2QCcUtCmQKux50qFr0jt/jPAwzHrcBnKwvxnmIFm4EZfjUp4S6Jq0
         PMKgxW+XW+fF60rydjviFN23TWTYZV3R152LKGwpXG8AQI4p7+Z55IQrpRGQnWaDqkpV
         F3XEEeuOtFIBB0CB+R0bb6/xncsxz29SoAwbUGYa1i9/jrMeQ0K9hOo+AzTIlE9c6j7V
         m08g==
X-Forwarded-Encrypted: i=1; AJvYcCXiSqpev662w6Xoyhgq0antVML5VAQw3+5gWnbMtLVNhDnztiMiiYFlIzdYCGLn4RCixHBZ5wc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYC+Naut8UOM344TNqEDBdhS9x33m7UsXGd6oEE9YJYC7dIdd1
	B62U3GcVwlv49EqlZHGNR+JHvcsdRcqX9ZlHbaeT7q1m7H6q0rywEBJ7GHNRDE7Mq0rgzdtkyjB
	zeEdWEQ==
X-Google-Smtp-Source: AGHT+IHYexPIgCTXbHegrNWRwV9PAsICfBY+CW50dlQj/EuWE5JzEYSKqjcY5P3xX5xOKDb9+UElHwxg8eM=
X-Received: from pfrb8.prod.google.com ([2002:aa7:8ec8:0:b0:746:32ae:99d5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:170d:b0:748:1bac:ad5f
 with SMTP id d2e1a72fcca58-74ad455d619mr461113b3a.12.1750794085384; Tue, 24
 Jun 2025 12:41:25 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:26 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079267460.517177.7949210108988821172.b4-ty@google.com>
Subject: Re: [PATCH v3 00/13] KVM: Make irqfd registration globally unique
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 22 May 2025 16:52:10 -0700, Sean Christopherson wrote:
> Non-KVM folks,
> 
> I am hoping to route this through the KVM tree (6.17 or later), as the non-KVM
> changes should be glorified nops.  Please holler if you object to that idea.
> 
> Hyper-V folks in particular, let me know if you want a stable topic branch/tag,
> e.g. on the off chance you want to make similar changes to the Hyper-V code,
> and I'll make sure that happens.
> 
> [...]

Applied to kvm-x86 irqs, thanks!

[01/13] KVM: Use a local struct to do the initial vfs_poll() on an irqfd
        https://github.com/kvm-x86/linux/commit/283ed5001d68
[02/13] KVM: Acquire SCRU lock outside of irqfds.lock during assignment
        https://github.com/kvm-x86/linux/commit/140768a7bf03
[03/13] KVM: Initialize irqfd waitqueue callback when adding to the queue
        https://github.com/kvm-x86/linux/commit/b5c543518ae9
[04/13] KVM: Add irqfd to KVM's list via the vfs_poll() callback
        https://github.com/kvm-x86/linux/commit/5f8ca05ea991
[05/13] KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
        https://github.com/kvm-x86/linux/commit/86e00cd162a7
[06/13] sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
        https://github.com/kvm-x86/linux/commit/867347bb21e1
[07/13] xen: privcmd: Don't mark eventfd waiter as EXCLUSIVE
        https://github.com/kvm-x86/linux/commit/a52664134a24
[08/13] sched/wait: Add a waitqueue helper for fully exclusive priority waiters
        https://github.com/kvm-x86/linux/commit/0d09582b3a60
[09/13] KVM: Disallow binding multiple irqfds to an eventfd with a priority waiter
        https://github.com/kvm-x86/linux/commit/2cdd64cbf990
[10/13] KVM: Drop sanity check that per-VM list of irqfds is unique
        https://github.com/kvm-x86/linux/commit/b599d44a71f1
[11/13] KVM: selftests: Assert that eventfd() succeeds in Xen shinfo test
        https://github.com/kvm-x86/linux/commit/033b76bc7f06
[12/13] KVM: selftests: Add utilities to create eventfds and do KVM_IRQFD
        https://github.com/kvm-x86/linux/commit/74e5e3fb0dd7
[13/13] KVM: selftests: Add a KVM_IRQFD test to verify uniqueness requirements
        https://github.com/kvm-x86/linux/commit/7e9b231c402a

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A7C240242
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736787578; cv=none; b=Zg222ZXoN9mCKAsqzKJAiK34Ihao1JXQWmvtVTHgWbeuRPR+8b+TIhMBl93SF/qHETUu+2OOaWF1QjSnyb6NvqnP9h6/pX+F7WZCEwqf3kpuFSTmkUvUJhY4+7Bb72s02w9Ei8OXGYjHEgBO8xUICaHsXGlgsA2tbJTcHZfEbIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736787578; c=relaxed/simple;
	bh=PXoDtKjpL57QI5TTVIsaHaCrbTm8U8iRsyaErR4Gcrw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZAJ/xFMVc4DZA2GUVFFIxtfehPRHPQJNrb4ihbrATAwC7zP/7PKJcBcQmNKnuyFvhlu4GkW9RksnGnuImmS+gIdDoYptmAdlTswx35urCEHTUOi1YETY+OQrgoTht6Gx2LS57Y9otbd6GOLZ6b5fAilww0sATKoSXwJLNdYEtmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3nUu5z3U; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3nUu5z3U"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166464e236so132811765ad.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 08:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736787576; x=1737392376; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lNi4ttNXrfrXDMynei5+HVfxxr2BRc6T71jVjH9tT8o=;
        b=3nUu5z3UvgIG4ftisc0EO+mTxPHQ3/1qY/3CyzABOe7eDbXBbxqyrnrN7F3a2KfPs8
         nhNbaKMWsXiGsU5jamtcGvYoOAityz0F3W9aPqclYmFoDW/KLPFysngRzSr/6YKrsz2o
         biebS6CtdiMSO3L9QoFIUxTpeDKb0S4RztBMrghek3hqNrqBxvoiPZ9VNQRSv17hEGHO
         ybLspmoV1B6QBPNs4Fx4lV6XkZZhHv3IqG4pjBQh5ZHNVK59K56UPRA83TdgPIi8O02Z
         eyuDE5ih8lUMh+/wekoTp9xuW6t93t0vCL6DO308Wcl8ck8G0Kk6X0BTnzRdqOmlv+wf
         II6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736787576; x=1737392376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lNi4ttNXrfrXDMynei5+HVfxxr2BRc6T71jVjH9tT8o=;
        b=AY3zPVt526+C7ZqQgeqiae7Ecrwsk6baJw98wqyHqZBcRP5f86nlvUmuBqehCRCbgz
         Ne6DY6XDTfYe7LXoIQXKfVHGdEd7oHK/q6gFLaYHA+0vvohOMx2Ruy4Bg8TflNgJsKM0
         H998kUcgu1zyt7nC+QkQVblTgHlBoKGvOILWsahHP9B5/rWaHjovuUukfaKpgsbubT22
         2GQTLX4vXpp9KRPmA7tXyx86yig820yPcSRJ9AWiG+iZRYsVjXwuFa3TfKBcfc1pP6SO
         wEr1pkt93EXxs4e10nQuxAwUfMXL/jHNBeC31kpiqDu7QPzTzFdlcAyE9ix0OWKUBh3r
         rQNg==
X-Forwarded-Encrypted: i=1; AJvYcCXCh8H5xWUXrPyDISNN0bJV+mZhLzFJwtOR9Om/foKa+gzYy2cAuSSw74LGP12WSxpzues8n/8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzt4Sw/xEIFfXEoS6p4Y4s5rTH7CkhfE1PPtmBJQ3oEQkR56CSI
	979Am68HeOVqkafIQuNGwTrZ6/Gd98frUM3pLySP2PbctFPUKLvvW+9agMHDk5KhFyRyG5TlnqU
	Jcg==
X-Google-Smtp-Source: AGHT+IENu5ZK9kPpRwdS1+EeXpR6nVCXMTR+IXJJExBjfsTrkclg65OJwbQ4mKEvtimncd2M4JDnxOz3MCM=
X-Received: from plks12.prod.google.com ([2002:a17:903:2cc:b0:211:fb3b:763b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e74b:b0:215:5ea2:654b
 with SMTP id d9443c01a7336-21a83f3eebemr334554025ad.1.1736787576636; Mon, 13
 Jan 2025 08:59:36 -0800 (PST)
Date: Mon, 13 Jan 2025 08:59:35 -0800
In-Reply-To: <Z4R12HOD1o8ETYzm@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com> <20250111012450.1262638-4-seanjc@google.com>
 <Z4R12HOD1o8ETYzm@intel.com>
Message-ID: <Z4VGdxyswQ6qcKR0@google.com>
Subject: Re: [PATCH 3/5] KVM: Add a common kvm_run flag to communicate an exit
 needs completion
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Chao Gao wrote:
> On Fri, Jan 10, 2025 at 05:24:48PM -0800, Sean Christopherson wrote:
> >Add a kvm_run flag, KVM_RUN_NEEDS_COMPLETION, to communicate to userspace
> >that KVM_RUN needs to be re-executed prior to save/restore in order to
> >complete the instruction/operation that triggered the userspace exit.
> >
> >KVM's current approach of adding notes in the Documentation is beyond
> >brittle, e.g. there is at least one known case where a KVM developer added
> >a new userspace exit type, and then that same developer forgot to handle
> >completion when adding userspace support.
> 
> This answers one question I had:
> https://lore.kernel.org/kvm/Z1bmUCEdoZ87wIMn@intel.com/
> 
> So, it is the VMM's (i.e., QEMU's) responsibility to re-execute KVM_RUN in this
> case.

Yep.

> Btw, can this flag be used to address the issue [*] with steal time accounting?
> We can set the new flag for each vCPU in the PM notifier and we need to change
> the re-execution to handle steal time accounting (not just IO completion).
> 
> [*]: https://lore.kernel.org/kvm/Z36XJl1OAahVkxhl@google.com/

Uh, hmm.  Partially?  And not without creating new, potentially worse problems.

I like the idea, but (a) there's no guarantee a vCPU would be "in" KVM_RUN at
the time of suspend, and (b) KVM would need to take vcpu->mutex in the PM notifier
in order to avoid clobbering the current completion callback, which is definitely
a net negative (hello, deadlocks).

E.g. if a vCPU task is in userspace processing emulated MMIO at the time of
suspend+resume, KVM's completion callback will be non-zero and must be preserved.
And if a vCPU task is in userspace processing an exit that _doesn't_ require
completion, setting KVM_RUN_NEEDS_COMPLETION would likely be missed by userspace,
e.g. if userspace checks the flag only after regaining control from KVM_RUN.

In general, I think setting KVM_RUN_NEEDS_COMPLETION outside of KVM_RUN would add
too much complexity.

> one nit below,
> 
> >--- a/arch/x86/include/uapi/asm/kvm.h
> >+++ b/arch/x86/include/uapi/asm/kvm.h
> >@@ -104,9 +104,10 @@ struct kvm_ioapic_state {
> > #define KVM_IRQCHIP_IOAPIC       2
> > #define KVM_NR_IRQCHIPS          3
> > 
> >-#define KVM_RUN_X86_SMM		 (1 << 0)
> >-#define KVM_RUN_X86_BUS_LOCK     (1 << 1)
> >-#define KVM_RUN_X86_GUEST_MODE   (1 << 2)
> >+#define KVM_RUN_X86_SMM			(1 << 0)
> >+#define KVM_RUN_X86_BUS_LOCK		(1 << 1)
> >+#define KVM_RUN_X86_GUEST_MODE		(1 << 2)
> >+#define KVM_RUN_X86_NEEDS_COMPLETION	(1 << 2)
> 
> This X86_NEEDS_COMPLETION should be dropped. It is never used.

Gah, thanks!

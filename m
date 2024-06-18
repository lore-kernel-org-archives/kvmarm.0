Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76036178370
	for <kvmarm@lists.linux.dev>; Tue, 18 Jun 2024 21:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718746907; cv=none; b=WbU4k01mfuI8DjmWSwb/ItqK9Q7j7ighC7jSJ6yOe/ECd1IKUpX7T2M8ZGAXcYDMLioy509CnvkHCaj3GBzgDI+Dyhi+aHHMxBJjS/xepP6m8T+sTxG65mqNhBsLozg/sRmGm9/y8tf1gYgveit/yihG038SXwW1JlhGOCZtQ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718746907; c=relaxed/simple;
	bh=43VvnWy8bJ3u6vF+ooepWW/K9kvnbb1owJCIeyrqbls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aQQl2JhOzHtEGUA4KyJyPE/c1Z22ARGv3VQu0ieuGlQVmn7kMxL+MKHHt28+2l771jRd5znVC01OkfLsvTR3ZZtP15eE+2CTu6nLS1kDLFoU6pZacxRCO1sZxeNCQaPQ8pGHaOS8BoEWQXvpYhqy98W2dGqDmEcDFpAOoCsDWEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PNAF6SvK; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PNAF6SvK"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62fb4a1f7bfso133707617b3.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Jun 2024 14:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718746904; x=1719351704; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hTMwIVse9Tqfg6lD3BDUhww1E0hJCsQTGAtbBvKYeBQ=;
        b=PNAF6SvKq2wRWQT/Q/axkJFSz0UfyYqp2vodJzV0r/uC+ex3+5f00t4ibUq/TNb60K
         54UEYlm8LTgzGWTiI0pZD6ytIWHA6XdHVSB32vOsoE1ZQBpVQE1p2tos6yEqnaqwJ7MW
         Ukq8g3/nmJ7LIHR48+JIqo4JokIt2ri/hSrnnPmagr65lpiypMs0xyHPTrjAfXZxpMgc
         t1qLci4iu4gr6zvJeGC5i5u4UtNzPuurMOCdxdGk00c7lQ3mcb49Blda+5Vm1P9DDExG
         JcnEWQ2mSo3lnpFN6F39r9C+EeL2b/XusuKCpZljX1IF5fi6K6vBj/4bpyWBXyoo5FBA
         1n4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718746904; x=1719351704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hTMwIVse9Tqfg6lD3BDUhww1E0hJCsQTGAtbBvKYeBQ=;
        b=ABziC/3I5VEXrJWVuhx1rRxy30wjHJ30J7TD342SGAfhU/C1mWi6OG48v3WOwx6Hi5
         SkxcmEiYlY5rswjwj6oDNSNTM/yQS9wvda6hjjrL+bQGBnGBS8yV4roHCxJglE2/lE/A
         rw1e6o/4MLgHZsLqgVBijDiYmxBLrDaxttfGPbhTj0pvdEVwv4UXJLAyBSeyFE/VHOMr
         CrUF7TXb7ui+aG1rd90pfpb40NCMctFw7D29azExS37tI/DgTgerT9qJlyVyi8VxeIbv
         8e0suMgIRCBVknNx558Br/Ir5eWtMgQ4Oh7g6b36jAXjUwYOpqwdTGxgWIauDcBC7u7h
         DbyQ==
X-Forwarded-Encrypted: i=1; AJvYcCViFDpxhj9TcFSeKoO5htpElG0bLAWXwoK/CxBNDg/LLN3ftX2OQKyN4OfFdkDuxKioORRiWDzBxOTkuXuYj/lc6ONzKtAw
X-Gm-Message-State: AOJu0Yxl9SElBVY9bJ7U0QirCEPlAalm6H3d3GTy3hqxheFSLqwaREji
	8PFdBH0UMqv4i1VyFXXGSXoKavd8lRFB/wvZWJkOq63zF6E9UI6wzy95dWGLm/VqJRsfsP988Mj
	zzA==
X-Google-Smtp-Source: AGHT+IEl94B6cPOfd/EKE0+8juuGqXNbimkkhvSQIWkIC7nhtL6RuCNxJoDH3on4HivHNvWvDQFbNJTKAmY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1003:b0:e02:bd4f:def2 with SMTP id
 3f1490d57ef6-e02be20b2ccmr339129276.11.1718746904451; Tue, 18 Jun 2024
 14:41:44 -0700 (PDT)
Date: Tue, 18 Jun 2024 14:41:24 -0700
In-Reply-To: <20240503181734.1467938-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240503181734.1467938-1-dmatlack@google.com>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <171874683295.1901599.10170158200177384059.b4-ty@google.com>
Subject: Re: [PATCH v3 0/3] KVM: Set vcpu->preempted/ready iff scheduled out
 while running
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="utf-8"

On Fri, 03 May 2024 11:17:31 -0700, David Matlack wrote:
> This series changes KVM to mark a vCPU as preempted/ready if-and-only-if
> it's scheduled out while running. i.e. Do not mark a vCPU
> preempted/ready if it's scheduled out during a non-KVM_RUN ioctl() or
> when userspace is doing KVM_RUN with immediate_exit=true.
> 
> This is a logical extension of commit 54aa83c90198 ("KVM: x86: do not
> set st->preempted when going back to user space"), which  stopped
> marking a vCPU as preempted when returning to userspace. But if userspace
> invokes a KVM vCPU ioctl() that gets preempted, the vCPU will be marked
> preempted/ready. This is arguably incorrect behavior since the vCPU was
> not actually preempted while the guest was running, it was preempted
> while doing something on behalf of userspace.
> 
> [...]

Applied to kvm-x86 generic, with minor changelog tweaks (me thinks you've been
away from upstream too long ;-) ).  Thanks!

[1/3] KVM: Introduce vcpu->wants_to_run
      https://github.com/kvm-x86/linux/commit/a6816314af57
[2/3] KVM: Ensure new code that references immediate_exit gets extra scrutiny
      https://github.com/kvm-x86/linux/commit/4b23e0c199b2
[3/3] KVM: Mark a vCPU as preempted/ready iff it's scheduled out while running
      https://github.com/kvm-x86/linux/commit/118964562969

--
https://github.com/kvm-x86/linux/tree/next

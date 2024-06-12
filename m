Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFECA186A
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 01:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718155130; cv=none; b=tGIt6O5AMSq0LkDDdNidwv5XLzz6VuPEGtbz3fZ8PhGDd+cOPaoLUFnSaid/jnYHFUv6NWH02JYvkS9XE5T+MGlW6XrHrfZ4MDNLbSctFB2BKSYhqZWhnlyhjpFcjdgbND1kjiRpQL235E46ji41AFSIuB98M8VbIhav/P6kvHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718155130; c=relaxed/simple;
	bh=NRQ5vxw0MkZ7yLnvDJPYGw9jB/h83t9zD3AKH0/y8IA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HGlxpZu1wyDWF+s9r6dljviYOp0E85+3O5HYQaMXZFRZdPAuqorO2KjkEYkiKOM3ONkAVcsCrUehIQ2KjWb2Y72s3rSm+sxC+bDc6v+wMfHeNENjeLRu65W+HuTueoV7cYG2t8hbRlFvrKV7gzsLXNQyomUSDOy32Rd9MEgwKPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m/Zqi2+k; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m/Zqi2+k"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6ea9b2ecb63so250223a12.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 18:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718155128; x=1718759928; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gH/VrRThVAqNqdnAJ8qqfFFTLj74e8FaAJgriK6mdbo=;
        b=m/Zqi2+k7bLHuSlQ32NNPNLilxaves0nt2M8c5YAI0k15st7SzrQ2CukHedQvzsATE
         rE0P54E8k43sHSaD2vvvnfYo/DfDdAUL4Mps6m5t9SknqNEY5HW/HH3VYCfuoG4wTaAx
         f/XARRU2O2kUoBtLoGOjBPm9J5AnZwCut9DU//67DF1wC9/JU4a/6UIQb0VppUP0TAhF
         UzTOqxmVQYF3fq6CsBJHUayTWk5RFGCX6cXlggWQLK4WmT5DSNhuHD3hdMd9cUCyYOze
         XgjluVSrjavccHYBYQC1fn17sklyMhk7tYOlcmDj458/x/tY57HeD0haF3/Fm4sddYXx
         zuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718155128; x=1718759928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gH/VrRThVAqNqdnAJ8qqfFFTLj74e8FaAJgriK6mdbo=;
        b=IUk+HWWkdx9sExtuIPg5MbdpWowwZFST5w5YCvOntzspd8UrDv4LZPJCSN8QGUSL1i
         A1Yg1hWBtBDRkkK0J+7jq4s88AJfcGsL1mD92eDBJq9zrbQHTi/DcoFIKuW4hM5phEX3
         RT56Pb3fAm51FHWMc4/zRNENLn2CRwbffdWb5oawb+3O5QDe2AbeYuw1ZYeVw83M50IX
         HT+NEs5nfqLush4RlaspJHMxyDzfcn0mBHhV1eOqI3m5JmVYNJxBX5q6x8mmt2ZtkNhX
         pPwjkMHK3kT/GMXwdNO2Utn4IyyVy341oJl0yI90b7L3KygbKY7E1P8Yi0v9dZJ8cRgk
         gJZw==
X-Forwarded-Encrypted: i=1; AJvYcCU5NkUEDS2zg++8wZel0WMK1smiVqn9rw8EWjVBH/pTAI+7+BJA/AKAgPOswpDr9J0qTR3QpX2slU+eHX46k53SgZXxvVT7
X-Gm-Message-State: AOJu0YwrXok6EfT1iWm+m7AgiDqvGPrKWSQAlq0pJO2F7/pM0E4zGkqV
	8ooA9KJ/J953e98YOBBuLakGTqu9g5CuK/NWeojZq9lyXqNds1luDYrKQm+G4QCcWeUdl7pYSmt
	9WQ==
X-Google-Smtp-Source: AGHT+IFA7Nf2gM73IakGhMLgjpKn7tnJ0y7JJoAyUgWaeTxteQw7ecnDkGCPi06xyYh6rqY8tUOLbz5+Rl4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce82:b0:1f7:516:4235 with SMTP id
 d9443c01a7336-1f83b1af087mr431195ad.6.1718155127840; Tue, 11 Jun 2024
 18:18:47 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:18:27 -0700
In-Reply-To: <20240522014013.1672962-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <171813751765.307375.7908491276602596005.b4-ty@google.com>
Subject: Re: [PATCH v2 0/6] KVM: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 21 May 2024 18:40:07 -0700, Sean Christopherson wrote:
> Drop kvm_arch_sched_in() and instead add and use kvm_vcpu.scheduled_out
> to communicate to kvm_arch_vcpu_load() that the vCPU is being scheduling
> back in.
> 
> While fiddling with an idea for optimizing state management on AMD CPUs,
> I wanted to skip re-saving certain host state when a vCPU is scheduled back
> in, as the state (theoretically) shouldn't change for the task while it's
> scheduled out.  Actually doing that was annoying and unnecessarily brittle
> due to having a separate API for the kvm_sched_in() case (the state save
> needed to be in kvm_arch_vcpu_load() for the common path).
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/6] KVM: Add a flag to track if a loaded vCPU is scheduled out
      https://github.com/kvm-x86/linux/commit/d1ae567fb8b5
[2/6] KVM: VMX: Move PLE grow/shrink helpers above vmx_vcpu_load()
      https://github.com/kvm-x86/linux/commit/5d9c07febb86
[3/6] KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
      https://github.com/kvm-x86/linux/commit/8fbb696a8f53
[4/6] KVM: Delete the now unused kvm_arch_sched_in()
      https://github.com/kvm-x86/linux/commit/2a27c4314007
[5/6] KVM: x86: Unconditionally set l1tf_flush_l1d during vCPU load
      https://github.com/kvm-x86/linux/commit/ef2e18ef3750
[6/6] KVM: x86: Drop now-superflous setting of l1tf_flush_l1d in vcpu_run()
      https://github.com/kvm-x86/linux/commit/3dee3b187499

--
https://github.com/kvm-x86/linux/tree/next

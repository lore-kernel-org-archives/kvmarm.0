Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A7238B
	for <kvmarm@lists.linux.dev>; Tue, 30 Jul 2024 22:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378922; cv=none; b=LfXDba6KVPCO1/wtFadRq07jkt9JEdxyX9Iii2XqUOIAq/E9vG0y8ivtyJc3+yW6SXwx/Jj+5GFWahTYXL6b9GaiiPJtlh+dfae4IyFbZD1xyhUrhLejR2YYhXqzh5Y8u5p+z1HL9gxkZhWX8DpiOxAeRNEgq60YWNxNUvBUUu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378922; c=relaxed/simple;
	bh=YFDCChsqaB4UhHP0/2HzjxvaMXC55WBTMkh7IBQDDtE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hLnruuqXmgcT+lCthwUoJzN6RDzvDpBZwGDcRExiovUOWhNEEnsFppUNOy5wlPjKwvk1CJlh7z7bN+hfPss/NUhOEaNgfngfmaptaRsLcrKkPay1TdocOuWy/Umfwc7KLL0+NzgZwe8c8txAhd8RNooYtYzHRerflY2mGA7JXJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dyR82lnw; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dyR82lnw"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d188c9cabso4144936b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Jul 2024 15:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722378920; x=1722983720; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eSOwPlC4K/K4c1NtKrHXJlP1TgjanOwgNCfxP6XzMYQ=;
        b=dyR82lnwmdLl0WcLqcAxWHGW51KIKMIAMkJUUH3tL/oMTnv35dOTKC4TyYQqEOWP9t
         fVgM/5NjUycQkPThxTgBDuzLS9izlsIWj5bnV7TIHEUnfPkH37KaAn7qJ3ufiksq/7kh
         /lmFPrXR/8aJ0xClwW07R4Zmm/JKtrT5pUQkj4ScVR4VOxVaj6cHfR+ejYtsvo7hjWXA
         0tYeXKU/wiFpMHpWms+EYYszMQt47mHeUnkzInEMTtBrdfOGQjGQjj80BZiln2t1rdlC
         LHGDinBLzUpFh1/Gb+v1HmwKo+wnKzY4ci6/1QQhyHywozRcIBLIaNeQIrkddermhi3P
         qQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722378920; x=1722983720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eSOwPlC4K/K4c1NtKrHXJlP1TgjanOwgNCfxP6XzMYQ=;
        b=A2KfnFYglQCJzMrQ43fn64UcZ/V0fbyU97tCjpQlmOO0SDDmLMBB94JV4wBDJ+v09y
         k8Fprg9hGcP9GGnvV/FrzC8ggHhlZaOni+lDRIybqUZW6rGr90NpBHqa0gBVlxiyzLlm
         5fVKbQLnej30+RarDAR6+CwzNDzaLOWelIASBzfYOvPUwsACyuf4AWKotdSVl2uXkTgd
         7L2X7dlY7kmz0anXSPG90IuHEQHUFyb08PLulPUvbd72V0hged3osVJw1645BvIbSF/q
         22u1BXxis3zO1y1gXKIEsLTCZ8Q0zIpntZyASqqIduPeQmlMky1cf55DUyWprSGWund7
         IXGg==
X-Forwarded-Encrypted: i=1; AJvYcCXAW2ArRAN86A+Enk0W7qsBjxFqvn1hGDDAji/7CCj+JSpE3mL4T58abW1/OXFG8EJEXa6Dse7MnLIIy0Lm/8qb0gQe+sNF
X-Gm-Message-State: AOJu0YzhCbLxaiLd/lY3fQ2p97xpYvUh7vbXgLEuuxmxdK4p2V+iX1i5
	udLZ0roh9q8ARPxXdAs8h7+hciHiP7iazd2cCnJ/jq/zmywadExqGWpw6xR8MmswD6qZm5ZI10V
	tLg==
X-Google-Smtp-Source: AGHT+IFhvXMAoVFBOUzUOOlo2Rzlu+lOmmXT/AMKduASO9OrwvfaDw5U6qKsr5Vo6lwrA4+Cjt72+QiZt8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:91c7:b0:710:4d08:e41f with SMTP id
 d2e1a72fcca58-7104d08e48amr716b3a.4.1722378920090; Tue, 30 Jul 2024 15:35:20
 -0700 (PDT)
Date: Tue, 30 Jul 2024 15:35:18 -0700
In-Reply-To: <419ea6ce-83ca-413e-936c-1935e2c51497@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <419ea6ce-83ca-413e-936c-1935e2c51497@redhat.com>
Message-ID: <ZqlqpjO0TiWnOEqx@google.com>
Subject: Re: [PATCH v12 00/84] KVM: Stop grabbing references to PFNMAP'd pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Paolo Bonzini wrote:
> An interesting evolution of the API could be to pass a struct kvm_follow_pfn
> pointer to {,__}kvm_faultin_pfn() and __gfn_to_page() (the "constructors");
> and on the other side to kvm_release_faultin_page() and
> kvm_release_page_*().  The struct kvm_follow_pfn could be embedded in the
> (x86) kvm_page_fault and (generic) kvm_host_map structs.  But certainly not
> as part of this already huge work.

For kvm_faultin_pfn(), my hope/dream is to make kvm_page_fault a common struct,
with an arch member (a la kvm_vcpu), and get to something like:

  static int arch_page_fault_handler(...)
  {
	struct kvm_page_fault fault = {
		<const common stuff>,

		.arch.xxx = <arch stuff>,
	};

	<arch code>


	r = kvm_faultin_pfn();
	
	...
  }

In theory, that would allow moving the kvm->mmu_invalidate_seq handling, memslot
lookup, etc. into kvm_faultin_pfn(), or maybe another helper that is invoked to
setup the fault structure.  I.e. it would give us a way to drive convergence for
at least some of the fault handling logic, without having to tackle gory arch
details, at least not right away.

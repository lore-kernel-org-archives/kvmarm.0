Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53024221570
	for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744999401; cv=none; b=EopHc5BGpkp/FToMLBBhNIRMjIa8FgToOSOT3qlhDYgqdbBahoYLD3b1JraqTVlqnKrL1mdpCSjlmklOz19SaIV5ZJy5N0QEGQckMqlLIYp/RyD0uGl6gSNfnuTYwMOodx1Aet6x5L4TR/a4LN/tOQ8tEq5f9y7TZrHxPYTotzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744999401; c=relaxed/simple;
	bh=1YG7DuypvUO2eH+ZtNma3tnBVmRMdQt3rkXfWDkxfvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JBfj/MVKpRUoaiyz3ER4BVXT/IHUwujdxM9zDR+pJyGvp1MHr14Pk60qtie7Mt/YIUf55qQPWs8caFmoOtCxH36Cx3bVRdr50VLsa3GxZZHAr3S2PbJqIyeG3B8RXTrnPfOUUkjokN8n6oWhkL15qJUYR2V9n0mr0KnjmLeSFO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k+HyNWoS; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k+HyNWoS"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-896c1845cb9so1884137a12.1
        for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 11:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744999399; x=1745604199; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rqJHg5UYMXwn+mNlrL5oxyZCVbhJU0UNvh0766Pzt3w=;
        b=k+HyNWoSpt6KiU1Yqf+q9ZYD4SaLHHfmyPLZTLCOm7s7crLf1+QSWoo0Uksvxigdzm
         /VDXh6LrQR3NyS3HLBwwoDUq1pqhW9MgOgfiVzMUZ5iNPP/XfL4eruKO/Siz2P59OCoV
         BJpwV1NW7SwtFzkzZjmU2XbUqUloMmz+uep2yWnanwwhTkmmP/Htcp1Q7MffbkbAYhCu
         Bym+HeXeh7QGvyt/0GGwCwDAUNzIFRzc+43NrVJ6ThmG0acKx5sZnvrwjXPJejDAh5BZ
         O0xS9iN24xnS15WZiEF+Tg5RZOnCEZJUxPiornZz9GYbAhsC4wcBS4XOqXkcCuakU5hr
         AVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744999399; x=1745604199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rqJHg5UYMXwn+mNlrL5oxyZCVbhJU0UNvh0766Pzt3w=;
        b=iU+GcVK+XrZqO8o1bHD9sk3ZWjzUI0AveuK4UBAkJVPMHF8a5UAkApr7LgOf4Y3xJ5
         MXd/YcoILKQvUjeL1yjU/vdg3QFNAiqRzKkIlO+3+nt1jSbTsbY4kYAWvK+7VagjXxiN
         W7TFk2Ti9COQWODRcN82h1U8GYPpYpsPb0YhVYyRbl0bSa230BDkYs20Ro2TYNRyOI85
         bubObElBQDBUaaecvLhYIf0eynQdFt/CvyWNWsj+2b16T+fBQlIIzl2mXgb7EB0MRWM/
         hdXVBitPeR+WtZllWnb1ZQfkg/wBXcYXQ82QxtaCVjXvKliJWFAHRxtkOqzIeX9WxMTU
         Qv7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWpN5w3xSsbZZqZqE0onovWQVaMbpAeH1WJdK0ulkJjuoq+guNH7Z7uYtQAl7c3C6g/Yf15kEk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjRbrJap+05/rTG9N09gJmA7hk/KoGr2+Kwb3RKh8YNr5OI/AW
	qIzqVNCXHSiMMuFqpPLivUUmk5akndStop8Ws91SEfjho0US94XlacBH2xWOvL4FljN8oKAVzpz
	RCA==
X-Google-Smtp-Source: AGHT+IFCmvZ0T+9eNap/pJTWsl4JOWWblp3uZelMKEtnIjAjt7ekoYrCZmpLXyNDhFs3e4WXHrwgxFD2ZsI=
X-Received: from pjbsn15.prod.google.com ([2002:a17:90b:2e8f:b0:2fa:b84:b308])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18f:b0:2ee:c30f:33c9
 with SMTP id 98e67ed59e1d1-3087c36106amr5592365a91.14.1744999399596; Fri, 18
 Apr 2025 11:03:19 -0700 (PDT)
Date: Fri, 18 Apr 2025 11:03:18 -0700
In-Reply-To: <20250418171609.231588-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250418171609.231588-1-pbonzini@redhat.com>
Message-ID: <aAKT5mLHVV7rz830@google.com>
Subject: Re: [PATCH] KVM: arm64, x86: make kvm_arch_has_irq_bypass() inline
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 18, 2025, Paolo Bonzini wrote:
> kvm_arch_has_irq_bypass() is a small function and even though it does
> not appear in any *really* hot paths, it's also not entirely rare.
> Make it inline---it also works out nicely in preparation for using it in
> kvm-intel.ko and kvm-amd.ko, since the function is not currently exported.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h   | 5 +++++
>  arch/arm64/kvm/arm.c                | 5 -----
>  arch/powerpc/include/asm/kvm_host.h | 2 ++
>  arch/x86/include/asm/kvm_host.h     | 6 ++++++
>  arch/x86/kvm/x86.c                  | 5 -----
>  include/linux/kvm_host.h            | 1 -
>  6 files changed, 13 insertions(+), 11 deletions(-)

...

> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 2d139c807577..6f761b77b813 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -907,4 +907,6 @@ static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
> +bool kvm_arch_has_irq_bypass(void);

...

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 291d49b9bf05..82f044e4b3f5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2383,7 +2383,6 @@ struct kvm_vcpu *kvm_get_running_vcpu(void);
>  struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
>  
>  #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
> -bool kvm_arch_has_irq_bypass(void);

Moving the declaration to PPC is unnecessary, and IMO undesirable.  It's perfectly
legal to have a non-static declaration follow a "static inline", and asm/kvm_host.h
is included by linux/kvm_host.h, i.e. the per-arch "static inline" is guaranteed
to be processed first.

And KVM already have multiple instances of this, e.g. kvm_arch_vcpu_blocking().
If only for consistency, I vote to keep the common declaration.

>  int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
>  			   struct irq_bypass_producer *);
>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
> -- 
> 2.43.5
> 

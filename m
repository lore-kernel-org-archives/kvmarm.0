Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E741DDDC
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 21:50:10 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2682b4ca834so4992112a91.2
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 14:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690840209; x=1691445009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R2QJFD2XHgTI1kJ5wD8vqBTFZZRvLtV3pZ4w1UH3Oa8=;
        b=tSLTmu+DLBufAzFzbicDIcqEm2TuolEf1DapzPi+gTM4FHXli52KWx81A5zuk/YCxr
         l/OlTy/M2QsL/+aaVuZ/hYb5nYSSERYjNp13FI8HYqXm9WQmG25RmZxIsRM/Z7zSspZU
         JeMXBEyXp4E2GhE+/oU7uxeo5vA7VEgDwo3z8s1TIqOjvBy9PB/UOIPUcDQqZ2yvrlDS
         tD1vLJn5szUm3mkfyZtKLdz/qI26XfZV9AjJ3HuKY1kp9JjckDUfZYJ6zw6f2Uc034NJ
         WHPzXkiGbDSZiEmxmUdXhZElFyFTVHyycIhHVC0+v52tpuADk55LDDgQL5cDUbXmgDrC
         Rygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690840209; x=1691445009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R2QJFD2XHgTI1kJ5wD8vqBTFZZRvLtV3pZ4w1UH3Oa8=;
        b=RBQdIHHCS0UYNNMi65j3MLGyeFBe7ymoabupYjJb8pHdm3ij8j9tT4/h+k6Enkn51K
         Qek5e6YhkQhfLTQdEjN6gAwSRGMK0fp3hcf0/Ttv4bZE5r2Aoza+ydh+/ywRQxav4vQ2
         k6NYHyvJzqVo9JEW6l0gu5gUH+K+9rZdJBBijwvPkL6ZLmJOK5TLQ61cKf3qDQy/DgRA
         IhFhzKY4yGQ15JTxz0Wb8Pt4w92f1EaE1s9HyCvRvVvoqgbAqLSXpekBaC2eLKAlJlZO
         NmKCUhd5xnIJetuVZICHpp+p0MIXyZ/2lm/QF0STbwW1F2PcNJDIvRwF4bLdCu3E527W
         Y4wQ==
X-Gm-Message-State: ABy/qLYVF3o7OD+9b2oqPtgCAQrn8hN+n1VmVG/K9XFlvdWrKnTX1cbk
	pMhf86SEHno/lWsDhoKPSh/YrqcYaog=
X-Google-Smtp-Source: APBJJlHF5b1qBy7lIC09fHisk5z7a6GWyFDId8WOrl6w4SB5XD3HwWcrOpZcO/fkStMRmvg1ofrSPaEq5SU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68b:b0:1b8:a552:c8c9 with SMTP id
 l11-20020a170902f68b00b001b8a552c8c9mr47142plg.13.1690840209652; Mon, 31 Jul
 2023 14:50:09 -0700 (PDT)
Date: Mon, 31 Jul 2023 14:50:07 -0700
In-Reply-To: <87tttpr6qy.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-3-rananta@google.com>
 <87tttpr6qy.wl-maz@kernel.org>
Message-ID: <ZMgsjx8dwKd4xBGe@google.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Ananta <rananta@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 27, 2023, Marc Zyngier wrote:
> On Sat, 22 Jul 2023 03:22:41 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> > 
> > Stop depending on CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL and opt to
> > standardize on kvm_arch_flush_remote_tlbs() since it avoids
> > duplicating the generic TLB stats across architectures that implement
> > their own remote TLB flush.
> > 
> > This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
> > path, but that is a small cost in comparison to flushing remote TLBs.
> 
> Well, there is no such thing as a "remote TLB" anyway. We either have
> a non-shareable or inner-shareable invalidation. The notion of remote
> would imply that we track who potentially has a TLB, which we
> obviously don't.

Maybe kvm_arch_flush_vm_tlbs()?  The "remote" part is misleading even on x86 when
running on Hyper-V, as the flush may be done via a single hypercall and by kicking
"remote" vCPUs.

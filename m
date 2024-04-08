Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6A469DF4;
	Mon,  8 Apr 2024 11:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712576725; cv=none; b=LuAwq7ut+rnWH2TpzjJlZCLYwZuLv/JYQoKns1XJA4i1Y9fgtlDWbdF/xnLEUxnSFiRW9xGl5qgtO75/0BFOIXZf+9YvNWdyCyv/aUvPzwhqX657mT9y6azn79Rt2qWQ9Sg0y2hycs0fhHp9fWA89oVjPhMsWLIxg1gNi3hp9H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712576725; c=relaxed/simple;
	bh=Lvr4Q9WQMTuj4LqkHya0HKL9JodxZNBHVeLenTpYopw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oZRsklvg3GP6TqwF9CiN7/yUHBu9skR0megGTZ2XWhE1yW7hk6IFw1Obkd0BfzMzhC4zALfEEOF6VHZPlJChW40vVJbdrAhI5BOnPheqkoYNVtstLBrghR1VVk+txjEBizqVaDK0oIldtfShHecZ107SKnkmP+rC9INC7rk1sgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=h0ErTczH; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="h0ErTczH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1712576721;
	bh=taqzyuzUm+h1dAr9up1EmBlmxQ7Pw3TT7Dqle3r+vfk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=h0ErTczH+J8eOKMVXpItrHYKRUMh+pxxcV6/0CoHG40VtMk6SjHBicTMij8g0QPcl
	 DqWHMNnSfi+fwP5HiCdifsYmHpkp4Xn+DbOgdxU7qWixZBXfw3jqmo2Mf9TSyh+dfR
	 6VbzGd3EpRZksCPRiEZyrpuPnkVP77GEek1dnGxxPTCQfwlANrE42GRZMWo8lTHAps
	 +9qTuFxiU3mHHBuAnio0EBxVUDdvEu22B/D31hrzTZyHyg754PmZ251qNdGHU6OTRk
	 8cDtgXORRLDOqu5a0FunAuYei0U3LrNTqxk35BBWQCXaFVALq9JB3md16kAgiWqViN
	 5wPghIA4bJBwA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VCnMf3rffz4wcF;
	Mon,  8 Apr 2024 21:45:18 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Nicholas Piggin
 <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, Atish Patra
 <atishp@atishpatra.org>, Sean Christopherson <seanjc@google.com>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
In-Reply-To: <20240405115815.3226315-2-pbonzini@redhat.com>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-2-pbonzini@redhat.com>
Date: Mon, 08 Apr 2024 21:45:18 +1000
Message-ID: <87h6gcaxip.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Paolo Bonzini <pbonzini@redhat.com> writes:
> The .change_pte() MMU notifier callback was intended as an
> optimization. The original point of it was that KSM could tell KVM to flip
> its secondary PTE to a new location without having to first zap it. At
> the time there was also an .invalidate_page() callback; both of them were
> *not* bracketed by calls to mmu_notifier_invalidate_range_{start,end}(),
> and .invalidate_page() also doubled as a fallback implementation of
> .change_pte().
>
> Later on, however, both callbacks were changed to occur within an
> invalidate_range_start/end() block.
>
> In the case of .change_pte(), commit 6bdb913f0a70 ("mm: wrap calls to
> set_pte_at_notify with invalidate_range_start and invalidate_range_end",
> 2012-10-09) did so to remove the fallback from .invalidate_page() to
> .change_pte() and allow sleepable .invalidate_page() hooks.
>
> This however made KVM's usage of the .change_pte() callback completely
> moot, because KVM unmaps the sPTEs during .invalidate_range_start()
> and therefore .change_pte() has no hope of finding a sPTE to change.
> Drop the generic KVM code that dispatches to kvm_set_spte_gfn(), as
> well as all the architecture specific implementations.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/arm64/kvm/mmu.c                  | 34 -----------------
>  arch/loongarch/include/asm/kvm_host.h |  1 -
>  arch/loongarch/kvm/mmu.c              | 32 ----------------
>  arch/mips/kvm/mmu.c                   | 30 ---------------
>  arch/powerpc/include/asm/kvm_ppc.h    |  1 -
>  arch/powerpc/kvm/book3s.c             |  5 ---
>  arch/powerpc/kvm/book3s.h             |  1 -
>  arch/powerpc/kvm/book3s_64_mmu_hv.c   | 12 ------
>  arch/powerpc/kvm/book3s_hv.c          |  1 -
>  arch/powerpc/kvm/book3s_pr.c          |  7 ----
>  arch/powerpc/kvm/e500_mmu_host.c      |  6 ---

LGTM.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers

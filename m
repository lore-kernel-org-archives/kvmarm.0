Received: from out-117.mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C1018B18
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 17:37:44 +0000 (UTC)
Date: Mon, 31 Jul 2023 17:37:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690825062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YdaDmAxh2tQ04c65R6HIInMSDgiFElU1rQyABOujGA=;
	b=EX5P5RrbAyGLiUihHg1zPC7oGWSKDM/ElBWxcBqxOnEfqsICZbH2/AKd3VVoNKwHnOFruh
	7NElv6WY+11J1OOCKqt98Yd2d6vWX/LMv7f7kzf3/02EtNU3neXRdqSxXfp5KfexlS5rP8
	7iRednQbNTf1lNnkOTSMwB1k8yGXoT8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH] KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union
Message-ID: <ZMfxYR41K71UV/84@linux.dev>
References: <20230729004144.1054885-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230729004144.1054885-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 28, 2023 at 05:41:44PM -0700, Sean Christopherson wrote:
> Wrap kvm_{gfn,hva}_range.pte in a union so that future notifier events can
> pass event specific information up and down the stack without needing to
> constantly expand and churn the APIs.  Lockless aging of SPTEs will pass
> around a bitmap, and support for memory attributes will pass around the
> new attributes for the range.
> 
> Add a "KVM_NO_ARG" placeholder to simplify handling events without an
> argument (creating a dummy union variable is midly annoying).
> 
> Opportunstically drop explicit zero-initialization of the "pte" field, as
> omitting the field (now a union) has the same effect.
> 
> Cc: Yu Zhao <yuzhao@google.com>
> Link: https://lore.kernel.org/all/CAOUHufagkd2Jk3_HrVoFFptRXM=hX2CV8f+M-dka-hJU4bP8kw@mail.gmail.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Looks good, and I don't think it'll conflict with anything on the arm64
side.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
> 
> If this looks good, my thought is to squeeze it into 6.6 so that the MGLRU
> and guest_memfd() series can build on it.  Or those series could just
> include it?

Eh, I'm not a huge fan of having two series independently reposting a
common base. It can be a bit annoying when the two authors have slightly
different interpretations on how to improve it...

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dfbaafbe3a00..f84ef9399aee 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -526,7 +526,7 @@ typedef void (*on_unlock_fn_t)(struct kvm *kvm);
>  struct kvm_hva_range {
>  	unsigned long start;
>  	unsigned long end;
> -	pte_t pte;
> +	union kvm_mmu_notifier_arg arg;
>  	hva_handler_t handler;
>  	on_lock_fn_t on_lock;
>  	on_unlock_fn_t on_unlock;
> @@ -547,6 +547,8 @@ static void kvm_null_fn(void)
>  }
>  #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
>  
> +static const union kvm_mmu_notifier_arg KVM_NO_ARG;
> +

I'm guessing you were trying to keep this short, but it might be nice to
use MMU_NOTIFIER_ (or similar) as the prefix to make the scope
immediately obvious.

-- 
Thanks,
Oliver

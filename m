Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3A31AA64
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 22:30:11 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d65201b777dso10327433276.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 15:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692138610; x=1692743410;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1sZ2KVcNcsekfiyOLDchFCWiNwVhcB+6K151wSFXsRU=;
        b=Sdk8hg1CZo0UZyPRUXVdkK75UBWBJbL5ssV4qfSNcJ0yLv5eoBjQS4ikTylrgvjRg5
         fAMh6d0O8KCRFHTNCYjLyKwda9Worh9IOHwLdjyjr43jpwYw1T/I0j2MIMowNRlDO5I8
         seJUbGeGRi1534R52LzEYYDDd5ijl0Ycakp7SKP7ACJxBKwO5q+1sd6EI3OyWGK24CgX
         jnL6doBdY30gIbx8RPMUELSJ79bpzsOBy12TJfrWjd52P0gtLnjQyB6B7osJCqozOqtW
         mlUSNNG5Lq0KPPvS7OkMRg41GasfSw3x8Ne19ql/oMstCF4KKqyTw1HO8U30XcK6asyE
         9NgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692138610; x=1692743410;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1sZ2KVcNcsekfiyOLDchFCWiNwVhcB+6K151wSFXsRU=;
        b=HmVW16FxUorQa3wDd4Be/dFA+8+MSvKbeXTl43JCrvmvSxnjrGCyopRG0HTG3SpCgc
         PeNRbaNlwTjy3a1r5eF+HwPWd/eWJ+KO8M59+xwiuRB1NO0UHjg6paP6pdfuD698geLR
         LfcA+VlA40IpPueYSvizId384mWF/wniwuuvPAhFTnvV4TuUKPV/omrppqU3RcLUlzTX
         tFkqJieB1sPonjLB+DUhbU7TwLOi5snZzjLEtB2VU5VeeUi330xbA0F/It71kT/Y/1Qx
         5ErMAb5rAVX3CR17NPzenXN4vquo0UkVQUS3njD86NaWOlDXKOA1MlbdMeNVkXhsGKoG
         JLnA==
X-Gm-Message-State: AOJu0YwZKZFZFw/2d9DcviSoA1MrlPAU285bGLs0n1wypnLOvxzylsFp
	F4KauIqvuQlorXvbgLm+mSGHRjtkQRY=
X-Google-Smtp-Source: AGHT+IG84S1z3EOk6278E7swEnxMzcYiiiMN3uMBAf/Zzr7Ij9WLl4fIHdZlEc+ZYkT7nZQXafm39o4AAu0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:24cc:0:b0:d10:a33d:36b6 with SMTP id
 k195-20020a2524cc000000b00d10a33d36b6mr55769ybk.0.1692138610358; Tue, 15 Aug
 2023 15:30:10 -0700 (PDT)
Date: Tue, 15 Aug 2023 15:30:08 -0700
In-Reply-To: <20230811045127.3308641-6-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com> <20230811045127.3308641-6-rananta@google.com>
Message-ID: <ZNv8cCzI9fMWkGWT@google.com>
Subject: Re: [PATCH v9 05/14] KVM: Allow range-based TLB invalidation from
 common code
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce2..00f7bda9202f2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -278,16 +278,14 @@ static inline bool kvm_available_flush_remote_tlbs_range(void)
>  	return kvm_x86_ops.flush_remote_tlbs_range;
>  }
>  
> -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> -				 gfn_t nr_pages)
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
>  {
>  	int ret = -EOPNOTSUPP;
>  
>  	if (kvm_x86_ops.flush_remote_tlbs_range)
> -		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, start_gfn,
> -								   nr_pages);
> -	if (ret)
> -		kvm_flush_remote_tlbs(kvm);
> +		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
> +
> +	return ret;

Please write this as

	if (kvm_x86_ops.flush_remote_tlbs_range)
		return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);

	return -EOPNOTSUPP;

or alternatively

	if (!kvm_x86_ops.flush_remote_tlbs_range)
		return -EOPNOTSUPP;

	return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);

Hmm, I'll throw my official vote for the second version.

The local "ret" is unnecessary and is suprisingly dangerous.  I screwed up the
conflict resolution when cherry-picking my CONFIG_HYPERV change to see what the
conflict looked like and ended up with a double flush:

	int ret = -EOPNOTSUPP;

	if (kvm_x86_ops.flush_remote_tlbs_range)
		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);

	if (ret)
		kvm_flush_remote_tlbs(kvm);

	return ret;

Dropping "ret" makes it much harder to get trigger happy when resolving conflicts.

No need for a new version to fix the above, assuming Marc/Oliver is ok doing
fixup when applying.

Nit aside, looks good for x86, and I know of no conflicts, so take 'er away!

Acked-by: Sean Christopherson <seanjc@google.com>

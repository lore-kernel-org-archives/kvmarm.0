Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634332AE74
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 08:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949750; cv=none; b=gHbX8GWSWmcwVrU5J5dIsyoTACFwDP0yH5/b45oQhj7cP6u+I2azZ3KV0fye4NVVDTwQM5CfOSrKmx6F8lk+ffVAppKO1qbkQbMaAa1GjEWRavYS3ouiNa1PvCj5BmW+pXtO2UiGyL3E3TXBdPF0FfWrpFnmIqwNtpdbHM3yUMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949750; c=relaxed/simple;
	bh=G3TwnVv2ws+ArFsJ6yylpavyeu3llx2RDNcE+HMxtyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eElgNFxaiUpuK6vdlo9RIfSyxswkKm3/jk3Arkrz/79vPzHYVZRhz324ERuED0xLuUJRPxxys7xmzznF1HkRznrmQdPW9m0QWvzgHSX0KJA4oP6yScjxrIZgcE020R0qn6/F5oLkGk2Pf6cfiXNrUXajnW4cQzTsyp8wFeQKLqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W6calkXs; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W6calkXs"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4aef56cea5bso63361cf.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 01:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949747; x=1754554547; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtgeTLUnQXMXWU42NDS+n+b9sSh//OO5LLzxtMDq45g=;
        b=W6calkXskqoysN8NYZ9TtmH+E+UmRhy2teLx7LDk9KOILv1807Attu0t0u8F4xw8d/
         daQR/NA/67TNecyQlzOq846mAa9xSh2CVSKjLMCRnq0iDJIP2eO7yxRtR1oywaU1Gmo7
         Qt/AlPyVd/h/aAbpykVJ66D8goBAOd0KLJuzIIsvAYU1SNHH7hp3BrEYIFiLm+gFPlf4
         h6DwTYJUSfaUUst8LeLNf5i1KoQmFYuIk5rL7t9cP1jZPno3dfXMVNiGHNTES9y+WZgQ
         ulwIcfFHMCrY/JwHl1vj1CreAas31qVsCusPGv7u6AJRqfgt8RZfk5eS2zt1cxR6nhEC
         68iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949747; x=1754554547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZtgeTLUnQXMXWU42NDS+n+b9sSh//OO5LLzxtMDq45g=;
        b=jFAwqUQvR2zSR1ssavPVlRfkPv4ShCUEa6/+DYag7BPGDTajLPq/Y7NF/BUsFNuocO
         MD6XiPmif2y9TQQAFSqI1SkWmbpuiySA9aDkCWn9KdmUFjMCH324tqh0TlWT0acW4CPp
         NcFTG5/bSUYBnYG16uB4hkw6xs/CKIarBgAPhXMGqD54T4dmTpRFgLtkGaHXZh7+AhAe
         3Y70ML1o/w+41bvP7fAfTVjyyLigDmRf+e57bHI4ZlnNP88UGvjQtfO5e+Ppf5e44zOA
         X9fr0IFQJiVukI0AHN/aghAfAy51HfUIW11nJBDkK/s29kQ4684PY9KRyrnvrdnDuMIy
         51NA==
X-Forwarded-Encrypted: i=1; AJvYcCWkul0n4KCWEfTbF6wMt/daaauB7BhziDJkZKHjuf8KKjemP4eNHmr0f4wAy7DHG2MUzJnekbk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJX73gF51Aw0zfKau0gUxoupSiWTrExm3XxHlyKQsRnRrjiurj
	UYzY2YNEwrmwfMd7piTiTXGOgVwuWTZ3ny5nq2vi2EUrh4rJ1Cp5suC0Y53nyMm5Tibpabemyht
	QqJcrZ9ak7SF4mMw7BGd/i0w9c+VRm8tMOBabDbV/
X-Gm-Gg: ASbGnctuqdoTUYnQ63aZYCGqBqJVK9MZnXMX0d23lVDrTI9oCPb5FMQ4eSS9qXVtxV5
	UMIH7vLMQKzmp+JeofEZlCPcYpiXC2LhgTcP8hGwqE5hc2D0tPcLl6pbRzBTrugpR+4yfanU70t
	a4wMQ8kW1ifkjcMU1IiQTA+GTgdD035FxvlP5UtRZuzEItB2S9EXYGxFzZyQ+yWIckz8dJDykQa
	rbXpwQrp36s1wkiNA==
X-Google-Smtp-Source: AGHT+IF3jlBckt17asL1OJitjRV0KoT4GNPiTrULyMmi9374k00fq9EfEoagert0ixcsHtiWtn0sZ/lfGp2Bbtfgh5k=
X-Received: by 2002:a05:622a:1989:b0:479:1958:d81a with SMTP id
 d75a77b69052e-4aeefd25399mr2200101cf.6.1753949746748; Thu, 31 Jul 2025
 01:15:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-13-seanjc@google.com>
In-Reply-To: <20250729225455.670324-13-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:15:10 +0100
X-Gm-Features: Ac12FXy9BehYhXYWaAAmIrERtbmas51wza3GSdkE_3UpVeAlSRu_uO9i-1FddA8
Message-ID: <CA+EHjTwuXT_wcDAOwwKP+yBetE9N46QMb+hUKAOsxBVkkOgCTw@mail.gmail.com>
Subject: Re: [PATCH v17 12/24] KVM: x86/mmu: Rename .private_max_mapping_level()
 to .gmem_max_mapping_level()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
> in anticipation of extending guest_memfd support to non-private memory.
>
> No functional change intended.
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

nit: remove my "Signed-off-by", since I'm not a co-developer, and instead:

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/include/asm/kvm-x86-ops.h | 2 +-
>  arch/x86/include/asm/kvm_host.h    | 2 +-
>  arch/x86/kvm/mmu/mmu.c             | 2 +-
>  arch/x86/kvm/svm/sev.c             | 2 +-
>  arch/x86/kvm/svm/svm.c             | 2 +-
>  arch/x86/kvm/svm/svm.h             | 4 ++--
>  arch/x86/kvm/vmx/main.c            | 6 +++---
>  arch/x86/kvm/vmx/tdx.c             | 2 +-
>  arch/x86/kvm/vmx/x86_ops.h         | 2 +-
>  9 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 18a5c3119e1a..62c3e4de3303 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -145,7 +145,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP_OPTIONAL(get_untagged_addr)
>  KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
>  KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
> -KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
> +KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
>  KVM_X86_OP_OPTIONAL(gmem_invalidate)
>
>  #undef KVM_X86_OP
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 50366a1ca192..c0a739bf3829 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
>         void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>         int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>         void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> -       int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
> +       int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
>  };
>
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index fdc2824755ee..b735611e8fcd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4532,7 +4532,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>         if (max_level == PG_LEVEL_4K)
>                 return PG_LEVEL_4K;
>
> -       req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
> +       req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>         if (req_max_level)
>                 max_level = min(max_level, req_max_level);
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7744c210f947..be1c80d79331 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>         }
>  }
>
> -int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>         int level, rc;
>         bool assigned;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d9931c6c4bc6..8a66e2e985a4 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5180,7 +5180,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>
>         .gmem_prepare = sev_gmem_prepare,
>         .gmem_invalidate = sev_gmem_invalidate,
> -       .private_max_mapping_level = sev_private_max_mapping_level,
> +       .gmem_max_mapping_level = sev_gmem_max_mapping_level,
>  };
>
>  /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 58b9d168e0c8..d84a83ae18a1 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>  void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> -int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
>  struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
>  void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
>  #else
> @@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
>         return 0;
>  }
>  static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
> -static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>         return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index dbab1c15b0cd..dd7687ef7e2d 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -831,10 +831,10 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>         return tdx_vcpu_ioctl(vcpu, argp);
>  }
>
> -static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>         if (is_td(kvm))
> -               return tdx_gmem_private_max_mapping_level(kvm, pfn);
> +               return tdx_gmem_max_mapping_level(kvm, pfn);
>
>         return 0;
>  }
> @@ -1005,7 +1005,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>         .mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
>         .vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
>
> -       .private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
> +       .gmem_max_mapping_level = vt_op_tdx_only(gmem_max_mapping_level)
>  };
>
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 66744f5768c8..b444714e8e8a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3318,7 +3318,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>         return ret;
>  }
>
> -int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>         return PG_LEVEL_4K;
>  }
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 2b3424f638db..6037d1708485 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
>  void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
> -int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
>  #endif
>
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> --
> 2.50.1.552.g942d659e1b-goog
>

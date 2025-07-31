Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641D71B0439
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 08:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949164; cv=none; b=bqsiG2Vp/iY2nNXe+yBz1mRPt2vvdVidQGCkWYHcVRkAM4Pt3fUbkMJa++CkCtdSEzzw9AccUhL6+hde2022w7rqGOrVBP4r3D49trObxrSYWPqudSNh/dm56guXEP9flG7h80m+RHe05rchYn2mIiGCldNxBF3j/wJ2V+jMsMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949164; c=relaxed/simple;
	bh=Dr25RX5UwdEyT/fw+Vjy8ZCDiwBHn/6iRJwKcG/4Kjw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUoJD7XnEmFyk1fUNRP4OXgcIc0q6+GPs7gwt3Xjt6HXQ1bXRPUVonYQl7pJ9sEF0fVRFbacWP2LVKqHETsrI1yglPAxN5HagbsPnidsmEgnSHlgJUYkNpc2AV7JknT0CrhfGS3vGcwvdODWqr3CCIwbUgWa62OQoXpAcAIO9Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tpVdsQ+0; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tpVdsQ+0"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4aef56cea5bso59921cf.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 01:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949161; x=1754553961; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sX9GbqVIjmwrvhX5OSfDHPFCq4jInN5mZum+NpNw7Gs=;
        b=tpVdsQ+0C8/aiF9zSCRPqoDJ1o+w5tiwiFRLs2+Ls4nVah960RHX8OklDwu/g/VN0f
         6oEixMS9hIlo6zp4y82UTgE/+4jVrkykevtU/Ex3iw77xA5ly/AfcHbfKa6d8LQtooCc
         Q481yXHTWy0AuS6a44kgQiUs3d+mIUDvZR3/S8+/2WkXfADQhhj5sAguqELR8soKJ+My
         wUh+EzF5EUyoPVzzeSlH3gQq4L2TDlkbw9K0r2th2e8xuKDFybV+kG5XomXmxHodWAo3
         3E6+CiJoFKvMUS0fWe6D9kIlogupouq4ypt7rj4RDTEeeUiwI1UBCbTSOwOYN6w5Zr2A
         60bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949161; x=1754553961;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sX9GbqVIjmwrvhX5OSfDHPFCq4jInN5mZum+NpNw7Gs=;
        b=CAtBQegOmKMaTJzHratUEa4QZyNjKmh8kBpTcS3MfOoNwhSw0rEAlD1ywR4YmDnjwm
         5kzFV5oeWDoncZwFswfR1A1H3unyK2VtEgVi1B8xgdJC45DE0IFNQjUK9tsPfTDvqHOb
         OoPAAgCEUYbN1syqRUhW6mzy6LYzrJVRJfb/vCS+J1Jpk2RJ01fTnt+3fsDj9LJMgsKf
         5BuK2iaxB1sR1BRyBeumtazT8wAWwUXRv/tR6ruTAW+vB8GLB6fVsQ0yoi2Vikn3Yy0h
         KZYG1OVOmxj/YSgXaoYe+0A2cJb6u2zgS8T/xzUcZuvM7HD8+JotNdNAQUlgOA7vyM1w
         GLyg==
X-Forwarded-Encrypted: i=1; AJvYcCVAiXRqGkIyMm90qpAMVFmtw2APyRaUt23Y/s6Hi1gMgLu1kJVoSV0Vrz9M4m1Xdq5J78R5HBk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdvTWAgjdUiAO1XVLdi0TRRNvUKcOYqdydEh5aLDjnadtn9Wcv
	JyuKF2U995PIz+VRYMpfwkIXqBRXZjgBaENs22wzKcteEfJdJTdCYr7Zk9Bjuoczjdj1grceIm0
	nVFXtCG85joLqUoPi6E577w/Q7jacBMIN3+vBS5LY
X-Gm-Gg: ASbGnctTsGy0iqWY8Q79OCnCq22ZIxXCb9QVdXunWAXzcFuZzccmWBsp8H1SkFcSk5e
	ibrt+h3KpJ/e6x7oAngA29QTqS7MmdsVkDszvBFvdG4ouiVSGEGNfzSDOvEw520uBeayfNWPXvd
	BloDi9wpAKne2ALJojxCHZd3Ijv3NkmwkSi0rW0iLmygWHjw8Qa5wTAugrcM7eSWPdzbgemxHin
	zhTewow8z7GHsGfXw==
X-Google-Smtp-Source: AGHT+IH4yq+cZN4dHwzK7g8E7DSjy0bGu3xiXGytk3StPe2WtxT21gv+bvGK0jCbJI3gRQMQxRtljt9Le12kOsEdiUI=
X-Received: by 2002:a05:622a:1989:b0:479:1958:d81a with SMTP id
 d75a77b69052e-4aeefd25399mr2167431cf.6.1753949160761; Thu, 31 Jul 2025
 01:06:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-16-seanjc@google.com>
In-Reply-To: <20250729225455.670324-16-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:05:24 +0100
X-Gm-Features: Ac12FXyz8RfnHssTX6SapaASSN1w3XZbMdMXGmxSRe7KK501NuRu89FkBwEbo-Y
Message-ID: <CA+EHjTz0g+Fd-893WYA9+WBhvMvbsrXvFtL3OGa8ohC6DdVbdw@mail.gmail.com>
Subject: Re: [PATCH v17 15/24] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
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
> Rework kvm_mmu_max_mapping_level() to consult guest_memfd for all mappings,
> not just private mappings, so that hugepage support plays nice with the
> upcoming support for backing non-private memory with guest_memfd.
>
> In addition to getting the max order from guest_memfd for gmem-only
> memslots, update TDX's hook to effectively ignore shared mappings, as TDX's
> restrictions on page size only apply to Secure EPT mappings.  Do nothing
> for SNP, as RMP restrictions apply to both private and shared memory.
>
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 12 +++++++-----
>  arch/x86/kvm/svm/sev.c          |  2 +-
>  arch/x86/kvm/svm/svm.h          |  4 ++--
>  arch/x86/kvm/vmx/main.c         |  5 +++--
>  arch/x86/kvm/vmx/tdx.c          |  5 ++++-
>  arch/x86/kvm/vmx/x86_ops.h      |  2 +-
>  7 files changed, 19 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c0a739bf3829..c56cc54d682a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
>         void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>         int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>         void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> -       int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
> +       int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  };
>
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 61eb9f723675..e83d666f32ad 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3302,8 +3302,9 @@ static u8 kvm_max_level_for_order(int order)
>         return PG_LEVEL_4K;
>  }
>
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> -                                       const struct kvm_memory_slot *slot, gfn_t gfn)
> +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +                                    const struct kvm_memory_slot *slot, gfn_t gfn,
> +                                    bool is_private)
>  {
>         u8 max_level, coco_level;
>         kvm_pfn_t pfn;
> @@ -3327,7 +3328,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
>          * restrictions.  A return of '0' means "no additional restrictions", to
>          * allow for using an optional "ret0" static call.
>          */
> -       coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> +       coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
>         if (coco_level)
>                 max_level = min(max_level, coco_level);
>
> @@ -3361,8 +3362,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>         if (max_level == PG_LEVEL_4K)
>                 return PG_LEVEL_4K;
>
> -       if (is_private)
> -               host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +       if (is_private || kvm_memslot_is_gmem_only(slot))
> +               host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> +                                                       is_private);
>         else
>                 host_level = host_pfn_mapping_level(kvm, gfn, slot);
>         return min(host_level, max_level);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index be1c80d79331..807d4b70327a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>         }
>  }
>
> -int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  {
>         int level, rc;
>         bool assigned;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d84a83ae18a1..70df7c6413cf 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>  void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> -int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
>  void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
>  #else
> @@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
>         return 0;
>  }
>  static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
> -static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  {
>         return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index dd7687ef7e2d..bb5f182f6788 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -831,10 +831,11 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>         return tdx_vcpu_ioctl(vcpu, argp);
>  }
>
> -static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +                                    bool is_private)
>  {
>         if (is_td(kvm))
> -               return tdx_gmem_max_mapping_level(kvm, pfn);
> +               return tdx_gmem_max_mapping_level(kvm, pfn, is_private);
>
>         return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b444714e8e8a..ca9c8ec7dd01 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3318,8 +3318,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>         return ret;
>  }
>
> -int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  {
> +       if (!is_private)
> +               return 0;
> +
>         return PG_LEVEL_4K;
>  }
>
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 6037d1708485..4c70f56c57c8 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
>  void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
> -int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  #endif
>
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> --
> 2.50.1.552.g942d659e1b-goog
>

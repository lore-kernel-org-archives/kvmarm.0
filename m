Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C84182AC
	for <kvmarm@lists.linux.dev>; Mon,  6 Nov 2023 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vs/DZJCO"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7781bc3783fso305310185a.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Nov 2023 03:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699268596; x=1699873396; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KU+b2mECXXvQ5slHB7/YEPM4eq1YPpk0J5Rl/yZ7AP8=;
        b=Vs/DZJCOuFej78zSv1e7YmCAS0hSH+/0a/sQveUSHXk4BEEBqipHDFlqZxYXL4+h6X
         pLfp7pN8suh642oRdmOBtlW5/djiskBT8ZIxA40lUxAYsxgYs7wYOKVlfXqa3kAYgKAY
         mDGc5n+E2dL1xp/MxDSyPG1J7hYxjA8pUMdS6ZOeXqW38IqzsP7vF2NlGhceNLQNdyHz
         n5G5ri6lkQFC2xUtzNngOr5ArXolrKja7czx8EKVDSdm68c6Yb8slLG/jJ/bkw6FRDu7
         uH2Zs7MS5wYeUVS7FDSHAiYVs4dvG3bIXMnHw3OOKbIRCJB/pK/RyeZkkzxip1NkbpO3
         zicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268596; x=1699873396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KU+b2mECXXvQ5slHB7/YEPM4eq1YPpk0J5Rl/yZ7AP8=;
        b=gZNOMVAmYBTTmu4jPtkDJ0K3zWZmDfWLP1KuMHQ56Ual7LAM2GAT0osbgqc9UmaF2P
         dwyX61GeRgDuWayCMWFW5ks916GHPKojxQ55uiFg4SqiCf3oFYElycWzIxW/z8m9PYX5
         t7lUdlvag73B3rl6GTpBbLsaT0DIo30pzmOB6x/eFGrELm7wPgylrYSjYl2a8xUiB5Xb
         7knP7xAJLDXSYpZmnwI2Xw+HdD3RRpRnFtoI5aF2HUZL6h9xuaOt6jj39ZSafhvcAid+
         mgxGllN9ekF2PIZzTaOzTnOl3T5E67zCcg/SBh+Z7E/ZGw/pt9mnGMSh4fxsz2NtwGWD
         nmUA==
X-Gm-Message-State: AOJu0YzQcaeHg+fQ7Vf1PfY0zsW1B5/vhbad5+PjMph30zTOIOWoLsUt
	XqQLsvrPsn7+o/9shHrCr7mFlSwi13lw84SEqAvjPw==
X-Google-Smtp-Source: AGHT+IH064K0ZtIRC0Ddcf2wpRdR9qcn5N+rpiGlH1rS/nMIj84KwquVAyvAa55WjBkBZ58J/DOu2Zh9h49soweI3jk=
X-Received: by 2002:a05:6214:2582:b0:671:3493:61e8 with SMTP id
 fq2-20020a056214258200b00671349361e8mr28685929qvb.26.1699268596310; Mon, 06
 Nov 2023 03:03:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-23-pbonzini@redhat.com>
In-Reply-To: <20231105163040.14904-23-pbonzini@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 6 Nov 2023 11:02:40 +0000
Message-ID: <CA+EHjTwB-jssz7+8ZiLgXdQREp8U3r3tYN2NOH28g54=QNdQmg@mail.gmail.com>
Subject: Re: [PATCH 22/34] KVM: selftests: Drop unused kvm_userspace_memory_region_find()
 helper
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 5, 2023 at 4:33=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Drop kvm_userspace_memory_region_find(), it's unused and a terrible API
> (probably why it's unused).  If anything outside of kvm_util.c needs to
> get at the memslot, userspace_mem_region_find() can be exposed to give
> others full access to all memory region/slot information.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20231027182217.3615211-25-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  .../selftests/kvm/include/kvm_util_base.h     |  4 ---
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 -------------------
>  2 files changed, 33 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/=
testing/selftests/kvm/include/kvm_util_base.h
> index a18db6a7b3cf..967eaaeacd75 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -776,10 +776,6 @@ vm_adjust_num_guest_pages(enum vm_guest_mode mode, u=
nsigned int num_guest_pages)
>         return n;
>  }
>
> -struct kvm_userspace_memory_region *
> -kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
> -                                uint64_t end);
> -
>  #define sync_global_to_guest(vm, g) ({                         \
>         typeof(g) *_p =3D addr_gva2hva(vm, (vm_vaddr_t)&(g));     \
>         memcpy(_p, &(g), sizeof(g));                            \
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 7a8af1821f5d..f09295d56c23 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -590,35 +590,6 @@ userspace_mem_region_find(struct kvm_vm *vm, uint64_=
t start, uint64_t end)
>         return NULL;
>  }
>
> -/*
> - * KVM Userspace Memory Region Find
> - *
> - * Input Args:
> - *   vm - Virtual Machine
> - *   start - Starting VM physical address
> - *   end - Ending VM physical address, inclusive.
> - *
> - * Output Args: None
> - *
> - * Return:
> - *   Pointer to overlapping region, NULL if no such region.
> - *
> - * Public interface to userspace_mem_region_find. Allows tests to look u=
p
> - * the memslot datastructure for a given range of guest physical memory.
> - */
> -struct kvm_userspace_memory_region *
> -kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
> -                                uint64_t end)
> -{
> -       struct userspace_mem_region *region;
> -
> -       region =3D userspace_mem_region_find(vm, start, end);
> -       if (!region)
> -               return NULL;
> -
> -       return &region->region;
> -}
> -
>  __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
>  {
>
> --
> 2.39.1
>
>

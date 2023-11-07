Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CCB2FE03
	for <kvmarm@lists.linux.dev>; Tue,  7 Nov 2023 12:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VzvY5wal"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-66d060aa2a4so38561916d6.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Nov 2023 04:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699361687; x=1699966487; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuFbqjfsVCp34XchBGKV0CWjcihho4T2q4FA5kjS7eU=;
        b=VzvY5walL64vn1+MenteOr1gweb6RHf9aQRuN/d/0vTQ5OXPVN8mAcAzer84Az+p1a
         X3iWVk0E8qwRBwHLWUGrSTIw8NXGJ9sepp8mOyPXE5hSb/r1V5L+0ptd1f/EX+jWa/jF
         aseTWVAI8xW2AyqEJxlAidZFIQtmQ9TVymI9A4AuRFSbNeKDabJ6d2J3WJOe4AqZnz+E
         WivK6YLIJ+ia/yiA8J8lNFeFF27kjOboO8Lu8j65gpQFNHsSwBOJLPQR9Yg7yxzthtsS
         X8UImECkV8/iJwE4AI9rSIONSPGVRzpdtNdLb8v3mJHkDQG6J8IR5QwGW8/yBQkKU/at
         T/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699361687; x=1699966487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FuFbqjfsVCp34XchBGKV0CWjcihho4T2q4FA5kjS7eU=;
        b=Bm97miTFahWSGVZhiKWjgdQdHXY9zf3Jt9pSJFi6fyVtjgrEUrqj1msgmHAP0BAY9i
         4TMFMY2y9f5oQe+UiBhJOWaNtEINoxZ1LCviVhKcyxZ0mtJSwcNSgRcKtfDJVIXw33/e
         pTBpK3n5aOl/rSucZARVybCW7CnkScVtW4ziAaCck/3PD+HKI3VK5rZvIbhF8yMchR9b
         cxyLNFu/BvhUunGIuzAPag5OhwKSFASyaRNayscF9xpk33RSW7StkasEQgJYAE3Kfp/j
         oIehq9n8YfZusD6BCLijrMchxZ0x4gPxQocRki7fpductmElsn5JmVA60CgRdRaWFQyi
         DCzw==
X-Gm-Message-State: AOJu0YxFnGksobBRXrXSsC35NpBaJvh0xNMpW54BZGkQahfNko6uTUri
	HSZFYITQZC0P8lCAJb4vJbrkQOXJshg7m4H0fHiHkQ==
X-Google-Smtp-Source: AGHT+IHS9JUkEkC/BybEMf4UmdGXo/DmXLNK4bOT/jrKIAqRMkLyM4gXD6uMK1OzLS09666PL8dXekXtndn5vIwFZqQ=
X-Received: by 2002:a05:6214:260c:b0:66f:bb36:9a51 with SMTP id
 gu12-20020a056214260c00b0066fbb369a51mr33614248qvb.36.1699361687221; Tue, 07
 Nov 2023 04:54:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-31-pbonzini@redhat.com>
In-Reply-To: <20231105163040.14904-31-pbonzini@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 7 Nov 2023 12:54:10 +0000
Message-ID: <CA+EHjTyZoLLv1nRfCEY4nHrbHadphn37jw3OPS17x1dAm_YUxA@mail.gmail.com>
Subject: Re: [PATCH 30/34] KVM: selftests: Add KVM_SET_USER_MEMORY_REGION2 helper
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

On Sun, Nov 5, 2023 at 4:34=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> From: Chao Peng <chao.p.peng@linux.intel.com>
>
> Add helpers to invoke KVM_SET_USER_MEMORY_REGION2 directly so that tests
> can validate of features that are unique to "version 2" of "set user
> memory region", e.g. do negative testing on gmem_fd and gmem_offset.
>
> Provide a raw version as well as an assert-success version to reduce
> the amount of boilerplate code need for basic usage.
>
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20231027182217.3615211-33-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  .../selftests/kvm/include/kvm_util_base.h     |  7 +++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++++++++
>  2 files changed, 36 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/=
testing/selftests/kvm/include/kvm_util_base.h
> index 157508c071f3..8ec122f5fcc8 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -522,6 +522,13 @@ void vm_set_user_memory_region(struct kvm_vm *vm, ui=
nt32_t slot, uint32_t flags,
>                                uint64_t gpa, uint64_t size, void *hva);
>  int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32=
_t flags,
>                                 uint64_t gpa, uint64_t size, void *hva);
> +void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32=
_t flags,
> +                               uint64_t gpa, uint64_t size, void *hva,
> +                               uint32_t guest_memfd, uint64_t guest_memf=
d_offset);
> +int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint3=
2_t flags,
> +                                uint64_t gpa, uint64_t size, void *hva,
> +                                uint32_t guest_memfd, uint64_t guest_mem=
fd_offset);
> +
>  void vm_userspace_mem_region_add(struct kvm_vm *vm,
>         enum vm_mem_backing_src_type src_type,
>         uint64_t guest_paddr, uint32_t slot, uint64_t npages,
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 1c74310f1d44..d05d95cc3693 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -873,6 +873,35 @@ void vm_set_user_memory_region(struct kvm_vm *vm, ui=
nt32_t slot, uint32_t flags,
>                     errno, strerror(errno));
>  }
>
> +int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint3=
2_t flags,
> +                                uint64_t gpa, uint64_t size, void *hva,
> +                                uint32_t guest_memfd, uint64_t guest_mem=
fd_offset)
> +{
> +       struct kvm_userspace_memory_region2 region =3D {
> +               .slot =3D slot,
> +               .flags =3D flags,
> +               .guest_phys_addr =3D gpa,
> +               .memory_size =3D size,
> +               .userspace_addr =3D (uintptr_t)hva,
> +               .guest_memfd =3D guest_memfd,
> +               .guest_memfd_offset =3D guest_memfd_offset,
> +       };
> +
> +       return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION2, &region);
> +}
> +
> +void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32=
_t flags,
> +                               uint64_t gpa, uint64_t size, void *hva,
> +                               uint32_t guest_memfd, uint64_t guest_memf=
d_offset)
> +{
> +       int ret =3D __vm_set_user_memory_region2(vm, slot, flags, gpa, si=
ze, hva,
> +                                              guest_memfd, guest_memfd_o=
ffset);
> +
> +       TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION2 failed, errno =3D =
%d (%s)",
> +                   errno, strerror(errno));
> +}
> +
> +
>  /* FIXME: This thing needs to be ripped apart and rewritten. */
>  void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type=
,
>                 uint64_t guest_paddr, uint32_t slot, uint64_t npages,
> --
> 2.39.1
>
>

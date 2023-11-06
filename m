Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E282518C07
	for <kvmarm@lists.linux.dev>; Mon,  6 Nov 2023 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PcIlVbHe"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-777745f1541so313727485a.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Nov 2023 03:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699270010; x=1699874810; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bcdCS6aA0hU/P/1Lxpxkfas8L67FF+zkKmd2vDLbKHk=;
        b=PcIlVbHeJquFDAf/tqJBWcsYYoogESct90om+lwA3zg6OovTkCclCBRH2B1ob/vmm+
         9H+H1wYm6jLnYsvouFvk1cQeIkfZCefT6YBLRwmL2IxvjmWd+zwNBwzQgThczJ86Vcc/
         hwYYkgHrGM9jCceYfQY4WVHviY5zb/ffyx3MZleQsCH1RRWKmWbkbadK7ZQ6Mf504Qb/
         DnmJGE1SmnDwc+//pM6hGtTqojwv5Zaba0i4F01wiE+UYh6ADETtCum8sEl2Jp+b7/2G
         L9QbvZbFFHKPSo19y94v69dOI0+5HXOvA0A6RSqoDoh9Z6wUODAQ4Du0uS8xdGfpXXAo
         /mQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699270010; x=1699874810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bcdCS6aA0hU/P/1Lxpxkfas8L67FF+zkKmd2vDLbKHk=;
        b=ECXEntBoIrCKIwN4VLX/7LJrIq9CgBRV8XVmqWV1BGU3+6yhXEA39pAL4lPZXZ3zOh
         XK7d4zyZBoZhQ+UxA4ccJM3sCw9jiXOnuL4y+sIj6x3fXk31vuxCNrobqqFaCkXftye7
         ZCCGJ5RobfSsGUSIyOix8zCWbEOa+AoEI11d2CxwKHsvQbzjWEyDbZkSQI6EOzR1OOdL
         kUYM2vRQLTU9dn65sl3L61bgaho7StYvNP51+xEs1aw8zHNlWSHRxmYmR3a9VOS7s1CC
         quA08As5ImQflzVMDBoar7mzO6WeHP0gRWfbUn6DiJ2zWt8onCELAHzvDXLbAvHaLytr
         t0bA==
X-Gm-Message-State: AOJu0Yx0dKAEydTImFy/Geev9YzgNuY/qiTG93vEuMnPxMSNAKN5kWbn
	tsyCOswkoFp3N/xR+Zf7TiQSXONm3Ubed7tG4PeYvA==
X-Google-Smtp-Source: AGHT+IFasxLYHHudhBN/+4eIX1OsOhIRfSB2CWnjQO7Y6r4dz1/Ca+R2Pv6YHi7+A5fsQfNYO2/OlOsYvWwG9CsrzMM=
X-Received: by 2002:a05:6214:2506:b0:658:26d7:72e0 with SMTP id
 gf6-20020a056214250600b0065826d772e0mr20208405qvb.4.1699270009660; Mon, 06
 Nov 2023 03:26:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-28-seanjc@google.com>
In-Reply-To: <20231027182217.3615211-28-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 6 Nov 2023 11:26:13 +0000
Message-ID: <CA+EHjTyjeKymYaJ3kTpVzRFPLKxeDEf9B-DGo7xif_FPN1dFBQ@mail.gmail.com>
Subject: Re: [PATCH v13 27/35] KVM: selftests: Add helpers to convert guest
 memory b/w private and shared
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
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
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 7:23=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> From: Vishal Annapurve <vannapurve@google.com>
>
> Add helpers to convert memory between private and shared via KVM's
> memory attributes, as well as helpers to free/allocate guest_memfd memory
> via fallocate().  Userspace, i.e. tests, is NOT required to do fallocate(=
)
> when converting memory, as the attributes are the single source of true.

true->truth

> Provide allocate() helpers so that tests can mimic a userspace that frees
> private memory on conversion, e.g. to prioritize memory usage over
> performance.
>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 48 +++++++++++++++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 28 +++++++++++
>  2 files changed, 76 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/=
testing/selftests/kvm/include/kvm_util_base.h
> index 9f861182c02a..1441fca6c273 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -333,6 +333,54 @@ static inline void vm_enable_cap(struct kvm_vm *vm, =
uint32_t cap, uint64_t arg0)
>         vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
>  }
>
> +static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t =
gpa,
> +                                           uint64_t size, uint64_t attri=
butes)
> +{
> +       struct kvm_memory_attributes attr =3D {
> +               .attributes =3D attributes,
> +               .address =3D gpa,
> +               .size =3D size,
> +               .flags =3D 0,
> +       };
> +
> +       /*
> +        * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These =
flows
> +        * need significant enhancements to support multiple attributes.
> +        */
> +       TEST_ASSERT(!attributes || attributes =3D=3D KVM_MEMORY_ATTRIBUTE=
_PRIVATE,
> +                   "Update me to support multiple attributes!");
> +
> +       vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
> +}
> +
> +
> +static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
> +                                     uint64_t size)
> +{
> +       vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIV=
ATE);
> +}
> +
> +static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
> +                                    uint64_t size)
> +{
> +       vm_set_memory_attributes(vm, gpa, size, 0);
> +}
> +
> +void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t si=
ze,
> +                           bool punch_hole);
> +
> +static inline void vm_guest_mem_punch_hole(struct kvm_vm *vm, uint64_t g=
pa,
> +                                          uint64_t size)
> +{
> +       vm_guest_mem_fallocate(vm, gpa, size, true);
> +}
> +
> +static inline void vm_guest_mem_allocate(struct kvm_vm *vm, uint64_t gpa=
,
> +                                        uint64_t size)
> +{
> +       vm_guest_mem_fallocate(vm, gpa, size, false);
> +}
> +
>  void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
>  const char *vm_guest_mode_string(uint32_t i);
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 45050f54701a..a140aee8d0f5 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1176,6 +1176,34 @@ void vm_mem_region_delete(struct kvm_vm *vm, uint3=
2_t slot)
>         __vm_mem_region_delete(vm, memslot2region(vm, slot), true);
>  }
>
> +void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t s=
ize,
> +                           bool punch_hole)
> +{
> +       const int mode =3D FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_=
PUNCH_HOLE : 0);
> +       struct userspace_mem_region *region;
> +       uint64_t end =3D base + size;
> +       uint64_t gpa, len;
> +       off_t fd_offset;
> +       int ret;
> +
> +       for (gpa =3D base; gpa < end; gpa +=3D len) {
> +               uint64_t offset;
> +
> +               region =3D userspace_mem_region_find(vm, gpa, gpa);
> +               TEST_ASSERT(region && region->region.flags & KVM_MEM_PRIV=
ATE,
> +                           "Private memory region not found for GPA 0x%l=
x", gpa);
> +
> +               offset =3D (gpa - region->region.guest_phys_addr);

nit: why the parentheses?

> +               fd_offset =3D region->region.guest_memfd_offset + offset;
> +               len =3D min_t(uint64_t, end - gpa, region->region.memory_=
size - offset);
> +
> +               ret =3D fallocate(region->region.guest_memfd, mode, fd_of=
fset, len);
> +               TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len =
=3D %lu), fd =3D %d, mode =3D %x, offset =3D %lx\n",
> +                           punch_hole ? "punch hole" : "allocate", gpa, =
len,
> +                           region->region.guest_memfd, mode, fd_offset);
> +       }
> +}
> +

Nits aside:

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  /* Returns the size of a vCPU's kvm_run structure. */
>  static int vcpu_mmap_sz(void)
>  {
> --
> 2.42.0.820.g83a721a137-goog
>

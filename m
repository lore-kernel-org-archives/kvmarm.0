Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427731DE4D2
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 08:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749197699; cv=none; b=sqXHXSh3yha7pbs52Q3xYXOlUmYWmm48CovDTGBcPTQf8fvmhutuGFgGlrR9g4m1dfejh4aDIDYuEa68+nsz95qEUd4bApqC9Qcji/nAefgOOgtlPMAfUGmpYkz2OPxVZwAxCHedvIINlG/YtQz2RfIZXSV3f2bILmNspBX1RrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749197699; c=relaxed/simple;
	bh=Sx2kRoA6540IBjmVa8iRjeggrCjDOHKI0hKp9zXnYLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fHwPBQ0HI5fwj8l5EciTB8/7GeBH1/IFnOlPv2pSJ7JDlHISdFTYZFoJxtNqfTnYynJSkLF7iGEGsPI0wS+wy34c7Z4ZnIowHHfXgiYl55tDF1Yzs6aZArHi1SZworUw/GA8q1KTY6BxdH+nMnmg1QBqclRWeH16o63ZnQyNREA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=acPmlNX+; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="acPmlNX+"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4a5ac8fae12so317271cf.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 01:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749197696; x=1749802496; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZ2a17s14DiwVXH5n9E8Jz+5/4EfpoYvUq0sk56Onz0=;
        b=acPmlNX+bpz9SDou2AOBUfl4hZ5d1cvbhdIt8mIJD/uFV7nfFXrM42RGmpQA9mWJQo
         mhFAR/CDtMS36MqHQq8WV4fKswTwF7A+NWzPEeygnWUmbj7zT7Tuu2b8qfa0p6hniuar
         D8AVCCT3dKqRK3xTow/bjEDB8f5dZQkRLijAxj1BkRyW6yvl5jzZfuCYlQd1OFbypDfP
         dLFATx8uhPF2po85dFSLobRTG6Q/Wvjy0Ab7wFKNMgSg5RE9hu2D8a9Ia6C7z1EnOkEN
         sheWUV+ntRQu/dvdF6jNimTr68Ys8yD9G/Psag95o5AuRU4Z+/5uy+Yt8WTA4GbySp18
         K8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749197696; x=1749802496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZ2a17s14DiwVXH5n9E8Jz+5/4EfpoYvUq0sk56Onz0=;
        b=HoGnMw8yHoToWlVTOey/OEOd943ttISiuieQLqLY7UJo82uzCuj5XLaxOvM3u/+OMK
         zjugkbphO4ZIgrOrm4DStBydpZ0I4F+hCAM8gztbxnjPrcmcS6NcgxXsDTA6m7NkrV8I
         jB3InDyDirJKYbj/Bu+dVLQRTH00WpUvBoBhoURlzdnie2QcGNjVZ/7PfoM9RAC7hLu1
         ooSv+tmLoX6AvASFdpebPm1cmVh8N9IvqX1iNUGT2cFucu1Rh2y4zCiOjG22CjsHjm1W
         zyfFeuf1NsCZ4mP+qzxgT12wKCPRhk+M3EBar3pGQ+ORjvTt7/j6C9p7zaaWzXxEZcfP
         ksWA==
X-Forwarded-Encrypted: i=1; AJvYcCXbQlJGjgsIkmHHl04LEPUiJUEGZKdAXnQopykMMLQDrmNiz1r4jX9ZfzWQaxT5F/bpCwX0GWo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDTygLEUEWU2rxSf3DlytCnJ7XkPf6ozaUV2rdnJm2G0rZRzJN
	ULvEy7myr0J+ffNfJAfiuC2Y0VxQZsazS6zXYUIJwS1EbbBGQ15qDkelpVxlz6MiZtiIRraYS4P
	IUZPHizu/Dzvtv9Kcf+iEHdyLAR0TWJ2QVxFOKt54
X-Gm-Gg: ASbGncuie7ORUUb3u8kLDcMdjLUZCZCklUFm8uVxRZ4RmPjkXOKleSHSlxv6/FuVOSx
	G4FI++aQrneKILv0sN3txuwBgEb+JB2KNPsahpGfj/EU7/Vmgk7eMsgZaSLcrIU85XJbK4Zkrei
	vq2+BK+ESI/sA0EVowI4OQD5ORps8HR6ToqhAMW+CZpuE=
X-Google-Smtp-Source: AGHT+IHO3XbI99LEJ3DkrIqbK0UHqQBaguugDetIvvefVbiU0bjl6q1UARSnYMvGmv4Bofkpu6UiMgfxhbQchzD7XrI=
X-Received: by 2002:a05:622a:4d4e:b0:480:1561:837f with SMTP id
 d75a77b69052e-4a5baa64ae4mr3422191cf.8.1749197695571; Fri, 06 Jun 2025
 01:14:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-19-tabba@google.com>
 <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com>
In-Reply-To: <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Jun 2025 09:14:18 +0100
X-Gm-Features: AX0GCFsF3bQ5ds5aybr1LYz7ilc6jmBKMPt-OX1Muc1KZq58VsL5O8r4L0rcIBQ
Message-ID: <CA+EHjTwHgAoGos+ZBzEPdkNPzLpX9t8nJLQ89YALPUw4LK4QTA@mail.gmail.com>
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 5 Jun 2025 at 23:07, James Houghton <jthoughton@google.com> wrote:
>
> On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrot=
e:
> >
> > Expand the guest_memfd selftests to include testing mapping guest
> > memory for VM types that support it.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Feel free to add:
>
> Reviewed-by: James Houghton <jthoughton@google.com>

Thanks!

> > ---
> >  .../testing/selftests/kvm/guest_memfd_test.c  | 201 ++++++++++++++++--
> >  1 file changed, 180 insertions(+), 21 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/tes=
ting/selftests/kvm/guest_memfd_test.c
> > index 341ba616cf55..1612d3adcd0d 100644
> > --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> > +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> > @@ -13,6 +13,8 @@
> >
> >  #include <linux/bitmap.h>
> >  #include <linux/falloc.h>
> > +#include <setjmp.h>
> > +#include <signal.h>
> >  #include <sys/mman.h>
> >  #include <sys/types.h>
> >  #include <sys/stat.h>
> > @@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
> >                     "pwrite on a guest_mem fd should fail");
> >  }
> >
> > -static void test_mmap(int fd, size_t page_size)
> > +static void test_mmap_supported(int fd, size_t page_size, size_t total=
_size)
> > +{
> > +       const char val =3D 0xaa;
> > +       char *mem;
>
> This must be `volatile char *` to ensure that the compiler doesn't
> elide the accesses you have written.
>
> > +       size_t i;
> > +       int ret;
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIV=
ATE, fd, 0);
> > +       TEST_ASSERT(mem =3D=3D MAP_FAILED, "Copy-on-write not allowed b=
y guest_memfd.");
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHAR=
ED, fd, 0);
> > +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest memor=
y should succeed.");
> > +
> > +       memset(mem, val, total_size);
>
> Now unfortunately, `memset` and `munmap` will complain about the
> volatile qualification. So...
>
> memset((char *)mem, val, total_size);
>
> Eh... wish they just wouldn't complain, but this is a small price to
> pay for correctness. :)
>
> > +       for (i =3D 0; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
>
> The compiler is allowed to[1] elide the read of `mem[i]` and just
> assume that it is `val`.
>
> [1]: https://godbolt.org/z/Wora54bP6
>
> Feel free to add `volatile` to that snippet to see how the code changes.

Having tried that and Sean's READ_ONCE() suggestion, I went with the
latter. Like Sean said, they're not optimised out, and avoid the need
to cast.

> > +
> > +       ret =3D fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOL=
E, 0,
> > +                       page_size);
> > +       TEST_ASSERT(!ret, "fallocate the first page should succeed.");
> > +
> > +       for (i =3D 0; i < page_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], 0x00);
> > +       for (; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
> > +
> > +       memset(mem, val, page_size);
> > +       for (i =3D 0; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
> > +
> > +       ret =3D munmap(mem, total_size);
> > +       TEST_ASSERT(!ret, "munmap() should succeed.");
> > +}
> > +
> > +static sigjmp_buf jmpbuf;
> > +void fault_sigbus_handler(int signum)
> > +{
> > +       siglongjmp(jmpbuf, 1);
> > +}
> > +
> > +static void test_fault_overflow(int fd, size_t page_size, size_t total=
_size)
> > +{
> > +       struct sigaction sa_old, sa_new =3D {
> > +               .sa_handler =3D fault_sigbus_handler,
> > +       };
> > +       size_t map_size =3D total_size * 4;
> > +       const char val =3D 0xaa;
> > +       char *mem;
>
> `volatile` here as well.
>
> > +       size_t i;
> > +       int ret;
> > +
> > +       mem =3D mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED=
, fd, 0);
> > +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest memor=
y should succeed.");
> > +
> > +       sigaction(SIGBUS, &sa_new, &sa_old);
> > +       if (sigsetjmp(jmpbuf, 1) =3D=3D 0) {
> > +               memset(mem, 0xaa, map_size);
> > +               TEST_ASSERT(false, "memset() should have triggered SIGB=
US.");
> > +       }
> > +       sigaction(SIGBUS, &sa_old, NULL);
> > +
> > +       for (i =3D 0; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
> > +
> > +       ret =3D munmap(mem, map_size);
> > +       TEST_ASSERT(!ret, "munmap() should succeed.");
> > +}
> > +
> > +static void test_mmap_not_supported(int fd, size_t page_size, size_t t=
otal_size)
> >  {
> >         char *mem;
> >
> >         mem =3D mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARE=
D, fd, 0);
> >         TEST_ASSERT_EQ(mem, MAP_FAILED);
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHAR=
ED, fd, 0);
> > +       TEST_ASSERT_EQ(mem, MAP_FAILED);
> >  }
> >
> >  static void test_file_size(int fd, size_t page_size, size_t total_size=
)
> > @@ -120,26 +193,19 @@ static void test_invalid_punch_hole(int fd, size_=
t page_size, size_t total_size)
> >         }
> >  }
> >
> > -static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> > +static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
> > +                                                 uint64_t guest_memfd_=
flags,
> > +                                                 size_t page_size)
> >  {
> > -       size_t page_size =3D getpagesize();
> > -       uint64_t flag;
> >         size_t size;
> >         int fd;
> >
> >         for (size =3D 1; size < page_size; size++) {
> > -               fd =3D __vm_create_guest_memfd(vm, size, 0);
> > -               TEST_ASSERT(fd =3D=3D -1 && errno =3D=3D EINVAL,
> > +               fd =3D __vm_create_guest_memfd(vm, size, guest_memfd_fl=
ags);
> > +               TEST_ASSERT(fd < 0 && errno =3D=3D EINVAL,
> >                             "guest_memfd() with non-page-aligned page s=
ize '0x%lx' should fail with EINVAL",
> >                             size);
> >         }
> > -
> > -       for (flag =3D BIT(0); flag; flag <<=3D 1) {
> > -               fd =3D __vm_create_guest_memfd(vm, page_size, flag);
> > -               TEST_ASSERT(fd =3D=3D -1 && errno =3D=3D EINVAL,
> > -                           "guest_memfd() with flag '0x%lx' should fai=
l with EINVAL",
> > -                           flag);
> > -       }
> >  }
> >
> >  static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
> > @@ -171,30 +237,123 @@ static void test_create_guest_memfd_multiple(str=
uct kvm_vm *vm)
> >         close(fd1);
> >  }
> >
> > -int main(int argc, char *argv[])
> > +static bool check_vm_type(unsigned long vm_type)
> >  {
> > -       size_t page_size;
> > +       /*
> > +        * Not all architectures support KVM_CAP_VM_TYPES. However, tho=
se that
> > +        * support guest_memfd have that support for the default VM typ=
e.
> > +        */
> > +       if (vm_type =3D=3D VM_TYPE_DEFAULT)
> > +               return true;
> > +
> > +       return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
> > +}
> > +
> > +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd=
_flags,
> > +                          bool expect_mmap_allowed)
> > +{
> > +       struct kvm_vm *vm;
> >         size_t total_size;
> > +       size_t page_size;
> >         int fd;
> > -       struct kvm_vm *vm;
> >
> > -       TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> > +       if (!check_vm_type(vm_type))
> > +               return;
> >
> >         page_size =3D getpagesize();
> >         total_size =3D page_size * 4;
> >
> > -       vm =3D vm_create_barebones();
> > +       vm =3D vm_create_barebones_type(vm_type);
> >
> > -       test_create_guest_memfd_invalid(vm);
> >         test_create_guest_memfd_multiple(vm);
> > +       test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, pa=
ge_size);
> >
> > -       fd =3D vm_create_guest_memfd(vm, total_size, 0);
> > +       fd =3D vm_create_guest_memfd(vm, total_size, guest_memfd_flags)=
;
> >
> >         test_file_read_write(fd);
> > -       test_mmap(fd, page_size);
> > +
> > +       if (expect_mmap_allowed) {
> > +               test_mmap_supported(fd, page_size, total_size);
> > +               test_fault_overflow(fd, page_size, total_size);
> > +
> > +       } else {
> > +               test_mmap_not_supported(fd, page_size, total_size);
> > +       }
> > +
> >         test_file_size(fd, page_size, total_size);
> >         test_fallocate(fd, page_size, total_size);
> >         test_invalid_punch_hole(fd, page_size, total_size);
> >
> >         close(fd);
> > +       kvm_vm_release(vm);
>
> I think kvm_vm_free() is probably more appropriate?

Ack (for both).

Cheers,
/fuad

> > +}
> > +
> > +static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
> > +                                           uint64_t expected_valid_fla=
gs)
> > +{
> > +       size_t page_size =3D getpagesize();
> > +       struct kvm_vm *vm;
> > +       uint64_t flag =3D 0;
> > +       int fd;
> > +
> > +       if (!check_vm_type(vm_type))
> > +               return;
> > +
> > +       vm =3D vm_create_barebones_type(vm_type);
> > +
> > +       for (flag =3D BIT(0); flag; flag <<=3D 1) {
> > +               fd =3D __vm_create_guest_memfd(vm, page_size, flag);
> > +
> > +               if (flag & expected_valid_flags) {
> > +                       TEST_ASSERT(fd >=3D 0,
> > +                                   "guest_memfd() with flag '0x%lx' sh=
ould be valid",
> > +                                   flag);
> > +                       close(fd);
> > +               } else {
> > +                       TEST_ASSERT(fd < 0 && errno =3D=3D EINVAL,
> > +                                   "guest_memfd() with flag '0x%lx' sh=
ould fail with EINVAL",
> > +                                   flag);
> > +               }
> > +       }
> > +
> > +       kvm_vm_release(vm);
>
> Same here.
>
> > +}
> > +
> > +static void test_gmem_flag_validity(void)
> > +{
> > +       uint64_t non_coco_vm_valid_flags =3D 0;
> > +
> > +       if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
> > +               non_coco_vm_valid_flags =3D GUEST_MEMFD_FLAG_SUPPORT_SH=
ARED;
> > +
> > +       test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_va=
lid_flags);
> > +
> > +#ifdef __x86_64__
> > +       test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, non_co=
co_vm_valid_flags);
> > +       test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
> > +       test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
> > +       test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
> > +       test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
> > +#endif
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> > +
> > +       test_gmem_flag_validity();
> > +
> > +       test_with_type(VM_TYPE_DEFAULT, 0, false);
> > +       if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> > +               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_SUPPOR=
T_SHARED,
> > +                              true);
> > +       }
> > +
> > +#ifdef __x86_64__
> > +       test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
> > +       if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> > +               test_with_type(KVM_X86_SW_PROTECTED_VM,
> > +                              GUEST_MEMFD_FLAG_SUPPORT_SHARED, true);
> > +       }
> > +#endif
> >  }
> > --
> > 2.49.0.1266.g31b7d2e469-goog
> >

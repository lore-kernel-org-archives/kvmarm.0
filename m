Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2DC10963
	for <kvmarm@lists.linux.dev>; Tue,  7 Nov 2023 14:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C9UNFwp+"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-66d0760cd20so47365636d6.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Nov 2023 06:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699367972; x=1699972772; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9yWUxtco4+SHtMfDkrQFL/rv2xiDn8sNB7VvrAl+j00=;
        b=C9UNFwp+Mu/b8BRyKHrQlTr+WAdvGuIPpR4vwPAbbGdwZ2tUjJaVty2k6bsu9fnCtT
         /XWbzU5ni+fF/zrzq3XBuyKymBKvrSFu0FF6IKWv0Cq1B7AEzT/cHF5745J19jexdLpp
         nU1R4ttbaZo728yhflwSvOCeOHXf/viCJq6APC8tNeh8P9xzAVfUj85FEynEg6o6obfa
         wO3VYp3Ht5w8SUAytAKhvWvLdPebDD2a67Mcu6HqT8lCLIC1hvp0RoLdKgI0IsGtGQil
         JBZd0usa3GWKs2/vx2LxWokvmBGUyl1kpiZa6q1U54g7ItsRObpiY7zJtnsv3CJHhuAj
         VIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699367972; x=1699972772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9yWUxtco4+SHtMfDkrQFL/rv2xiDn8sNB7VvrAl+j00=;
        b=QZJK7hC1yG4SltE8LOpkVOS5phsJUwyRKzOovNkSG16AbV8y8D5r2ajKDT9d2KoEzX
         bK1Dp3dWXoUI4QHeeKh11ZE1XLmX5/YJqHd5yb9XXIR/yfwjmCD7LyMXwtK+6hfzguAK
         fHnvZK+ltKkGDbDCpG3htMBymyO8kRopvBrb5HuooQOJH5hDaVgiqEWNCbd/C2jjq8SY
         4sxNlt6KhtNr71OUghxYxtVC1gRkg7g9wV8mxEZDsrcoYqfxu+kWDpmNo/OXe3QasTSG
         s19CVk/rmha6tmYPG1zqkHv4PsgOptc8NowMuKgZhMsEvsBPE4Nie3fanU3LIJXcbmQ/
         9W1w==
X-Gm-Message-State: AOJu0YzOCQjJ+0QuHvI5bWnh7Uq1DUrC5PeXDa7Hvk7onINTOqeAfLPM
	Knpx/cJOj7qNc7GRlqNhims4fNkZg7DQeKaVUwb+4w==
X-Google-Smtp-Source: AGHT+IENouhYwfq0zksB9smEGLB+VMdhNNrCcscvQWBkeUX0Zkluj03/Xo1edckn4e3jUv+DeKenqbsHwG9y+w7RhbQ=
X-Received: by 2002:a05:6214:5297:b0:66f:abb4:49ff with SMTP id
 kj23-20020a056214529700b0066fabb449ffmr3397127qvb.7.1699367972171; Tue, 07
 Nov 2023 06:39:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-34-pbonzini@redhat.com>
In-Reply-To: <20231105163040.14904-34-pbonzini@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 7 Nov 2023 14:38:55 +0000
Message-ID: <CA+EHjTw4C-3E+V0WsC68DtKRjqCt+d7M=q3STM48fKHiy4GvSw@mail.gmail.com>
Subject: Re: [PATCH 33/34] KVM: selftests: Test KVM exit behavior for private memory/access
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

On Sun, Nov 5, 2023 at 4:35=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> "Testing private access when memslot gets deleted" tests the behavior
> of KVM when a private memslot gets deleted while the VM is using the
> private memslot. When KVM looks up the deleted (slot =3D NULL) memslot,
> KVM should exit to userspace with KVM_EXIT_MEMORY_FAULT.
>
> In the second test, upon a private access to non-private memslot, KVM
> should also exit to userspace with KVM_EXIT_MEMORY_FAULT.

nit: The commit message is referring to private memslots, which might
need rewording with the latest changes in v14.

> Intentionally don't take a requirement on KVM_CAP_GUEST_MEMFD,
> KVM_CAP_MEMORY_FAULT_INFO, KVM_MEMORY_ATTRIBUTE_PRIVATE, etc., as it's a
> KVM bug to advertise KVM_X86_SW_PROTECTED_VM without its prerequisites.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> [sean: call out the similarities with set_memory_region_test]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20231027182217.3615211-36-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/x86_64/private_mem_kvm_exits_test.c   | 120 ++++++++++++++++++
>  2 files changed, 121 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/private_mem_kvm_ex=
its_test.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index fd3b30a4ca7b..69ce8e06b3a3 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -92,6 +92,7 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/nested_exceptions_tes=
t
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/platform_info_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/pmu_event_filter_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/private_mem_conversions_test
> +TEST_GEN_PROGS_x86_64 +=3D x86_64/private_mem_kvm_exits_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/set_boot_cpu_id
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/set_sregs_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/smaller_maxphyaddr_emulation_test
> diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_tes=
t.c b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
> new file mode 100644
> index 000000000000..2f02f6128482
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
> @@ -0,0 +1,120 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2022, Google LLC.

nit: 2023

Nits aside:
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad




> + */
> +#include <linux/kvm.h>
> +#include <pthread.h>
> +#include <stdint.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +
> +/* Arbitrarily selected to avoid overlaps with anything else */
> +#define EXITS_TEST_GVA 0xc0000000
> +#define EXITS_TEST_GPA EXITS_TEST_GVA
> +#define EXITS_TEST_NPAGES 1
> +#define EXITS_TEST_SIZE (EXITS_TEST_NPAGES * PAGE_SIZE)
> +#define EXITS_TEST_SLOT 10
> +
> +static uint64_t guest_repeatedly_read(void)
> +{
> +       volatile uint64_t value;
> +
> +       while (true)
> +               value =3D *((uint64_t *) EXITS_TEST_GVA);
> +
> +       return value;
> +}
> +
> +static uint32_t run_vcpu_get_exit_reason(struct kvm_vcpu *vcpu)
> +{
> +       int r;
> +
> +       r =3D _vcpu_run(vcpu);
> +       if (r) {
> +               TEST_ASSERT(errno =3D=3D EFAULT, KVM_IOCTL_ERROR(KVM_RUN,=
 r));
> +               TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MEMORY_FA=
ULT);
> +       }
> +       return vcpu->run->exit_reason;
> +}
> +
> +const struct vm_shape protected_vm_shape =3D {
> +       .mode =3D VM_MODE_DEFAULT,
> +       .type =3D KVM_X86_SW_PROTECTED_VM,
> +};
> +
> +static void test_private_access_memslot_deleted(void)
> +{
> +       struct kvm_vm *vm;
> +       struct kvm_vcpu *vcpu;
> +       pthread_t vm_thread;
> +       void *thread_return;
> +       uint32_t exit_reason;
> +
> +       vm =3D vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
> +                                          guest_repeatedly_read);
> +
> +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +                                   EXITS_TEST_GPA, EXITS_TEST_SLOT,
> +                                   EXITS_TEST_NPAGES,
> +                                   KVM_MEM_GUEST_MEMFD);
> +
> +       virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
> +
> +       /* Request to access page privately */
> +       vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
> +
> +       pthread_create(&vm_thread, NULL,
> +                      (void *(*)(void *))run_vcpu_get_exit_reason,
> +                      (void *)vcpu);
> +
> +       vm_mem_region_delete(vm, EXITS_TEST_SLOT);
> +
> +       pthread_join(vm_thread, &thread_return);
> +       exit_reason =3D (uint32_t)(uint64_t)thread_return;
> +
> +       TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
> +       TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLA=
G_PRIVATE);
> +       TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
> +       TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
> +
> +       kvm_vm_free(vm);
> +}
> +
> +static void test_private_access_memslot_not_private(void)
> +{
> +       struct kvm_vm *vm;
> +       struct kvm_vcpu *vcpu;
> +       uint32_t exit_reason;
> +
> +       vm =3D vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
> +                                          guest_repeatedly_read);
> +
> +       /* Add a non-private memslot (flags =3D 0) */
> +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +                                   EXITS_TEST_GPA, EXITS_TEST_SLOT,
> +                                   EXITS_TEST_NPAGES, 0);
> +
> +       virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
> +
> +       /* Request to access page privately */
> +       vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
> +
> +       exit_reason =3D run_vcpu_get_exit_reason(vcpu);
> +
> +       TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
> +       TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLA=
G_PRIVATE);
> +       TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
> +       TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
> +
> +       kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PRO=
TECTED_VM));
> +
> +       test_private_access_memslot_deleted();
> +       test_private_access_memslot_not_private();
> +}
> --
> 2.39.1
>
>

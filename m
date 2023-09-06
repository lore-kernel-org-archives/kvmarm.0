Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAA962B
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 01:24:10 +0000 (UTC)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2bd6611873aso48400091fa.1
        for <kvmarm@lists.linux.dev>; Tue, 05 Sep 2023 18:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693963448; x=1694568248; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xfJSGXD8vBLM08q729zBD/9glpH/PWMQ0GciStqljw=;
        b=m1U34WmmP2BxEc1dbY8yAetSUe4D4pDQmG5fpDwbXjvzMpMVRYTjULPjUT/96ZHQ7d
         UiD90Yx7nXNIIleLhhg2vSaaElO6oHSkD2/KO9adqxp5sNDKx4SeSk42mjna1xshjQdY
         JDOJJg4tl9jdfJur25BcV4oxt8JvkPHtKbuebmSIJfTlM06G7qcLY35aSz8NZ/tmI5fN
         3EY5qswOA1W5Rrnr78Yt3D9nWP+AnptyhpUvKdzRF1F5wZsKy2e1vpBQI8D/hs67jX67
         1wKvGsnVtWajAVtCtf+8qoRVodyKNdBwO3c0O58Fju76xuLCoowhr/OTNhPgI82OYAmI
         Cw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693963448; x=1694568248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xfJSGXD8vBLM08q729zBD/9glpH/PWMQ0GciStqljw=;
        b=f3Z5X/6ChFcjDwm8bjWsQZtntgusMGoQ/Haz73xrIWSMDBeAlUHEJ0bZt6oqk6uHMb
         8t5dVg2TICuwdNxpDPGOiGDdVRxjUfL3xvJBc3oVxx2kNCiJkrRWLnh8XRI0fLbC+mYY
         y3gB7nxYPx6BwrBg7EGrI1KAHYL/anePfmOKHSdw463y/PQulAH7/4ZIFiQxIP+F/9/S
         30Vej8wOxFE3pUQh0jvwwcgUcnij4OZQxNlDLaayookH9z5BPSqYIkYUf05XtHyLsGj4
         aeJ0akbLuuXA1FxbA/KB4FUoNe7/oBnM+hyItLQPZmU1aZ8u/Z4uGjhryv0DxZC8IYSF
         axVg==
X-Gm-Message-State: AOJu0YxdIOSpZLMtzExgHfeytxuEwo2rOrVxMqQGesNy5mP916PxwBnr
	80ddrPceP6P8acN4hYiCutYde5xQHRp1kiKJ7Vc=
X-Google-Smtp-Source: AGHT+IEZAtSdfv2O9kOnOodcd6ZENRRHvHNIg7rIlF/apuuxioXnbEufFM1mW11nwPy+FUp/gWhTnrfWfFZLNg5iXcI=
X-Received: by 2002:a2e:7204:0:b0:2bc:fb79:d165 with SMTP id
 n4-20020a2e7204000000b002bcfb79d165mr1109276ljc.39.1693963447866; Tue, 05 Sep
 2023 18:24:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <20230905-eb7998dbd945ed9dd12659ea@orel>
In-Reply-To: <20230905-eb7998dbd945ed9dd12659ea@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 6 Sep 2023 09:23:56 +0800
Message-ID: <CAJve8o=Oz9m_t3tZOFgxo41Ss+dz-kLHU5Y44ov=JjZs3Jyaew@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] RISCV: Add kvm Sstc timer selftest
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	wchen <waylingii@gmail.com>, Greentime Hu <greentime.hu@sifive.com>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, David Matlack <dmatlack@google.com>, 
	Mingwei Zhang <mizhang@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Lei Wang <lei4.wang@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Peter Gonda <pgonda@google.com>, Thomas Huth <thuth@redhat.com>, 
	Like Xu <likexu@tencent.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 5, 2023 at 6:36=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> Hi Haibo,
>
> Some of your patch summaries say 'selftest' instead of 'selftests'. Pleas=
e
> correct those for the next version.
>

Sure, thanks for pointing that out!

> Thanks,
> drew
>
> On Sat, Sep 02, 2023 at 08:59:22PM +0800, Haibo Xu wrote:
> > The RISC-V arch_timer selftest is used to validate Sstc timer
> > functionality in a guest, which sets up periodic timer interrupts
> > and check the basic interrupt status upon its receipt.
> >
> > This KVM selftest was ported from aarch64 arch_timer and tested
> > with Linux v6.5-rc5 on a Qemu riscv64 virt machine.
> >
> > ---
> > Changed since v1:
> >   * Rebase to kvm-riscv/riscv_kvm_next
> >   * Cherry-pick Sean's kselftest guest printf patch set
> >     https://lore.kernel.org/all/20230729003643.1053367-1-seanjc@google.=
com/
> >   * Copy the entire csr.h verbatim
> >   * Unified the function names for exception vector table setup
> >     void vm_init_vector_tables(struct kvm_vm *vm);
> >     void vcpu_init_vector_tables(struct kvm_vcpu *vcpu);
> >   * Format the handler.S asm file per Andrew's comments
> >   * Consolidate the timer test code for arm64 and riscv
> >     based on Andrew's and Sean's suggestion
> >
> > Haibo Xu (8):
> >   KVM: selftests: Unify the codes for guest exception handling
> >   KVM: arm64: selftest: Split arch_timer test code
> >   tools: riscv: Add header file csr.h
> >   KVM: riscv: selftests: Switch to use macro from csr.h
> >   KVM: riscv: selftests: Add exception handling support
> >   KVM: riscv: selftests: Add guest helper to get vcpu id
> >   KVM: riscv: selftest: Change vcpu_has_ext to a common function
> >   KVM: riscv: selftests: Add sstc timer test
> >
> >  tools/arch/riscv/include/asm/csr.h            | 521 ++++++++++++++++++
> >  tools/testing/selftests/kvm/Makefile          |  11 +-
> >  .../selftests/kvm/aarch64/arch_timer.c        | 292 +---------
> >  .../selftests/kvm/aarch64/debug-exceptions.c  |   4 +-
> >  .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
> >  .../testing/selftests/kvm/aarch64/vgic_irq.c  |   4 +-
> >  tools/testing/selftests/kvm/arch_timer.c      | 261 +++++++++
> >  .../selftests/kvm/include/aarch64/processor.h |  12 +-
> >  .../selftests/kvm/include/kvm_util_base.h     |   9 +
> >  .../selftests/kvm/include/riscv/arch_timer.h  |  80 +++
> >  .../selftests/kvm/include/riscv/processor.h   |  60 +-
> >  .../selftests/kvm/include/timer_test.h        |  58 ++
> >  .../selftests/kvm/include/x86_64/processor.h  |   5 -
> >  .../selftests/kvm/lib/aarch64/processor.c     |   6 +-
> >  .../selftests/kvm/lib/riscv/handlers.S        | 101 ++++
> >  .../selftests/kvm/lib/riscv/processor.c       |  86 +++
> >  .../selftests/kvm/lib/x86_64/processor.c      |   4 +-
> >  .../testing/selftests/kvm/riscv/arch_timer.c  | 130 +++++
> >  .../selftests/kvm/riscv/get-reg-list.c        |  14 -
> >  tools/testing/selftests/kvm/x86_64/amx_test.c |   4 +-
> >  .../selftests/kvm/x86_64/fix_hypercall_test.c |   4 +-
> >  .../selftests/kvm/x86_64/hyperv_evmcs.c       |   4 +-
> >  .../selftests/kvm/x86_64/hyperv_features.c    |   8 +-
> >  .../testing/selftests/kvm/x86_64/hyperv_ipi.c |   6 +-
> >  .../selftests/kvm/x86_64/kvm_pv_test.c        |   4 +-
> >  .../selftests/kvm/x86_64/monitor_mwait_test.c |   4 +-
> >  .../kvm/x86_64/pmu_event_filter_test.c        |   8 +-
> >  .../smaller_maxphyaddr_emulation_test.c       |   4 +-
> >  .../selftests/kvm/x86_64/svm_int_ctl_test.c   |   4 +-
> >  .../kvm/x86_64/svm_nested_shutdown_test.c     |   4 +-
> >  .../kvm/x86_64/svm_nested_soft_inject_test.c  |   4 +-
> >  .../kvm/x86_64/ucna_injection_test.c          |   8 +-
> >  .../kvm/x86_64/userspace_msr_exit_test.c      |   4 +-
> >  .../vmx_exception_with_invalid_guest_state.c  |   4 +-
> >  .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |   4 +-
> >  .../selftests/kvm/x86_64/xapic_ipi_test.c     |   4 +-
> >  .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |   4 +-
> >  .../selftests/kvm/x86_64/xen_shinfo_test.c    |   4 +-
> >  38 files changed, 1376 insertions(+), 376 deletions(-)
> >  create mode 100644 tools/arch/riscv/include/asm/csr.h
> >  create mode 100644 tools/testing/selftests/kvm/arch_timer.c
> >  create mode 100644 tools/testing/selftests/kvm/include/riscv/arch_time=
r.h
> >  create mode 100644 tools/testing/selftests/kvm/include/timer_test.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/riscv/handlers.S
> >  create mode 100644 tools/testing/selftests/kvm/riscv/arch_timer.c
> >
> > --
> > 2.34.1
> >

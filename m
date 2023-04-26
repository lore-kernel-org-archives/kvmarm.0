Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B326ADC
	for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682538400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vSr52G4zlg8DfNeN6fOnKgdJw7y+ySKAE/n/2yKiqlg=;
	b=a/pvKUTeJV7v4JRC0YxwckEYbdH30/wG/IfVv5/Z8XVQ0s9XIfxgul5fIyBK8tK46GlShz
	OfS3o4VjKpXIxPkUJgtjh2ez9Q5MfpNMxApxd4vLoNpQoeDImRJJqh7Aq/rKp9dgxvVz0w
	KciF4PTMEmUEr4Kpk6wuVNNAHJKXo9s=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-mgPzxNtnMn6NOgO9t3B0vw-1; Wed, 26 Apr 2023 15:46:39 -0400
X-MC-Unique: mgPzxNtnMn6NOgO9t3B0vw-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-771792aa6bcso2027879241.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 12:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538398; x=1685130398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vSr52G4zlg8DfNeN6fOnKgdJw7y+ySKAE/n/2yKiqlg=;
        b=fl3X0wO83idqpkb2sFer/9Z7GNpkKs7/nDanQGlw8xBxHXyz+DipBCiFdbjswq3Gjg
         8wL1GWbd/Nu6+zAfX6I9ft9ygcEsC5oX0UHk3gpnBm25nNK3xLLAJ7IvO6GsVDoq8Jwn
         SLEwgPPG43HbaWCJ6rKnLIED+uo6oZFc+rBRdRBhcdha/sSoOpmtGx0qAOMx9AT8kLBC
         MKhHfa6+DaE72O99FCUkb3WNh5pF7FBRGsmDOuhhJ2+44CSqAFvGE3mie4Op+tsNvU1+
         NiijU6IuZ8w7pU77l8Q4hIMbIahwFBiYa2zuikrC2yWhXBlG+2uNn+M4wxlLWDckD50n
         Et8A==
X-Gm-Message-State: AAQBX9dbXKmAHGrt63+ljUJUS5n0BYJozRuaoPbb/68PekyaGfnmfaZ5
	Bjzdtsahxn4JEpMLjB0ey8Qd+AarMHsDl63xWrama89SffVTd+pze82pa5rS/4SjOfQY0Rd1VDJ
	k9XWkpN1vUYKRdxK9bqSYKhFE/FqfzNoz
X-Received: by 2002:a05:6102:356a:b0:42f:fae5:3b98 with SMTP id bh10-20020a056102356a00b0042ffae53b98mr8964394vsb.14.1682538398268;
        Wed, 26 Apr 2023 12:46:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z/uUM8A1aq6a3CFzFBs418t4Q1bWSEphk+cg1XMVRNt4S/GZCjPVW4/1MX/0YMIGZ2ONTUk9dh9BOYt/iAPQw=
X-Received: by 2002:a05:6102:356a:b0:42f:fae5:3b98 with SMTP id
 bh10-20020a056102356a00b0042ffae53b98mr8964382vsb.14.1682538397947; Wed, 26
 Apr 2023 12:46:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230421104005.3017731-1-maz@kernel.org>
In-Reply-To: <20230421104005.3017731-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Apr 2023 21:46:26 +0200
Message-ID: <CABgObfY63ytE8EOxpYQ39v8ptFtJJZxeoa4jmcoFA0UQ9+jsuw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for v6.4
To: Marc Zyngier <maz@kernel.org>
Cc: Christoffer Dall <christoffer.dall@arm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	Colton Lewis <coltonlewis@google.com>, Jeremy Linton <jeremy.linton@arm.com>, 
	Mark Brown <broonie@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Reiji Watanabe <reijiw@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 21, 2023 at 12:40=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Hi Paolo,
>
> Here's the initial set of changes for KVM/arm64. A bunch of
> infrastructure changes this time around, with two new user
> visible changes (hypercall forwarding to userspace, global counter
> offset) and a large set of locking inversion fixes.
>
> The remaining of the patches contain the NV timer emulation code, and
> a small set of less important fixes/improvements.
>
> Please pull,

Queued, thanks!  I assume I'll get -rc pull requests from you as well
over the next two months?

Paolo

>        M.
>
> The following changes since commit 197b6b60ae7bc51dd0814953c562833143b292=
aa:
>
>   Linux 6.3-rc4 (2023-03-26 14:40:20 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-6.4
>
> for you to fetch changes up to 36fe1b29b3cae48f781011abd5a0b9e938f5b35f:
>
>   Merge branch kvm-arm64/spec-ptw into kvmarm-master/next (2023-04-21 09:=
44:58 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 updates for 6.4
>
> - Numerous fixes for the pathological lock inversion issue that
>   plagued KVM/arm64 since... forever.
>
> - New framework allowing SMCCC-compliant hypercalls to be forwarded
>   to userspace, hopefully paving the way for some more features
>   being moved to VMMs rather than be implemented in the kernel.
>
> - Large rework of the timer code to allow a VM-wide offset to be
>   applied to both virtual and physical counters as well as a
>   per-timer, per-vcpu offset that complements the global one.
>   This last part allows the NV timer code to be implemented on
>   top.
>
> - A small set of fixes to make sure that we don't change anything
>   affecting the EL1&0 translation regime just after having having
>   taken an exception to EL2 until we have executed a DSB. This
>   ensures that speculative walks started in EL1&0 have completed.
>
> - The usual selftest fixes and improvements.
>
> ----------------------------------------------------------------
> Colin Ian King (1):
>       KVM: selftests: Fix spelling mistake "KVM_HYPERCAL_EXIT_SMC" -> "KV=
M_HYPERCALL_EXIT_SMC"
>
> Marc Zyngier (33):
>       KVM: arm64: timers: Use a per-vcpu, per-timer accumulator for fract=
ional ns
>       arm64: Add CNTPOFF_EL2 register definition
>       arm64: Add HAS_ECV_CNTPOFF capability
>       KVM: arm64: timers: Use CNTPOFF_EL2 to offset the physical timer
>       KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
>       KVM: arm64: Expose {un,}lock_all_vcpus() to the rest of KVM
>       KVM: arm64: timers: Allow userspace to set the global counter offse=
t
>       KVM: arm64: timers: Allow save/restoring of the physical timer
>       KVM: arm64: timers: Rationalise per-vcpu timer init
>       KVM: arm64: timers: Abstract per-timer IRQ access
>       KVM: arm64: timers: Move the timer IRQs into arch_timer_vm_data
>       KVM: arm64: Elide kern_hyp_va() in VHE-specific parts of the hyperv=
isor
>       KVM: arm64: timers: Fast-track CNTPCT_EL0 trap handling
>       KVM: arm64: timers: Abstract the number of valid timers per vcpu
>       KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
>       KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
>       KVM: arm64: nv: timers: Support hyp timer emulation
>       KVM: arm64: selftests: Add physical timer registers to the sysreg l=
ist
>       KVM: arm64: selftests: Deal with spurious timer interrupts
>       KVM: arm64: selftests: Augment existing timer test to handle variab=
le offset
>       KVM: arm64: Expose SMC/HVC width to userspace
>       KVM: arm64: nvhe: Synchronise with page table walker on vcpu run
>       KVM: arm64: Handle 32bit CNTPCTSS traps
>       KVM: arm64: nvhe: Synchronise with page table walker on TLBI
>       KVM: arm64: pkvm: Document the side effects of kvm_flush_dcache_to_=
poc()
>       KVM: arm64: vhe: Synchronise with page table walker on MMU update
>       KVM: arm64: vhe: Drop extra isb() on guest exit
>       Merge branch kvm-arm64/lock-inversion into kvmarm-master/next
>       Merge branch kvm-arm64/timer-vm-offsets into kvmarm-master/next
>       Merge branch kvm-arm64/selftest/lpa into kvmarm-master/next
>       Merge branch kvm-arm64/selftest/misc-6.4 into kvmarm-master/next
>       Merge branch kvm-arm64/smccc-filtering into kvmarm-master/next
>       Merge branch kvm-arm64/spec-ptw into kvmarm-master/next
>
> Mark Brown (1):
>       KVM: selftests: Comment newly defined aarch64 ID registers
>
> Oliver Upton (20):
>       KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
>       KVM: arm64: Avoid lock inversion when setting the VM register width
>       KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
>       KVM: arm64: Use config_lock to protect vgic state
>       KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
>       KVM: arm64: Add a helper to check if a VM has ran once
>       KVM: arm64: Add vm fd device attribute accessors
>       KVM: arm64: Rename SMC/HVC call handler to reflect reality
>       KVM: arm64: Start handling SMCs from EL1
>       KVM: arm64: Refactor hvc filtering to support different actions
>       KVM: arm64: Use a maple tree to represent the SMCCC filter
>       KVM: arm64: Add support for KVM_EXIT_HYPERCALL
>       KVM: arm64: Introduce support for userspace SMCCC filtering
>       KVM: arm64: Return NOT_SUPPORTED to guest for unknown PSCI version
>       KVM: arm64: Let errors from SMCCC emulation to reach userspace
>       KVM: selftests: Add a helper for SMCCC calls with SMC instruction
>       KVM: selftests: Add test for SMCCC filter
>       KVM: arm64: Prevent userspace from handling SMC64 arch range
>       KVM: arm64: Test that SMC64 arch calls are reserved
>       KVM: arm64: vgic: Don't acquire its_lock before config_lock
>
> Reiji Watanabe (2):
>       KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init(=
)
>       KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE() to update mp_s=
tate
>
> Ryan Roberts (3):
>       KVM: selftests: Fixup config fragment for access_tracking_perf_test
>       KVM: selftests: arm64: Fix pte encode/decode for PA bits > 48
>       KVM: selftests: arm64: Fix ttbr0_el1 encoding for PA bits > 48
>
>  Documentation/virt/kvm/api.rst                     |  71 ++-
>  Documentation/virt/kvm/devices/vm.rst              |  79 +++
>  arch/arm64/include/asm/kvm_host.h                  |  25 +-
>  arch/arm64/include/asm/kvm_mmu.h                   |   4 +
>  arch/arm64/include/asm/sysreg.h                    |   3 +
>  arch/arm64/include/uapi/asm/kvm.h                  |  36 ++
>  arch/arm64/kernel/cpufeature.c                     |  11 +
>  arch/arm64/kvm/arch_timer.c                        | 550 +++++++++++++++=
+-----
>  arch/arm64/kvm/arm.c                               | 147 +++++-
>  arch/arm64/kvm/guest.c                             |  31 +-
>  arch/arm64/kvm/handle_exit.c                       |  36 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |  53 ++
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   2 -
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   7 +
>  arch/arm64/kvm/hyp/nvhe/switch.c                   |  18 +
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c                 |  18 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c                      |  38 +-
>  arch/arm64/kvm/hyp/vhe/switch.c                    |   7 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  12 +
>  arch/arm64/kvm/hypercalls.c                        | 189 ++++++-
>  arch/arm64/kvm/pmu-emul.c                          |  25 +-
>  arch/arm64/kvm/psci.c                              |  37 +-
>  arch/arm64/kvm/reset.c                             |  15 +-
>  arch/arm64/kvm/sys_regs.c                          |  10 +
>  arch/arm64/kvm/trace_arm.h                         |   6 +-
>  arch/arm64/kvm/vgic/vgic-debug.c                   |   8 +-
>  arch/arm64/kvm/vgic/vgic-init.c                    |  36 +-
>  arch/arm64/kvm/vgic/vgic-its.c                     |  33 +-
>  arch/arm64/kvm/vgic/vgic-kvm-device.c              |  85 ++--
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   4 +-
>  arch/arm64/kvm/vgic/vgic-mmio.c                    |  12 +-
>  arch/arm64/kvm/vgic/vgic-v4.c                      |  11 +-
>  arch/arm64/kvm/vgic/vgic.c                         |  27 +-
>  arch/arm64/kvm/vgic/vgic.h                         |   3 -
>  arch/arm64/tools/cpucaps                           |   1 +
>  arch/arm64/tools/sysreg                            |   4 +
>  arch/x86/include/asm/kvm_host.h                    |   7 +
>  arch/x86/include/uapi/asm/kvm.h                    |   3 +
>  arch/x86/kvm/x86.c                                 |   6 +-
>  include/clocksource/arm_arch_timer.h               |   1 +
>  include/kvm/arm_arch_timer.h                       |  34 +-
>  include/kvm/arm_hypercalls.h                       |   6 +-
>  include/kvm/arm_vgic.h                             |   1 +
>  include/uapi/linux/kvm.h                           |  12 +-
>  tools/testing/selftests/kvm/Makefile               |   1 +
>  tools/testing/selftests/kvm/aarch64/arch_timer.c   |  56 ++-
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c |  15 +-
>  tools/testing/selftests/kvm/aarch64/smccc_filter.c | 268 ++++++++++
>  tools/testing/selftests/kvm/config                 |   1 +
>  .../selftests/kvm/include/aarch64/processor.h      |  13 +
>  .../testing/selftests/kvm/lib/aarch64/processor.c  |  91 ++--
>  51 files changed, 1759 insertions(+), 410 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/smccc_filter.c
>


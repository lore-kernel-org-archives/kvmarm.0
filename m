From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 0/9] KVM: arm/arm64: race fixes and vcpu requests
Date: Mon, 3 Apr 2017 17:28:45 +0200
Message-ID: <20170403152845.GB11752@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170331160658.4331-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On Fri, Mar 31, 2017 at 06:06:49PM +0200, Andrew Jones wrote:
> This series fixes some hard to produce races by introducing the use of
> vcpu requests.  It also fixes a couple easier to produce races, ones
> that have been produced with the PSCI kvm-unit-test test.  The easy two
> are addressed in two different ways: the first takes advantage of
> power_off having been changed to a vcpu request, the second caches vcpu
> MPIDRs in order to avoid extracting them from sys_regs.  I've tested the
> series on a Mustang and a ThunderX and compile-tested the ARM bits.
> 
> Patch 2/9 adds documentation, as, at least for me, understanding vcpu
> request interplay with vcpu kicks and vcpu mode and the memory barriers
> that interplay implies, is exhausting.  Hopefully the document is useful
> to others.  I'm not married to it though, so it can be deferred/dropped
> as people like...

Sounds helpful, I'll have a look.

> 
> v2:
>   - No longer based on Radim's vcpu request API rework[1], except for
>     including "add kvm_request_pending" as patch 1/9 [drew]

I lost track here; did those patches get merged or dropped and why are
we not basing this work on them anymore, and should patch 1/9 be applied
here or is it expected to land in the KVM tree via some other path?

>   - Added vcpu request documentation [drew]
>   - Dropped the introduction of user settable MPIDRs [Christoffer]
>   - Added vcpu requests to all request-less vcpu kicks [Christoffer]
> 

Didn't we also have an issue with a missing barrier if the cmpxchg
operation doesn't succeed?  Did that fall though the cracks or is it
just missing in the changelog?

Thanks,
-Christoffer

> [1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1340496.html
> 
> Andrew Jones (7):
>   KVM: Add documentation for VCPU requests
>   KVM: arm/arm64: prepare to use vcpu requests
>   KVM: arm/arm64: replace vcpu->arch.pause with a vcpu request
>   KVM: arm/arm64: replace vcpu->arch.power_off with a vcpu request
>   KVM: arm/arm64: use a vcpu request on irq injection
>   KVM: arm/arm64: PMU: remove request-less vcpu kick
>   KVM: arm/arm64: avoid race by caching MPIDR
> 
> Levente Kurusa (1):
>   KVM: arm/arm64: fix race in kvm_psci_vcpu_on
> 
> Radim Krčmář (1):
>   KVM: add kvm_request_pending
> 
>  Documentation/virtual/kvm/vcpu-requests.rst | 114 ++++++++++++++++++++++++++++
>  arch/arm/include/asm/kvm_emulate.h          |   2 +-
>  arch/arm/include/asm/kvm_host.h             |  13 ++--
>  arch/arm/kvm/arm.c                          |  68 +++++++++++------
>  arch/arm/kvm/coproc.c                       |  20 +++--
>  arch/arm/kvm/handle_exit.c                  |   1 +
>  arch/arm/kvm/psci.c                         |  18 ++---
>  arch/arm64/include/asm/kvm_emulate.h        |   2 +-
>  arch/arm64/include/asm/kvm_host.h           |  13 ++--
>  arch/arm64/kvm/handle_exit.c                |   1 +
>  arch/arm64/kvm/sys_regs.c                   |  27 +++----
>  arch/mips/kvm/trap_emul.c                   |   2 +-
>  arch/powerpc/kvm/booke.c                    |   2 +-
>  arch/powerpc/kvm/powerpc.c                  |   5 +-
>  arch/s390/kvm/kvm-s390.c                    |   2 +-
>  arch/x86/kvm/x86.c                          |   4 +-
>  include/linux/kvm_host.h                    |   5 ++
>  virt/kvm/arm/arch_timer.c                   |   1 +
>  virt/kvm/arm/pmu.c                          |  29 +++----
>  virt/kvm/arm/vgic/vgic.c                    |  12 ++-
>  20 files changed, 245 insertions(+), 96 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/vcpu-requests.rst
> 
> -- 
> 2.9.3
> 

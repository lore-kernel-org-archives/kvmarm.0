From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 21/55] KVM: arm64: Forward HVC instruction to the guest
 hypervisor
Date: Mon, 3 Jul 2017 11:51:26 +0200
Message-ID: <20170703095126.GH4066@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-22-git-send-email-jintack@cs.columbia.edu>
 <20170222114758.GM26976@cbox>
 <CAHyh4xjG8_dOOe-eqQmAogDHDnQPCUQ-2Kccz9=6NmL0_+9TAA@mail.gmail.com>
 <20170703090850.GG4066@cbox>
 <20170703093156.m3ds2orbjcyooaag@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A2E540C5A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 05:51:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8VHKNQ+r+azo for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jul 2017 05:51:12 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE528408EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 05:51:11 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id 70so17733921wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jul 2017 02:51:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170703093156.m3ds2orbjcyooaag@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 03, 2017 at 11:31:56AM +0200, Andrew Jones wrote:
> On Mon, Jul 03, 2017 at 11:08:50AM +0200, Christoffer Dall wrote:
> > On Mon, Jun 26, 2017 at 11:21:25AM -0400, Jintack Lim wrote:
> > > On Wed, Feb 22, 2017 at 6:47 AM, Christoffer Dall <cdall@linaro.org> wrote:
> > > > On Mon, Jan 09, 2017 at 01:24:17AM -0500, Jintack Lim wrote:
> > > >> Forward exceptions due to hvc instruction to the guest hypervisor.
> > > >>
> > > >> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> > > >> ---
> > > >>  arch/arm64/include/asm/kvm_nested.h |  5 +++++
> > > >>  arch/arm64/kvm/Makefile             |  1 +
> > > >>  arch/arm64/kvm/handle_exit.c        | 11 +++++++++++
> > > >>  arch/arm64/kvm/handle_exit_nested.c | 27 +++++++++++++++++++++++++++
> > > >>  4 files changed, 44 insertions(+)
> > > >>  create mode 100644 arch/arm64/include/asm/kvm_nested.h
> > > >>  create mode 100644 arch/arm64/kvm/handle_exit_nested.c
> > > >>
> > > >> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> > > >> new file mode 100644
> > > >> index 0000000..620b4d3
> > > >> --- /dev/null
> > > >> +++ b/arch/arm64/include/asm/kvm_nested.h
> > > >> @@ -0,0 +1,5 @@
> > > >> +#ifndef __ARM64_KVM_NESTED_H__
> > > >> +#define __ARM64_KVM_NESTED_H__
> > > >> +
> > > >> +int handle_hvc_nested(struct kvm_vcpu *vcpu);
> > > >> +#endif
> > > >> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > > >> index b342bdd..9c35e9a 100644
> > > >> --- a/arch/arm64/kvm/Makefile
> > > >> +++ b/arch/arm64/kvm/Makefile
> > > >> @@ -35,4 +35,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
> > > >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
> > > >>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> > > >>
> > > >> +kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += handle_exit_nested.o
> > > >>  kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += emulate-nested.o
> > > >> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > > >> index a891684..208be16 100644
> > > >> --- a/arch/arm64/kvm/handle_exit.c
> > > >> +++ b/arch/arm64/kvm/handle_exit.c
> > > >> @@ -29,6 +29,10 @@
> > > >>  #include <asm/kvm_mmu.h>
> > > >>  #include <asm/kvm_psci.h>
> > > >>
> > > >> +#ifdef CONFIG_KVM_ARM_NESTED_HYP
> > > >> +#include <asm/kvm_nested.h>
> > > >> +#endif
> > > >> +
> > > >>  #define CREATE_TRACE_POINTS
> > > >>  #include "trace.h"
> > > >>
> > > >> @@ -42,6 +46,13 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > > >>                           kvm_vcpu_hvc_get_imm(vcpu));
> > > >>       vcpu->stat.hvc_exit_stat++;
> > > >>
> > > >> +#ifdef CONFIG_KVM_ARM_NESTED_HYP
> > > >> +     ret = handle_hvc_nested(vcpu);
> > > >> +     if (ret < 0 && ret != -EINVAL)
> > > >> +             return ret;
> > > >> +     else if (ret >= 0)
> > > >> +             return ret;
> > > >> +#endif
> > > >>       ret = kvm_psci_call(vcpu);
> > > >>       if (ret < 0) {
> > > >>               kvm_inject_undefined(vcpu);
> > > >> diff --git a/arch/arm64/kvm/handle_exit_nested.c b/arch/arm64/kvm/handle_exit_nested.c
> > > >> new file mode 100644
> > > >> index 0000000..a6ce23b
> > > >> --- /dev/null
> > > >> +++ b/arch/arm64/kvm/handle_exit_nested.c
> > > >> @@ -0,0 +1,27 @@
> > > >> +/*
> > > >> + * Copyright (C) 2016 - Columbia University
> > > >> + * Author: Jintack Lim <jintack@cs.columbia.edu>
> > > >> + *
> > > >> + * This program is free software; you can redistribute it and/or modify
> > > >> + * it under the terms of the GNU General Public License version 2 as
> > > >> + * published by the Free Software Foundation.
> > > >> + *
> > > >> + * This program is distributed in the hope that it will be useful,
> > > >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > >> + * GNU General Public License for more details.
> > > >> + *
> > > >> + * You should have received a copy of the GNU General Public License
> > > >> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> > > >> + */
> > > >> +
> > > >> +#include <linux/kvm.h>
> > > >> +#include <linux/kvm_host.h>
> > > >> +
> > > >> +#include <asm/kvm_emulate.h>
> > > >> +
> > > >> +/* We forward all hvc instruction to the guest hypervisor. */
> > > >> +int handle_hvc_nested(struct kvm_vcpu *vcpu)
> > > >> +{
> > > >> +     return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> > > >> +}
> > > >
> > > > I don't understand the logic here or in the caller above.  Do we really
> > > > forward *all" hvc calls to the guest hypervisor now, so that we no
> > > > longer support any hypercalls from the VM?  That seems a little rough
> > > > and probably requires some more discussions.
> > > 
> > > So I think if we run a VM with the EL2 support, then all hvc calls
> > > from the VM should be forwarded to the virtual EL2.
> > 
> > But do we actually check if the guest has EL2 here?  It seems you cann
> > handle_hvc_nested unconditionally when you have
> > OCNFIG_KVM_ARM_NESTED_HYP.  I think that's what threw me off when first
> > reading your patch.
> > 
> > > 
> > > I may miss something obvious, so can you (or anyone) come up with some
> > > cases that the host hypervisor needs to directly handle hvc from the
> > > VM with the EL2 support?
> > > 
> > 
> > So I'm a little unsure what to say here.  On one hand you are absolutely
> > correct, that architecturally if we emulated virtual EL2, then all
> > hypercalls are handled by the virtual EL2 (even hypercalls from virtual
> > EL2 which should become self-hypercalls).
> > 
> > On the other hand, an enlightened guest may want to use hypercalls to
> > the hypervisor for some reason, but that would require some numbering
> > scheme to separate the two concepts.
> 
> Yes, I've been thinking that a KVM generic vcpu needs to be enlightened,
> and to use a hypercall to get the host cpu's errata. If we head down that
> road, then even a vcpu emulating EL2 would need to be able to this.
> 

We could use SMC calls here a well, as the "conduit" as I believe the
ARM folks are calling it.  We just need to agree somewhere (across
hypervisors preferably), that when you have virtual EL2, everything is
via SMC (even upcalls to a host hypervisor), and otherwise it's via HVC.

> > 
> > Do we currently have support for the guest to use SMC calls for PSCI
> > when it has virtual EL2?
> 
> Yup, that's already supported by QEMU and the guest kernel.
> 
Yes, and the KVM support follows this patch in the series as it turns
out (but given the time since I looked at this series last, I forgot).


Thanks,
-Christoffer

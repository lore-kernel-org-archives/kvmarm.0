From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 05/10] KVM: arm: introduce kvm_arch_setup/clear_debug()
Date: Thu, 9 Apr 2015 14:56:07 +0200
Message-ID: <20150409125607.GD3212@hawk.usersys.redhat.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-6-git-send-email-alex.bennee@linaro.org>
 <20150401182855.4650b14a@thinkpad-w530>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74A0F4BE48
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 08:48:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 61dFOswkWALY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 08:48:39 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1B514BE4D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 08:48:39 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150401182855.4650b14a@thinkpad-w530>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 01, 2015 at 06:28:55PM +0200, David Hildenbrand wrote:
> > This is a precursor for later patches which will need to do more to
> > setup debug state before entering the hyp.S switch code. The existing
> > functionality for setting mdcr_el2 has been moved out of hyp.S and now
> > uses the value kept in vcpu->arch.mdcr_el2.
> > =

> > This also moves the conditional setting of the TDA bit from the hyp code
> > into the C code.
> > =

> > Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > =

> >  create mode 100644 arch/arm64/kvm/debug.c
> > =

> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm=
_host.h
> > index 41008cd..8c01c97 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -242,5 +242,7 @@ static inline void kvm_arch_hardware_unsetup(void) =
{}
> >  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> >  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> > +static inline void kvm_arch_setup_debug(struct kvm_vcpu *vcpu) {}
> > +static inline void kvm_arch_clear_debug(struct kvm_vcpu *vcpu) {}
> =

> Do you really want to call these functions "kvm_arch.." although they are=
 not
> defined for other arch and not triggered by common code?
>

Agreed. If other arches want something similar we can rename/refactor
later. If these are arm-only functions, then we don't need the generic
prefix, which is actually even a bit confusing.

drew =

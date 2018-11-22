From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 11/23] KVM: arm64: Support runtime sysreg filtering
 for KVM_GET_REG_LIST
Date: Thu, 22 Nov 2018 12:32:37 +0000
Message-ID: <20181122123235.GQ4719@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-12-git-send-email-Dave.Martin@arm.com>
 <20181102081625.GS12057@e113682-lin.lund.arm.com>
 <20181115172711.GQ3505@e103592.cambridge.arm.com>
 <20181122105344.GF17441@e113682-lin.lund.arm.com> <87bm6hic7a.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A30B4A200
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 07:32:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8DU9EApYAsAI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Nov 2018 07:32:47 -0500 (EST)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B6E34A1DC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 07:32:47 -0500 (EST)
In-Reply-To: <87bm6hic7a.fsf@linaro.org>
Content-Language: en-US
Content-ID: <50C6CE5A5CD08C4A9D250435109AB2A2@eurprd08.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?iso-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>
Cc: "tokamoto@jp.fujitsu.com" <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 22, 2018 at 11:27:53AM +0000, Alex Benn=E9e wrote:
>
> Christoffer Dall <christoffer.dall@arm.com> writes:
>
> > [Adding Peter and Alex for their view on the QEMU side]
> >
> > On Thu, Nov 15, 2018 at 05:27:11PM +0000, Dave Martin wrote:
> >> On Fri, Nov 02, 2018 at 09:16:25AM +0100, Christoffer Dall wrote:
> >> > On Fri, Sep 28, 2018 at 02:39:15PM +0100, Dave Martin wrote:
> >> > > KVM_GET_REG_LIST should only enumerate registers that are actually
> >> > > accessible, so it is necessary to filter out any register that is
> >> > > not exposed to the guest.  For features that are configured at
> >> > > runtime, this will require a dynamic check.
> >> > >
> >> > > For example, ZCR_EL1 and ID_AA64ZFR0_EL1 would need to be hidden
> >> > > if SVE is not enabled for the guest.
> >> >
> >> > This implies that userspace can never access this interface for a vc=
pu
> >> > before having decided whether such features are enabled for the gues=
t or
> >> > not, since otherwise userspace will see different states for a VCPU
> >> > depending on sequencing of the API, which sounds fragile to me.
> >> >
> >> > That should probably be documented somewhere, and I hope the
> >> > enable/disable API for SVE in guests already takes that into account.
> >> >
> >> > Not sure if there's an action to take here, but it was the best plac=
e I
> >> > could raise this concern.
> >>
> >> Fair point.  I struggled to come up with something better that solves
> >> all problems.
> >>
> >> My expectation is that KVM_ARM_SVE_CONFIG_SET is considered part of
> >> creating the vcpu, so that if issued at all for a vcpu, it is issued
> >> very soon after KVM_VCPU_INIT.
> >>
> >> I think this worked OK with the current structure of kvmtool and I
> >> seem to remember discussing this with Peter Maydell re qemu -- but
> >> it sounds like I should double-check.
> >
> > QEMU does some thing around enumerating all the system registers exposed
> > by KVM and saving/restoring them as part of its startup, but I don't
> > remember the exact sequence.
>
> QEMU does this for each vCPU as part of it's start-up sequence:
>
>   kvm_init_vcpu
>     kvm_get_cpu (-> KVM_CREATE_VCPU)
>     KVM_GET_VCPU_MMAP_SIZE
>     kvm_arch_init_vcpu
>       kvm_arm_vcpu_init (-> KVM_ARM_VCPU_INIT)
>       kvm_get_one_reg(ARM_CPU_ID_MPIDR)
>       kvm_arm_init_debug (chk for KVM_CAP SET_GUEST_DEBUG/GUEST_DEBUG_HW_=
WPS/BPS)
>       kvm_arm_init_serror_injection (chk KVM_CAP_ARM_INJECT_SERROR_ESR)
>       kvm_arm_init_cpreg_list (KVM_GET_REG_LIST)
>
> At this point we have the register list we need for
> kvm_arch_get_registers which is what we call every time we want to
> synchronise state. We only really do this for debug events, crashes and
> at some point when migrating.

So we would need to insert KVM_ARM_SVE_CONFIG_SET into this sequence,
meaning that the new capability is not strictly necessary.

I sympathise with Christoffer's view though that without the capability
mechanism it may be too easy for software to make mistakes: code
refactoring might swap the KVM_GET_REG_LIST and KVM_ARM_SVE_CONFIG ioctls
over and then things would go wrong with no immediate error indication.

In effect, the SVE regs would be missing from the list yielded by
KVM_GET_REG_LIST, possibly leading to silent migration failures.

I'm a bit uneasy about that.  Am I being too paranoid now?

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

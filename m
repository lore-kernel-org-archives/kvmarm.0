From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH v2 11/23] KVM: arm64: Support runtime sysreg
 filtering for KVM_GET_REG_LIST
Date: Thu, 22 Nov 2018 11:53:44 +0100
Message-ID: <20181122105344.GF17441@e113682-lin.lund.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-12-git-send-email-Dave.Martin@arm.com>
 <20181102081625.GS12057@e113682-lin.lund.arm.com>
 <20181115172711.GQ3505@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C56244A2BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 05:53:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xK1rm1W8lL7n for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Nov 2018 05:53:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4568A4A1DC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 05:53:47 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181115172711.GQ3505@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

[Adding Peter and Alex for their view on the QEMU side]

On Thu, Nov 15, 2018 at 05:27:11PM +0000, Dave Martin wrote:
> On Fri, Nov 02, 2018 at 09:16:25AM +0100, Christoffer Dall wrote:
> > On Fri, Sep 28, 2018 at 02:39:15PM +0100, Dave Martin wrote:
> > > KVM_GET_REG_LIST should only enumerate registers that are actually
> > > accessible, so it is necessary to filter out any register that is
> > > not exposed to the guest.  For features that are configured at
> > > runtime, this will require a dynamic check.
> > > 
> > > For example, ZCR_EL1 and ID_AA64ZFR0_EL1 would need to be hidden
> > > if SVE is not enabled for the guest.
> > 
> > This implies that userspace can never access this interface for a vcpu
> > before having decided whether such features are enabled for the guest or
> > not, since otherwise userspace will see different states for a VCPU
> > depending on sequencing of the API, which sounds fragile to me.
> > 
> > That should probably be documented somewhere, and I hope the
> > enable/disable API for SVE in guests already takes that into account.
> > 
> > Not sure if there's an action to take here, but it was the best place I
> > could raise this concern.
> 
> Fair point.  I struggled to come up with something better that solves
> all problems.
> 
> My expectation is that KVM_ARM_SVE_CONFIG_SET is considered part of
> creating the vcpu, so that if issued at all for a vcpu, it is issued
> very soon after KVM_VCPU_INIT.
> 
> I think this worked OK with the current structure of kvmtool and I
> seem to remember discussing this with Peter Maydell re qemu -- but
> it sounds like I should double-check.

QEMU does some thing around enumerating all the system registers exposed
by KVM and saving/restoring them as part of its startup, but I don't
remember the exact sequence.

> 
> Either way, you're right, this needs to be clearly documented.
> 
> 
> If we want to be more robust, maybe we should add a capability too,
> so that userspace that enables this capability promises to call
> KVM_ARM_SVE_CONFIG_SET for each vcpu, and affected ioctls (KVM_RUN,
> KVM_GET_REG_LIST etc.) are forbidden until that is done?
> 
> That should help avoid accidents.
> 
> I could add a special meaning for an empty kvm_sve_vls, such that
> it doesn't enable SVE on the affected vcpu.  That retains the ability
> to create heterogeneous guests while still following the above flow.
> 
I think making sure that userspace can ever only see the same list of
available system regiters is going to cause us less pain going forward.

If the separate ioctl and capability check is the easiest way of doing
that, then I think that sounds good.  (I had wished we could have just
added some data to KVM_CREATE_VCPU, but that doesn't seem to be the
case.)


Thanks,

    Christoffer

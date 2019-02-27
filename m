From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 13/26] KVM: arm64/sve: System register context switch
 and access support
Date: Wed, 27 Feb 2019 14:38:55 +0000
Message-ID: <20190227143854.GF3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-14-git-send-email-Dave.Martin@arm.com>
 <8a0e6089-b77b-151b-eacd-34ad13f39ac6@arm.com>
 <20190226170105.GB3567@e103592.cambridge.arm.com>
 <5a7dc2f4-a6e7-28bb-64d7-4f64424eb5c2@arm.com>
 <20190227135030.GE3567@e103592.cambridge.arm.com>
 <f39f69a2-18fe-578e-916d-030a4c07e0fd@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C0CE4A408
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Feb 2019 09:39:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wraz77FCAg7V for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Feb 2019 09:39:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C66E4A389
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Feb 2019 09:39:00 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <f39f69a2-18fe-578e-916d-030a4c07e0fd@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 27, 2019 at 02:17:06PM +0000, Julien Grall wrote:
> Hi Dave,
> 
> On 2/27/19 1:50 PM, Dave Martin wrote:
> >On Wed, Feb 27, 2019 at 12:02:46PM +0000, Julien Grall wrote:
> >>Hi Dave,
> >>
> >>On 2/26/19 5:01 PM, Dave Martin wrote:

[...]

> >>>The access_id_aa64zfr0_el1() should still be reachable, since we don't
> >>>have REG_NO_GUEST for this.
> >>
> >>__access_id_reg is taking a boolean to tell whether the register is RAZ or
> >>not. So you probably could re-use it passing !vcpu_has_sve(vcpu).
> >>
> >>It feels to me we would introduce a new restriction to tell whether the
> >>register should be RAZ. Anyway, the new restriction is probably for a
> >>follow-up patch.
> >
> >It's true that we should be able to handle these as regular ID regs in
> >the get()/set() case, when SVE is enabled for the vcpu.  I'll have a
> >think about how to reduce the amount of special-case code here maybe
> >we can indeed get of some of these accessors entitely now that access
> >is rejected earlier, in a more generic way.
> >
> >The access() case for this register still has to be custom though; I
> >don't see a trivial solution for that.
> 
> I believe you can implement access_id_aa64zfr0_el1 in one line:
> 
> return __access_id_reg(vcpu, p, r, !vcpu_has_sve(vcpu));

Could maybe do that -- I'll take a look.

> Another possibility is to introduce REG_GUEST_RAZ and use the restrictions
> callback to set it when the vCPU is not using SVE.

This is possible, though I'm reluctant to introduce this for a one-off
special case.

Depending on how many registers follow the same pattern in the future,
we could add it later on.

Cheers
---Dave

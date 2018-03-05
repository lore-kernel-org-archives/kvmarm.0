From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 2/2] KVM: arm64: Eliminate most redundant FPSIMD
 saves and restores
Date: Mon, 5 Mar 2018 11:54:37 +0000
Message-ID: <20180305115433.GI32331@e103592.cambridge.arm.com>
References: <1518805771-15346-1-git-send-email-Dave.Martin@arm.com>
 <1518805771-15346-3-git-send-email-Dave.Martin@arm.com>
 <20180223170844.GB7396@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180223170844.GB7396@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 23, 2018 at 06:08:44PM +0100, Christoffer Dall wrote:
> Hi Dave,
> 
> On Fri, Feb 16, 2018 at 06:29:31PM +0000, Dave Martin wrote:
> > Currently, KVM doesn't know how host tasks interact with the cpu
> > FPSIMD regs, and the host doesn't knoe how vcpus interact with the
> > regs.  As a result, KVM must currently switch the FPSIMD state
> > rather defensively in order to avoid anybody's state getting
> > corrupted: in particular, the host and guest FPSIMD state must be
> > fully swapped on each iteration of the run loop.
> > 
> > This patch integrates KVM more closely with the host FPSIMD context
> > switch machinery, to enable better tracking of whose state is in
> > the FPSIMD regs.  This brings some advantages: KVM can tell whether
> > the host has any live state in the regs and can avoid saving them
> > if not; also, KVM can tell when and if the host clobbers the vcpu
> > state in the regs, to avoid reloading them before reentering the
> > guest.
> > 
> > As well as avoiding the host state being unecessarily saved, this
> > should also mean that the vcpu state can survive context switch
> > when there is no kernel-mode NEON use and no entry to userspace,
> > such as when ancillary kernel threads preempt a vcpu.
> > 
> > This patch cannot eliminate the need to save the guest context
> > eefore enabling interrupts, becuase softirqs may use kernel- mode
> > NEON and trash the vcpu regs.  However, provding that doesn't
> > happen the reload cost is at least saved on the next run loop
> > iteration.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > 
> > ---
> > 
> > Caveat: this does *not* currently deal properly with host SVE state,
> > though supporting that shouldn't be drastically different.
> 
> It's a bit outside the capacity of my brain to think about that a well
> for the moment, but if we can agree on the overall approach of doing
> FPSIMD first, then hopefully I can understand the SVE challenge later.
> 
> > ---

[...]

> commit 6bb55488489d69885b51819add3690da523be12a (HEAD -> kvm-vfp-integration-rfc)
> Author: Christoffer Dall <christoffer.dall@linaro.org>
> Date:   Fri Feb 23 17:58:17 2018 +0100
> 
>     KVM: arm64: Be more lazy with switching KVM guest FPSIMD state
>     
>     We currently save the FPSIMD state back from the CPU on every exit, when
>     the guest has touched the FPSIMD state.
>     
>     We can try to avoid this by changing the state that is tracked by the
>     kernel FPSIMD mechanism to the KVM guest state, and keep track of this
>     using additional thread flag.  Whenever we go back to userspace from the
>     KVM_RUN ioctl, we check if we switched to the KVM state, and make sure
>     the state is copied back.
>     
>     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

[...]

Hmmm, on reflection I think we still have the same underlying problem
here, which is that pulling fpsimd save/restore outside the
local_irq_disable() region exposes us to softirqs that can trash the
state.  Long-term blocking of softirq or kernel-mode NEON could fix
this, but the impact on kernel-mode NEON client code would probably
be unacceptable (recalling discussions we had with Ard).

I don't see a straightforward way around this that doesn't involve
adding logic in the kvm run/loop and fpsimd hyp trap code...

Cheers
---Dave

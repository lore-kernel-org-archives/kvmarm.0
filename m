From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 13/27] KVM: arm64/sve: Context switch the SVE registers
Date: Thu, 4 Apr 2019 09:36:25 +0100
Message-ID: <20190404083624.GA3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-14-git-send-email-Dave.Martin@arm.com>
 <20190403200145.c2oep2hbugl7db5t@kamzik.brq.redhat.com>
 <20190404081008.GY3567@e103592.cambridge.arm.com>
 <20190404083502.b7a345l2gx3df2zk@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190404083502.b7a345l2gx3df2zk@kamzik.brq.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 10:35:02AM +0200, Andrew Jones wrote:
> On Thu, Apr 04, 2019 at 09:10:08AM +0100, Dave Martin wrote:
> > On Wed, Apr 03, 2019 at 10:01:45PM +0200, Andrew Jones wrote:
> > > On Fri, Mar 29, 2019 at 01:00:38PM +0000, Dave Martin wrote:
> > > > In order to give each vcpu its own view of the SVE registers, this
> > > > patch adds context storage via a new sve_state pointer in struct
> > > > vcpu_arch.  An additional member sve_max_vl is also added for each
> > > > vcpu, to determine the maximum vector length visible to the guest
> > > > and thus the value to be configured in ZCR_EL2.LEN while the vcpu
> > > > is active.  This also determines the layout and size of the storage
> > > > in sve_state, which is read and written by the same backend
> > > > functions that are used for context-switching the SVE state for
> > > > host tasks.
> > > > 
> > > > On SVE-enabled vcpus, SVE access traps are now handled by switching
> > > > in the vcpu's SVE context and disabling the trap before returning
> > > > to the guest.  On other vcpus, the trap is not handled and an exit
> > > > back to the host occurs, where the handle_sve() fallback path
> > > > reflects an undefined instruction exception back to the guest,
> > > > consistently with the behaviour of non-SVE-capable hardware (as was
> > > > done unconditionally prior to this patch).
> > > > 
> > > > No SVE handling is added on non-VHE-only paths, since VHE is an
> > > > architectural and Kconfig prerequisite of SVE.
> > > > 
> > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > > > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > > > 
> > > > ---
> > > > 
> > > > Changes since v5:
> > > > 
> > > >  * [Julien Thierry, Julien Grall] Commit message typo fixes
> > > > 
> > > >  * [Mark Rutland] Rename trap_class to hsr_ec, for consistency with
> > > >    existing code.
> > > > 
> > > >  * [Mark Rutland] Simplify condition for refusing to handle an
> > > >    FPSIMD/SVE trap, using multiple if () statements for clarity.  The
> > > >    previous condition was a bit tortuous, and how that the static_key
> > > >    checks have been hoisted out, it makes little difference to the
> > > >    compiler how we express the condition here.
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h |  6 ++++
> > > >  arch/arm64/kvm/fpsimd.c           |  5 +--
> > > >  arch/arm64/kvm/hyp/switch.c       | 75 +++++++++++++++++++++++++++++----------
> > > >  3 files changed, 66 insertions(+), 20 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index 22cf484..4fabfd2 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -228,6 +228,8 @@ struct vcpu_reset_state {
> > > >  
> > > >  struct kvm_vcpu_arch {
> > > >  	struct kvm_cpu_context ctxt;
> > > > +	void *sve_state;
> > > > +	unsigned int sve_max_vl;
> > > >  
> > > >  	/* HYP configuration */
> > > >  	u64 hcr_el2;
> > > > @@ -323,6 +325,10 @@ struct kvm_vcpu_arch {
> > > >  	bool sysregs_loaded_on_cpu;
> > > >  };
> > > >  
> > > > +/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> > > > +#define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
> > > > +				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> > > 
> > > Maybe an inline function instead?
> > 
> > I tried, but that requires the definition of struct kvm_vcpu to be
> > visible.  I failed to get that here without circular #include problems,
> > and it looked tricky to fix.
> 
> Ah, OK
> 
> > 
> > Since this is a small bit of code which is unlikely to get used by
> > accident, I decided it was OK to keep it as a macro.
> > 
> > Can you see another way around this?
> 
> Nope

OK.  If someone eventually solves this, I'd be happy to change to an
inline function.

Cheers
---Dave

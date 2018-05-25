From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v10 07/18] arm64: fpsimd: Eliminate task->mm checks
Date: Fri, 25 May 2018 13:28:49 +0200
Message-ID: <20180525112849.GA56636@C02W217FHV2R.local>
References: <20180523114812.GH55598@C02W217FHV2R.local>
 <20180523133158.GJ13470@e103592.cambridge.arm.com>
 <20180523145657.g7b6v2q2vxfqpoc4@armageddon.cambridge.arm.com>
 <20180523150337.GO13470@e103592.cambridge.arm.com>
 <20180524083350.GK55598@C02W217FHV2R.local>
 <20180524095056.GR13470@e103592.cambridge.arm.com>
 <20180524100659.GO55598@C02W217FHV2R.local>
 <20180524143714.GV13470@e103592.cambridge.arm.com>
 <20180525090020.GA54529@C02W217FHV2R.local>
 <20180525094515.GA13470@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180525094515.GA13470@e103592.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 25, 2018 at 10:45:17AM +0100, Dave Martin wrote:
> On Fri, May 25, 2018 at 11:00:20AM +0200, Christoffer Dall wrote:
> > On Thu, May 24, 2018 at 03:37:15PM +0100, Dave Martin wrote:
> > > On Thu, May 24, 2018 at 12:06:59PM +0200, Christoffer Dall wrote:
> > > > On Thu, May 24, 2018 at 10:50:56AM +0100, Dave Martin wrote:
> 
> [...]
> 
> > > > I'm not sure what the reader is to make of that.  Do you not mean the
> > > > TIF_FOREIGN_FPSTATE is always true for kernel threads?
> > > 
> > > Again, this is probably a red herring.  TIF_FOREIGN_FPSTATE is always
> > > true for kernel threads prior to the patch, except (randomly) for the
> > > init task.
> > 
> > That was really what my initial question was about, and what I thought
> > the commit message should make abundantly clear, because that ties the
> > message together with the code.
> > 
> > > 
> > > This change is not really about TIF_FOREIGN_FPSTATE at all, rather
> > > that there is nothing to justify handling kernel threads differently,
> > > or even distinguishing kernel threads from user threads at all in this
> > > code.
> > 
> > Understood.
> 
> And my bad was that I hadn't gone to the effort of understanding my own
> argument -- I'd glad to be called out on that.
> 
> > > Part of the confusion (and I had confused myself) comes from the fact
> > > that TIF_FOREIGN_FPSTATE is really a per-cpu property and doesn't make
> > > sense as a per-task property -- i.e., the flag is meaningless for
> > > scheduled-out tasks and we must explicitly "repair" it when scheduling
> > > a task in anyway.  I think it's a thread flag primarily so that it's
> > > convenient to check alongside other thread flags in the ret_to_user
> > > work loop.  This is somewhat less of a justification now that loop was
> > > ported to C.
> > > 
> > > > > 
> > > > > The context switch logic is already deliberately optimised to defer
> > > > > reloads of the regs until ret_to_user (or sigreturn as a special
> > > > > case), and save them only if they have been previously loaded.
> > > 
> > > Does it help to insert the following here?
> > > 
> > > "These paths are the only places where the wrong_task and wrong_cpu
> > > conditions can be made false, by calling fpsimd_bind_task_to_cpu()."
> > > 
> > 
> > yes it does.
> > 
> > > > > Kernel threads by definition never reach these paths.  As a result,
> > > > 
> > > > I'm struggling with the "As a result," here.  Is this because reloads of
> > > > regs in ret_to_user (or sigreturn) are the only places that can make
> > > > wrong_cpu or wrong_task be false?
> > > 
> > > See the proposed clarification above.  Is that sufficient?
> > > 
> > 
> > yes.
> > 
> > > > (I'm actually wanting to understand this, not just bikeshedding the
> > > > commit message, as new corner cases keep coming up on this logic.)
> > > 
> > > That's a good thing, and I would really like to explain it in a
> > > concise manner.  See [*] below for the "concise" explanation -- it may
> > > demonstrate why I've been evasive...
> > > 
> > 
> > I don't think you've been evasive at all, I just think we reason about
> > this in slightly different ways, and I was trying to convince myself why
> > this change is safe and summarize that concisely.  I think we've
> > accomplished both :)
> 
> OK, good.  I reposted speculatively on this basis :)
> 
> The commit message is in better shape now, and I very much appreciate
> you kicking the tyres on my reasoning!
> 
> [...]
> 
> > > As an aside, the big wall of text before the definition of struct
> > > fpsimd_last_state_struct is looking out of date and could use an
> > > update to cover at least some of what is explained in [*] better.
> > > 
> > > I'm currently considering that out of scope for this series, but I will
> > > keep it in mind to refresh it in the not too distant future.
> > > 
> > 
> > Fine with me.
> 
> OK, good.
> 
> [...]
> 
> > > [*] The bigger picture:
> > > 
> > > * Consider a relation (C,T) between cpus C and tasks T, such that
> 
> [...]
> 
> > > but by assuming that the code is already well-optimised, "unnecessary"
> > > save/restore work will not be added.  If this were not the case, it
> > > could in any case be fixed independently.
> > > 
> > > The observation of this _series_ is that we don't need to do very
> > > much in order to be able to generalise the logic to accept KVM vcpus
> > > in place of T.
> > > 
> > 
> > Thanks for the explanation.
> > -Christoffer
> 
> Was this reasonably understandable?  If so I could use it as a basis for
> improving the comment block in fpsimd.c, but I'd want to squash it down
> to the essentials.  It's pretty verbose as it stands.

Yes, I think that's a resonable way forward.  The thing that I hadn't
fully appreciated before is that you may have a valid relation (C,T)
which you wish to invalidate whilst T may not be running on C at that
particular time.

> 
> (What I'd really like to do it take an axe to the logic so that we
> end up with something that doesn't require anything like this amount
> of explanation ... but that's more of an aspiration right now.)
> 

I'll be happy to review a potentially simplified design, should you come
up with one at some point in the future.

Thanks,
-Christoffer

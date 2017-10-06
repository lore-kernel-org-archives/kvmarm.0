From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 11/28] arm64/sve: Core task context handling
Date: Fri, 6 Oct 2017 16:33:13 +0100
Message-ID: <20171006153312.cushhcb4m2qc4kwd@armageddon.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-12-git-send-email-Dave.Martin@arm.com>
 <20170913143325.hi4cfcajbts3bbao@localhost>
 <20171003113302.GR3611@e103592.cambridge.arm.com>
 <20171005112835.2rhaqx23bhe6tnwl@armageddon.cambridge.arm.com>
 <20171006131005.GA3611@e103592.cambridge.arm.com>
 <20171006133639.ialgglabo7yca5bm@armageddon.cambridge.arm.com>
 <20171006151528.GB3611@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171006151528.GB3611@e103592.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:15:28PM +0100, Dave P Martin wrote:
> On Fri, Oct 06, 2017 at 02:36:40PM +0100, Catalin Marinas wrote:
> > On Fri, Oct 06, 2017 at 02:10:09PM +0100, Dave P Martin wrote:
> > > On Thu, Oct 05, 2017 at 12:28:35PM +0100, Catalin Marinas wrote:
> > > > On Tue, Oct 03, 2017 at 12:33:03PM +0100, Dave P Martin wrote:
> > > > > TIF_FOREIGN_FPSTATE's meaning is expanded to cover SVE, but otherwise
> > > > > unchanged:
> > > > > 
> > > > >  * If a task is running and !TIF_FOREIGN_FPSTATE, then the the CPU
> > > > >    registers of the CPU the task is running on contain the authoritative
> > > > >    FPSIMD/SVE state of the task.  The backing memory may be stale.
> > > > > 
> > > > >  * Otherwise (i.e., task not running, or task running and
> > > > >    TIF_FOREIGN_FPSTATE), the task's FPSIMD/SVE backing memory is
> > > > >    authoritative.  If additionally per_cpu(fpsimd_last_state,
> > > > >    task->fpsimd_state.cpu) == &task->fpsimd_state.cpu, then
> > > > >    task->fpsimd_state.cpu's registers are also up to date for task, but
> > > > >    not authorititive: the current FPSIMD/SVE state may be read from
> > > > >    them, but they must not be written.
> > > > >  
> > > > > The FPSIMD/SVE backing memory is selected by TIF_SVE:
> > > > > 
> > > > >  * TIF_SVE set: Zn (incorporating Vn in bits[127:0]), Pn and FFR are
> > > > >    stored in task->thread.sve_state, formatted appropriately for vector
> > > > >    length task->thread.sve_vl.  task->thread.sve_state must point to a
> > > > >    valid buffer at least sve_state_size(task) bytes in size.
> > 
> > "Zn [...] stored in  task->thread.sve_state" - is this still true with
> > the changes you proposed? I guess even without these changes, you have
> > situations where the hardware regs are out of sync with sve_state (see
> > more below).
> 
> I guess I need to tweak the wording here.
> 
> TIF_SVE says where the vector state should be loaded/stored from,
> but does not say whether the data is up to date in memory, or when
> it should be loaded/stored.
> 
> The latter is described by a cocktail of different things including
> which bit of kernel code we are executing if any, whether the task
> is running/stopped etc., TIF_FOREIGN_FPSTATE,
> task->thread.fpsimd_state.cpu and per_cpu(fpsimd_last_state).
> 
> Does this make any better sense of my code below?

Yes, it looks fine.

-- 
Catalin

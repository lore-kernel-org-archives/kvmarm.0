From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 22/28] arm64/sve: KVM: Prevent guests from using SVE
Date: Tue, 17 Oct 2017 15:31:42 +0100
Message-ID: <20171017143142.GX19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-23-git-send-email-Dave.Martin@arm.com>
 <20171017115024.GS1845@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E84549D1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 10:30:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M45eED+4vMpu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 10:30:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D24E40638
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 10:30:49 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171017115024.GS1845@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 01:50:24PM +0200, Christoffer Dall wrote:
> On Tue, Oct 10, 2017 at 07:38:39PM +0100, Dave Martin wrote:
> > Until KVM has full SVE support, guests must not be allowed to
> > execute SVE instructions.
> > 
> > This patch enables the necessary traps, and also ensures that the
> > traps are disabled again on exit from the guest so that the host
> > can still use SVE if it wants to.
> > 
> > This patch introduces another instance of
> > __this_cpu_write(fpsimd_last_state, NULL), so this flush operation
> > is abstracted out as a separate helper fpsimd_flush_cpu_state().
> > Other instances are ported appropriately.
> 
> I don't understand this paragraph, beginning from ", so this...".
> 
> 
> From reading the code, what I think is the reason for having to flush
> the SVE state (and mark the host state invalid) is that even though we
> disallow SVE usage in the guest, the guest can use the normal FP state,
> and while we always fully preserve the host state, this could still
> corrupt some additional SVE state not properly preserved for the host.
> Is that correct?

Yes, that's right: the guest can't touch the SVE-specific registers
Pn/FFR, but FPSIMD accesses to Vn regs cause the high bits of the
corresponding SVE Zn registers to be clobbered.  In any case, the
FPSIMD restore done by KVM after guest exit is sufficient to clobber
those bits even if the guest didn't do it.

This is a band-aid for not making the KVM world switch code properly
SVE-aware yet.

Does the following wording sound better:

--8<--

On guest exit, high bits of the SVE Zn registers may have been
clobbered as a side-effect the execution of FPSIMD instructions in
the guest.  The existing KVM host FPSIMD restore code is not
sufficient to restore these bits, so this patch explicitly marks
the CPU as not containing cached vector state for any task, this
forcing a reload on the next return to userspace.  This is an
interim measure, in advance of adding full SVE awareness to KVM.

Because of the duplication of this operation
(__this_cpu_write(fpsimd_last_state, NULL)), it is factored out as
a new helper fpsimd_flush_cpu_state() to make the purpose clearer.

-->8--

> > 
> > As a side effect of this refactoring, a this_cpu_write() in
> > fpsimd_cpu_pm_notifier() is changed to __this_cpu_write().  This
> > should be fine, since cpu_pm_enter() is supposed to be called only
> > with interrupts disabled.
> 
> Otherwise the patch itself looks good to me.

Thanks, let me know about the above wording change though.

---Dave

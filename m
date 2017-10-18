From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 22/28] arm64/sve: KVM: Prevent guests from using SVE
Date: Wed, 18 Oct 2017 21:22:41 +0200
Message-ID: <20171018192241.GL8900@cbox>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-23-git-send-email-Dave.Martin@arm.com>
 <20171017115024.GS1845@lvm>
 <20171017143142.GX19485@e103592.cambridge.arm.com>
 <20171018132323.GG8900@cbox>
 <20171018150004.GA19485@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03FBE49D1D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 15:21:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ocK06wgaWmE1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 15:21:40 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CED654078A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 15:21:39 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id u138so12188680wmu.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 12:22:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171018150004.GA19485@e103592.cambridge.arm.com>
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
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 18, 2017 at 04:00:05PM +0100, Dave Martin wrote:
> On Wed, Oct 18, 2017 at 03:23:23PM +0200, Christoffer Dall wrote:
> > On Tue, Oct 17, 2017 at 03:31:42PM +0100, Dave Martin wrote:
> > > On Tue, Oct 17, 2017 at 01:50:24PM +0200, Christoffer Dall wrote:
> > > > On Tue, Oct 10, 2017 at 07:38:39PM +0100, Dave Martin wrote:
> > > > > Until KVM has full SVE support, guests must not be allowed to
> > > > > execute SVE instructions.
> > > > > 
> > > > > This patch enables the necessary traps, and also ensures that the
> > > > > traps are disabled again on exit from the guest so that the host
> > > > > can still use SVE if it wants to.
> > > > > 
> > > > > This patch introduces another instance of
> > > > > __this_cpu_write(fpsimd_last_state, NULL), so this flush operation
> > > > > is abstracted out as a separate helper fpsimd_flush_cpu_state().
> > > > > Other instances are ported appropriately.
> > > > 
> > > > I don't understand this paragraph, beginning from ", so this...".
> > > > 
> > > > 
> > > > From reading the code, what I think is the reason for having to flush
> > > > the SVE state (and mark the host state invalid) is that even though we
> > > > disallow SVE usage in the guest, the guest can use the normal FP state,
> > > > and while we always fully preserve the host state, this could still
> > > > corrupt some additional SVE state not properly preserved for the host.
> > > > Is that correct?
> > > 
> > > Yes, that's right: the guest can't touch the SVE-specific registers
> > > Pn/FFR, but FPSIMD accesses to Vn regs cause the high bits of the
> > > corresponding SVE Zn registers to be clobbered.  In any case, the
> > > FPSIMD restore done by KVM after guest exit is sufficient to clobber
> > > those bits even if the guest didn't do it.
> > > 
> > > This is a band-aid for not making the KVM world switch code properly
> > > SVE-aware yet.
> > > 
> > > Does the following wording sound better:
> > > 
> > > --8<--
> > > 
> > > On guest exit, high bits of the SVE Zn registers may have been
> > > clobbered as a side-effect the execution of FPSIMD instructions in
> > > the guest.  The existing KVM host FPSIMD restore code is not
> > > sufficient to restore these bits, so this patch explicitly marks
> > > the CPU as not containing cached vector state for any task, this
> > > forcing a reload on the next return to userspace.  This is an
> > > interim measure, in advance of adding full SVE awareness to KVM.
> > > 
> > > Because of the duplication of this operation
> > > (__this_cpu_write(fpsimd_last_state, NULL)), it is factored out as
> > 
> > s/it is/is/  (I think)
> > 
> > > a new helper fpsimd_flush_cpu_state() to make the purpose clearer.
> > 
> > Yes, the wording is good and helps a lot.  Thanks for writing that.
> > 
> 
> I think it "it is" is correct, but it's a pretty ghastly sentence...

Ah, I missed the comma, before and read it as __this_cpu_write... is
factored... but that doesn't make any sense.  Sorry, I was just not
paying proper attention.

> 
> I'll split it as:
> 
> This marking of cached vector state in the CPU as invalid is done using
> __this_cpu_write(fpsimd_last_state, NULL) in fpsimd.c.  Due to the
> repeated use of this rather obscure operation, it makes sense to factor
> it out as a separate helper with a clearer name.  This patch factors it
> out as fpsimd_flush_cpu_state().
> 

That's definitely clear.

> > Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> I'll assume I can keep keep your Reviewed-by, since this change is just
> clarification.
> 
> But if you're not happy, please shout!
> 
I'm happy - in most aspects of life - indeed keep my reviewed-by.

Thanks,
-Christoffer

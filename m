Return-Path: <SRS0=LttP=ZO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C88C432C0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 18:31:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 552A22068F
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 18:31:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 552A22068F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B917E4AEDC;
	Fri, 22 Nov 2019 13:31:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F+DnrqvDet+7; Fri, 22 Nov 2019 13:31:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 813024AEC0;
	Fri, 22 Nov 2019 13:31:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5274A4ACF4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 13:31:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GCdZZVqIfHet for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Nov 2019 13:31:08 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D64754ACE3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 13:31:08 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why)
 by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
 (Exim 4.80) (envelope-from <maz@kernel.org>)
 id 1iYDhz-0007WI-AG; Fri, 22 Nov 2019 19:31:07 +0100
Date: Fri, 22 Nov 2019 18:31:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: Daniel Verkamp <dverkamp@chromium.org>
Subject: Re: KVM_COMPAT support on aarch64
Message-ID: <20191122183106.08dcb1de@why>
In-Reply-To: <CABVzXAkeuHJOHcV1djsUOanbtNYbhsQ_vXe2ErKcpre0TRiCvA@mail.gmail.com>
References: <CABVzXA=DGxc4eE0RQX=tGu3QAYQ0RmEL7Y=WZYWBr355zEp_vA@mail.gmail.com>
 <a07bd7883278838c26a955a1b4c43441@www.loen.fr>
 <CABVzXAkeuHJOHcV1djsUOanbtNYbhsQ_vXe2ErKcpre0TRiCvA@mail.gmail.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dverkamp@chromium.org, kvmarm@lists.cs.columbia.edu,
 dgreid@chromium.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Dylan Reid <dgreid@chromium.org>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, 22 Nov 2019 09:50:50 -0800
Daniel Verkamp <dverkamp@chromium.org> wrote:

> On Fri, Nov 22, 2019 at 7:29 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > Hi Daniel,
> >
> > [please use my kernel.org address, as I'm not employed by ARM anymore]
> >
> > On 2019-11-21 20:16, Daniel Verkamp wrote:  
> > > Hi Marc,
> > >
> > > I noticed that in recent kernels (4.19 in our case), KVM no longer
> > > works for 32-bit processes running on arm64 machines. We
> > > (Crostini/crosvm, Linux VM support on Chromebooks) use this
> > > KVM_COMPAT
> > > on all arm64-based Chromebooks that support VMs, since our entire
> > > userspace (including crosvm) is 32-bit.
> > >
> > > I found this commit (KVM: arm64: Prevent KVM_COMPAT from being
> > > selected):
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=37b65db85f9b2fc98267eee4a18d7506492e6e8c
> > >
> > > Is there any particular reason the compat ioctl is disabled (e.g.
> > > actual bugs/breakage), or would it be possible to re-enable
> > > KVM_COMPAT
> > > for ARM64?  
> >
> > Well, it never worked the first place! :( The whole API is entirely
> > different,
> > and you should feel extremely lucky that it ever seemed to work!  
> 
> I hadn't looked at this before, but it seems like the Rust bindings
> for KVM we are using are actually generated from the aarch64 C headers
> (e.g. struct kvm_regs contains sp_el1, etc. rather than svc_regs):
> https://chromium.googlesource.com/chromiumos/platform/crosvm/+/37bd738b783053c2e94b4c215c32496bae5081ed/kvm_sys/src/aarch64/bindings.rs
> So we are really passing the native 64-bit structs to the 32-bit
> compat ioctl, which is probably bogus.

Wow. It's amazing it did anything sensible!

> I can see how this is unlikely to work in a normal C program compiled
> against the 32-bit ARM uapi headers.

Indeed.

> > > In my brief testing with a 4.19-stable-based kernel on a new arm64
> > > board, everything seems to work fine with the commit above reverted.  
> >
> > The key word here is *seems*. It may happen that the userspace ABI
> > somehow align for some of the basic stuff, but it will fail for
> > anything moderately serious (I really doubt QEMU would be able to
> > run at all).
> >
> > I suppose to tried this with crosvm? 32 or 64bit guest?  
> 
> Yes, I am able to run the full Crostini environment using 32-bit
> crosvm on an aarch64 Chromebook kernel based on 4.19.84 stable.  The
> guest kernel and userspace is 64 bit in this case (we don't support
> 32-bit guest).
> 
> I also just tried a 32-bit build of kvmtool (lkvm), since we have a
> convenient ebuild to cross-compile it in the Chrome OS SDK, but I
> wasn't able to get it to boot (it fails at a call to KVM_GET_ONE_REG).
> I didn't attempt to debug it, but I'm assuming it's due to the ABI
> mismatch you mentioned.

That's what I was expecting indeed. The registers are identified
differently to make my life easier (and at some point I considered
writing a compat interface before making up my mind and canning the
thing altogether).

> It sounds like disabling the compat ioctl is probably the right thing
> to do in this case; I'll have to see if we can build crosvm as a
> 64-bit executable instead in the future (not sure how easily this will
> be given the way the Chromium OS build system works).

You may have to end-up with a static binary, which is not very
appealing...


	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

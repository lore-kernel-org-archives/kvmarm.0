Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6530DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Feb 2022 12:13:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAB3540DE6;
	Tue, 15 Feb 2022 07:13:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C2MPVcmejP6U; Tue, 15 Feb 2022 07:13:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3673D40E00;
	Tue, 15 Feb 2022 07:13:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3EDB40BF0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 07:13:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4vQEb7VaIPyA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Feb 2022 07:13:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BC8F401A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 07:13:11 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F39CC1480;
 Tue, 15 Feb 2022 04:13:10 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E48A3F718;
 Tue, 15 Feb 2022 04:13:09 -0800 (PST)
Date: Tue, 15 Feb 2022 12:13:23 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH v5 02/38] KVM: arm64: Add lock/unlock memslot user API
Message-ID: <YguY450MMykpbKsm@monolith.localdoman>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
 <20211117153842.302159-3-alexandru.elisei@arm.com>
 <CAAeT=Fzx4Hf+Rimi7yNMxCO2OOm6C1_s1CnhcONHwg04nV_d7Q@mail.gmail.com>
 <YguInzLt1D9PZkwh@monolith.localdoman>
 <87ee4449t9.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ee4449t9.wl-maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi,

On Tue, Feb 15, 2022 at 12:02:26PM +0000, Marc Zyngier wrote:
> On Tue, 15 Feb 2022 11:03:59 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > > If a memslot with read/write permission is locked with read only,
> > > and then unlocked, can userspace expect stage 2 mapping for the
> > > memslot to be updated with read/write ?
> > 
> > Locking a memslot with the read flag would map the memory described by the
> > memslot with read permissions at stage 2. When the memslot is unlocked, KVM
> > won't touch the stage 2 entries.
> > 
> > When the memslot is unlocked, the pages (as in, struct page) backing the VM
> > memory as described by the memslot are unpinned. Then the host's MM subsystem
> > can treat the memory like any other pages (make them old, new, unmap them, do
> > nothing, etc), and the MMU notifier will take care of updating the stage 2
> > entries as necessary.
> > 
> > I guess I should have been more precise in the description. I'll
> > change "causes the memory pinned when locking the memslot specified
> > in args[0] to be unpinned" to something that clearly states that the
> > memory in the host that backs the memslot is unpinned.
> > 
> > > Can userspace delete the memslot that is locked (without unlocking) ?
> > 
> > No, it cannot.
> > 
> > > If so, userspace can expect the corresponding range to be implicitly
> > > unlocked, correct ?
> > 
> > Userspace must explicitely unlock the memslot before deleting it. I want
> > userspace to be explicit in its intent.
> 
> Does it get in the way of making this robust wrt userspace being
> killed (or terminating without unlock first)?

Patch #8 ("KVM: arm64: Unlock memslots after stage 2 tables are freed")
teaches kvm_arch_flush_shadow_all() to unlock all locked memslots.

Thanks,
Alex

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

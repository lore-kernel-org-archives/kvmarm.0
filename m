Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A05C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 18 Oct 2022 07:38:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 712C64B846;
	Tue, 18 Oct 2022 03:38:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PWSrp2y8iTvR; Tue, 18 Oct 2022 03:38:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F1E4B83B;
	Tue, 18 Oct 2022 03:38:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FD744B83B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 03:38:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HFWdVYSIjnek for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Oct 2022 03:38:15 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A66D4B796
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 03:38:15 -0400 (EDT)
Date: Tue, 18 Oct 2022 10:38:10 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666078693;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=eDSLSj2+FaCxQ6JLOSZjjUSUkBTENn2p5h3lOz7sOjY=;
 b=o1dpkomXpwV9dzvGmvAHVlFIgbKBjOFqgV0rhu8SA3nYpXBU6lD0AKjNAaM69XMuWGANJO
 Vqz/YKBT74G+2lVeKuz8uC0x4zI5BrOruBKTe51bMhKywgbfH813oTyKvbxqahKOYNEJtd
 zmcIscrJ3o5tY/vF4q6moMcHMCl2GB4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y05X4o1TxxkvES9E@google.com>
References: <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n> <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local> <Y0SxnoT5u7+1TCT+@google.com>
 <Y0S2zY4G7jBxVgpu@xz-m1.local> <Y0TDCxfVVme8uPGU@google.com>
 <Y0mUh5dEErRVtfjl@x1n>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y0mUh5dEErRVtfjl@x1n>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Oct 14, 2022 at 12:55:35PM -0400, Peter Xu wrote:
> On Tue, Oct 11, 2022 at 01:12:43AM +0000, Oliver Upton wrote:
> > The VMM must know something about the architecture it is running on, as
> > it calls KVM_DEV_ARM_ITS_SAVE_TABLES after all...
> 
> IIUC this is still a kernel impl detail to flush data into guest pages
> within this ioctl, or am I wrong?

Somewhat...

The guest is assigning memory from the IPA space to back the ITS tables,
but KVM maintains its own internal representation. It just so happens
that we've conditioned userspace to be aware that ITS emulation is
incoherent w.r.t. the guest memory that backs the tables.

> For example, I'm assuming it's safe to change KVM_DEV_ARM_ITS_SAVE_TABLES
> impl one day to not flush data to guest memories, then the kernel should
> also disable the ALLOW_BITMAP cap in the same patch, so that any old qemu
> binary that supports arm64 dirty ring will naturally skip all the bitmap
> ops and becoming the same as what it does with x86 when running on that new
> kernel.  With implicit approach suggested, we need to modify QEMU.
> 
> Changing impl of KVM_DEV_ARM_ITS_SAVE_TABLES is probably not a good
> example.. but just want to show what I meant.  Fundamentally it sounds
> cleaner if it's the kernel that tells the user "okay you collected the
> ring, but that's not enough; you need to collect the bitmap too", rather
> than assuming the user app will always know what kvm did in details.  No
> strong opinion though, as I could also have misunderstood how arm works.

I think the SAVE_TABLES ioctl is likely here to stay given the odd quirk
that it really is guest memory, so we'll probably need the bitmap on
arm64 for a long time. Even if we were to kill it, userspace would need
to take a change anyway to switch to a new ITS migration mechanism.

If we ever get to the point that we can relax this restriction i think a
flag on the BITMAP_WITH_TABLE cap that says "I don't actually set any
bits in the bitmap" would do. We shouldn't hide the cap entirely, as
that would be ABI breakage for VMMs that expect bitmap+ring.

Thoughts?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

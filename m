Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE559C433E2
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:28:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DFCE21741
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R9Hi2bir"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DFCE21741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACFE64B575;
	Mon,  7 Sep 2020 11:28:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J27AbMElCunH; Mon,  7 Sep 2020 11:28:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61E894B2BA;
	Mon,  7 Sep 2020 11:28:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 842874B2BA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:28:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sXpxmSsfd-kB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 11:28:28 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48E5D4B26E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:28:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599492508;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8sVz1sXB3S8O+Ei2CKhwWlGsleL+awuWDP8l7TGlMTQ=;
 b=R9Hi2birWVxPEBY/RqcwJ5jN7pBluzCCap02DE8qrEPjNd6wFbzDR2GuYkJ2pRtzrDKFgx
 AFLeLXfouxNjGb2nNDAMwM7m16pZ/08lPfO6xeWWvZAjl6fxp3yHVgCopfXNqmfECeI17L
 e+ryuSBWKeYTh2W3neQBhGgOSunGc4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-lo-bhTY-OiOxxFEK9sC7Kg-1; Mon, 07 Sep 2020 11:28:24 -0400
X-MC-Unique: lo-bhTY-OiOxxFEK9sC7Kg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D0DD18B9EC1;
 Mon,  7 Sep 2020 15:28:22 +0000 (UTC)
Received: from work-vm (ovpn-114-180.ams2.redhat.com [10.36.114.180])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 742D65D9D2;
 Mon,  7 Sep 2020 15:28:15 +0000 (UTC)
Date: Mon, 7 Sep 2020 16:28:12 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To: Steven Price <steven.price@arm.com>, eric.auger@redhat.com
Subject: Re: [PATCH v2 0/2] MTE support for KVM guest
Message-ID: <20200907152812.GJ2682@work-vm>
References: <20200904160018.29481-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200904160018.29481-1-steven.price@arm.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: Peter Maydell <Peter.Maydell@arm.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

(cc'ing in Eric Auger)

* Steven Price (steven.price@arm.com) wrote:
> Arm's Memory Tagging Extension (MTE) adds 4 bits of tag data to every 16
> bytes of memory in the system. This along with stashing a tag within the
> high bit of virtual addresses allows runtime checking of memory
> accesses.
> 
> These patches add support to KVM to enable MTE within a guest. They are
> based on Catalin's v9 MTE user-space support series[1].
> 
> I'd welcome feedback on the proposed user-kernel ABI. Specifically this
> series currently:
> 
>  1. Requires the VMM to enable MTE per-VCPU.
>  2. Automatically promotes (normal host) memory given to the guest to be
>     tag enabled (sets PG_mte_tagged), if any VCPU has MTE enabled. The
>     tags are cleared if the memory wasn't previously MTE enabled.
>  3. Doesn't provide any new methods for the VMM to access the tags on
>     memory.
> 
> (2) and (3) are particularly interesting from the aspect of VM migration.
> The guest is able to store/retrieve data in the tags (presumably for the
> purpose of tag checking, but architecturally it could be used as just
> storage). This means that when migrating a guest the data needs to be
> transferred (or saved/restored).
> 
> MTE tags are controlled by the same permission model as normal pages
> (i.e. a read-only page has read-only tags), so the normal methods of
> detecting guest changes to pages can be used. But this would also
> require the tags within a page to be migrated at the same time as the
> data (since the access control for tags is the same as the normal data
> within a page).

(Without understanding anything about your tag system...)

Note that during (normal, non-postcopy) migration the consistency can
be a little loose - until the guest starts running; i.e. you can send
a page that's in themiddle of being modified as long as you make sure
you send it again later so that what the guest sees on the destination
when it runs is consistent; i.e. it would be fine to send your tags
separately to your data and allow them to get a little out of sync, as
long as they caught up before the guest ran.

> (3) may be problematic and I'd welcome input from those familiar with
> VMMs. User space cannot access tags unless the memory is mapped with the
> PROT_MTE flag. However enabling PROT_MTE will also enable tag checking
> for the user space process (assuming the VMM enables tag checking for
> the process) and since the tags in memory are controlled by the guest
> it's unlikely the VMM would have an appropriately tagged pointer for its
> access. This means the VMM would either need to maintain two mappings of
> memory (one to access tags, the other to access data) or disable tag
> checking during the accesses to data.

Imagine I had a second mapping; what would it look like; how would I get
and restore the tags?

In terms of migration stream, I guess we have two ways to do this,
either it rides shotgun on the main RAM section pages, transmitting
those few extra bytes whenever we transmit a page, or you have a
separate iteratable device for RAMtags, and it just transmits those.
How you keep the two together is an interesting question.
The shotgun method sounds nasty to avoid putting special cases in the,
already hairy, RAM code.

> If it's not practical to either disable tag checking in the VMM or
> maintain multiple mappings then the alternatives I'm aware of are:
> 
>  * Provide a KVM-specific method to extract the tags from guest memory.
>    This might also have benefits in terms of providing an easy way to
>    read bulk tag data from guest memory (since the LDGM instruction
>    isn't available at EL0).
>  * Provide support for user space setting the TCMA0 or TCMA1 bits in
>    TCR_EL1. These would allow the VMM to generate pointers which are not
>    tag checked.

I guess you want the VMM to do as much tagged checked access as possible
on it's own data structures?

How do things like virtio work where the qemu or kernel is accessing
guest memory for IO?

Dave

> Feedback is welcome, and feel free to ask questions if anything in the
> above doesn't make sense.
> 
> Changes since the previous v1 posting[2]:
> 
>  * Rebasing clean-ups
>  * sysreg visibility is now controlled based on whether the VCPU has MTE
>    enabled or not
> 
> [1] https://lore.kernel.org/r/20200904103029.32083-1-catalin.marinas@arm.com
> [2] https://lore.kernel.org/r/20200713100102.53664-1-steven.price%40arm.com
> 
> Steven Price (2):
>   arm64: kvm: Save/restore MTE registers
>   arm64: kvm: Introduce MTE VCPU feature
> 
>  arch/arm64/include/asm/kvm_emulate.h       |  3 +++
>  arch/arm64/include/asm/kvm_host.h          |  9 ++++++++-
>  arch/arm64/include/asm/sysreg.h            |  3 ++-
>  arch/arm64/include/uapi/asm/kvm.h          |  1 +
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 14 ++++++++++++++
>  arch/arm64/kvm/mmu.c                       | 15 +++++++++++++++
>  arch/arm64/kvm/reset.c                     |  8 ++++++++
>  arch/arm64/kvm/sys_regs.c                  | 20 +++++++++++++++-----
>  8 files changed, 66 insertions(+), 7 deletions(-)
> 
> -- 
> 2.20.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

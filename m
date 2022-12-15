Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C18C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 15 Dec 2022 18:12:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 811304B7FC;
	Thu, 15 Dec 2022 13:12:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dp4O3n7riSDS; Thu, 15 Dec 2022 13:12:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 680D74B82B;
	Thu, 15 Dec 2022 13:12:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 777814B828
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2022 13:12:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZM0SE-cazSes for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Dec 2022 13:12:21 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F16F34B825
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2022 13:12:20 -0500 (EST)
Date: Thu, 15 Dec 2022 18:12:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1671127939;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=NR0RL3zpixZswsWefFQZYtOaaPkMaQgei0oRBq1daFM=;
 b=hLEvw7pLYE0dgSwnXDsnPKUS/uso1iZ7ESDgITzTMi7HhtQpedIxSSY9l8NGreYhOa95Wh
 Y6Qibd87eoQzB6BqcrAwtwJOw/KYydgFlCGkjGuBaw/dAc/htmNEZhlb/rik0/OKLVI/wR
 sHdAsAC00DylzFzKaZ+tZRm0pxM3oMw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v1 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm s2
Message-ID: <Y5tjfmJRFY2pFlr4@google.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <Y5pvzKYdZK79nyZw@google.com>
 <c19594a6-358b-c0de-b1f5-84de38015379@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c19594a6-358b-c0de-b1f5-84de38015379@arm.com>
X-Migadu-Flow: FLOW_OUT
Cc: Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Thu, Dec 15, 2022 at 09:33:17AM +0000, Ryan Roberts wrote:
> On 15/12/2022 00:52, Oliver Upton wrote:
> > On Tue, Dec 06, 2022 at 01:59:18PM +0000, Ryan Roberts wrote:
> >> (appologies, I'm resending this series as I managed to send the cover letter to
> >> all but the following patches only to myself on first attempt).
> >>
> >> This is my first upstream feature submission so please go easy ;-)
> > 
> > Welcome :)
> > 
> >> Support 52-bit Output Addresses: FEAT_LPA2 changes the format of the PTEs. The
> >> HW advertises support for LPA2 independently for stage 1 and stage 2, and
> >> therefore its possible to have it for one and not the other. I've assumed that
> >> there is a valid case for this if stage 1 is not supported but stage 2 is, KVM
> >> could still then use LPA2 at stage 2 to create a 52 bit IPA space (which could
> >> then be consumed by a 64KB page guest kernel with the help of FEAT_LPA). Because
> >> of this independence and the fact that the kvm pgtable library is used for both
> >> stage 1 and stage 2 tables, this means the library now has to remember the
> >> in-use format on a per-page-table basis. To do this, I had to rework some
> >> functions to take a `struct kvm_pgtable *` parameter, and as a result, there is
> >> a noisy patch to add this parameter.
> > 
> > Mismatch between the translation stages is an interesting problem...
> > 
> > Given that userspace is responsible for setting up the IPA space, I
> > can't really think of a strong use case for 52 bit IPAs with a 48 bit
> > VA. Sure, the VMM could construct a sparse IPA space or remap the same
> > HVA at multiple IPAs to artificially saturate the address space, but
> > neither seems terribly compelling.
> > 
> > Nonetheless, AFAICT we already allow this sort of mismatch on LPA &&
> > !LVA systems. A 48 bit userspace could construct a 52 bit IPA space for
> > its guest.
> 
> I guess a simpler approach would be to only use LPA2 if its supported by both
> stage1 and stage2. Then the code could just use a static key in the few required
> places.

Ah, you caught on quick to what I was thinking :-)

What I'm groaning about in particular is the changes to the TLB
invalidation path, as it feels like a static key is warranted there.
Nonetheless, it is all a bit of a mess depending on LPA2 support in both
the kernel and KVM.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

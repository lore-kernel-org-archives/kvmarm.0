Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6258AC433E2
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 10:06:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C80C920658
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 10:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1XDSYl56"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C80C920658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F6E14B238;
	Wed,  2 Sep 2020 06:06:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PxjT-EmEDfKx; Wed,  2 Sep 2020 06:06:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 377214B275;
	Wed,  2 Sep 2020 06:06:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A00C64B275
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 06:06:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RdjZsm2LPPKU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 06:06:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB2D24B238
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 06:06:31 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8D92920658;
 Wed,  2 Sep 2020 10:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599041190;
 bh=sT4E6AnMCVQaoeKJAZtiZS9ZtiA6X40Ljf9mTG8VKz0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=1XDSYl56YmAI1O/WYqCWbc7w4l9MbZVbKzdkjaF4umjkh/IqUW1QiP5Yz8/grBE9N
 i0XaquQGbm9P9ZafnoiPf5l6d4AVE/yEnEw6F+KHrrOwdhqn2HHzTXcTB1vdSHO0Et
 Ehq54beFgj+97ckiZSapqIRAoX5+9vw5McGnDSr0=
Date: Wed, 2 Sep 2020 11:06:26 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 03/21] KVM: arm64: Add support for creating
 kernel-agnostic stage-1 page tables
Message-ID: <20200902100625.GB5567@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-4-will@kernel.org>
 <57e40fa8-f6e3-d442-3bd4-412f04d88a4b@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57e40fa8-f6e3-d442-3bd4-412f04d88a4b@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

Hi Alex,

On Fri, Aug 28, 2020 at 04:35:24PM +0100, Alexandru Elisei wrote:
> On 8/25/20 10:39 AM, Will Deacon wrote:
> > The generic page-table walker is pretty useless as it stands, because it
> > doesn't understand enough to allocate anything. Teach it about stage-1
> > page-tables, and hook up an API for allocating these for the hypervisor
> > at EL2.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  34 +++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 131 +++++++++++++++++++++++++++
> >  2 files changed, 165 insertions(+)

[...]

> > +/**
> > + * kvm_pgtable_hyp_map() - Install a mapping in a hypervisor stage-1 page-table.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_hyp_init().
> > + * @addr:	Virtual address at which to place the mapping.
> > + * @size:	Size of the mapping.
> > + * @phys:	Physical address of the memory to map.
> > + * @prot:	Permissions and attributes for the mapping.
> > + *
> > + * If device attributes are not explicitly requested in @prot, then the
> > + * mapping will be normal, cacheable.
> > + *
> > + * Return: 0 on success, negative error code on failure.
> 
> From my understanding of the code, when the caller replaces an existing leaf entry
> or a table with a different one, KVM will print a warning instead of using
> break-before-make (if necessary). It might be worth pointing out that it is
> expected from the callers not to do that, because it's not immediately obvious.

For hypervisor stage-1 mappings, we WARN() and ignore the mapping request
if we run into an existing valid leaf entry for a different mapping. That
shouldn't happen, as hyp mappings are typically static and performed only
for the .hyp.* sections and the GICv2 memory-mapped bits. We don't even
provide an unmap interface. But yes, I can mention this in the comment:

  | Attempts to install a mapping for a virtual address that is already
  | mapped will be rejected with an error and a WARN().

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

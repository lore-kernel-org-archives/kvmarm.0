Return-Path: <SRS0=lGHe=IB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4890C433E6
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 11:49:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3589164EE3
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 11:49:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3589164EE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B32114B761;
	Wed,  3 Mar 2021 06:49:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gHduLvMdRLL8; Wed,  3 Mar 2021 06:49:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABD3D4B64F;
	Wed,  3 Mar 2021 06:49:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6EFB4B64F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 06:49:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VQZyPN916R7t for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Mar 2021 06:49:33 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4FCA4B5F1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 06:49:33 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B67164EDE;
 Wed,  3 Mar 2021 11:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614772172;
 bh=Ij+AIShpeMAYkd5iWPOBrQjZXlkiW/5YIu+UuS8glCU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=foFVp21i4EfsQIt8xvEyoy9aciANAodw7gEORSgUZaZw9WjHCDXEPv2fBv7EBQS9/
 EoVtXyjL7zUZpCeVedc8Rz4n6eLhzkaBD/3UsBf5tI+bQ4x+D9l92frKV579p8fvJF
 ygoLD0BfY0OjGVhYCK3EhYgjypX8Tt0nMSQUy0ChnMNQChVe5F6UNfeuB/EXa/uNej
 VkWCOKhelIUHw6mCRcsc2k01d/i64zJS23cuMbInzMR0vyg4qyu99RuKNP3nd0OZ2U
 DeR/JHSYIFPgrk70zakPbRx3SYLcS0OD/8boKw67k81RZq1ZO5nI/FDzs+E2ASENq7
 7HYOnD8klGLOg==
Date: Wed, 3 Mar 2021 11:49:24 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix unaligned addr case in mmu walking
Message-ID: <20210303114924.GB18452@willie-the-truck>
References: <20210303024225.2591-1-justin.he@arm.com>
 <87sg5czhny.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sg5czhny.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Jia He <justin.he@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 03, 2021 at 09:54:25AM +0000, Marc Zyngier wrote:
> Hi Jia,
> 
> On Wed, 03 Mar 2021 02:42:25 +0000,
> Jia He <justin.he@arm.com> wrote:
> > 
> > If the start addr is not aligned with the granule size of that level.
> > loop step size should be adjusted to boundary instead of simple
> > kvm_granual_size(level) increment. Otherwise, some mmu entries might miss
> > the chance to be walked through.
> > E.g. Assume the unmap range [data->addr, data->end] is
> > [0xff00ab2000,0xff00cb2000] in level 2 walking and NOT block mapping.
> 
> When does this occur? Upgrade from page mappings to block? Swap out?
> 
> > And the 1st part of that pmd entry is [0xff00ab2000,0xff00c00000]. The
> > pmd value is 0x83fbd2c1002 (not valid entry). In this case, data->addr
> > should be adjusted to 0xff00c00000 instead of 0xff00cb2000.
> 
> Let me see if I understand this. Assuming 4k pages, the region
> described above spans *two* 2M entries:
> 
> (a) ff00ab2000-ff00c00000, part of ff00a00000-ff00c00000
> (b) ff00c00000-ff00db2000, part of ff00c00000-ff00e00000
> 
> (a) has no valid mapping, but (b) does. Because we fail to correctly
> align on a block boundary when skipping (a), we also skip (b), which
> is then left mapped.
> 
> Did I get it right? If so, yes, this is... annoying.
> 
> Understanding the circumstances this triggers in would be most
> interesting. This current code seems to assume that we get ranges
> aligned to mapping boundaries, but I seem to remember that the old
> code did use the stage2_*_addr_end() helpers to deal with this case.
> 
> Will: I don't think things have changed in that respect, right?

We've maintained stage2_pgd_addr_end() for the top-level iterator, but
it looks like we're failing to do the rounding in __kvm_pgtable_visit()
when hitting a leaf entry, so the caller (__kvm_pgtable_walk()) will
terminate early.

I agree that it's annoying, as you'd have expected us to run into this
earlier on.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

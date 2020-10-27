Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A668C4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 09:27:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3AB6206D4
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 09:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJ1TwWCp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3AB6206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6508B4B543;
	Tue, 27 Oct 2020 05:27:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xjy-cA8omg1q; Tue, 27 Oct 2020 05:27:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C9214B541;
	Tue, 27 Oct 2020 05:27:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5AA54B541
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 05:27:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aBYtHL1eQ23W for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 05:27:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC35A4B539
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 05:27:26 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B07EC206D4;
 Tue, 27 Oct 2020 09:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603790845;
 bh=ef3tSgJGvh/+FW5JytROaTs+HrLt7cDNgPcoVVzeMsk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=jJ1TwWCpKmTKJfG+GwdjZxMmBZwedALky+iq8rltvGWCNQt+d1i9Gdo+LEaaIowAL
 nDwwMv5YMMhbqIAXPs3tBdH4He1eoxzYm/+vVD3UNF2Qg+Qv/XaeQHH4wowBsktDri
 wI6W9nfBDNDboETTK21kD+gOdseJgjZsmiRHp6IQ=
Date: Tue, 27 Oct 2020 09:27:21 +0000
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Allocate stage-2 pgd pages with
 GFP_KERNEL_ACCOUNT
Message-ID: <20201027092720.GB26019@willie-the-truck>
References: <20201026144423.24683-1-will@kernel.org>
 <962c401d-4376-7ecf-1a8b-b6ad91ecfe68@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <962c401d-4376-7ecf-1a8b-b6ad91ecfe68@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
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

On Tue, Oct 27, 2020 at 10:41:33AM +1100, Gavin Shan wrote:
> On 10/27/20 1:44 AM, Will Deacon wrote:
> > For consistency with the rest of the stage-2 page-table page allocations
> > (performing using a kvm_mmu_memory_cache), ensure that __GFP_ACCOUNT is
> > included in the GFP flags for the PGD pages.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >   arch/arm64/kvm/hyp/pgtable.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> 
> The patch itself looks good to me:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> Another question is why the page-table pages for hyp mode aren't
> allocated with __GFP_ACCOUNT in kvm_pgtable_hyp_init and hyp_map_walker()?
> The page-table pages for host or guest are allocated with GFP_PGTABLE_USER
> in alloc_pte_one().
> 
> #define GFP_PGTABLE_USER      (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> #define GFP_PGTABLE_KERNEL    (GFP_KERNEL | __GFP_ZERO)

I think because the guest pages are allocated as a direct result of the VMM,
whereas I tend to think of the hyp page-tables more like kernel page-tables
(which aren't accounted afaik: see GFP_PGTABLE_USER vs GFP_PGTABLE_KERNEL).

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

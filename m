Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1CDC433E9
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:59:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E156C64DDB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:59:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E156C64DDB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 541024B274;
	Wed,  3 Feb 2021 10:59:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IJh-vjJ13Pv1; Wed,  3 Feb 2021 10:59:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A91E4B276;
	Wed,  3 Feb 2021 10:59:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7ACB4B246
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:59:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uVnCIwJ9nUFH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 10:59:51 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C41364B1E3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:59:51 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E6AF64F65;
 Wed,  3 Feb 2021 15:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612367990;
 bh=vd0JgwFi9SFygRPs6uJBA5IlqSHA0J4/viQnsdxbe6M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=XwgRTmY+wbR2AWWneR+QRJ+VxZOq50HCSKKrgH5Ecgmq4c+MJskCHQNeDrpF1IQGq
 APHOyD709mozvFdQurnEctqaf5sR8hTJFQxdJH9/B7y7cIBkVdQjdZ1Qbof8UzG987
 BQazpTejCHkc1coZ1E/4d0ZGeFNwC9SZYr1l0ixSgILWhLjE45A+GbmW34Q0VgN6Zl
 k4kxRTSM6m9ocPQNOAuiHsoQG1tMMotCPw2k+NGSot83udwo4MSjZ5KJHmJpjBhUBo
 WIw9nqDlqBmjXY0m58gAS3DSUXRXzpFzWrkpGSpJuI7zrgVkZrnXF9Fg+Ob5UNyDm1
 Mr4VG7u9YtZYw==
Date: Wed, 3 Feb 2021 15:59:44 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 24/26] KVM: arm64: Make memcache anonymous in
 pgtable allocator
Message-ID: <20210203155944.GH18974@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-25-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-25-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jan 08, 2021 at 12:15:22PM +0000, Quentin Perret wrote:
> The current stage2 page-table allocator uses a memcache to get
> pre-allocated pages when it needs any. To allow re-using this code at
> EL2 which uses a concept of memory pools, make the memcache argument to
> kvm_pgtable_stage2_map() anonymous. and let the mm_ops zalloc_page()
> callbacks use it the way they need to.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 6 +++---
>  arch/arm64/kvm/hyp/pgtable.c         | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 8e8f1d2c5e0e..d846bc3d3b77 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -176,8 +176,8 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>   * @size:	Size of the mapping.
>   * @phys:	Physical address of the memory to map.
>   * @prot:	Permissions and attributes for the mapping.
> - * @mc:		Cache of pre-allocated GFP_PGTABLE_USER memory from which to
> - *		allocate page-table pages.
> + * @mc:		Cache of pre-allocated memory from which to allocate page-table
> + *		pages.

We should probably mention that this memory must be zeroed, since I don't
think the page-table code takes care of that.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

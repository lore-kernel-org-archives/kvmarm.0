Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154B2C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 08:38:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B1932080C
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 08:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qGEn+X97"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B1932080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE6644B35D;
	Wed, 16 Sep 2020 04:38:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6I96puJwUyQP; Wed, 16 Sep 2020 04:38:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 004AB4B34D;
	Wed, 16 Sep 2020 04:38:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E73E4B324
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 04:38:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2yl175tCR15w for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 04:38:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E8644B19E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 04:38:03 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A4FA82064E;
 Wed, 16 Sep 2020 08:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600245482;
 bh=ayHqD0TxwK+DKfoaoQ5U/0qGfOY6exkP6goS8angK4c=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qGEn+X97bm/YN/f+V8umKxtNMSFx/ciTUIo7tQe8epZAfaYwBRvP6AEB5Z5NInYAD
 S3STXFRBhTgYskh7xiRZm9P5KJIN/vOPJWDaBdcjdTou5QCVZYtRIuk2X40h3l80fw
 uQ5jSfJsSaY2ecWqqpn4aTryoCuef03zQiXcvC+s=
Date: Wed, 16 Sep 2020 09:37:57 +0100
From: Will Deacon <will@kernel.org>
To: Xiaofei Tan <tanxiaofei@huawei.com>
Subject: Re: [PATCH v2] KVM: arm64: fix doc warnings in mmu code
Message-ID: <20200916083756.GD27496@willie-the-truck>
References: <1600221639-4471-1-git-send-email-tanxiaofei@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1600221639-4471-1-git-send-email-tanxiaofei@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 16, 2020 at 10:00:39AM +0800, Xiaofei Tan wrote:
> Fix following warnings caused by mismatch bewteen function parameters
> and comments.
> arch/arm64/kvm/mmu.c:128: warning: Function parameter or member 'mmu' not described in '__unmap_stage2_range'
> arch/arm64/kvm/mmu.c:128: warning: Function parameter or member 'may_block' not described in '__unmap_stage2_range'
> arch/arm64/kvm/mmu.c:128: warning: Excess function parameter 'kvm' description in '__unmap_stage2_range'
> arch/arm64/kvm/mmu.c:499: warning: Function parameter or member 'writable' not described in 'kvm_phys_addr_ioremap'
> arch/arm64/kvm/mmu.c:538: warning: Function parameter or member 'mmu' not described in 'stage2_wp_range'
> arch/arm64/kvm/mmu.c:538: warning: Excess function parameter 'kvm' description in 'stage2_wp_range'
> 
> Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
> ---
>  arch/arm64/kvm/mmu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e8a51799..909e995 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -114,9 +114,10 @@ static bool kvm_is_device_pfn(unsigned long pfn)
>   */
>  /**
>   * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
> - * @kvm:   The VM pointer
> + * @mmu:   pointer to mmu structure to operate on
>   * @start: The intermediate physical base address of the range to unmap
>   * @size:  The size of the area to unmap
> + * @may_block: The flag that if block is allowed here

Whether or not we are permitted to block.

>   *
>   * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>   * be called while holding mmu_lock (unless for freeing the stage2 pgd before
> @@ -493,6 +494,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   * @guest_ipa:	The IPA at which to insert the mapping
>   * @pa:		The physical address of the device
>   * @size:	The size of the mapping
> + * @writable:   If it is writable here

Whether or not to create a writable mapping.

>   */
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  			  phys_addr_t pa, unsigned long size, bool writable)
> @@ -530,7 +532,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  
>  /**
>   * stage2_wp_range() - write protect stage2 memory region range
> - * @kvm:	The KVM pointer
> + * @mmu:        pointer to mmu structure to operate on

The KVM stage-2 MMU pointer.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

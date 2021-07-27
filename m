Return-Path: <SRS0=phmX=MT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A688C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:12:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2CC4560F59
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2CC4560F59
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D55FA4AEDC;
	Tue, 27 Jul 2021 14:12:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8IW34pBueUDm; Tue, 27 Jul 2021 14:12:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C793E4AEE2;
	Tue, 27 Jul 2021 14:12:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC83A4AED4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:12:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5LMbbFhteRNE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Jul 2021 14:12:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1F744A534
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:12:09 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD3946056B;
 Tue, 27 Jul 2021 18:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627409529;
 bh=fUgkuFB9VQtgL1VRh8fF7edi9U2ibRcCUZV2oZL57h8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=cpxx1nirtagKB64kip87dBNB4SjfC/kG0WM5+aseu385nTOwDTylRCPPxcHHEKwf4
 S/qfl0CnSLCp9sK+uhtUVArERHSiTR7kkyPKN3sq91+Zg5hJSy5mlTys4lOcf64vbg
 Uzt9HkAx8h1hcXSUxH2ZVPiwZInxVvvWK6Yd2+f2RvEJSo7d4I04xtqexTPdTbtzSq
 6pPq1ijZab66hHRoS6BHWS/xdQG0UfWek6Cq3yLNt+lx7b1GmqOeo3uT4+9QhCTbuj
 obYyb3hXWK+0f4QnJlejAIT2PVix0kDbobIpTmsJqi74OX4pei/3hFhpxQmVgnTisi
 P/T7JGHLrHYog==
Date: Tue, 27 Jul 2021 19:12:04 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 12/16] mm/ioremap: Add arch-specific callbacks on
 ioremap/iounmap calls
Message-ID: <20210727181203.GG19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-13-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-13-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Jul 15, 2021 at 05:31:55PM +0100, Marc Zyngier wrote:
> Add a pair of hooks (ioremap_page_range_hook/iounmap_page_range_hook)
> that can be implemented by an architecture.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/linux/io.h |  3 +++
>  mm/ioremap.c       | 13 ++++++++++++-
>  mm/vmalloc.c       |  8 ++++++++
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/io.h b/include/linux/io.h
> index 9595151d800d..0ffc265f114c 100644
> --- a/include/linux/io.h
> +++ b/include/linux/io.h
> @@ -21,6 +21,9 @@ void __ioread32_copy(void *to, const void __iomem *from, size_t count);
>  void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
>  
>  #ifdef CONFIG_MMU
> +void ioremap_page_range_hook(unsigned long addr, unsigned long end,
> +			     phys_addr_t phys_addr, pgprot_t prot);
> +void iounmap_page_range_hook(phys_addr_t phys_addr, size_t size);
>  int ioremap_page_range(unsigned long addr, unsigned long end,
>  		       phys_addr_t phys_addr, pgprot_t prot);
>  #else

Can we avoid these hooks by instead not registering the regions proactively
in the guest and moving that logic to a fault handler which runs off the
back of the injected data abort? From there, we could check if the faulting
IPA is a memory address and register it as MMIO if not.

Dunno, you've spent more time than me thinking about this, but just
wondering if you'd had a crack at doing it that way, as it _seems_ simpler
to my naive brain.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

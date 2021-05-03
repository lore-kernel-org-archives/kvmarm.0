Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB61DC433ED
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 07:02:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 077A1611CD
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 07:02:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 077A1611CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6284B332;
	Mon,  3 May 2021 03:02:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id usnXvlMn81dN; Mon,  3 May 2021 03:02:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E67C4B335;
	Mon,  3 May 2021 03:02:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6A84B335
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 03:02:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I1CRBqcBtU-G for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 03:02:03 -0400 (EDT)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6725A4B332
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 03:02:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=EvzK/tNTFu6j7RpqReg+UsePxfTlwWDpS1m4nxob5S8=; b=d+fupqW0bciG3xsylg36LLTQ15
 +QOOLEWa0exqDSIyE2RFjDoTQS5TD06FY0/1FfQh1XNyXHeFTsG9tyenVBVIqgjCBGawuG14FPPQb
 nlgJ4eujI3lzEMR10byAqYaaw88/xqIRqygJ5YIZ9PGkOsxhy0ki3ZQtW3ya69QlCjplaZenO46s3
 CkePR34QF23Hm6BAF/3bUu0VKRE3N5IjTHEqDqDYFI3jHmEo9AfrGQSPCIGrZ0Y8/bi+X18cTDSU5
 0b538F8+voZe0aZQuAYNWKR2ipPh29rG5HgUm/aggYZDfxdDlS/AZf2JS+8jK3UFDn0+WK/YHAl6N
 vR5rCHXw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
 Linux)) id 1ldSaF-00Elgh-Vf; Mon, 03 May 2021 07:01:37 +0000
Date: Mon, 3 May 2021 08:01:35 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Shanker Donthineni <sdonthineni@nvidia.com>
Subject: Re: [RFC 0/2] [RFC] Honor PCI prefetchable attributes for a virtual
 machine on ARM64
Message-ID: <20210503070135.GA3515187@infradead.org>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210429162906.32742-1-sdonthineni@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 casper.infradead.org. See http://www.infradead.org/rpr.html
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Vikram Sethi <vsethi@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Jason Sequeira <jsequeira@nvidia.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Apr 29, 2021 at 11:29:04AM -0500, Shanker Donthineni wrote:
> Problem statement: Virtual machine crashes when NVIDIA GPU driver access a prefetchable BAR space due to the unaligned reads/writes for pass-through devices. The same binary works fine as expected in the host kernel. Only one BAR has control & status registers (CSR) and other PCI BARs are marked as prefetchable. NVIDIA GPU driver uses the write-combine feature for mapping the prefetchable BARs to improve performance. This problem applies to all other drivers which want to enable WC.

Unless you mean the noveau drivers this simply does not matter.  Please
don't spam the kernel lists with issues with your broken and license
violating drivers.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=WfsG=3M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAA3C2D0DB
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jan 2020 11:59:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E6ED2467E
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jan 2020 11:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uVF5rERq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E6ED2467E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 370724AF23;
	Thu, 23 Jan 2020 06:59:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dmsG3nWtRet4; Thu, 23 Jan 2020 06:59:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39E424AF22;
	Thu, 23 Jan 2020 06:59:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B23A94AF3E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jan 2020 06:59:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yoVtXVTUCxpw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jan 2020 06:59:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3EA54AF1F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jan 2020 06:59:14 -0500 (EST)
Received: from hump.haifa.ibm.com (nesher1.haifa.il.ibm.com [195.110.40.7])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id ACD3320704;
 Thu, 23 Jan 2020 11:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579780754;
 bh=sPgVONfMBssyrYeOuNYXulKqcfSKytB9nRTLqgRxmS8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=uVF5rERqT0jd+V9y/x+9lELDQyPdGpV1tP/mdrlK+qSKbSW1torLX2dCc/MLqgBEL
 Yn8ARXFSFu9OEqhGmdOsVxFcvKEe8f6UjhQcmBYEF4pxjKECfqUBjqawzluK1cE5pt
 fVrjwg4K5wErH4qLiwrRsizZx4Ecd9NfIs6YthKc=
Date: Thu, 23 Jan 2020 13:59:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 0/1] arm/arm64: add support for folded p4d page tables
Message-ID: <20200123115904.GA10436@hump.haifa.ibm.com>
References: <20200113111323.10463-1-rppt@kernel.org>
 <20200122185017.GA17321@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200122185017.GA17321@willie-the-truck>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Mike Rapoport <rppt@linux.ibm.com>,
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

On Wed, Jan 22, 2020 at 06:50:17PM +0000, Will Deacon wrote:
> On Mon, Jan 13, 2020 at 01:13:22PM +0200, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > This is a part of clean up of the page table manipulation code that aims to
> > remove asm-generic/5level-fixup.h and asm-generic/pgtable-nop4d-hack.h
> > 
> > There is a single patch for both arm and arm64 because doing the conversion
> > separately would mean breaking the shared mmu bits in virt/kvm/arm.
> 
> Unfortunately, that's going to be really hard to merge, as the two
> architectures are maintained in different trees and the breadth of this
> patch series is likely to lead to conflicts in both.

I anyway realized that sending these changes arch-by-arch was not so bright
idea, so my intention is to make "v2" include all the changes required to
drop asm-generic/5level-fixup.h and merge it via the -mm tree.
 
> Will

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

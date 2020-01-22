Return-Path: <SRS0=OV02=3L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883E2C2D0DB
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 18:50:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10D5A217F4
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 18:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+Ot0Q5e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10D5A217F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A24F14AE92;
	Wed, 22 Jan 2020 13:50:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YT7wvVjVUnIP; Wed, 22 Jan 2020 13:50:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9611B4AEC8;
	Wed, 22 Jan 2020 13:50:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5914AE92
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jan 2020 13:50:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eGbFWwMQvN0E for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jan 2020 13:50:24 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65FBE4A968
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jan 2020 13:50:24 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 426D5217F4;
 Wed, 22 Jan 2020 18:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579719023;
 bh=fQoQAjUDEAVwQrQeHLA+HkE9LCpRN8ToPkGfhrFGRTI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=b+Ot0Q5erq2ofBuHbSY4jl60BHqd5jvaTS2Z5b8zY9E2CCjpW/gUY7SmA6zxes5u5
 bi2BHeBPk6IhlFZECSrGz8HnFEfhJ/4Xept9OHvYsE9MiemYO4T6gr5/d3FMtJxid7
 4ziXuAQ8YYQEQWVs78cHw3ipxSjKjkn0OWuYacAs=
Date: Wed, 22 Jan 2020 18:50:17 +0000
From: Will Deacon <will@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v2 0/1] arm/arm64: add support for folded p4d page tables
Message-ID: <20200122185017.GA17321@willie-the-truck>
References: <20200113111323.10463-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200113111323.10463-1-rppt@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

On Mon, Jan 13, 2020 at 01:13:22PM +0200, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> This is a part of clean up of the page table manipulation code that aims to
> remove asm-generic/5level-fixup.h and asm-generic/pgtable-nop4d-hack.h
> 
> There is a single patch for both arm and arm64 because doing the conversion
> separately would mean breaking the shared mmu bits in virt/kvm/arm.

Unfortunately, that's going to be really hard to merge, as the two
architectures are maintained in different trees and the breadth of this
patch series is likely to lead to conflicts in both.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=hKGY=6M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6A8C83001
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 15:58:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C15220663
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 15:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQXqibFS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C15220663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E28084B38F;
	Tue, 28 Apr 2020 11:58:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UKHXYj4+1yhF; Tue, 28 Apr 2020 11:58:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F37714B384;
	Tue, 28 Apr 2020 11:58:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E0934B37E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 11:58:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c13eLM2SQcwM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2020 11:58:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 787484B35E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 11:58:54 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2E0D720663;
 Tue, 28 Apr 2020 15:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588089533;
 bh=0Bw2WYxz0osMy3g4eF8BHxR9jp93bTXexFG2uSWB8Z0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qQXqibFS7DE1Bc9mclFTDqJuH6c7bf615MUHCHv3NAPVvn22dm8rPlDGvn3QrOcZY
 LmYNgtOIWjP8X08DFvkMQkzEdQvLq7ZTVmQ8onWZbiKS2h+unO1LmjlZEkxdMkAa7f
 ASiYBjhY6YVMhkeIku/IrsxgrHYX7iAW+wYDbf6A=
Date: Tue, 28 Apr 2020 16:58:48 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: Fix spelling in code comments
Message-ID: <20200428155847.GC12697@willie-the-truck>
References: <20200401140310.29701-1-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200401140310.29701-1-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: trivial@kernel.org, kvm@vger.kernel.org, jeffv@google.com, maz@kernel.org,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Apr 01, 2020 at 03:03:10PM +0100, Fuad Tabba wrote:
> Fix spelling and typos (e.g., repeated words) in comments.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/guest.c        | 4 ++--
>  arch/arm64/kvm/reset.c        | 6 +++---
>  arch/arm64/kvm/sys_regs.c     | 6 +++---
>  virt/kvm/arm/arm.c            | 6 +++---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 2 +-
>  virt/kvm/arm/mmio.c           | 2 +-
>  virt/kvm/arm/mmu.c            | 6 +++---
>  virt/kvm/arm/psci.c           | 6 +++---
>  virt/kvm/arm/vgic/vgic-v3.c   | 2 +-
>  virt/kvm/coalesced_mmio.c     | 2 +-
>  virt/kvm/eventfd.c            | 2 +-
>  virt/kvm/kvm_main.c           | 2 +-
>  12 files changed, 23 insertions(+), 23 deletions(-)

FWIW, these *do* all look like valid typos to me, but I'll leave it at
Marc's discretion as to whether he wants to merge the series, since things
like this can confuse 'git blame' and get in the way of backports.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

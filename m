Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24449C433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:38:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6596064F58
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:38:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6596064F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E13364B1D1;
	Wed,  3 Feb 2021 10:38:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k7zoBuSyGfgW; Wed,  3 Feb 2021 10:38:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2C884B1DB;
	Wed,  3 Feb 2021 10:38:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86F764B1DB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:38:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 959JD2W7RmHv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 10:38:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0E0F4B1D1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:38:08 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88CCD64F8C;
 Wed,  3 Feb 2021 15:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612366687;
 bh=Qak6mhwDNjguVOOBu6kwlKWIJ1viPAqdFwNyzm7XLsY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=WE08rcuIZPrjb3tZ2Brfsaz61cnJTNscqfNeBsiftXJXvl0RFgDQMRQGsL9y4bvdz
 hRIEC9eV1iTFkGbVHirIkUTAbNC1fNlLxM3S6Ldc+fjAksC1NLVwUMWZKm6KlkRNbZ
 oxlaa7Y1p8USkggIuj3MNcsY6nu0QM8R6BUBq2hny0vI1g2a8ZiehGC7e7hI6OQCeD
 FnNkbnkIpmUgzCJs85nPzlOTQtPEiz0XhLSxv+5egwoARq3K8t2NEMo1GargXbJQgv
 h3MDcVD8FlPpYXhzKd9A8jHHWQaFTXJDy8gC3cs4x+2yDybuQSO1tZ5hQGV3sB84qo
 aRTYgR+mHu8Qw==
Date: Wed, 3 Feb 2021 15:38:01 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 19/26] KVM: arm64: Use kvm_arch in kvm_s2_mmu
Message-ID: <20210203153801.GD18974@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-20-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-20-qperret@google.com>
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

On Fri, Jan 08, 2021 at 12:15:17PM +0000, Quentin Perret wrote:
> In order to make use of the stage 2 pgtable code for the host stage 2,
> change kvm_s2_mmu to use a kvm_arch pointer in lieu of the kvm pointer,
> as the host will have the former but not the latter.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  arch/arm64/include/asm/kvm_mmu.h  | 7 ++++++-
>  arch/arm64/kvm/mmu.c              | 8 ++++----
>  3 files changed, 11 insertions(+), 6 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

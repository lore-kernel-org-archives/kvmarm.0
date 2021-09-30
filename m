Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBA5C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 13:07:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E26C4619EB
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 13:07:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E26C4619EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70CB14B0CC;
	Thu, 30 Sep 2021 09:07:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TLPjKkdoH8Ed; Thu, 30 Sep 2021 09:07:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD2854B0D9;
	Thu, 30 Sep 2021 09:07:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B80D04B0CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 09:07:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RJooytr62LnZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 09:07:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9999249DE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 09:07:22 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33017619E4;
 Thu, 30 Sep 2021 13:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633007241;
 bh=3CTzqJ6seyTwaKCCqSo//2u7V4K/VoTn43hSmcSetgo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=fn2yZ7NAX4ReoLZviOkyuwHmxIbenGbEKp+bVAs2ukXUbj8LJQgmwXwXxQb8HKzOc
 1OkWfih3hsTOdTG/4sAnyE9mWRl4AeyGDPwxgy0578k6MKysQAALscZwv4fSGhfPHS
 c/Lvg7ihSf9+JtP3ZUzA7qfavw//JA1yTnuVLxZ0fmAfEVAgbYfBH+PBd8V9MGhQZR
 rCIqROiGQqZBSZ2b3aEwH70mmGzwW0/fowbaEKWDHcM0+5iSoSQcn6n0OGFeD3pyin
 4hcZW3PzcjaWBtInV+pxcIdZi0vsJECrJGsIh1NU2aclBylZnGNwoXkSTd0062qtEn
 yt0qJ+7qXT8Cg==
Date: Thu, 30 Sep 2021 14:07:15 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v6 02/12] KVM: arm64: Don't include switch.h into
 nvhe/kvm-main.c
Message-ID: <20210930130715.GB23809@willie-the-truck>
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-3-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210922124704.600087-3-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Sep 22, 2021 at 01:46:54PM +0100, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> hyp-main.c includes switch.h while it only requires adjust-pc.h.
> Fix it to remove an unnecessary dependency.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 2da6aa8da868..8ca1104f4774 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -4,7 +4,7 @@
>   * Author: Andrew Scull <ascull@google.com>
>   */
>  
> -#include <hyp/switch.h>
> +#include <hyp/adjust_pc.h>
>  
>  #include <asm/pgtable-types.h>
>  #include <asm/kvm_asm.h>

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

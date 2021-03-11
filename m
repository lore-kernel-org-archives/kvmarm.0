Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DB1C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 17:29:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD87A64FE2
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 17:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD87A64FE2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23BA34B167;
	Thu, 11 Mar 2021 12:29:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1UXj2Yv7PSgr; Thu, 11 Mar 2021 12:29:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 245BE4B1C1;
	Thu, 11 Mar 2021 12:29:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA8E4B178
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 12:29:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FWkHKltpyFs9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 12:29:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FC264B167
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 12:29:00 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39BF264F8D;
 Thu, 11 Mar 2021 17:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615483739;
 bh=SUeqNhY4Z+cYtXpQCYJP8i17rbPK2GdEQhebAc/M+tU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=L7QwP3mI/PxaXZL6Lzb4Uj8lOgGQvuW2ooWh1d9r7PlRtwnOnWkaL0lkxdH4Io8dM
 33c0SarypvZ0j+O+tOyGFO9XW23anKOIKjMUm0OdqHWOemnYHBfhgzeDCNLJ0YpAUu
 i9voLaJivgCho9e8soLqDIKUvVRT4O8Y4bPmk/+ITnD8F6sHo02xfh9vqMZIERS0PP
 YQmJQK+2mB+cVYY8FaaD5yvGFbtgsuHPhmiG5TZXZHiXZPtKg/WQZrnhRtxiFgju/B
 hsId/apbJy3etztRisBSXv9NedsezIP/q9J4pUoHKQdIce0ea7xWXXr3c2OACBNw3Q
 bmKHEV4MQEEiA==
Date: Thu, 11 Mar 2021 17:28:52 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 17/34] KVM: arm64: Elevate hypervisor mappings
 creation at EL2
Message-ID: <20210311172852.GA31378@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-18-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310175751.3320106-18-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 10, 2021 at 05:57:34PM +0000, Quentin Perret wrote:
> Previous commits have introduced infrastructure to enable the EL2 code
> to manage its own stage 1 mappings. However, this was preliminary work,
> and none of it is currently in use.
> 
> Put all of this together by elevating the mapping creation at EL2 when
> memory protection is enabled. In this case, the host kernel running
> at EL1 still creates _temporary_ EL2 mappings, only used while
> initializing the hypervisor, but frees them right after.
> 
> As such, all calls to create_hyp_mappings() after kvm init has finished
> turn into hypercalls, as the host now has no 'legal' way to modify the
> hypevisor page tables directly.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h |  2 +-
>  arch/arm64/kvm/arm.c             | 87 +++++++++++++++++++++++++++++---
>  arch/arm64/kvm/mmu.c             | 43 ++++++++++++++--
>  3 files changed, 120 insertions(+), 12 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=roT/=JX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DC0C433ED
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 10:41:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC04B60FE5
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 10:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC04B60FE5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE0A4B40F;
	Mon, 26 Apr 2021 06:41:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P7O9mtgzIIXy; Mon, 26 Apr 2021 06:41:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3294B329;
	Mon, 26 Apr 2021 06:41:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D4424B297
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 06:41:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yc-p6xAFD4by for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Apr 2021 06:41:13 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 328584B222
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 06:41:13 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B05AF61185;
 Mon, 26 Apr 2021 10:41:11 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1layft-009SvS-Fz; Mon, 26 Apr 2021 11:41:09 +0100
MIME-Version: 1.0
Date: Mon, 26 Apr 2021 11:41:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Skip CMOs when updating a PTE pointing to
 non-memory
In-Reply-To: <20210426103605.616908-1-maz@kernel.org>
References: <20210426103605.616908-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <fa71b02d1a7c8be97968be1461749649@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, jean-philippe@linaro.org,
 suzuki.poulose@arm.com, kernel-team@android.com, james.morse@arm.com,
 sumitg@nvidia.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Sumit Gupta <sumitg@nvidia.com>, kernel-team@android.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-04-26 11:36, Marc Zyngier wrote:
> Sumit Gupta and Krishna Reddy both reported that for MMIO regions
> mapped into userspace using VFIO, a PTE update can trigger a MMU
> notifier reaching kvm_set_spte_hva().
> 
> There is an assumption baked in kvm_set_spte_hva() that it only
> deals with memory pages, and not MMIO. For this purpose, it
> performs a cache cleaning of the potentially newly mapped page.
> However, for a MMIO range, this explodes as there is no linear
> mapping for this range (and doing cache maintenance on it would
> make little sense anyway).
> 
> Check for the validity of the page before performing the CMO
> addresses the problem.
> 
> Reported-by: Krishna Reddy <vdumpa@nvidia.com>
> Reported-by: Sumit Gupta <sumitg@nvidia.com>,
> Tested-by: Sumit Gupta <sumitg@nvidia.com>,
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: 
> https://lore.kernel.org/r/5a8825bc-286e-b316-515f-3bd3c9c70a80@nvidia.com

FWIW, I've locally added:

Fixes: 694556d54f35 ("KVM: arm/arm64: Clean dcache to PoC when changing 
PTE due to CoW")
Cc: stable@vger.kernel.org

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

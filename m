Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42344C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:00:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CEFCA61059
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CEFCA61059
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 515DE40839;
	Thu, 12 Aug 2021 05:00:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UoGNtIx0akdz; Thu, 12 Aug 2021 05:00:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DC9D49E8C;
	Thu, 12 Aug 2021 05:00:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAC3740839
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 04:59:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id afqlOCdzVIdr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 04:59:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16829407F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 04:59:59 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F383A60C3F;
 Thu, 12 Aug 2021 08:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628758798;
 bh=LSnxIAWFBH+TXzoUemge/IGwf/7z3pt2Uhl+LDDkxG0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=itKfYN4tnJcJNST1aLwNL7a+/CGcbemG2hv6LXhDO5dQZTv+04wX+2HMYoiIC7c2G
 D99xgtedO5NbHZmKgAsT7fqJuOpp98cGy+w/+SOtceyBG2H+EDh8eKqSQZNkyQ7t3o
 SViG1JoldkmNPMYdEKqCbV832AmUrTYYHI+JsEye+2YhBtTBYZsif6yJJC+VqQap4b
 P4Rx2Jh1Q4uoTVzfiZjOoTnC72RvnmBEL0ytFbdktRyszTzG0ny1pyKyPYRFIYeT1A
 Y8CBF/mLJMFFwzPWbZ3HSZxM1R9hACQdgFrAbDuoc4WYHrW/vLtRR+mtqxg5b/X0to
 3fj6BL17+wRIQ==
Date: Thu, 12 Aug 2021 09:59:53 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 09/15] KVM: arm64: Add config register bit definitions
Message-ID: <20210812085952.GG5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-10-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-10-tabba@google.com>
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

On Mon, Jul 19, 2021 at 05:03:40PM +0100, Fuad Tabba wrote:
> Add hardware configuration register bit definitions for HCR_EL2
> and MDCR_EL2. Future patches toggle these hyp configuration
> register bits to trap on certain accesses.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)

I checked all of these against the Arm ARM and they look correct to me:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

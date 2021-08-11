Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3087FC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 18:43:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 984A46105A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 18:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 984A46105A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2700B40291;
	Wed, 11 Aug 2021 14:43:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id axJ18KJFIjtO; Wed, 11 Aug 2021 14:43:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A454020A;
	Wed, 11 Aug 2021 14:43:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB5534020A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 14:43:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cKL4p2YeTBKf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 14:43:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D002549DE7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 14:43:09 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DFB7561019;
 Wed, 11 Aug 2021 18:43:08 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mDtBy-004Oi9-RD; Wed, 11 Aug 2021 19:43:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
 kvmarm@lists.cs.columbia.edu, Alexandru Elisei <alexandru.elisei@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Quentin Perret <qperret@google.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Return -EPERM from __pkvm_host_share_hyp()
Date: Wed, 11 Aug 2021 19:43:02 +0100
Message-Id: <162870737148.2970653.12931848949565086445.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811173630.2536721-1-qperret@google.com>
References: <20210811173630.2536721-1-qperret@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, james.morse@arm.com,
 kvmarm@lists.cs.columbia.edu, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, qperret@google.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Wed, 11 Aug 2021 18:36:25 +0100, Quentin Perret wrote:
> Fix the error code returned by __pkvm_host_share_hyp() when the
> host attempts to share with EL2 a page that has already been shared with
> another entity.

Applied to next, thanks!

[1/1] KVM: arm64: Return -EPERM from __pkvm_host_share_hyp()
      commit: 12593568d7319c34c72038ea799ab1bd0f0eb01c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

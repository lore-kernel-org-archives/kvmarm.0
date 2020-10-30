Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAD4C55179
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F31D20756
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zDJ3/4os"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F31D20756
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E75414B53D;
	Fri, 30 Oct 2020 12:40:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BbgyzcURXeDB; Fri, 30 Oct 2020 12:40:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 993614B545;
	Fri, 30 Oct 2020 12:40:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C86B4B228
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mNSTX4lXu6LT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 12:40:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2748D4B21B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:31 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 16A192151B;
 Fri, 30 Oct 2020 16:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604076030;
 bh=zS4ms9lpY+5i0csRVlQid6DJtYxnZFqMNVqaAUo4X8g=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=zDJ3/4os3w8+PmOFABAHJX97XQh8lUQwe69Bl4735umr+DKPlil9l6xwTVdXBHux5
 P0eeJtFzeZWzXMtDYVymOs5k8AJ5Eu+EHClujSaPGIhc2mr8VUTxU6JbRTrbbvvtN7
 gZQ9iay1rch7P4OrwsX+xrG+QaqMpRGCcm0ZFsrM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYXS0-005noK-9W; Fri, 30 Oct 2020 16:40:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 08/12] KVM: arm64: Force PTE mapping on fault resulting in a
 device mapping
Date: Fri, 30 Oct 2020 16:40:13 +0000
Message-Id: <20201030164017.244287-9-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com,
 james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com,
 qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com,
 will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, stable@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, Qais Yousef <qais.yousef@arm.com>
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

From: Santosh Shukla <sashukla@nvidia.com>

VFIO allows a device driver to resolve a fault by mapping a MMIO
range. This can be subsequently result in user_mem_abort() to
try and compute a huge mapping based on the MMIO pfn, which is
a sure recipe for things to go wrong.

Instead, force a PTE mapping when the pfn faulted in has a device
mapping.

Fixes: 6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
[maz: rewritten commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1603711447-11998-2-git-send-email-sashukla@nvidia.com
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e431d2d8e368..c7c6df6309d5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -851,6 +851,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (kvm_is_device_pfn(pfn)) {
 		device = true;
+		force_pte = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

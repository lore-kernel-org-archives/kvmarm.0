Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5453CC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:59:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09AFB61073
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:59:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 09AFB61073
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B34C84B165;
	Fri,  8 Oct 2021 09:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W5us49P4UoYY; Fri,  8 Oct 2021 09:59:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6D634B190;
	Fri,  8 Oct 2021 09:59:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C4D94B0BF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:59:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bGhsG6vXc1xd for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 09:59:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B4684B0B8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:59:00 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09CE661108;
 Fri,  8 Oct 2021 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633701539;
 bh=JQ2vDfTTUv2kZVaFhWcuP9yI9JIJ01mjGFz/l+UPtH8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=o/yRBasuRkcPigzfjLMem83YshHKzzOmSqGMLIlAEeW8n0D+VR73we+TgbGPgGGBA
 RsiJUjoaqyL7pnTLLD1C8Uj6E4KOYfxDVjIxeVs9GtLOvfwsSeugN5jJ9K2O5BFcmK
 RK5ghodcW6948U7XQ3890/eL1dtGhJjZu8vb7orzTwxg+jTHE+SKOsa3Eez5Xe8F3p
 zMuUDru32bs6CeCQAvc5qfxBuUmK86GZm7iuWuDVhkaOZqU5J1uHTsWurF3nPV6i2b
 SxdX+3UYFjKSeKUtvj063j2vjgJ46CN6BJgHiRzA0ClwLK+GF4PG5su57HflyJQ2NV
 8+21lXlOvaJiQ==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 5/6] KVM: arm64: Prevent re-finalisation of pKVM for a
 given CPU
Date: Fri,  8 Oct 2021 14:58:38 +0100
Message-Id: <20211008135839.1193-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211008135839.1193-1-will@kernel.org>
References: <20211008135839.1193-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

__pkvm_prot_finalize() completes the deprivilege of the host when pKVM
is in use by installing a stage-2 translation table for the calling CPU.

Issuing the hypercall multiple times for a given CPU makes little sense,
but in such a case just return early with -EPERM rather than go through
the whole page-table dance again.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bacd493a4eac..cafe17e5fa8f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -123,6 +123,9 @@ int __pkvm_prot_finalize(void)
 	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
 	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
 
+	if (params->hcr_el2 & HCR_VM)
+		return -EPERM;
+
 	params->vttbr = kvm_get_vttbr(mmu);
 	params->vtcr = host_kvm.arch.vtcr;
 	params->hcr_el2 |= HCR_VM;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337CDC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:37:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA9E06126A
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:37:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CA9E06126A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 773214B2E0;
	Tue,  5 Oct 2021 07:37:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z8fDyqID7jjN; Tue,  5 Oct 2021 07:37:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63D074B2F9;
	Tue,  5 Oct 2021 07:37:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 799D34B2C5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:37:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yIjzaOydJMx0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 07:37:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A8294B2E4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:37:44 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49FBF6137D;
 Tue,  5 Oct 2021 11:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633433863;
 bh=kry0yCEkM1rOAPqgCZmnkCzktstFgLIzaFToUOzNxzw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bCUAxH+im0T4w4QUPnOC3P6r8YG9nK6SmIOp8N6/nBuXL9ZzwSkA5J/Yie1abJeRJ
 ZJecFSr+JJxcStJw0gGY+QaB3vNI6W/7xnNwgfof8rdVDEHe0OqmsUBzawqv68asNZ
 H+f+xGMfYwJDm1ja9q8p8ePUJI5nskB5cQjICEJbgaqF0ZtyFfv1bugEr6zZHIpRxA
 7wl1SAga+E6O7MNsoAIMZvkfADcu0ioOgxEQgpzx9cKxHJetoidp+SCqht2edYDtrE
 NOAVjB3K8lC/z5Ql4p+I+edu2r4OnhbKlKsRgO8Uhf+G31m2UCBzkzp1SQMqqyUv/U
 adhrHYpYQdilg==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 4/5] KVM: arm64: Prevent re-finalisation of pKVM for a
 given CPU
Date: Tue,  5 Oct 2021 12:37:20 +0100
Message-Id: <20211005113721.29441-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211005113721.29441-1-will@kernel.org>
References: <20211005113721.29441-1-will@kernel.org>
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
Reviewed-by: Quentin Perret <qperret@google.com>
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
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

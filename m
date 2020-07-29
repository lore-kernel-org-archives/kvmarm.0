Return-Path: <SRS0=ZPfy=BI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CF7C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jul 2020 10:28:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C8FC2076E
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jul 2020 10:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0r2wYQq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C8FC2076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8A74B560;
	Wed, 29 Jul 2020 06:28:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Gsa8kdMakBB; Wed, 29 Jul 2020 06:28:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B16974B54D;
	Wed, 29 Jul 2020 06:28:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DBC44B53C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jul 2020 06:28:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j7PyF11Osuer for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jul 2020 06:28:28 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8C6A4B547
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jul 2020 06:28:28 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 93E39207E8;
 Wed, 29 Jul 2020 10:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596018508;
 bh=VlBqSIQxv3wU73/BY96zYETvpUthPtLt2oVsiBE3XzU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=o0r2wYQqQUwMAL6c6mPbFMFHBJCLipf4Ltcdgp/dzgfWl8czCBgaz6ehVMBWCqS0g
 pCSVLcs5nFafPWLMQIwu7Gx5TnWNKzw233gys0y/mHAvHG/UQEBEnimxon4cxgPnU6
 +8M7TUGzF4YeDReMy80lRKCHJbGjatoJBSB5wSyQ=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 1/4] KVM: arm64: Rename kvm_vcpu_dabt_isextabt()
Date: Wed, 29 Jul 2020 11:28:18 +0100
Message-Id: <20200729102821.23392-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200729102821.23392-1-will@kernel.org>
References: <20200729102821.23392-1-will@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

kvm_vcpu_dabt_isextabt() is not specific to data aborts and, unlike
kvm_vcpu_dabt_issext(), has nothing to do with sign extension.

Rename it to 'kvm_vcpu_abt_issea()'.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 arch/arm64/kvm/hyp/switch.c          | 2 +-
 arch/arm64/kvm/mmu.c                 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4d0f8ea600ba..26eabf987e71 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -366,7 +366,7 @@ static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vc
 	return kvm_vcpu_get_hsr(vcpu) & ESR_ELx_FSC_TYPE;
 }
 
-static __always_inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
 {
 	switch (kvm_vcpu_trap_get_fault(vcpu)) {
 	case FSC_SEA:
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index db1c4487d95d..72459d955799 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -594,7 +594,7 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
 			kvm_vcpu_trap_get_fault_type(vcpu) == FSC_FAULT &&
 			kvm_vcpu_dabt_isvalid(vcpu) &&
-			!kvm_vcpu_dabt_isextabt(vcpu) &&
+			!kvm_vcpu_abt_issea(vcpu) &&
 			!kvm_vcpu_dabt_iss1tw(vcpu);
 
 		if (valid) {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index df2a8025ec8a..97394d56a5a9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2074,7 +2074,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
 	/* Synchronous External Abort? */
-	if (kvm_vcpu_dabt_isextabt(vcpu)) {
+	if (kvm_vcpu_abt_issea(vcpu)) {
 		/*
 		 * For RAS the host kernel may handle this abort.
 		 * There is no need to pass the error into the guest.
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

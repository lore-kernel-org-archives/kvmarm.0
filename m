Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD29C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:59:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1BCF9610E5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:59:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1BCF9610E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB65E4B15D;
	Fri,  8 Oct 2021 09:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dvp-5Daf2-+P; Fri,  8 Oct 2021 09:59:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA794B166;
	Fri,  8 Oct 2021 09:59:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 342814B0BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:58:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X1MHgGd81LAc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 09:58:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F1054B154
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:58:58 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1166C60FD8;
 Fri,  8 Oct 2021 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633701537;
 bh=d3wFH/yIetGiq5uriHxlgYqLTUnj/21bzxMY8KFLvuE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=gSvmFTxBs3Yv3TsWi3tqX1+3UZfMC5nAidDqLeOMgNhiZwKO3rcX0xDtnTVSqPls8
 1WKd7E2cNsrWEuJUcNOegtncGN3biwCWV9+kWuY+DF//z2s+v/+z4t1ZMsq5P5Coey
 SEG96mqW3SKMHFVwCLFTaWJ7OrBHJqMhfdwIhehq9bA9zvPrcHNM7YbuLTTS4SH9qv
 uW3OC9bISzBwlAwH5griMOPP3/kdXkWfKVHe8Xga07syTnDPDf9bgxMHUFnzHIDPlU
 HI1lJZ9b5xg3SDUVuU/nnIT1yCZGYK3XGDbZXXrEyaFTtKBI7T2FJbsxxSWjN4I2MC
 ZMDtaCgbISNZQ==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 4/6] KVM: arm64: Propagate errors from __pkvm_prot_finalize
 hypercall
Date: Fri,  8 Oct 2021 14:58:37 +0100
Message-Id: <20211008135839.1193-5-will@kernel.org>
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

If the __pkvm_prot_finalize hypercall returns an error, we WARN but fail
to propagate the failure code back to kvm_arch_init().

Pass a pointer to a zero-initialised return variable so that failure
to finalise the pKVM protections on a host CPU can be reported back to
KVM.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9506cf88fa0e..13bbf35896cd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1986,9 +1986,25 @@ static int init_hyp_mode(void)
 	return err;
 }
 
-static void _kvm_host_prot_finalize(void *discard)
+static void _kvm_host_prot_finalize(void *arg)
 {
-	WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize));
+	int *err = arg;
+
+	if (WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)))
+		WRITE_ONCE(*err, -EINVAL);
+}
+
+static int pkvm_drop_host_privileges(void)
+{
+	int ret = 0;
+
+	/*
+	 * Flip the static key upfront as that may no longer be possible
+	 * once the host stage 2 is installed.
+	 */
+	static_branch_enable(&kvm_protected_mode_initialized);
+	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
+	return ret;
 }
 
 static int finalize_hyp_mode(void)
@@ -2002,15 +2018,7 @@ static int finalize_hyp_mode(void)
 	 * None of other sections should ever be introspected.
 	 */
 	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
-
-	/*
-	 * Flip the static key upfront as that may no longer be possible
-	 * once the host stage 2 is installed.
-	 */
-	static_branch_enable(&kvm_protected_mode_initialized);
-	on_each_cpu(_kvm_host_prot_finalize, NULL, 1);
-
-	return 0;
+	return pkvm_drop_host_privileges();
 }
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

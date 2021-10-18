Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53BFC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 21:12:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 620146103D
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 21:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 620146103D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C974B1F3;
	Mon, 18 Oct 2021 17:12:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cjcMWpAg-11H; Mon, 18 Oct 2021 17:12:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C21D84B178;
	Mon, 18 Oct 2021 17:12:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4EF44B1AB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 17:12:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nq4S5LdWPM2t for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 17:12:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA77E4B16E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 17:12:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A119E60462;
 Mon, 18 Oct 2021 21:12:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mcZvV-0004Sc-PQ; Mon, 18 Oct 2021 22:12:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/5] KVM: arm64: Move SVE state mapping at HYP to
 finalize-time
Date: Mon, 18 Oct 2021 22:11:54 +0100
Message-Id: <20211018211158.3050779-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018211158.3050779-1-maz@kernel.org>
References: <20211018211158.3050779-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com,
 will@kernel.org, drjones@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

We currently map the SVE state to HYP on detection of a PID change.
Although this matches what we do for FPSIMD, this is pretty pointless
for SVE, as the buffer is per-vcpu and has nothing to do with the
thread that is being run.

Move the mapping of the SVE state to finalize-time, which is where
we allocate the state memory, and thus the most logical place to
do this.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 11 -----------
 arch/arm64/kvm/reset.c  | 11 ++++++++++-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 5621020b28de..62c0d78da7be 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -43,17 +43,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 	if (ret)
 		goto error;
 
-	if (vcpu->arch.sve_state) {
-		void *sve_end;
-
-		sve_end = vcpu->arch.sve_state + vcpu_sve_state_size(vcpu);
-
-		ret = create_hyp_mappings(vcpu->arch.sve_state, sve_end,
-					  PAGE_HYP);
-		if (ret)
-			goto error;
-	}
-
 	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
 error:
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5ce36b0a3343..9e904a9244c1 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -94,6 +94,8 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 {
 	void *buf;
 	unsigned int vl;
+	size_t reg_sz;
+	int ret;
 
 	vl = vcpu->arch.sve_max_vl;
 
@@ -106,10 +108,17 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 		    vl > SVE_VL_ARCH_MAX))
 		return -EIO;
 
-	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL);
+	reg_sz = vcpu_sve_state_size(vcpu);
+	buf = kzalloc(reg_sz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
+	ret = create_hyp_mappings(buf, buf + reg_sz, PAGE_HYP);
+	if (ret) {
+		kfree(buf);
+		return ret;
+	}
+	
 	vcpu->arch.sve_state = buf;
 	vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
 	return 0;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=EuCB=AS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D5AC433DF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 14:57:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BE2D2078A
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 14:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="YTEOwtMn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BE2D2078A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BEE4B113;
	Tue,  7 Jul 2020 10:57:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gm+LtVxTMliB; Tue,  7 Jul 2020 10:57:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B28534B107;
	Tue,  7 Jul 2020 10:57:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7A64B0F6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 10:57:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M0rIj3BAtWGp for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2020 10:57:23 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6D914B0F3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 10:57:23 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id d27so14138866ybe.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jul 2020 07:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=k0vhnD9DEIKy911IfnNc+JldmkHMm378MBRDrX5FzxU=;
 b=YTEOwtMnngWwxS8bNRLmKF8b6FC0JI4nALV2uUhvySLF9SYkSMM3aHWrshYPk2T0cG
 WjVaTK3i8Za7CafW4SH0ULLTOhbz4K1YSyth7scZwsSVA7aRARbNBsGwXKoxKBIxivM6
 lw4KZSpGNs8T6zNv7rs2PLzieP4091p0OQP0v5/+rHjqJ0Aa1dpS551cqP3PWKkj8xVC
 zGhsS705Ty1pZKXBBvM2gl6+r0DI9Qldf/zB/HpOdEqLwrO5EimEq7SrTuMgakevzwz+
 ISX1vqpljYDM//BpH5fy/CROEnD33oqNoklKLY9C8iYkxh6od/qBEq2tzAAVmDCRvZY/
 aodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=k0vhnD9DEIKy911IfnNc+JldmkHMm378MBRDrX5FzxU=;
 b=fhIMVU/j1osmZi0Li38LKPFxZB63yJ9PiBDt4+jV93xCUN5wxhTwW+f33LpeFGEa85
 RukZmagmUih0m1ADnKk16vRTVLmryB1BkEYpvOL/UQjUbgKD+g3k9bqlzXLJ6x9xWWQY
 ZkAQy10VEVlH2+Vr23ktJ3OC1bRxVKkLgWL9F86WOaTIBxZ18tflEgBLkW3jOEhNZU1Y
 KNt96rznACen8lPofMsth+4LFhHqcyWfbVRTmB2NPrSSM/1wFzTXFXwOTKuld4x2+anK
 nRbBOSbvgbDjt7bIIBFVjKiianDK1O2lBQL3AEdvUmN8NEWiwegz6DtA8TUilOiPp/+2
 XF+A==
X-Gm-Message-State: AOAM533o4dzlAVWpxD9DbKNTY5IVbMMPXa+AA6QvwIjIs9Efo34konrl
 ipQsEDdj6HFTowsPuLBpVetaHToPQXEo8gOcultXSi+bBpfitCW7KaBfW1bbU8HLjmu41wKPOAj
 j1Qvp5iS3VktYk7n/XTaJOkRJudXWgze3hrKefKEHWOyQC3Fm75xEdOFv3dAT0AVqxCsvcw==
X-Google-Smtp-Source: ABdhPJzNU4q917gY00TN2qCJ72KkogjtXs8QvfEcD3qbbRvbsf/Z6bLqjYUqyxRXX219nWt6vhPtpMabYbI=
X-Received: by 2002:a25:41d4:: with SMTP id
 o203mr26286845yba.378.1594133843058; 
 Tue, 07 Jul 2020 07:57:23 -0700 (PDT)
Date: Tue,  7 Jul 2020 15:57:13 +0100
Message-Id: <20200707145713.287710-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH] arm64: kvm: Remove redundant KVM_ARM64_FP_HOST flag
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com, dave.martin@arm.com
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

The FPSIMD registers can be in one of three states:
 (a) loaded with the user task's state
 (b) loaded with the vcpu's state
 (c) dirty with transient state

KVM_ARM64_FP_HOST identifies the case (a). When loading the vcpu state,
this is used to decide whether to save the current FPSIMD registers to
the user task.

However, at the point of loading the vcpu's FPSIMD state, it is known
that we are not in state (b). States (a) and (c) can be distinguished by
by checking the TIF_FOREIGN_FPSTATE bit, as was previously being done to
prepare the KVM_ARM64_FP_HOST flag but without the need for mirroring
the state.

Signed-off-by: Andrew Scull <ascull@google.com>
---
This is the result of trying to get my head around the FPSIMD handling.
If I've misunderstood something I'll be very happy to have it explained
to me :)
---
 arch/arm64/include/asm/kvm_host.h       | 11 +++++----
 arch/arm64/kvm/fpsimd.c                 |  1 -
 arch/arm64/kvm/hyp/include/hyp/switch.h | 30 +++++++++++++++++--------
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e0920df1d0c1..d3652745282d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -370,12 +370,11 @@ struct kvm_vcpu_arch {
 /* vcpu_arch flags field values: */
 #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
 #define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
-#define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
-#define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
-#define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
-#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
-#define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
-#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
+#define KVM_ARM64_HOST_SVE_IN_USE	(1 << 2) /* backup for host TIF_SVE */
+#define KVM_ARM64_HOST_SVE_ENABLED	(1 << 3) /* SVE enabled for EL0 */
+#define KVM_ARM64_GUEST_HAS_SVE		(1 << 4) /* SVE exposed to guest */
+#define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 5) /* SVE config completed */
+#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 6) /* PTRAUTH exposed to guest */
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() && \
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index e329a36b2bee..4e9afeb31989 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -65,7 +65,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
 			      KVM_ARM64_HOST_SVE_IN_USE |
 			      KVM_ARM64_HOST_SVE_ENABLED);
-	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
 
 	if (test_thread_flag(TIF_SVE))
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 8f622688fa64..beadf17f12a6 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -33,16 +33,24 @@ extern const char __hyp_panic_string[];
 static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * When the system doesn't support FP/SIMD, we cannot rely on
-	 * the _TIF_FOREIGN_FPSTATE flag. However, we always inject an
-	 * abort on the very first access to FP and thus we should never
-	 * see KVM_ARM64_FP_ENABLED. For added safety, make sure we always
+	 * When entering the vcpu during a KVM_VCPU_RUN call before the vcpu
+	 * has used FPSIMD, FPSIMD is disabled for the vcpu and will trap when
+	 * it is first used. The FPSIMD state currently bound to the cpu is
+	 * that of the user task.
+	 *
+	 * After the vcpu has used FPSIMD, on subsequent entries into the vcpu
+	 * for the same KVM_VCPU_RUN call, the vcpu's FPSIMD state is bound to
+	 * the cpu. Therefore, if _TIF_FOREIGN_FPSTATE is set, we know the
+	 * FPSIMD registers no longer contain the vcpu's state. In this case we
+	 * must, once again, disable FPSIMD.
+	 *
+	 * When the system doesn't support FPSIMD, we cannot rely on the
+	 * _TIF_FOREIGN_FPSTATE flag. For added safety, make sure we always
 	 * trap the accesses.
 	 */
 	if (!system_supports_fpsimd() ||
 	    vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
-		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
-				      KVM_ARM64_FP_HOST);
+		vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
 
 	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
 }
@@ -245,7 +253,13 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
 	isb();
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
+	/*
+	 * The trap means that the vcpu's FPSIMD state is not loaded. If
+	 * _TIF_FOREIGN_FPSTATE is set, the current state does not need to be
+	 * saved. Otherwise, the user task's state is currently loaded and
+	 * needs to be saved.
+	 */
+	if (!(vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)) {
 		/*
 		 * In the SVE case, VHE is assumed: it is enforced by
 		 * Kconfig and kvm_arch_init().
@@ -260,8 +274,6 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		} else {
 			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 		}
-
-		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
 	}
 
 	if (sve_guest) {
-- 
2.27.0.383.g050319c2ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

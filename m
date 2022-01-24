Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9A0C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jan 2022 15:58:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E972411C7;
	Mon, 24 Jan 2022 10:58:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kfGJPvcYGC-C; Mon, 24 Jan 2022 10:58:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 033E849AF9;
	Mon, 24 Jan 2022 10:58:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94C1440D2E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 10:58:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nJXSfxGmpEBO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 10:58:51 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C959041016
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 10:58:50 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 337C5614CC;
 Mon, 24 Jan 2022 15:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DABFC340ED;
 Mon, 24 Jan 2022 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643039930;
 bh=GV5HkATNNnX0yRUyvsNMHzAMxckxNiAa2tFvk2NEu48=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=dXUSXiWSbYGhhUFIpD2xuNZAo2mfuIgiUI+YP2JWavp76/XCdxQ42n0eAlyOn/ukd
 ayFt7YSjcc4u5QfJFYPXq8z5VYj++ZCihhqX3JVyTLRu0FYZ+Si3hi6bCS7+MYYI8H
 cVm1L3bN5ZdSizlFjr3NHsgYjGLffHyr0miTdRlefStvvFaxzeTI0lHfqC89GwQ1Hm
 pvUC9H92GT/oRHdJwsOFC+xQ5QtXlc84mM+R5UeeptabBV3XciiGr1ePBstubgTNUK
 wWNoX2Rh5UQEMjTUJ0mD6zkvwVnOWPPTUlwEq0blUP/v4QB/Dc8aMTQuUHAhZKarZN
 dbctPTnXl6Lhw==
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH v1 2/2] KVM: arm64: Add some more comments in
 kvm_hyp_handle_fpsimd()
Date: Mon, 24 Jan 2022 15:57:20 +0000
Message-Id: <20220124155720.3943374-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220124155720.3943374-1-broonie@kernel.org>
References: <20220124155720.3943374-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1281; h=from:subject;
 bh=GV5HkATNNnX0yRUyvsNMHzAMxckxNiAa2tFvk2NEu48=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh7sxfoAukxR/ZotsyUayM9vV8IENwnOaFVj2yZB66
 sAHbhFqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe7MXwAKCRAk1otyXVSH0CISB/
 9jEXJmIRURSEw+uGbSqsIdjSJNWVX2i9YN55ozJGJ1MYihVSiLNUC0K7rhy2kP7/AFBeVVgRmfiT8Q
 S8g/+8L7E1TDl9Qvfe+hN7TormYa9wJD+aWgtrFMKlgWvHboL+C3a9Kk9cF+WqesOCuOoPC6sO//qf
 +8cVOb5GYh0zBWZSEEYls478/l2XeAWgxBTJD0600/8njNMrP9NtCtu8eFxAVQqewX2psIGNz4fG0f
 zt1h94rzqNbo8R/5KLok7jMpJ0Jgw7sexi1G0sXhcpUIj43fINRR8+dpa+gEBcNoEvs4TKS/Tjtx2b
 1B9/t6AAFQvI9WZtCGQvvFfbp7fi5a
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

The handling for FPSIMD/SVE traps is multi stage and involves some trap
manipulation which isn't quite so immediately obvious as might be desired
so add a few more comments.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 58e14f8ead23..1995808d8766 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -173,6 +173,8 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		return false;
 
 	/* Valid trap.  Switch the context: */
+
+	/* First disable enough traps to allow us to update the registers */
 	if (has_vhe()) {
 		reg = CPACR_EL1_FPEN;
 		if (sve_guest)
@@ -188,11 +190,13 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	}
 	isb();
 
+	/* Write out the host state if it's in the registers */
 	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
 		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
 	}
 
+	/* Restore the guest state */
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);
 	else
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

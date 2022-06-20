Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85BCC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 12:42:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EE6C4B403;
	Mon, 20 Jun 2022 08:42:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oCCwW7e4GH7T; Mon, 20 Jun 2022 08:42:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D977A4B2B4;
	Mon, 20 Jun 2022 08:42:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 321FF4B29D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iYOjMdVbBLa7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 08:42:19 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 687634B379
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:18 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 79A1EB81145;
 Mon, 20 Jun 2022 12:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239CDC3411B;
 Mon, 20 Jun 2022 12:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655728936;
 bh=z0GcdC5i/4KCZ2+LjSmSv8IHIAdSSppadOP4Yk/b27s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=uuYSwLW+vbLIAnS8K+Ts0Q8w0EF72EPfpu8a13yF92TV50Kj3TIeJod1T7ArEbAvL
 wSKwEpl4cZpJT0sGsr6e9YNOnXBGZhr+Y1E+Rm7BvbNkTVomKNsB5VlNyd0UzPAN+P
 f1h3s2n0Trc6/uYOPtBIPx8MJEEgGcPD7nwEkk+JkH4jQnTsLsU5jzCg/zMD4ari5U
 7JjVQj/dJawXbOLO6B3PfBTLwMrUhIVz9MNqH5pVopE0rX2Gw45no5CxrkEkIaUFLm
 sSRZgGnw86r349MVCjSV8TNDePtgvgT7/alUhctaxa/bYZLvpg3/HgEUvi6aUutv8p
 QlWR2P6aU2bnw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 1/7] KVM: arm64: Discard any SVE state when entering KVM
 guests
Date: Mon, 20 Jun 2022 13:41:52 +0100
Message-Id: <20220620124158.482039-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620124158.482039-1-broonie@kernel.org>
References: <20220620124158.482039-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2967; h=from:subject;
 bh=z0GcdC5i/4KCZ2+LjSmSv8IHIAdSSppadOP4Yk/b27s=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhqQN2XwuXsvrRI7zZ3D+F/Qrzgh5WufSElZquvOX/c2vZVFG
 IUadjMYsDIxcDLJiiixrn2WsSg+X2Dr/0fxXMINYmUCmMHBxCsBEbLax/5WaFS+YKv9KWj2saZq3WF
 LvnqaL3AvyWLmfdvs/WMBjL7gh6HxE5AeuzTMr5xd817NKeF63MOyeyo7lHjIl148GlG/NV3pcx3X0
 uQ/DhJhTdil3pxt1qvl9lvHwiEy8aq566sPjC+IdvruTf616KBZwpOfPAi/19KfM5lX+7Dm3Z8S67z
 wbbHMmn+XYGQ+9a0HsZ7Z2Mf5W2MLww4rzmL2yeHdJ0vGLU55sLfP9UM46U9rD6lbAd8/Hla1LxZPi
 mYWFq7J833Xr67hcuKkj0qB9xPfuwnuzBMLavjQmt7HMkHFdbnWBgzFyz3rL9YVLM1T0knefLuRlmn
 UzUPeBeW3k593n/lxY83PPHZlXAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Marc Zyngier <maz@kernel.org>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Mark Brown <broonie@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Since 8383741ab2e773a99 (KVM: arm64: Get rid of host SVE tracking/saving)
KVM has not tracked the host SVE state, relying on the fact that we
currently disable SVE whenever we perform a syscall. This may not be true
in future since performance optimisation may result in us keeping SVE
enabled in order to avoid needing to take access traps to reenable it.
Handle this by clearing TIF_SVE and converting the stored task state to
FPSIMD format when preparing to run the guest.  This is done with a new
call fpsimd_kvm_prepare() to keep the direct state manipulation
functions internal to fpsimd.c.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  1 +
 arch/arm64/kernel/fpsimd.c      | 23 +++++++++++++++++++++++
 arch/arm64/kvm/fpsimd.c         |  3 ++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 9bb1873f5295..847fd119cdb8 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -56,6 +56,7 @@ extern void fpsimd_signal_preserve_current_state(void);
 extern void fpsimd_preserve_current_state(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
+extern void fpsimd_kvm_prepare(void);
 
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index aecf3071efdd..d67e658f1e24 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1637,6 +1637,29 @@ void fpsimd_signal_preserve_current_state(void)
 		sve_to_fpsimd(current);
 }
 
+/*
+ * Called by KVM when entering the guest.
+ */
+void fpsimd_kvm_prepare(void)
+{
+	if (!system_supports_sve())
+		return;
+
+	/*
+	 * KVM does not save host SVE state since we can only enter
+	 * the guest from a syscall so the ABI means that only the
+	 * non-saved SVE state needs to be saved.  If we have left
+	 * SVE enabled for performance reasons then update the task
+	 * state to be FPSIMD only.
+	 */
+	get_cpu_fpsimd_context();
+
+	if (test_and_clear_thread_flag(TIF_SVE))
+		sve_to_fpsimd(current);
+
+	put_cpu_fpsimd_context();
+}
+
 /*
  * Associate current's FPSIMD context with this cpu
  * The caller must have ownership of the cpu FPSIMD context before calling
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 6012b08ecb14..a433ee8da232 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -75,7 +75,8 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(!current->mm);
-	BUG_ON(test_thread_flag(TIF_SVE));
+
+	fpsimd_kvm_prepare();
 
 	vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
 	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

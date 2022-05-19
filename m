Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B612C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:45:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6C344B3D4;
	Thu, 19 May 2022 09:45:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3cBQE19T5QFQ; Thu, 19 May 2022 09:45:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B405A4B406;
	Thu, 19 May 2022 09:45:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 999A74B3D4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 75fjPWU7yB+d for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:45:27 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E635F4B38D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:26 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 8FE31CE2466;
 Thu, 19 May 2022 13:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F885C385B8;
 Thu, 19 May 2022 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967919;
 bh=Wd/HwkBqurC96ZGUbUiPBa09e91aiokQncSXqY2+W8A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nv0J7+q5DNpWtUyZflP18IUXGvVQz6kZ23wtPsn4EH1Zp0na7ewTMNMI/jESdl0jY
 kaJLuZ1/UmO0i5rCxQu/II3wMQGm61PlpJcwlM7M9VjvLRAf9XmuSQk8gq4hhA76+J
 UarGWnqVZ/uJ7PdpUbLO79QDVN75VZvQQ9TwBLMScAoQubJB0T2RMPkx/bCRmstMj7
 IpPPr4YKqDMtLP3VwKpDFVbw1li75USzU3RJF8LIVfPo7DF+HKRPfs1tAvmFOPzf16
 UUwgt3GfGVj23i2SUEuLWseCK13FrmD9oGSIbbE9JH3pbejdapr/o0Fa6b7+m1T2bD
 lmy3TBRccp+0w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 44/89] KVM: arm64: Introduce predicates to check for protected
 state
Date: Thu, 19 May 2022 14:41:19 +0100
Message-Id: <20220519134204.5379-45-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Marc Zyngier <maz@kernel.org>

In order to determine whether or not a VM or (shadow) vCPU are protected,
introduce a helper function to query this state. For now, these will
always return 'false' as the underlying field is never configured.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h      |  6 ++----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h | 13 +++++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c55aadfdfd63..066eb7234bdd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -164,6 +164,7 @@ struct kvm_pinned_page {
 };
 
 struct kvm_protected_vm {
+	bool enabled;
 	unsigned int shadow_handle;
 	struct mutex shadow_lock;
 	struct kvm_hyp_memcache teardown_mc;
@@ -895,10 +896,7 @@ int kvm_set_ipa_limit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
-static inline bool kvm_vm_is_protected(struct kvm *kvm)
-{
-	return false;
-}
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.pkvm.enabled)
 
 void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index f76af6e0177a..3997eb3dff55 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -58,6 +58,19 @@ static inline struct kvm_shadow_vm *get_shadow_vm(struct kvm_vcpu *shadow_vcpu)
 	return get_shadow_state(shadow_vcpu)->shadow_vm;
 }
 
+static inline bool shadow_state_is_protected(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	return shadow_state->shadow_vm->kvm.arch.pkvm.enabled;
+}
+
+static inline bool vcpu_is_protected(struct kvm_vcpu *vcpu)
+{
+	if (!is_protected_kvm_enabled())
+		return false;
+
+	return shadow_state_is_protected(get_shadow_state(vcpu));
+}
+
 void hyp_shadow_table_init(void *tbl);
 int __pkvm_init_shadow(struct kvm *kvm, unsigned long shadow_hva,
 		       size_t shadow_size, unsigned long pgd_hva);
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

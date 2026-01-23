Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F6A1F91E3
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195803; cv=none; b=JTnKtjHl5kqloQRZjUAOGk6jC1GIT+iqICwRv9XBVSkGLVLJ9lDm1K8knTQqIyEk2kZPdQEU4KTIv4iywUnKU27MJwRhplyBCJ/5D0XfoTUVBf3BLMUsmTcaaUrpNPB9wv+6CC704nPW4u44lKnENpK+RxVu/cXfdlFMdqdhgdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195803; c=relaxed/simple;
	bh=n8p4GrhZYc/onaCNYcYnYrmgdPoNoakZKm18N6u1jVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0LxDEZ0kou3fD0bZgw6yfmfshbDyyxW+3hXJSwE+SzKLzOK3pgm+NDjVP5ql/elwj02H4MobMZU/EIiSeHziktyTC2KREPbzUZU3DU8NSyiiUHm5xeOncn+2APuCEwteUttA9fIHXrm+F48IRNbgKiMMHXAdfjegpKA/IME30Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dae/CMo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dae/CMo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3C9C19425;
	Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769195803;
	bh=n8p4GrhZYc/onaCNYcYnYrmgdPoNoakZKm18N6u1jVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dae/CMo9WVTAbR9xlmhMMsDeB10WJNVdTqCsN7nkMEPXqI2os8k60js0t7tQU13Oy
	 ckO/zn2h5kHz57V5IiUhBGAtT2BbUyJtKP8D1z/b1QEuTEYQ8Z3k8BTaPxggn5rp3w
	 vrh8TgIAOP4Yec5Gjpr/r5vO6FCJzZ1ylAk9PZDH85LqiVDJuW1ky7hDt6jqXgoInM
	 a15RZrn/FT4Su510kmJxqf3RlK7jPPbAi5Rt7/Gr+mbCRuYUrrQVgxZzy5F4GQEczq
	 /ZyoLcgoZU0OIDuSdIjTf40PSyvzkrYcuIwSjh/Kx/K/NgdMKjyKhvZKLpF0/GAcS1
	 n3BoEsxJ0tIrg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vjMe9-00000005A2V-16kd;
	Fri, 23 Jan 2026 19:16:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 3/5] KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
Date: Fri, 23 Jan 2026 19:16:35 +0000
Message-ID: <20260123191637.715429-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123191637.715429-1-maz@kernel.org>
References: <20260123191637.715429-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since we have the basics to use the S1 memory attributes as the
final ones with FWB, flip the host over to that when FWB is present.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 49db32f3ddf71..38f66a56a7665 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -19,7 +19,7 @@
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 
-#define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_NOFWB | KVM_PGTABLE_S2_IDMAP)
+#define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_AS_S1 | KVM_PGTABLE_S2_IDMAP)
 
 struct host_mmu host_mmu;
 
@@ -324,6 +324,8 @@ int __pkvm_prot_finalize(void)
 	params->vttbr = kvm_get_vttbr(mmu);
 	params->vtcr = mmu->vtcr;
 	params->hcr_el2 |= HCR_VM;
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		params->hcr_el2 |= HCR_FWB;
 
 	/*
 	 * The CMO below not only cleans the updated params to the
-- 
2.47.3


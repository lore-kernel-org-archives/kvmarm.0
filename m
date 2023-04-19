Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6175D15A8
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 02:19:07 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id f66-20020a255145000000b00b7f75c3cafdso12592451ybb.16
        for <kvmarm@lists.linux.dev>; Tue, 18 Apr 2023 19:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681870746; x=1684462746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z7zzcGDZPbSte4f8fT9vbCw5LuF4xstdxjEG9JI5LdU=;
        b=1BpmpgNYdsRKvRk6qrTEJbdcclnYFCXUZ1sKONbsw5Ac+UIEhNn+Cnjg4xjnCGB5JQ
         Shim51D/sV8i+svuoxMw06bFf0Ucel+aJs/jZJJQ1BNVWu7V4xKCnMR7ZBqzsal8nEcV
         kZiYnCBxW/ZfmJF0FbIPl2er+nfPek/CxhnGqU0yeGxTQkO0OY60TJ9f3whZk7pwzDPA
         rVKqlgZTUyLiVhks/K6jyM9QOfSJkfori6PQ0DzF2ye/sOHYLOlYUmsp0B2Nv5eywmkS
         EwDe+BL0VSwDvG3ugu5GwSLOR0/NsBzFakFVtuLsKy/yuAWsB+PVHPnR285JBPVa1X9+
         hNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681870746; x=1684462746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z7zzcGDZPbSte4f8fT9vbCw5LuF4xstdxjEG9JI5LdU=;
        b=dm3Tt/FhaLJvLlA2b7PKO+RPijp2SPeVArT7kTbkDH62H/VZzwPYrKnQhGwlVhuYFL
         GRhdLYaNSBgZBFi21HhqW7KqKgiIyQETDTcAEFCN1qK78HG+iZGTeKi2cxGOGrSUQyC0
         9ukZgTIPrbBoJj+vLG3brCq1CJSsfOCkK14xvRdP6epaEzhQoyKMcfWRgGNm9/QBVXkh
         Lv+oW/fSEE7w4W6QpvULObXVPiDnPOpXg46eJ0E9+68DshWTIC5a7YLZYVDXntKt6IV0
         xk7zRHETW795lLX/027Mzo35/KFEg4HTG13z9+B7T7hCNeVPXuUlYpFGOF+EyWaCcCWN
         pMlA==
X-Gm-Message-State: AAQBX9fOjT/QjJx8dDKLcPnR0iJVUq5SMg4CG3DSdpyLJk8HJ1U21f2L
	44r958i13sv/H98wLFHGAZ0fxfbFR0U=
X-Google-Smtp-Source: AKy350Z/I1GCXlm8WzCDIqkLOeoag4XllnSKJRp0ZAYYdDCimf2ANR08QBaZ+Z2bMGMmbTBDeu0l1oEfJ0E=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:d814:0:b0:b96:7676:db47 with SMTP id
 p20-20020a25d814000000b00b967676db47mr433801ybg.13.1681870746505; Tue, 18 Apr
 2023 19:19:06 -0700 (PDT)
Date: Tue, 18 Apr 2023 19:18:51 -0700
In-Reply-To: <20230419021852.2981107-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230419021852.2981107-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.396.gfff15efe05-goog
Message-ID: <20230419021852.2981107-2-reijiw@google.com>
Subject: [PATCH v1 1/2] KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

kvm_arch_vcpu_ioctl_vcpu_init() doesn't acquire mp_state_lock
when setting the mp_state to KVM_MP_STATE_RUNNABLE. Fix the
code to acquire the lock.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/arm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fbafcbbcc463..388aa4f18f21 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1244,8 +1244,11 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 */
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
 		kvm_arm_vcpu_power_off(vcpu);
-	else
+	else {
+		spin_lock(&vcpu->arch.mp_state_lock);
 		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
+		spin_unlock(&vcpu->arch.mp_state_lock);
+	}
 
 	return 0;
 }
-- 
2.40.0.396.gfff15efe05-goog


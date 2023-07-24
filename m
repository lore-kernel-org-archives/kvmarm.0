Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF686AA2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:38:51 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5704995f964so55953537b3.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690202330; x=1690807130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vk8BXjadAVeu46mny/H5WkIFzEB+1LH2gEPENBnvLP8=;
        b=n3mJNiJXFG7JMQ5JHJHkvidUF8MVKsMc35QZ7hyiirIHrgf7hSo4ZH7AWqRdZhDhrl
         hiUaLkBRlrZrRnwZWCQ0beTiSejB56e816p3pDRjaxJ0cGIgmuhYs6gWwby5JLg7qHQy
         6vBKRqgGSShuR+gAjQ+MQkIMOTQm5oAtpn1y7DO9z+K5WwCtolhA9g0nW/21nbdSrabW
         1sE74K31Vj/CJ97FUymSXOSXIZJOgOdPE7ThNBqtJBXXl5SYZX2Hu+vGzDHtCNF3QwmB
         aqf/kylOg8KhrOi6tcbwxWqAqIZNKQrUsqZlmHQue3Os9nmKbue3RCPT4hq7ox4+9L5s
         YFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202330; x=1690807130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vk8BXjadAVeu46mny/H5WkIFzEB+1LH2gEPENBnvLP8=;
        b=XtKPxEv7jdq19dyoGck6rX/7y9EtK1x7Z2Z2ZtV2CEBCMP8vJg3d8LtyE7/JpWuiRg
         cN2U0H1qtZvHNP28dnqR4Lcr3DLAIjRzBSSepC1eeTyXFjev/dWSK02dKiwvLqqthc/z
         3KFstM4e8XdjpBuxfNnB/aro0o+vFwfNu1YKdqz2/YPBCbyONSkEhboP7UgHMG/KZB93
         pW8NrGajcJcTg41wTYonVqDqsyZhkDd+Pnbthe5YdZvBgEcSCVfuThPoszSzWoS6GCsw
         cEsmErIgePTXFgROqw6mevga4Tqkvm3zeLyyFqgYh4645WmtTOyFK1+tTN9JNxUN8Rfb
         ZccA==
X-Gm-Message-State: ABy/qLZaPshqCY2HPDLwyJ/YdXcG6zji4eEpwj+i/pRxeDWi/diTSW2a
	Pm7sRjdfPt3VkasdRNXd5UiZO5gSq6oLJtAaTM7z2RJ9kycGo3qMzZ86075hUSYbJQOeYo+vSyG
	QlbDqPhP1LnL/pt1G1gpWUnoYlwT6kFKrqK9Y9J2PX0V5wzz5xVzHp/AeM8A=
X-Google-Smtp-Source: APBJJlGeiasp5GMr45a3MRZz7jXwXXlCsqUGtRZSzVMsJcJ+bGPE5Hhjexi1J1nyAX0uXHNKWN9ZsPbwMg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:b71d:0:b0:576:f61f:adbc with SMTP id
 v29-20020a81b71d000000b00576f61fadbcmr69513ywh.1.1690202330580; Mon, 24 Jul
 2023 05:38:50 -0700 (PDT)
Date: Mon, 24 Jul 2023 13:38:29 +0100
In-Reply-To: <20230724123829.2929609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230724123829.2929609-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724123829.2929609-9-tabba@google.com>
Subject: [PATCH v3 7/7] KVM: arm64: Fix resetting SME trap values on reset for (h)VHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Ensure that SME traps are disabled for (h)VHE when getting the
reset value for the architectural feature control register.

Fixes: 75c76ab5a641 ("KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index adfb7d0ac55b..3d6725ff0bf6 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -586,12 +586,16 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 	if (has_vhe()) {
 		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
 		       CPACR_EL1_ZEN_EL1EN);
+		if (cpus_have_final_cap(ARM64_SME))
+			val |= CPACR_EL1_SMEN_EL1EN;
 	} else if (has_hvhe()) {
 		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
 
 		if (!vcpu_has_sve(vcpu) ||
 		    (vcpu->arch.fp_state != FP_STATE_GUEST_OWNED))
 			val |= CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN;
+		if (cpus_have_final_cap(ARM64_SME))
+			val |= CPACR_EL1_SMEN_EL1EN | CPACR_EL1_SMEN_EL0EN;
 	} else {
 		val = CPTR_NVHE_EL2_RES1;
 
-- 
2.41.0.487.g6d72f3e995-goog


Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682FF22EF1
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 21:57:29 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-c64ef5bde93so104327276.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 14:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689803848; x=1690408648;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d3Ht7L7dsVm5KYjvx2fbdO1jyBq4m055oYZLq1pDnXs=;
        b=Ra8+xJNP/sYgyLpaDBs1F288TIvL1tnzWLHFmnzM7/dQqrNn5YcbKDgTbFtPDZD/ha
         K8MFOKEa+OQyC87XpoOeppzZtaRCkoHPRaR+wC1YoKWuo1BAl875kJyfty5HOfA/hD9+
         DfLJhptuW65V2HY78jzcImh3piPxWnQw9n9gcwz97bbRazS7jcez6cAmtuqzFBjG12+w
         mtv2cEj7lNF4fu2yhTlpdewK1595/OJ//S3L+ici78yhdckGjZky1+pC4CyEGkAidHWm
         IBziZwUK+XXVoHgvync2hHaby+uusAd+25S0ybYENq7qI1Wh9pAbi7wcu7J7bvZIarxv
         g/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689803848; x=1690408648;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d3Ht7L7dsVm5KYjvx2fbdO1jyBq4m055oYZLq1pDnXs=;
        b=llFr5+FAP9amE2bQef2Ec+voueqVRUg2oiXOPtXSiKeDrFN3pVXhw4chqWLU2Rdq6L
         7FurhfUQD/CCgb5yfamIK7DLzafY4MLM5jntQaLGfJO0NYvtXkJtP/S9jjyD2eN/PA3p
         ZJFUs0Ujg+aAS4lrT4Xq7gYips4Pfku+IjMS0ijybk4UZk1bDIpjk6p7/mQklOvMEZcn
         BjY3YfFsq42LWzG1Z8vJbRzZsSro94s1qc886JAahj7yd4c8ps0mYmfvXqGefZJa2zCq
         j4p0DegYjk/T7q9h4R1ufu8kbxR1w/MZyVaDIm24FlQVdkZl0hr08z4zUGPDF/rl3wb3
         V2xw==
X-Gm-Message-State: ABy/qLYdTJ2PWkU6Kl07SJz2ocyU7IV7caxjFF8jTEiAh9M+SmiFR8dJ
	/bRpGb8adp22fmbzPfMS2viABWP2EHNX
X-Google-Smtp-Source: APBJJlFhBf7IMPO6XHr8iP300gZpPf9iE5qcascfXqirJteE6s/G8oXQ/YGVmqERwG2BAFqqgzagvO/iZ6Qg
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5b:352:0:b0:cc7:b850:7f2 with SMTP id
 q18-20020a5b0352000000b00cc7b85007f2mr30000ybp.5.1689803848368; Wed, 19 Jul
 2023 14:57:28 -0700 (PDT)
Date: Wed, 19 Jul 2023 21:57:25 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230719215725.799162-1-rananta@google.com>
Subject: [PATCH v2] KVM: arm64: Fix hardware enable/disable flows for pKVM
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When running in protected mode, the hyp stub is disabled after pKVM is
initialized, meaning the host cannot enable/disable the hyp at
runtime. As such, kvm_arm_hardware_enabled is always 1 after
initialization, and kvm_arch_hardware_enable() never enables the vgic
maintenance irq or timer irqs.

Unconditionally enable/disable the vgic + timer irqs in the respective
calls, instead relying on the percpu bookkeeping in the generic code
to keep track of which cpus have the interrupts unmasked.

Fixes: 466d27e48d7c ("KVM: arm64: Simplify the CPUHP logic")
Reported-by: Oliver Upton <oliver.upton@linux.dev>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c2c14059f6a8..010ebfa69650 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1867,14 +1867,10 @@ static void _kvm_arch_hardware_enable(void *discard)
 
 int kvm_arch_hardware_enable(void)
 {
-	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
-
 	_kvm_arch_hardware_enable(NULL);
 
-	if (!was_enabled) {
-		kvm_vgic_cpu_up();
-		kvm_timer_cpu_up();
-	}
+	kvm_vgic_cpu_up();
+	kvm_timer_cpu_up();
 
 	return 0;
 }
@@ -1889,10 +1885,8 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
-	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
-		kvm_timer_cpu_down();
-		kvm_vgic_cpu_down();
-	}
+	kvm_timer_cpu_down();
+	kvm_vgic_cpu_down();
 
 	if (!is_protected_kvm_enabled())
 		_kvm_arch_hardware_disable(NULL);
-- 
2.41.0.487.g6d72f3e995-goog


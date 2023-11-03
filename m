Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987A822F09
	for <kvmarm@lists.linux.dev>; Fri,  3 Nov 2023 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YyUNyENJ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9a5a3f2d4fso2807706276.3
        for <kvmarm@lists.linux.dev>; Fri, 03 Nov 2023 12:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699039769; x=1699644569; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ej9TKa7ZSJIOAJS1B/2lr9o03XnT9TFq89fTO+C5Ds=;
        b=YyUNyENJlUFnR24LYni+ThQnEfdvw8ZLOsog6enqMKcWQ4pc1VZ1lUD5mEHGSzVgFr
         e5HMu6b85JZWnvO9oI9ZekA1Vpg9r5ZVI0AayWDgYv2Q5oecL+KtRI/GXpp5U+oI/175
         XH1NJR2ZfYVQhQSko9zgngeQQC5w4yBWfrIS5BNIJ/3thAwrrcLbnQyTBaOLy5SSWnYA
         XQmqiGlTXLit1tOlVOK9Bg23rZp+H/Jg8eSyeA79xRzRhmIE8NDJjr+zP/boMGrMr87q
         BhgyJzKUlx0yulDxSbYBQf5zeb+o02qP8U8rmgzASqc51YPd2HukJy0OenBLMGdASA36
         hhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699039769; x=1699644569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ej9TKa7ZSJIOAJS1B/2lr9o03XnT9TFq89fTO+C5Ds=;
        b=vzwrYGPk6yExEGUH+flKyukG8KnbH2ZlTzXGZ1IaLRs8kc2UeZC8Hcre3iZtrLrJez
         2XBTAOMaK5xrmw+Uz70W0tm6b7nzbN4WldMUtEVRVSB3IwnNBVwjElWvcW9wSBjoWKE+
         3IcD5VZfR+xA7yt764OApmxUfUvKVAmzMhwzFDHVx6YpR2OZwRXNAsfpr0NQVHTQq2vf
         Cnoshi03cQttjkpB/ScFMTTJuZKrB6Z+RdMF/H/Lxj4Ojwb5dM86ofEG5RCyC/P6G1+q
         m4vP48xyCsABY4yUYPgY4ZQq25Z4V6u5h58W94pZzb7tn+M7qL1ao2n5EkG1fst7okb6
         OVrw==
X-Gm-Message-State: AOJu0YxDAgCvoXSeyskFr2s1qWv6fduklLJmPgTowC1zg1FjdUFHwXBH
	V+ahsROUvZq16IC4GYXXd1wr0cJAF3elxyPDtw==
X-Google-Smtp-Source: AGHT+IFHprlg+8CuBn3dAnKWLLisYwZoGaeLvdHj+lnYB5xuNReCG2ZD3zHPD6Ahxm/WYC4ajyf4OuQZtVCmY8RAOA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:2688:0:b0:da0:29ba:668c with SMTP
 id m130-20020a252688000000b00da029ba668cmr412352ybm.10.1699039769635; Fri, 03
 Nov 2023 12:29:29 -0700 (PDT)
Date: Fri,  3 Nov 2023 19:29:14 +0000
In-Reply-To: <20231103192915.2209393-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231103192915.2209393-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103192915.2209393-3-coltonlewis@google.com>
Subject: [PATCH v3 2/3] KVM: arm64: selftests: Guarantee interrupts are handled
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Break up the asm instructions poking daifclr and daifset to handle
interrupts. R_RBZYL specifies pending interrupts will be handle after
context synchronization events such as an ISB.

Introduce a function wrapper for the WFI instruction.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c    | 12 ++++++------
 tools/testing/selftests/kvm/include/aarch64/gic.h |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/gic.c     |  5 +++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index d3bf584d2cc1..85f182704d79 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -269,13 +269,13 @@ static void guest_inject(struct test_args *args,
 	KVM_INJECT_MULTI(cmd, first_intid, num);

 	while (irq_handled < num) {
-		asm volatile("wfi\n"
-			     "msr daifclr, #2\n"
-			     /* handle IRQ */
-			     "msr daifset, #2\n"
-			     : : : "memory");
+		gic_wfi();
+		local_irq_enable();
+		isb();
+		/* handle IRQ */
+		local_irq_disable();
 	}
-	asm volatile("msr daifclr, #2" : : : "memory");
+	local_irq_enable();

 	GUEST_ASSERT_EQ(irq_handled, num);
 	for (i = first_intid; i < num + first_intid; i++)
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index 9043eaef1076..f474714e4cb2 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -47,4 +47,7 @@ void gic_irq_clear_pending(unsigned int intid);
 bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);

+/* Execute a Wait For Interrupt instruction. */
+void gic_wfi(void);
+
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
index 9d15598d4e34..392e3f581ae0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
@@ -164,3 +164,8 @@ void gic_irq_set_config(unsigned int intid, bool is_edge)
 	GUEST_ASSERT(gic_common_ops);
 	gic_common_ops->gic_irq_set_config(intid, is_edge);
 }
+
+void gic_wfi(void)
+{
+	asm volatile("wfi");
+}
--
2.42.0.869.gea05f2083d-goog

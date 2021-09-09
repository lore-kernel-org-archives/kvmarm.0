Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA7EC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E7B261167
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1E7B261167
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8E5E4B131;
	Wed,  8 Sep 2021 21:38:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OPNqLlbQHW+J; Wed,  8 Sep 2021 21:38:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3BD4B10E;
	Wed,  8 Sep 2021 21:38:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2A4C4B091
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IVVboV-s4uUn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:38:38 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAF954B0E2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:34 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 v66-20020a25abc8000000b0059ef57c3386so440269ybi.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zNHqAFnuHiggwZ7jn9N18KxilmXmaHVrWak3lSk+d74=;
 b=rKFntGWT7Zlr1j69UYRUvBr32BT0o9bmx5mTs/dXAaJ7tGkNGtdvXB7ckiyofZChKV
 7n52lUMs/NChF+8iAfWGVFmty6jb+kLonv/JDmnQso092hq5b3v+Rn6dR2u9pNlcJb32
 vyDtjMYhsYXNh/ccaY792PP4q4YjoqfVydlQw2NSiNBjJlVPLuidRcTObpascm5hLwn3
 x8aviO8LNf3odytaZJ7XuCObuChS5xmrQQIOr/xsJeiFeAvbvOMUF3HZBZV0Zp5KrxTi
 9xnbF76qFJKkIoIsC7tdccHakdVT2nlJz/kVIfoAIwNxLcl0JHNmxQ0Th6vOjH+sHCwy
 lJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zNHqAFnuHiggwZ7jn9N18KxilmXmaHVrWak3lSk+d74=;
 b=Pr2aHapNgZFNggwdqa0Hrvx8adM1n23O5t1RSFYUe9mivxOa6tgAtnlSZWfLgL6ACM
 O/P/NGCjKV8m5/n1h0x513RxrQSezwTTSRqg5ZHa+v+cesjavzFWJMqqtB5VD9AgRWiC
 FYmqaVWzx9HPJPV8YdoQR2JirDExxfH2f8o75m3vJSB+UiJqUfypbByZk/bO8FQoprNR
 HcOXvHlKYavQtNZ5bqluD3JP5RZSFj5WOKe74Kxeu7GJei/pikGn1sKWOQKpWIESP1OI
 +hNUhWTPH3WUfs/XbZnYnLE6BfucbqdW6dUKVCmZaXUulsiy4n8efY95M8nErtq8UYwz
 A7FA==
X-Gm-Message-State: AOAM530p8QdhwLfAmjy5KXG4u2/yifLtYnZmwR3vpB4PPgRHemDhfPRF
 932JMGVIi7PzDzF3573H7FioqpZbEUQd
X-Google-Smtp-Source: ABdhPJzqGHIW5BlqjxrpUF6cFXd1RySHNQzV5SgkIh3LB+LBsAvRqWs0V+o2D2lg90iac2o/nK8DBUg+bdAv
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:1845:: with SMTP id
 66mr543521yby.396.1631151514456; Wed, 08 Sep 2021 18:38:34 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:04 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-5-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 04/18] KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

With the inclusion of sysreg.h, that brings in system register
encodings, it would be redundant to re-define register encodings
again in processor.h to use it with ARM64_SYS_REG for the KVM
functions such as set_reg() or get_reg(). Hence, add helper macro,
ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
into ARM64_SYS_REG definitions.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h      | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index bed4ffa70905..ac8b63f8aab7 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -26,6 +26,20 @@
 
 #define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
 
+/*
+ * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
+ * SYS_* register definitions in sysreg.h to use in KVM
+ * calls such as get_reg() and set_reg().
+ */
+#define ARM64_SYS_KVM_REG(sys_reg_id)			\
+({							\
+	ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),		\
+			sys_reg_Op1(sys_reg_id),	\
+			sys_reg_CRn(sys_reg_id),	\
+			sys_reg_CRm(sys_reg_id),	\
+			sys_reg_Op2(sys_reg_id));	\
+})
+
 /*
  * Default MAIR
  *                  index   attribute
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

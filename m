Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75322C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 28379619E8
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 28379619E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEB624B224;
	Mon,  8 Nov 2021 21:39:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DQgpYyw-XHfc; Mon,  8 Nov 2021 21:39:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8383E4B202;
	Mon,  8 Nov 2021 21:39:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27AF74B1E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kEXSiS23n7v9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:40 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 854E04B202
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:39 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 x14-20020a63cc0e000000b002a5bc462947so11244171pgf.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tc3mXVzzOaZBy5gyuY36RG3hrmBxESsxJH6cjzwnYCE=;
 b=Re6hB7wRoT18fAcpM30azZmr5LuzK6wqyf/A8iUeb0FcMAeRijXmJNCamHrNbyVJYV
 sa2cJFJkbLzmyswtvwuSPlxXVH3CkpN9Nn6mxLs+UVXzoDgnQGLMxFV0kYA5RrDvBEON
 9yH2SI589qCICvAD68c8bWJZ0dftj7oYaul1wnYvGoGu9ylzuZzZnb5OBxJJm1JKmI/F
 dJ/98P6tXrZmYr+cNwokFbq/PitIVz6TVdDoR2LjkxFKB8graOPS8Ri559A05evEmb1x
 n/2RQ5x6zo/jGhyllBtP/5qqdC0SeY5JCcUCmsp7ifL+6z8bMWQARIqeTF4H2/ooQrSF
 7ujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tc3mXVzzOaZBy5gyuY36RG3hrmBxESsxJH6cjzwnYCE=;
 b=Q9eNkEBBSxsk4Q8dB6XNJXeB4tkdH2SuFCQacE0hcEVL/9lXEkgjk2ml6m0Y+/OiUj
 Pj8rxXo2kXtrXXayOm8sMKgKgAezpqCsY8Orb7W6dHuiCgKum+UIibOGS5F8ButIiEbr
 952fmH9FASRRSmnAG8dBF3jscAavOeD1pU9cwifk9qEoKU4v4YoWfED49nQP+p8Py8Ac
 KF2ep0FdbPAtBT4RDNLZ1CUgIMJO9bdegfRzVeD9E0mKMS/to0muvEblu+19G21NAqOI
 IUmLzg2Z88hwrs6OFNIQF192FMe12dhPMi0bv3SKSZcCsnBLENx1ZY14m8YExzMvjgs5
 SZBA==
X-Gm-Message-State: AOAM531n7kAcgyt3vsOZ0JaH6dkLrEykaM0CVZLFu7HYQzSCoDuCCoHq
 vUG+/K7hmmW7Lu/kcWbz8fb/xW8Sqkm7sQ==
X-Google-Smtp-Source: ABdhPJyPSCCkl/K5UVGKkEu9Pa4VFG9SOYr7MwUgakcjaRqD+5d0aaPnebxqZaIiLnYnhcP9ybbQCof1iuzpkg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7608:b0:141:9a53:ceff with SMTP
 id k8-20020a170902760800b001419a53ceffmr3722147pll.78.1636425578745; Mon, 08
 Nov 2021 18:39:38 -0800 (PST)
Date: Mon,  8 Nov 2021 18:39:05 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-17-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 16/17] KVM: selftests: aarch64: add ISPENDR write tests in
 vgic_irq
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Add injection tests that use writing into the ISPENDR register (to mark
IRQs as pending). This is typically used by migration code.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 121113f24ed3..ab39f0bf18e7 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -65,6 +65,7 @@ typedef enum {
 	KVM_SET_IRQ_LINE_HIGH,
 	KVM_SET_LEVEL_INFO_HIGH,
 	KVM_INJECT_IRQFD,
+	KVM_WRITE_ISPENDR,
 } kvm_inject_cmd;
 
 struct kvm_inject_args {
@@ -105,6 +106,7 @@ static struct kvm_inject_desc inject_edge_fns[] = {
 	/*                                      sgi    ppi    spi */
 	{ KVM_INJECT_EDGE_IRQ_LINE,		false, false, true },
 	{ KVM_INJECT_IRQFD,			false, false, true },
+	{ KVM_WRITE_ISPENDR,			true,  false, true },
 	{ 0, },
 };
 
@@ -113,6 +115,7 @@ static struct kvm_inject_desc inject_level_fns[] = {
 	{ KVM_SET_IRQ_LINE_HIGH,		false, true,  true },
 	{ KVM_SET_LEVEL_INFO_HIGH,		false, true,  true },
 	{ KVM_INJECT_IRQFD,			false, false, true },
+	{ KVM_WRITE_ISPENDR,			false, true,  true },
 	{ 0, },
 };
 
@@ -495,6 +498,20 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 	}
 }
 
+static void kvm_irq_write_ispendr_check(int gic_fd, uint32_t intid,
+			uint32_t vcpu, bool expect_failure)
+{
+	/*
+	 * Ignore this when expecting failure as invalid intids will lead to
+	 * either trying to inject SGIs when we configured the test to be
+	 * level_sensitive (or the reverse), or inject large intids which
+	 * will lead to writing above the ISPENDR register space (and we
+	 * don't want to do that either).
+	 */
+	if (!expect_failure)
+		kvm_irq_write_ispendr(gic_fd, intid, vcpu);
+}
+
 static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
 		uint32_t intid, uint32_t num, uint32_t kvm_max_routes,
 		bool expect_failure)
@@ -597,6 +614,11 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 					test_args->kvm_max_routes,
 					expect_failure);
 		break;
+	case KVM_WRITE_ISPENDR:
+		for (i = intid; i < intid + num; i++)
+			kvm_irq_write_ispendr_check(gic_fd, i,
+					VCPU_ID, expect_failure);
+		break;
 	default:
 		break;
 	}
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

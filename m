Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9673BC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44812619EA
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 44812619EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9AAC4B1E3;
	Mon,  8 Nov 2021 21:39:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aX8OQvKTIpls; Mon,  8 Nov 2021 21:39:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 491964B1E4;
	Mon,  8 Nov 2021 21:39:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 941D34B125
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DDJVLdM1f5uQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:21 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EA084B1E0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:20 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 n22-20020a6563d6000000b0029261ffde9bso11238846pgv.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uniPEnuX0gk6QJKFukwf5b6AeT8wkhedLb4e6yWrmRE=;
 b=cG46+tLyMfC8E+1FJHQpqSu4Vbj+OiIbfEpy5p1NQAa+m49AfuMrjXaxrgO6GHL0aY
 TeOOBhzqqxWrm8iHjdug9No4pC+oTadJGj+iziMUuNt2Myh2dR0jb/Eykriurjpu4lBk
 9kdjPokVXRh/shl9/6okG7g3U4+pd1ukU09oNuQB6vFrB00cQXNzuYMQ60yTL46wa0co
 +BPaT52cPC1eD4cQBBvE+UT2U36X+J6uBTYEONmYRYtRKQ3GGlJZ48KlVjurtTPg0yNb
 K77of8S0UO8HCuEur5bB2c90AaHve/TCp/NZMuDjeIawRFQAGKBhlE2ImpiMnv0gDG2U
 fcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uniPEnuX0gk6QJKFukwf5b6AeT8wkhedLb4e6yWrmRE=;
 b=bM6jYyfrjzue17bMflzhMH6GOmIVfq3fj3kTR2NKSTgvhj5ckBf6fWzgUXBdwRmIVA
 gG0H7q3G5KwBK8OZnIG/eoDHoXZSUkYCRsN+LvZLQd6YapiZMr9qzrp+63mFvEehwV1h
 vtEubipM+Sk3fV60Vs++UHRjPnnKVqkq+kt3MqjDddOa7I6D0Deh7tQKM2RulYuSrb1J
 XNbYtGqGwWqGSB1xONPQfbgbms5try9QBhOMZX4PyrU74m/r0yIpx9LpCC9dRhGNuMZJ
 fWU8VfHD3kX7eoBiFvqCgshrehXpqBurIuzz4u/eoZI6Pi8xGoXP3HRvn51zervPhwv6
 AF9g==
X-Gm-Message-State: AOAM532sdbOR222B4jUGz8g9UEvsioe3xUFPfR/WFzFTLvX34oomJG88
 41lSHomPLgX8Wi+09NLTsaU1B2oYKil6YA==
X-Google-Smtp-Source: ABdhPJzM2HDlpLCFeVGD1I8VKS6/Hls1yIJys+w+uzA32rZ+hWXRKhQTWiwEtpYWa+gIZZ+AndDlQYxnlSUrKw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4ad0:: with SMTP id
 mh16mr3376599pjb.176.1636425559349; Mon, 08 Nov 2021 18:39:19 -0800 (PST)
Date: Mon,  8 Nov 2021 18:38:53 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 04/17] KVM: selftests: add kvm_irq_line library function
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

Add an architecture independent wrapper function for the KVM_IRQ_LINE
ioctl.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index f6b3794f306b..c6831fd8aea7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -239,6 +239,8 @@ int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		       void *val, bool write);
 int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		      void *val, bool write);
+void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
+int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
 
 int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			  uint64_t attr);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 041004c0fda7..7d9cb8358702 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2078,6 +2078,27 @@ int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 	return ret;
 }
 
+/*
+ * IRQ related functions.
+ */
+
+int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
+{
+	struct kvm_irq_level irq_level = {
+		.irq    = irq,
+		.level  = level,
+	};
+
+	return _vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
+}
+
+void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
+{
+	int ret = _kvm_irq_line(vm, irq, level);
+
+	TEST_ASSERT(ret >= 0, "KVM_IRQ_LINE failed, rc: %i errno: %i", ret, errno);
+}
+
 /*
  * VM Dump
  *
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

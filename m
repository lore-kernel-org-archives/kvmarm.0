Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EB3C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7A9D619E4
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B7A9D619E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8204B1FB;
	Mon,  8 Nov 2021 21:39:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NQ51jz3iBcNT; Mon,  8 Nov 2021 21:39:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AA564B22E;
	Mon,  8 Nov 2021 21:39:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8511E4B1DB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MuTwhpHUcpeP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:38 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 493964B212
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:36 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 p16-20020a170902e75000b0014271728fd6so1969347plf.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GES34y6vW0ebb/dfUgRINMRJKHYQGjmRo+EZqwaIueY=;
 b=jiXduLdnJkx6DErFWp2JDCOijv3TFXCxT3uZujtWXXxgyB0fFpmQtlBLiuqtzy3PDT
 YYZN5cL67RDOi6oDxCE5BZLUArXl0lyIA1BJYSiB6uqXr8qLJivYMihA1DPwK6IhlCFj
 +J1mOK6flPI7qR7JOEU/+m/RbmnFRTFFDSuG3SuCy3uCJTtbA4fv/EnFzgc6fr4NELZ3
 PUgWnrLGaRB6RL5UYEyQ+0/8s+bjQboyZVYPM5iAlVNd1pCtNCUrhXOlNY0uzPqaqy1/
 429atQDcnFcqKzC7WEd12/4fFQ0CUhpuwLU1V0fY0WMojtWx26SgM3zxoSHncuJDP/r3
 AVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GES34y6vW0ebb/dfUgRINMRJKHYQGjmRo+EZqwaIueY=;
 b=WBKKmVhtos8f54Ghy5dOU26oW2GGvO7/0E725Tc40Hvs8CJq3hbuL/q7rUqRhLq8KT
 xQVQiSxLaZXF/fXSUeoSmfxpjalCQSFB+rrqRPsCn34piHuVK0eObmVnR2IYWRFMN2gG
 j25yB6yFtW6o/SjE+v46xmu3P5d2s702flopbB9VwfUQJDpGCy1jOnj1JifsGKIy0dd3
 rc4uPCpWBNjAXB7uTvvHJqA8twGQ6B3WB98YOosNz033/XhFaS6z02tziS7OJT8zXj6T
 J15dAxIYiTSivrvwdM7lIHAkjAJVKg1ACMNweAia/FyiwoRjCmT2lpbTUoADjz9N0Di+
 7lZQ==
X-Gm-Message-State: AOAM533+gD7FSIMKymeVJV2TOKrGJeS21Lq8PQBcR/BLaBF3l225y7Kw
 hvQj4yW5Qeu91eqtxQPhoa88WpZNBvtufw==
X-Google-Smtp-Source: ABdhPJzO1D1+Dk2URw44WZn2b3SSBgPjATtGTsr+/7avX/ccU6voQidUrVDPgjRDV2e/RzeBE1FF4OFi9Upaqw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr137518pjf.1.1636425575183; Mon, 08 Nov 2021 18:39:35 -0800 (PST)
Date: Mon,  8 Nov 2021 18:39:03 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-15-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 14/17] KVM: selftests: add IRQ GSI routing library functions
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

Add an architecture independent wrapper function for creating and
writing IRQ GSI routing tables. Also add a function to add irqchip
entries.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  8 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 51 +++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c6831fd8aea7..26c0722d7f77 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -251,6 +251,14 @@ int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			 uint64_t attr, void *val, bool write);
 
+#define KVM_MAX_IRQ_ROUTES		4096
+
+struct kvm_irq_routing *kvm_gsi_routing_create(void);
+void kvm_gsi_routing_irqchip_add(struct kvm_irq_routing *routing,
+		uint32_t gsi, uint32_t pin);
+int _kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
+void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
+
 const char *exit_reason_str(unsigned int exit_reason);
 
 void virt_pgd_alloc(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7d9cb8358702..2a38d717bc67 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2099,6 +2099,57 @@ void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
 	TEST_ASSERT(ret >= 0, "KVM_IRQ_LINE failed, rc: %i errno: %i", ret, errno);
 }
 
+struct kvm_irq_routing *kvm_gsi_routing_create(void)
+{
+	struct kvm_irq_routing *routing;
+	size_t size;
+
+	size = sizeof(struct kvm_irq_routing);
+	/* Allocate space for the max number of entries: this wastes 196 KBs. */
+	size += KVM_MAX_IRQ_ROUTES * sizeof(struct kvm_irq_routing_entry);
+	routing = calloc(1, size);
+	assert(routing);
+
+	return routing;
+}
+
+void kvm_gsi_routing_irqchip_add(struct kvm_irq_routing *routing,
+		uint32_t gsi, uint32_t pin)
+{
+	int i;
+
+	assert(routing);
+	assert(routing->nr < KVM_MAX_IRQ_ROUTES);
+
+	i = routing->nr;
+	routing->entries[i].gsi = gsi;
+	routing->entries[i].type = KVM_IRQ_ROUTING_IRQCHIP;
+	routing->entries[i].flags = 0;
+	routing->entries[i].u.irqchip.irqchip = 0;
+	routing->entries[i].u.irqchip.pin = pin;
+	routing->nr++;
+}
+
+int _kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing)
+{
+	int ret;
+
+	assert(routing);
+	ret = ioctl(vm_get_fd(vm), KVM_SET_GSI_ROUTING, routing);
+	free(routing);
+
+	return ret;
+}
+
+void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing)
+{
+	int ret;
+
+	ret = _kvm_gsi_routing_write(vm, routing);
+	TEST_ASSERT(ret == 0, "KVM_SET_GSI_ROUTING failed, rc: %i errno: %i",
+				ret, errno);
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

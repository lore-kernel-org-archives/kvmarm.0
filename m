Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4907C433B4
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73ABB613C8
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73ABB613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D1D74B41E;
	Fri,  7 May 2021 02:41:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UGxYDF2rDugN; Fri,  7 May 2021 02:41:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E03A84B529;
	Fri,  7 May 2021 02:41:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E06894B28B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tS4CK+qg5r09 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:41:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C61C74B52F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369669;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=yG5aDKv7DIi2eszWYTGurLfzUxHheIVVM/sgdYtthIM=;
 b=dcOa+wn/qfSHeCoexLmJkAMFh8lDUAn93XWmcAnKJTa1BJIr6hfhZmmND6eXCnmryMCKC8
 u6oKvJL+aOWofn6/wz+2o7h0s+Zwv8Dg1yGJJk6Ob12E893NGrtpgiqYWac9mmq7gaDj+i
 mvY91e61/SujFHa7O7EblxeEkIHhd7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-ytiG5E5NOKqf3JdTA39xAw-1; Fri, 07 May 2021 02:41:07 -0400
X-MC-Unique: ytiG5E5NOKqf3JdTA39xAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EFA98015F5;
 Fri,  7 May 2021 06:41:06 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 5DD8474AD5;
 Fri,  7 May 2021 06:41:02 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 03/15] KVM: async_pf: Make GFN slot management generic
Date: Fri,  7 May 2021 16:40:41 +0800
Message-Id: <20210507084053.44407-4-gshan@redhat.com>
In-Reply-To: <20210507084053.44407-1-gshan@redhat.com>
References: <20210507084053.44407-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
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

It's not allowed to fire duplicate notification for same GFN on
x86 platform, with help of a hash table. This mechanism is going
to be used by arm64 and this makes the code generic and shareable
by multiple platforms.

   * As this mechanism isn't needed by all platforms, a new kernel
     config option (CONFIG_ASYNC_PF_SLOT) is introduced so that it
     can be disabled at compiling time.

   * The code is basically copied from x86 platform and the functions
     are renamed to reflect the fact: (a) the input parameters are
     vCPU and GFN. (b) The operations are resetting, searching, adding
     and removing.

   * Helper stub is also added on !CONFIG_KVM_ASYNC_PF because we're
     going to use IS_ENABLED() instead of #ifdef on arm64 when the
     asynchronous page fault is supported.

This is preparatory work to use the newly introduced functions on x86
platform and arm64 in subsequent patches.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 include/linux/kvm_host.h | 18 +++++++++
 virt/kvm/Kconfig         |  3 ++
 virt/kvm/async_pf.c      | 85 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 00811de013d0..bade8f306ee8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -292,6 +292,9 @@ struct kvm_vcpu {
 
 #ifdef CONFIG_KVM_ASYNC_PF
 	struct {
+#ifdef CONFIG_KVM_ASYNC_PF_SLOT
+		gfn_t gfns[ASYNC_PF_PER_VCPU];
+#endif
 		u32 queued;
 		struct list_head queue;
 		struct list_head done;
@@ -331,6 +334,13 @@ struct kvm_async_pf {
 	bool				notpresent_injected;
 };
 
+#ifdef CONFIG_KVM_ASYNC_PF_SLOT
+void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu);
+void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
+void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
+bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
+#endif
+
 static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 {
 	return !list_empty_careful(&vcpu->async_pf.done);
@@ -342,6 +352,14 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			unsigned long hva, struct kvm_arch_async_pf *arch);
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #else
+static inline void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu) { }
+static inline void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn) { }
+static inline void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn) { }
+static inline bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	return false;
+}
+
 static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 {
 	return false;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 1c37ccd5d402..74f33151e0b1 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -23,6 +23,9 @@ config KVM_MMIO
 config KVM_ASYNC_PF
        bool
 
+config KVM_ASYNC_PF_SLOT
+	bool
+
 # Toggle to switch between direct notification and batch job
 config KVM_ASYNC_PF_SYNC
        bool
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index d145a61a046a..0d1fdb2932af 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -13,12 +13,97 @@
 #include <linux/module.h>
 #include <linux/mmu_context.h>
 #include <linux/sched/mm.h>
+#ifdef CONFIG_KVM_ASYNC_PF_SLOT
+#include <linux/hash.h>
+#endif
 
 #include "async_pf.h"
 #include <trace/events/kvm.h>
 
 static struct kmem_cache *async_pf_cache;
 
+#ifdef CONFIG_KVM_ASYNC_PF_SLOT
+static inline u32 kvm_async_pf_hash(gfn_t gfn)
+{
+	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
+
+	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
+}
+
+static inline u32 kvm_async_pf_next_slot(u32 key)
+{
+	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
+}
+
+static u32 kvm_async_pf_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 key = kvm_async_pf_hash(gfn);
+	int i;
+
+	for (i = 0; i < ASYNC_PF_PER_VCPU &&
+		(vcpu->async_pf.gfns[key] != gfn &&
+		vcpu->async_pf.gfns[key] != ~0); i++)
+		key = kvm_async_pf_next_slot(key);
+
+	return key;
+}
+
+void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
+		vcpu->async_pf.gfns[i] = ~0;
+}
+
+void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 key = kvm_async_pf_hash(gfn);
+
+	while (vcpu->async_pf.gfns[key] != ~0)
+		key = kvm_async_pf_next_slot(key);
+
+	vcpu->async_pf.gfns[key] = gfn;
+}
+
+void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 i, j, k;
+
+	i = j = kvm_async_pf_slot(vcpu, gfn);
+
+	if (WARN_ON_ONCE(vcpu->async_pf.gfns[i] != gfn))
+		return;
+
+	while (true) {
+		vcpu->async_pf.gfns[i] = ~0;
+
+		do {
+			j = kvm_async_pf_next_slot(j);
+			if (vcpu->async_pf.gfns[j] == ~0)
+				return;
+
+			k = kvm_async_pf_hash(vcpu->async_pf.gfns[j]);
+			/*
+			 * k lies cyclically in ]i,j]
+			 * |    i.k.j |
+			 * |....j i.k.| or  |.k..j i...|
+			 */
+		} while ((i <= j) ? (i < k && k <= j) : (i < k || k <= j));
+
+		vcpu->async_pf.gfns[i] = vcpu->async_pf.gfns[j];
+		i = j;
+	}
+}
+
+bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 key = kvm_async_pf_slot(vcpu, gfn);
+
+	return vcpu->async_pf.gfns[key] == gfn;
+}
+#endif /* CONFIG_KVM_ASYNC_PF_SLOT */
+
 int kvm_async_pf_init(void)
 {
 	async_pf_cache = KMEM_CACHE(kvm_async_pf, 0);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

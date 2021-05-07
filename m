Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D280AC433ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6745B613EA
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6745B613EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 081464B2C4;
	Fri,  7 May 2021 02:41:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OgZZc5P4vqzp; Fri,  7 May 2021 02:41:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBDD94B41E;
	Fri,  7 May 2021 02:41:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 951834B2C4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IZxiZHzDH429 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:41:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97BB84B449
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369665;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+/kypSFyh68OU3NA0OrwsIJ3llWio/dSx/GY0edISXo=;
 b=WITDsbr5Ge8nO6Wt/V6u/6FW9cbZxrqnmnp0/+VnD13F3LYHjvYFjEIuN87ntM0ZD7jNge
 t71WXi3LTI+GXJ9UBwhDKGizO0MpmMtCysclr6fQaAkE+pqWwAmVusOXEWgkUz98p+V4tB
 ftZ0YN14+F1KXcfxuESE04jky5XTMak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-KIpUE33aO7-J4lw9kAVjnw-1; Fri, 07 May 2021 02:41:03 -0400
X-MC-Unique: KIpUE33aO7-J4lw9kAVjnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0666802938;
 Fri,  7 May 2021 06:41:01 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 5D3765C276;
 Fri,  7 May 2021 06:40:58 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 02/15] KVM: async_pf: Add helper function to check
 completion queue
Date: Fri,  7 May 2021 16:40:40 +0800
Message-Id: <20210507084053.44407-3-gshan@redhat.com>
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

This adds inline function kvm_check_async_pf_completion_queue() to
check if there are pending completion in the queue. The empty stub
is also added on !CONFIG_KVM_ASYNC_PF so that the caller needn't
consider if CONFIG_KVM_ASYNC_PF is enabled.

All checks on the completion queue is done by the newly added inline
function since list_empty() and list_empty_careful() are interchangeable.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/x86/kvm/x86.c       |  2 +-
 include/linux/kvm_host.h | 10 ++++++++++
 virt/kvm/async_pf.c      | 10 +++++-----
 virt/kvm/kvm_main.c      |  4 +---
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cebdaa1e3cf5..300661dc6ca4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11075,7 +11075,7 @@ static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 {
-	if (!list_empty_careful(&vcpu->async_pf.done))
+	if (kvm_check_async_pf_completion_queue(vcpu))
 		return true;
 
 	if (kvm_apic_has_events(vcpu))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d54adba6ebf7..00811de013d0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -331,12 +331,22 @@ struct kvm_async_pf {
 	bool				notpresent_injected;
 };
 
+static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
+{
+	return !list_empty_careful(&vcpu->async_pf.done);
+}
+
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
 bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			unsigned long hva, struct kvm_arch_async_pf *arch);
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #else
+static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu) { }
 #endif
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index dd777688d14a..d145a61a046a 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -70,7 +70,7 @@ static void async_pf_execute(struct work_struct *work)
 		kvm_arch_async_page_present(vcpu, apf);
 
 	spin_lock(&vcpu->async_pf.lock);
-	first = list_empty(&vcpu->async_pf.done);
+	first = !kvm_check_async_pf_completion_queue(vcpu);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
 	apf->vcpu = NULL;
 	spin_unlock(&vcpu->async_pf.lock);
@@ -122,7 +122,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 		spin_lock(&vcpu->async_pf.lock);
 	}
 
-	while (!list_empty(&vcpu->async_pf.done)) {
+	while (kvm_check_async_pf_completion_queue(vcpu)) {
 		struct kvm_async_pf *work =
 			list_first_entry(&vcpu->async_pf.done,
 					 typeof(*work), link);
@@ -138,7 +138,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
 
-	while (!list_empty_careful(&vcpu->async_pf.done) &&
+	while (kvm_check_async_pf_completion_queue(vcpu) &&
 	      kvm_arch_can_dequeue_async_page_present(vcpu)) {
 		spin_lock(&vcpu->async_pf.lock);
 		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
@@ -205,7 +205,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	struct kvm_async_pf *work;
 	bool first;
 
-	if (!list_empty_careful(&vcpu->async_pf.done))
+	if (kvm_check_async_pf_completion_queue(vcpu))
 		return 0;
 
 	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
@@ -216,7 +216,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
 
 	spin_lock(&vcpu->async_pf.lock);
-	first = list_empty(&vcpu->async_pf.done);
+	first = !kvm_check_async_pf_completion_queue(vcpu);
 	list_add_tail(&work->link, &vcpu->async_pf.done);
 	spin_unlock(&vcpu->async_pf.lock);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2799c6660cce..d3a473f9811f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3129,10 +3129,8 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
 	if (kvm_arch_dy_runnable(vcpu))
 		return true;
 
-#ifdef CONFIG_KVM_ASYNC_PF
-	if (!list_empty_careful(&vcpu->async_pf.done))
+	if (kvm_check_async_pf_completion_queue(vcpu))
 		return true;
-#endif
 
 	return false;
 }
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

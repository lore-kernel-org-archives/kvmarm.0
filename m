Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFF3C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 09:43:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4344B827;
	Sat, 12 Nov 2022 04:43:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7AUUhDFXlGxs; Sat, 12 Nov 2022 04:43:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2A5D4B812;
	Sat, 12 Nov 2022 04:43:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 845834B808
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 04:43:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FvlzqqSq9Mf2 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 04:43:55 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 895824B803
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 04:43:55 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1668246235;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=+vth4QqRUuDSpOWMLlQs7VjBpqTVerCXz3PtT0havhE=;
 b=Npo6tUJGsaOu8O8vdd0KgOuhr1Sxkqu0lPYgHbY3/rl7GbGskoiyo0nETtMsjlFROom9j7
 RBDJRRQAg+oqmlHMHQJjB6JVnJ+hBbY1sJzFdKuW2s59amrrj0aga+CGtFhpH1Q7PoY3cC
 C0hiZgrRcOOAhSrX4gmdH1m1/RbG5zg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-DSjGDlhaODmp06gJS4w96A-1; Sat, 12 Nov 2022 04:43:51 -0500
X-MC-Unique: DSjGDlhaODmp06gJS4w96A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E58085A583;
 Sat, 12 Nov 2022 09:43:51 +0000 (UTC)
Received: from gshan.redhat.com (unknown [10.67.24.81])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A53AC17585;
 Sat, 12 Nov 2022 09:43:42 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH for-next] KVM: Push dirty information unconditionally to
 backup bitmap
Date: Sat, 12 Nov 2022 17:43:22 +0800
Message-Id: <20221112094322.21911-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, will@kernel.org, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

In mark_page_dirty_in_slot(), we bail out when no running vcpu exists
and a running vcpu context is strictly required by architecture. It may
cause backwards compatible issue. Currently, saving vgic/its tables is
the only known case where no running vcpu context is expected. We may
have other unknown cases where no running vcpu context exists and it's
reported by the warning message and we bail out without pushing the
dirty information to the backup bitmap. For this, the application is
going to enable the backup bitmap for the unknown cases. However, the
dirty information can't be pushed to the backup bitmap even though the
backup bitmap is enabled for those unknown cases in the application,
until the unknown cases are added to the allowed list of non-running
vcpu context with extra code changes to the host kernel.

In order to make the new application, where the backup bitmap has been
enabled, to work with the unchanged host, we continue to push the dirty
information to the backup bitmap instead of bailing out early. With the
added check on 'memslot->dirty_bitmap' to mark_page_dirty_in_slot(), the
kernel crash is avoided silently by the combined conditions: no running
vcpu context, kvm_arch_allow_write_without_running_vcpu() returns 'true',
and the backup bitmap (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) isn't enabled
yet.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 virt/kvm/kvm_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2719e10dd37d..03e6a38094c1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3308,8 +3308,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
 		return;
 
-	if (WARN_ON_ONCE(!kvm_arch_allow_write_without_running_vcpu(kvm) && !vcpu))
-		return;
+	WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm));
 #endif
 
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
@@ -3318,7 +3317,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 
 		if (kvm->dirty_ring_size && vcpu)
 			kvm_dirty_ring_push(vcpu, slot, rel_gfn);
-		else
+		else if (memslot->dirty_bitmap)
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

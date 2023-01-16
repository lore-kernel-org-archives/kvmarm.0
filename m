Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC5D10EA
	for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 04:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673841906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7h2CvV8GXjZs4C73BUDvN+HXzxZqbt6pIrQ0tWeaXU=;
	b=gdUb3NA1uYvxLVZhVaPME0Kxrvzhb9FY3a8E/df/BfSnY/yMbke5F/5QSK8KO39U4IVekb
	Go48vGq2DInZnsTf3oXxVfx7OZsmlnWiZ3jHPcrCV3CFeR+mEB5HerK4xfwsKYrumbSiY/
	TIQYEBvYda3+a0joqog7cKI9FVHpjV4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-QQaliHT-O_6-bWuaXxHQkw-1; Sun, 15 Jan 2023 23:05:00 -0500
X-MC-Unique: QQaliHT-O_6-bWuaXxHQkw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFF362A59543;
	Mon, 16 Jan 2023 04:04:59 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82BCA492B05;
	Mon, 16 Jan 2023 04:04:52 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	maz@kernel.org,
	corbet@lwn.net,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ricarkol@google.com,
	eric.auger@redhat.com,
	yuzhe@nfschina.com,
	renzhengeek@gmail.com,
	ardb@kernel.org,
	peterx@redhat.com,
	seanjc@google.com,
	shan.gavin@gmail.com
Subject: [PATCH 3/4] KVM: Refactor mark_page_dirty_in_slot()
Date: Mon, 16 Jan 2023 12:04:04 +0800
Message-Id: <20230116040405.260935-4-gshan@redhat.com>
In-Reply-To: <20230116040405.260935-1-gshan@redhat.com>
References: <20230116040405.260935-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9

Refactor mark_page_dirty_in_slot() to bail early if the memory slot
isn't existing or dirty page tracking is disabled on it. It's the
preparatory work for the forth coming fixes.

No functional change intended.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 virt/kvm/kvm_main.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384b5ae0..90f538433916 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3317,6 +3317,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		 	     gfn_t gfn)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	unsigned long rel_gfn;
+	u32 slot;
 
 #ifdef CONFIG_HAVE_KVM_DIRTY_RING
 	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
@@ -3325,15 +3327,16 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm));
 #endif
 
-	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
-		unsigned long rel_gfn = gfn - memslot->base_gfn;
-		u32 slot = (memslot->as_id << 16) | memslot->id;
+	if (!memslot || !kvm_slot_dirty_track_enabled(memslot))
+		return;
 
-		if (kvm->dirty_ring_size && vcpu)
-			kvm_dirty_ring_push(vcpu, slot, rel_gfn);
-		else if (memslot->dirty_bitmap)
-			set_bit_le(rel_gfn, memslot->dirty_bitmap);
-	}
+	rel_gfn = gfn - memslot->base_gfn;
+	slot = (memslot->as_id << 16) | memslot->id;
+
+	if (kvm->dirty_ring_size && vcpu)
+		kvm_dirty_ring_push(vcpu, slot, rel_gfn);
+	else if (memslot->dirty_bitmap)
+		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
 
-- 
2.23.0


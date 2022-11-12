Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6280B7B
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 09:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668246237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+vth4QqRUuDSpOWMLlQs7VjBpqTVerCXz3PtT0havhE=;
	b=XLDDZGqWLU9EpN9Lsp9KH+XXirV3aCDXyqqM+VDLwsPFg0PMXFdRF4J/Ogrv5wLuewRT5z
	t1LWF6JjaxGcnBKxayI7pwTAh+sPm9VEik8C06XRo5FONaSZ65FV/U6ylTCzEK9vmMdBWj
	GWYhqLy4ZWa7ub8i/TFLsUh6b9zbxGI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-DSjGDlhaODmp06gJS4w96A-1; Sat, 12 Nov 2022 04:43:51 -0500
X-MC-Unique: DSjGDlhaODmp06gJS4w96A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E58085A583;
	Sat, 12 Nov 2022 09:43:51 +0000 (UTC)
Received: from gshan.redhat.com (unknown [10.67.24.81])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A53AC17585;
	Sat, 12 Nov 2022 09:43:42 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	andrew.jones@linux.dev,
	ajones@ventanamicro.com,
	bgardon@google.com,
	dmatlack@google.com,
	will@kernel.org,
	suzuki.poulose@arm.com,
	alexandru.elisei@arm.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	peterx@redhat.com,
	seanjc@google.com,
	oliver.upton@linux.dev,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH for-next] KVM: Push dirty information unconditionally to backup bitmap
Date: Sat, 12 Nov 2022 17:43:22 +0800
Message-ID: <20221112094322.21911-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Message-ID: <20221112094322.qwGRXzwEijoOOpy3Cdq5VKNx_WmrlthJVCzIuhPo2bY@z>

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


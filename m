Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D235234
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 23:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674863576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c2wJW8358fg+BxDaJzgkd3OND14b2zFqKAQeciq7tLo=;
	b=ZnWA9wBQFqbyHWhKGMWZphZWbBW19ohO+OyhBydLrvwlaagro8Mg9h+6mXBPyywVxUdncH
	U5nuosGLUBiw8VCZAwOBlLTECuWSOn76iYjUhcGYM/h8L3bPdHln2+JvtFKgoaqsOMpTyN
	Wedq2MBrbAU0fFQJqQR3c2dsqFdUcFc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490--DjD9ThIOLGmJsNr4myWAw-1; Fri, 27 Jan 2023 18:52:52 -0500
X-MC-Unique: -DjD9ThIOLGmJsNr4myWAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5B672801E4F;
	Fri, 27 Jan 2023 23:52:51 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-64.bne.redhat.com [10.64.54.64])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F02B40C141B;
	Fri, 27 Jan 2023 23:52:44 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Cc: pbonzini@redhat.com,
	corbet@lwn.net,
	maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzhe@nfschina.com,
	gshan@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	ricarkol@google.com,
	eric.auger@redhat.com,
	renzhengeek@gmail.com,
	reijiw@google.com,
	shan.gavin@gmail.com
Subject: [PATCH v4 3/4] KVM: arm64: Allow no running vcpu on restoring VGICv3 LPI pending status
Date: Sat, 28 Jan 2023 07:51:49 +0800
Message-Id: <20230127235150.17025-4-gshan@redhat.com>
In-Reply-To: <20230127235150.17025-1-gshan@redhat.com>
References: <20230127235150.17025-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2

We don't have a running VCPU context to restore VGICv3 LPI pending status
due to command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM
device "kvm-arm-vgic-its".

Use vgic_write_guest_lock() to restore VGICv3 LPI pending status.

Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/api.rst | 8 +++++---
 arch/arm64/kvm/vgic/vgic-v3.c  | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9807b05a1b57..5dc3598afbe2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8070,9 +8070,11 @@ considering the state as complete. VMM needs to ensure that the dirty
 state is final and avoid missing dirty pages from another ioctl ordered
 after the bitmap collection.
 
-NOTE: One example of using the backup bitmap is saving arm64 vgic/its
-tables through KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on
-KVM device "kvm-arm-vgic-its" when dirty ring is enabled.
+NOTE: Multiple examples of using the backup bitmap: (1) save vgic/its
+tables through command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} on
+KVM device "kvm-arm-vgic-its". (2) restore vgic/its tables through
+command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM device
+"kvm-arm-vgic-its". VGICv3 LPI pending status is restored.
 
 8.30 KVM_CAP_XEN_HVM
 --------------------
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 5dfbd03e5e1a..c94e4d7520fc 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -338,7 +338,7 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 	if (status) {
 		/* clear consumed data */
 		val &= ~(1 << bit_nr);
-		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
+		ret = vgic_write_guest_lock(kvm, ptr, &val, 1);
 		if (ret)
 			return ret;
 	}
-- 
2.23.0


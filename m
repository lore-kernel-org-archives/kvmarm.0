Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE282F29
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 23:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674171922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3zFh3s/QzTjRrooT54dh0V5tVwdCR5pp1Mfct0DavzQ=;
	b=RS9cExi79YlY6Iih/kcgy8w4fDWEc6JG+LaCKpLXrQX2nTZOCrFdTanzfG+LeQqvkhivqs
	p+ZvohOWoFvFIiCJ6Tfkb86NGsb6hUbZgX42T8Hz6ctjWS4A2DAL7l1PWu9Q3tiev215SB
	j5exmv/nzfZAoZermBkxlh2S5kv06F8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-kWfVYrgHOYywcdOFPH1jDg-1; Thu, 19 Jan 2023 18:45:18 -0500
X-MC-Unique: kWfVYrgHOYywcdOFPH1jDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C00F085C064;
	Thu, 19 Jan 2023 23:45:17 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB5A02166B2A;
	Thu, 19 Jan 2023 23:45:10 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	pbonzini@redhat.com,
	corbet@lwn.net,
	maz@kernel.org,
	oliver.upton@linux.dev,
	will@kernel.org,
	gshan@redhat.com,
	ricarkol@google.com,
	eric.auger@redhat.com,
	yuzhe@nfschina.com,
	renzhengeek@gmail.com,
	reijiw@google.com,
	ardb@kernel.org,
	Julia.Lawall@inria.fr,
	yuzenghui@huawei.com,
	seanjc@google.com,
	shan.gavin@gmail.com
Subject: [PATCH v2 3/3] KVM: arm64: Allow no running vcpu on saving vgic3 pending table
Date: Fri, 20 Jan 2023 07:44:05 +0800
Message-Id: <20230119234405.349644-4-gshan@redhat.com>
In-Reply-To: <20230119234405.349644-1-gshan@redhat.com>
References: <20230119234405.349644-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6

We don't have a running VCPU context to save vgic3 pending table due
to KVM_DEV_ARM_VGIC_{GRP_CTRL, SAVE_PENDING_TABLES} command on KVM
device "kvm-arm-vgic-v3". The unknown case is caught by kvm-unit-tests.

   # ./kvm-unit-tests/tests/its-pending-migration
   WARNING: CPU: 120 PID: 7973 at arch/arm64/kvm/../../../virt/kvm/kvm_main.c:3325 \
   mark_page_dirty_in_slot+0x60/0xe0
    :
   mark_page_dirty_in_slot+0x60/0xe0
   __kvm_write_guest_page+0xcc/0x100
   kvm_write_guest+0x7c/0xb0
   vgic_v3_save_pending_tables+0x148/0x2a0
   vgic_set_common_attr+0x158/0x240
   vgic_v3_set_attr+0x4c/0x5c
   kvm_device_ioctl+0x100/0x160
   __arm64_sys_ioctl+0xa8/0xf0
   invoke_syscall.constprop.0+0x7c/0xd0
   el0_svc_common.constprop.0+0x144/0x160
   do_el0_svc+0x34/0x60
   el0_svc+0x3c/0x1a0
   el0t_64_sync_handler+0xb4/0x130
   el0t_64_sync+0x178/0x17c

Use vgic_write_guest_lock() to save vgic3 pending table.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst | 4 +++-
 arch/arm64/kvm/vgic/vgic-v3.c  | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 40ada313faa3..07f07668995e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8074,7 +8074,9 @@ NOTE: Multiple examples of using the backup bitmap: (1) save vgic/its
 tables through command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} on
 KVM device "kvm-arm-vgic-its". (2) restore vgic/its tables through
 command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM device
-"kvm-arm-vgic-its". vgic3 LPI pending status is restored.
+"kvm-arm-vgic-its". vgic3 LPI pending status is restored. (3) save
+vgic3 pending table through KVM_DEV_ARM_VGIC_{GRP_CTRL, SAVE_PENDING_TABLES}
+command on KVM device "kvm-arm-vgic-v3".
 
 8.30 KVM_CAP_XEN_HVM
 --------------------
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 2e680d8a0a15..fc2f24433076 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -437,7 +437,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 		else
 			val &= ~(1 << bit_nr);
 
-		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
+		ret = vgic_write_guest_lock(kvm, ptr, &val, 1);
 		if (ret)
 			goto out;
 	}
-- 
2.23.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7BA3B3FA
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686215048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dagrqDiq3A7dkc7gq9vL9zi12EhyXb6jT5d9cSUCfXk=;
	b=Hb25tLGkeSP6Pdbk4jT7TFRCyuOquKpXFvVSe6gSGJMyKSFAbOcWwLxqPNfCi2SEouXnL0
	90ykdM8xduBXP+TknUKTcrr/jXlM8jGW7OjN28OCWQKCjVVgpz4CFyzxxNobmP+De+2A69
	Db55EtpGEmlAYPAqKUo6+sItgDMyMH0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-uYlwIiBtPiGpmZWNBjNLZA-1; Thu, 08 Jun 2023 05:04:06 -0400
X-MC-Unique: uYlwIiBtPiGpmZWNBjNLZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 079FF185A78E;
	Thu,  8 Jun 2023 09:04:06 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-168.bne.redhat.com [10.64.54.168])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C3DC40D1B66;
	Thu,  8 Jun 2023 09:04:02 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	oliver.upton@linux.dev,
	maz@kernel.org,
	hshuai@redhat.com,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH] KVM: Avoid illegal stage2 mapping on invalid memory slot
Date: Thu,  8 Jun 2023 19:03:48 +1000
Message-Id: <20230608090348.414990-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2

We run into guest hang in edk2 firmware when KSM is kept as running
on the host. The edk2 firmware is waiting for status 0x80 from QEMU's
pflash device (TYPE_PFLASH_CFI01) during the operation for sector
erasing or buffered write. The status is returned by reading the
memory region of the pflash device and the read request should
have been forwarded to QEMU and emulated by it. Unfortunately, the
read request is covered by an illegal stage2 mapping when the guest
hang issue occurs. The read request is completed with QEMU bypassed and
wrong status is fetched.

The illegal stage2 mapping is populated due to same page mering by
KSM at (C) even the associated memory slot has been marked as invalid
at (B).

  CPU-A                    CPU-B
  -----                    -----
                           ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
                           kvm_vm_ioctl_set_memory_region
                           kvm_set_memory_region
                           __kvm_set_memory_region
                           kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
                             kvm_invalidate_memslot
                               kvm_copy_memslot
                               kvm_replace_memslot
                               kvm_swap_active_memslots        (A)
                               kvm_arch_flush_shadow_memslot   (B)
  same page merging by KSM
  kvm_mmu_notifier_change_pte
  kvm_handle_hva_range
  __kvm_handle_hva_range       (C)

Fix the issue by skipping the invalid memory slot at (C) to avoid the
illegal stage2 mapping. Without the illegal stage2 mapping, the read
request for the pflash's status is forwarded to QEMU and emulated by
it. The correct pflash's status can be returned from QEMU to break
the infinite wait in edk2 firmware.

Cc: stable@vger.kernel.org # v5.13+
Fixes: 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
Reported-by: Shuai Hu <hshuai@redhat.com>
Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 479802a892d4..7f81a3a209b6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -598,6 +598,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			unsigned long hva_start, hva_end;
 
 			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
+			if (slot->flags & KVM_MEMSLOT_INVALID)
+				continue;
+
 			hva_start = max(range->start, slot->userspace_addr);
 			hva_end = min(range->end, slot->userspace_addr +
 						  (slot->npages << PAGE_SHIFT));
-- 
2.23.0


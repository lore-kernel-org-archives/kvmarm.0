Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FB328EC
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 23:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674777309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SJZfNQFxxVstI8H1j3XkMVugmKRsdIV8JBMybkB1kW4=;
	b=Rywhiq6qp31+p+TQyXOFdpsasS4vbJkX8UWJJOo6jAPypeFDR9sMrOJwK0bLpta8XjkaT+
	7uLBxyMm8GXUSCNqbrsah8mTuMKK8ZN8AX1meU85qnDJmDIbx5mf9h53CDa4LqX8eyKkQe
	sO0oHcjk5tDv+xa47VyddbyTjCoGE2A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-AUDX19oQNx-EySF2tOJP5w-1; Thu, 26 Jan 2023 18:55:06 -0500
X-MC-Unique: AUDX19oQNx-EySF2tOJP5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA1BA185A78B;
	Thu, 26 Jan 2023 23:55:04 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E5792166B29;
	Thu, 26 Jan 2023 23:54:55 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	pbonzini@redhat.com,
	corbet@lwn.net,
	maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzhe@nfschina.com,
	isaku.yamahata@intel.com,
	seanjc@google.com,
	ricarkol@google.com,
	eric.auger@redhat.com,
	renzhengeek@gmail.com,
	reijiw@google.com,
	shan.gavin@gmail.com
Subject: [PATCH v3 0/4] Improve dirty ring warning report
Date: Fri, 27 Jan 2023 07:54:47 +0800
Message-Id: <20230126235451.469087-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6

It has been known case where no running VCPU context exists when the
vgic/its tables are saved. There are other two unknown cases where we
don't have the running VCPU context: (a) restore vgic3 LPI pending
status. (b) restoring vgic3 pending tables.

PATCH[1]     includes 'kvm_mmu.h' to 'vgic.h'
PATCH[2]     adds unified helper vgic_write_guest_lock()
PATCH[3 - 4] allows no-running-vcpu context for (a) and (b)

v2: https://lore.kernel.org/kvmarm/Y9Lg1ESUVJov0WpH@google.com/T/#t
v1: https://lore.kernel.org/kvmarm/20230116040405.260935-1-gshan@redhat.com/T/#t

Changelog
=========
v3:
  * Pick Oliver's r-bs
  * Include 'kvm_mmu.h' to 'vgic.h'                            (Oliver)
v2:
  * Add unified helper vgic_write_guest_lock()                 (Oliver)
  * Dropped two patches to refactor mark_page_dirty_in_slot()  (Sean)


Gavin Shan (4):
  KVM: arm64: Include kvm_mmu.h from vgic.h
  KVM: arm64: Add helper vgic_write_guest_lock()
  KVM: arm64: Allow no running vcpu on restoring vgic3 LPI pending
    status
  KVM: arm64: Allow no running vcpu on saving vgic3 pending table

 Documentation/virt/kvm/api.rst        | 10 +++++++---
 arch/arm64/kvm/vgic/vgic-debug.c      |  1 -
 arch/arm64/kvm/vgic/vgic-init.c       |  1 -
 arch/arm64/kvm/vgic/vgic-its.c        | 14 +++++---------
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  1 -
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  1 -
 arch/arm64/kvm/vgic/vgic-v2.c         |  1 -
 arch/arm64/kvm/vgic/vgic-v3.c         |  5 ++---
 arch/arm64/kvm/vgic/vgic.h            | 14 ++++++++++++++
 include/kvm/arm_vgic.h                |  2 +-
 10 files changed, 29 insertions(+), 21 deletions(-)

-- 
2.23.0


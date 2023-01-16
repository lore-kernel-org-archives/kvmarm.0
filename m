Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E5010EA
	for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 04:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673841882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PPbcjkK5NFxrKS7gt/P8CaZ7LsHJG99pgxGIGUkyjbE=;
	b=WdsXnE30SkqtoqyNgXWVUWeXM0tJJyQTQEE1YireWLTVWgF7NPJO+vMgRA7GIde+P1ITu2
	taBz3uMgDhew9IcHhvsXZHmFOpH+8MHUOmWYARpMli3lz8rVEKNJXGaLWER9olT28kkmBj
	MDiQfl6XDfI0cWRtRfDHKMoqQUjykt0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-bCJqG-YCNxyVRZqU4hIdUA-1; Sun, 15 Jan 2023 23:04:37 -0500
X-MC-Unique: bCJqG-YCNxyVRZqU4hIdUA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A60001C05B16;
	Mon, 16 Jan 2023 04:04:36 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F472492B05;
	Mon, 16 Jan 2023 04:04:16 +0000 (UTC)
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
Subject: [PATCH 0/4] Improve dirty ring warning report
Date: Mon, 16 Jan 2023 12:04:01 +0800
Message-Id: <20230116040405.260935-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9

It has been known case where no running VCPU context exists when the
vgic/its tables are saved. There are other two unknown cases where we
don't have the running VCPU context: (a) saving vgic3 LPI pending status
and (b) saving vgic3 pending tables. Besides, the warning reports in
mark_page_dirty_in_slot() is triggered even the dirty ring hasn't been
enabled by the user space. It's not the unexpected behaviour.

PATCH[1 - 2] Fixes the no-running VCPU context issue when vgic3 LPI
             and vgic3 pending table are saved.
PATCH[3 - 4] Improve the warning reports by enabling them when the
             dirty ring has been enabled by the user space.

Gavin Shan (4):
  KVM: arm64: Allow saving vgic3 LPI pending status in no running vcpu
    context
  KVM: arm64: Allow saving vgic3 pending tables in no running vcpu
    context
  KVM: Refactor mark_page_dirty_in_slot()
  KVM: Improve warning report in mark_page_dirty_in_slot()

 Documentation/virt/kvm/api.rst |  8 ++++++--
 arch/arm64/kvm/vgic/vgic-its.c |  3 ++-
 arch/arm64/kvm/vgic/vgic-v3.c  |  5 +++++
 include/kvm/arm_vgic.h         |  1 +
 include/linux/kvm_dirty_ring.h |  5 +++++
 virt/kvm/kvm_main.c            | 30 ++++++++++++++++++------------
 6 files changed, 37 insertions(+), 15 deletions(-)

-- 
2.23.0


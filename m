Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC272F29
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 23:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674171899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O26wXFwfbNKvM1Y0zBYnBKMX3ek+hLU/5IsgmYQVXCM=;
	b=Q+jfpO1upTbXnMkFLvBN7CxbfA+Dwoa5IK/lFegi4mvUJcrTx5c1scMZPAJoB4VqkopDRI
	31AgSNZb/f+vOK22ogHE2nKaBFxsv+2a7fsfzWsxN5S9bod0E8UafbDkSX3Uh4R/9TZnki
	s4KoEiQUf1e5gV8wZ+TJCrdqYoZHJgk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-X1kbE4T6MuiqRklvwNWn7Q-1; Thu, 19 Jan 2023 18:44:56 -0500
X-MC-Unique: X1kbE4T6MuiqRklvwNWn7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 161D63806104;
	Thu, 19 Jan 2023 23:44:55 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CABE72166B2A;
	Thu, 19 Jan 2023 23:44:47 +0000 (UTC)
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
Subject: [PATCH v2 0/3] Improve dirty ring warning report
Date: Fri, 20 Jan 2023 07:44:02 +0800
Message-Id: <20230119234405.349644-1-gshan@redhat.com>
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

PATCH[1]     adds unified helper vgic_write_guest_lock()
PATCH[2 - 3] allows no-running-vcpu context for (a) and (b)

v1: https://lore.kernel.org/kvmarm/20230116040405.260935-1-gshan@redhat.com/T/#t

Changelog
=========
v2:
  * Add unified helper vgic_write_guest_lock()                 (Oliver)
  * Dropped two patches to refactor mark_page_dirty_in_slot()  (Sean)

Gavin Shan (3):
  KVM: arm64: Add helper vgic_write_guest_lock()
  KVM: arm64: Allow no running vcpu on restoring vgic3 LPI pending
    status
  KVM: arm64: Allow no running vcpu on saving vgic3 pending table

 Documentation/virt/kvm/api.rst     | 10 +++++++---
 arch/arm64/kvm/vgic-sys-reg-v3.c   |  1 +
 arch/arm64/kvm/vgic/vgic-irqfd.c   |  1 +
 arch/arm64/kvm/vgic/vgic-its.c     | 13 +++++--------
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  1 +
 arch/arm64/kvm/vgic/vgic-mmio.c    |  1 +
 arch/arm64/kvm/vgic/vgic-v3.c      |  4 ++--
 arch/arm64/kvm/vgic/vgic-v4.c      |  1 +
 arch/arm64/kvm/vgic/vgic.c         |  1 +
 arch/arm64/kvm/vgic/vgic.h         | 13 +++++++++++++
 include/kvm/arm_vgic.h             |  2 +-
 11 files changed, 34 insertions(+), 14 deletions(-)

-- 
2.23.0


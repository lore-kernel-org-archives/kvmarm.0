Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DEF375
	for <kvmarm@lists.linux.dev>; Wed,  5 Oct 2022 00:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664930620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e2vO/HZgtB5CiMditasb5l4Z5VG/S1wRmLc+HGljeRM=;
	b=FWC3rmYKBo/f54GnxOpj3IK6NA6XcBeFwT7WUAXtycaTQw10ymhHE96goT+6pctQK8OWh0
	KsuzxEnAdYWQ5sVfwfScCW4+TtXy2pGsrv+YJUQFnu+MeeB9KEum30xkgj9+/kDlCCwpBb
	XnRhI1x+RjxfwnQ1DCl0MZD/CJtbYX0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-GD8dWRP4NOyG_JNcIYwqvQ-1; Tue, 04 Oct 2022 20:43:37 -0400
X-MC-Unique: GD8dWRP4NOyG_JNcIYwqvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74A9B811E67;
	Wed,  5 Oct 2022 00:43:14 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-56.bne.redhat.com [10.64.54.56])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C47A917583;
	Wed,  5 Oct 2022 00:42:51 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	peterx@redhat.com,
	catalin.marinas@arm.com,
	bgardon@google.com,
	shuah@kernel.org,
	andrew.jones@linux.dev,
	will@kernel.org,
	dmatlack@google.com,
	pbonzini@redhat.com,
	zhenyzha@redhat.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	alexandru.elisei@arm.com,
	oliver.upton@linux.dev,
	seanjc@google.com,
	shan.gavin@gmail.com
Subject: [PATCH v5 0/7] KVM: arm64: Enable ring-based dirty memory tracking
Date: Wed,  5 Oct 2022 08:41:47 +0800
Message-ID: <20221005004154.83502-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Message-ID: <20221005004147.w8iS3kamin_Pvn3dIniDlfI-J6BwTE71jMJpBCyDvXc@z>

This series enables the ring-based dirty memory tracking for ARM64.
The feature has been available and enabled on x86 for a while. It
is beneficial when the number of dirty pages is small in a checkpointing
system or live migration scenario. More details can be found from
fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking").

This series is applied on top of Marc's v2 series [0], fixing dirty-ring
ordering issue. This series is going to land on v6.1.rc0 pretty soon.

[0] https://lore.kernel.org/kvmarm/20220926145120.27974-1-maz@kernel.org

v4: https://lore.kernel.org/kvmarm/20220927005439.21130-1-gshan@redhat.com/
v3: https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
v2: https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com

Testing
=======
(1) kvm/selftests/dirty_log_test
(2) Live migration by QEMU

Changelog
=========
v5:
  * Drop empty stub kvm_dirty_ring_check_request()             (Marc/Peter)
  * Add PATCH[v5 3/7] to allow using bitmap, indicated by
    KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP                        (Marc/Peter)
v4:
  * Commit log improvement                                     (Marc)
  * Add helper kvm_dirty_ring_check_request()                  (Marc)
  * Drop ifdef for kvm_cpu_dirty_log_size()                    (Marc)
v3:
  * Check KVM_REQ_RING_SOFT_RULL inside kvm_request_pending()  (Peter)
  * Move declaration of kvm_cpu_dirty_log_size()               (test-robot)
v2:
  * Introduce KVM_REQ_RING_SOFT_FULL                           (Marc)
  * Changelog improvement                                      (Marc)
  * Fix dirty_log_test without knowing host page size          (Drew)

Gavin Shan (7):
  KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
  KVM: x86: Move declaration of kvm_cpu_dirty_log_size() to
    kvm_dirty_ring.h
  KVM: x86: Allow to use bitmap in ring-based dirty page tracking
  KVM: arm64: Enable ring-based dirty memory tracking
  KVM: selftests: Use host page size to map ring buffer in
    dirty_log_test
  KVM: selftests: Clear dirty ring states between two modes in
    dirty_log_test
  KVM: selftests: Automate choosing dirty ring size in dirty_log_test

 Documentation/virt/kvm/api.rst               | 19 ++++---
 arch/arm64/include/uapi/asm/kvm.h            |  1 +
 arch/arm64/kvm/Kconfig                       |  1 +
 arch/arm64/kvm/arm.c                         |  3 ++
 arch/x86/include/asm/kvm_host.h              |  2 -
 arch/x86/kvm/x86.c                           | 15 +++---
 include/linux/kvm_dirty_ring.h               |  9 ++--
 include/linux/kvm_host.h                     |  1 +
 include/uapi/linux/kvm.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c | 53 ++++++++++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c   |  2 +-
 virt/kvm/dirty_ring.c                        | 19 ++++++-
 virt/kvm/kvm_main.c                          | 24 ++++-----
 13 files changed, 92 insertions(+), 58 deletions(-)

-- 
2.23.0


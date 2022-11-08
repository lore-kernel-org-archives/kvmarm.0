Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F49C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Nov 2022 04:12:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A2854B8AE;
	Mon,  7 Nov 2022 23:12:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MrMJX5CGZTr6; Mon,  7 Nov 2022 23:12:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C7A54B8B6;
	Mon,  7 Nov 2022 23:12:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7570D4B8AE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 23:12:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pseyt9pJWjyk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 23:12:17 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B81A94B8A4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 23:12:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667880737;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=kWJeZzY3IwymxOSE8eyqhQVbBJ/OMii7d4/5NMTkL1I=;
 b=YoYcMb8yXyrwDPnCibaeW6b8iqnNND7uSbxgKuewjm5JO2+zzgekPh1dkOR6ZbkiJWPrhf
 zI2R6eXVcMSt7vJE87B8mh50mutYYvhXmJAVWL+282tIeaRQPTbQswEyAK4u7fmcchf7YR
 dWNAB/VbQTmlgUFFuq5g1LTt9AyFUs0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-4Qrpd2qIMzWBW-ymKzh8ew-1; Mon, 07 Nov 2022 23:12:16 -0500
X-MC-Unique: 4Qrpd2qIMzWBW-ymKzh8ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 989363C01DF0;
 Tue,  8 Nov 2022 04:12:15 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F89D35429;
 Tue,  8 Nov 2022 04:12:08 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH v9 0/7] KVM: arm64: Enable ring-based dirty memory tracking
Date: Tue,  8 Nov 2022 12:10:32 +0800
Message-Id: <20221108041039.111145-1-gshan@redhat.com>
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

This series enables the ring-based dirty memory tracking for ARM64.
The feature has been available and enabled on x86 for a while. It
is beneficial when the number of dirty pages is small in a checkpointing
system or live migration scenario. More details can be found from
fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking").

For PATCH[v9 3/7], Peter's ack-by is kept since the recent changes 
don't fundamentally break what he agreed. However, it would be nice
for Peter to double confirm.

v8: https://lore.kernel.org/kvmarm/e7196fb5-1e65-3a5b-ba88-1d98264110e3@redhat.com/T/#t
v7: https://lore.kernel.org/kvmarm/20221031003621.164306-1-gshan@redhat.com/
v6: https://lore.kernel.org/kvmarm/20221011061447.131531-1-gshan@redhat.com/
v5: https://lore.kernel.org/all/20221005004154.83502-1-gshan@redhat.com/
v4: https://lore.kernel.org/kvmarm/20220927005439.21130-1-gshan@redhat.com/
v3: https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
v2: https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com

Testing
=======
(1) kvm/selftests/dirty_log_test
(2) Live migration by QEMU (partially)

Changelog
=========
v9:
  * Improved documentation in PATCH[v9 3/7]                     (Marc/Peter)
  * Add helper to check if we have any memslot and lockdep
    assert is added to kvm_use_dirty_bitmap() in PATCH[v9 3/7]  (Sean/Oliver)
  * Drop the helper to return dist->save_its_tables_in_progress
    and move kvm_arch_allow_write_without_running_vcpu() to
    vgic-its.c in PATCH[v9 4/7]                                 (Marc)
v8:
  * Pick review-by and ack-by                                   (Peter/Sean)
  * Drop chunk of code to clear KVM_REQ_DIRTY_RING_SOFT_FULL
    in kvm_dirty_ring_reset(). Add comments to say the event
    will be cleared by the VCPU thread next time when it enters
    the guest. All other changes related to kvm_dirty_ring_reset()
    are dropped in PATCH[v8 1/7].                               (Sean/Peter/Marc)
  * Drop PATCH[v7 3/7] since it has been merged                 (Marc/Oliver)
  * Document the order of DIRTY_RING_{ACQ_REL, WITH_BITMAP},
    add check to ensure no memslots are created when
    DIRTY_RING_WITH_BITMAP is enabled, and add weak function
    kvm_arch_allow_write_without_running_vcpu() in PATCH[v8 3/7] (Oliver)
  * Only keep ourself out of non-running-vcpu radar when vgic/its
    tables are being saved in PATCH[v8 4/7]                      (Marc/Sean)
v7:
  * Cut down #ifdef, avoid using 'container_of()', move the
    dirty-ring check after KVM_REQ_VM_DEAD, add comments
    for kvm_dirty_ring_check_request(), use tab character
    for KVM event definitions in kvm_host.h in PATCH[v7 01]    (Sean)
  * Add PATCH[v7 03] to recheck if the capability has
    been advertised prior to enable RING/RING_ACEL_REL         (Sean)
  * Improve the description about capability RING_WITH_BITMAP,
    rename kvm_dirty_ring_exclusive() to kvm_use_dirty_bitmap()
    in PATCH[v7 04/09]                                         (Peter/Oliver/Sean)
  * Add PATCH[v7 05/09] to improve no-running-vcpu report      (Marc/Sean)
  * Improve commit messages                                    (Sean/Oliver)
v6:
  * Add CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP, for arm64
    to advertise KVM_CAP_DIRTY_RING_WITH_BITMAP in
    PATCH[v6 3/8]                                              (Oliver/Peter)
  * Add helper kvm_dirty_ring_exclusive() to check if
    traditional bitmap-based dirty log tracking is
    exclusive to dirty-ring in PATCH[v6 3/8]                   (Peter)
  * Enable KVM_CAP_DIRTY_RING_WITH_BITMAP in PATCH[v6 5/8]     (Gavin)
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
  KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
  KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
  KVM: Support dirty ring in conjunction with bitmap
  KVM: arm64: Enable ring-based dirty memory tracking
  KVM: selftests: Use host page size to map ring buffer in
    dirty_log_test
  KVM: selftests: Clear dirty ring states between two modes in
    dirty_log_test
  KVM: selftests: Automate choosing dirty ring size in dirty_log_test

 Documentation/virt/kvm/api.rst                | 36 ++++++++---
 .../virt/kvm/devices/arm-vgic-its.rst         |  5 +-
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/Kconfig                        |  2 +
 arch/arm64/kvm/arm.c                          |  3 +
 arch/arm64/kvm/vgic/vgic-its.c                | 20 ++++++
 arch/x86/include/asm/kvm_host.h               |  2 -
 arch/x86/kvm/x86.c                            | 15 ++---
 include/kvm/arm_vgic.h                        |  1 +
 include/linux/kvm_dirty_ring.h                | 20 +++---
 include/linux/kvm_host.h                      | 10 +--
 include/uapi/linux/kvm.h                      |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c  | 53 +++++++++++----
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-
 virt/kvm/Kconfig                              |  8 +++
 virt/kvm/dirty_ring.c                         | 44 ++++++++++++-
 virt/kvm/kvm_main.c                           | 64 +++++++++++++++----
 17 files changed, 227 insertions(+), 60 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

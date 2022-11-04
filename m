Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC8DC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 23:41:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3DF49E1A;
	Fri,  4 Nov 2022 19:41:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZwNg7Z8wkeRs; Fri,  4 Nov 2022 19:41:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2023740C1F;
	Fri,  4 Nov 2022 19:41:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FCDC40AF2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 19:41:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uSqXPMtUfSFd for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 19:41:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8F6F401C6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 19:41:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667605272;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=XWxgwafshZIITRYDM/RSB09f3dY5+w75t0i+zCM8F8E=;
 b=KF9YTJhHlVLZqYOqTJaNO0Zo3QET4Lx8B2p7ex0ByfLE8sMFlNJAyNcJubF/mmNRimJsDD
 o1XA618WnUleYuaApW89lxuAmqC4Fqws5uF22BZ+3cvRBrsI7c87FyLTm/dBS1Mn8qGSTb
 5IkXl2+wYKUklOuFcg+KHg1OAWa+Yc0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-zgzoIETZNWmtuv6fOn29OA-1; Fri, 04 Nov 2022 19:41:09 -0400
X-MC-Unique: zgzoIETZNWmtuv6fOn29OA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65932101A528;
 Fri,  4 Nov 2022 23:41:02 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A247E4A9254;
 Fri,  4 Nov 2022 23:40:55 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH v8 0/7] KVM: arm64: Enable ring-based dirty memory tracking
Date: Sat,  5 Nov 2022 07:40:42 +0800
Message-Id: <20221104234049.25103-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

This series is applied to v6.1.rc3, plus commit c227590467cb ("KVM:
Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL} prior to enabling them").
The commit is currently in Marc's 'fixes' branch, targeting v6.1.rc4/5.

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
(2) Live migration by QEMU

Changelog
=========
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

 Documentation/virt/kvm/api.rst               | 35 ++++++++++---
 arch/arm64/include/uapi/asm/kvm.h            |  1 +
 arch/arm64/kvm/Kconfig                       |  2 +
 arch/arm64/kvm/arm.c                         |  3 ++
 arch/arm64/kvm/mmu.c                         | 15 ++++++
 arch/arm64/kvm/vgic/vgic-its.c               |  3 ++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c           |  7 +++
 arch/x86/include/asm/kvm_host.h              |  2 -
 arch/x86/kvm/x86.c                           | 15 +++---
 include/kvm/arm_vgic.h                       |  2 +
 include/linux/kvm_dirty_ring.h               | 20 +++++---
 include/linux/kvm_host.h                     | 10 ++--
 include/uapi/linux/kvm.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c | 53 ++++++++++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c   |  2 +-
 virt/kvm/Kconfig                             |  8 +++
 virt/kvm/dirty_ring.c                        | 42 +++++++++++++++-
 virt/kvm/kvm_main.c                          | 52 +++++++++++++++----
 18 files changed, 214 insertions(+), 59 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

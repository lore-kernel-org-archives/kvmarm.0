Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C437AECAAD8
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 00:32:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5694B601;
	Wed, 21 Sep 2022 20:32:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id njQX9aXT6VID; Wed, 21 Sep 2022 20:32:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B20494B105;
	Wed, 21 Sep 2022 20:32:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8A8C4B105
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 20:32:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4f0eTjmEnAN1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 20:32:29 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DFFC4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 20:32:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663806749;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=ccbp8BD4kcBiFdBToxQRh5neaOCPlEmQcd7egl4H6S4=;
 b=E0RK1mm0+9AozkXhWJceX4js5h2voxPnDCMRPxTtR4gdrgrNmwqfwfXmDUsPsh1ilFOiEO
 2jz0dJv6JWslAOVFWPnhdfCPzU5QzTvFJRgwRgnvPLADHnDI0++4DF2Pez++JhoUN3vAET
 j0e3k2KOQmTTmHRi1WuRn4MqvBAPeN0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-HcF3MiBoNYefjnk5N_Icpw-1; Wed, 21 Sep 2022 20:32:25 -0400
X-MC-Unique: HcF3MiBoNYefjnk5N_Icpw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C388C1C14B65;
 Thu, 22 Sep 2022 00:32:24 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-126.bne.redhat.com [10.64.54.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 61FEF2166B26;
 Thu, 22 Sep 2022 00:32:18 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 0/6] KVM: arm64: Enable ring-based dirty memory tracking
Date: Thu, 22 Sep 2022 08:32:08 +0800
Message-Id: <20220922003214.276736-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, will@kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, shuah@kernel.org
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

The generic part has been comprehensive, meaning there isn't too much
work, needed to extend it to ARM64.

  PATCH[1]   introduces KVM_REQ_RING_SOFT_FULL for x86
  PATCH[2]   moves declaration of kvm_cpu_dirty_log_size()
  PATCH[3]   enables the feature on ARM64
  PATCH[4-6] improves kvm/selftests/dirty_log_test

v2: https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com

Testing
=======
(1) kvm/selftests/dirty_log_test
(2) Live migration by QEMU

Changelog
=========
v3:
  * Check KVM_REQ_RING_SOFT_RULL inside kvm_request_pending()  (Peter)
  * Move declaration of kvm_cpu_dirty_log_size()               (test-robot)
v2:
  * Introduce KVM_REQ_RING_SOFT_FULL                           (Marc)
  * Changelog improvement                                      (Marc)
  * Fix dirty_log_test without knowing host page size          (Drew)

Gavin Shan (6):
  KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
  KVM: x86: Move declaration of kvm_cpu_dirty_log_size() to
    kvm_dirty_ring.h
  KVM: arm64: Enable ring-based dirty memory tracking
  KVM: selftests: Use host page size to map ring buffer in
    dirty_log_test
  KVM: selftests: Clear dirty ring states between two modes in
    dirty_log_test
  KVM: selftests: Automate choosing dirty ring size in dirty_log_test

 Documentation/virt/kvm/api.rst               |  2 +-
 arch/arm64/include/uapi/asm/kvm.h            |  1 +
 arch/arm64/kvm/Kconfig                       |  1 +
 arch/arm64/kvm/arm.c                         |  8 +++
 arch/x86/include/asm/kvm_host.h              |  2 -
 arch/x86/kvm/mmu/mmu.c                       |  2 +
 arch/x86/kvm/x86.c                           | 19 +++----
 include/linux/kvm_dirty_ring.h               |  1 +
 include/linux/kvm_host.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c | 53 ++++++++++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c   |  2 +-
 virt/kvm/dirty_ring.c                        |  4 ++
 12 files changed, 69 insertions(+), 27 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

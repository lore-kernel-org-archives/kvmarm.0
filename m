Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C00AC32771
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 00:55:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6EDE4B750;
	Mon, 26 Sep 2022 20:54:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id odsoZFEI1d+U; Mon, 26 Sep 2022 20:54:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 802414B64E;
	Mon, 26 Sep 2022 20:54:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BDA74B64E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 20:54:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id arLGLfgUfUEU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 20:54:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49A3C4B64C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 20:54:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664240095;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=ws7zU+gISAyBx1MgpyOG4IHg2lyJCsLl3GGmjikN0Kg=;
 b=TMNG9eLF4GxG5XgNTPpQS2FnZTQ7CiuCUNWGVoiymjvB1VHreK63MpQDXafQHgQUl8FECs
 qR/AMPlym3iH6KsYYYohBN8fxJaJVSsdqRhgXhy9Sj2+dbDdZyRtyTAp06k8gpS+C+v9ca
 MhsNjVIOFJ6foge5+wx7zllm02p0ZzY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-KD41FZ54NZyUq83xkWEe2A-1; Mon, 26 Sep 2022 20:54:51 -0400
X-MC-Unique: KD41FZ54NZyUq83xkWEe2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1BB03C02B7C;
 Tue, 27 Sep 2022 00:54:50 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-143.bne.redhat.com [10.64.54.143])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6523B40C2064;
 Tue, 27 Sep 2022 00:54:44 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 0/6] KVM: arm64: Enable ring-based dirty memory tracking
Date: Tue, 27 Sep 2022 08:54:33 +0800
Message-Id: <20220927005439.21130-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Cc: maz@kernel.org, shuah@kernel.org, kvm@vger.kernel.org,
 catalin.marinas@arm.com, andrew.jones@linux.dev, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org
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

This series is applied on top of Marc's v2 series [0], fixing dirty-ring
ordering issue.

[0] https://lore.kernel.org/kvmarm/20220926145120.27974-1-maz@kernel.org

v3: https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
v2: https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com

Testing
=======
(1) kvm/selftests/dirty_log_test
(2) Live migration by QEMU

Changelog
=========
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
 arch/arm64/kvm/arm.c                         |  3 ++
 arch/x86/include/asm/kvm_host.h              |  2 -
 arch/x86/kvm/x86.c                           | 15 +++---
 include/linux/kvm_dirty_ring.h               | 14 +++---
 include/linux/kvm_host.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c | 53 ++++++++++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c   |  2 +-
 virt/kvm/dirty_ring.c                        | 19 ++++++-
 11 files changed, 79 insertions(+), 34 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

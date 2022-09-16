Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC17C54EE9
	for <kvmarm@archiver.kernel.org>; Fri, 16 Sep 2022 04:51:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 631474BBEB;
	Fri, 16 Sep 2022 00:51:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fgJsXN4-3ZYi; Fri, 16 Sep 2022 00:51:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BF7D4BBED;
	Fri, 16 Sep 2022 00:51:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C79DE4BBEC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 00:51:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id baUAEqURBIQE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2022 00:51:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54BFC4BBD1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 00:51:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663303911;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=ZrlYoSR0t0sSR123GOVAJxEfCWOvnKpItP6M0/Vrog0=;
 b=L8Q8pVkXAXlyhc9bJidMelrqFDxcdqbCODQBFo2Un4S05cguVx6JiT2QLqwKkCdS7BffZn
 bp85BLxcrrOgTzZY2a9G+pYInUj5hkb+4ly6cZD3HkuMbpLfrUR9Nwka8adlMoEawm75vD
 HnWgJeUrhdgY5DC0yjU/OSDsNShaLNM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-HQsuENMbNjO1T32TYAyMaA-1; Fri, 16 Sep 2022 00:51:48 -0400
X-MC-Unique: HQsuENMbNjO1T32TYAyMaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFB52862FDF;
 Fri, 16 Sep 2022 04:51:47 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-126.bne.redhat.com [10.64.54.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2795D140EBF3;
 Fri, 16 Sep 2022 04:51:40 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/5] KVM: arm64: Enable ring-based dirty memory tracking
Date: Fri, 16 Sep 2022 12:51:30 +0800
Message-Id: <20220916045135.154505-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Cc: maz@kernel.org, drjones@redhat.com, shan.gavin@gmail.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 corbet@lwn.net, linux-kernel@vger.kernel.org, zhenyzha@redhat.com,
 will@kernel.org, linux-kselftest@vger.kernel.org, bgardon@google.com,
 dmatlack@google.com, pbonzini@redhat.com, shuah@kernel.org,
 linux-arm-kernel@lists.infradead.org
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

- PATCH[1]   introduces KVM_REQ_RING_SOFT_FULL for x86
- PATCH[2]   enables the feature on ARM64
- PATCH[3-5] improves kvm/selftests/dirty_log_test

v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com

Testing
=======

(1) kvm/selftests/dirty_log_test
(2) Live migration by QEMU

Changelog
=========
v2:
  * Introduce KVM_REQ_RING_SOFT_FULL                         (Marc)
  * Changelog improvement                                    (Marc)
  * Fix dirty_log_test without knowing host page size        (Drew)

Gavin Shan (5):
  KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
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
 arch/x86/kvm/x86.c                           |  5 +-
 include/linux/kvm_host.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c | 53 ++++++++++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c   |  2 +-
 virt/kvm/dirty_ring.c                        |  4 ++
 9 files changed, 59 insertions(+), 18 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

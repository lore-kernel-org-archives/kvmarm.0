Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD165C00140
	for <kvmarm@archiver.kernel.org>; Fri, 19 Aug 2022 00:56:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 457234B5F5;
	Thu, 18 Aug 2022 20:56:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Maj0-V9o6eDP; Thu, 18 Aug 2022 20:56:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7BEC4E3D1;
	Thu, 18 Aug 2022 20:56:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04B834E3CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 20:56:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Hzd8ZJ3uKv5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Aug 2022 20:56:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 540A64E3BD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 20:56:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660870606;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=0mjtjKvaCKjFD+8hWTDMS94mOG+sVGwcb17W8u/FnUA=;
 b=OJewxCy1v8Jz/cUhkSlzoPZf8k7hqb0KPRfKOrPPwnc50VefmSxrXV+WXvcYUSwEIqwZ1H
 CIIZYADXCbsBMRVrifPcabMzIKY2huZzuODnGp+jeN3u5QLBf6VGQF78z+ADrHzVynr2ZZ
 GLjZyzhm/Ippj8PyZsLPtS5vsSX/VYA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317--evnGzXCP_CdJVefZLfQyg-1; Thu, 18 Aug 2022 20:56:42 -0400
X-MC-Unique: -evnGzXCP_CdJVefZLfQyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D370802D2C;
 Fri, 19 Aug 2022 00:56:41 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-16.bne.redhat.com [10.64.54.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 51086C15BB8;
 Fri, 19 Aug 2022 00:56:31 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 0/5] KVM: arm64: Enable ring-based dirty memory tracking
Date: Fri, 19 Aug 2022 08:55:56 +0800
Message-Id: <20220819005601.198436-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 corbet@lwn.net, maz@kernel.org, shan.gavin@gmail.com, drjones@redhat.com,
 will@kernel.org, zhenyzha@redhat.com, dmatlack@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com
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

The generic part has been comprehensive enough, meaning there isn't too
much work, needed to extend it to ARM64. 

- PATCH[1]   enables the feature on ARM64
- PATCH[2-5] improves kvm/selftests/dirty_log_test

Testing
=======

- kvm/selftests/dirty_log_test
- Live migration by QEMU
- Host with 4KB or 64KB base page size

Gavin Shan (5):
  KVM: arm64: Enable ring-based dirty memory tracking
  KVM: selftests: Use host page size to map ring buffer in
    dirty_log_test
  KVM: selftests: Dirty host pages in dirty_log_test
  KVM: selftests: Clear dirty ring states between two modes in
    dirty_log_test
  KVM: selftests: Automate choosing dirty ring size in dirty_log_test

 Documentation/virt/kvm/api.rst               |   2 +-
 arch/arm64/include/uapi/asm/kvm.h            |   1 +
 arch/arm64/kvm/Kconfig                       |   1 +
 arch/arm64/kvm/arm.c                         |   8 ++
 tools/testing/selftests/kvm/dirty_log_test.c | 101 ++++++++++++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c   |   2 +-
 6 files changed, 88 insertions(+), 27 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

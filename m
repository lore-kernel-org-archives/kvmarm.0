Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB81C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:06:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBBDC22CA1
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MC+urFoB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBBDC22CA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 755574B727;
	Tue,  4 Aug 2020 13:06:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a5r1ORHFJ2-v; Tue,  4 Aug 2020 13:06:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 742364B726;
	Tue,  4 Aug 2020 13:06:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28CFB4B136
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:06:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K294uTWHF6ve for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 13:06:13 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3A04B6DB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:06:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596560773;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=ursdoHm0tMH2wXUeTBLWm59Mni6170SDHwjwgqHwT+o=;
 b=MC+urFoBq0N6cn0Aj11wUtBvWczUlcdF9yRpbvJ4pXmiEQ7RuqxvJHnLZiPVa2MX3HiSGG
 mgEpB7Sh2964hoJlzmSLQiHnhxD9sumV3euxlv06tsxuTDwrbv16NQTQGT3UWzz673yFmZ
 3VIQDzsN1d/8NymvGMxlpUHnm3KhWPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-2ZsODA-iONy5CZ-XCCUzcA-1; Tue, 04 Aug 2020 13:06:08 -0400
X-MC-Unique: 2ZsODA-iONy5CZ-XCCUzcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8115B106B242;
 Tue,  4 Aug 2020 17:06:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 896CC72E48;
 Tue,  4 Aug 2020 17:06:05 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/6] KVM: arm64: pvtime: Fixes and a new cap
Date: Tue,  4 Aug 2020 19:05:58 +0200
Message-Id: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: maz@kernel.org, pbonzini@redhat.com, steven.price@arm.com
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

v2:
  - ARM_SMCCC_HV_PV_TIME_FEATURES now also returns SMCCC_RET_NOT_SUPPORTED
    when steal time is not supported
  - Added READ_ONCE() for the run_delay read
  - Reworked kvm_put/get_guest to not require type as a parameter
  - Added some more text to the documentation for KVM_CAP_STEAL_TIME
  - Enough changed that I didn't pick up Steven's r-b's


The first four patches in the series are fixes that come from testing
and reviewing pvtime code while writing the QEMU support[*]. The last
patch is only a convenience for userspace, and I wouldn't be heartbroken
if it wasn't deemed worth it. The QEMU patches are currently written
without the cap. However, if the cap is accepted, then I'll change the
QEMU code to use it.

Thanks,
drew

[*] https://lists.gnu.org/archive/html/qemu-devel/2020-07/msg03856.html
    (a v2 of this series will also be posted shortly)

Andrew Jones (6):
  KVM: arm64: pvtime: steal-time is only supported when configured
  KVM: arm64: pvtime: Fix potential loss of stolen time
  KVM: arm64: Drop type input from kvm_put_guest
  KVM: arm64: pvtime: Fix stolen time accounting across migration
  KVM: Documentation: Minor fixups
  arm64/x86: KVM: Introduce steal-time cap

 Documentation/virt/kvm/api.rst    | 22 ++++++++++++++++++----
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/pvtime.c           | 29 +++++++++++++----------------
 arch/x86/kvm/x86.c                |  3 +++
 include/linux/kvm_host.h          | 31 ++++++++++++++++++++++++++-----
 include/uapi/linux/kvm.h          |  1 +
 7 files changed, 65 insertions(+), 26 deletions(-)

-- 
2.25.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

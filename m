Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB1CC00A89
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 19:03:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C4F222268
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 19:03:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="In1U6I9S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C4F222268
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2069B4B4E5;
	Mon,  2 Nov 2020 14:03:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rkZj+EqZNF2m; Mon,  2 Nov 2020 14:03:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDD604B556;
	Mon,  2 Nov 2020 14:03:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFBA84B494
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 14:03:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4atdEk99jrfh for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 14:03:06 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C06AA4B382
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 14:03:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604343786;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=NQdKNE9/zc9ZzBpRKz0xCeXBkuHXUMTgObFrN15l8CM=;
 b=In1U6I9SCtZ09XVws5lxOxSg19EHrxU8ndAtTsyTIEocJuUT2Lmk1s3YJJITNjC66q287e
 6F5WHPUmkNmS7ijxHjlCFTLNW97Kai0gytJ2CD9e2S2utKJZ4g9jhlo9NpKZO+kjSkjpx8
 o/gQqK3XAUk0ftvs3/7rL7Vc+KQnURA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-pxQbgAu3OQSXlf2ZmlAbMA-1; Mon, 02 Nov 2020 14:03:04 -0500
X-MC-Unique: pxQbgAu3OQSXlf2ZmlAbMA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 812A91099F75;
 Mon,  2 Nov 2020 19:03:03 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
 by smtp.corp.redhat.com (Postfix) with ESMTP id AA50B5B4C4;
 Mon,  2 Nov 2020 19:02:54 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/3] KVM: selftests: Add get-reg-list regression test
Date: Mon,  2 Nov 2020 20:02:50 +0100
Message-Id: <20201102190253.50575-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: pbonzini@redhat.com, Dave.Martin@arm.com, maz@kernel.org
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

This test was inspired by recent regression report about get-reg-list
losing a register between an old kernel version and a new one.

v2:
  - Added "... up to date with kernel version v5.10-rc2" comment
    to the blessed list [Marc]
  - Assert when an invalid command line argument is given rather
    than ignore it [drew]

Thanks,
drew


Andrew Jones (3):
  KVM: selftests: Add aarch64 get-reg-list test
  KVM: selftests: Update aarch64 get-reg-list blessed list
  KVM: selftests: Add blessed SVE registers to get-reg-list

 tools/testing/selftests/kvm/.gitignore        |   2 +
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 +
 .../selftests/kvm/aarch64/get-reg-list.c      | 843 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  29 +
 6 files changed, 880 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list.c

-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

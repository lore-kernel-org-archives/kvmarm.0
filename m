Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C92C2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 13:17:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8856721569
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 13:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NczZE8NO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8856721569
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC09F4B014;
	Tue, 21 Jan 2020 08:17:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qBBwc9xoGS+Y; Tue, 21 Jan 2020 08:17:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44E7D4B015;
	Tue, 21 Jan 2020 08:17:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6842B4B013
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 08:17:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id awy0vJfwX0sm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 08:17:50 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 963B24B000
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 08:17:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579612670;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=+rAyWKaOF4V9iHT89mVBFivCzH/4/gOEkg/nXvfYvIk=;
 b=NczZE8NOAl3OgBFMgR4TLonq4gN5taQlJxvJXbRla0tC27N230D2iqm91trAj4qimswKYk
 DrU/5eMwJqIQxw8OksrbR2NltfaHhDIZCXfmbZS2QNpFVZ5rqH9yHdaQPWbjW6E8aIRPZa
 ww3MmOIN2nBdu/1pu/F9gYh8eRf+KMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-Ckho5A-dPTu5xvpmp4WBxA-1; Tue, 21 Jan 2020 08:17:49 -0500
X-MC-Unique: Ckho5A-dPTu5xvpmp4WBxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1396100550E;
 Tue, 21 Jan 2020 13:17:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A38E410002A2;
 Tue, 21 Jan 2020 13:17:46 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PULL kvm-unit-tests 0/3] arm/arm64: Add prefetch abort test
Date: Tue, 21 Jan 2020 14:17:42 +0100
Message-Id: <20200121131745.7199-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: pbonzini@redhat.com
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

The following changes since commit 3c13c64209599d16c1b04655144af5097aabb857:

  Merge branch 'arm/queue' of https://github.com/rhdrjones/kvm-unit-tests into HEAD (2020-01-08 16:39:22 +0100)

are available in the Git repository at:

  https://github.com/rhdrjones/kvm-unit-tests arm/queue

for you to fetch changes up to cf251b7106d54ef239ad0f34a3dbc9716b9f9ffe:

  arm/arm64: selftest: Add prefetch abort test (2020-01-13 13:31:49 +0100)

Thanks,
drew

----------------------------------------------------------------
Andrew Jones (3):
      arm/arm64: Improve memory region management
      arm/arm64: selftest: Allow test_exception clobber list to be extended
      arm/arm64: selftest: Add prefetch abort test

 arm/selftest.c      | 199 ++++++++++++++++++++++++++++++++++++++--------------
 lib/arm/asm/setup.h |   8 ++-
 lib/arm/mmu.c       |  24 ++-----
 lib/arm/setup.c     |  56 +++++++++++----
 lib/arm64/asm/esr.h |   3 +
 5 files changed, 203 insertions(+), 87 deletions(-)

-- 
2.21.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

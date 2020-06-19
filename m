Return-Path: <SRS0=kKHV=AA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26505C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 18:46:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0030208D5
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 18:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y5NcMrwI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0030208D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E874B183;
	Fri, 19 Jun 2020 14:46:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l3oaB96sU-6E; Fri, 19 Jun 2020 14:46:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6A114B17C;
	Fri, 19 Jun 2020 14:46:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7671C4B15B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 14:46:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T6-iVf6aN74H for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2020 14:46:39 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5D64B09D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 14:46:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1592592399;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=m0FpzCva/zyn/UMs7J4w8ZtycrPgdRAxriFzKZK3P20=;
 b=Y5NcMrwIcXvJ5HnOLdmS0Hy4Mj/ss/lUL6fB8w8UCYi65XGoOV7zq0yFYITsVOOjShAJMl
 wGeexueb3X2ieHx74sxa7yDpBKS8jv4eYfENCc3ci16b+SWD1guA3UJRvpJDaZC6OGz+kv
 UWNBRIj4bSuzo/LQ+UzBQAAcx1L9OVc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-3iUouf49P-q72fQsgHn2hg-1; Fri, 19 Jun 2020 14:46:33 -0400
X-MC-Unique: 3iUouf49P-q72fQsgHn2hg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87D3BEC1A0;
 Fri, 19 Jun 2020 18:46:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.110])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C160F60BF4;
 Fri, 19 Jun 2020 18:46:30 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/4] arm64/x86: KVM: Introduce KVM_CAP_STEAL_TIME
Date: Fri, 19 Jun 2020 20:46:25 +0200
Message-Id: <20200619184629.58653-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: pbonzini@redhat.com, steven.price@arm.com, maz@kernel.org
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

This series introduces a KVM CAP for steal time to arm64 and x86.
For arm64 the cap resolves a couple issues described in the second
patch's commit message. The cap isn't necessary for x86, but is
added for consistency.

Thanks,
drew

Andrew Jones (4):
  KVM: Documentation minor fixups
  arm64/x86: KVM: Introduce steal time cap
  tools headers kvm: Sync linux/kvm.h with the kernel sources
  KVM: selftests: Use KVM_CAP_STEAL_TIME

 Documentation/virt/kvm/api.rst           | 20 ++++++++++++++++----
 arch/arm64/kvm/arm.c                     |  3 +++
 arch/x86/kvm/x86.c                       |  3 +++
 include/uapi/linux/kvm.h                 |  1 +
 tools/include/uapi/linux/kvm.h           | 15 +++++++++++++++
 tools/testing/selftests/kvm/steal_time.c |  8 ++++++++
 6 files changed, 46 insertions(+), 4 deletions(-)

-- 
2.25.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

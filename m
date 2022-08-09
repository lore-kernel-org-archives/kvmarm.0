Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC08C19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 04:06:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 134364C471;
	Tue,  9 Aug 2022 00:06:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Peq7pwD-7e5X; Tue,  9 Aug 2022 00:06:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F6454CFA9;
	Tue,  9 Aug 2022 00:06:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F3A44CF9F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 00:06:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1C5QmSzZdkb0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 00:06:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 457E64C511
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 00:06:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660017975;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=ZjK0GuZ2alM35iqhgJkEaVdZNKEdFOR/rEWuzOn8N5o=;
 b=dD5ogBdxZkzzzou3cIkyOZ5M/sxwQg+EUeaVg3ByktjkC5ePqwtmWnf0W5+Xz6JlQt+DIw
 pwEkasP499K1eBgSsidZiZtXBh1hMJqZM4y6amQ8AkuNHi8UAnvYtwPlcARHfafAPDLRcU
 SjXbdJMg0qVqrZLheC+vw6KNMwSQE6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-HpMhBOelPCOEFVO_l6NS2w-1; Tue, 09 Aug 2022 00:06:11 -0400
X-MC-Unique: HpMhBOelPCOEFVO_l6NS2w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46DF080391B;
 Tue,  9 Aug 2022 04:06:10 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-20.bne.redhat.com [10.64.54.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D19482166B26;
 Tue,  9 Aug 2022 04:06:05 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/2] kvm/selftests: Two rseq_test fixes
Date: Tue,  9 Aug 2022 14:06:25 +0800
Message-Id: <20220809060627.115847-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Cc: fweimer@redhat.com, shan.gavin@gmail.com, kvm@vger.kernel.org,
 maz@kernel.org, linux-kernel@vger.kernel.org, andrew.jones@linux.dev,
 mathieu.desnoyers@efficios.com, yihyu@redhat.com,
 linux-kselftest@vger.kernel.org, pbonzini@redhat.com
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

There are two issues in current rseq_test implementation and the
series intends to fix them:

- From glibc-2.35, rseq information is registered by TLS. It means
  rseq_test is unable to register its own rseq information. PATCH[01]
  fixes the issue by reuse TLS's rseq information if needed.

- sched_getcpu() relies on glibc's implementation and it can simply
  returns the CPU ID cached in the rseq information. In this case,
  it's pointless to compare the return value from sched_getcpu()
  and that fetched from rseq information. PATCH[02] fixes the issue
  by replacing sched_getcpu() with getcpu().

Gavin Shan (2):
  KVM: selftests: Make rseq compatible with glibc-2.35
  KVM: selftests: Use getcpu() instead of sched_getcpu() in rseq_test

 tools/testing/selftests/kvm/rseq_test.c | 62 ++++++++++++++++++-------
 1 file changed, 44 insertions(+), 18 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

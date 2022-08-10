Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347A2C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 10:42:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5F224D7CD;
	Wed, 10 Aug 2022 06:42:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zHeCHkgKlQzZ; Wed, 10 Aug 2022 06:42:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F5354D7CE;
	Wed, 10 Aug 2022 06:42:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF4A64D7CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 06:42:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dbVqL8ypi8oX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 06:41:59 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6B614D7B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 06:41:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660128119;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=9bKhNJI7G6HPFM7ZC8g4f1RPMl031HWjaKYN/Cgan+A=;
 b=ML+f51WisLewEtDCWmEjfOlO0WnX+/45UlwFj0LlpBTxortgMkcmCG3PwS4ZJnsgF12jxD
 4LbCFoenv615SP9tFhFOhjgh+CUVmIxYXVL3ZpTppYCkiOj6sbZM2GusZgxeNc2efcZSdL
 ZMNrMBG96jYjNEdlYKFsZXecHf9+cL4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-vNqntwxVNh6f0s2lJnO8VQ-1; Wed, 10 Aug 2022 06:41:58 -0400
X-MC-Unique: vNqntwxVNh6f0s2lJnO8VQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91AFC2999B2D;
 Wed, 10 Aug 2022 10:41:57 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-77.bne.redhat.com [10.64.54.77])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F1D304050067;
 Wed, 10 Aug 2022 10:41:52 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/2] kvm/selftests: Two rseq_test fixes
Date: Wed, 10 Aug 2022 18:41:12 +0800
Message-Id: <20220810104114.6838-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
  fixes the issue by reusing "../rseq/rseq.c" to fetch TLS's rseq
  information if possible.

- sched_getcpu() relies on glibc's implementation and it can simply
  returns the CPU ID cached in the rseq information. In this case,
  it's pointless to compare the return value from sched_getcpu()
  and that fetched from rseq information. PATCH[02] fixes the issue
  by replacing sched_getcpu() with getcpu().

v1: https://lore.kernel.org/lkml/8c1f33b4-a5a1-fcfa-4521-36253ffa22c8@redhat.com/T/

Changelog
=========
v2:
  * Add "-ldl" to LDLIBS as Florian suggested.
  * Reuse "../rseq/rseq.c" as Paolo/Mathieu/Sean suggested.
  * Add comments to sys_getcpu() as Sean suggested.

Gavin Shan (2):
  KVM: selftests: Make rseq compatible with glibc-2.35
  KVM: selftests: Use getcpu() instead of sched_getcpu() in rseq_test

 tools/testing/selftests/kvm/Makefile    |  5 ++-
 tools/testing/selftests/kvm/rseq_test.c | 60 ++++++++++++-------------
 2 files changed, 33 insertions(+), 32 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

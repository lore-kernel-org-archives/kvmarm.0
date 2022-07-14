Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BBDCCA47B
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 06:07:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 173BE4C54F;
	Thu, 14 Jul 2022 02:07:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h3E-ASbdR5pW; Thu, 14 Jul 2022 02:07:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3C5D4C52F;
	Thu, 14 Jul 2022 02:07:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C87A64C52F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 02:07:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oRXn7I9RC6jl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 02:07:15 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5D854C52E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 02:07:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657778835;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=0Iv/of2lWJhY6Wq6eUx2wF1MOm6COuhI4THcs0fOz4c=;
 b=fPzFMdNmjwuCC96UL0wdRD9AkBLOSBVSRC2qhVYd4DqeonmMWLVERZY6dkWe7BH/F7VX5M
 6LpqHTqTztJRheIPcDrZMdBMSMwxnwVxGzhNaVSN5HlWpUKjQlLpq1sMxo+lT/AfLNF7vl
 TTgm/L08V7AoQHT4DTJjpNyI9yP1PzM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-xg7vNdqMMFWLrvckPTivMg-1; Thu, 14 Jul 2022 02:07:10 -0400
X-MC-Unique: xg7vNdqMMFWLrvckPTivMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B956E802D1C;
 Thu, 14 Jul 2022 06:07:09 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-37.bne.redhat.com [10.64.54.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6237140E80E0;
 Thu, 14 Jul 2022 06:07:05 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: selftests: Double check on the current CPU in rseq_test
Date: Thu, 14 Jul 2022 16:06:42 +0800
Message-Id: <20220714080642.3376618-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, mathieu.desnoyers@efficios.com,
 linux-kselftest@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 shuah@kernel.org
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

In rseq_test, there are two threads created. Those two threads are
'main' and 'migration_thread' separately. We also have the assumption
that non-migration status on 'migration-worker' thread guarantees the
same non-migration status on 'main' thread. Unfortunately, the assumption
isn't true. The 'main' thread can be migrated from one CPU to another
one between the calls to sched_getcpu() and READ_ONCE(__rseq.cpu_id).
The following assert is raised eventually because of the mismatched
CPU numbers.

The issue can be reproduced on arm64 system occasionally.

  host# uname -r
  5.19.0-rc6-gavin+
  host# # cat /proc/cpuinfo | grep processor | tail -n 1
  processor    : 223
  host# pwd
  /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
  host# for i in `seq 1 100`;   \
        do echo "--------> $i"; \
        ./rseq_test; sleep 3;   \
        done
  --------> 1
  --------> 2
  --------> 3
  --------> 4
  --------> 5
  --------> 6
  ==== Test Assertion Failure ====
    rseq_test.c:265: rseq_cpu == cpu
    pid=3925 tid=3925 errno=4 - Interrupted system call
       1  0x0000000000401963: main at rseq_test.c:265 (discriminator 2)
       2  0x0000ffffb044affb: ?? ??:0
       3  0x0000ffffb044b0c7: ?? ??:0
       4  0x0000000000401a6f: _start at ??:?
    rseq CPU = 4, sched CPU = 27

This fixes the issue by double-checking on the current CPU after
call to READ_ONCE(__rseq.cpu_id) and restarting the test if the
two consecutive CPU numbers aren't euqal.

Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 4158da0da2bb..74709dd9f5b2 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -207,7 +207,7 @@ int main(int argc, char *argv[])
 {
 	int r, i, snapshot;
 	struct kvm_vm *vm;
-	u32 cpu, rseq_cpu;
+	u32 cpu, rseq_cpu, last_cpu;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
@@ -259,8 +259,9 @@ int main(int argc, char *argv[])
 			smp_rmb();
 			cpu = sched_getcpu();
 			rseq_cpu = READ_ONCE(__rseq.cpu_id);
+			last_cpu = sched_getcpu();
 			smp_rmb();
-		} while (snapshot != atomic_read(&seq_cnt));
+		} while (snapshot != atomic_read(&seq_cnt) || cpu != last_cpu);
 
 		TEST_ASSERT(rseq_cpu == cpu,
 			    "rseq CPU = %d, sched CPU = %d\n", rseq_cpu, cpu);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

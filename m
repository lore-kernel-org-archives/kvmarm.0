Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6E3C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 10:42:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 284E14D7D7;
	Wed, 10 Aug 2022 06:42:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eBnEEJ8GONOf; Wed, 10 Aug 2022 06:42:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D54744D7D0;
	Wed, 10 Aug 2022 06:42:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECB0F4D7D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 06:42:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YwPnXmtI1x+k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 06:42:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E36D4D7CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 06:42:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660128132;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=TwW6M6u5vKyxDnMqx9AQR/gg33wHCbXk3i4GrhHVUrQ=;
 b=Zf+wWVrDpedaYYZ2XLvLeteoW/784Vvxlzg1HXTBkZyGfWWUQowmnKrfavWYlIZxG/l4FT
 GbgbN8l/gq/Gb6LAOGZ7jNd3VbcjdntGSqv9+k34NC4sHRWjHaUnD7c9GSxWmZp5kDbs45
 ltNJSbF4TYTRbmtju1EEyrBK/n3LD4o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-gw23tJ4HN0-JU_uY1ipUDA-1; Wed, 10 Aug 2022 06:42:08 -0400
X-MC-Unique: gw23tJ4HN0-JU_uY1ipUDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23A693C2288C;
 Wed, 10 Aug 2022 10:42:08 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-77.bne.redhat.com [10.64.54.77])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 666C64050067;
 Wed, 10 Aug 2022 10:42:03 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/2] KVM: selftests: Use getcpu() instead of sched_getcpu()
 in rseq_test
Date: Wed, 10 Aug 2022 18:41:14 +0800
Message-Id: <20220810104114.6838-3-gshan@redhat.com>
In-Reply-To: <20220810104114.6838-1-gshan@redhat.com>
References: <20220810104114.6838-1-gshan@redhat.com>
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

sched_getcpu() is glibc dependent and it can simply return the CPU
ID from the registered rseq information, as Florian Weimer pointed.
In this case, it's pointless to compare the return value from
sched_getcpu() and that fetched from the registered rseq information.

Fix the issue by replacing sched_getcpu() with getcpu(), as Florian
suggested. The comments are modified accordingly by replacing
"sched_getcpu()" with "getcpu()".

Reported-by: Yihuang Yu <yihyu@redhat.com>
Suggested-by: Florian Weimer <fweimer@redhat.com>
Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 42 ++++++++++++++++---------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 2cd5fe49ac8b..84e8425edc2c 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -42,6 +42,18 @@ static void guest_code(void)
 		GUEST_SYNC(0);
 }
 
+/*
+ * We have to perform direct system call for getcpu() because it's
+ * not available until glic 2.29.
+ */
+static void sys_getcpu(unsigned *cpu)
+{
+	int r;
+
+	r = syscall(__NR_getcpu, cpu, NULL, NULL);
+	TEST_ASSERT(!r, "getcpu failed, errno = %d (%s)", errno, strerror(errno));
+}
+
 static int next_cpu(int cpu)
 {
 	/*
@@ -86,7 +98,7 @@ static void *migration_worker(void *__rseq_tid)
 		atomic_inc(&seq_cnt);
 
 		/*
-		 * Ensure the odd count is visible while sched_getcpu() isn't
+		 * Ensure the odd count is visible while getcpu() isn't
 		 * stable, i.e. while changing affinity is in-progress.
 		 */
 		smp_wmb();
@@ -127,10 +139,10 @@ static void *migration_worker(void *__rseq_tid)
 		 *     check completes.
 		 *
 		 *  3. To ensure the read-side makes efficient forward progress,
-		 *     e.g. if sched_getcpu() involves a syscall.  Stalling the
-		 *     read-side means the test will spend more time waiting for
-		 *     sched_getcpu() to stabilize and less time trying to hit
-		 *     the timing-dependent bug.
+		 *     e.g. if getcpu() involves a syscall. Stalling the read-side
+		 *     means the test will spend more time waiting for getcpu()
+		 *     to stabilize and less time trying to hit the timing-dependent
+		 *     bug.
 		 *
 		 * Because any bug in this area is likely to be timing-dependent,
 		 * run with a range of delays at 1us intervals from 1us to 10us
@@ -226,9 +238,9 @@ int main(int argc, char *argv[])
 
 		/*
 		 * Verify rseq's CPU matches sched's CPU.  Ensure migration
-		 * doesn't occur between sched_getcpu() and reading the rseq
-		 * cpu_id by rereading both if the sequence count changes, or
-		 * if the count is odd (migration in-progress).
+		 * doesn't occur between getcpu() and reading the rseq cpu_id
+		 * by rereading both if the sequence count changes, or if the
+		 * count is odd (migration in-progress).
 		 */
 		do {
 			/*
@@ -238,12 +250,12 @@ int main(int argc, char *argv[])
 			snapshot = atomic_read(&seq_cnt) & ~1;
 
 			/*
-			 * Ensure reading sched_getcpu() and rseq.cpu_id
-			 * complete in a single "no migration" window, i.e. are
-			 * not reordered across the seq_cnt reads.
+			 * Ensure reading getcpu() and rseq.cpu_id complete in
+			 * a single "no migration" window, i.e. are not reordered
+			 * across the seq_cnt reads.
 			 */
 			smp_rmb();
-			cpu = sched_getcpu();
+			sys_getcpu(&cpu);
 			rseq_cpu = READ_ONCE(__rseq->cpu_id);
 			smp_rmb();
 		} while (snapshot != atomic_read(&seq_cnt));
@@ -255,9 +267,9 @@ int main(int argc, char *argv[])
 	/*
 	 * Sanity check that the test was able to enter the guest a reasonable
 	 * number of times, e.g. didn't get stalled too often/long waiting for
-	 * sched_getcpu() to stabilize.  A 2:1 migration:KVM_RUN ratio is a
-	 * fairly conservative ratio on x86-64, which can do _more_ KVM_RUNs
-	 * than migrations given the 1us+ delay in the migration task.
+	 * getcpu() to stabilize.  A 2:1 migration:KVM_RUN ratio is a fairly
+	 * conservative ratio on x86-64, which can do _more_ KVM_RUNs than
+	 * migrations given the 1us+ delay in the migration task.
 	 */
 	TEST_ASSERT(i > (NR_TASK_MIGRATIONS / 2),
 		    "Only performed %d KVM_RUNs, task stalled too much?\n", i);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

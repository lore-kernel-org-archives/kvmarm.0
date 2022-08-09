Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2CDC25B08
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 04:06:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 548554CBF1;
	Tue,  9 Aug 2022 00:06:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kEWeWMa0UpCo; Tue,  9 Aug 2022 00:06:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 984DB4CFA9;
	Tue,  9 Aug 2022 00:06:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5C14CBF1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 00:06:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EBnb0wnH55wD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 00:06:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 663074C457
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 00:06:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660017985;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GpMqE31lls01IVsW/AFKiHmLzH6RkUJAa9i/teIiT1c=;
 b=BqZP3567C01JSpTFhWGoL6H0itSST4FSU2yXkY0Um/B3KCEqpLHEa+Bv4DThJp99CKytXH
 bA6u7mDM21RSsUOCs/7NGdbPj7I+7xdRJkruo1WGTfhmFcFg3rq6K5he3Gi1hFP7PB96PA
 V5oGAaIWgPPqE7mLC0rtcnJN5OKp3CU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-ahVzwH5mPJ6nYZb0VLyzfg-1; Tue, 09 Aug 2022 00:06:21 -0400
X-MC-Unique: ahVzwH5mPJ6nYZb0VLyzfg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF4D8804191;
 Tue,  9 Aug 2022 04:06:20 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-20.bne.redhat.com [10.64.54.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 26FE72166B26;
 Tue,  9 Aug 2022 04:06:15 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/2] KVM: selftests: Use getcpu() instead of sched_getcpu() in
 rseq_test
Date: Tue,  9 Aug 2022 14:06:27 +0800
Message-Id: <20220809060627.115847-3-gshan@redhat.com>
In-Reply-To: <20220809060627.115847-1-gshan@redhat.com>
References: <20220809060627.115847-1-gshan@redhat.com>
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

sched_getcpu() is glibc dependent and it can simply return the CPU
ID from the registered rseq information, as Florian Weimer pointed.
In this case, it's pointless to compare the return value from
sched_getcpu() and that fetched from the registered rseq information.

Fix the issue by replacing sched_getcpu() with getcpu(), as Florian
suggested. The comments are modified accordingly.

Reported-by: Yihuang Yu <yihyu@redhat.com>
Suggested-by: Florian Weimer <fweimer@redhat.com>
Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 32 ++++++++++++-------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index acb1bf1f06b3..621b9b15049b 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -126,7 +126,7 @@ static void *migration_worker(void *__rseq_tid)
 		atomic_inc(&seq_cnt);
 
 		/*
-		 * Ensure the odd count is visible while sched_getcpu() isn't
+		 * Ensure the odd count is visible while getcpu() isn't
 		 * stable, i.e. while changing affinity is in-progress.
 		 */
 		smp_wmb();
@@ -167,10 +167,10 @@ static void *migration_worker(void *__rseq_tid)
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
@@ -264,9 +264,9 @@ int main(int argc, char *argv[])
 
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
@@ -276,15 +276,15 @@ int main(int argc, char *argv[])
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
+			r = getcpu(&cpu, NULL);
 			rseq_cpu = READ_ONCE(__rseq_info->cpu_id);
 			smp_rmb();
-		} while (snapshot != atomic_read(&seq_cnt));
+		} while (r || snapshot != atomic_read(&seq_cnt));
 
 		TEST_ASSERT(rseq_cpu == cpu,
 			    "rseq CPU = %d, sched CPU = %d\n", rseq_cpu, cpu);
@@ -293,9 +293,9 @@ int main(int argc, char *argv[])
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

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055AFCCA479
	for <kvmarm@archiver.kernel.org>; Sat, 16 Jul 2022 12:46:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A1154CA5E;
	Sat, 16 Jul 2022 08:46:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1xBVmnge3ksm; Sat, 16 Jul 2022 08:46:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18EFA4CA64;
	Sat, 16 Jul 2022 08:46:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C28CF4CA5E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jul 2022 08:46:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yefrlQaa5pxa for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Jul 2022 08:46:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68D3B4CA56
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jul 2022 08:46:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657975579;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=6jdgBr8qPyYQ7wIItqpQ8nbtb9ewBI0uvepqAzRBm0w=;
 b=HZ11Zh3/P8G4GmBMQcmmnYm/5p8pB1LWzGboophv+iLyJYbrn9b7eTwXuitiyVc4Ib7JKC
 6efK0+bPHLYYTRyPa2x52RWM4a4++sUNIXjJ0bBJ3XY/hQOb40S50JRpmoukP3JVbUUnpB
 sHwohDoVY7z20pS3e4sn1IorPnIIAJQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-jVl0NklINweQDDm3TzrjdQ-1; Sat, 16 Jul 2022 08:46:15 -0400
X-MC-Unique: jVl0NklINweQDDm3TzrjdQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4A358037B7;
 Sat, 16 Jul 2022 12:46:14 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-37.bne.redhat.com [10.64.54.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ED01E492C3B;
 Sat, 16 Jul 2022 12:46:10 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2] KVM: selftests: Fix target thread to be migrated in
 rseq_test
Date: Sat, 16 Jul 2022 22:45:37 +0800
Message-Id: <20220716144537.3436743-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, linux-kselftest@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, shuah@kernel.org
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

In rseq_test, there are two threads, which are thread group leader
and migration worker. The migration worker relies on sched_setaffinity()
to force migration on the thread group leader. Unfortunately, we
have wrong parameter (0) passed to sched_getaffinity(). It's actually
forcing migration on the migration worker instead of the thread group
leader. It also means migration can happen on the thread group leader
at any time, which eventually leads to failure as the following logs
show.

  host# uname -r
  5.19.0-rc6-gavin+
  host# # cat /proc/cpuinfo | grep processor | tail -n 1
  processor    : 223
  host# pwd
  /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
  host# for i in `seq 1 100`;                \
        do echo "--------> $i"; ./rseq_test; done
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

This fixes the issue by passing correct parameter, tid of the group
thread leader, to sched_setaffinity().

Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 4158da0da2bb..c83ac7b467f8 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -38,6 +38,7 @@ static __thread volatile struct rseq __rseq = {
  */
 #define NR_TASK_MIGRATIONS 100000
 
+static pid_t rseq_tid;
 static pthread_t migration_thread;
 static cpu_set_t possible_mask;
 static int min_cpu, max_cpu;
@@ -106,7 +107,8 @@ static void *migration_worker(void *ign)
 		 * stable, i.e. while changing affinity is in-progress.
 		 */
 		smp_wmb();
-		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
+		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask),
+				      &allowed_mask);
 		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
 			    errno, strerror(errno));
 		smp_wmb();
@@ -231,6 +233,7 @@ int main(int argc, char *argv[])
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
 
+	rseq_tid = gettid();
 	pthread_create(&migration_thread, NULL, migration_worker, 0);
 
 	for (i = 0; !done; i++) {
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

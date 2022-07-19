Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA0DC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 00:09:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D8894CAEE;
	Mon, 18 Jul 2022 20:09:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8A-ZcW3qF+gH; Mon, 18 Jul 2022 20:09:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98FBD4CAF6;
	Mon, 18 Jul 2022 20:09:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87AE84CAF2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 20:09:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BJrT9CTaDkTG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 20:09:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14AC74CAFD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 20:09:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1658189349;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=NEVx0pB2HnnThMov1umNo2N7MZ+/Y6MEAU+qrFJg/CQ=;
 b=X6VBX/3+3GzP8iqzHyJidvwtPSPc7HVwoK0kl5zR9lXdbEgo3FNwZ2W+1ydT7gLzCs1nb7
 JibTfDqiFoHVCcmIpn6amBoSXbQwqhtAXsigZ0INpJXBpHPG0GvDnG97G4Sm/bXr8jCGsm
 Dvsj4hxwYLLZO3FHmJOybIv5wK40WAE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-GID_6yVGPdS7z3RsC3m02w-1; Mon, 18 Jul 2022 20:08:59 -0400
X-MC-Unique: GID_6yVGPdS7z3RsC3m02w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A989811E7A;
 Tue, 19 Jul 2022 00:08:59 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-37.bne.redhat.com [10.64.54.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F0E111121314;
 Tue, 19 Jul 2022 00:08:55 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4] KVM: selftests: Fix target thread to be migrated in
 rseq_test
Date: Tue, 19 Jul 2022 10:08:30 +0800
Message-Id: <20220719020830.3479482-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Cc: shan.gavin@gmail.com, maz@kernel.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
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

In rseq_test, there are two threads, which are vCPU thread and migration
worker separately. Unfortunately, the test has the wrong PID passed to
sched_setaffinity() in the migration worker. It forces migration on the
migration worker because zeroed PID represents the calling thread, which
is the migration worker itself. It means the vCPU thread is never enforced
to migration and it can migrate at any time, which eventually leads to
failure as the following logs show.

  host# uname -r
  5.19.0-rc6-gavin+
  host# # cat /proc/cpuinfo | grep processor | tail -n 1
  processor    : 223
  host# pwd
  /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
  host# for i in `seq 1 100`; do \
        echo "--------> $i"; ./rseq_test; done
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

Fix the issue by passing correct parameter, TID of the vCPU thread, to
sched_setaffinity() in the migration worker.

Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
v4: Pick the code change as Sean suggested.
---
 tools/testing/selftests/kvm/rseq_test.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 4158da0da2bb..2237d1aac801 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -82,8 +82,9 @@ static int next_cpu(int cpu)
 	return cpu;
 }
 
-static void *migration_worker(void *ign)
+static void *migration_worker(void *__rseq_tid)
 {
+	pid_t rseq_tid = (pid_t)(unsigned long)__rseq_tid;
 	cpu_set_t allowed_mask;
 	int r, i, cpu;
 
@@ -106,7 +107,7 @@ static void *migration_worker(void *ign)
 		 * stable, i.e. while changing affinity is in-progress.
 		 */
 		smp_wmb();
-		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
+		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask), &allowed_mask);
 		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
 			    errno, strerror(errno));
 		smp_wmb();
@@ -231,7 +232,8 @@ int main(int argc, char *argv[])
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
 
-	pthread_create(&migration_thread, NULL, migration_worker, 0);
+	pthread_create(&migration_thread, NULL, migration_worker,
+		       (void *)(unsigned long)gettid());
 
 	for (i = 0; !done; i++) {
 		vcpu_run(vm, VCPU_ID);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

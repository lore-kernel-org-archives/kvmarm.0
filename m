Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB7AC25B0C
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 04:06:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D058E4C511;
	Tue,  9 Aug 2022 00:06:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tdliDOCfxLWg; Tue,  9 Aug 2022 00:06:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B934CFA9;
	Tue,  9 Aug 2022 00:06:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3395B4CFAD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 00:06:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RNt7s7FS-Imm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 00:06:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED9ED4CFB5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 00:06:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660017981;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=v7Wypa4oOYW4jZXZehboAwCarfEU3fnRZX5wpPKbgRs=;
 b=gYWTgZEYOxiKibDkc8/8xSYoOgEP0xt4QhWWU29TeeJmjZ9ZuO6ZvZH+FuixBhk0Grro3p
 C/Zd6hDRJWEc++Jc1H5z0nClxJBS7Hzxpzwo+vW4CuACY07d1CHsHgdDPvAdHtksPaf05z
 VsCx8JOmCbm5xYzF6tRA+QNJCFpZkGc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-JGUT5zIuPAWUE7gJa_yylg-1; Tue, 09 Aug 2022 00:06:16 -0400
X-MC-Unique: JGUT5zIuPAWUE7gJa_yylg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 892AF85A58A;
 Tue,  9 Aug 2022 04:06:15 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-20.bne.redhat.com [10.64.54.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4B932166B26;
 Tue,  9 Aug 2022 04:06:10 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
Date: Tue,  9 Aug 2022 14:06:26 +0800
Message-Id: <20220809060627.115847-2-gshan@redhat.com>
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

The rseq information is registered by TLS, starting from glibc-2.35.
In this case, the test always fails due to syscall(__NR_rseq). For
example, on RHEL9.1 where upstream glibc-2.35 features are enabled
on downstream glibc-2.34, the test fails like below.

  # ./rseq_test
  ==== Test Assertion Failure ====
    rseq_test.c:60: !r
    pid=112043 tid=112043 errno=22 - Invalid argument
       1	0x0000000000401973: main at rseq_test.c:226
       2	0x0000ffff84b6c79b: ?? ??:0
       3	0x0000ffff84b6c86b: ?? ??:0
       4	0x0000000000401b6f: _start at ??:?
    rseq failed, errno = 22 (Invalid argument)
  # rpm -aq | grep glibc-2
  glibc-2.34-39.el9.aarch64

Fix the issue by using the registered rseq information from TLS
if it exists. Otherwise, we're going to register our own rseq
information as before.

Reported-by: Yihuang Yu <yihyu@redhat.com>
Suggested-by: Florian Weimer <fweimer@redhat.com>
Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 30 +++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index a54d4d05a058..acb1bf1f06b3 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <signal.h>
 #include <syscall.h>
+#include <dlfcn.h>
 #include <sys/ioctl.h>
 #include <sys/sysinfo.h>
 #include <asm/barrier.h>
@@ -36,6 +37,8 @@ static __thread volatile struct rseq __rseq = {
  */
 #define NR_TASK_MIGRATIONS 100000
 
+static bool __rseq_ownership;
+static volatile struct rseq *__rseq_info;
 static pthread_t migration_thread;
 static cpu_set_t possible_mask;
 static int min_cpu, max_cpu;
@@ -49,11 +52,33 @@ static void guest_code(void)
 		GUEST_SYNC(0);
 }
 
+static void sys_rseq_ownership(void)
+{
+	long *offset;
+	unsigned int *size, *flags;
+
+	offset = dlsym(RTLD_NEXT, "__rseq_offset");
+	size = dlsym(RTLD_NEXT, "__rseq_size");
+	flags = dlsym(RTLD_NEXT, "__rseq_flags");
+
+	if (offset && size && *size && flags) {
+		__rseq_ownership = false;
+		__rseq_info = (struct rseq *)((uintptr_t)__builtin_thread_pointer() +
+					      *offset);
+	} else {
+		__rseq_ownership = true;
+		__rseq_info = &__rseq;
+	}
+}
+
 static void sys_rseq(int flags)
 {
 	int r;
 
-	r = syscall(__NR_rseq, &__rseq, sizeof(__rseq), flags, RSEQ_SIG);
+	if (!__rseq_ownership)
+		return;
+
+	r = syscall(__NR_rseq, __rseq_info, sizeof(*__rseq_info), flags, RSEQ_SIG);
 	TEST_ASSERT(!r, "rseq failed, errno = %d (%s)", errno, strerror(errno));
 }
 
@@ -218,6 +243,7 @@ int main(int argc, char *argv[])
 
 	calc_min_max_cpu();
 
+	sys_rseq_ownership();
 	sys_rseq(0);
 
 	/*
@@ -256,7 +282,7 @@ int main(int argc, char *argv[])
 			 */
 			smp_rmb();
 			cpu = sched_getcpu();
-			rseq_cpu = READ_ONCE(__rseq.cpu_id);
+			rseq_cpu = READ_ONCE(__rseq_info->cpu_id);
 			smp_rmb();
 		} while (snapshot != atomic_read(&seq_cnt));
 
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

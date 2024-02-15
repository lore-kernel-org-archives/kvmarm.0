Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F6F1474CA
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041266; cv=none; b=JanYuyQnOulX3jtIJZTZuL2noWbPhAobe4BrFddato0WMkmTOXwm+Cn8HcsKvq7seY/0vGImgdx1rc9LzCLdQ6hZb33ehzzUflEDucf5Tvap2RZQu7K5AadTz7ql+UCZ4OaQ9GewysuOjOlbbFvm2ZW5ZxhMeNVN8WAyoEgeADk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041266; c=relaxed/simple;
	bh=a7eKLWtaoxoL7cVfHGdohyj2AF5ZACc8LDLsIrxBv08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k2CeMtQkk5vaB2sWP4NrkD02rEX+p3HBtbK/1PHOFducHqtQQAZL/TrYogtVybf4CEP2nK+XxXia+6OCTblpakMcYxfM/T1sri54HK6vfiDQT5rxBZvyCrn57He63z800BN/twn8jhiCC3di/dzXYghzPwurRWPbZJ2Lhy1EQdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=doZIiuAY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="doZIiuAY"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so282092276.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041264; x=1708646064; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp/0bdTdp/wTZtC8stanHESpr8tHISyMMSdV5bn6+Y0=;
        b=doZIiuAYn3ufL93WjeGXG/UI0DmuLhd2NhNzFPVhbzBUqO5vcYB2zxOE3k7QyMqZrp
         SCQWB5FTzhicmy5lL+/H5+mfoZ5nkje4XG8q4jRrmvPYz9qdlQZLoXmii0ic+3NAXqgl
         OZa8l7gU+GCApDDWEztSycJVj5g6rvSq7fm+etJdT/ZL68m0HyT0Rl5uhxtZsgRynPZu
         Wco0TNqjx38btnWpcy1GfMu3uRF7GppqURuLoLBUNYh/RhIjRAD0FedZH0nBKiY5YeTm
         0kgF1n6QEUOK+yVhwLJyaKDEUAu+jc2zBsD+pOXS4U/XSrTS6J/CGndj3jUI2aZqPjnI
         Mzfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041264; x=1708646064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp/0bdTdp/wTZtC8stanHESpr8tHISyMMSdV5bn6+Y0=;
        b=NHIkUtEFD5EyR5lq2qAxK+3dKa6vvHT/T0KW05Z99KuasygaJJCnqEzV3EC5CJMYzJ
         2bZZzovOWYdrBYWGDgeyFyk2cEffdVJ2wMRVNVNcHxEna/UcrlO+14xQXSQkjpatEyJu
         341C8smK0PEEBjo3roBVIlGtbl9YADzktadGkKaey/usitQMi/AcqQUWLgWYV++pRQY9
         Nqqq10UblHacVW+wAKQKuuxJFC/hMD2f5y+fL3dc9bMyLq7lTPWkjiCV1HooAsNTiVfF
         +oUEt4ibmbJ2GFMTCyUwIq5SWU/HyU28qo+dPFMSWgyzb53FWpOgGGZC90iedVSk2VOg
         maMA==
X-Forwarded-Encrypted: i=1; AJvYcCUhtxFy8b8Zcetkc4AHZZIPvyHugGZJJLPfyGvj/Th2GqVWWYQObnYUsy3NhtCHICFfNOpKqNAFioGf58y312wnVRDduo+M
X-Gm-Message-State: AOJu0YwUKCe6GptjUod7pLROsysjT9LDfLXUc/Bn4r7p1yPj1Yhuo1Sy
	5NVXpFX1pf2R4fRYuh5yAgIBxC1jRUOMC0LAMlQ/K9XGst+XmXTbY6G0wawsiWkztr4qF66+TDl
	PSsLHpbVuow==
X-Google-Smtp-Source: AGHT+IGo9PYNpFMRSL7MDuuM071FwDbG6033GhiZwLkGjhQJG67+BYPtQK3FZHpNcH0hyJDMDR4MZgbnf0Bqqw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a5b:ca:0:b0:dc6:b813:5813 with SMTP id
 d10-20020a5b00ca000000b00dc6b8135813mr123862ybp.9.1708041263965; Thu, 15 Feb
 2024 15:54:23 -0800 (PST)
Date: Thu, 15 Feb 2024 23:54:03 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-13-amoorthy@google.com>
Subject: [PATCH v7 12/14] KVM: selftests: Use EPOLL in userfaultfd_util reader
 threads and signal errors via TEST_ASSERT
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

With multiple reader threads POLLing a single UFFD, the test suffers
from the thundering herd problem: performance degrades as the number of
reader threads is increased. Solve this issue [1] by switching the
the polling mechanism to EPOLL + EPOLLEXCLUSIVE.

Also, change the error-handling convention of uffd_handler_thread_fn.
Instead of just printing errors and returning early from the polling
loop, check for them via TEST_ASSERT. "return NULL" is reserved for a
successful exit from uffd_handler_thread_fn, ie one triggered by a
write to the exit pipe.

Performance samples generated by the command in [2] are given below.

Num Reader Threads, Paging Rate (POLL), Paging Rate (EPOLL)
1      249k      185k
2      201k      235k
4      186k      155k
16     150k      217k
32     89k       198k

[1] Single-vCPU performance does suffer somewhat.
[2] ./demand_paging_test -u MINOR -s shmem -v 4 -o -r <num readers>

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        |  1 -
 .../selftests/kvm/lib/userfaultfd_util.c      | 74 +++++++++----------
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index f7897a951f90..0455347f932a 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -13,7 +13,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
-#include <poll.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
 #include <sys/syscall.h>
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 6f220aa4fb08..2a179133645a 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -16,6 +16,7 @@
 #include <poll.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
+#include <sys/epoll.h>
 #include <sys/syscall.h>
 
 #include "kvm_util.h"
@@ -32,60 +33,55 @@ static void *uffd_handler_thread_fn(void *arg)
 	int64_t pages = 0;
 	struct timespec start;
 	struct timespec ts_diff;
+	int epollfd;
+	struct epoll_event evt;
+
+	epollfd = epoll_create(1);
+	TEST_ASSERT(epollfd >= 0, "Failed to create epollfd.");
+
+	evt.events = EPOLLIN | EPOLLEXCLUSIVE;
+	evt.data.u32 = 0;
+	TEST_ASSERT(epoll_ctl(epollfd, EPOLL_CTL_ADD, uffd, &evt) == 0,
+		    "Failed to add uffd to epollfd");
+
+	evt.events = EPOLLIN;
+	evt.data.u32 = 1;
+	TEST_ASSERT(epoll_ctl(epollfd, EPOLL_CTL_ADD, reader_args->pipe, &evt) == 0,
+		    "Failed to add pipe to epollfd");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	while (1) {
 		struct uffd_msg msg;
-		struct pollfd pollfd[2];
-		char tmp_chr;
 		int r;
 
-		pollfd[0].fd = uffd;
-		pollfd[0].events = POLLIN;
-		pollfd[1].fd = reader_args->pipe;
-		pollfd[1].events = POLLIN;
-
-		r = poll(pollfd, 2, -1);
-		switch (r) {
-		case -1:
-			pr_info("poll err");
-			continue;
-		case 0:
-			continue;
-		case 1:
-			break;
-		default:
-			pr_info("Polling uffd returned %d", r);
-			return NULL;
-		}
+		r = epoll_wait(epollfd, &evt, 1, -1);
+		TEST_ASSERT(r == 1,
+			    "Unexpected number of events (%d) from epoll, errno = %d",
+			    r, errno);
 
-		if (pollfd[0].revents & POLLERR) {
-			pr_info("uffd revents has POLLERR");
-			return NULL;
-		}
+		if (evt.data.u32 == 1) {
+			char tmp_chr;
 
-		if (pollfd[1].revents & POLLIN) {
-			r = read(pollfd[1].fd, &tmp_chr, 1);
+			TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
+				    "Reader thread received EPOLLERR or EPOLLHUP on pipe.");
+			r = read(reader_args->pipe, &tmp_chr, 1);
 			TEST_ASSERT(r == 1,
-				    "Error reading pipefd in UFFD thread\n");
+				    "Error reading pipefd in uffd reader thread");
 			break;
 		}
 
-		if (!(pollfd[0].revents & POLLIN))
-			continue;
+		TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
+			    "Reader thread received EPOLLERR or EPOLLHUP on uffd.");
 
 		r = read(uffd, &msg, sizeof(msg));
 		if (r == -1) {
-			if (errno == EAGAIN)
-				continue;
-			pr_info("Read of uffd got errno %d\n", errno);
-			return NULL;
+			TEST_ASSERT(errno == EAGAIN,
+				    "Error reading from UFFD: errno = %d", errno);
+			continue;
 		}
 
-		if (r != sizeof(msg)) {
-			pr_info("Read on uffd returned unexpected size: %d bytes", r);
-			return NULL;
-		}
+		TEST_ASSERT(r == sizeof(msg),
+			    "Read on uffd returned unexpected number of bytes (%d)", r);
 
 		if (!(msg.event & UFFD_EVENT_PAGEFAULT))
 			continue;
@@ -93,8 +89,8 @@ static void *uffd_handler_thread_fn(void *arg)
 		if (reader_args->delay)
 			usleep(reader_args->delay);
 		r = reader_args->handler(reader_args->uffd_mode, uffd, &msg);
-		if (r < 0)
-			return NULL;
+		TEST_ASSERT(r >= 0,
+			    "Reader thread handler fn returned negative value %d", r);
 		pages++;
 	}
 
-- 
2.44.0.rc0.258.g7320e95886-goog


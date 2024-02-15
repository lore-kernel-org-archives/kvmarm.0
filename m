Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC441474A6
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041265; cv=none; b=IcgBmYByhQW5gHRJrNjk3mkqw++0+rrr7vJjZ0NrMAzsqEILX8XoqnuRXP3/8Zu/TBVcxG6IsP6valNMHB6e7XY3CxXcmXDweM+fM6DVDczxYMl0+ogmSL8MSYihKWPp6q5ZBShMw6H4q/0PBp6nFZM6GRPVHKlK5FzGQcFr1fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041265; c=relaxed/simple;
	bh=LU+P22WMx8+l0j28eDp7TZSAb4K8ddezaIfE2HB5OjY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r6kZk7uWii4hTt8CAVF2GC09dBi2uDXgP3RypOKJPpgDMSIhq+U456p8tO4J4X4zBbtKeXoEAJf7uft9+B2PRUV2RzUsK0GDrNsRLdtTMT3MiiKgzSc8IK2Ck/y14lEI+U579pTEuQXhGhwfBvkAKW78D1DGo4hCQ7bcLs3ER6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xfi3g6I+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xfi3g6I+"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607c9677a91so27162967b3.2
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041262; x=1708646062; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wxgMpdjPiqAl5L5CrBln707OMjyjZ2YsrvRZmT9MQFg=;
        b=Xfi3g6I+knyKIA7x2PvZStbh1ObnBzO2pG1czKemJKnG9dUtVVKhL6GYA870ZRXmPX
         KcDTybskny65BJcTs39Gp06gukQ9VbJ3dqgIEnLTBnGEMINDKd5oA6V85wUTWMoljecl
         o1ngSi3h+SmLvsJmbL7FNyEf1M0TjVt8h/B1eYHjfHinyge1m+00zh9EZ9n31MRt5MS0
         /iGE0he3zKd9/oJSZ7sc5xWgoBZX95+kiBsK5IbOkSosA+ZuiZJPW4ZUzhZLJtcpLn/I
         qZuJESEMBP6P1l7C8Eey0PEsQTNzaI/6BzlEG2LIytbztghVoJJianF86iRCgxlFwg/5
         7vQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041262; x=1708646062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wxgMpdjPiqAl5L5CrBln707OMjyjZ2YsrvRZmT9MQFg=;
        b=TJTjoE4KtYr5QMcNb3OuyfU3AOAbjje8XdpO6g/U01JY+qZBO0YxldXFXz0hGy6OmN
         mxR4aFvyfk5usKto8xQD0H825aIbzNPNaehfFDSs0A9EQMkXEyrnbSIIuR6C0xQrFgjn
         gndFj4EOeSdiSaFIDjD/MMLhmLbggEvpXgk5znzSOSV1w+bvj/y+jGl4+Ufa3XBOuBT1
         17i4MHPkF0VmcZGiuPidKiK02CRyl8SsdUUEQzzwpuA8w4CumHc6u58fS7BzYdyUJIaN
         67xIuZQXZOQTSzXU2LmHibgF/sgqtGEO4B3npzDaYvkZvSQwe0kT7fQWR6q8p78loYQq
         FTCg==
X-Forwarded-Encrypted: i=1; AJvYcCXDssmHcpabohYmUAQx8aRKuDRUsA2FTff6XkOT1yIJv4YvFQTfIzrZBgVxJZlYFWjJjGGh/sUI6/Rl4wdesB468Lkw5vHW
X-Gm-Message-State: AOJu0YzxbQrzvqqmc7zhyrus+sEMKdYThgnJ2Us/E+0YrTiAxRKFiCkh
	4doy1y1vPdGR/B7Uk5AmMW/Qt/OfMoKiLtchYQ5VB0zgHLXhZ0o7ZGsSm0404AF1u+AdRstk/om
	EitT3PwfN5A==
X-Google-Smtp-Source: AGHT+IGxwZE2D4TMTbojQuxIQsdHxi4CLt7P+BDw6owECL4gA7IpetyfAOdk5HtQUv5KTlzPChmWvxiHs6Ovkg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:4c04:0:b0:607:cd22:1f32 with SMTP id
 z4-20020a814c04000000b00607cd221f32mr774161ywa.0.1708041261933; Thu, 15 Feb
 2024 15:54:21 -0800 (PST)
Date: Thu, 15 Feb 2024 23:54:01 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-11-amoorthy@google.com>
Subject: [PATCH v7 10/14] KVM: selftests: Report per-vcpu demand paging rate
 from demand paging test
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Using the overall demand paging rate to measure performance can be
slightly misleading when vCPU accesses are not overlapped. Adding more
vCPUs will (usually) increase the overall demand paging rate even
if performance remains constant or even degrades on a per-vcpu basis. As
such, it makes sense to report both the total and per-vcpu paging rates.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 09c116a82a84..6dc823fa933a 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -135,6 +135,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec ts_diff;
 	struct kvm_vm *vm;
 	int i;
+	double vcpu_paging_rate;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
@@ -191,11 +192,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			uffd_stop_demand_paging(uffd_descs[i]);
 	}
 
-	pr_info("Total guest execution time: %ld.%.9lds\n",
+	pr_info("Total guest execution time:\t%ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
-	pr_info("Overall demand paging rate: %f pgs/sec\n",
-		memstress_args.vcpu_args[0].pages * nr_vcpus /
-		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
+
+	vcpu_paging_rate =
+		memstress_args.vcpu_args[0].pages
+		/ ((double)ts_diff.tv_sec
+			+ (double)ts_diff.tv_nsec / NSEC_PER_SEC);
+	pr_info("Per-vcpu demand paging rate:\t%f pgs/sec/vcpu\n",
+		vcpu_paging_rate);
+	pr_info("Overall demand paging rate:\t%f pgs/sec\n",
+		vcpu_paging_rate * nr_vcpus);
 
 	memstress_destroy_vm(vm);
 
-- 
2.44.0.rc0.258.g7320e95886-goog


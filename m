Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7E638F86
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kUbpKKK5"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5b1ff96d5b9so18337717b3.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563834; x=1700168634; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ndN5evHM8MUglZ5LACl1va3WXCv7FT2yLnixDthGd8U=;
        b=kUbpKKK5yOC0DlpD+5QuKBRO0eEMm0n75MQBsCnYXbmBoZmGG6mSiF3t9tBiygsiTi
         L91TdQZuogZAnxAEJMbdMKJur12d5vRRoUYtFnm6DxGGtTvFZBro9AJSez0fX1c+JTl1
         /X6AnQyCMGXGhgf/8AkaQDkn19IWHDKHMa9d3ZRm+ShrPe+lFu/sLiSfKHIBBQfmF9lI
         XXJ2SMaf2uTet5GrvZco8g2731Yvv0JLJGsFok5zbgIIdsVVHfgSX7dgTjLnqkmQ5yvb
         EgaQTX5gR7Qz+jeXMRD4RLTnPRCbcJZcfAY+6X9qIaqVBDT+2SkDBugeYO7ygrND2ncv
         Iu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563834; x=1700168634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ndN5evHM8MUglZ5LACl1va3WXCv7FT2yLnixDthGd8U=;
        b=g1mu5Hpasm4ucUIy+gxNXlctshAvt2tcPyRYOvOzA57je97ZxqdXbVEiT7XMHqJxpR
         M2ueBDVm+WlG2RZXDXStMh/4vbtVOsrvuQvc23lH9UcFrgjiY3P+Q5lQyS2etcbDUifd
         kmUxLhkU0zf9NwDyhtHCDHigorAk+xpW4mcVzlec685oH5lypgcGFoXJpMkze2sbP01Z
         FczhiqjWdV+SDRWg3q3pLNqeIqW3tIu0jrgRfQArl+q1x1t0ExbIisu5xb2Lh/lA/EvW
         fPjsZJST9JkE9v/o8k8WsVwff6E7Y98Dua8+vk9dyAXGXneoLWjezapz7U+Dob4CCZA0
         cktg==
X-Gm-Message-State: AOJu0YzSKZr2zowZbvHtlR8Kh7xOnm9h0Dj77gg0NtfaohiT/HJZJVTD
	hxFL5012vB9cOLiSGajH9WlwTLDnzH1qsQ==
X-Google-Smtp-Source: AGHT+IGr/R/Ys/jo55wlqQbJQ0YqF45A4R74eV/HizZPI6A91g6dD/euSHzkl4e6vMTELVXYRo6uYcd4cdgrgw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:1fd6:0:b0:d9a:e3d9:99bd with SMTP id
 f205-20020a251fd6000000b00d9ae3d999bdmr147977ybf.5.1699563834122; Thu, 09 Nov
 2023 13:03:54 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:21 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-11-amoorthy@google.com>
Subject: [PATCH v6 10/14] KVM: selftests: Report per-vcpu demand paging rate
 from demand paging test
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
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
2.42.0.869.gea05f2083d-goog


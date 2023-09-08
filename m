Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0747EB64D
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:30:01 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-59224c40275so28520827b3.3
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212201; x=1694817001; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KBbXT1HpOrFkX6fT3ri9dT8smyClqE/Pk/MSUbxJK0g=;
        b=y3ubfm2lFsJneWTlgQslXQrUFLaJIH5+EzE4XsBbO1Kh3k9KmwZCzdkZkfxwPCqg6J
         yAVeh+tdmcudkUacsD3eMXYKzvWKfsszLJYJZ+5Oa5mtieHLx8HwiPlB5NraLq9mSwd3
         zXdxTausgg/xa/3qnG2y+LqAVLMMkKAFfMRIdfV2NqQSMubtjk/RjhHQWE/21SGTdAbv
         J3mihEyuQV7fycxhHE4Cds9RYFqu8NKL4nEJGdR+ZlLVZtV+GKn3ShBo7nyEctueq5aF
         sRImYmeH2imdYyy/V9/ot26B20jCGWipG+hb1E0gRssUURYp9E6AsMD6MxSY19SfAeDf
         NcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212201; x=1694817001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KBbXT1HpOrFkX6fT3ri9dT8smyClqE/Pk/MSUbxJK0g=;
        b=ugAj5adfDNDphMxjeb0rFJYy6LYfGTJpIoFGSYKszpF8NVnH0CwDNTaZZSDK6CTnrD
         z9iYVhx36tCyqKyjHxzD8UHXkiVghd3fr4ADDkp4NhBHSkGl1ffgh5L8e6K690c/wVhN
         Im+Ii1srYy0qw15rgEEbb13+4aV6JL4Ux0RcRN0RRnvSQdV+wQ8jt08bzhOIFll8g1BX
         GG1J872gWHFkMaX9vqGxM4lTTJnn22zMQDoEogigLtws8DyWdtfivICNTUem00HfjjNu
         e29g8Zt8L8g7YkVCe7TEzw9cdUI4Qr7mn5SDGWz+YuIxjxgS5IDFYAdsQNilMxoSumlb
         a70w==
X-Gm-Message-State: AOJu0YzEgbuvTklcNw/SxMUXxI5VA1K4Beq2KTfCZAlWJlNIgzEbwvDX
	Pz+5p1ojdqxabKWbvSpL6l2ppEgYhhJOzA==
X-Google-Smtp-Source: AGHT+IG0u7Fmfgwad2kTm5siZgMBlIJxpuK6meAbCgZIKiyvEqI1hsyuH16I5IXFPHVsdwlRNhxPIlipqpV5bw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:ae96:0:b0:c78:c530:6345 with SMTP id
 b22-20020a25ae96000000b00c78c5306345mr67692ybj.7.1694212201104; Fri, 08 Sep
 2023 15:30:01 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:29:00 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-14-amoorthy@google.com>
Subject: [PATCH v5 13/17] KVM: selftests: Report per-vcpu demand paging rate
 from demand paging test
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
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
2.42.0.283.g2d96d420d3-goog


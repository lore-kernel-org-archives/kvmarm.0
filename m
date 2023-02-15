Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B295415AE
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 01:16:31 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-52f2445e802so78330567b3.10
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=75a28QXTJaFdsjx6g4R+wdHT2tgt6NGnmqWStNNEkpo=;
        b=Iw8Q2vdwA/noAgSu5p+I2tng2TkLFWwFmMLMDpqhCZUJH6FHLrlVwnGqZC7E+T+c++
         WwVqgLiQAkzWOOFOG7UworKsK6kWnyfHaBaQ9jBKGItUwk7wbg5nGqmMKHgVoUDG6M0d
         HRrSP3LzAhDUv+h1V5wMna8A+rUBR+vv8I5e97PA7WksgkZ5bI8XlBxD+zLSVLDL1aCu
         4p1ICp0e0xEnENttjWn7BOCDURaGSl3Z7du6q7F6PYE4UnjLZFSME/Ki8si4qX1zSJP3
         cnfsgw8BSj/Cpp0pCwDyE36AMmllKJ58JMmqaAQOR9mVwOxJFx5a/rR78syL3Gy95QX5
         mwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=75a28QXTJaFdsjx6g4R+wdHT2tgt6NGnmqWStNNEkpo=;
        b=nv2hjB+0oU1o5YzQFHzFrjRrO27XMucqP9Q/6yYTJcvXgPsoHYEAPNsTEe4dtRaLXp
         A9VSJHY+dJZvORvvZkmU5gc2k0wZ4TFhDjknWS/LZnQq3Ema65JUjNkUT1k2kwD9O1Ua
         caD0N38URLd1v0CpVN8vf0XquGKmMWYPlRPehXiMm7UVZYvGhLxmOLb3u0C34ItWBjPe
         /c21ZDBBWp6Tp6R/sNwWlkIcIzc6koF7QhdNl7F+UYrPl6JTZs8nullMBL+QzpBln+HX
         OPMcOQc0qM8yFtlBZtoIb5Fv3F6gF3MKKBW7CGDloOTJDSvQQ2bCcLLNYX6za45KqMaS
         a/QQ==
X-Gm-Message-State: AO0yUKXK+zLOG+KjYjVQEgF6mXCcTLvMgDgxn9NOlPqu+1zTARKrOWz/
	bE+2xLaNguxk4MFoCb6Hr8tXek3I+UmY2g==
X-Google-Smtp-Source: AK7set8jyzjZ/w7zGwihP0Af5Tw20Rh/Yrccj44g/TtOWlS4X6Kbr4whsu8IPoI5Z6begZB8p5TvMHZofkLS+g==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:388:b0:902:5b5c:73f7 with SMTP
 id f8-20020a056902038800b009025b5c73f7mr0ybs.12.1676423790329; Tue, 14 Feb
 2023 17:16:30 -0800 (PST)
Date: Wed, 15 Feb 2023 01:16:07 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-2-amoorthy@google.com>
Subject: [PATCH 1/8] selftests/kvm: Fix bug in how demand_paging_test
 calculates paging rate
From: Anish Moorthy <amoorthy@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Anish Moorthy <amoorthy@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Currently we're dividing tv_nsec by 1E8, not 1E9.

Reported-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index b0e1fc4de9e29..6809184ce2390 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 	pr_info("Overall demand paging rate: %f pgs/sec\n",
 		memstress_args.vcpu_args[0].pages * nr_vcpus /
-		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
+		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 1E9));
 
 	memstress_destroy_vm(vm);
 
-- 
2.39.1.581.gbfd45094c4-goog


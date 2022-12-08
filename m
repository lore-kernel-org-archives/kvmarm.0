Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B97C4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 946624BA1A;
	Thu,  8 Dec 2022 14:39:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G-t6ZGUO9EEW; Thu,  8 Dec 2022 14:39:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 975BA4BA61;
	Thu,  8 Dec 2022 14:39:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F31C34BA0E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e11HTxE+iTMz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:22 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2D024BA12
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:20 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 n197-20020a25d6ce000000b00702558fba96so2587055ybg.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=SSdGxEhCr0RqVU7mTEekOKbILUbkr12FLBfwU71mUxI=;
 b=ASwdiNISwi39e3pN7oE2KNZFMmRKqmr3VYiit4wIyv47H88t6EbCKRpQMvgIGjb8Ee
 rJVPUEvW73NAo8aFV+BbV0Vr3OSkq29yA95vS5SMRxjzWXbnV3DZI/1DBZWOB8qdIrDl
 W6zsADUJr9yTIozq12aJEIz0+DdiTk+hebpQwi9Spbwq0O7+Rp/AhyZ8kHc6W7GbLEQQ
 W0hWYQM1VKgOje1FPxZ4mA6ztD8KMzpQNn+h5VJfv3SoW4uFDeXDtliLmzD104DdQ5jS
 RPnONZy1sj8iUseTf5J8a4CjaI/8JgGCw7ZrAZK92Qp419zeHoy00JFMymW+m0ow9uJP
 AA4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=SSdGxEhCr0RqVU7mTEekOKbILUbkr12FLBfwU71mUxI=;
 b=j0jXSluvkyvBCVb+tPQxjv+x1T5QAzBbth1Bt/QZkd7Dp0Kb+iqGw4AnKi3YZEnTjg
 vIpTvlo/pMRMTTkWB1sh9BEevky5ws+cTdsMJ96O4tgWoOOD5R1ccu9R0Pe32bf7lfom
 EkKx/kr4/EITx/WHaYaMlL0mASOcsCkjGXLDaRC+UWrXqf2hwx2En/j4oMVOtPXkw9Zq
 Ia9OnUx8km6RDsxhNGGifNZMPFCP4jLNnK160e4MM1dhi1FHSH8SPV47NC+e0e/GFmeg
 rribFr6toSiLt3icUoV7YScyEwjUaYA9Lu5YkCZJAnA9Wp50AVzbdpwds6aRY9fS8NBO
 XPIA==
X-Gm-Message-State: ANoB5pnDTkks6xPsS9tDIwUTQOsFqwsOzFlF83+UdRWwALRwHk6zxikH
 fJlNb7nARc6083xu91sFsyj9EcfCm3KGHw==
X-Google-Smtp-Source: AA0mqf47fCCsz8lLNEesw2/yjinjmb5c0Q+BVTcOByCxMnOsH1R3SmOt/A4xjy4bk2xWJgLDn+u8z1uj6TTwRA==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:9943:0:b0:3b6:79b0:c10e with SMTP id
 q64-20020a819943000000b003b679b0c10emr62215766ywg.87.1670528360357; Thu, 08
 Dec 2022 11:39:20 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:28 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-9-dmatlack@google.com>
Subject: [RFC PATCH 08/37] KVM: selftests: Stop assuming stats are contiguous
 in kvm_binary_stats_test
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
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

From: Jing Zhang <jingzhangos@google.com>

Remove the assumption from kvm_binary_stats_test that all stats are
laid out contiguously in memory. The KVM stats ABI specifically allows
holes in the stats data, since each stat exposes its own offset.

While here drop the check that each stats' offset is less than
size_data, as that is now always true by construction.

Fixes: 0b45d58738cd ("KVM: selftests: Add selftest for KVM statistics data binary interface")
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
[Re-worded the commit message.]

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 894417c96f70..46a66ece29fd 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -134,7 +134,8 @@ static void stats_test(int stats_fd)
 				    "Bucket size of stats (%s) is not zero",
 				    pdesc->name);
 		}
-		size_data += pdesc->size * sizeof(*stats_data);
+		size_data = max(size_data,
+			pdesc->offset + pdesc->size * sizeof(*stats_data));
 	}
 
 	/*
@@ -149,14 +150,6 @@ static void stats_test(int stats_fd)
 	TEST_ASSERT(size_data >= header.num_desc * sizeof(*stats_data),
 		    "Data size is not correct");
 
-	/* Check stats offset */
-	for (i = 0; i < header.num_desc; ++i) {
-		pdesc = get_stats_descriptor(stats_desc, i, &header);
-		TEST_ASSERT(pdesc->offset < size_data,
-			    "Invalid offset (%u) for stats: %s",
-			    pdesc->offset, pdesc->name);
-	}
-
 	/* Allocate memory for stats data */
 	stats_data = malloc(size_data);
 	TEST_ASSERT(stats_data, "Allocate memory for stats data");
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

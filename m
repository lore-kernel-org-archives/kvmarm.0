Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8C4C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 15:00:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D74854BA08;
	Fri, 25 Feb 2022 10:00:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x79MKhPMhGzX; Fri, 25 Feb 2022 10:00:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 503E54BAAA;
	Fri, 25 Feb 2022 09:59:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1539C4BB9B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:42:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hCfYwC-W0ofn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 22:42:54 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11B2D4BB95
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:42:54 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2d07ae11467so19792207b3.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 19:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=TYfrDDnCDZLgsaXn4hYzYqjwtRqrff+8WzYcoEgftOI=;
 b=q7666YkutUkL6RKXDHN6uW1bfeRRma2VbYbkjuziO8kN3Ez+AvP99CPA+crFQIMyGM
 u8V98l/kcyJmZrAMYC8lp0VZdsx7hfOnk0og8Iyu8/EPTcDyOrtXaylNfruGAYrBELML
 0t4kJOa3EW5NNbIbFy4ls3stZzs7gzcL6saNGB+qXhJn3B64HD/5jMrLH5g2Qj/oJRUN
 C3NdGCf8ofRIATki5ntXpIdGQYYOMg+4xfPq2uDJ2UMg5PbTBm+zuybq7cU5vTAp9A5R
 OadOj9nn2g7Sk/FRIHG0Q30twQG0Zl6SxdUGzB8zR5q1zrX1sy32E1VtmvDod4V091/Q
 RyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=TYfrDDnCDZLgsaXn4hYzYqjwtRqrff+8WzYcoEgftOI=;
 b=4Uf+P5Za0vLleoj+HB6KLOZyW7AcMmtGzeD1Xl4VgUsiWeG7/ytsE4J+4rWLLhBtLR
 TiEVRUqruXJPomzpZ6P7MxUNgUjRdKPpOvrwdoXsDzbzT/c0EPaylrI6d2t0UpSZAGzo
 AU2fR/SlJjDsg9UJsPvPicZlwF5YADX8AQKBbEATsvrhOVNk436BaqFAOeOU7kF3tCQC
 AGbBRkGfS1SgUTL2/cRFmwR07EOHUG8JijmLxPphdh67PQ0ReTtih/WA2YM1JUMQZlEa
 KigmMN79rgt4sWnJlbSMbIVn+lJ2hV9VaEjq8CfkDKte8TTk/X6NUA+cQJlfH6J4Vc6F
 4dPA==
X-Gm-Message-State: AOAM530U/cBfBlv5rsY93QF3gUa+ND02O0xinyFAjGUKWmoOMyGjwdYK
 3A91/xDC4oK8HEfX0rq9LEDyZyvoz3vcmtRhYg==
X-Google-Smtp-Source: ABdhPJyuZ08nciNdihLr0dH67Rir4ZvyzFgkAlltso3KgjJwiOs2qrT2Nw+pxsQEIBxp93gHWjAaX4W2t6yMU0pQ5Q==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:3a50:90b2:e6a2:9060])
 (user=kaleshsingh job=sendgmr) by 2002:a25:808f:0:b0:624:a5e8:9762 with SMTP
 id n15-20020a25808f000000b00624a5e89762mr5469937ybk.279.1645760573552; Thu,
 24 Feb 2022 19:42:53 -0800 (PST)
Date: Thu, 24 Feb 2022 19:34:49 -0800
In-Reply-To: <20220225033548.1912117-1-kaleshsingh@google.com>
Message-Id: <20220225033548.1912117-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220225033548.1912117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 4/8] KVM: arm64: Add guard pages for pKVM (protected nVHE)
 hypervisor stack
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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

Maps the stack pages in the flexible private VA range and allocates
guard pages below the stack as unbacked VA space. The stack is aligned
to twice its size to aid overflow detection (implemented in a subsequent
patch in the series).

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v4:
  - Replace IS_ERR_OR_NULL check with IS_ERR check now that
    pkvm_alloc_private_va_range() returns an error for null
    pointer, per Fuad

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark

 arch/arm64/kvm/hyp/nvhe/setup.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 27af337f9fea..1b69a25c1861 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -105,11 +105,28 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 		if (ret)
 			return ret;
 
-		end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va;
+		/*
+		 * Private mappings are allocated upwards from __io_map_base
+		 * so allocate the guard page first then the stack.
+		 */
+		start = (void *)pkvm_alloc_private_va_range(PAGE_SIZE, PAGE_SIZE);
+		if (IS_ERR(start))
+			return PTR_ERR(start);
+
+		/*
+		 * The stack is aligned to twice its size to facilitate overflow
+		 * detection.
+		 */
+		end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_pa;
 		start = end - PAGE_SIZE;
-		ret = pkvm_create_mappings(start, end, PAGE_HYP);
-		if (ret)
-			return ret;
+		start = (void *)__pkvm_create_private_mapping((phys_addr_t)start,
+					PAGE_SIZE, PAGE_SIZE * 2, PAGE_HYP);
+		if (IS_ERR(start))
+			return PTR_ERR(start);
+		end = start + PAGE_SIZE;
+
+		/* Update stack_hyp_va to end of the stack's private VA range */
+		per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va = (unsigned long) end;
 	}
 
 	/*
-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

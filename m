Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF46C388F7
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86BC320731
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="l5mFBYX1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86BC320731
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDF0D4B720;
	Mon,  9 Nov 2020 06:32:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aYJlBscscGdt; Mon,  9 Nov 2020 06:32:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC8B34B7F1;
	Mon,  9 Nov 2020 06:32:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B31224B75B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id msIAlwQ1UzND for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:32:55 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 982F24B743
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:55 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id o15so469411wru.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=E1NKlSXbosotz7yE3k2vTKr2ydlvsygMA7t9DehWpvE=;
 b=l5mFBYX18Rn7YX+QOaWfw6pSERAucDkfSD0fLjY2La9KEXAkogCnx0MlXxkUnnQruE
 hcRz3mFUUHEK7BkHrKmHKS7z4K9kzSMySOyP7FbGc3/T8JrugpkNZIt/AJ44AdxcV/y9
 7EGITSkupXBoishh0kGdsfNPWgvqpzGLGKMdOBFcz0OhhjZ9kNWpadYeoPxbZ90OQ0rG
 QoZLm++zKXNxDhFNzhQ4FEt5gWvnAlfXkA27lW91g6b2Ie32EmXFrFBg/m4ggOxY1441
 ypg58scvklmkltXN9bpd2eLzNMuaLpFOQc9Qw8AdB4l22lVMqsm9gnPrsu3lwPJtpD7k
 bfQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=E1NKlSXbosotz7yE3k2vTKr2ydlvsygMA7t9DehWpvE=;
 b=KrgJKrVYWwgGjP/MDs3gQouSpdW9hghF0p7HgxKtCbKFcCamiw3iOh6+uPiXWd5+Sl
 cBL8yGMN51sof4hScAOHiOR9hHTa0+O3It0ltacuIZVJzHrGLURXAqRsp+TxMhYyeFoc
 U3FMKeGVhBU45aMh9kpsndlBb15VIWwqYxlxwvDVSGjJifoiQmwuTEsz2vyBnZW3aGNw
 uFx8gywFZ3JbsL9anS4z9AZc8JJvQf/DY2m7ZLDq2M5F0crmK54bW8T67VLCgKyjBYqK
 /Chld2YWnjscS3Zh1l66O2rH7BjWVGKB8Q+mSjud59N8FqcNJPBK3o3CCb2YVVZThMY0
 iMCg==
X-Gm-Message-State: AOAM5333TRRwvNwSbyt2Yi/zNzCCQwY2yylKHPpMrFfAFN7nKVrQQJTw
 fI88VWAEdlegMwknYTll1ujh5TsjKtJrSoWy
X-Google-Smtp-Source: ABdhPJz/l/6GQDBPHymkPNzaoMyRUmvzkHblO9n04gDj4zUaNX37jiQdcZNRxwl4SGl32T4mexwRmg==
X-Received: by 2002:adf:e287:: with SMTP id v7mr17824035wri.252.1604921574345; 
 Mon, 09 Nov 2020 03:32:54 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id f23sm12132699wmb.43.2020.11.09.03.32.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:32:53 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 07/24] kvm: arm64: Create nVHE copy of cpu_logical_map
Date: Mon,  9 Nov 2020 11:32:16 +0000
Message-Id: <20201109113233.9012-8-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

When KVM starts validating host's PSCI requests, it will need to map
MPIDR back to the CPU ID. To this end, copy cpu_logical_map into nVHE
hyp memory when KVM is initialized.

Only copy the information for CPUs that are online at the point of KVM
initialization so that KVM rejects CPUs whose features were not checked
against the finalized capabilities.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c             | 17 +++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/percpu.c | 16 ++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9ba9db2aa7f8..b85b4294b72d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1481,6 +1481,21 @@ static inline void hyp_cpu_pm_exit(void)
 }
 #endif
 
+static void init_cpu_logical_map(void)
+{
+	extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
+	int cpu;
+
+	/*
+	 * Copy the MPIDR <-> logical CPU ID mapping to hyp.
+	 * Only copy the set of online CPUs whose features have been chacked
+	 * against the finalized system capabilities. The hypervisor will not
+	 * allow any other CPUs from the `possible` set to boot.
+	 */
+	for_each_online_cpu(cpu)
+		CHOOSE_NVHE_SYM(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
+}
+
 static int init_common_resources(void)
 {
 	return kvm_set_ipa_limit();
@@ -1659,6 +1674,8 @@ static int init_hyp_mode(void)
 		}
 	}
 
+	init_cpu_logical_map();
+
 	return 0;
 
 out_err:
diff --git a/arch/arm64/kvm/hyp/nvhe/percpu.c b/arch/arm64/kvm/hyp/nvhe/percpu.c
index 5fd0c5696907..d0b9dbc2df45 100644
--- a/arch/arm64/kvm/hyp/nvhe/percpu.c
+++ b/arch/arm64/kvm/hyp/nvhe/percpu.c
@@ -8,6 +8,22 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+/*
+ * nVHE copy of data structures tracking available CPU cores.
+ * Only entries for CPUs that were online at KVM init are populated.
+ * Other CPUs should not be allowed to boot because their features were
+ * not checked against the finalized system capabilities.
+ */
+u64 __ro_after_init __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
+
+u64 cpu_logical_map(int cpu)
+{
+	if (cpu < 0 || cpu >= ARRAY_SIZE(__cpu_logical_map))
+		hyp_panic();
+
+	return __cpu_logical_map[cpu];
+}
+
 unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 {
 	unsigned long *cpu_base_array;
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

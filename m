Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EF7C4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F65A4BA12;
	Thu,  8 Dec 2022 14:39:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NAfprPID--q0; Thu,  8 Dec 2022 14:39:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 858CA4BA8C;
	Thu,  8 Dec 2022 14:39:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39F674BA25
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k263Tw9I0rMn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:40 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 654D34BA26
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:35 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 n197-20020a25d6ce000000b00702558fba96so2587672ybg.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=9RmR6EwIqCFDBLvxI6selt5ga3zw1fPd7MYyun7sh04=;
 b=pUH2F0cXu3WIGRD2ce8NSaVZncsouuIq0PwSt3Hx5XNNzUTAHyLwoPUZmYYFi5CtSP
 nVhq3u0B+puFODMcSNnljB/IQui4QQoBBoT7VK2vjldq5K0TcwfXSpD6l8CQHX5MJLf1
 +ObCB8QWeBiWlCf7gO5CWF4MLRqEya3iXno1lfQYF2S+3pFzK9GESTP8LV94Jcgc/kmm
 DGrmedpnRTomnz9+8f0JJ8smD91kG4llzTsIt3IMmR0C9KC9suLzy6zk0g20DYlyZJGB
 ATs/tP0070Y72621Cd+brELKn4hhj6+ekuepajebi56ZFA2sqrDn/ZHk1U80/2BWwxTx
 E8Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=9RmR6EwIqCFDBLvxI6selt5ga3zw1fPd7MYyun7sh04=;
 b=iS0qh/dqZIkmAJn3quw1Z/1e2EbbCrwDtfrGZ9OFd/kjkf8kL+YH1tYneQDP48qZ8P
 f6r6ODBxKcXaJn02FBQaVlaV4sL7HsQc+4D4Cu1y8tP/KBvHbzawNag1QGdLoq13JFZL
 OwyQLlSkSb6+w9V99PZ2aovkLlCJj7k/VL80EtTCoQxdWTm3e8/7e/B27lQQ5BDq7kIW
 QRMazoBQ/b3gSePCkpnPnIblmkQeIv7W0sn3KO31lAI8Oypwjd54HiqzCeejjpIWnb5q
 cu4WQ3sE9hAQkUm3AaMTMgqCS18RnxFRmhu9YTJ9j0vaqDF/woZWxbs/yza+GpLLv7tW
 T2oQ==
X-Gm-Message-State: ANoB5pnwGQM2lO8rOSWRP97QoyEf95TtwU6mK213EcdQ8y5FG2ZOhup8
 utzMJa3nUmv02zYhccGa2PEvWh9dFPqCMQ==
X-Google-Smtp-Source: AA0mqf7cV11l2t3OM7agzc6qRsrai4lnDlxSMNa6gi84ZckjSbH/wAyvmmZJEJroavTOpSqZ0tfjElEm8egcuA==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d9c1:0:b0:6fd:d054:a0a7 with SMTP id
 q184-20020a25d9c1000000b006fdd054a0a7mr25462879ybg.112.1670528375112; Thu, 08
 Dec 2022 11:39:35 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:37 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-18-dmatlack@google.com>
Subject: [RFC PATCH 17/37] KVM: Move struct kvm_gfn_range to kvm_types.h
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

Move struct kvm_gfn_range to kvm_types.h so that it's definition can be
accessed in a future commit by arch/x86/include/asm/kvm/tdp_pgtable.h
without needing to include the mega-header kvm_host.h.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h  | 7 -------
 include/linux/kvm_types.h | 8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 22ecb7ce4d31..469ff4202a0d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -256,13 +256,6 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
-struct kvm_gfn_range {
-	struct kvm_memory_slot *slot;
-	gfn_t start;
-	gfn_t end;
-	pte_t pte;
-	bool may_block;
-};
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 59cf958d69df..001aad9ea987 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -132,4 +132,12 @@ struct kvm_vcpu_stat_generic {
 
 #define KVM_STATS_NAME_SIZE	48
 
+struct kvm_gfn_range {
+	struct kvm_memory_slot *slot;
+	gfn_t start;
+	gfn_t end;
+	pte_t pte;
+	bool may_block;
+};
+
 #endif /* __KVM_TYPES_H__ */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

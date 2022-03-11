Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8EFC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:49:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A2B49F3E;
	Fri, 11 Mar 2022 03:49:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4OfJ6Hmpybze; Fri, 11 Mar 2022 03:49:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 095B64B086;
	Fri, 11 Mar 2022 03:48:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 753BB40C52
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 40isP4IIp5tu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:26:09 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C63F408C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:09 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 z14-20020a170902ccce00b0014d7a559635so3534856ple.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Xxlsl5gMjKmF9SCaiAavzpq6LPoScWsJHzRFSDHyFso=;
 b=cMEUZuguiW6pmIHu9LU3eoo1FDRnKfP07X6qrVJz+feSqP00edJurvJ6fZVCoGCvaJ
 5svA21y657lW0vnnvcB8DrJj0Wif0psmeyY8i7OHoLX//aZidsK2Kwctp17DBZkm6zks
 bNqQTe153ijee74TbEx9ka/WwLu8NnHNmhJ3rzu0hVNv/X65IxxIaEZsKTVXiz3k0pq/
 PXKVNpYhcW10Mo0GvokzU2pQFbCQGCYnnW5ERLDk3Bglg0cMtbS8FePSpbkv3zkxP4/+
 HypkhlHZXg2YdqZQ+p9wkqmsfUp8Sg4/Y0BzNMC+ciXTAMJksdrkfNpcGpiny8WuXLFB
 rq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Xxlsl5gMjKmF9SCaiAavzpq6LPoScWsJHzRFSDHyFso=;
 b=wn6a1c6clMVBBtuSa1FddK3bld+43NPa8lU6hdgi+OsSksB5rETsy1XiyS4Yqq/OVU
 Xo8Y1Wcf5YytPaX8AQXMtWo/RqjaeBpuaJPLWf7maLz2IxM2alTw9+BBs9i/WmNvY+iU
 gae7d92LTyAFrWLg6lxj47ZGwOzWHA5HuqScpz5uNePhz8BAw74t+C2IZ2maJnGm2R06
 3CZBjuEsB66gn512W+AA5K9gs3KGkMp3BPq3qDoHkzxXvVJEJusPln+k1E9yhADJ5SQC
 lYOMA2WrlWHlmOAibGIhuR4nF47SkasLqkxqr94XYxPWogRepEt1gMed7kkFvW5uuOoH
 laDQ==
X-Gm-Message-State: AOAM531iRdWtpAbZZra03Dp2/XmRtZGS7CzOFYb58CuY+L99C6MyPBU2
 Gvv/YuYvuGERSXw01rVPoAHI6fllvVRFjw==
X-Google-Smtp-Source: ABdhPJywweZjzvrfhg7epKsXyYUluoBQw2WEtYQ9qKQxDvH8uHrVK9h/VGrnh31BcpoNycSVrImYh5be0PAtHQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:17ca:b0:1bf:6188:cc00 with SMTP
 id me10-20020a17090b17ca00b001bf6188cc00mr19161970pjb.2.1646958368553; Thu,
 10 Mar 2022 16:26:08 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:24 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-23-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 22/26] KVM: Allow GFP flags to be passed when topping up
 MMU caches
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:42 -0500
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

This will be used in a subsequent commit to top-up MMU caches under the
MMU lock with GFP_NOWAIT as part of eager page splitting.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..7d3a1f28beb2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1335,6 +1335,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
+int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min, gfp_t gfp);
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1d849ba9529f..7861874af1c8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -367,7 +367,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 		return (void *)__get_free_page(gfp_flags);
 }
 
-int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
+int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min, gfp_t gfp)
 {
 	void *obj;
 
@@ -382,7 +382,7 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	if (mc->nobjs >= min)
 		return 0;
 	while (mc->nobjs < mc->capacity) {
-		obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
+		obj = mmu_memory_cache_alloc_obj(mc, gfp);
 		if (!obj)
 			return mc->nobjs >= min ? 0 : -ENOMEM;
 		mc->objects[mc->nobjs++] = obj;
@@ -390,6 +390,11 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	return 0;
 }
 
+int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
+{
+	return __kvm_mmu_topup_memory_cache(mc, min, GFP_KERNEL_ACCOUNT);
+}
+
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
 	return mc->nobjs;
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

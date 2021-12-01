Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD68EC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:04:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CFEA4B21F;
	Wed,  1 Dec 2021 12:04:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 89kWWZJt47eh; Wed,  1 Dec 2021 12:04:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BA734B26B;
	Wed,  1 Dec 2021 12:04:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4854B21F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xEFGOlDqY838 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:04:54 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 849E34B25D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:54 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 g11-20020a1c200b000000b003320d092d08so12565167wmg.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=T0JsrzG68YfPigMGVPlPrd/xCSmb5pbfUw0MQLeIq18=;
 b=FxwXE/GBzpALB+WDGk4xxS/qk7AEHYIAQOFqBsax91XFh54Oe4XTkZKSH5mjhhiGwi
 xojuzI07IO1NX0heyd2/dn4DPfxq0MBzpigfJwCCo9EWFe/7k5cjD6K87Hr1bnzMr75n
 LPvlTZ5UVckhBdhWY1tA5gp6BooYMA6vk6UqpvQCQKxmxXijzAAUxOLQHmq3W/UT5K76
 LLOzTHeRcv7HG31p0iL095jbrbR4CWaw0qd/Lm3WvIAX+mRlmQSBbLi4bERT3mmAXGm9
 giXC8vRUXTgmyMn6BJyiPcxZQDAjsrAMk92/xCu0oed2MKOEUxmlhKYTnIEcRcGVQi/j
 d5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=T0JsrzG68YfPigMGVPlPrd/xCSmb5pbfUw0MQLeIq18=;
 b=4cYSux/S+dOBKzOcGeAuohXuPgzKoTbFxgrXi6qQ25XCJSQYghVZUllDAFw2viJUy5
 1hYFpf8KEhIXKCqCjyx1v2PfPH2Pf9mA0rKpxXPmeIMYh0u6rUnndA5zm24P0Ivyu8hJ
 NdX5lrVGoV1dnPMuqr7WLH2ddUq9HRvUnQcpwr5AS/8rJhioD3/id2uBrYssZt3ImD4I
 0/HiJZvAMdMjFkllEhwqpLNDbGUZIhVfdKfnwEt+HvG+XyFaB5T0fnZb02lt4EpMFa5A
 5mbgl06yYpp3VQcgHd8lsYetR3XnWU3WzgzC50+NyG/AxzrCH0WR84ZTuGLzT/9hHiBf
 9zAA==
X-Gm-Message-State: AOAM531pBkaqBk19uNOH0rE5n3Dx7Jh69a6MKGZ97e0f6tpfAXx7CQiw
 CuHzSO8sosvlqjv9wEZaENMECLmKUdtg
X-Google-Smtp-Source: ABdhPJzxm+jj5EWvAYdKtX2YJJnnLDNfrgC/7WKMyffToJZDquq3DYO27TbqsoOCOfqh0AkV6YTZ7zDrqd13
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:adf:fb09:: with SMTP id
 c9mr8021924wrr.223.1638378293678; Wed, 01 Dec 2021 09:04:53 -0800 (PST)
Date: Wed,  1 Dec 2021 17:04:04 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-11-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 10/15] KVM: arm64: Introduce wrappers for host and hyp spin
 lock accessors
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

From: Will Deacon <will@kernel.org>

In preparation for adding additional locked sections for manipulating
page-tables at EL2, introduce some simple wrappers around the host and
hypervisor locks so that it's a bit easier to read and bit more difficult
to take the wrong lock (or even take them in the wrong order).

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 32 ++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c1a90dd022b8..757dfefe3aeb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -27,6 +27,26 @@ static struct hyp_pool host_s2_pool;
 
 const u8 pkvm_hyp_id = 1;
 
+static void host_lock_component(void)
+{
+	hyp_spin_lock(&host_kvm.lock);
+}
+
+static void host_unlock_component(void)
+{
+	hyp_spin_unlock(&host_kvm.lock);
+}
+
+static void hyp_lock_component(void)
+{
+	hyp_spin_lock(&pkvm_pgd_lock);
+}
+
+static void hyp_unlock_component(void)
+{
+	hyp_spin_unlock(&pkvm_pgd_lock);
+}
+
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
 	void *addr = hyp_alloc_pages(&host_s2_pool, get_order(size));
@@ -338,14 +358,14 @@ static int host_stage2_idmap(u64 addr)
 
 	prot = is_memory ? PKVM_HOST_MEM_PROT : PKVM_HOST_MMIO_PROT;
 
-	hyp_spin_lock(&host_kvm.lock);
+	host_lock_component();
 	ret = host_stage2_adjust_range(addr, &range);
 	if (ret)
 		goto unlock;
 
 	ret = host_stage2_idmap_locked(range.start, range.end - range.start, prot);
 unlock:
-	hyp_spin_unlock(&host_kvm.lock);
+	host_unlock_component();
 
 	return ret;
 }
@@ -369,8 +389,8 @@ int __pkvm_host_share_hyp(u64 pfn)
 	if (!addr_is_memory(addr))
 		return -EINVAL;
 
-	hyp_spin_lock(&host_kvm.lock);
-	hyp_spin_lock(&pkvm_pgd_lock);
+	host_lock_component();
+	hyp_lock_component();
 
 	ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, NULL);
 	if (ret)
@@ -432,8 +452,8 @@ int __pkvm_host_share_hyp(u64 pfn)
 	BUG_ON(ret);
 
 unlock:
-	hyp_spin_unlock(&pkvm_pgd_lock);
-	hyp_spin_unlock(&host_kvm.lock);
+	hyp_unlock_component();
+	host_unlock_component();
 
 	return ret;
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

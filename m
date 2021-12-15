Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9119C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 16:13:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6574C4B162;
	Wed, 15 Dec 2021 11:13:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oQVd4e5muqis; Wed, 15 Dec 2021 11:13:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D8454B161;
	Wed, 15 Dec 2021 11:13:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 800DD4B159
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:13:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R1ajs3EnE3T9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 11:13:15 -0500 (EST)
Received: from mail-lj1-f201.google.com (mail-lj1-f201.google.com
 [209.85.208.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0679D4B149
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:13:15 -0500 (EST)
Received: by mail-lj1-f201.google.com with SMTP id
 m20-20020a2eb6d4000000b002219b019ae8so6943475ljo.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2TGPIYSaEIjKXjmvhnIXxrzrd8fguGN1MQzZdij/gwk=;
 b=bx6YgQQWKyCSriIz1R2rvmpQeUPcD0LpKjIZj+LDd11kYfmZKlDmapJ/NyEJhKB7GO
 0GNru/GfkcY439wnQd6qGZWJ0R4V8TCPgdF4fQCmFf2mLn1nyyp7lky7fe2/FaH0RHIt
 ayc9pOBPTj6NebOFz8Q/fypnbTOti4vduxE+9sd9VMnD0V8ByjDjpM0LtEIpro98NX+C
 xloCTF1+b5uUnxrAf8KMgFnozY/oViJEotm4Te4lvAcvr85lmaAQHI0wOMWk9biEgA94
 CdeqYpF58doTpOxXGhwdvr8+ryDxaa43mMdVMz3zcHokS9iuQ95w4Vg0j4BSjvXa10iK
 gr9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2TGPIYSaEIjKXjmvhnIXxrzrd8fguGN1MQzZdij/gwk=;
 b=zdFEU2TJQvfuktquMZlES42+GIV7KmCrGf+fFtTZwOOCy5PE0TIbpYdiRkUKDt9AEB
 TkyRrHJMZ3c5RXqu/+/ci+edwRy4rAUV2fCPwLSDuapwdViZdW+M8UXKQg9QrwfEoo1f
 uuu+9Xr7iqKGEaj/h9jCCnzux7IG94El2tm3s72E7lCMiLTlchxJ7PBh0mu846rB5q26
 LOCFYyM8gob2I3cwhcCZNn8tYJZlUbXArEFi6eGklC/EvykaGSZJClw3LmaSPvIJJSjh
 rbr/7rTV5Z+8mpN8w2upTW5OpGs/o6MFDOdLmXInIVwAByLL01fIRfKqEV9ZDZrOD/Ff
 OJ7w==
X-Gm-Message-State: AOAM533n7G3Tl3rIO3RoWP7tLAIrrkILJt/8AuSYrxtNOanBjCgVxv/T
 AfS7GK5PUGXhz3Doi9/rMMAWYgzcOyAG
X-Google-Smtp-Source: ABdhPJzILf2Wp1hVJt12n/LnfOzJSJvsC7ZTraq2mR6Vo+DADiIAWTxTcbaMTv7WHfizd8OOLb/5vfdAWkVM
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:fc03:4f5b:4e9b:3ec1])
 (user=qperret job=sendgmr) by 2002:a05:6512:388b:: with SMTP id
 n11mr10318861lft.198.1639584793573; Wed, 15 Dec 2021 08:13:13 -0800 (PST)
Date: Wed, 15 Dec 2021 16:12:26 +0000
In-Reply-To: <20211215161232.1480836-1-qperret@google.com>
Message-Id: <20211215161232.1480836-10-qperret@google.com>
Mime-Version: 1.0
References: <20211215161232.1480836-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 09/14] KVM: arm64: Introduce wrappers for host and hyp spin
 lock accessors
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: qwandor@google.com, linux-kernel@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
index 92262e89672d..907d3cbf1809 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -28,6 +28,26 @@ static struct hyp_pool host_s2_pool;
 
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
@@ -339,14 +359,14 @@ static int host_stage2_idmap(u64 addr)
 
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
@@ -370,8 +390,8 @@ int __pkvm_host_share_hyp(u64 pfn)
 	if (!addr_is_memory(addr))
 		return -EINVAL;
 
-	hyp_spin_lock(&host_kvm.lock);
-	hyp_spin_lock(&pkvm_pgd_lock);
+	host_lock_component();
+	hyp_lock_component();
 
 	ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, NULL);
 	if (ret)
@@ -433,8 +453,8 @@ int __pkvm_host_share_hyp(u64 pfn)
 	BUG_ON(ret);
 
 unlock:
-	hyp_spin_unlock(&pkvm_pgd_lock);
-	hyp_spin_unlock(&host_kvm.lock);
+	hyp_unlock_component();
+	host_unlock_component();
 
 	return ret;
 }
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

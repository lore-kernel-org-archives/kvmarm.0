Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CF0C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 16:13:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1324C4B129;
	Wed, 15 Dec 2021 11:13:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lgqtUVEz67kU; Wed, 15 Dec 2021 11:13:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C12144B1CA;
	Wed, 15 Dec 2021 11:13:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 753CD4B1CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:13:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iKXQTH4Y8CrA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 11:13:06 -0500 (EST)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5AFAD4B161
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:13:06 -0500 (EST)
Received: by mail-ed1-f73.google.com with SMTP id
 y9-20020aa7c249000000b003e7bf7a1579so20571128edo.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=B6GzFGiJ9PDO3woWUzIbQYLWwAYi6gFGbI36nZkkLuI=;
 b=LfMfotPk7w6rWp0uOSQHvJQNeYxBG/vYsI0ZSS+gJS2pQ9d7+MYAIw+CIHmxNxqtvK
 5chzSGZRy0VzQN/uC3MPMZdBIb+2eqcQoyfLMPGg0heD+S9jsPKnj5ksmwTFlDCKyjms
 7Hfq8hkRBtkZGdNfS8LyA/V1IPjjJ3tZN5isv8poxOZ5hGJvwKD5J6UgOj+Po2xIio2h
 MSN1+ZmJFWbEwZm6QRt22g23P6tdBlPdm30GzXM6iaEMpkf6s1iG8iNTcRVQq9rsCrDh
 Am2/bQCEEYu9awQdp9iHx0pj0BcxW4nwNDKIVeZvaD75lEGjA59wpVCV+IEfLMIzwjAZ
 EWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=B6GzFGiJ9PDO3woWUzIbQYLWwAYi6gFGbI36nZkkLuI=;
 b=O6EbMNUgpi62TG0y2cyHPjSr/CLmrtzFmJ8uyREIdly8sLZwN8WX5PjtLUKLkB0edf
 mmm6VMoSm3DzwCbsi7fvB2pzB0m+ovkqyIZgfjWT7R81AhJhdNed1Tx8+G8QtGtcbI9b
 UBopQ89dSk8vAw4GyyqiYitx2dEN8Z4qpPUT6q3zb6FoB1egJ+UaFlTGL1tGYO35BGiG
 5ioM2lEyg6yOhae9OC45KiQ4oISf3r9ASqya6IuiZGekc22EV0fGc9i6UTrpeLYo2A+k
 n+U+vW+UecjrHTZHMaxfWfQTh6Ai17o/DmbFRZX3fUD7CHP9fm82u38BfWhwQulG3uBG
 CvIA==
X-Gm-Message-State: AOAM533cYy0ICNOYQy5mCVICYvL9kwYA8D+woxqcNMTElXMwq9UHtbxP
 Eqf/OfSo/BfSeeGmmGgKe5ItOPRfaOEa
X-Google-Smtp-Source: ABdhPJzgyjka4FxXVtsMMj3VQycigI6bxMYJb26eD4iPUI6aLUCxnlKe/+64Obb/yrMeRoi9JwSheSnldtDw
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:fc03:4f5b:4e9b:3ec1])
 (user=qperret job=sendgmr) by 2002:a17:906:390:: with SMTP id
 b16mr11243842eja.123.1639584785340; Wed, 15 Dec 2021 08:13:05 -0800 (PST)
Date: Wed, 15 Dec 2021 16:12:24 +0000
In-Reply-To: <20211215161232.1480836-1-qperret@google.com>
Message-Id: <20211215161232.1480836-8-qperret@google.com>
Mime-Version: 1.0
References: <20211215161232.1480836-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 07/14] KVM: arm64: pkvm: Refcount the pages shared with EL2
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

In order to simplify the page tracking infrastructure at EL2 in nVHE
protected mode, move the responsibility of refcounting pages that are
shared multiple times on the host. In order to do so, let's create a
red-black tree tracking all the PFNs that have been shared, along with
a refcount.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 78 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 68 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 872137fb5e0f..f26d83e3aa00 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -284,23 +284,72 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
 	}
 }
 
-static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
+struct hyp_shared_pfn {
+	u64 pfn;
+	int count;
+	struct rb_node node;
+};
+
+static DEFINE_MUTEX(hyp_shared_pfns_lock);
+static struct rb_root hyp_shared_pfns = RB_ROOT;
+
+static struct hyp_shared_pfn *find_shared_pfn(u64 pfn, struct rb_node ***node,
+					      struct rb_node **parent)
 {
-	phys_addr_t addr;
-	int ret;
+	struct hyp_shared_pfn *this;
+
+	*node = &hyp_shared_pfns.rb_node;
+	*parent = NULL;
+	while (**node) {
+		this = container_of(**node, struct hyp_shared_pfn, node);
+		*parent = **node;
+		if (this->pfn < pfn)
+			*node = &((**node)->rb_left);
+		else if (this->pfn > pfn)
+			*node = &((**node)->rb_right);
+		else
+			return this;
+	}
 
-	for (addr = ALIGN_DOWN(start, PAGE_SIZE); addr < end; addr += PAGE_SIZE) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
-					__phys_to_pfn(addr));
-		if (ret)
-			return ret;
+	return NULL;
+}
+
+static int share_pfn_hyp(u64 pfn)
+{
+	struct rb_node **node, *parent;
+	struct hyp_shared_pfn *this;
+	int ret = 0;
+
+	mutex_lock(&hyp_shared_pfns_lock);
+	this = find_shared_pfn(pfn, &node, &parent);
+	if (this) {
+		this->count++;
+		goto unlock;
 	}
 
-	return 0;
+	this = kzalloc(sizeof(*this), GFP_KERNEL);
+	if (!this) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	this->pfn = pfn;
+	this->count = 1;
+	rb_link_node(&this->node, parent, node);
+	rb_insert_color(&this->node, &hyp_shared_pfns);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn, 1);
+unlock:
+	mutex_unlock(&hyp_shared_pfns_lock);
+
+	return ret;
 }
 
 int kvm_share_hyp(void *from, void *to)
 {
+	phys_addr_t start, end, cur;
+	u64 pfn;
+	int ret;
+
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
@@ -315,7 +364,16 @@ int kvm_share_hyp(void *from, void *to)
 	if (kvm_host_owns_hyp_mappings())
 		return create_hyp_mappings(from, to, PAGE_HYP);
 
-	return pkvm_share_hyp(__pa(from), __pa(to));
+	start = ALIGN_DOWN(__pa(from), PAGE_SIZE);
+	end = PAGE_ALIGN(__pa(to));
+	for (cur = start; cur < end; cur += PAGE_SIZE) {
+		pfn = __phys_to_pfn(cur);
+		ret = share_pfn_hyp(pfn);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

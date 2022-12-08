Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D03C001B2
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3C44BA7F;
	Thu,  8 Dec 2022 14:39:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vImiK5GTDAHs; Thu,  8 Dec 2022 14:39:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44DC84BA59;
	Thu,  8 Dec 2022 14:39:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A612A4BA2B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i3nss72dDgtv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:52 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B8B74BA22
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:48 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 n5-20020a170902d2c500b00189e5b86fe2so2194127plc.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=1a1z/b3owkRfttdiEuiESfzblYsje7V7GrYJ8kI0Po8=;
 b=F0XYX+U7NiHCkK7bsbIKwHt4xn5xSLrANWygs7k8NFHbu1R2R/rmJKDDnvUWdIHP92
 Ly2IYp0NOWTwXh63NaBMZcPqgDrfFaYYlcINvpDuRoegsyJJVoxOj7s7XDFnwq4W8GTC
 f+4upgVNo5G4bbwSbrkVhi3YHBvy4jYzsDFUG9wwYOpDkZx7UBWzJoj2myxNLvIdqZ4W
 pfI5REShGLM7+b3RergwOgWIMIsTPACWYsmBoNyo8t79eVgzWxxkGk1mGWxh5mVT27dB
 xSUuXJrP+ASrLLbWhs1/6bZw6Zgr2IKK/y+UkG+xQAvodbxK4QFJj/l93proPVAsOFHJ
 1lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=1a1z/b3owkRfttdiEuiESfzblYsje7V7GrYJ8kI0Po8=;
 b=M1RwbUMTItvm7qhQBoNpN7GNZFD8XabFyrPQfzZWniLv0iiBVq/yH58xi18dW6VrrW
 BdK/OEZCiiBWO3Cyej5Bzj79A4L7xCvq7/u0HYD6MzrWJ1/n30DjO5tEQiKtRi1VsPar
 93KhDoWeUs1zqBXQswNOH/1WiLqT3RoJt/dVgW17kHV31RwnYXyScWSuMeuvflg3HBMI
 8Qyrd1T4ttM7f+j3ngxLLbacW+vs6mAc+Ye9AQ0+aDMKHIhMmyHC4HWOJIWNRXHSpCYC
 xLWG1Hw+rL+D6zVp1bUt/8cm86caI1lKnfuIZi6y9VIn/bMiGfd9c4aZFhESKnGqpogn
 zf9g==
X-Gm-Message-State: ANoB5pkPR+okuImXRHB8KsVygY+hMU3jFP1X4xCHFCAK4mQ04enhxPCy
 ravV+6/Pa1pOmpPF750WDOXP7teTgiAOmw==
X-Google-Smtp-Source: AA0mqf5kngnEG6TtWra1+xFIY37aBRwogffq20uJpUzBVyAWsE1WUGsuHoa/DzL+7L0/Sgg0ER4DuRQldLsQMw==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1997:b0:219:8ee5:a226 with SMTP
 id mv23-20020a17090b199700b002198ee5a226mr29019577pjb.13.1670528387307; Thu,
 08 Dec 2022 11:39:47 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:44 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-25-dmatlack@google.com>
Subject: [RFC PATCH 24/37] KVM: x86/mmu: Move kvm_mmu_hugepage_adjust() up to
 fault handler
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

Move the call to kvm_mmu_hugepage_adjust() up to the fault handler
rather than calling it from kvm_tdp_mmu_map(). Also make the same change
to direct_map() for consistency. This reduces the TDP MMU's dependency
on an x86-specific function, so that it can be moved into common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 2 --
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0593d4a60139..9307608ae975 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3151,8 +3151,6 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	int ret;
 	gfn_t base_gfn = fault->gfn;
 
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
 	trace_kvm_mmu_spte_requested(fault);
 	for_each_shadow_entry(vcpu, fault->addr, it) {
 		/*
@@ -4330,6 +4328,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		goto out_unlock;
 
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
 	r = direct_map(vcpu, fault);
 
 out_unlock:
@@ -4408,6 +4408,8 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
 	r = kvm_tdp_mmu_map(vcpu, fault);
 
 out_unlock:
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b997f84c0ea7..e6708829714c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1157,8 +1157,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
 
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
 	trace_kvm_mmu_spte_requested(fault);
 
 	rcu_read_lock();
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

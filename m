Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1801E7B
	for <kvmarm@lists.linux.dev>; Tue, 25 Oct 2022 14:52:06 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id qk31-20020a1709077f9f00b00791a3e02c80so2921948ejc.21
        for <kvmarm@lists.linux.dev>; Tue, 25 Oct 2022 07:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iW7y1fLgpkJui3hvQxzLoNSX4KE+fgXa0IU1VCGorq8=;
        b=qJakZ6WY7j9J9m8Y0t0mKscdKtWoQFQZx/SlIwtmdVidxM8A5xf050QT9Ki74jQrL1
         I1jtlS5bPffVifc9+0ncXh2wwwFOzVaq6063eYqf/v/Pl2+CjzJRqU13Oz7kC4XO9shq
         rk7e1jP74dU+C6IgUOoa4PVz3g4RhXXyTqm6wsiEhNC7ZVMmHNQhgmULb6ksYf93T5Pq
         Hz1ccacdzLT7No3GpTOIBgRj9eUiZYuKalDOV91XpIhsNHChn2V7IF28NwUwvxVpR7ps
         7iqals/Wlf90wOzqbZc+9XGB9AKrzHp5iU5dKE+mCdqT+LlsVAHopgFQJUCQmhrKOdkS
         ENcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iW7y1fLgpkJui3hvQxzLoNSX4KE+fgXa0IU1VCGorq8=;
        b=4LTlhs8PvhHxH+HauA8US55y6td/9O8yfDOErPQd16R7oNBU8wJ22sW9m4bnog5Vrp
         G3NqszeK/+ua8ObWObpITp6aLjkXCj3hQz4/rn/8RrpgEr1t+YVA/ag6PIUUysJaBDV0
         u9mFpgwpk2hmGly03aR9GcdtOaKke8yZ5wl9mIk/gDlNwUY5suyReCA0e4EtbqEa88PU
         l7H6QyCYLrXpuIU9ynhK6WiaUdLOkyBbM858X4JzahyW74ACGeWa1Szp51r6bUZK2plK
         l6OzY8o0j6wDPnnhyh5p5qLpDPlwrpSEgRAWsn9K5rSuCrSCh0UaHqRJ3U+uMwdz1TaK
         J9LQ==
X-Gm-Message-State: ACrzQf1na6Jb7wrceNzdF420RHRDnlywfAiG/wHN7ZZIT+Uzcetas6Eh
	17XLqcB7hfm9ZmERyhBs9osoXZLvRrbR
X-Google-Smtp-Source: AMsMyM4BGDxK+RsryB8gWtAc8z+lfBDtIE7P/25DUQWrqxjJtocSP2UPxVASx3qt+ngO9qDF5OIYpYiVN++A
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a05:6402:d06:b0:45a:3ac6:ad26 with SMTP id
 eb6-20020a0564020d0600b0045a3ac6ad26mr36497510edb.195.1666709525134; Tue, 25
 Oct 2022 07:52:05 -0700 (PDT)
Date: Tue, 25 Oct 2022 14:51:56 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221025145156.855308-1-qperret@google.com>
Subject: [PATCH] KVM: arm64: Use correct accessor to parse stage-1 PTEs
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221025145156.ic0Tzhjun8lk11-pa6bYMOmDQ95EeYvzROBlrp3yx4g@z>

hyp_get_page_state() is used with pKVM to retrieve metadata about a page
by parsing a hypervisor stage-1 PTE. However, it incorrectly uses a
helper which parses *stage-2* mappings. Ouch.

Luckily, pkvm_getstate() only looks at the software bits, which happen
to be in the same place for stage-1 and stage-2 PTEs, and this all ends
up working correctly by accident. But clearly, we should do better.

Fix hyp_get_page_state() to use the correct helper.

Fixes: e82edcc75c4e ("KVM: arm64: Implement do_share() helper for sharing memory")
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1e78acf9662e..07f9dc9848ef 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -516,7 +516,7 @@ static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
 	if (!kvm_pte_valid(pte))
 		return PKVM_NOPAGE;
 
-	return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
+	return pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
 }
 
 static int __hyp_check_page_state_range(u64 addr, u64 size,
-- 
2.38.0.135.g90850a2211-goog


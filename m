Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FEB1CD1F
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727132; cv=none; b=SwsZMW+G7j2kJhk6++QAryOsFCIYX7TaK9nQdZFDdEbmccTrziGldxP/0uWC4UjpZUmM17HSwz+4dzN9ILn4yBbWnKj+RY7T2ttI3l7B7oYfuu0mU3tEtUqIEn/SVfQvoCaS6u+k5rQSQAH6vMXs/KzB5seY5fZ5lAdCop2B6QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727132; c=relaxed/simple;
	bh=cQFZKUNkNesOamlW7FrbWTKKfmpcC6n8YuDFlsfz03c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SmSHs1zwzoONoL90FPbNpJZFODV0EROoASmwU+W30Ga4wb5BhybxnEtVoe6eJqjl1UtjdcLIv1MIvENXxITegZcUecmZEKQwxhb0U4Yi/419rGm5C9BYjS3b6X47YSEBzjIDl5QrS562MWSmSaon6Itwa+uSBFMTGMq5IVZv6fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uwQcBG9W; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uwQcBG9W"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e59dc7df64so53895877b3.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727130; x=1731331930; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C3cxg1LygKNu1O6MtAV/wXocYa0JdKRd+G1uF5af3p4=;
        b=uwQcBG9WvjAcg+g4uaeqfYzN9yMLWoNWKmRxWZa/urIxbVsS5kUHssE1hSkRYnlYD4
         aULDFRK75vwkE93LpAxftTfR5sxf0XbwU1C8fET3wuFBThhmV7y7oG1dIvyLMvJjhXev
         VuPlSP+8knMfxvx8/d6C4Ha+ZyP1QrIy9IIfOxYTz5zldrEbfwqtLlrXbhKQpyn3Dla6
         FApjNSDNWqfEL6awtZOkEnApq3IgHLsJAISvxN0khC2aAgHEKtN+fE8xCxiZ+SvZ4sVe
         0RvLGgc1YBHtW/PjC87AMelRfe/1XIjxADR8wZsjgkhm+zxPiL2Ag6Wp8hKBh7TN3bua
         wOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727130; x=1731331930;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3cxg1LygKNu1O6MtAV/wXocYa0JdKRd+G1uF5af3p4=;
        b=bkAgJu55pcamGIe74qaQdF0fCq0LxqqZQdTTgPeRJQXUvbUfGVIUKRLhQZWyG3czbb
         Hy71G6otog29I7w50lcVAc6A7u0+mpCnzTfnPb++OHXFldbHbbCf8xZCKTGK7MPRBDQ/
         g4W14lLCfcMmW3QOsmdVstcPINXbtzV/FU0m24dMK68+esZT/JJik9GiD3nWB7iuYSUl
         k2S8l/Q50WPgPVTCY1+X+ywYpBrprKdBmyHaYw4uXdXUPp0hw1ref/u95T3lIkvQzOk4
         2QYmAdm+8oFilsyENBqnjaUnyUpPcaADSxRAD/2Y2CnbH3FddhK4JxRAQMOuGfU78Ico
         qPbA==
X-Forwarded-Encrypted: i=1; AJvYcCWwWCBi6hRf5fRA68ROr1EbrCHFuJPxmCdX2gqL4YJ0mS0kmWdiiPsV1evMINEC2sahVRKkrxQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywri9A3AtwuNtTul13n2U3Yosjx+HAxrjiIhd8ec/lKVnOL9vu1
	mhG1K10eVuvDMn8l+CbFVTVcAuMp8EwW2pKcOvO3gW/630vEDr9c8UQIBKuW+4R9gd+vNMqJX1g
	wEg62nA==
X-Google-Smtp-Source: AGHT+IG4oLvWKjpenUPcwb9MUEXuA4k9iUal4VcJqIm7bVxly8pKYoHiLyM9jmlzbnyR07kVBLqdiArEOR21
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a05:690c:3603:b0:6e3:ad3:1f19 with SMTP id
 00721157ae682-6ea557a7a11mr2085187b3.3.1730727130106; Mon, 04 Nov 2024
 05:32:10 -0800 (PST)
Date: Mon,  4 Nov 2024 13:31:47 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-2-qperret@google.com>
Subject: [PATCH 01/18] KVM: arm64: Change the layout of enum pkvm_page_state
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The 'concrete' (a.k.a non-meta) page states are currently encoded using
software bits in PTEs. For performance reasons, the abstract
pkvm_page_state enum uses the same bits to encode these states as that
makes conversions from and to PTEs easy.

In order to prepare the ground for moving the 'concrete' state storage
to the hyp vmemmap, re-arrange the enum to use bits 0 and 1 for this
purpose.

No functional changes intended.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 0972faccc2af..ca3177481b78 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -24,25 +24,28 @@
  */
 enum pkvm_page_state {
 	PKVM_PAGE_OWNED			= 0ULL,
-	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
-	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
-	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
-					  KVM_PGTABLE_PROT_SW1,
+	PKVM_PAGE_SHARED_OWNED		= BIT(0),
+	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
+	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
 
 	/* Meta-states which aren't encoded directly in the PTE's SW bits */
-	PKVM_NOPAGE,
+	PKVM_NOPAGE			= BIT(2),
 };
+#define PKVM_PAGE_META_STATES_MASK	(~(BIT(0) | BIT(1)))
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
 static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
 						 enum pkvm_page_state state)
 {
-	return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
+	BUG_ON(state & PKVM_PAGE_META_STATES_MASK);
+	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
+	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
+	return prot;
 }
 
 static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
 {
-	return prot & PKVM_PAGE_STATE_PROT_MASK;
+	return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
 }
 
 struct host_mmu {
-- 
2.47.0.163.g1226f6d8fa-goog


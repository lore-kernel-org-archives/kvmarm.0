Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194BD207E03
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371890; cv=none; b=d/3A2vTGuYgtYyBwXmRjVE0NpaHHtkKjf19dB9id4gNqyBWA8ph1xHNZ35c7vTC56TgffWUHMaa4NagiP1xGwRyAGgWMCu/ivYoFEo8dsR2Eg8L8gDxyGkuLovMxhSEe05DPIUIURCzT0NFwf6gEMTblcwydSwNGtpIhJ9WXA0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371890; c=relaxed/simple;
	bh=c9TuY0JzEDJDlz8409s4LmorQWb/6VBYImcN+XUquJs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=stYkfOdsj4rFrev/jf+jYP2eLmu2sNHDXGS5oNC3R/41s0L4rgnkzmoDhX7oWFWidcSQE5LDVVacQmG6QWgJqL2oDijKT+vckiaD4RV+dDwpvmQfn1/XiBZffMcrwt3lncXLvs72J/nAmZX6fJDSVVL5r/c5Or3ox38rnG9KYNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YTEvJFWY; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YTEvJFWY"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aab954d1116so273117866b.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371887; x=1734976687; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zm077LWUklom1qgghNmApFcV7NaUdG/wSJAtTBhffFY=;
        b=YTEvJFWY2X50alWlN2zMCiyBzAoQ7RYC8J/aDPUqUkpi9LszIzn8A3U1S7yi4m73Cm
         52AdlB3bo3bAdJracrXeAzYZD5eWL550cw5z6wT5HjYx7yvMqngXFoTw+SoEkdb3Kua7
         dDITjtIjwbregv5SZv22k6uCf+DVPRTZtKZQGZkUBhxbyTKNzqve6Sj4v3liI4QteGhF
         LnKTaxYOvssGtStZt6ACsciOBEnbTprRM3oy4WqZy4CRFFC31OuPayr1DHMC00Ut7ZaI
         gSZtoGF0ZJchp/OkNb2MtUm62TwvaOkRMSpioShXAq4WxcotT8LeE8w9Tw8NRirngZZk
         bNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371887; x=1734976687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zm077LWUklom1qgghNmApFcV7NaUdG/wSJAtTBhffFY=;
        b=tsPnQDCYUrH5jIBFi2HxBzAK7+yf2upthA4eyIEm9D2MISSu95h22U61hRnzA7l/Lw
         CCzJ+t+jf2vbbdHweZ7/dxWMVev2SlDuatUc4sWFl+VtgOqRDOrwB2gsYVAQcXl3M5MV
         yogEPQjFbkCPy8dnbqHdwZJ3JlC2gEF1H07nW44InSATkyOT0KNOOQdQg+aMLCeEHb2M
         knaFONlLuMO1OkC1Ku9GfbwhBau+pTuZ138weIClzNmH+GoEgVIwF2Qd64izrAPAHNtz
         D35erTfk2C6uhpE3WfpLmLDEa+tTsCikgS+llo5nxd8Knik2YKm929ZqnKumOj7aAYXk
         hirg==
X-Forwarded-Encrypted: i=1; AJvYcCWAhtYJxVodPLPk4ia3sZ2BGhZR4Hg7p2aACfPDX85W2bmsciXo0cA0HL1uJyBYHpV6rKObKI4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjfaoaMlbF58EuOkJVXMOyEj5Xn3AZfRXgKtpSE+lbQn2BrYuh
	D3DrFL92i3X31yP9nOcB0a6stxTiAhXsFuTl5k/aqMEq2VGo23utiXDaFfNdHaPWJ4iFg71d0Kr
	f3AgEKA==
X-Google-Smtp-Source: AGHT+IHQ5oA98sWMNkT9FIe7HUKG7DjxRL6Q1mhzqfn466rudnNmwiDaQ8QrHj3NSSmISVUj3n4MBHY2yXmJ
X-Received: from ejctj6.prod.google.com ([2002:a17:907:c246:b0:aab:70bc:648c])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7ba1:b0:aa6:894c:84b9
 with SMTP id a640c23a62f3a-aab7795ff77mr1374185366b.23.1734371887552; Mon, 16
 Dec 2024 09:58:07 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:46 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-2-qperret@google.com>
Subject: [PATCH v3 01/18] KVM: arm64: Change the layout of enum pkvm_page_state
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
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 0972faccc2af..8c30362af2b9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -24,25 +24,27 @@
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
2.47.1.613.gc27f4b7a9f-goog


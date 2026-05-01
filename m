Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376CD39EF02
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634515; cv=none; b=Ididu3rCRp93DchxDUINj3chF7NbkhltKTNBVTz+AqjwlLpZYN+F5ndTEiMouiUYDUiBWeTm25pQXxYkvUZ4TRfe2JEpsRiAbjLWDhkO6RVght/0LQHcZOk9NCpGZCWqbQO0XyEUlDgxhUREO1kBmKfbFQfI1S4JqY/3nZb9CrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634515; c=relaxed/simple;
	bh=zyuV3AiKNchX6U73Dh4EBSlCZOT6K6NOUGVwnjSVKJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rW6a+GIAv39Ta+49LpRV/TH4jUQdVrlzGDH+Ff7R6nW6N48BgDwY1srz5SjNgCWWo0F7f2PGLqHQl6wrfWiBpLjNLLvtZ3oKptGWz/pAwPil5RJ884Mmjxmne0J6JltCm09VDMp5mo1LwQGSlfCUx6eR736Grz2MRIYsqJt7Yws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wlQa99AN; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wlQa99AN"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488c2cc0cbaso15948335e9.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634512; x=1778239312; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hoZhqW+DbuvcNP5ZEEtFHwCo3yR5b+Lks488o9s6mbk=;
        b=wlQa99ANWhFcpNoUh2Aqeu2Y3rEUF4FpSeLngBdbr9FgHaNdsnbUIkxFSKKom8g9Ws
         KaU0E1lvsm+aKKbvJ+pNub8epRuRMVcrsdUUz0rzXwumXbKCq7+xcymbs6lK835RrWRa
         LqHBVUMEXkkIyHUcbIjAtquHW8EbmFWwxwty8/VdeRZ305Fz0korOmKgdhVpmlAN0Yqm
         +sheESGlVmONzEJo01KjrG+Tevoiwrnb/6/6Ns/Jug7C+is5uTEDK5REBDYdtk7jcr7F
         XydEFlKhmBOm4P8kT42PM4BHmt3h7AAIxwf0DHosoHlo0EX4vxkAQ9J8f/rtcYzaganF
         3glg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634512; x=1778239312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hoZhqW+DbuvcNP5ZEEtFHwCo3yR5b+Lks488o9s6mbk=;
        b=fO3YVJJMjb9ObKO60eQQ6NbmWmMby5tyJ8yDMoHeO4GZ2ShDpo0WfZ07kuPMm853du
         bweijngpBUODmffVdFK7RqUR3YjZkmj3Ebnyd7AFoOFF+PcLBjHnhWOK8QtnI7hBXQ0Q
         UtIge+tCGKKpyDkn/Mo42bXvOR8hdt+AH3bd5ICdZ3hRFK+07azQcABHR/e9s5NSwnN0
         D1cwAsMAy5/uy3pHfaLe87Z9WCw/sz+7GQVssMGIVpEfc0zM1jWc4gkwj0Vw6Z73MH1U
         tcg5/MjpZs4taDfWNb6thmbS1FRZGQWRLoZu+jnPerNfqxifyyPXyn9JVLqDD0bc0iSn
         ksuA==
X-Forwarded-Encrypted: i=1; AFNElJ+gHrdgzLEcRaKPw8SP1q7TyzVQMzEF13EI+MEDX4Lae640a0ge/RAKUmfXjTpdG3SNGhSLm8c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxE2yZ8ridz+C9ZbL1HvL0ELPv2aOqKbIackun6+VkigkUplgZv
	pk38fH45RWielDSpL17/lh0dfsclwH76rQxflO06ZQqZljdcgDbSg52+Ph7zqIWcnmp1lVAJxmI
	v6w==
X-Received: from wmbhu22.prod.google.com ([2002:a05:600c:a296:b0:48a:5c24:d305])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a30b:b0:48a:58ae:993b
 with SMTP id 5b1f17b1804b1-48a8451cfe2mr82955875e9.16.1777634511757; Fri, 01
 May 2026 04:21:51 -0700 (PDT)
Date: Fri,  1 May 2026 12:21:44 +0100
In-Reply-To: <20260501112149.2824881-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501112149.2824881-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501112149.2824881-2-tabba@google.com>
Subject: [PATCH v2 1/6] KVM: arm64: Make EL2 exception entry and exit
 context-synchronization events
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

SCTLR_EL2.EIS and SCTLR_EL2.EOS control whether exception entry and
exit at EL2 are Context Synchronisation Events (CSEs). Per ARM DDI
0487 M.b D24.2.175 (p. D24-9754):

  - !FEAT_ExS: the bit is RES1, so the entry/exit is unconditionally
    a CSE.
  - FEAT_ExS: the reset value is architecturally UNKNOWN; software
    must set the bit to make the entry/exit a CSE.

INIT_SCTLR_EL2_MMU_ON in arch/arm64/include/asm/sysreg.h sets neither
bit. KVM/arm64 hot paths rely on ERET from EL2 being a CSE, and on
synchronous EL1->EL2 entry being a CSE, to elide explicit ISBs after
MSRs to context-switching system registers (HCR_EL2, ZCR_EL2,
ptrauth keys, etc.). On FEAT_ExS hardware those reliances are not
architecturally backed unless EOS=1 (and, for entry, EIS=1).

Until commit 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg
infrastructure"), SCTLR_EL2_RES1 was a hand-rolled mask that
included BIT(11) (EOS) and BIT(22) (EIS), so INIT_SCTLR_EL2_MMU_ON
was setting both unconditionally. The conversion made
SCTLR_EL2_RES1 auto-generated; because the sysreg tooling only
models unconditionally-RES1 fields and EIS/EOS are RES1 only when
FEAT_ExS is absent, the auto-generated mask is UL(0). The seven
other bits dropped from the old mask (positions 4, 5, 16, 18, 23,
28, 29) are unconditionally RES1 in the E2H=0 SCTLR_EL2 layout per
DDI 0487 M.b D24.2.175, so dropping them is harmless. EIS and EOS
are the only bits whose semantics changed for FEAT_ExS hardware
and where the kernel relies on the value being 1.

Make the guarantee explicit: include SCTLR_ELx_EIS | SCTLR_ELx_EOS in
INIT_SCTLR_EL2_MMU_ON so that EL2 exception entry and exit are
unconditionally CSEs regardless of whether FEAT_ExS is implemented.
This matches the pairing in arch/arm64/kvm/config.c which treats EIS
and EOS together as RES1 under !FEAT_ExS.

Fixes: 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg infrastructure")
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Assisted-by: Gemini:gemini-3.1-pro review-prompts
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 736561480f36..7aa08d59d494 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -844,7 +844,7 @@
 #define INIT_SCTLR_EL2_MMU_ON						\
 	(SCTLR_ELx_M  | SCTLR_ELx_C | SCTLR_ELx_SA | SCTLR_ELx_I |	\
 	 SCTLR_ELx_IESB | SCTLR_ELx_WXN | ENDIAN_SET_EL2 |		\
-	 SCTLR_ELx_ITFSB | SCTLR_EL2_RES1)
+	 SCTLR_ELx_ITFSB | SCTLR_ELx_EIS | SCTLR_ELx_EOS | SCTLR_EL2_RES1)
 
 #define INIT_SCTLR_EL2_MMU_OFF \
 	(SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
-- 
2.54.0.545.g6539524ca2-goog


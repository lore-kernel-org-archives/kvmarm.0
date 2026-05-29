Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954773E0C71
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 12:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780057085; cv=none; b=mNxQfB045lIaOiFk8/6YJ/asgHPih/miO1joW7w87XGuGF82J4CKwruwGhA6sh2AHNBFYzPGZB9JbOu43KapCiIaNBM7rGxzjxrB37OJZgbpmrZG7Gj+YES4UCFFyxmRJ9ka0PpXFG1f5ivdzJJ6j6DaMWuesyESslhQrXyx/UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780057085; c=relaxed/simple;
	bh=8w8KTrWj55Nni7jeJZogBJiEHTgA+V61G6RhH1ALm3Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CNvaYHGRxop7YMEeEV3Wppt8QS+GWsYj7ie9BYNx+oCziDQ2rE3TwId1/aBr+OXX7eKsV9jb43ztUqdJ7tgHEdxJ5nX8+2Jx8DVoqHVOnFy/5h1I9yQgJbn7SIgH+w/dPNs0p83JgB0Ur2ZhtJ8MjuGRHCjrZupPCswQhNay75Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q1QKe8Wa; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q1QKe8Wa"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48d127eb013so66900925e9.1
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 05:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780057081; x=1780661881; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YSXsbIdnWInVilAPlZA6JhRFyCgRtF4/KyoHf0/oPWY=;
        b=Q1QKe8WaUHa/o0xHqMZWPxOxFhui+4xYqlouH8di+X/0boiflv3YAeR+ivy0vIy8ho
         bu9hwgtEZgR/9NGYqeYlscUd3QwgN9r5ooaoaV4DSnB2ayE5nbmDWBL7M5yI1w8+2tGL
         uC2VdlU9PSSf/bNfh89tt05yK+lKjGb1bJtcfCprOssBomC2KShYgMoxb+UAjTNdMpge
         R3lTclbmobyQs3G+oAAMWS7Zk2HZMW8siGrJWM2NzjLvkATK4O6nwuYioR1ow+21QQWX
         crOm1/YJw4MuBT6RLIdviqq2cWeJ+2Vss/jvYWJcG4k9EgyAMjunmGni4/1PmO1u12Yt
         QGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780057081; x=1780661881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YSXsbIdnWInVilAPlZA6JhRFyCgRtF4/KyoHf0/oPWY=;
        b=RH67Ue/V68zE3JYzyhvJh1zlJzmKdVMXvtKXl7JhAlK+sA5zSURNFTYBtUNGGcem5m
         8hQRViRuQBt/B/YM21BRG4TfUXY3/Hti9XRFHUi9Ag6BTefpWUnVN4i/GsSYTt2MsHob
         lzSZPYPERRdzk3qVSlsOtQU/1DhuoRQM7Tf91vuNbE2dNQ7ErE8oezeiFowvBVJcH8L3
         eCmQj8DNXMAhakgOHhisypK+NHXfcfIvX41fWltUgYpXo3KMHIqhhiA0zigYXBeZFz/d
         3GQTstVdnc9qCLLmMRvCA24UReWo3MVeE4UJcnKeOfogfVoZw1s4wZFlf/aHvDR+osFc
         mkVw==
X-Forwarded-Encrypted: i=1; AFNElJ+8mG7u1GikenyyLsoS4TrlisiYGgCmVspSK6PLH1xh1SSBQE1fWb6sNPpjpzX+7npsuL4utsU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/ilMmifK4Ij7urLmhNHnQaub13mDta0ZtPygdSvhjsoTA0Ygq
	3oaRKkB8m8ecDCZccjs3NjyapL5b0sa56vEj9JZmGia/XCTTTAY359a/hk8RranGyGyWOU+7f+R
	Jnw==
X-Received: from wmqa18.prod.google.com ([2002:a05:600c:3492:b0:490:538a:ee3a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a00a:b0:490:9d5c:a3e0
 with SMTP id 5b1f17b1804b1-4909d5ca570mr41853905e9.9.1780057080700; Fri, 29
 May 2026 05:18:00 -0700 (PDT)
Date: Fri, 29 May 2026 13:17:55 +0100
In-Reply-To: <20260529121755.2923500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260529121755.2923500-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.929.g9b7fa37559-goog
Message-ID: <20260529121755.2923500-4-tabba@google.com>
Subject: [PATCH v2 3/3] KVM: arm64: Roll back partial shares on
 kvm_share_hyp() failure
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_share_hyp() shares a range one page at a time. If share_pfn_hyp()
fails partway through, the pages already shared by this call are left
shared, while the caller treats the whole range as failed and never
unshares them.

Unshare those pages before returning the error. If an unshare itself
fails the page is leaked: it stays shared with the hypervisor and is
no longer reusable for pKVM, but no isolation guarantee is broken, so
WARN and continue. Not expected in practice.

Fixes: a83e2191b7f1 ("KVM: arm64: pkvm: Refcount the pages shared with EL2")
Suggested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e08503e89fc4..8811ad60cf72 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -544,8 +544,8 @@ static int unshare_pfn_hyp(u64 pfn)
 int kvm_share_hyp(void *from, void *to)
 {
 	phys_addr_t start, end, cur;
+	int ret = 0;
 	u64 pfn;
-	int ret;
 
 	if (is_kernel_in_hyp_mode())
 		return 0;
@@ -567,10 +567,24 @@ int kvm_share_hyp(void *from, void *to)
 		pfn = __phys_to_pfn(cur);
 		ret = share_pfn_hyp(pfn);
 		if (ret)
-			return ret;
+			break;
 	}
 
-	return 0;
+	if (!ret)
+		return 0;
+
+	/*
+	 * Roll back the pages shared by this call. A failed unshare leaks
+	 * the page (it stays shared with the hypervisor and is no longer
+	 * reusable for pKVM) but breaks no isolation guarantee, so warn and
+	 * continue. Not expected in practice.
+	 */
+	for (end = cur, cur = start; cur < end; cur += PAGE_SIZE) {
+		pfn = __phys_to_pfn(cur);
+		WARN_ON(unshare_pfn_hyp(pfn));
+	}
+
+	return ret;
 }
 
 void kvm_unshare_hyp(void *from, void *to)
-- 
2.54.0.929.g9b7fa37559-goog


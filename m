Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512683E0C6F
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 12:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780057085; cv=none; b=rOkBvY+TRMV7QPIkwMGmowDoFusS0cuaZ+/57ONnuYrkgYvBIZFXgkn+rMIRZJmhJz0io8TmNue90zkME1mN/f31evGkWugBnAXvR9fUKkVe7MhgYoScWA0I6P0x5AyKozfaXKZNsRC8ZG9/tyyGR48ceDmmEj04sdc6aN2wnZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780057085; c=relaxed/simple;
	bh=fdzmWxJGLz9AlLzramjJVHM/pqkHYN7czqaULpgkQ/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Eq55MCIkoOYISchjDKMHWRr0BA6+qxFo4j9g17vmEJBaQ37zabgTNMqWLSjYvGsO8V2mUmT/sn1CqlFxoZglKHLnam59n56gXga3EGAhDnrpPKE7uu65cNxM0ZPH3pblXD6D9Dt12TGH6bYJSqPSY3OHojmaIQt5NIh94mZSB4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CrIVU/9Y; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CrIVU/9Y"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4903dcb32f8so68477665e9.0
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 05:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780057079; x=1780661879; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OefBi9Ucl75C903M9JEhzfF/8vc9lZTl6eXKcY7A1xo=;
        b=CrIVU/9YhQN3ewiNlmuip6U0jJEb94+c0J9eUzGBMxakT/fONB0EHLAUcF6euOR27S
         pkpfhFAx1YwrjuGs4TLUEZ+AsaUZIl2bvZBQomKbFTRNLQVpjB1ldYz4hyV/aasg2QOk
         3EeXdOPz/IujG0/pueHwV4t2Af8GR1B80ExWVhLk/e9l6H1gDTWA8iX4qS/YA557G4dS
         DeGcTHOIod1bPGGQKxiOFIQXhHx0YhHwEQ+kQHD2Szvqp2AiEjkVlFbF8oBbbc3GTpfy
         OL3bLl7upNr3h1+T7PvjXNup8oDVTmV9U0kDdcpxAMYAD0YReUNXHr2kWEoqfbmoK23Z
         Vjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780057079; x=1780661879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OefBi9Ucl75C903M9JEhzfF/8vc9lZTl6eXKcY7A1xo=;
        b=Q76xwLVn8pxAnUtNj2+L/m/dYtfAGgPePsgh2iWEwwuUfHTpfhwmYq1iWZP9lZ6BBk
         vSZk01EN53qGWBy7zsh1C27GrRn7AunDr437fRTcRguI0WnoGuRxIrT+ZUvIiCdwlrxN
         Fh7/T2MGy9aroIPaIrqBG9bnJtU63Y7nBdoqluN48cpjuSbGzRmlOUVm0zNc78NMzjFe
         EvMMoNHYYxrmBOXfzAi+Wp9Q6zy3JMDxL2STwuZqDQZaYtTtBlRM+sOJLd6kFI35mfJb
         uuSG5ivcRTphtZFYrl5ZTPS7GRci/wDWGERvjEGamDiUHNuQxJ9y6Oll34RAzxnDhEwt
         +1dQ==
X-Forwarded-Encrypted: i=1; AFNElJ8dmWtpMqm12W/SIM7eKSfoHLFJD+TKPWOwzFjWf93Zu8RM3t+h1sJcPW63z1Yrke6JLt8Gs+8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzvuVOKz7MypBZrslk/pxUqwp0PytCBxjjRfqe217gDZ1oII47v
	VWrGaakw0Z2L4p43ZSbqyjZUI7EyA5L2jRgbnSQZk9ioThwArtkDV7lCsiNNbzvjEPLG8D5w1HT
	8Vw==
X-Received: from wmbgx17.prod.google.com ([2002:a05:600c:8591:b0:490:11e5:b5aa])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6008:b0:490:44eb:c1e0
 with SMTP id 5b1f17b1804b1-4909c0ac911mr37129365e9.21.1780057078508; Fri, 29
 May 2026 05:17:58 -0700 (PDT)
Date: Fri, 29 May 2026 13:17:53 +0100
In-Reply-To: <20260529121755.2923500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260529121755.2923500-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.929.g9b7fa37559-goog
Message-ID: <20260529121755.2923500-2-tabba@google.com>
Subject: [PATCH v2 1/3] KVM: arm64: Free hyp-share tracking node when share
 hypercall fails
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

share_pfn_hyp() inserts a tracking node into hyp_shared_pfns and
then invokes __pkvm_host_share_hyp. If the hypercall rejects the
share (page-state mismatch at EL2), the node stays in the tree
with refcount 1: a phantom share that leaks the allocation and
that a later unshare will trust.

Erase the node and free it on hypercall failure.

Fixes: a83e2191b7f1 ("KVM: arm64: pkvm: Refcount the pages shared with EL2")
Reported-by: Sashiko (local):gemini-3.1-pro
Suggested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4da9281312eb..4a928fb003ff 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -501,6 +501,10 @@ static int share_pfn_hyp(u64 pfn)
 	rb_link_node(&this->node, parent, node);
 	rb_insert_color(&this->node, &hyp_shared_pfns);
 	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
+	if (ret) {
+		rb_erase(&this->node, &hyp_shared_pfns);
+		kfree(this);
+	}
 unlock:
 	mutex_unlock(&hyp_shared_pfns_lock);
 
-- 
2.54.0.929.g9b7fa37559-goog


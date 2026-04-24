Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936243537E5
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 08:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020555; cv=none; b=ABGLVEP+X8GNammXsqIBoZFREo/GkyyVrk2ajHvCcHc3NlcmOClDKKpn+wGeLDpZ2+qUo0a2enRX9HItPCbp6dqypRsQWFZVKZh9wDQYDPKfWzmwtinOcsIYr+8nzXdDOBl197hEYWN0rmERhrGGHqTxAIPq33B09wBsTG/XStE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020555; c=relaxed/simple;
	bh=1lCa0fGJkv3iZRPlrHk4ryZeg4c15YmUkb8vMfqEOL4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KtHVbOdkrqhyuXnFd4MHv1M92hB21b8CXOkwI/ZUn/inDLR2tOFvE4QOyagA/FCVukZuIGUc6vhOPXUNX617S51r0brBD7mR6Hg6jsmaE4TTJq3Rk4/cDK77JpOxVM2gZ/KJ7eDBkD2W248RXeLUg1Lo4HQKQ5JhdkAElYid5FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gjCt/yvs; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gjCt/yvs"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43ea7a5da57so6110736f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 01:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777020552; x=1777625352; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XShP+UFGcHA8+NRAMytT9G1kOFOShWj4IGMrrTJlFSk=;
        b=gjCt/yvskt2kp3gsdxXRBHopW5jlrFs6Cl/FQPR6tuijvWfvDrHFuzOr1YNeznnpOr
         ZH76mF2No/TcgTT1Ynbdx7eP5/9D+BbLLBOHUbo892b0CtFfOPW98r9e6fpbvG2fbDRR
         XTDcTy52vOhpHIkCI+Ii1WGfWIcAPdematJeb8rBMGL5K7x29tstKj2h0nEZYQy91f6J
         4i8MNeG9T415pqBPo72kaexak4rbfdp4Sfpe0D21L51982x7NOpEl/U8Q15Q/GHpJ451
         pn9y5LYWzp7IDuzipb+1NZoSdBpjbxom5HGUp1eTg2a1IPTYpTdZP1nKD2LSsQDJU8GE
         vi+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777020552; x=1777625352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XShP+UFGcHA8+NRAMytT9G1kOFOShWj4IGMrrTJlFSk=;
        b=ATuO940McLHn8iYW1lmaS/to0pE90hcGD3Th+FIQibr5QNXbV/3EfPkBHwAgmYiblQ
         T3e41ltyfWzntL11kMGuOKvkeg9P89Cf69/xoih54Dq4DEr25V9HQezIqYueE30XySft
         oN2hgzhihv1gk6hBovsFnF1ueTea1c7Lu5bCEUiLBhwXgvG++Syw68F63evWGi2mH5C3
         I/lgWggK26ai2zoPqAbjvX8Tp069XOX6NIsAA2NgwicGtmvSXNYWVgS4VM94nJdT/CCi
         KGdBlDPeaoLFwL+7Nd77z7XXuj1J04mv/zdauYcmBEtOftJek2RMf+9HRm8Zi54/QbY3
         kwOQ==
X-Gm-Message-State: AOJu0YzRqvLgQTJcnrIsdNkQMTHBzQJe0GTdxiJ6DMBn9lKVigAdK7Zx
	7KD84xawf270QxMfQPZeBlWFzE4q9VchFBUoFVGE0JAav0kX63LZNsiLJYYAnzswZ/PMqQXOG41
	AIb7D9mVQ2O9nYBMbPd/zLvvqnlKpQ6QvhWtVMnLtsydpqHPWTJJfEXa/HQmvvMBnudcYNbowdv
	Q+QXKmVZ3e6wgjKw4xMdW4pHtjuh4D1PQ=
X-Received: from wmjf15.prod.google.com ([2002:a7b:cd0f:0:b0:485:37cb:adc1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:8447:b0:489:1ff5:edda
 with SMTP id 5b1f17b1804b1-4891ff5efe1mr218011645e9.6.1777020551865; Fri, 24
 Apr 2026 01:49:11 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:49:04 +0100
In-Reply-To: <20260424084908.370776-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260424084908.370776-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424084908.370776-3-tabba@google.com>
Subject: [PATCH 2/6] KVM: arm64: Fix typo in feature check comments
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Cc: tabba@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oupton@kernel.org, qperret@google.com, suzuki.poulose@arm.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Revists -> Revisit. The following patch will add another similar line.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/config.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 093290b366e6..a722ea178f68 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -283,7 +283,7 @@ static bool feat_anerr(struct kvm *kvm)
 static bool feat_sme_smps(struct kvm *kvm)
 {
 	/*
-	 * Revists this if KVM ever supports SME -- this really should
+	 * Revisit this if KVM ever supports SME -- this really should
 	 * look at the guest's view of SMIDR_EL1. Funnily enough, this
 	 * is not captured in the JSON file, but only as a note in the
 	 * ARM ARM.
@@ -295,7 +295,7 @@ static bool feat_sme_smps(struct kvm *kvm)
 static bool feat_spe_fds(struct kvm *kvm)
 {
 	/*
-	 * Revists this if KVM ever supports SPE -- this really should
+	 * Revisit this if KVM ever supports SPE -- this really should
 	 * look at the guest's view of PMSIDR_EL1.
 	 */
 	return (kvm_has_feat(kvm, FEAT_SPEv1p4) &&
@@ -305,7 +305,7 @@ static bool feat_spe_fds(struct kvm *kvm)
 static bool feat_trbe_mpam(struct kvm *kvm)
 {
 	/*
-	 * Revists this if KVM ever supports both MPAM and TRBE --
+	 * Revisit this if KVM ever supports both MPAM and TRBE --
 	 * this really should look at the guest's view of TRBIDR_EL1.
 	 */
 	return (kvm_has_feat(kvm, FEAT_TRBE) &&
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A38B3F44F3
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785020; cv=none; b=nFT2crKWX3uDP6hq0D16R3WnQ8KjSym280/piJp/9htjk1+jX3rv2/2g7BPoE6PNYmA4J3goLYBdkrwWe1mMQfXGfcnEmC5Iwm6zkiD8yGeyAZtaTbBOOXIoEedY0a3TThZ20K8rkvW6jUDGoVCNNca3itjJDuEKLJuTFSf9Res=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785020; c=relaxed/simple;
	bh=j3rEYP7FiUuGbQ4RpO2XU0IDDF9AfVNcqI5J1SlJhcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PyrWNz3ksRO31ULdaFW1OQxk7JwNE2oNOOJbTJAapMFJ/UVQJlsG2rUpMdboxx8vJUi4g5pgl44g8EwpJk89Wh8zH23yex4FLUtcPaTZ7WzdfmZaoOqdXpq9vpz3QY+4CfTUKTO6s6Vu55YhXLb3jsVOKkVDWlk1qQQn5fjYQIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XCCvSah4; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XCCvSah4"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b61243easo9711875e9.2
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 05:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781785010; x=1782389810; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GSfLIh1ia8h00/76vM0zOwIn9wq6bVKngqqirdlDuHs=;
        b=XCCvSah47vG+q0+r2EFVOnDSJNeowMyypcE/C8sZClvQS+7xcuagWyQ38FLn6imh4O
         UgtJiHR6MHLcUJdPS1sXWvRP+r9Ya6srmL0TrQYnwSC1bbCxfNVnS2+P1WB8f4+/WUWg
         iVvqiIWmmTMz0npDzNdoCS/9UvWiGlttQwdYMw2c2DMXpxQ+WUxfyJdbDDNudxVq8egR
         DYAjxBQ+CG5sLNvUSGeu7d4cz/bs8o7e4GruLh57VgYbBWz0xgxrMMJ3m91geMX2FvOe
         NZkxj0u2eqHLTH+b/Ab4UX64FxB6m8vHPJqStXHqk2vkbbrW4OPtg50n2/srp2prefCv
         o6BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785010; x=1782389810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GSfLIh1ia8h00/76vM0zOwIn9wq6bVKngqqirdlDuHs=;
        b=mTXQjGZmyFNUHXqw3UB2LCQ9swdXfuN0PQ5kYjqOmNHqUPM/egyAy3v1e/eCXjIo3g
         kY6FqdVCRYDRL6iE+qm4aVP+NjTHc2SlkyiHD2K3F3hxKHGquqVsCdhTsKOZBGDf/cpI
         Hl5xNj+aGD/c4+Rat7ZZWYdIk+slzfmZnFMoLqZgHzfVXQoVkI8aQqxJfhbfjTdPYhxb
         6AfICcC7mLgiGo6+tBhdi7RGApZP6Dm1IK1N+hv93dC7iTI3vit/sHhKvyLnkUDBBPbq
         8CFyWSvM6xmWndaeYOCbQvdw+Lzs6H5TsR1lZCMplDquwd2R4KuXO3LM3ppc7YArtbCs
         7xrA==
X-Forwarded-Encrypted: i=1; AFNElJ8Pqj3UxhK+j5rbGydS7CkjcbpN70zpcOznh3qLH23USH3FfHV8MLMyjZjkUT4wVtzqNIt2ulo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhOtB7plp+MgPAK7IQCMrxgtvcFVb1/hc/f8qZOLxuwYRDcwJI
	cDhiRSIXZXXttjf/FYHcWC/G6Ti0GSNj6QoKPHuVtEP7wrNw2yfF8L+c36VbNUFvDhFAHTZfqFf
	paQ==
X-Received: from wmbjl3.prod.google.com ([2002:a05:600c:6a83:b0:490:46a4:b11e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e0f:b0:490:e5c1:b88d
 with SMTP id 5b1f17b1804b1-492333babfbmr148040435e9.1.1781785009399; Thu, 18
 Jun 2026 05:16:49 -0700 (PDT)
Date: Thu, 18 Jun 2026 13:16:40 +0100
In-Reply-To: <20260618121643.4105064-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618121643.4105064-5-tabba@google.com>
Subject: [PATCH v2 4/7] KVM: arm64: Set IL for injected FPAC exceptions during
 ERET emulation
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The FPAC syndrome constructed during nested ERET emulation does not set
IL. For FPAC (EC=0x1C), IL reflects the instruction length. ERET and
its authenticated variants are always A64 32-bit instructions, so IL
must be 1.

Fixes: 213b3d1ea161 ("KVM: arm64: nv: Handle ERETA[AB] instructions")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index dba7ced74ca5..b74369e9ad7f 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2776,7 +2776,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 		 * ERET handling, and the guest will have a little surprise.
 		 */
 		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE) && !(spsr & PSR_IL_BIT)) {
-			esr &= ESR_ELx_ERET_ISS_ERETA;
+			esr &= (ESR_ELx_ERET_ISS_ERETA | ESR_ELx_IL);
 			esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
 			kvm_inject_nested_sync(vcpu, esr);
 			return;
-- 
2.54.0.1189.g8c84645362-goog


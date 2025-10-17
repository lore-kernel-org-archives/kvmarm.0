Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C6B2550A4
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 07:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760687843; cv=none; b=VGB19dLawkze7gdasj3rtkXSeGAP6e2gmUmG35N2IDHqUmJ4d9/3rS6z1PT7Ef3x2uqyCybEPVfFP2ysC7F10NmSpJiyWL5JBgp+qrkKqGlUlxwA1KMZs2CZRg6uznH/pbYceOkVvsCyT6nKdeKHk/fmS1J2SbmEdu4mBaUM+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760687843; c=relaxed/simple;
	bh=v+cwEQu/l0K0aFYXom/va+vqcAeLTQs97OiCDReEkHw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nqt8kUDW0Bx6MiS8pwTv2MTfIYqXic4Kb2K+qtlC7EkuSvTku8tQAtTJsJVQ6Rrih0If6CYWxp/LQD285cAhHPh8ESpHulk0QmMy86gPIRzJRbdu5dkrQSiSWTuXE1mvehfzCaxEx6bsFKWK36V3ni47NSuvgQJbVKf1pk3Qi2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dG0WWJxc; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dG0WWJxc"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-62fcb646334so2302194a12.2
        for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760687840; x=1761292640; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YeonnmR22YpdBnRA2e84Q5k99IvmMWnT+8o9upY5Y8U=;
        b=dG0WWJxcgbZ/BuPcm9rlqPEcGkxEw16hz5Dp3zUI51kbNwU3nefQ7Y+S09RBU8MyVt
         w2rmIDuY1u7P4SbQeeKYr679PgXfvTn+nznkHKKG0NwR/aSMBQu7EHUw+AP7a0+v9osZ
         32GumXBQaWQ05Aa853MEl+Mie6xmULlAtJaxYwKgtq0dt776IPsT0OneBC77IiyhAhkY
         RBPWnMmSBo1e67qiFp1pCIr5vthzAfR8fweYXOQfEwTcrkxQU+rQ7fSibN23TvDfNP+z
         0/uth3vlD6s0daApARqNtHV1zos1zTz41ax5wMBOOy6E09e7Et67yoBz8rG2MPCInq1J
         RirQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760687840; x=1761292640;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YeonnmR22YpdBnRA2e84Q5k99IvmMWnT+8o9upY5Y8U=;
        b=vNg8454CgIHBXVlxFImi7SEQPzQhWZ4EmaZY8LVZ9E7VjvQ3jCwAuMo+yejdntXKzk
         /D8FjdD3H/FKXEjt66J53x/NcIpNKu3uQztz6mzkO01i10XcxeqqudK54tBLpvFYMxgh
         kGoyoJ5YIxKKtZLuijTUT8q6Hwqm3015UfxnFuZF41jxjYfwQH2i27Unv2cH3xiiAd8T
         //WCzVey4lIizczzmp62rQN6wdugQsdOlbFZmrbYHG5iT1flHypdR+Er1HhHwncdbqbC
         KABPl04KRL1N3wmiHPBr9kNEI8ciaz0Mlfw51u+/yvmygb+b7a2eg4kqcjWsgIzMgSv+
         nuUw==
X-Forwarded-Encrypted: i=1; AJvYcCVVR+Ix6UFVQgf51C8kw9LAq5XVkQQMRSM6lmBqBqVdsriVD6ggFCwtQZuBb6TESNLl4uIlojQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7IKnbFNTBp0ta5Cnxj890I7YcyfXhG9CaTx1+hHNJjPh5HCEj
	AaTM0esn4TTdR9HaxNaZ2srHufbkplaxxIhq7s8BIBFUWBePPGywA6iKh/xOieLJZzKy75Cc7jA
	0ber9J7TRdi/29ALcX3O1RK+5AYq2qw==
X-Google-Smtp-Source: AGHT+IFurVwu13hTVgjqFkuyg+jJU8SJ/2HWVhpsWHXh/EE63aqE9d17vw6ppnqZ4TszNyVb3fhURmcJUleEuWeLYDE=
X-Received: from edya15.prod.google.com ([2002:aa7:cf0f:0:b0:639:f07d:725a])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:20c2:20b0:63b:f93a:57b with SMTP id 4fb4d7f45d1cf-63c1f6b50c1mr2138541a12.20.1760687839997;
 Fri, 17 Oct 2025 00:57:19 -0700 (PDT)
Date: Fri, 17 Oct 2025 07:57:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017075710.2605118-1-sebastianene@google.com>
Subject: [PATCH] KVM: arm64: Check the untrusted offset in FF-A memory share
From: Sebastian Ene <sebastianene@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	catalin.marinas@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	joey.gouly@arm.com
Cc: ayrton@google.com, yuzenghui@huawei.com, qperret@google.com, 
	vdonnefort@google.com, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Verify the offset to prevent OOB access in the hypervisor
FF-A buffer in case an untrusted large enough value
[U32_MAX - sizeof(struct ffa_composite_mem_region) + 1, U32_MAX]
is set from the host kernel.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 4e16f9b96f63..58b7d0c477d7 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -479,7 +479,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges;
+	u32 offset, nr_ranges, checked_offset;
 	int ret = 0;
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
@@ -516,7 +516,12 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 		goto out_unlock;
 	}
 
-	if (fraglen < offset + sizeof(struct ffa_composite_mem_region)) {
+	if (check_add_overflow(offset, sizeof(struct ffa_composite_mem_region), &checked_offset)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	if (fraglen < checked_offset) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out_unlock;
 	}
-- 
2.51.0.858.gf9c4a03a3a-goog


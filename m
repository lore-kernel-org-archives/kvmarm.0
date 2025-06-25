Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4F72BEFE4
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 10:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750848954; cv=none; b=aDLUAyASbzVNkz6xHLkoO02VVjajPU39QsgmnVYG9oFSDH8aa2aPtQm1DDLJGiEe87HNJxbIVk4hLcSaBIMcFfQIojzrJebWAvjob+JitCPf5cFuTblsYeQz0JXJGVWnQ1Qsd7L9IXeKh0qKnjZn03LIUoQmK8lIzZNsm1F+fb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750848954; c=relaxed/simple;
	bh=Y+NflATt1BbVg4AJe27l0CDfySeQP4HOlxRLdzEDkE4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uSp+3MQt2qRenM+HFLYifodyOz44zyP0X/3BfeLYcc10e2MUINYi2EZz7Eq4qbbKhjs0Q8mPFALaLMIWr8/VmYqx8yUJWv4SMGAI0nrRk8dZd7k52HsHCFc+1kOYr3+gPizZC/ZwFD2whoNtkTqi+kpGZ17eMYgCFXnrTnxzMOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NIFAMT2s; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NIFAMT2s"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-60724177a1fso1460276a12.3
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 03:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750848951; x=1751453751; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V1GXLq2HqBHIx1U8RtZLo2I2pqPpplv4UNHwKqoIWBU=;
        b=NIFAMT2sbPPmFbS8O5I1J2yqaca3/VFm6ZKsTjyzK3qDSpuJTGLnYh8SGVCUO4uHCH
         wVm6nkTvEVTZ/Zu2/34JZi1sKk1IsyhwjkqG5sdVC20yOCOOj9CaV5oc4mtxOfX0XJtz
         BilNOGCPZ32muvVWXX79zkXKgmUDKPGXsCX3N5tUoown6FMQKR1Y3fQOMYjZGElBtpwv
         HHjSrkC0GG/0jH4O2V8ow6i1FngZ3+mDz4RA812AyDsFlLSZZFoCvFzF2mbKW8WNUu61
         D2es7/ihMP5odfje8gjzC8QAd0sWEpaDTEgYm56t4mk5hQCar7Gl3IxrZf8uAMktBng8
         jn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750848951; x=1751453751;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V1GXLq2HqBHIx1U8RtZLo2I2pqPpplv4UNHwKqoIWBU=;
        b=Vcp8uRAQLZSl82RV1Hpz2kOFoWvhbvTjPJG7cKsnn0NTSpZD+9z6Ua3ehXtAXjfr/w
         MdXJrrY5JCCNVsd34lOBtSROR5x/JtwWKKi8FevRzt03QjdGr8BU4XeAuZkWfFwpWPop
         ODJpE6jDdTovdbod4DBbL3UWTE1sN98/r9QNJ4TaBCCDvA38FqYolYsNtlwHkSrWdPbU
         CC5kkZ69/f3n/vnANjWTmlxxWRtW+j4W4zpIgSSwSARqmclcZAp+9eAE0fuUgaS4ksRW
         FJx4CGG9WUdJNKeBbpESR0ctf4O/p+aMBGqXqqqtHKS+JHBIafBMLwO0BPLrxDfhSeh8
         /Gzg==
X-Forwarded-Encrypted: i=1; AJvYcCVl8+yboQJIY8FCze5+wUPLbx647eX23v755hr1zDMR4Y7MmwE+8bzQHUwAnt3qRMXMdxGwpF0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJC6MSpKSsVJB3cI7dzCz7BLHGvWsDyRcCL/If0TbM2xhO4Dvn
	gRNs/hkn8ccyis2ty8AX73dyY+M9vJU2AdO8J8q4rH6DJ7Wz4MQdwYvRiDEGUEGaZZC6MicnIOz
	IMLpu/053ag==
X-Google-Smtp-Source: AGHT+IHUR8NzJ9FFoX9Hr5oMdShDNs6NRkAE3kBsnjpl89mkWn7cGms6VUHj8zcgECBy48WdUiyOSlbMzG/D
X-Received: from edtb19.prod.google.com ([2002:aa7:c913:0:b0:60c:5b8e:e20b])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:35d3:b0:608:8204:c600
 with SMTP id 4fb4d7f45d1cf-60c4d31789amr2084880a12.3.1750848951221; Wed, 25
 Jun 2025 03:55:51 -0700 (PDT)
Date: Wed, 25 Jun 2025 10:55:48 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250625105548.984572-1-qperret@google.com>
Subject: [PATCH] KVM: arm64: Adjust range correctly during host stage-2 faults
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

host_stage2_adjust_range() tries to find the largest block mapping that
fits within a memory or mmio region (represented by a kvm_mem_range in
this function) during host stage-2 faults under pKVM. To do so, it walks
the host stage-2 page-table, finds the faulting PTE and its level, and
then progressively increments the level until it finds a granule of the
appropriate size. However, the condition in the loop implementing the
above is broken as it checks kvm_level_supports_block_mapping() for the
next level instead of the current, so pKVM may attempt to map a region
larger than can be covered with a single block.

This is not a security problem and is quite rare in practice (the
kvm_mem_range check usually forces host_stage2_adjust_range() to choose a
smaller granule), but this is clearly not the expected behaviour.

Refactor the loop to fix the bug and improve readability.

Fixes: c4f0935e4d95 ("KVM: arm64: Optimize host memory aborts")
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 95d7534c9679..8957734d6183 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -479,6 +479,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 {
 	struct kvm_mem_range cur;
 	kvm_pte_t pte;
+	u64 granule;
 	s8 level;
 	int ret;
 
@@ -496,18 +497,21 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 		return -EPERM;
 	}
 
-	do {
-		u64 granule = kvm_granule_size(level);
+	for (; level <= KVM_PGTABLE_LAST_LEVEL; level++) {
+		if (!kvm_level_supports_block_mapping(level))
+			continue;
+		granule = kvm_granule_size(level);
 		cur.start = ALIGN_DOWN(addr, granule);
 		cur.end = cur.start + granule;
-		level++;
-	} while ((level <= KVM_PGTABLE_LAST_LEVEL) &&
-			!(kvm_level_supports_block_mapping(level) &&
-			  range_included(&cur, range)));
+		if (!range_included(&cur, range))
+			continue;
+		*range = cur;
+		return 0;
+	}
 
-	*range = cur;
+	WARN_ON(1);
 
-	return 0;
+	return -EINVAL;
 }
 
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
-- 
2.50.0.714.g196bf9f422-goog


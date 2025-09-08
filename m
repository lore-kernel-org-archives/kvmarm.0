Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4374C2D5C95
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 06:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757313976; cv=none; b=s2hBUTK4B+fEGPk/YrqxpexoxTqGPnsKrDHQzhKy/C8IhQmGVWXome2VPOqmzwy/Yw7dyb4a6qB4fXFVqjVip0486Yt6khnD6KeeQdDgdXVNLcljyRnbZtE33Y70q7JPW9qn0FVEP5aSgqw8SSoYoXqUKiG7S6C9EoC8em3MSO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757313976; c=relaxed/simple;
	bh=J+uwgCSb716MwM+IdWxrDTwyLDESBtarqBq1Dado3nw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t2ybOWANHB0/PG0Z0ZTzlkHBubKZ6zkTpr5i+cGKWnDgOGJ99v8OaL25vLDPxc9SF4OVhxDTvmow4CZK7SbfKmha1OcJsjHpK+uNdJFL5kbVRv0mE0I1H38PZW/HoTYwffVOCupnrpcBmr/vQk9e/36+hRvYI1vhfp8lpc9uNIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=fTfV/CqF; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="fTfV/CqF"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24cd340377dso23200635ad.1
        for <kvmarm@lists.linux.dev>; Sun, 07 Sep 2025 23:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1757313972; x=1757918772; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X/6C0dAUyoLQyauQofbYRj/vzpgwi+DjfoZxlhTk298=;
        b=fTfV/CqFlxTQyyR9PEKMUO6x1APlhAJpnTDzlRe1Ct+7W83LA2beH+eIRAI/8Qj++d
         vTtSbFrkg0MVM72upxpqvFsmQZ1kxNjaghkAaeJ+G7lUE85N/WmBBvStFtCrp0ZNAbiA
         ZWpugokEHU/QBM+P/F5JJoR5XlCVghWOF0eE/cPmsL0D8U1fFyNFoneROgCu0MBBSUeP
         +3XveiTiR7GcbMXs6DmRuId+mJs9XgdNp2BYcvZ70fQFXWZELgJMooLU1hvhzppxZrnM
         8nDQGYP21a8QYeZzdWOZ8Nyw3rRpgfakEE7xQ17pjDa49O5cHl9fVx83os6sGBl7t7l4
         k0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757313972; x=1757918772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X/6C0dAUyoLQyauQofbYRj/vzpgwi+DjfoZxlhTk298=;
        b=l2KxhJkpG3/Zd1q2YVUnrmO+nQWwtNPXdt5rwjrt/ld3Ym4MK/W57E7XOLAccc253z
         LAlrs9u0arlQdEHSVqBDnM4CjrwAOA1l7vSzJZiAlF2Qkb9PHLqS/WudbXgua9TUARl6
         ZxG7i1ezQLrvLwE8/uzUVnU78Lf+wEe0ccKF8FyA59xATv9yoDxYZgg0XzdEUChmR7G6
         M8cDu3riBWNI4SYQnlPJLePaepiYsGSiCO6E4z04bRK9sGq+TS1SZS72dOtdqdZfvfmT
         +bexVjPSyMw5Pex0+LWYH06gRt4oq4R4+9Dm9zvmO9q+gbK1dE1GuVSliIAKCmvaKtWd
         xN8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUiuSFWD8d2nmYW/9bo0k1LIP5miL4OTZOIy8dgrCdDexx1DlE/KOl1Mh4MqSkTC3gTOpE1T50=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgCG1PG8vhtISbLs+H3VmjjHmrWltjltLnr4+B0CR9mtjQwRKA
	G8Aw/kAr/a3UUCSmvQD3GlcVLs0iocAwHB4UnrGw5a2XbUxPnFLdvHTfznNYalgh+a9BA+Bk8GH
	sDEOcW94NPDQcrtf6MH7Q6QX/tZirol4GqQmDqtEUwZqBpqYomoI=
X-Gm-Gg: ASbGncudHS4dRIQg823vSgVsniFn9ChXUSpdskbIRLlSGd5jeLVuQygEEKlceckmhzh
	Fs1lRJcwiGg99VrLejuK1Piny7LQPRhWF833zVsEri/9Lk4ZzJY3GNRO/vWwPJyYI0dBNpVDaUp
	Ngzf8j2m18zVA1WOOOIz+CeHy/PnD5e7HYwCtZCXR4h0ckInBjjpK8vO62KM8VCfG+wzUAnB6Z9
	GWiHhqm0am6NArzzELBUuAsR7JqdaI8ELS179P8EHNYsG2+us3wUmUGx0iFjSdbAyI65sepqltZ
	eewXgQNUbL+J6Ap31OFVGZ3Q7MB/EDASw5QUUX8yCQ/BbQTMkTQHdSvngE4eSMeHlqppQqS/cWN
	G+Xz3sGnkPpgNhTVoN2S4B1TYM3WwH53+PCRGwvEtIg+bi7iDAGUP6HJAfZkZXwqMBF7iLeA=
X-Google-Smtp-Source: AGHT+IEQZar8WBAOm85u+suoluGDr+DTtstTbqs6dfovDku4FTi9XGSytpEOzcrDiccqig50y3evvA==
X-Received: by 2002:a17:902:f64e:b0:24c:be1f:c1f7 with SMTP id d9443c01a7336-25170e4187fmr86761255ad.39.1757313972470;
        Sun, 07 Sep 2025 23:46:12 -0700 (PDT)
Received: from zenbook (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b5236338fcasm1574671a12.35.2025.09.07.23.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 23:46:12 -0700 (PDT)
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2] KVM: arm64: Remove stage 2 read fault check
Date: Mon,  8 Sep 2025 14:48:06 +0800
Message-ID: <20250908064806.4093081-1-r09922117@csie.ntu.edu.tw>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

In the non-NV case, read permission is always granted when mapping
stage-2, so checking for it doesn't bring much. On the other hand,
shadow stage-2 for NV guests could potentially have non-readable
mappings when we align the permissions with those that L1 set for L2, we
shouldn't be checking for read faults in this case either.

So just remove this check.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
---

Changes in v2, thanks to those listed in the Suggested-by tags:
  - remove the read fault check instead of skipping it for NV
  - Link to v1: https://lore.kernel.org/kvmarm/20250822031853.2007437-1-r09922117@csie.ntu.edu.tw/

---
 arch/arm64/kvm/mmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1c78864767c5c..fb239cd9f7a67 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1508,11 +1508,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
-	if (fault_is_perm && !write_fault && !exec_fault) {
-		kvm_err("Unexpected L2 read permission error\n");
-		return -EFAULT;
-	}
-
 	if (!is_protected_kvm_enabled())
 		memcache = &vcpu->arch.mmu_page_cache;
 	else
-- 
2.50.1


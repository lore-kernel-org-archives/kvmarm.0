Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6F047AF68
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589308; cv=none; b=E1FOAIqupFAqrcvohI6BcT/D1FW0QU2E68PQMP1BBJ0q/4TJwlJaW2clK0wvf3ixJYpahkek9L4xyrC9xd02e7J0O8egXhUXLAPFEcZynvhdCixLLZk8OHEyualFo4/sv+4SNe/VQNzFm0jk/UJ8GwPsSBitTABI4TzeAF1uyFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589308; c=relaxed/simple;
	bh=/se4oIgnwRvYOg4j3UbDL/rPnFIf7czgq2FijQT83zU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EIYlyvmrbdfv3Oyvq1iAalgmcyMB8X9Q3JKH7PDVMhs9oGOzNL2xojd6oeID2Il/l+CXapSyE7WmrEGW4wavnVio3jt4V4wohXK0bjOqSKFDmvIVfiKHufupoGUasDrTx+0lZ71N2stwGMVhp5+fzpYmtGswY5vNex2BxgRR2es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ichz6rMG; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ichz6rMG"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e661c6440so19112435e9.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 02:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790589305; x=1791194105; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JVt9PTQ3gJ/ArVKfT3hU8hseiFwEBqxTroAJlxW9cEQ=;
        b=ichz6rMG0GEwBfk+pZVKx1WUbHrCnsXyfjCBtgn07z4U3JikUZYEi7Dkj0ey6lT1aY
         4MmPI3/8hRSbT+4htvcHYZZ2oqVd2bmhm5CWy+SmMBsgd3aKzVVnbnhbly+SOuWqE/WT
         N4a+5KOVB3adCisEPIF1nbncSuuFndPwuYminC7lFt09rM442Ps2ElQ78weqCiz87It9
         w+5dY0+uGpnmc+ROxMaQx572MG3iqzjQqEwuW4MgeMMORc6DBo3PG5Ri6VNmvroLoBhT
         cerZM+KJvOzMDU3V39Du6d8ETf9mm9rtX+iDi2qNZUFYWIclUS3e+sYvBJ+3NVFXKM/M
         U9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790589305; x=1791194105;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JVt9PTQ3gJ/ArVKfT3hU8hseiFwEBqxTroAJlxW9cEQ=;
        b=lKmqDGdiRjNeRWwqFc65XzL01KSFgz0mrFyil4QM/HghJjbyOM0r3ScPhSOhgoBz9X
         N8YGnJhavAHDuFyYTspcUQAb53JnFTOQJVveGSRqIreyysrxewmIXTQpf9HLakjNY6df
         9USODErsVnlryDRR4YAes7OKD77WAkCJXXHeb1PU172AFGNyjm7P67MoaAl9HqlppmHV
         VNfGeptPwXkP3AgLgCIxzVClKk4tocp7sdV+kida0JM5Qgo9zkzcWw4JGzLxXhIqA3cA
         vcLT01aF/+qibMYebRpZHraJSHBgOIMGSRW6qnhEETOqJ6ltpkUrwzxFbZ5u5+l7ndWw
         6r7g==
X-Forwarded-Encrypted: i=1; AKwUvBzdX67bfVvPSQ+9XEkwx4s7yiLfALsKfWq0HGdnsRAp5S0bwB65PArTyFdVUvr4881Y4bYxm78=@lists.linux.dev
X-Gm-Message-State: AFuF++laOef+6HDRIQJsBSQhSZNldCYexYjY/QTuwsBbYebrlGXs7svN
	aLLAUZS3/ZqyuH4QM5QqSlCB9+VBJ4MXszHZL0GSLt3CgL6+XmefuK4wEMGsX8w3Py02qvhGGa8
	5AiS7cP23txOFnWUWisH3sg==
X-Received: from wmdv19.prod.google.com ([2002:a05:600c:12d3:b0:49f:e401:6ca4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc2:b0:49e:7d69:83b7 with SMTP id 5b1f17b1804b1-49fe66d397fmr217648495e9.13.1790589304426;
 Mon, 28 Sep 2026 02:55:04 -0700 (PDT)
Date: Mon, 28 Sep 2026 10:54:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928095454.3255918-1-vdonnefort@google.com>
Subject: [PATCH v2 0/4] Fix guest_memfd and protected VMs on systems with
 pages larger than 4K
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

This series allows booting protected VMs and guest_memfd-back VMs on
systems with a page size larger than 4K.

Currently, the fault handling assumes 4K alignment, as HPFAR_EL2
provides the IPA minus the bottom 12 bits regardless of the system page
size. This leads to mapping failures on 16K and 64K systems.

This series addresses the alignment mismatch by relying on struct
kvm_s2_fault_vma_info in both gmem_abort() and pkvm_mem_abort() to
retrieve correctly page-aligned addresses.

This series bundles the following previously discussed fixes:

 1. https://lore.kernel.org/all/20260915091606.2111217-1-vdonnefort@google.com
 2. https://lore.kernel.org/all/20260915084438.2076072-1-vdonnefort@google.com

v2:
  - Use forward declarations (Marc)
  - gmem_abort(): rename local gfn to canonical_gfn (Wei-Lin)
  - Pick up Reviewed-by and Tested-by tags
  - Rebase on v7.3-rc5

v1: https://lore.kernel.org/all/20260922130821.1666713-1-vdonnefort@google.com/

Fuad Tabba (1):
  KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()

Vincent Donnefort (3):
  KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
  KVM: arm64: Pass kvm_s2_fault_desc to
    fault_supports_stage2_huge_mapping()
  KVM: arm64: Use kvm_s2_fault_vma_info in pkvm_mem_abort()

 arch/arm64/kvm/hyp/nvhe/sys_regs.c |   3 +
 arch/arm64/kvm/mmu.c               | 129 +++++++++++++++--------------
 arch/arm64/kvm/pkvm.c              |   3 +
 3 files changed, 75 insertions(+), 60 deletions(-)


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


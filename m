Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D34415F0B
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 09:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243540; cv=none; b=CpIs2jxnRsMO1Vg4aOFJ8YByVYM2yU0vb6KpNx7xUaMTH0+stg/oom8cWQND3UNqv9sNmZWQ7WNxb0kNRcuhhJa4ivO2FqmoFd99MrCK1t+gbLpmNIVCx804L2aOn5Bbp1gl3NEq1aM+AEgRd7A0l3cMx8liYP0cytC87dAYl/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243540; c=relaxed/simple;
	bh=+wwRzPbd0D/O70oJCkHWQQemR606EvamjHUJcIxpNiM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Me9lY6YGYNTtze91cVTSUgyCrb8ULDM5OVmbhNB9/fm46eMVDqaQObfPZiHepRfawGpo5+N3ANm7I0pb1erg4W+OiALZJAg1ZawOsyZroyakDuyLXxaLecNTAdsLUG2w6x89LiJNuFaGeDTC/woUGEzGfexAsAQR8DKsWZOhdik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OA8Rwf0J; arc=none smtp.client-ip=209.85.221.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OA8Rwf0J"
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4886448d257so1261388f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 02:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790243522; x=1790848322; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Teg2xf6fWRrl/zBr5cBFx6F6XwrP4vrM+fvmVBE3SQE=;
        b=OA8Rwf0JZT6REkYGcDDtELPZmG1ASb+myTj89gNVgtv1bBy5AKJM3pcw7BCTUguTV0
         Go2Kd08UIERZ0yEp8ma0+NGF8F6TvEvrdpg4318FbmAsOlI0KaRWyu9tEQm5SDlXYMjI
         QzFw8WEhXn9E8NhVF/o/lXDZynUhpGRAFcEQj0BiRtVUKXpQEXUzRUipqyRGQ6EJj+Vv
         JuW2lWWtXsBAnaHNHsbaBlJxih80G0S4gvQp6j9GJFOhr5ZD0jR/I+EJ7MzEp6ysyOk4
         u9nZWuxP+jIFVT2HxoXWvfMSvDQB7Ze7OkaixEn3GqC+6N0OH4i8ZrZ5LGWOqDCPyc2g
         t3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790243522; x=1790848322;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Teg2xf6fWRrl/zBr5cBFx6F6XwrP4vrM+fvmVBE3SQE=;
        b=gIraKVHTAYHr/nC6NjECCB5K+mWFQu2VVwQBKgBxTPBPfRuaHBOm2vYCwickUpkrrf
         W6njQKd1hDo2AXjXCTIm8/ifcbd6FrR40b1aIuah4rWtvf5rYXqiWk2tVOtctE1HxBVK
         xyA+rQa+cNadRYqA2syBcx/5k0wzkmSIQ1WHftXPoFmNVnWOT3N/0A6YlyYsYKtkBmHW
         /XCuNeUNnzGuoQEUnPqbxn32qeHf9vndhlDoeTrlcPL+1Mb1/hi+e7lXGrZKHux9jYvO
         EdbRmgnfbv3bZXIbvqVzNOUWgo4a0IVLC1TvXo6IqlI8v2LwbpVuOBpu5mFKadplpwuD
         GvGg==
X-Forwarded-Encrypted: i=1; AKwUvByifDxWmNhmN5vVI88UZ/QGfrhs8Nb27WwwxnDzTmnmbB2Mo5/pMQtcy/+xsImw7esq96rX/uk=@lists.linux.dev
X-Gm-Message-State: AFuF++mTslMz6S5npdgM3mdJiLhkzg3ofS16Kkngn4RNbToNqVgClIFp
	zYPD0uq9/MdYvf1UvKU69jik9R7vHugc0GhxuOS7bZSBo7Effty7qi7S3JsKvEy9m0bTvrDXfxF
	FQ43rw2Bttb7Qt0cKX0Do/Q==
X-Received: from wrzq8.prod.google.com ([2002:a05:6000:1368:b0:488:7479:3b57])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:64c7:0:b0:487:765:46bf with SMTP id ffacd0b85a97d-4887171d2aemr2945649f8f.19.1790243521432;
 Thu, 24 Sep 2026 02:52:01 -0700 (PDT)
Date: Thu, 24 Sep 2026 10:51:54 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.310.g51773c2048-goog
Message-ID: <20260924095154.807726-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Remove PAGE_SIZE alignment for hyp event ELF sections
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

.hyp.event_ids is mapped as part of .hyp.rodata. As a consequence this
section does not need any page-alignment. Remove it to save a page worth
of memory.

Fixes: 0a90fbc8a170 ("KVM: arm64: Add event support to the nVHE/pKVM hyp and trace remote")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kernel/vmlinux.lds.S   | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index af1d72020976..c0b090db8be4 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -15,7 +15,7 @@
 
 #ifdef CONFIG_NVHE_EL2_TRACING
 #define HYPERVISOR_EVENT_IDS 					\
-	. = ALIGN(PAGE_SIZE);					\
+	. = ALIGN(SZ_8);					\
 	__hyp_event_ids_start = .;				\
 	*(HYP_SECTION_NAME(.event_ids))				\
 	__hyp_event_ids_end = .;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index 7a02837203d1..89222425359a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -17,7 +17,6 @@ SECTIONS {
 	HYP_SECTION(.data..ro_after_init)
 	HYP_SECTION(.rodata)
 #ifdef CONFIG_NVHE_EL2_TRACING
-	. = ALIGN(PAGE_SIZE);
 	BEGIN_HYP_SECTION(.event_ids)
 		*(SORT(.hyp.event_ids.*))
 	END_HYP_SECTION

base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.56.0.rc1.310.g51773c2048-goog


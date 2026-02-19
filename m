Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABC3346FB6
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513432; cv=none; b=m6yQfauSwNd8meNw5V5j05KAOW9/xtHsp9vCCJK7uGrE9rt425A57bi9INK0QqkXPzyATU3DleIbxXsDhgpEBFHXb5elptc1+0xheI0IHNdLBsvAw2JB/9NaPLwoaMMGJ6lwh4DFzDTUA8GprHr7wVI1hTdTlZG/VIal8VgYSv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513432; c=relaxed/simple;
	bh=9koaOg8gz/LIYhm5Xo3A1Dhg2C+g70uI5oYNUnCRRUI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L76HLISMOb+3JJv9MnnjuTps7BYrImoq1OY9Y1yN0Wn9EMeb51Qp3LNffT4o2H48eZzSqS7hFrpISGQMmsWRXKZKozxdoxc7nDSImUCe4k7BRyVBkNIvJPVM0uVZPuXUFhk4HvBzKne8kRWQphujUNIstriv+jhHyHOck/wRDkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vje0fnpV; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vje0fnpV"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b7fe37056e1so98960266b.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513429; x=1772118229; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F2gZpXDniUcFidBjYaLwAM4ahhSMDy4xfU2xFo+BZpQ=;
        b=vje0fnpVIUoujvSiaAegP4fJDqzX4dTkr5iL0K6GCgAxorXRnI6PYJOsaXVLPQrOCh
         22zAjlebLnYkiQq+tB1px1QCzO2JCCbCeVXaCtgIWP89NM57LYpGFvGbinOiuP7m22TF
         9bdHeZJtp0OV8poMZMao5MTRofROkrO+eS46KjSK0kYlEDarqcHPbpSbuiq1krZqR3CS
         V1CqYYhjWi9TDbjyVwIIrLyZP5GqsnrAxE1K37rCTJb31InKczLVzIr72M02NvGwb2N/
         VshuTu4ot4zwqsGGQ4pT3T0JwGTnNjLcutqpSJ7b+3dcUzLz7+QiFaSS47sgzbnTrgv1
         21Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513429; x=1772118229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F2gZpXDniUcFidBjYaLwAM4ahhSMDy4xfU2xFo+BZpQ=;
        b=SMCcOgAMgS2xxpUPFO+2tZCPUWokDVqhM0u2c7HfEhvK3p3RMRXQLMMonFy9Ugjswy
         uni28yLJVrTVnfYp9uZ6ZSRLMTsYtome5J4/f1jrGURKfZMJtQFz7KHelV3Xzj/aVHCI
         +sHW9GdpMC7ejQqrdw5m47jOTWXq51gJbgmBHGR70j+sHX9LFXc+Db2HgH6esRfIw2+w
         IgwAJFtpxexHLvYURCY/yR2UhKg4agcYUn48784cA12Fozh63wc4AZDU8ubOKJVNVe8N
         geoKEWRtsfuFzc0hSthbils8RnH/DMwh3xFDfQKE71YjOmsw/qSNlfR4+rtE12jcLQet
         gP/Q==
X-Gm-Message-State: AOJu0YwjGbtHEnXCcNPEneCqCE6nCMCZeq159qymk4hODXupU4ISOOh1
	KnN52RLl3VZSKaw4g01Pxmt8hehyXJGG3Eb0Yy50Hjg2jtpZBg+aAgL+mFIq7nlwRpkqfNioFIi
	XPywCBlP4d+sYxNYaUXbzdw==
X-Received: from ejcfr47.prod.google.com ([2002:a17:906:892f:b0:b7a:21aa:8969])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:86aa:b0:b8d:e10d:6f96 with SMTP id a640c23a62f3a-b903dc94b3bmr358008266b.32.1771513428793;
 Thu, 19 Feb 2026 07:03:48 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:59 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-23-vdonnefort@google.com>
Subject: [PATCH v12 22/30] KVM: arm64: Support unaligned fixmap in the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Return the fixmap VA with the page offset, instead of the page base
address. This allows to use hyp_fixmap_map() seamlessly regardless of
the address alignment. While at it, do the same for hyp_fixblock_map().

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index ae8391baebc3..a6eafd72f87c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -244,7 +244,7 @@ static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
 
 void *hyp_fixmap_map(phys_addr_t phys)
 {
-	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys);
+	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys) + offset_in_page(phys);
 }
 
 static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
@@ -366,7 +366,7 @@ void *hyp_fixblock_map(phys_addr_t phys, size_t *size)
 #ifdef HAS_FIXBLOCK
 	*size = PMD_SIZE;
 	hyp_spin_lock(&hyp_fixblock_lock);
-	return fixmap_map_slot(&hyp_fixblock_slot, phys);
+	return fixmap_map_slot(&hyp_fixblock_slot, phys) + offset_in_page(phys);
 #else
 	*size = PAGE_SIZE;
 	return hyp_fixmap_map(phys);
-- 
2.53.0.335.g19a08e0c02-goog


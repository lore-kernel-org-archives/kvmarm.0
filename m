Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA3634B183
	for <kvmarm@lists.linux.dev>; Tue, 23 Dec 2025 19:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766518668; cv=none; b=E8UcQfTjQiJFuuf+C8jnoZMdKie4uShSbvmuAbITJY4nWB/5jfCe70mPuusPlIUQrK6bUcXX/1jpzif5ygvB+Gy4NZXpa1Y/sc4bAwPBoktEDVTPAcSuxxXhNWsPNl71lpfyTncGtmpJddBIAmyDHy7nlOW51taszCCgzLgP1g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766518668; c=relaxed/simple;
	bh=P0bttLFLFuRh+QxOVIGbbBLN7a1dGQScl6lQT1zbSfg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WTJz4E42yxkMqrBJL47UQfKbxzdmdVANNL5HRnA63fMFPHYiNGOS3U0vcPOorWslb7R3bAk1MhcMzyR79wZdkPwRW+aewsqU/cL/0675Tlh9zUyc4x0mZ4cn/bx/dLH6EPMQ3ebFXPz8sQWqtZkyi9C3DgSIEZ1u9CyqhM2eCw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--pekangas.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tCJxmKlV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pekangas.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tCJxmKlV"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7bf5cdef41dso9027862b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Dec 2025 11:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766518666; x=1767123466; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f+/9YLEDg3kvIVJ8uIdd0LLUvUHitQ7YUX6eQO1NlK0=;
        b=tCJxmKlVG0m8eTkdeOaal2N/OLBZCzpre0yABXezNvJMuUAOz2zxWcTYrbpDfmoAcA
         VxHZwBLwICbcGchuHBUSj6RbOB4oan6wWOnLRKjboeVPy0kxR/f9ZGfAS4E8GqNE6xwj
         a9BVw7PjoJxsXlb00PQn2tQvy4Mq5VTilAeF49QVCbkrmYOwmlEEDRQfQHatHtp6/y8i
         zLaijEzj/ZwNrD/dYxpEw9VwKkJSAEWrb4v0VdXyp6Y+T6GKxn0xVtMN2vkiph+7DW6p
         C88xaw2XXDdJu4RrC3M8jcbVOwfBDpE4XA/lxegc8w5fsuwW+OtLZ/WXMhQpvXLlJWjQ
         venw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766518666; x=1767123466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+/9YLEDg3kvIVJ8uIdd0LLUvUHitQ7YUX6eQO1NlK0=;
        b=kBw2fOwf/jAZyluXKkWWPoUHTvUcqtWvPQ6R7F+zMR9KiFH0/Ck3xOrtIpIdgLJqVO
         NJSdoBomkv/YOzQw/52lCVHurv3NGTRShRD7X3zOBvqc0nGgdxaOAzxxGp3rruuPks6c
         B2MaOLCUcagjb1mBAOZe8SdhVN2xP6ZNkNwAwCazAly72aOIiJ0aHFlZrmPWCnAM3Eav
         IWQvG4nVLCEQFHD39THT8dRcF7pyqbMiM6b4ZTRlokaCT78tO+oSRL6Q0uLfYqrf5gdF
         GmGFD9r55njV5BRPEfnCDTOIdhzc9Ajl4H2NXA6q5jBwPAfO+oquUocmcGYkPMhiiPTj
         dfYg==
X-Gm-Message-State: AOJu0YyVS/nKCX5DkejrUIRjEZeWYn7UO1DJNoSvk/3mwHqMCCaKao6Y
	6OAZj1vPycFzQ4RE1kTYKSlcmbuaW12UfhQdrWdqQGrGRP1cErUuxlWbkBGcBmnrvfnKxgZ7t3o
	3e9mqFvhM7UCCDSnHhtiwMeYbOdzokuwFxpKQAd9sXKoEzrESw1hQpqCYGEjF2eJ1mfVEGcB6lT
	HE6nBYQB+qb4IpiMfrBYvmhz53fny4WDdkMO3tlaXZpnKQ28Q=
X-Google-Smtp-Source: AGHT+IFdQ0xv1ECz+S2fE4SGRa/G62rXTSK/YhtqO7PYzVPbTpr6YHYABHt3naOEamVpBBjQGWHJo2312jteHA==
X-Received: from dlbps8.prod.google.com ([2002:a05:7023:888:b0:120:5def:9544])
 (user=pekangas job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:6199:b0:11f:1e59:4c2d with SMTP id a92af1059eb24-121721acb6dmr15174419c88.7.1766518666308;
 Tue, 23 Dec 2025 11:37:46 -0800 (PST)
Date: Tue, 23 Dec 2025 19:34:40 +0000
In-Reply-To: <20251223193440.1441657-1-pekangas@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251223193440.1441657-1-pekangas@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251223193440.1441657-2-pekangas@google.com>
Subject: [PATCH 1/1] KVM: arm64: Fix hyp VA size between layout and MMU
From: Petteri Kangaslampi <pekangas@google.com>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Vincent Donnefort <vdonnefort@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Petteri Kangaslampi <pekangas@google.com>
Content-Type: text/plain; charset="UTF-8"

Use a consistent hypervisor VA size between memory layout and MMU
initialization logic when the kernel is configured for less than
IDMAP_VA_BITS of VA space.

Signed-off-by: Petteri Kangaslampi <pekangas@google.com>
---
 arch/arm64/kvm/va_layout.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index f6ca0193a96f..76cdd62550e1 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -49,7 +49,7 @@ static void init_hyp_physvirt_offset(void)
 
 /*
  * We want to generate a hyp VA with the following format (with V ==
- * vabits_actual):
+ * hypervisor VA bits):
  *
  *  63 ... V |     V-1    | V-2 .. tag_lsb | tag_lsb - 1 .. 0
  *  ---------------------------------------------------------
@@ -62,10 +62,17 @@ __init void kvm_compute_layout(void)
 {
 	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
 	u64 hyp_va_msb;
+	u32 hyp_va_bits;
+
+	/*
+	 * We use the bigger of IDMAP_VA_BITS and kernel VA size as the
+	 * hypervisor VA address space size. See mmu.c.
+	 */
+	hyp_va_bits = max(IDMAP_VA_BITS, vabits_actual);
 
 	/* Where is my RAM region? */
-	hyp_va_msb  = idmap_addr & BIT(vabits_actual - 1);
-	hyp_va_msb ^= BIT(vabits_actual - 1);
+	hyp_va_msb  = idmap_addr & BIT(hyp_va_bits - 1);
+	hyp_va_msb ^= BIT(hyp_va_bits - 1);
 
 	tag_lsb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
 			(u64)(high_memory - 1));
@@ -73,9 +80,9 @@ __init void kvm_compute_layout(void)
 	va_mask = GENMASK_ULL(tag_lsb - 1, 0);
 	tag_val = hyp_va_msb;
 
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (vabits_actual - 1)) {
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (hyp_va_bits - 1)) {
 		/* We have some free bits to insert a random tag. */
-		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
+		tag_val |= get_random_long() & GENMASK_ULL(hyp_va_bits - 2, tag_lsb);
 	}
 	tag_val >>= tag_lsb;
 
-- 
2.52.0.351.gbe84eed79e-goog


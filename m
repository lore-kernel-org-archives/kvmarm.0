Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937462;
	b=CdU1maCFG8FIZ8vOqeuFW+RRWMzrGyOnGLrXzTO9+BPLyR4CIcV53PB3EfKXuimk0LCG
	 +8Z/4KeLoC3njCz1f4ReMFJODbCmkPJyNOmgVxQurdKS0WLyIUznX+9Nkm2ZckK0LDeDo
	 9R4SfBwc15QumeoDTvXFHLvnf74zTOctLJWHKFkQftUzxFKAqbp4/lCeglHi/sY1KXZy7
	 lqdI8GzQ9Z99EOnYbJCE8xLdzPYQPaA7/GGO1s6ImB3RdlmyXJjUgmESG1Y6m55hNW0Do
	 GzRdhdUg8dw8BQmassnyEEM27NHVOxdgXEDxHuCUVPQ15fMm08R9GEFSZdwZIe2Lfdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937462;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=cj4h9vHOPKG8KzftPAKBz87rLwe/ZFLBFwOVzEp8Bp0=;
	b=m0QHUcVaLdgfHR95ONOzOWaSGidgFX8W46Ka1W5Y3FqZYv5hy6xzBNY8ovd+bU8yKNo7
	 rrKHtixKLDbFavWm202Tp3sAEGCBhU6GbTYQHdSn6NWJK2kwPte+Q9J3NUpSCKOxywaYO
	 d2ibyIazJixgihcd/TkGf3lyAC7ctNB1eNz+tdFvHLZpQxxuSAdEttrYWI7WM5STPhjXv
	 UVt/lX3mQ5ywepBbHOefET0iEIkjhZbMWa5U2jJSyF/65fHiGtEtFgUoFnMv8sNV1nype
	 HVbOzUYPNk4mlj2r90tsKnAEcnCfhlsOY47xMOkVj9SSeixeiHUK9etU268WBY4aGjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iWRQ5wxP;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C025F606A32A
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C025F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iWRQ5wxP
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48fcb657f32so10808f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937460; x=1795542260; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cj4h9vHOPKG8KzftPAKBz87rLwe/ZFLBFwOVzEp8Bp0=;
        b=iWRQ5wxPfLqdRpSrbXM0gzNgmO2cU4Sze1AtpFm6OUz31uuQUD3tRsSJsuw6NemvnM
         5w1fQtZu6IP11vuT3odGKXeifCLfMenMJtrQFoKlfutJhlZqHnfH01scXPC6V0+tROf5
         ptVXE8woKBTuKDjUSEk/SvytSryWEzZo23AVHwlJKcZpwAVpSn//9AYhvEsRqyp6dl2V
         CihF0t/YNRdq7fImZ/73Uftikz0dkLgUM4JSYVmxTEL2bQNVcHbgxkrpoHaOIUcmHRtF
         k/GNTwDqI+IgMwM7dQTjPOMhmAmZNLGRCpgr9JCiUs7JSQ492GkhyypiWLLTH/9daf6t
         9mfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937460; x=1795542260;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cj4h9vHOPKG8KzftPAKBz87rLwe/ZFLBFwOVzEp8Bp0=;
        b=lgnqLNmJ0ZpS9DcnsqwJDgGYdnaTgEo3PR1uLqYoH88CJJNTaaHpHXK/OGQZUw0VC7
         aKDAyqKLf/2vFRNi9/pURqvlHXJyObIbSOuTmSbBoxC4ZD7Wh/+S0nAvIxXlh0onyERN
         N+GphtEs+VniWzvsl4IIhn/NRxb9c8C2jmuhWYJIIpOueG95sX147nyWnYmNOXPJfe5w
         xTxbgOgsfF1HxihV6pSvTY0qZULUvyyabXL27YaAQ/zGaxHnummHH9uDBvKkKGgCoVlB
         MyvOCyw4veVBUmQNXISQ9t5oYFkCW13nZWg5TjyxXjtt0Ye3daScXv0EnSA1gJdxTYqF
         /7JQ==
X-Forwarded-Encrypted: i=1; AL+hErHlbELhMazw9K8Twiiy2Pkjj4UnsrtXcNUO2hwx+1g9ueNgw83Z0evqxAGGvN/+P7OkbF0Z0Iw=@lists.linux.dev
X-Gm-Message-State: APuU4Z8zsdt0Uu/XUM1DOF8Z/itee7XbdaUwi3/l43ATDBy1Zjs9EEht
	TmKUM4BICXqwygXqaOU34M/qGeqD+Vkn3L4kNYwfmy5Y7andgj0bqYEen1e+eEgK7TfpBg3Tr5H
	b32RCuOlkTGidJWuhSN/YlQ==
X-Received: from wmqu18.prod.google.com ([2002:a05:600c:19d2:b0:4a1:d8be:ba51])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:608c:b0:4bb:680f:9a3 with SMTP id 5b1f17b1804b1-4bb680f0a64mr211547735e9.2.1794937460026;
 Tue, 17 Nov 2026 09:44:20 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:42 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-4-vdonnefort@google.com>
Subject: [PATCH v4 03/23] KVM: arm64: Allow block-level stage-2 annotation
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

On host to guest donation, pKVM annotates the host stage-2 invalid
entries with the GFN. Now that the host stage-2 preserves annotations on
block split, we can allow these annotations at block-level. This enables
safe support for guest stage-2 huge mappings.

Allowing block-level annotations also reduces stage-2 fragmentation when
unmapping a huge region, and reduces host stage-2 memory usage by
avoiding the allocation of intermediate page tables.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bf5c8e75dd52..abd32e94f6ff 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -949,9 +949,6 @@ static bool stage2_leaf_mapping_allowed(const struct kvm_pgtable_visit_ctx *ctx,
 	if (data->force_pte && ctx->level < KVM_PGTABLE_LAST_LEVEL)
 		return false;
 
-	if (data->annotation)
-		return true;
-
 	return kvm_block_mapping_supported(ctx, phys);
 }
 
@@ -1180,8 +1177,9 @@ int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	struct stage2_map_data map_data = {
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
-		.force_pte	= true,
 		.annotation	= true,
+		/* Pretend ID-mapped for kvm_block_mapping_supported() */
+		.phys		= ALIGN_DOWN(addr, PAGE_SIZE),
 		.pte_annot	= pte_annot |
 				  FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK, type),
 	};
-- 
2.56.1.708.g77570a6a1d-goog


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652426;
	b=mkNuS9j77oTSC2IwiMkMcApmhUchjZKOg6KUYHLXUjpeadLo2ZEvXaXnuNBCzKNj62ry
	 3EqUNXglVPOENUB+JZtv/HS71cMBv3ZMq2Ul0a7WQ/aPN+EuhGSgkBjarE+TcNmMrrBY6
	 GmSYamzKlRcQfnlGH0YqWvNk8bis+leaUmmtKmsGRpcJLRZEIyLeNJFbrqzhIrfqVPw5j
	 FKrcEUk8TUdE4WndHdg+5NF+iSutPyRIO7B4dtT9w/yENuhMqLH1aDXuLfZr5EBfyzb4r
	 abypmEmJ1weYgWCOB+ptK/02QClcUO9SugaTVph7AYI2N5Lnl+JftSlbi5NVqTguoxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652426;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=M0SPwlooo8QFrnwNZf/PyV+WJMNWJ9T5R+ygx0SnAo4=;
	b=XzyhLHXYiBsjTpC58z8mG0nVAarABUxIhGDMAEaGL8s0rsZEPwmxGsptQLlBICbv8gXA
	 O++Zw4si2GYTrq60Ao0RthsiE/Y6oFPSYLg1Ro5aVqXK/fwe5DAXl5Y/GCtyyJqt6HAlA
	 YEE6YBvpcyM56lt4SYSAZxJHZGTahlpNSwhtU8kxKaOuyPS/f+X7FckWKOR3sY/ueZjb0
	 x4sBLB8CdaRECHkGVE2kppOS8DXUe+D2qOSfQH3i/iBeewgK4upEMSOpNGg/yqYM4dzEH
	 14pz0EXx068KnpJQKFGjyVypjz6pFqdrYe+Lxcu+3WNb0vgYGhA/vYg60wNZDft2Vfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=moWdyy5j;
	arc=none smtp.remote-ip=209.85.221.70
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62311606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62311606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=moWdyy5j
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48e1ad3cb66so2419288f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652425; x=1794257225; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M0SPwlooo8QFrnwNZf/PyV+WJMNWJ9T5R+ygx0SnAo4=;
        b=moWdyy5jCJx+ZgC4dJXwPK1AIgL5Xc7+WIIm9eIWdyqJ5VY/mBXntrThNzAUrsGKhx
         nqCbqZtDkClTDgd60CB2XDxczJ+HcehkeYRwvNXYdTSlW02wDPp5mIKxSOq8nfmH5GHB
         0oC3W37QQ/6OLLiJ4o8H6nLjBmXHT9YWURt4rcHKO6PdVXXHFjjMRVmxW9u4hazd9mad
         xsPkK6Px/YqPGmpp+DG/W1Hyu6Rr4jknElxE6f1RjKZ1vA4PyV01TH2W//ndnUVqv9OV
         cA2mJosTWMx8hGoHMPOs2jlPNKooLAt1velj/YJE94TvanglNEwNLxg+uEKJwWorziBn
         16OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652425; x=1794257225;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M0SPwlooo8QFrnwNZf/PyV+WJMNWJ9T5R+ygx0SnAo4=;
        b=14eQgBE4M7LDXKWdapUAAnDLE15zpOGoMzB9WjifJlRhD29NzBAV+Yd6VdpZHijwp0
         y5TrayIVfvorTWE0iC4pSSLPdjAykvycL3Dnk2XQJZTcex39j7R82rZ7+7ulATbfwd3u
         A11htCYPHfijXR5ZpWavfT/W7h/Bk7OojFY5mew0aRWopSPh0IASEA8x3xQff3k1hZHD
         B6zJ/WmWXbsmHx4LKDeHHOnJ+pugto4EjJyiK1Koi1s7Woqv2rZVilsQQ/QaS4Bqc9V8
         cFsJBbek25ofczd7RLoLJuggwa+yn5uvwGAoFm8+vd1xYEBvFJnukzemB3qSNONzwRuR
         1LiQ==
X-Forwarded-Encrypted: i=1; AKwUvBzzEdm/bQ36ZxhqrsLwQ8UyDC3DTh7hTdIn3QJ4PJf7iB0SrT54/yZVtabuWgEDjrOM5sfem7E=@lists.linux.dev
X-Gm-Message-State: AFq9FYL4lHGfgn5qBMxgKuif1aPhhwrsV/rPF3XOx9NODKHvBgAaPFAy
	HyIpbAsogQAEsHyXShc8brFE6HjBhiLEFznlY+UJorSgNfGJFix07xZbhjiZHOoRnM/6fiQwMra
	zGbCjW71pLgeB0FLGnP+JFg==
X-Received: from wrxm15.prod.google.com ([2002:a05:6000:8f:b0:48d:ed12:7c4c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34cf:b0:4a1:dbdf:17a8 with SMTP id 5b1f17b1804b1-4ac150b3d01mr268972445e9.2.1793652424698;
 Mon, 02 Nov 2026 12:47:04 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:08 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-4-vdonnefort@google.com>
Subject: [PATCH v3 03/23] KVM: arm64: Allow block-level stage-2 annotation
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
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
2.56.0.385.gac671c819a-goog


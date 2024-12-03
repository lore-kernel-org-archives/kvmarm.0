Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984051E32D6
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222275; cv=none; b=kRC9c7E5GYNn11QmJ/nlTkXixldaXpiboIvyM90YBAo1Jp9CKVNJaKBdUG/FxHfCfSeTnFB8Rh1YjKzha4gxUws3yimj2zEewVRIONBjROP6NIaHok1BRrOc2CqlI06iEs3dhf9xPpZv1tZp4zPAdCdIgcGBfu+r5m/x1rCnOn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222275; c=relaxed/simple;
	bh=lJYxg2ORZLoU4C32XfNiVx3N75+98ndLA0eq7VTKcZA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CmpjsEMSJ3DXES8sundIgTC+Y1y88Qoe5MtBdxMu4oy0ciR8wSdVaAchQ1lZav+2Ex8cPiaZcb34OlBI+zzpjQYZnfUKlilCOuCrDWD/0iqfTFA5g+0iZbJkrAuAqY5zksOTCC38pMPcYlk7YmnweIY2/VGp0gdZhC/LavPAujo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Iv7FysqT; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iv7FysqT"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d0c9bbc6ceso3127371a12.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222272; x=1733827072; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RoLTpcw2i/ARiDDfP5KR0JIwlxbCPGGxl8N0KcEuWeM=;
        b=Iv7FysqTqHnOhgAzHIGB+xICdz4eYT/PCGaWO/0Sa6O5djnTE2r/REb+D5Ffpge/ky
         m7gs25OxNUn/J/jppzA+xExVbfZSnR4+VeXrPpEacTTolFwowL4/T2hjSn+KaUUP9ZJf
         0AeEmY4S9Y6Reb/g+xNGU/UbvHo9FOBu5Z9HLMoNFhO15AnJtB1qD4qf3dw12DqQlQ/R
         7looHuyxa2ddVS+qtpcOovDA/ban/+gqbsyzEkcv+//vUHweQEV8RvAg3Y0nMB9nnw7k
         N4S+A8JVTfq8jKR+YenZgUqQW6Av53LBTpK4LxcvEYyd2WLb+AD2J1sZhb89YWUEMz5j
         8qkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222272; x=1733827072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RoLTpcw2i/ARiDDfP5KR0JIwlxbCPGGxl8N0KcEuWeM=;
        b=QfhZ5N9FEsb+AyiN6OjANOQnM4VdWMZFORy+y5I1a/HPnjmMuRctUQfksw8GEdErrx
         8qwJPaxyDAkDQcTHES3ptIcZP4X9Q+9P5E8xso+6+ehsKUgM02N4i9KWBhCS1FtB+Qkp
         9E4nSdAurUc2zPQZq9H7+0LVwN2ZECiKAqug7yw9LjYBDcKo1gdRjyZvctO3DzSt3PMJ
         UQbF4hXJ4b2eIjgYY2YySap340jcRprmaIa8szsOLHS8nFNSbOehThSBRjrbg1kB8hI8
         B7AQ7+Lab/QfE2LYH8BPh9LwIK8nsZYW3e0uG3xl8FV6/0y8x+ha7p8rBfu3A46Yuqut
         /woQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxxIj5u1Zmz169eFaT4id6xKZpljKdVjYFEMWr3gfLkXaz8kHoLaEwLJdnhwszD4FCozy2I0o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQ4wEyN8vTvbkDy7m2/Xos3iJkG2ak0szE/JaOIqM3ITCEUP+n
	C9C8MRSlUKVdExeNYERQz2f+GsX6cmwVwjnrUqKUTlUOzRWhsXya2A90g5KDRVJntQFYAyysbZH
	ltEbUWA==
X-Google-Smtp-Source: AGHT+IGydksz2oitkkS+PzunE3Xo1LLjOTwrM0JRUgGZOInmX86+vMlVFPZJqRfsJ77VjfmAauob+8D8Wh13
X-Received: from edtw23.prod.google.com ([2002:aa7:cb57:0:b0:5cb:ee45:27d6])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:27c9:b0:5cf:924f:9968
 with SMTP id 4fb4d7f45d1cf-5d10cb4f7c1mr2156507a12.2.1733222272258; Tue, 03
 Dec 2024 02:37:52 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:24 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-8-qperret@google.com>
Subject: [PATCH v2 07/18] KVM: arm64: Make kvm_pgtable_stage2_init() a static
 inline function
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Turn kvm_pgtable_stage2_init() into a static inline function instead of
a macro. This will allow the usage of typeof() on it later on.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c2f4149283ef..04418b5e3004 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -526,8 +526,11 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      enum kvm_pgtable_stage2_flags flags,
 			      kvm_pgtable_force_pte_cb_t force_pte_cb);
 
-#define kvm_pgtable_stage2_init(pgt, mmu, mm_ops) \
-	__kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL)
+static inline int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
+					  struct kvm_pgtable_mm_ops *mm_ops)
+{
+	return __kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL);
+}
 
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
-- 
2.47.0.338.g60cca15819-goog


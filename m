Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794231287;
	b=beC0psxMwcKLLZcluoXUU9Oth0ZYlHzY8DSJn9VWxz425W+8BURHaB+EgPU0FktZoQIF
	 DH3sufJtVpUtE7ODx3xpgYSy7Cthm0lHOISL+jEqWXZZk2oCJXZ0JjpMzUSt9F3hbSd9+
	 hAuaWzgZgbt8S1Uo5VZ1oA+7MRaMCgnfpKg+5DMGNcWCBoNYoQzjYxgKs4eT0Leb8a3JV
	 V5Q08PzqlwRQMuu7ZKMMoxMCHgcnfdu6sB4XIbfVb4R7U6hJ7O8LO76z8JiHqFHThS4VV
	 4NpigyjIaA1AbjpK3BqXEIgNxWfPvmxpfoOuU1o41fLZk3SOjCNyUpkZg729UyA38kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794231287;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n80U4YDXqK/o+oYAQLvAWwG1xx85IlIvZcYTxm52F4c=;
	b=VI19b2Q2ibErOa2FbXTOMB2iEhweiJ+ynRZ1oMLH6lNB6W0LFpSqtStZce7BBFPEmlLj
	 l4mFOXqu0JvnVI+V5iLtUylSdxv8/hhW5nD2B+lZNRvN6d1ofMzHTLMPe7m2Md0mDFKmp
	 yFL+o1v/P75fW4/hDU/auuYDSLWipUbD5E2OcyxqB4d9GEsYfMGMFfMlG70Is8vdwWHD0
	 GK/4+hvCF9yaPyxhyG9G7C0tlpkx1H8qQ3+Zx1k80823Pk8UH4MCTT+25Ev5V3z6miTnB
	 ZIFIydNUMMnqo9DNJ319oE6CZZ/LQ0Yy4vCg5lLVkmKjSEAfZEnPSfmR7EELxiDg1OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uh+vvbxL;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFE8606A336
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 13:34:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CFE8606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uh+vvbxL
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e47347279so567850f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 05:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794231285; x=1794836085; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n80U4YDXqK/o+oYAQLvAWwG1xx85IlIvZcYTxm52F4c=;
        b=uh+vvbxLSPq8XgVJ1uWYv6lvBHLUEditsUtCpn0dLf6C7CVfQoOE0GGpGY5rzffj+E
         f146JP6rX+uUgdhfuW1AMzvDrnBb6I944o4M7kOALCUgQ28MATly9FAAox23AHboVP9p
         tApv0HbFFPUH+uh3TslJNwpqrd2QWRHGOKLB/2O8wFOCbBEoMiDgXDyV+TxzFbDzuORM
         sXoymGdTVDx4VKWKJ5Wv9pBaJVu+/QDAb1cQTeHf8dJirMjRq33WWLI8nWYNIwjCUVDp
         cl/U6bS7v0nvu2ZuMvTD223UZNBMx8Cry+1IUrTTSOYYI4e8R7PZkgWSXLjbYQ2OUjXi
         d1vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794231285; x=1794836085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n80U4YDXqK/o+oYAQLvAWwG1xx85IlIvZcYTxm52F4c=;
        b=mY2gY05zRjDhzlszesEn5Artru8apQ+aDU/kn8OWbvRlJMMGxZ4sMMtuy1x6zrM8Jr
         hpvnVP2Db47QJEALXHjPBOhHGu43C2k9w2IzZLAn+DhYCqm4O2LCTfrc0sNNmfbEJjT0
         OpCa4MGZqxqRaglyORdDDS4OANt33Ow9Zui1U48ij1OVkOXWmkIMpuBBnCj8tO3H29lg
         nZ+RD/zdqZ74IX3tO5F8BPaVgjKqRbtz6sV+Y5raUEQY9do/430TCTjdFGoRlYz9993e
         g50S9ocXoA3/ShYJIJTWN3diP+RMp7yOB16aLfV6bHXfk6DoC298BAHFRKRC4ViObrtE
         xBRQ==
X-Forwarded-Encrypted: i=1; AL+hErFQar0JGQ1OTn2tqw7rXVV4GkjQeDjglvgVe5deNGxW3ceNatzn687FkGrpbv9/IwBezTSanro=@lists.linux.dev
X-Gm-Message-State: APuU4Z8ibzxeNdeHzsGNVogqhR7LUoYO/W1CSg2FbxRb4Hntk/Tf+gJs
	zld4/qXcCLI4+rEqrzYmwzqznzfQmryZiNA5M+c7PuzFnEJmBQ2fwau/TTBZ+0RJ
X-Gm-Gg: AYBFou1w3X0FMbEk7+hg87Alt0E4sUt3hb7arJYF5bMmSXuNW/y9YM7uwrb2bi5nZAw
	stcGHwsdS/8p4ADrQnmXS4ScnJTXvDpTddciamj3R09uES/64EwmQB/gXsRa9RaN6lgBRV8hCY4
	ygjNEOceVo+zQe7us3UW01C9117957mCzT5MfXa1OPfr1KpMlvLt639yJAYO+2xonfnmYb8MR01
	aB7gcJKCKVnLo4OI+ElsuUhmrnVc5nmUQldYgOsDfuqUPEUyB2pCAf4hZbKRYi9RB9NxRIHjJgL
	h/gIoTZ9gM7LaFV63TRtzsgUH7EoKz2v+0jSA6hLrqhBx2lo8J9HnJXGe4OGuQnH5wtmhbMhtwa
	rPVkUvFYbKu9cqy9IReiIjevfbvUyVdRK4Pb0KGYrT6WuOOGIjBm9t5vuuy8k/8RdQ7LdE854lM
	0lWTCvDtnN2nX9dCYJmWvvMUPlwJ7ZS4LrWYnHAA6iXaORK4DdwhW9d10hzixAoaCukf4a6l151
	KjbojyvZZCp8nT9Qbs1iJ2Fo11J6lUI2c8Gk4LjlRhjnVeuBTPTuGgFdiPJwet9f3D1Ylp4A1bW
	WOaFZK/hCsNLHKCafCHDvSv8tuYdTX1K+CIfkCLmiAzHwXU2DQ4qehWGNK1NLjB9FPcmGm5Z9cS
	O9MT9J3O+qKr+D9u8BxYvQL3dJA==
X-Received: by 2002:a5d:5d87:0:b0:48e:5444:a1d3 with SMTP id ffacd0b85a97d-49583ee2114mr8567019f8f.11.1794231285303;
        Mon, 09 Nov 2026 05:34:45 -0800 (PST)
Received: from PKL-HASEEBA-LT.. ([39.36.57.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39899sm9140435f8f.3.2026.11.09.05.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 05:34:44 -0800 (PST)
From: Haseeb Ashraf <haseebashraf091@gmail.com>
To: maz@kernel.org,
	Oliver Upton <oupton@kernel.org>
Cc: Haseeb Ashraf <haseeb.ashraf@siemens.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	fahad.arslan@siemens.com,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] KVM: arm64: nv: Use kvm_stage2_unmap_all() for shadow S2 teardown
Date: Mon,  9 Nov 2026 18:34:31 +0500
Message-ID: <c7e75684a027b1bdf232e7fe7435bd92742b21e6.1794229714.git.haseeb.ashraf@siemens.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cfa77cdbf14d9fd24c22ab1ef9b940a0d7411699.1794229714.git.haseeb.ashraf@siemens.com>
References: <cfa77cdbf14d9fd24c22ab1ef9b940a0d7411699.1794229714.git.haseeb.ashraf@siemens.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haseeb Ashraf <haseeb.ashraf@siemens.com>

kvm_nested_s2_unmap() and the pending unmap that is completed at vcpu
entry both drop a complete shadow stage-2 by unmapping its whole IPA
range chunk by chunk, with the same cost for an empty table as the
TLBI VMALLS12E1IS handler: 262144 unmap calls per MMU with 4kB pages
and a 48-bit PARange.

kvm_nested_s2_unmap() is used when emulating TLBI ALLE1IS and when the
whole VM is unmapped. The pending unmap runs on the first entry after
a shadow MMU has been recycled for a different context, which a guest
hypervisor running more contexts than there are shadow MMUs can
trigger repeatedly.

Switch both to kvm_stage2_unmap_all(). The may_block rules are
unchanged: kvm_nested_s2_unmap() forwards its argument, and the
pending unmap, which only holds mmu_lock, still allows blocking. The
VNCR invalidation and the synchronous completion of the pending unmap
are left as they are.

Unmaps of a canonical IPA range, such as MMU notifier invalidations
and memslot removal, no longer go through kvm_nested_s2_unmap() since
the guest stage-2 tracking was introduced, and are not affected.

Signed-off-by: Haseeb Ashraf <haseeb.ashraf@siemens.com>
---
 arch/arm64/kvm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28..875eb9c312f9 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1441,7 +1441,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
+			kvm_stage2_unmap_all(mmu, may_block);
 	}
 
 	kvm_invalidate_vncr_ipa_all(kvm);
@@ -2160,7 +2160,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		write_lock(&vcpu->kvm->mmu_lock);
 		if (mmu->pending_unmap) {
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
+			kvm_stage2_unmap_all(mmu, true);
 			mmu->pending_unmap = false;
 		}
 		write_unlock(&vcpu->kvm->mmu_lock);
-- 
2.43.0


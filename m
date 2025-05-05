Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A69264A77
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746466341; cv=none; b=AxsI7crQDBM6AOM/Lx3jzU7SqdDBsb6O97JAm4y0dMtGrfNOteyGSumA7Q+h4E41hvFw4XDEc8+l+FHvQyBCcE2m7RvwJ3+8gcWMjez3dP/eFzLcO1mIk+gB+YcC8BQD5MlvsVpYTz4CUdMUiE7YVW39zhSCKSJYezFWulSdaVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746466341; c=relaxed/simple;
	bh=Sirt4gr8r2sZgygHZ7WpIIJ0uwlYX2WulgE8mLU8plo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=RSOv4cp97Y6zTx49sBuFmOuHhXGiAWhHOHTwV2Tplkztv4XeJuJcuhvNZbuhm7I0+9riPqcPCa9ypJbB2Fj/BI0dopSflKwDJIuOp1OzlRrGYFFbBbjtj3acZofbxH13/Ls6lvuK1HDOh8SpGuj4olUU6DzYnI3FawFKxjoPdfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CyvYvDI8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CyvYvDI8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746466337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JjAxyTaB2HZtvewgEgyYKDE4ThQVrWuUNuivvsqnLN4=;
	b=CyvYvDI8ufORcNsNs5MpCkj5wllOSwb9TA82amlfvBe3BjK4aX/UIWlcIVRVShtew0wwol
	+P0adLJia+z1aR4h0mT8KNUDaqGzqChDjx5C8IxrcSDCDe+uwY9JJzeYRUtnYKIDY8sVn1
	GL8H1cJ6UzTY0+9CDxdpNMvN1N5gPHM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-5kvrwfSHP9Wy4gFYi8mimw-1; Mon, 05 May 2025 13:32:16 -0400
X-MC-Unique: 5kvrwfSHP9Wy4gFYi8mimw-1
X-Mimecast-MFC-AGG-ID: 5kvrwfSHP9Wy4gFYi8mimw_1746466335
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so25208365e9.1
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 10:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746466335; x=1747071135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JjAxyTaB2HZtvewgEgyYKDE4ThQVrWuUNuivvsqnLN4=;
        b=NXMTBUalb/hHdO0WSvD7O6T5MdIpBFkxPKB9BHDaPThIJ1Gwm34Ivx5ht7RsH4tEbP
         HLh5CHpkn6IXNyUVEaH0aDi7zCwrNwZLtvtZ41CouXeryNOc3JtkbeceLnVL+KREiGNH
         RLW7smukwQQgLr2yU7G4ZvpkPX7W5hx197Ps6Fzj5GbgI2Py5vHTkEWxnDsNNrO/GWDE
         c5dxzsFkwB9IdVk/S+Lz9TzLA/ghTk89nfazltIt74RTXrE4ZNka6n/v7i0U5wdMO1Cn
         Hp4GsxMs2AEhceTTw/TYuDVVxRyL3Z/wxgScWFz0+dllrT7yDfh5r2KdvTFdldojHSUP
         lsJQ==
X-Forwarded-Encrypted: i=1; AJvYcCULitKjN7ZGkjBhYqtq8DKozAVDl206ACmvxd/8F/sZcFEPqKtfcuuiGq6qGO+Gp6W9pLxrcN4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDUryOh3z1uX4jT1B+ut+HUoCP48lf04kW96Xw/yToY1RdlFie
	A5+ihgVxKXxHsv3mFjz3d/6l0Il4Xli/952PiL7RkjFDzHUD540E65qSgCFcvDAHHb+E7xlNWwM
	BcvgFW0FbbnI13tSTBiy/Q1s56sDNW7Ou5ASYdnZMo+SO7dLfTBRzLQ==
X-Gm-Gg: ASbGnctAQWrUXK//t5yv1ySs3RQPq5LyJ8elQ/O7tnzRixAdpT5v+D2s9GQ5CeuDsIB
	7LwkRm4N1QarDjBTtqkyAMsN/8wyjpeVKd38UVY5bI8dikqd7P9HenZxsXD1gb1ms2/mfmNkUIQ
	p18GTsehonLF85KvKoO75pz42sSdVpcQwJRIZlCTZ1IFtjBUkReVhuvBg2kOuLufoIw45rpkOOG
	unwOPmzCOI5bZiW+2a511M/n0y8ZT/YQNql30n8ept8fCIqHAJF+L0zCCFCuck4cB8SpFK+upHR
	x3Vl0DEVsfvyEyApBz0L0ZENlbnuaeaNguRoa42PckDRnzBlTRCG6XqjolETgmaqDZ0RNOBV6w=
	=
X-Received: by 2002:a05:600c:a401:b0:43c:e2dd:98f3 with SMTP id 5b1f17b1804b1-441c525facbmr56096385e9.21.1746466335029;
        Mon, 05 May 2025 10:32:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFILc2vKI3/xP04PnDAD0gBqfLoTJ7gk5HkYL4nRmV2jGTs1rwbkDQtRYRRFH+l5ESk0GD4dg==
X-Received: by 2002:a05:600c:a401:b0:43c:e2dd:98f3 with SMTP id 5b1f17b1804b1-441c525facbmr56096055e9.21.1746466334623;
        Mon, 05 May 2025 10:32:14 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae0c3dsm11343310f8f.12.2025.05.05.10.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 10:32:14 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Fix uninitialized memcache pointer in user_mem_abort()
Date: Mon,  5 May 2025 19:31:48 +0200
Message-ID: <20250505173148.33900-1-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nS_JjsEX0cQ-sW0PIgcxHSdZ0Y462D7JPpc6D8oflek_1746466335
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Commit fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM") made the
initialization of the local memcache variable in user_mem_abort()
conditional, leaving a codepath where it is used uninitialized via
kvm_pgtable_stage2_map().

This can fail on any path that requires a stage-2 allocation
without transition via a permission fault or dirty logging.

Fix this by making sure that memcache is always valid.

Fixes: fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM")
Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/kvmarm/3f5db4c7-ccce-fb95-595c-692fa7aad227@redhat.com/
---
 arch/arm64/kvm/mmu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 754f2fe0cc67..eeda92330ade 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1501,6 +1501,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
+	if (!is_protected_kvm_enabled())
+		memcache = &vcpu->arch.mmu_page_cache;
+	else
+		memcache = &vcpu->arch.pkvm_memcache;
+
 	/*
 	 * Permission faults just need to update the existing leaf entry,
 	 * and so normally don't require allocations from the memcache. The
@@ -1510,13 +1515,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (!fault_is_perm || (logging_active && write_fault)) {
 		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
 
-		if (!is_protected_kvm_enabled()) {
-			memcache = &vcpu->arch.mmu_page_cache;
+		if (!is_protected_kvm_enabled())
 			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
-		} else {
-			memcache = &vcpu->arch.pkvm_memcache;
+		else
 			ret = topup_hyp_memcache(memcache, min_pages);
-		}
+
 		if (ret)
 			return ret;
 	}

base-commit: 92a09c47464d040866cf2b4cd052bc60555185fb
-- 
2.49.0


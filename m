Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D209E306486
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820217; cv=none; b=BEdJbY0sLH7/P4mV/hELTfeB0Ie5lNZssCxm85Dj3skdvfFF3HS1SNHjkvHSMgT8FQEPX8yMiiQWC50C7lVUj806wrmpUxayEzYfxi4Wz1VNEpAsSkC28iOiPgfYHQpLnIVF4TMZR174jyj7bATHWndBXGszbaAdU+eu0qI7WaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820217; c=relaxed/simple;
	bh=hHBy7RNCqQdK/4x/L31X5QTyIIyoP30NeIlkbmSNm5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIBkG5tjll0jw/IvovZ4HmOdLdd56TMNWndxZio/v3yZaj1ce8JV9Wsc1q1YpWJm7JWsmAMU2GMchDBmAe3jYBtnnhOyJw1jg4UMR0Ag8XxFuvJjdpMVO0KNpF9hkSVYxykzgIJm3erGVflfyjVLSkWDWRiTNprv1oJ0lfZXazw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaN7AVGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaN7AVGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A363FC19422;
	Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768820217;
	bh=hHBy7RNCqQdK/4x/L31X5QTyIIyoP30NeIlkbmSNm5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaN7AVGN0DG0+GJap2kqxp00Y4UJjoXvrnDhHVGdrDdSEtXlXwc9Lnom8UiwouSXE
	 NaaP8p+DyJmWeugnivUPMGzmn4TM08OQom8iqfFtGBcze+AlDnKy2CEshMYSjd8ud7
	 h+RPZKdIWDhvwmCsqqwwRi8oxxJVhEOYqX1UDQQj/Wwh50+MdcW+9V2b9xrHf+0xQ/
	 meD5ho5ZDavEciEQBEfJWA1My5y3bTPmJ/fq9vQbs4xhWIFkcD8+CFednpVfsKDU7g
	 nt01YJLRubAzB7GA+vNHGZ2ecBEB6bjKyTzHzl8dNYygEilyZ6vdPwreRYRxLYuLqX
	 X3DVaWcUEx4MQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vhmwJ-00000003YVK-2d7J;
	Mon, 19 Jan 2026 10:56:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 4/6] KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
Date: Mon, 19 Jan 2026 10:56:49 +0000
Message-ID: <20260119105651.255693-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119105651.255693-1-maz@kernel.org>
References: <20260119105651.255693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since we have the basics to use the S1 memory attributes as the
final ones with FWB, flip the host over to that when FWB is present.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 49db32f3ddf71..38f66a56a7665 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -19,7 +19,7 @@
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 
-#define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_NOFWB | KVM_PGTABLE_S2_IDMAP)
+#define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_AS_S1 | KVM_PGTABLE_S2_IDMAP)
 
 struct host_mmu host_mmu;
 
@@ -324,6 +324,8 @@ int __pkvm_prot_finalize(void)
 	params->vttbr = kvm_get_vttbr(mmu);
 	params->vtcr = mmu->vtcr;
 	params->hcr_el2 |= HCR_VM;
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		params->hcr_el2 |= HCR_FWB;
 
 	/*
 	 * The CMO below not only cleans the updated params to the
-- 
2.47.3


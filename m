Received: from cvsmtppost106.wmail.worksmobile.com (cvsmtppost106.wmail.worksmobile.com [125.209.209.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2AA31A071
	for <kvmarm@lists.linux.dev>; Wed,  3 Sep 2025 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=125.209.209.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756912505; cv=none; b=IDWs5d+9JwhbymUWcMGVdJmFmnZ4IGT0VWxbpO3AOCy9PTaNX8mEaxSJh+R/RakDZato03Q/D7cDH4lorKLIfE14Pz+RiN2ia6aR0GOBDBT1w25ebyPV7f3rlwqn0ODXBwi4Lz3toqY/+1uQAWjGGTntlvIp0j2uu3nsC7/lX98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756912505; c=relaxed/simple;
	bh=3FhiaCfmZwkYLyKJbI+B3fuYEbKg6EUl6NdwQ1AxukY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qe/oBdmLa9lukXA0GgXs1GzMNDoy/v7250nMg5YD3GBbSKJhHPHEwzX6CW78SPwftHDqedMNRa54gf1RU9OE7ztJAgzGtsV+/kjy/S9HjMBpZ/f7Joz+yQUTbJnCUHhAHU3lWlkjfcOLnpXFNyc/qqdt8jL+ZycJ2Upx/CWichw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=korea.ac.kr; spf=pass smtp.mailfrom=korea.ac.kr; dkim=pass (2048-bit key) header.d=worksmobile.com header.i=@worksmobile.com header.b=yoeS5+qL; dkim=pass (1024-bit key) header.d=korea.ac.kr header.i=@korea.ac.kr header.b=dsAQssHO; arc=none smtp.client-ip=125.209.209.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=worksmobile.com header.i=@worksmobile.com header.b="yoeS5+qL";
	dkim=pass (1024-bit key) header.d=korea.ac.kr header.i=@korea.ac.kr header.b="dsAQssHO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=worksmobile.com;
	s=s20171120; t=1756911890;
	bh=3FhiaCfmZwkYLyKJbI+B3fuYEbKg6EUl6NdwQ1AxukY=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=yoeS5+qLqwx51cCugDjTqy/HAuqvWmjhXmTMaOBS2ZR7ht81xBTCXx8WyrysE3QJJ
	 gSgUmt9qJF/+tQe0Be5xHgunSYVvJqPVdiNesCr0bjNFoDQ9buoHcHZo8EhUp1TaNN
	 Bi1g2x4atDw8iIZxYz+Q2QPUv/GR6OkS2GiMmMxTrblO2qwMoHvyZD/Bc4ytNOdLMT
	 /gABI8y93gSX733fVKDQEx/7ij5xhAHoxlU3dN8WV5zK0+rUcqLFPyZRfH+1JWOc3w
	 eiZynDBdqJTxRvegMLncIkSI2U/qOotbvbClgay43HllGGvI3Ii730J6WafNYQgux5
	 zSXJ6ZSqz7U2g==
Received: from cvsendbo004.wmail ([10.113.20.173])
  by cvsmtppost106.wmail.worksmobile.com with ESMTP id Qniq3hUMSBmsB4KxPkCQcg
  for <kvmarm@lists.linux.dev>;
  Wed, 03 Sep 2025 15:04:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=korea.ac.kr;
	s=naverworks; t=1756911890;
	bh=3FhiaCfmZwkYLyKJbI+B3fuYEbKg6EUl6NdwQ1AxukY=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=dsAQssHOInAbkx77EBdrK50Cc/qJksE186U24D/5Hg2iqMTOllmi6xSx1+WQ0F07J
	 FxMh2k/I/PrMUpjvEbjaVec/KRkpTAkK1Uyw9yWZcQy8RDJWHvg+yC+B41ClQHQeIB
	 8vNSBIBg917LJnvOgvvu7dbv17YwtF5NDwsfwMLA=
X-Session-ID: paH7lmGFTMuO7byS2M2b2w
X-Works-Send-Opt: L/bwjAJYjHm/FqMrKBmmKxg/FACYjHmm
X-Works-Smtp-Source: VdnXaAM9FqJZ+Hmmaxtl+6E=
Received: from camellia.vcn11051708.oraclevcn.com ([130.162.137.185])
  by cvnsmtp104.wmail.worksmobile.com with ESMTP id paH7lmGFTMuO7byS2M2b2w
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Wed, 03 Sep 2025 15:04:50 -0000
From: Geonha Lee <w1nsom3gna@korea.ac.kr>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Geonha Lee <w1nsom3gna@korea.ac.kr>
Subject: [PATCH] KVM: arm64: nested: fix VNCR TLB ASID match logic for non-Global entries
Date: Thu,  4 Sep 2025 00:04:21 +0900
Message-ID: <20250903150421.90752-1-w1nsom3gna@korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kvm_vncr_tlb_lookup() is supposed to return true when the cached VNCR
TLB entry is valid for the current context. For non-Global entries, that
means the entry’s ASID must match the current ASID.

The current code returns true when the ASIDs do *not* match, which
inverts the logic. This is a potential vulnerability:

- Valid entries are ignored and we fall back to kvm_translate_vncr(),
  hurting performance.
- Mismatched entries are treated as permission faults (-EPERM) instead
  of triggering a fresh translation.
- This can also cause stale translations to be (wrongly) considered
  valid across address spaces.

Flip the predicate so non-Global entries only hit when ASIDs match.

Reported-by: Team 0xB6 in bob14
  DongHa Lee (@GAP-dev)
  Gyujeong Jin (@gyutrange)
  Daehyeon Ko (@4ncienth)
  Geonha Lee (@leegn4a)
  Hyungyu Oh (@DQPC_lover)
  Jaewon Yang (@R4mbb)

Signed-off-by: Geonha Lee <w1nsom3gna@korea.ac.kr>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 77db81bae86f..24eab94d7d7f 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1276,7 +1276,7 @@ static bool kvm_vncr_tlb_lookup(struct kvm_vcpu *vcpu)
 		    !(tcr & TCR_ASID16))
 			asid &= GENMASK(7, 0);
 
-		return asid != vt->wr.asid;
+		return asid == vt->wr.asid;
 	}
 
 	return true;
-- 
2.43.0


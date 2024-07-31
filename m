Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB6513D523;
	Wed, 31 Jul 2024 18:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722452361; cv=none; b=Yf1Pta4LKwjT0KpQA3qM7Tig+UWlkB4MuSi8FfcOBsjlBRRxIKjcBOEPKPt/YXMoMs6OIjqe12hz6Kt3g4r66gxzlEzhYDXpaMkyY19/g57ZzWMNPEPuSm+hh4xE1uUVC+Ti887xzGGYFQeztj9EkIeqPpQrtHPTimTAs7b7IpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722452361; c=relaxed/simple;
	bh=XSg+lwQ2g0nRVDthJlG8jLEJHyIpajpAAFoMvVS2r5k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b9Q1HS2gF57q5eaqeOWlYPlQxn9VOaaIlmfgvrr+Bd4G99TkPHSGSHVH0+jqkUa2hMfbgo2zZjpXoyH1KFJIjtgWvK0Uscb5hxj9S2iC//uMK/mtDs440BSONnnPKtmpX1tWwmnDg/EVjXGO+PvpkU3nDUoa76rBfF1Y5UFKTqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vESV6yaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vESV6yaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D653C116B1;
	Wed, 31 Jul 2024 18:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722452360;
	bh=XSg+lwQ2g0nRVDthJlG8jLEJHyIpajpAAFoMvVS2r5k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vESV6yaq+se8b/obD5lptkajKWudiLt9pSQ9lwZc3cId+JXJiC85ZmYUFN5Oj6NIC
	 JyRcKhkm3kcezmQDUMYsdALc+66WllZVwa/4wuptaDf9Q2xmuzvdZhu2WtK0gYy74h
	 mCFfyhbcs3512drL+X4KJDwOgZA3jjbcSfpX+6eNS61u8Edx8g4SPdMRJO2SqBdTgh
	 d5L+qCQDKKuzJ76eeXwXbR+0ZTJDH+a2ZERVSTsv8QMYFKH+VS49JplnK4Xzf5Yz0E
	 lKiqB30Y9xrtjJdF+ckAbInzxvjQOFXHg53hCaWWglxWq1ZDVlHghAz0dhAn/Ti80E
	 BOQKZuzv5DtNg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 31 Jul 2024 19:58:37 +0100
Subject: [PATCH 1/2] KVM: arm64: Fix outdated comment about incomplete FGT
 bitmask definitions
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240731-kvm-arm64-fgt-doc-v1-1-abb364f8fe57@kernel.org>
References: <20240731-kvm-arm64-fgt-doc-v1-0-abb364f8fe57@kernel.org>
In-Reply-To: <20240731-kvm-arm64-fgt-doc-v1-0-abb364f8fe57@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=1401; i=broonie@kernel.org;
 h=from:subject:message-id; bh=XSg+lwQ2g0nRVDthJlG8jLEJHyIpajpAAFoMvVS2r5k=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmqomCoNLrvAvRpKGkMdbEwhgsRaot3JhlgytOQAJI
 6WjxHLuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqqJggAKCRAk1otyXVSH0CmpB/
 9C4Ym5KBqxoNgXRss3lajUhwhZiOEoo5xFr6umTw5c/SWiK2uOVEKgElVyeM+yAOJE4KOX8zFQqHSd
 S+AMf1oXBbEOchQ/ULdIALTqTGyjMZ1kJEdSTCl5ljGXkqelqZ+qrbE3DZEoqQ3y/hTuMRyrD2ENuK
 yi4wODmI7ksUEcbBFJtdnYD5Zqi7vpzMGy+1Xnl0G9wJT2+gVgYWDnFvnysNcPWzYuGy+YXSNJbfd8
 lhrgAiK/0u4qG46xWwst+dVzWjUzDcFgXc8TcEWSEOeMjSsZc+lXy/hdrnZyomm/fiQSiKf93kXOCi
 5c9KFx7FMOPYTNY+OkZn5k7JtuR3XI
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Comments in the code say that our definitions for the FGT registers are not
the generated ones and are updated only as far as DDI0487 J.a however in
commit 9ff67dd26a9e ("KVM: arm64: Use generated FGT RES0 bits instead of
specifying them") we updated to use the generated definitions, and as of
the release of DDI0487 K.a the XML in DD0601 is in sync with the ARM.
Remove the outdated comment about divergence.

Fixes: 9ff67dd26a9e ("KVM: arm64: Use generated FGT RES0 bits instead of specifying them")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d81cc746e0eb..d347483395b4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -342,12 +342,7 @@
 /*
  * FGT register definitions
  *
- * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
- * We're not using the generated masks as they are usually ahead of
- * the published ARM ARM, which we use as a reference.
- *
- * Once we get to a point where the two describe the same thing, we'll
- * merge the definitions. One day.
+ * RES0 and polarity masks for the FGT registers.
  */
 #define __HFGRTR_EL2_RES0	HFGxTR_EL2_RES0
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)

-- 
2.39.2


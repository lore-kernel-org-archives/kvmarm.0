Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3CA3090C5
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771530949; cv=none; b=Z9u4hUTYbwxJDai9f+rOUTV58W1VddE0jCXmZbNFmmER+DEr6hxl0Wp2vE/LKd9gqJ6BOUZRQl1hOyPwlUk+SK/17NmVBzZIdWWx2uSdQfY6JUch2CesVB0Bsu/VB+C8D0E7JQxipe8pJxArsDKiCkobARF84b3bZ+Yn/6NcYXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771530949; c=relaxed/simple;
	bh=IhAX95LdoQ8+4nwPLbvRaw+mcpWGJGreooYLh+/dXf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjBJfN3E8jE0pRFHEVNaYaxFJeZU8EIOcrSs37BEZ3By5sfI5xx/DVVggymBNXOeH5cphnrzZPaNSVTIvyRLQX1LKIdjmcPqbm5zJfSjdS/0pgCUnGYkzv2sMvB+/fbznr6pf7ZzXFbG4b0STGpd8xJgImTEtxfREq0UzK/UBYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+Z8SdIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+Z8SdIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084C1C4CEF7;
	Thu, 19 Feb 2026 19:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771530949;
	bh=IhAX95LdoQ8+4nwPLbvRaw+mcpWGJGreooYLh+/dXf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+Z8SdIjWFIKVvQeQ7Kam1DgyReVosNwqRf9keumfSTspmOdRtjCv9Bh9+FHM94jp
	 TNIWeAVz6N5Q4Xt6BBISt5p5U8Y021zpbla/+W3nk1buZs10vehzcsHhJepWHe2PDW
	 LFBe1Rq7oTYld90WIrZrrY0Nfp/ac+Zr3IH4bWRdW+jLHpSkmqjXCga3oxeJVW0Dy9
	 5JfNVpB7/OBTQAvSYF4zzQ7vc1WCJ7lEe9+de0AEl+cjbyZakbWLVJtbYibuJIwTId
	 HW6cuOrcWhLbx10JZh1lYfp+UCTEF8Va8KOFLKuWXkESWQMkIbJlXCuqGd0mz7r8c6
	 clZcRbg9bZFWA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vtA7n-0000000CGHL-0d89;
	Thu, 19 Feb 2026 19:55:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 8/9] arm64: Convert CONFIG_ARM64_BTI to FTR_CONFIG()
Date: Thu, 19 Feb 2026 19:55:31 +0000
Message-ID: <20260219195533.2455736-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219195533.2455736-1-maz@kernel.org>
References: <20260219195533.2455736-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Even if the kernel doesn't use BTI and doesn't expose it to userspace,
it is still OK to expose the feature to the rest of the kernel including
KVM, as there is no additional state attached to this feature.

The only purpose of this change is to kill the last user of the
FTR_VISIBLE_IF_IS_ENABLED() macro.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 8eb9dc35cdba4..d58931e63a0b6 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -317,8 +317,8 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
 	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_MTE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_SHIFT, 4, ID_AA64PFR1_EL1_MTE_NI),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SSBS_SHIFT, 4, ID_AA64PFR1_EL1_SSBS_NI),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_BTI),
-				    FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_BT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_BTI, VISIBLE, HIDDEN),
+		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_BT_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
-- 
2.47.3


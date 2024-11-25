Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EFB1426C
	for <kvmarm@lists.linux.dev>; Mon, 25 Nov 2024 09:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732528082; cv=none; b=Iqj6RoxNggpYoknKZMmnTTIvfgM0dsRd1IIU1TQyVzgXP0O0+Nf3qVDwMpAWZy54ETlzLTQYoSkJYODrb+eut91fFOnA5qwjRTTuBn3kdIYmlrEPvSvs2ELc+x7snaqFgM/kGyz95qGU0ugh167ZtS3ZzcHOwopbz9ZkwQdiqkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732528082; c=relaxed/simple;
	bh=fFDoWawgI33eZaEQEGoUTTZhQQtQ+oC/k8T3cn7uRfM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lx8UOGvV0XfXko6WFcxufgpDhPynQMZ9vP5c01xf+WMNjGHt0wTEpYD0O2C3ekVR4FU+X+Jqu1c2B88URKjhujuxsiltQR8qBGf+AGUvsgLPzV4JT98J+6eO4zdHB7kDTOFyHltPGfBk1HxKgonA+VSKCymiyKWhrefsBKijTj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4Kn6JMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4Kn6JMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D86AC4CECE;
	Mon, 25 Nov 2024 09:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732528082;
	bh=fFDoWawgI33eZaEQEGoUTTZhQQtQ+oC/k8T3cn7uRfM=;
	h=From:To:Cc:Subject:Date:From;
	b=K4Kn6JMkTVlXgUG0OA7Uxnxdbb9XjuI1MazRwEcQFVVHRZ7u1QcE2rAzl/TIGR7sQ
	 ZJxkGA/3qMlLgTFKobIswulSFDS6CT7Bf9oLAmBS90kMPl6HYudXGb1PpURDO/y9M9
	 UNMaldMtiUkJBBeJYL6d4li66SfOsyUGynw7RCrQnlsNBSdFP8ssp2b/eel9lyq+vJ
	 Mb/neaAqI1Dzfxfh4VcqHuFfV02OIvsW54iIuUGkZCRpe0zF3bmN7C4bx9z3GAG68t
	 LkAaV6tsO7t0uxbeVeCzt1MVGVg0YHoEfZrmz6GWdLdjjLkDJgvkWqe9xlN4YJtAPf
	 VHkTCGigxEdTw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tFVhI-00FecR-0e;
	Mon, 25 Nov 2024 09:48:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH] KVM: arm64: Fix S1/S2 combination when FWB==1 and S2 has Device memory type
Date: Mon, 25 Nov 2024 09:47:56 +0000
Message-Id: <20241125094756.609590-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The G.a revision of the ARM ARM had it pretty clear that HCR_EL2.FWB
had no influence on "The way that stage 1 memory types and attributes
are combined with stage 2 Device type and attributes." (D5.5.5).

However, this wording was lost in further revisions of the architecture.

Restore the intended behaviour, which is to take the strongest memory
type of S1 and S2 in this case, as if FWB was 0. The specification is
being fixed accordingly.

Fixes: be04cebf3e788 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8c5d7990e5b31..98cb499fa4b11 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -739,8 +739,15 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
 			final_attr = s1_parattr;
 			break;
 		default:
-			/* MemAttr[2]=0, Device from S2 */
-			final_attr = s2_memattr & GENMASK(1,0) << 2;
+			/*
+			 * MemAttr[2]=0, Device from S2.
+			 *
+			 * FWB does not influence the way that stage 1
+ 			 * memory types and attributes are combined
+ 			 * with stage 2 Device type and attributes.
+			 */
+			final_attr = min(s2_memattr_to_attr(s2_memattr),
+					 s1_parattr);
 		}
 	} else {
 		/* Combination of R_HMNDG, R_TNHFM and R_GQFSF */
-- 
2.39.2


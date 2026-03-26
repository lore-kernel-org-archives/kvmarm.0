Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51316405ACC;
	Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539337; cv=none; b=T6q+FBlFbjPNZfXzrj+ty9yY8QSp8A9YPDEh9xKEXzbCTwPpEKsrZ8ujlhiIEvtE9qMyyKyWM//7ymjH9F6VGdpPyjSOVXjiyOU9OlOg3HbP+CMSOO3O5mqwK/eqf2fkm6LyDE15gOgetO4y6kTWcYHmSo0qdccGq4v/ej9YOHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539337; c=relaxed/simple;
	bh=RmLa9GzRXJsahedmoCPhB+xtwC4BH6cVyTiEXjDvIDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEbb6xUeFV+O25YS7548kdVkAmHSocSS/BxeI1b11qBCPmU/MLhOQ0hVjRxqMqbtj/mGPMZu9askwPuHm7gGxsbpz9bEDWBPixRb/ArNkJlSD468jhK9PAdTx6ICx6EsWKnZR7vBy87xKm9m0gDwIM29arZS7MlhkQPlA8IpYSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ugj4mrrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ugj4mrrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3DCC2BCB7;
	Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539337;
	bh=RmLa9GzRXJsahedmoCPhB+xtwC4BH6cVyTiEXjDvIDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ugj4mrrTIo1yZ2LyFlk8NH6GJG+e6AXu2LK6PIOHvzUJvNEIOzZ5DLHSZtE6lB9FU
	 xb7lQ+fbNABDIdcZB3HYeDohLm9DTcbRu/IfEmhYsGN4YbWQTsBa+tvTgeC/9LTmqp
	 1djBNm8fW4GFYmJHlL+PWL/ci1eJ6nfPQ7t8ctDiJ2mcSUdHrGWno0wgMoqO8kDAEX
	 Jn7NFTInau7olHypu81TnZNgwvA1FSPLyc4zcB65Jy+yfPKZyqWC75ZqpKOqZ3NxD1
	 9tiXF7a6T8VgTkGFUJt5NzaWPhMtFFZuc/qA9zgIVR7RpDIq4t99IkBQAudr9evqJo
	 jbVhDmDtIvwNA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkB-000000060II-1FQB;
	Thu, 26 Mar 2026 15:35:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 05/15] KVM: arm64: Account for RESx bits in __compute_fgt()
Date: Thu, 26 Mar 2026 15:35:20 +0000
Message-ID: <20260326153530.3981879-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
References: <20260326153530.3981879-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When computing Fine Grained Traps, it is preferable to account for
the reserved bits. The HW will most probably ignore them, unless the
bits have been repurposed to do something else.

Use caution, and fold our view of the reserved bits in,

Fixes: c259d763e6b09 ("KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index e14685343191b..f35b8dddd7c1f 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1663,8 +1663,8 @@ static __always_inline void __compute_fgt(struct kvm_vcpu *vcpu, enum vcpu_sysre
 		clear |= ~nested & m->nmask;
 	}
 
-	val |= set;
-	val &= ~clear;
+	val |= set | m->res1;
+	val &= ~(clear | m->res0);
 	*vcpu_fgt(vcpu, reg) = val;
 }
 
-- 
2.47.3


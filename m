Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A921F3B95FA
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 23:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780444497; cv=none; b=gVYyxQADu9hqxlgmmb1hyXdNOLYmlmCzJg80SZ3+hibYZA4gXAUxoUZo799pdlalhxQcXiCdTgmwVg12JjqljZI+1EDAdxYy/gD7x15DX+3k3cu6sAdUmhFTiYqUHyFGGP9zg0HnLjrzlnv6qTB3y53XzX0VCkmFOEYEa5lOYtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780444497; c=relaxed/simple;
	bh=qywktVtMQUx+tEA7mcMgg0WUjKueEqFnJEcrcIVRozw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0JTd0PYPqy8pgEbBCaOHnEnS17KLYKP67ZIS+kpWJPbl93zVx2UtVFapWHoFFe7HeY5syF8ohCmOIvYAxvUxdeTG4am55xabWJmWVElyIWLVFUIQjtQ1N9DtrKtcniEuWpJntzR0r03zY0iluAkGL5RQa6ZeWnfLm79AGFqyH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehpJCizx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehpJCizx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B07A1F0089D;
	Tue,  2 Jun 2026 23:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780444496;
	bh=tzJ2/VZZp8UNj8fim2ua/OljCM3ZP0BYep9oucSNJQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehpJCizxnUpj3hklMD6bX4eZqt2fEAjZHQH9JAPTadV/7nMvcfrLtUZryw+n7H2DF
	 avH5j7t0eH/aKV8MeZr8hu4pa0Hsq4C7ZVcnbA/g2V94pMBhsT+zP+BjQetj8OFuFy
	 77pySiJiJn+wQPl/qeu5FDo94a8HYREBio4pHwrPL9lfcGfrrhOxtAEyy1gWN1SDuo
	 XsvJZRzKXSceqsCjpW9WP6n93f56v2lFckkIAMp1gAyIBCdUVQD36V0itHHTQvxxNe
	 H/ZyooV+rLcav4OH+UC9+cGR/NNuoV5m/F8p4nfmJlHqBkRv9YytRp0lDHPNYSHdgk
	 gw4TRjlhLGDmg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 3/5] KVM: arm64: nv: Inject SEA TTW when desc update can't write to GPA
Date: Tue,  2 Jun 2026 16:54:48 -0700
Message-ID: <20260602235450.103057-4-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602235450.103057-1-oupton@kernel.org>
References: <20260602235450.103057-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to the handling of descriptor reads, inject an SEA during TTW
when the descriptor access fails for reasons other than a race, such as
a read-only memslot or a bad HVA.

Fixes: bff8aa213dee ("KVM: arm64: Implement HW access flag management in stage-1 SW PTW")
Fixes: e4c7dfac2f1a ("KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW")
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c     | 6 +++++-
 arch/arm64/kvm/nested.c | 7 ++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 9f8f0ae8e86e..119a603e636e 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -521,8 +521,12 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		}
 
 		ret = kvm_swap_s1_desc(vcpu, ipa, desc, new_desc, wi);
-		if (ret)
+		if (ret == -EAGAIN)
 			return ret;
+		if (ret) {
+			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(level), false);
+			return ret;
+		}
 
 		desc = new_desc;
 	}
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d0545144eaac..f8d3f3a72328 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -352,8 +352,13 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 
 	if (new_desc != desc) {
 		ret = swap_guest_s2_desc(vcpu, paddr, desc, new_desc, wi);
-		if (ret)
+		if (ret == -EAGAIN)
 			return ret;
+		if (ret) {
+			out->esr = ESR_ELx_FSC_SEA_TTW(level);
+			out->desc = desc;
+			return 1;
+		}
 
 		desc = new_desc;
 	}
-- 
2.47.3


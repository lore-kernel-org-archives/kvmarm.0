Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EDD3A6EFC
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 23:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780444498; cv=none; b=VFsfNCAAdF0J95ay5S/eFG4bTjB21yu5OM8VqP6WIrpRNCPLzjIcVCB1cXQpOWXaWn3v5ent2u1/d6uUGYHTQdk+jsJJxJ50q8SyqxkE8nxczJp91je5Fup3eC3k4DQ24gYy8KjkZ9UCalmZZo/mHfuityzNlYY7AYktcB+0tQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780444498; c=relaxed/simple;
	bh=r0wthUi3jn5HPrQURuOCmjomuzsJVZB1AYVmwclcANU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtyjPW3RXPPZdb+xoI/ozpENdSThQuNkl09ZHhKFAkJwudOK7XOueOMjZ9HptKVE0KDhRJr8wXUfGJqwWrIkDDilkNhzbpiwNlNvgoU2LRdqs22OOO/SeLhYScQnGd0ix8NqPvjp2cney2jwiXFwOIlVMpCiNnLcWlbBO0xx2u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQzYAaxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQzYAaxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4681F0089C;
	Tue,  2 Jun 2026 23:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780444497;
	bh=qLw5B3Vvecy6bUO6JY+FC/YUR06xZsdpZrc65nkyjWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQzYAaxg9/DE8MVj+B1Jz1tkKoLdx50Ss+N/6ewgjZokt4bEAMiBUiyhCCf42FajU
	 zF4ljAV2QxSdCMcmh9vRspaY7brpIj3LsOJSLXcecYn5iHYVeC4iCjbu6ha+3OgZ2M
	 lg5XwALiez3Va+Sx3CiJeI6qpBoB3zsCT30niF0EPGuBb5dMFFxufhPgHOi7ImxqHw
	 DHmqXOvKqIDFPhhO+0vhwsqb2NqMs3yYdtRlPnx85SuK8XvXfYYv+hMKaUaWN2tTwZ
	 Ia4ruTc3ykBBssQgst7vDmyg8OGfyO7dbZyLmYp1X7yWfx7SKv7BFdrzMnmBcdEVm0
	 iEg5dIB15yC7A==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 5/5] KVM: arm64: nv: Restart stage-1 walk if stage-2 desc update fails
Date: Tue,  2 Jun 2026 16:54:50 -0700
Message-ID: <20260602235450.103057-6-oupton@kernel.org>
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

kvm_walk_nested_s2() returns -EAGAIN as an indication that an underlying
descriptor update fails due to a race. The expectation is that the
caller restart translation, yet walk_s1() actually synthesizes an abort.

Propagate the -EAGAIN return out of walk_s1(), relying on callers to
restart the translation fetch.

Fixes: e4c7dfac2f1a ("KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW")
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 6cc5892023dd..4d4285e60fce 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -423,6 +423,9 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 		if (wi->s2) {
 			ret = kvm_walk_nested_s2(vcpu, ipa, &s2_trans);
+			if (ret == -EAGAIN)
+				return ret;
+
 			if (ret) {
 				fail_s1_walk(wr,
 					     (s2_trans.esr & ~ESR_ELx_FSC_LEVEL) | level,
-- 
2.47.3


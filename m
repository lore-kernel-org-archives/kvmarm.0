Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052E9C120;
	Tue, 13 May 2025 06:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747117741; cv=none; b=CSNhM4ou3xGibUGthQHtBcAI4T0+G8vlmpzytvFD8zeGExxKpV2OBWBtdLgNEZ5Cbasf+HE6c4vgNKj4RnSXY9yKb8IpYdBWZhAxRCqk40fYjbNY729cT9pTI49pY2l+1XwvO+4CDaCDiG1xjitFl5/AXgtHV2o5BGXmnWhtVfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747117741; c=relaxed/simple;
	bh=CS2K4IBTS8BkewmPKf8FL6tLALwgWKThVfrXRfxYC+8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MVTXPgKXzqHf1tPPZF1RAnB0YR0OBFRRldLf75hAJIQ8wH/zLDwRgHUw0lgiOH5o5eOvn4MQP7YxtFEWSHF2jKCLbWZndeqvHWWWG+KsYsMq/w68vTFT2M96CrffpssF0WnKtb+Y+7gc/XvzFZOt7SQyuL4WYZRDcqqU5jvX6mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dqm0UN82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dqm0UN82"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81838C4CEED;
	Tue, 13 May 2025 06:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747117740;
	bh=CS2K4IBTS8BkewmPKf8FL6tLALwgWKThVfrXRfxYC+8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Dqm0UN82QsfC4IQP/Cp66v3A1+Ww/WMaecVYDP4VjXCwpB3PAqxXIdYKQ31lj2bC6
	 g3YdR99MU4ZMe+Tc44aqWBGRC9BD5nq3a9N5tJ1poXYgvDqUrtUkHXRAaSt4nni0UF
	 lP6psQWqFDko3jhH8QfJBioRZdbI1rZeX+geLEH930tpEIJchSBMQmGYux68a49iea
	 SEC63Gqe5N2+Dzw9lF5Js+VMnOciEeOUbz/N6u+wP0oApZLxr54DcLfVehzik7RaNd
	 WfMmzJaU+9h7VzMXD/maBUJuQ8UhUlsU6JXbEDnD7OJ6xkO6sQzpCRKv+B2T4jUwyB
	 nE/lxI14+gryA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C62AC3ABD9;
	Tue, 13 May 2025 06:29:00 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Tue, 13 May 2025 06:28:30 +0000
Subject: [PATCH v3 1/3] KVM: arm64: Restrict FF-A host version
 renegotiation
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250513-virtio-msg-ffa-v3-1-d66c76ff1b2c@google.com>
References: <20250513-virtio-msg-ffa-v3-0-d66c76ff1b2c@google.com>
In-Reply-To: <20250513-virtio-msg-ffa-v3-0-d66c76ff1b2c@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, sebastianene@google.com, 
 lpieralisi@kernel.org, arve@android.com, qwandor@google.com, 
 kernel-team@android.com, armellel@google.com, perl@immunant.com, 
 jean-philippe@linaro.org, ahomescu@google.com, tabba@google.com, 
 qperret@google.com, james.morse@arm.com, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1747117739; l=1163;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=Prs9vwH1PpI7boVTkM9t7dd2Gj6IXNMISFZbJ9u0HHQ=;
 b=iD3MoRDcl6vsNTRQcIKy81Aq/kHV0QjJvlLIp932eUrLbxYG5Q8loKlRusWWZDX7lgiC6r6kh
 mqLFZjkse+hA86wrqJ46kG7NDve/h1wBZyoRavVqXmupHV3UmqOlBhP
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

Prevent the host from re-negotiating a lesser minor version with the
hypervisor. Once the hypervisor negotiates a version, that should
remain locked in. Fix the current behaviour by returning NOT_SUPPORTED
to avoid the FF-A interoperability rules with lesser minor versions that
allow the host version to downgrade.

Signed-off-by: Per Larsen <perlarsen@google.com>
Signed-off-by: Per Larsen <perl@immunant.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 3369dd0c4009f84ad3cf9481c747bdc57a162370..2c199d40811efb5bfae199c4a67d8ae3d9307357 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -712,7 +712,10 @@ static void do_ffa_version(struct arm_smccc_res *res,
 
 	hyp_spin_lock(&version_lock);
 	if (has_version_negotiated) {
-		res->a0 = hyp_ffa_version;
+		if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version))
+			res->a0 = FFA_RET_NOT_SUPPORTED;
+		else
+			res->a0 = hyp_ffa_version;
 		goto unlock;
 	}
 

-- 
2.49.0.1045.g170613ef41-goog



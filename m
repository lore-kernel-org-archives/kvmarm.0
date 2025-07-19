Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5F314AD2D;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752891114; cv=none; b=JeMvBRdETJWWsl9UE8jFyHUIIajcXOZ23Y80W0Z9IP/iLfvBZXZ72m6xi48eAXNdLFSQYIy7awg+bgd3pfgTLZXkuN/WJdAexs5mcuHRN1z1cukCwdY/ZLorPM22AC+I9LeikZJ+pyVpki9to0TsLzf4RTuT5kodKZwMEZhAjjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752891114; c=relaxed/simple;
	bh=coAKO9TLhK8MTIgf77yLemsOevi3hPcTUAqXS91Y2b4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gZc6rJTuZpd0w/C5nggchA7gRTxp1Hk99X4vQW+UwaMVceWDpT028sv7yBV0HtYRa7T9bjWxGYzkLgyAR7rYaPEqNmnUzzD+L4n7GaI/WUR/+O/ZHDsUIK974GUPSUSeJYqOIafOGJQYtlwtqjWeMxFocQ6sZK+xKjUkzYnM5Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNH9a9Kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNH9a9Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4129C4CEF4;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752891113;
	bh=coAKO9TLhK8MTIgf77yLemsOevi3hPcTUAqXS91Y2b4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JNH9a9KkBf83Hstnxpc0qHWAdgczsuEPME2MsMYzxFGC62UPfbtjrJ8AwBp0J8r3e
	 GWbMu03xTS/rei/BYcLozWhyXGJ8QlPGVQQ9tvyDbMKP25xcPlwV7LWZeg29GK/+Dv
	 YuiUy4nc+5s5TdiGTiqJOO9PIGgBy+vz1yKLSM20j0gY1Qqrx50RMYCU4ZMT0B1eqk
	 nZ1k8gRWikdOwLClk6spvvS9DmwINwC2fmiSh3N0NeSa44elvvwCaej2rPylktugCf
	 z0nydZRuavFm6XvQTyu/Fgcn8Rl5MuKmDVSu5ITARl1a+pduqz7IAHanY1StVfD+j/
	 yXFBMHJ12NQLw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953E3C83F34;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Sat, 19 Jul 2025 02:11:23 +0000
Subject: [PATCH v8 1/7] KVM: arm64: Correct return value on host version
 downgrade attempt
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250719-virtio-msg-ffa-v8-1-03e8e8dbe856@google.com>
References: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
In-Reply-To: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com, 
 arve@android.com, ayrton@google.com, qperret@google.com, 
 sebastianene@google.com, qwandor@google.com, 
 Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1752891112; l=1399;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=Dl9KrxrUP4K0W3dgejUfrC3aK93wdcqeauIVLeuo9f0=;
 b=lJirE4j7wkWB4ZcW5+qaK6CCOsLqrm6DoTu3uQ92cxCsDWf/6HUXasK7WYG+ZO4eEYzhDYFTo
 bHmnGo6VxdvDx0nd0Fg8/UgHKuIxWg4pBX33eAN6Bx47iuctxSU6aZ5
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

Once the hypervisor negotiates the FF-A version with the host, it should
remain locked-in. However, it is possible to load FF-A as a module first
supporting version 1.1 and then 1.0.

Without this patch, the FF-A 1.0 driver will use 1.0 data structures to
make calls which the hypervisor will incorrectly interpret as 1.1 data
structures. With this patch, negotiation will fail.

This patch does not change existing functionality in the case where a
FF-A 1.2 driver is loaded after a 1.1 driver; the 1.2 driver will need
to use 1.1 in order to proceed.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Per Larsen <perlarsen@google.com>
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
2.50.0.727.gbf7dc18ff4-goog



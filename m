Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4A62620CA;
	Thu,  8 May 2025 08:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746693572; cv=none; b=PcQPeG0TB99OFtLzyooFvqel5H5tdEVRV2HIH/4HEKVv2lRoQnMSHBUSA2c/ianexfUFOuoVP5nl0eFCg1KW80l0/j+VcEuBHhxhYWnSneqFEJNfVy7dGvnde1SCpgpROL8kYqvWJg/J/5VEePDdW0QZWTRMtM2qa1zwhoYJAvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746693572; c=relaxed/simple;
	bh=yuBweLnXJr+UlHoAeP0Vp5rW+zBWTBXlDB/S+fvgixg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FXxI7fQo27Mh4JB/mJ6fw2yO5A9TmXf//fcBVyawzHFFDPmvQfhc445mSHzsM+fXtLC5hkf5mZVkwgvbtZROyd+kInONGZmnqumHZ5V3hX9+nEW6PThuyrbSNerMIOEkM39rJGmY5fYAyT2/VtrNm0K4lEJ17mDJEplaaEKW9DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCaXU2yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCaXU2yy"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDA60C4CEEF;
	Thu,  8 May 2025 08:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746693572;
	bh=yuBweLnXJr+UlHoAeP0Vp5rW+zBWTBXlDB/S+fvgixg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RCaXU2yy1eGr0Ao8jVrCf4FS/Gj9dHBIGZOoYtF7QleJaVWX6f56MtZ37Pm4IYJI6
	 f97zAssJjYoRHFLmeIoqktFp7zrtbtgBHa1b5ADak76G58xUiK7w/Tm/6TSWHAABPe
	 w5C5NkJYTrPOFsj/gbcEYSFh94VuY8xK+PvpNNL8PyyjvyYwrzxEhgABkatyxIidBs
	 +08EvAJpyQi+JSdZJxT7uUoZKnO/+WXsqYDkjAAEPSTzEMfJTJkmJM6fwZ8prS35e1
	 3HLmpyS4PQVUT6OWHRYqsJReDWM+iue4WFnQyDevQpW2FtAmDD+ypVG5O/ySMWUkk/
	 56L+6dgyFQEfw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA856C3ABC5;
	Thu,  8 May 2025 08:39:31 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Thu, 08 May 2025 08:38:52 +0000
Subject: [PATCH v2 1/3] KVM: arm64: Restrict FF-A host version
 renegotiation
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250508-virtio-msg-ffa-v2-1-ed84f8053965@google.com>
References: <20250508-virtio-msg-ffa-v2-0-ed84f8053965@google.com>
In-Reply-To: <20250508-virtio-msg-ffa-v2-0-ed84f8053965@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, arve@android.com, lpieralisi@kernel.org, 
 qwandor@google.com, jean-philippe@linaro.org, james.morse@arm.com, 
 perl@immunant.com, tabba@google.com, kernel-team@android.com, 
 armellel@google.com, qperret@google.com, sebastianene@google.com, 
 ahomescu@google.com, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1746693571; l=1162;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=J3MWSM5x2/SDttpy5fJekCrept6pUn9foVmr8XHfbVs=;
 b=Tg7dgit3kVDTUX65R4PhEXNXxB3lmCZRYexlRi3hD5jNmaUMG4KAbKfgshhUz94xxl0AsCRLm
 EkblOHMrR3rCekrYx3uolLaOoJxg+OaWEnz+RuGNqykxMOnI9X5gOAm
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
2.49.0.987.g0cc8ee98dc-goog



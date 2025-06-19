Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B2A28368B;
	Thu, 19 Jun 2025 09:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750323808; cv=none; b=pkc/6tQGCjIHgDHSM5XhHG9un6idrFhj9J/9hr4y9OzSH4er/RUB55xxY//R2Hj2wbtDEJMdbEpmLTEAX4XMIWBjjePLC4J3EVgFKauCWSaDZ8i4I8nOQ0Ip1GQqlY8upmW1JhsO3EAGc8Mf34nWfKzMpYbucaq4+AURYmBnNEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750323808; c=relaxed/simple;
	bh=MRrvGml0U3t0XqSQRSoIEJmoyHlE+TFSPmmooSVffjM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FtdOsId3VvEpDuxN5r2oXiyChKt7Oycfp9nHwME6ARW6MO0estP7SJUYLRgaR6ogG1n3AJN8FYhRurcusl6V0OVrYd1sh6VDBsWMZNpqbU8wZ/ekoiN5AABdBTYrOQSIrPUIng6MBki7ERKIGp7G0sa53jjVU4CpgvKGi/mR0U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7vxbIJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7vxbIJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23D7DC4CEED;
	Thu, 19 Jun 2025 09:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750323808;
	bh=MRrvGml0U3t0XqSQRSoIEJmoyHlE+TFSPmmooSVffjM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=k7vxbIJ4TYkmeqHSu7NLCO5x0f9uOP5g/B+hsHPD2VicHIN4hCu+9mFIfHwwVdtD3
	 S1AzYLk55a2oTmlCBFKk7DzbsS+20zlzhduKw6mfNDHIF85E9Hu64wpQtsC5Mr1aG7
	 GzqfU9AaCsEQsaOjC9wy8sW4OXkIMH1oKXKefLuqQ8sU1OO4ljdSPHf2uLl6NP0x4H
	 9nBBh5cJaJCfHwfhwu/SWN2qbOiQ1gZokwf4S9MtrQPIyjxYsJYxoO3OmJHAZ9HMID
	 2BYqbzxOah1Ho6z6UhRTvPTxh6r93qj5Q7xEmtOiTBS0xHrFprd4n/7nF/ypxMSKZn
	 E9ZpUi7/Yh7eQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1516EC73C66;
	Thu, 19 Jun 2025 09:03:28 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Thu, 19 Jun 2025 09:02:54 +0000
Subject: [PATCH v5 1/6] KVM: arm64: Correct return value on host version
 downgrade attempt
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250619-virtio-msg-ffa-v5-1-412c98558807@google.com>
References: <20250619-virtio-msg-ffa-v5-0-412c98558807@google.com>
In-Reply-To: <20250619-virtio-msg-ffa-v5-0-412c98558807@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1750323807; l=1403;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=XSNMzgDeYfF9zx6xj7IDlykSvrb/Zm2zMMm5Su7+ZNY=;
 b=vlLo26EbZC8FlbIqebYBm1ZZsgH5/RuDe1guOfj7370nOJkDx7S6jtysbV6fKvz683m6mjMjB
 EC6NUJwWZxLDVoQlxmJK+NRSelxnFVBcoGKoIaMOO1R50OI4FW4YQ3f
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
2.50.0.rc2.701.gf1e915cc24-goog



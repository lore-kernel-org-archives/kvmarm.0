Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBAD219E8F;
	Fri, 27 Jun 2025 07:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751008381; cv=none; b=H3F+ELJ1p5L305axvcokJdsFJ0oET4Hfi0qlptdCzALoYhWRYNpG6pWHsx2Xp9NYMUykSi7SA2FZSIymkTVyJwXRGE4We/KZWYXRSCFeGPAOsktwZDpJ+hjdnXtXWuqN2xY26KtqrD32/kYnvyd+Zss9uoTUlOo3qTepiOUJ0U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751008381; c=relaxed/simple;
	bh=coAKO9TLhK8MTIgf77yLemsOevi3hPcTUAqXS91Y2b4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=etgycJVdTABlk9sGgfeZ5JE5a36d6hjxtjEnEDm7PiBLxCs8KxLbrqbWLL1e8+2pL+QA7MXJDa9ROHnnYJ+0qL13U1xC8o7TPU+5d9y03UAUE6gzw02Aj/5GsvMDaLJRoq4GGS55FMnKoiGIjeFyFckinsNf/qGGsp2jSZnzJmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMSokcvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMSokcvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1AECC4CEEF;
	Fri, 27 Jun 2025 07:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751008380;
	bh=coAKO9TLhK8MTIgf77yLemsOevi3hPcTUAqXS91Y2b4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aMSokcvQEDDbicaE47gZ49QnF0uXTYVm4CWSuRcLVeWymOEjhiZt8dPtXRKA3XcLd
	 6qGEjckOuz5daWTK32ymxgmr/eieMpkAyq/62IZTmaNuP4A2KO6f3aTQiD6OJD9S5a
	 Mz+GrM1E0dn4uo1uQ0rWOcs7zx+k1+VZsmZU2ZAQAh/9Tmp7xiHHBunARnSMrN7vHy
	 RFwpb8+e5O+da88tdYT+5vGyyN6a3p8eulbgwCCbOGdrggkC5BTMPwmJMw2qX3Y5IH
	 ExhSlLEPDGTzEz+iNktuyIOnTTYYAoDhCbFIrTLAlSt7u7XGrJ3pMfnJMAoOe2aIkD
	 3ap9+L8S/uR3w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04B0C7EE2A;
	Fri, 27 Jun 2025 07:13:00 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Fri, 27 Jun 2025 07:12:25 +0000
Subject: [PATCH v6 1/5] KVM: arm64: Correct return value on host version
 downgrade attempt
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250627-virtio-msg-ffa-v6-1-8c02fd94edac@google.com>
References: <20250627-virtio-msg-ffa-v6-0-8c02fd94edac@google.com>
In-Reply-To: <20250627-virtio-msg-ffa-v6-0-8c02fd94edac@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1751008380; l=1399;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=Dl9KrxrUP4K0W3dgejUfrC3aK93wdcqeauIVLeuo9f0=;
 b=CJMbpH5xzZ8rgxvBzjxjYPckK18PzpFrnU6uC2FRNTu3OnErumBY2HVduPw9JDT/ouvd34G6C
 XcqlEB0JOb6CLjObh8ahU9dR6Q7P3NUIGLg+6Ox6xuSNDRMcR5b+riE
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



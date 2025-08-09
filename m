Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F29221540;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754706813; cv=none; b=TPUMOipnJyt4lcVgJQmfBQtk3iI8U+vjTu8Y877Zrv3RvpuuUd5u9/jMbdPAGNypzdGkC6rS6SuOSDhSHHMfHoYcIqWsDvPZYCNsuadfnjNw1+VjMx9KgJ3IdXKVdNzRHiTvsjdb2mn3Gp/rmTOpRYUX+TWXmrXqJrDFp+4/4YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754706813; c=relaxed/simple;
	bh=pRk884j85qJWpr4NoEoXY7hoJkcqya53bDXrYKd9cyM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Pt5iJXzymcJYvXsWWIaFxw0cu0SVwiNufcXEO5qol2BjTr2IDtwhXY7FppVZeAjjsAJragDdME3917nvvXcxAxIIX1PLA7vMCwzIWCFVmi7ws6DzliIJXJBeucGYwVY2zm9FMI/dzrniAwk0zGm8drPg65JcBUHfLmUJC/3CFI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbfX+ook; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbfX+ook"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A72B7C4CEF0;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754706812;
	bh=pRk884j85qJWpr4NoEoXY7hoJkcqya53bDXrYKd9cyM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XbfX+ookelT/tiAyKPrYhYXqvvcwNomvdl+V48PJzDTMIC/tuNwHUnQP0PvtlsMKU
	 t82SGlIzPnOfkP96lrJC22kl7WsJvCfwjZp3KbvtIw6sVQiOOhe1tYSVzRdZIfVaTq
	 jKP9NaJMh1jYMmgx6cLo0TiO1PUtLiuB4OoB6N/01IErc28TzFvuHOuNOiyPlhMu6N
	 wYfAFShHJNGRrESCMcdYhsHPuCoTvK+Pam8qAIV8rDoE1svGsXRpeJCOnGvf5Ule8B
	 1SxX0CjB98ZHJWvOPRKZCqlE3k0rpHCSHDjXnMkTld6SCEvD0PAe+EXQl8llk+59eY
	 xQAT/BWwpvRGA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96288C87FCB;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Sat, 09 Aug 2025 02:33:19 +0000
Subject: [PATCH v10 1/6] KVM: arm64: Correct return value on host version
 downgrade attempt
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250809-virtio-msg-ffa-v10-1-189eeecf8ae8@google.com>
References: <20250809-virtio-msg-ffa-v10-0-189eeecf8ae8@google.com>
In-Reply-To: <20250809-virtio-msg-ffa-v10-0-189eeecf8ae8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754706811; l=1403;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=SDN/JS4I99RvtlCDGwQieznfcPU/u6Bd9Lqo8Ex2NAE=;
 b=r+y4LZc+m2nbhEElxy8SmbhvCeyuJHh25wVxvL7eggpV6FhWwSwUXNJ9lrUwa47f7xeCZJRlQ
 8f/ItXFciHrB/gVBD/NOhugGxq9+tdHsQNjI/3yyvkeOHw56TmpBic3
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
2.51.0.rc0.155.g4a0f42376b-goog



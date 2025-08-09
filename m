Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4863B2777FC;
	Sat,  9 Aug 2025 02:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754706813; cv=none; b=ZoSyWvmC0nUq07CMjNsuzqfOyvxGjjsu5cdzW15iGi4BWZFGJA+HOjW7CLYlA82iSihRCERUHrIY/q1X5fn2/e97kxR8WNeIbAd1F30RnL2lMzBWW5NxvUySV6KB36BCEzv5Tl08laPzJiKHiJw+KOaXHfZMRqzaGoqUEV8LSV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754706813; c=relaxed/simple;
	bh=xEPeB7qGHmvf4hEcftZI6cvTrD1NkDZPhJX4AIec5Dw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kup9cK26L9cf8V/vWdSXXJxh8dKCXrSAUDtQjHt8hFcLnaVN9/j7aq7/gNGmhuPnyMBttKyrPd/FysKWPjDsRAio/S2+6mI9fdo9YfPQtEsSerNTtU4yJiMPKnhXeQGV5146hRiMWXdlhaD4S6pB9aNCIs3MT1jgE8oQLydRXWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfHM7hMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfHM7hMK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6489C4CEFD;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754706812;
	bh=xEPeB7qGHmvf4hEcftZI6cvTrD1NkDZPhJX4AIec5Dw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JfHM7hMK/RKWRPe77LaFJKtG/14M3y64v2tPZ42aQzlFlGwfmUBYjAt/RZElLK2Zz
	 nkjq0+nzzgaR7/zy7DFh3UkvUZI7UQUbFWJu5wJkxazOMbKzdB2q9iMLCNYMLExT04
	 asCla5oahuvwmdmCvnx5kR4okiSO6+87yloFUV/j2JpXoyAfy64iZhlPqu1520FVMR
	 E5R04UUuRdwivseHGE5FB45F2dFnd8HGuMutdk2rRFYlf+L6mK9Jjd7M3bR3INQM0g
	 N0qlo1xS5MGaFO0VPFgF8xL/qKT+GclYAUCT1dnaU5FHF9nw8czuHZhHJ99csN8WQo
	 nhdd9I3pN5sBg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED41CA0EC1;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Sat, 09 Aug 2025 02:33:23 +0000
Subject: [PATCH v10 5/6] KVM: arm64: Mask response to FFA_FEATURE call
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250809-virtio-msg-ffa-v10-5-189eeecf8ae8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754706812; l=1408;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=vELjMz0VHanHZyjHFhzZd2mcce5Zj2vh8Eki9ACAFco=;
 b=mPzO7QiZt52ZoyBspo220r8uI7g93su2IY0VqQ1vwlV6eBXS5EoAGWS/yBhDGPew+3efqKmF/
 cZ6DUoIkz0+B3ccpjrK3n17FGPHKmVvYFADfXzhBjzvXPWAU23eT4Az
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

The minimum size and alignment boundary for FFA_RXTX_MAP is returned in
bit[1:0]. Mask off any other bits in w2 when reading the minimum buffer
size in hyp_ffa_post_init.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 2 +-
 include/linux/arm_ffa.h       | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index bcb2fab66a61190733682c5bda44e2fa6766177a..22a369f8d1d8edcde45d77377e29dc08256c0bcc 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -734,7 +734,7 @@ static int hyp_ffa_post_init(void)
 	if (res.a0 != FFA_SUCCESS)
 		return -EOPNOTSUPP;
 
-	switch (res.a2) {
+	switch (res.a2 & FFA_FEAT_RXTX_MIN_SZ_MASK) {
 	case FFA_FEAT_RXTX_MIN_SZ_4K:
 		min_rxtx_sz = SZ_4K;
 		break;
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index e1634897e159cdc208931938649eb0fb04d5a070..cd7ee4df9045dceca1c4e0dca2d533b770b1b056 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -128,6 +128,7 @@
 #define FFA_FEAT_RXTX_MIN_SZ_4K		0
 #define FFA_FEAT_RXTX_MIN_SZ_64K	1
 #define FFA_FEAT_RXTX_MIN_SZ_16K	2
+#define FFA_FEAT_RXTX_MIN_SZ_MASK	GENMASK(1, 0)
 
 /* FFA Bus/Device/Driver related */
 struct ffa_device {

-- 
2.51.0.rc0.155.g4a0f42376b-goog



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC7A407576;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539338; cv=none; b=jCIGda+fJcerDkTj9dcdCRMChzvFnTXGX4LIOZcoFuWPusPCBnzz96WC9XZAsK0po/BiH/T99441WJ4mJDhdpIlNrVNXFqilw63iHay5VJycp1jpn1u2mOEDfkThKc5DvVHGmnRg64yTQxIE8o6ixGvn6VWMD6s8HrIRHS3J/PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539338; c=relaxed/simple;
	bh=cnv6DmntcMXagmxMgyBXvT6QXRuTNqmKUclId5YjCv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5UGBvrm9EPfv2UbqoPEqoyM9Bf4xHxXKGnxmArr/JW4CIHDnIxLyuxW9e2KfbgPFmo7793FJm6/QtfIXAZE612NNT0+U+SvVoPsl5/zXOL6FbkTl3o1pRwbkA03RBfPwO1n7Ozsc7Q2y2Ul0A26cH4zbssxYBf/oE8W3tnmclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A2MMWq4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A2MMWq4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D153FC19424;
	Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539337;
	bh=cnv6DmntcMXagmxMgyBXvT6QXRuTNqmKUclId5YjCv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2MMWq4VrW2KplKrXpd2DAHmL5+mAbUgm5NsC2O8y4tHml8H15wMjWwKQY2dNIdd8
	 AMSNsGWyZr3t0Rhx50arn9aBG7MA5R2Z71WMH8erNdQQ+oldOjpefZJuZda8swrB1p
	 3sVYzBb6XUPDwF3qEZRY9suh6XweNPlbNfMspZBsIj6lUjJE22YU9BPLPljBdeSsN1
	 /LTu2a8T3gNQgM7Hgp135O5KT9ETMoqgZ7zqFRn88J65dztLnrkCTJ4PizO9gecgHd
	 wHAW6yWvxf8YXBMPGU/jY1S1z0WZoKDGwBSsPfpWms5cwuRgywnCcQGu22yZjszsTY
	 yhdqKoh70x4Ig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkB-000000060II-3zaq;
	Thu, 26 Mar 2026 15:35:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 08/15] KVM: arm64: vgic-v5: Cast vgic_apr to u32 to avoid undefined behaviours
Date: Thu, 26 Mar 2026 15:35:23 +0000
Message-ID: <20260326153530.3981879-9-maz@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Passing a u64 to __builtin_ctz() is odd, and requires some digging to
figure out why this construct is indeed safe as long as the HW is
correct.

But it is much easier to make it clear to the compiler by casting
the u64 into an intermediate u32, and be done with the UD.

Fixes: 933e5288fa971 ("KVM: arm64: gic-v5: Check for pending PPIs")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 422741c86c6a8..0f269321ece4b 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -212,7 +212,7 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
-	u32 highest_ap, priority_mask;
+	u32 highest_ap, priority_mask, apr;
 
 	/*
 	 * If the guest's CPU has not opted to receive interrupts, then the
@@ -227,7 +227,8 @@ static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
 	 * priority. Explicitly use the 32-bit version here as we have 32
 	 * priorities. 32 then means that there are no active priorities.
 	 */
-	highest_ap = cpu_if->vgic_apr ? __builtin_ctz(cpu_if->vgic_apr) : 32;
+	apr = cpu_if->vgic_apr;
+	highest_ap = apr ? __builtin_ctz(apr) : 32;
 
 	/*
 	 * An interrupt is of sufficient priority if it is equal to or
-- 
2.47.3


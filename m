Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30A33F23A6;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039793; cv=none; b=XhHd7hMPwIhhU3mKkHc0SjVQHcRv+8CE8I+jRXNyntknRZRbvaJ2UejsxJ8tc1wEKsdGa1eulcIGYcCsChYsl8+Z3k+rwwGmyqOlLJHPIPawnJ95D9Hpsy6EuN4p6PTyKfRtei6loQYRb9y36mJVO0SMKikRF1+aOe7n+gQUiws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039793; c=relaxed/simple;
	bh=3N8Es+J9SHXb1LH4kFixxcN/1+h78f4vRX6JJRGxg6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4YPPYWvS9uKB/lKRojTaauteD1pM3tsdqzwwWgj3H9ociJ5onX7yVPvIjU5jkEhUzdwd8gCd+ivzDuXx97zE+aTC5vAysLGjL0rhIyqUNXJfXNGebBuVDTJr25ffc9Sk2B4bpei2OCZebojH+RG2x5eMTtoeuCc+ZSXrkT98nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hx+B6sD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hx+B6sD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6758C2BCB5;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039792;
	bh=3N8Es+J9SHXb1LH4kFixxcN/1+h78f4vRX6JJRGxg6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hx+B6sD+msfwXlp8i73Z7Ny5eibir9ie5wxDidGL6n5CjpeLoQrxM/TL0H8oOcWY8
	 I6YQXhbelfO8sdjAPunu5ElLlz5jRb6q6mwA9yteqRqfXXUCVx9o6aJ+OIRC0kRkXA
	 OV8+mTn8I0y7agJ3YW/r1x+QIGj3XnHuzl5QhMYtbvr3uH+nnYBZndkuAb4c97Z39F
	 fhZy9zX62pkNOunqkI7WC8cjjHtdHXoEO7itYUfPA1fpJ2fe8TP+Eu0JuxLF0PujkV
	 QtHvMAIeArpN2XrnDey8I2Dt1IN0oarkB8ZZkA12RJZ9OJqFHYUbWiWYvdrEvHBqHP
	 ELmLhKmZ1uExw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw2-00000007oRQ-4169;
	Wed, 01 Apr 2026 10:36:31 +0000
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
Subject: [PATCH v2 08/16] KVM: arm64: vgic-v5: Cast vgic_apr to u32 to avoid undefined behaviours
Date: Wed,  1 Apr 2026 11:36:03 +0100
Message-ID: <20260401103611.357092-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
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

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
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


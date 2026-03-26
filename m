Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88624070F2;
	Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539337; cv=none; b=jWpYbmlcbooqdWzZalBdwBnUcWPwO9mwReNinGKz3W1jcSpRp3YBRMX+iMzu03c40wCl1erL14dEToIRE0yZemLRgc/zd/9tN3hGoqle2YDNsUb5wtE4b5HeLdtmwt/0HQCKfdAsTLp4fgnwZ0iETCLIl5L3+xlGco5iju8/EOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539337; c=relaxed/simple;
	bh=CrWdCZA8JdxCY9eF4XTewZwde0WwVr8is3+3aUovL/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO5g4EVZOT3wWIVR1pD2WZ4dm+vlMmXApUIJAFNGY+MTThBo+xp/TZ8lPyMatKOipkvi20rNjz7wZ1Zy02d+C5jpO5fA9OZBGLcFa/vljXCr55pR3TE7o0VcYAaIbnd5Owgl63uk/uGjMu8cWT/udvfRvITv9dZu3RN6MumcjvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3WpifxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3WpifxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872E7C2BCB6;
	Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539337;
	bh=CrWdCZA8JdxCY9eF4XTewZwde0WwVr8is3+3aUovL/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3WpifxGUJ0U+zRraD1mwOcqxlKJxl0XsxXA0UB8dEis2gVni1mDng1sNGNmuypj/
	 sy+90bvZBbuG09nz2KtR75yJsG82uAdDMHCcnHCLExLu4DKK4MYYdvMJCY+d2gKROJ
	 EprjcfFZlfSaTeGbJklAZRrmzkl/FMdj276pBhftxi+3DwKZDmz1+z6OuWhVkScmJj
	 kXMUo9F/jG3GYEpj9daSZZ6yV/vllCWqNgGTpsNovCL3eHp8EHxK5GQhEw1q3beWXd
	 Xy4TikF0MPv+Kds6ps4bNmgdZbCtIoEzCWjiCrJFPG2VGFm1Lz/JMOgs0jPdTXFWue
	 D6kewkfi+c7+w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkB-000000060II-37mF;
	Thu, 26 Mar 2026 15:35:35 +0000
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
Subject: [PATCH 07/15] KVM: arm64: vgic-v5: Transfer edge pending state to ICH_PPI_PENDRx_EL2
Date: Thu, 26 Mar 2026 15:35:22 +0000
Message-ID: <20260326153530.3981879-8-maz@kernel.org>
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

While it is perfectly correct to leave the pending state of a level
interrupt as is when queuing it (it is, after all, only driven by
the line), edge pending state must be transfered, as nothing will
lower it.

Fixes: 4d591252bacb2 ("KVM: arm64: gic-v5: Implement PPI interrupt injection")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 119d7d01d0e77..422741c86c6a8 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -445,8 +445,11 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 
 		irq = vgic_get_vcpu_irq(vcpu, intid);
 
-		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
 			__assign_bit(i, pendr, irq_is_pending(irq));
+			if (irq->config == VGIC_CONFIG_EDGE)
+				irq->pending_latch = false;
+		}
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
-- 
2.47.3


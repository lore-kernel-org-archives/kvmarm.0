Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79961FA5
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 16:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D938C433AC;
	Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680969891;
	bh=34/Zlt4htBGJgLYgA2mf1PBt32s5lUf3YI5evv+PwzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jV+8Kwh1lmVgBvYGcG+iC3fyA5kwntvZUgWIUpSeVIpcdceElV3iV+G9LYPudTIRy
	 +pn5TobDu3KgReOMqXKiQDtiXrwrrd8dmySbRIn0nISnHCfGol9ZKg4wWN6dLPFgej
	 VJydRLx166oCho6nN2S4d252TcUO9v+v6BE6Ax2t9fnt8yYgDYJCgxcLaynT7x5cwu
	 qo6nM5tRALtzxPYYKI4AzH0V7C5QpD1lmRlxcmPkIEo2H4I0G8OLuUpGHlGY1wzLRs
	 JaO7AKKGjvRr7I7MEBIrt1T5yftAoQL47I2Vd+6ssVptEYHn4BOrGeqRWCuHCMQ7KI
	 LQ9JyBNFr1a0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1plB3Z-006wc5-LH;
	Sat, 08 Apr 2023 17:04:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 5/5] KVM: arm64: vhe: Drop extra isb() on guest exit
Date: Sat,  8 Apr 2023 17:04:27 +0100
Message-Id: <20230408160427.10672-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408160427.10672-1-maz@kernel.org>
References: <20230408160427.10672-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

__kvm_vcpu_run_vhe() end on VHE with an isb(). However, this
function is only reachable via kvm_call_hyp_ret(), which already
contains an isb() in order to mimick the behaviour of nVHE and
provide a context synchronisation event.

We thus have two isb()s back to back, which is one too many.
Drop the first one and solely rely on the one in the helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index cd3f3117bf16..3d868e84c7a0 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -227,11 +227,10 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/*
 	 * When we exit from the guest we change a number of CPU configuration
-	 * parameters, such as traps.  Make sure these changes take effect
-	 * before running the host or additional guests.
+	 * parameters, such as traps.  We rely on the isb() in kvm_call_hyp*()
+	 * to make sure these changes take effect before running the host or
+	 * additional guests.
 	 */
-	isb();
-
 	return ret;
 }
 
-- 
2.34.1


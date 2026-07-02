Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A67317173;
	Thu,  2 Jul 2026 16:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008186; cv=none; b=JXI+E4iPxkpy3ZseHQl+pGt0XW+3Z1NEvStmuAGKKMEt/nUpd3hmxq5kc5zruvKbG/Um2BuOkVFbzhX+ZD8uvlPi1sGRRDSSBNIwilM5ulmJOvrDqqbooMTzCgrHK1nd72GLMboMSJkPy7SEzaKEbYWxmqRrZYeU3xpcwwZiwd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008186; c=relaxed/simple;
	bh=093tE2pqbC6tbKCHzb34wdL9+A7LSXkXwL1wGFmyY0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWcNPEQev27hqirkkHZCj8G5LKwEVpPGiYtnLbfI2sQfmIeQh6nZcvyruI233U4Iz87sjnnwRly4qrMIyOYglN9csz5F7hyW69Y5hWUS6NcQay8aL1381rlSA6XMDjb4yIwvUA3AQDX0ttT01ks2JhV0CWHaoTBuk3TVop01N0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R9yFgPqo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9yFgPqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25021F01568;
	Thu,  2 Jul 2026 16:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008184;
	bh=/1UdJ97Bp7EXqhL2TR07gM6gIfScCTqCxI6c0EYEFwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9yFgPqodk5pFnoAa8zckKG5N4UUu43NKBq397/iMbegaOgTq5BqV81zDx0d2vGlD
	 QT87B7VIzQUrFmwqrh/i83/dVidA3wTc01Ug7tfx09Bol2slx/1VWyWPrY4ufHdzPv
	 B2oWGEcAdtw+fBKi26V+XyBbdycXdRSL6JtsnKoO8XjNdaaWb7zDf3KtclSLmNXofi
	 A8ohcF3jVIyQmtEiYh7XTGG0sS7i89EbMmXLrvyDR6igUZMJprRFC/P3HO+Jj5mkbk
	 Vs8CUwZ78u5MRibCFswne5S7XAIABigu7YGOEQCT0es+X9hkbXFo2VZ92hWwoWNqrX
	 eZszobUdyh6cQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsV-00000000ojd-0sJp;
	Thu, 02 Jul 2026 16:03:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 25/28] KVM: arm64: Engage NV3 TLBI trap elision
Date: Thu,  2 Jul 2026 17:02:45 +0100
Message-ID: <20260702160248.1377250-26-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Similarly to the ERET elision mechanism, FEAT_NV3 can elide TLBIs
that only affects the guest's S1 translation. Enable this, with the
express condition that the guest isn't NV2 aware, as we otherwise
need to trap these TLBIs to deal with VNCR mappings.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b32870a5e1236..d6f432b1558f5 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -715,6 +715,15 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 		if (cpus_have_final_cap(ARM64_HAS_NV3) &&
 		    vcpu_has_nv(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_NVTGE;
+
+			/*
+			 * If the guest is NV2-capable, then we need to see
+			 * all the TLBIs, as configured in HCR_EL2.
+			 * Otherwise, relax the TLBI traps to only TGE=0.
+			 */
+			if (!kvm_has_nv2(vcpu->kvm))
+				vcpu->arch.hcrx_el2 |= (HCRX_EL2_NVnTTLB  |
+							HCRX_EL2_NVnTTLBIS);
 		}
 	}
 }
-- 
2.47.3


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB087E
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 09:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2802C433C1;
	Thu, 20 Oct 2022 09:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666257406;
	bh=3tbOfP787ivANekjOpi0D+lzmeYXSesKC2n+sLbSetQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmp9gTo1hdSKd8xa/Cb4CnZj4NfRTUvH93BSsSvZM+UeGmtVcuCX7T2lRtTTWwMMX
	 O9OuS9WUHXGOv7LgGvPwf9F59FHLbsCGWM++xfNo00bS/JkWxp/jdpItRAt6TaTq06
	 JNb0vvi6whYfO0vHJ20B8CAiwuZFy9t+3gf8OuCmlo4MqyuV8+8xwGT9tjvifIVmBp
	 bRfyZeLObwa69MxkxXYb3MOBXBBjvq4M/u6+J7RtNQNSzP67KOV1ACD+Dxa/7my430
	 aA8dlX6id4K0aeTON7QOQlhdQ3DmL8gHxbWcuSgbcyEvQBOX8VPpb42yhtORk1LJXt
	 Pq/xvllZwECkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1olRWb-000Buf-3W;
	Thu, 20 Oct 2022 10:07:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 10/17] KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
Date: Thu, 20 Oct 2022 10:07:20 +0100
Message-ID: <20221020090727.3669908-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221020090720.MSsqd0R1RhJXYgc7X0wj0uHvJ-Wt_12S3_1j4BcLKB8@z>

Obviously, in order to be able to use VHE whilst at EL2, we need
to set HCR_EL2.E2H. Do so when ARM64_KVM_HVHE is set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..85df7ce0b051 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1558,6 +1558,8 @@ static void cpu_prepare_hyp_mode(int cpu)
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
 	else
 		params->hcr_el2 = HCR_HOST_NVHE_FLAGS;
+	if (cpus_have_final_cap(ARM64_KVM_HVHE))
+		params->hcr_el2 |= HCR_E2H;
 	params->vttbr = params->vtcr = 0;
 
 	/*
-- 
2.34.1


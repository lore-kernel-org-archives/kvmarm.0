Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF6E1EA6F
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 14:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EFBC433D2;
	Fri, 26 May 2023 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685112409;
	bh=gX1HEG+z9KW3eMtUvCzJlWpVp+Aform3r5YduMPqVos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofsW8JVOTHJSD7OCUF4Swuj9FRlkinEIJ+gqQ5CWgJAG4CwBVcnnEp6B4AQfsqYEu
	 YEVC+18Zr//6R8aaMN/NsojaGFz650zEI0Wn+pFJ1O/2wjG3tXqhlK4vI0ok0IMiev
	 GdvnV93rRCmwRZB9eXdWcd+9xtiY5Hg2wsgeXLS9/Wg7rt47eEL0Y6ZCCRcVTDvJCN
	 xBY/PKtgPSLKF9GRLnIVFyNXjhdQhcAD4MutgwNtF697DV1fpLxWz51zQFsKClapZ2
	 ZM6wcIhfChWJI3y+PDYhgUU1MHTTSsX0DfvOt4k6t5rQOJ9ShGkwhj411PY3vsQnrQ
	 FQx/JkXp+9ffw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q2YVt-000aHS-QU;
	Fri, 26 May 2023 15:33:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 10/17] KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
Date: Fri, 26 May 2023 15:33:41 +0100
Message-Id: <20230526143348.4072074-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526143348.4072074-1-maz@kernel.org>
References: <20230526143348.4072074-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Obviously, in order to be able to use VHE whilst at EL2, we need
to set HCR_EL2.E2H. Do so when ARM64_KVM_HVHE is set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..c12276dd2cf4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1676,6 +1676,8 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
 	else
 		params->hcr_el2 = HCR_HOST_NVHE_FLAGS;
+	if (cpus_have_final_cap(ARM64_KVM_HVHE))
+		params->hcr_el2 |= HCR_E2H;
 	params->vttbr = params->vtcr = 0;
 
 	/*
-- 
2.34.1


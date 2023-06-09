Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF6F17AC2
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 16:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A85C4339B;
	Fri,  9 Jun 2023 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686329212;
	bh=gX1HEG+z9KW3eMtUvCzJlWpVp+Aform3r5YduMPqVos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEiM5R/4aevEb4J/vFXcGdksREbX92Xqz/xlS/hTiGXfLIw2n3IupNYnRrKDdYXoi
	 Bxmmbzsups8snvNWlGJcu8T8M3aEthhyNW5Hiid8MCZzpUe/9sEVGzml68N40H9rxk
	 CvaW9JoTjinLFlSfrr2VuISzdea5FShkABCHhIXo95Vi5D80XTXpatf4OxpSBxwpQ9
	 I+13GDZlws4N0j0NM24Ig0DlwlXoHaJhAyUiTLRgC1tWL2D8um/PjATWZASRVzgYla
	 ChmzI+bh55vTC2KRFuiIQqeRnq+cp4P+KQAglmEiV5gZAv++KEB65l6PYb4+lZ9SQw
	 zpJ0QM+sx0neQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q7esM-0048L7-GV;
	Fri, 09 Jun 2023 17:22:10 +0100
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
Subject: [PATCH v3 10/17] KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
Date: Fri,  9 Jun 2023 17:21:53 +0100
Message-Id: <20230609162200.2024064-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9207C1A629
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 19:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42773C43470;
	Thu, 10 Nov 2022 19:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668107073;
	bh=uMN1ArbeWfWv/O62zqeOvGb2y8HJShuBsCnPS3/+2oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGSF2KOfbI+NWNMYpuXJdMn6sjtgosjF+/5m9yJhsUPw/ZH3VFTzaNbPtP7Sl5Wa1
	 SZl7d/7QEFymJH3kpjrlXSa6DUCmYB+6RRNioh3gU42wCWnDRNr8LfM/vUodD8ZFyi
	 gtSDPJaEZTmUG95nz6yT6j/Rg/tzVcIavidHRaKAGyWwd8qo6TkI0O3AZTq3p/iU+z
	 PCLUQ2RRuJ8NteBq5+XVe12xmbxTZXTlj576Cf8jwwpSaLA9HC5eeVlmckiBccvSiF
	 QqtR3Lt6SA6xyPdhpWBbIJKfgpkY3C0knsrGdy0EjweMYS1QAXoNmPmbn/tkTtCn3o
	 0uE9uWeQF5ZFg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kernel-team@android.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 23/26] KVM: arm64: Explicitly map 'kvm_vgic_global_state' at EL2
Date: Thu, 10 Nov 2022 19:02:56 +0000
Message-Id: <20221110190259.26861-24-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221110190259.26861-1-will@kernel.org>
References: <20221110190259.26861-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Quentin Perret <qperret@google.com>

The pkvm hypervisor at EL2 may need to read the 'kvm_vgic_global_state'
variable from the host, for example when saving and restoring the state
of the virtual GIC.

Explicitly map 'kvm_vgic_global_state' in the stage-1 page-table of the
pKVM hypervisor rather than relying on mapping all of the host '.rodata'
section.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 0f69c1393416..5a371ab236db 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -161,6 +161,11 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
+	ret = pkvm_create_mappings(&kvm_vgic_global_state,
+				   &kvm_vgic_global_state + 1, prot);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.38.1.431.g37b22c650d-goog


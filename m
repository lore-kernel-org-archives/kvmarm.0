Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB69D1537CE;
	Fri,  2 Aug 2024 15:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722613345; cv=none; b=X5fdF54MPfSJ9OJxdW7mRRIR6G1ubx6pWoZy7qx0NwcRmLNOstId6egO8i9zU41JDeMtRYZVI7ag9iCN3swgC8ckfTlQRlpLKtMG7V21MJRQ4WI6qSDjDngJEuoWBk0IwF13aQYN7thyVi3tJeG1rCKQzcEOEKV6uhQDti22Mks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722613345; c=relaxed/simple;
	bh=8qgLCzLY9Ucp9hk+V/+vkRMc+zhUAi0FQD5ni0RyeeU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KBy1eOEX4WrzvGbVuXt4b6LO+dnnFM2eFicGSh6DqHmVhExhqXXrkIImeHFChFZy7jEdPCyL8Xxl+Ftg1P2PMvbsjA7plkyAzgryFjWTKSslG8k3PYgaj3kY+ZDcdtXGljqp2rha5Y4OTfeoah/lhr45i+++7oUxokBLjO+3/GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfwQYSJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfwQYSJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65057C4AF0B;
	Fri,  2 Aug 2024 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722613345;
	bh=8qgLCzLY9Ucp9hk+V/+vkRMc+zhUAi0FQD5ni0RyeeU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PfwQYSJmYqbMUfZnCrN/1QlRzykzZxgqQSgVAxDGrWFWvd3mFMRmOfZQsCwnfI6Ce
	 4QtMKdOzB38LugkZd+zhkXHZH5DBTZSgXQEz50WgK1RF+Er4Y1lMjus7dGFHXoUqHK
	 73MkVZFgiOpPDMv6eb3jqzro6fSisCMHoe36P4nHfUE4VislIHgsa2Bgzh/T+lX/rD
	 xnLUudRoqlyTs8kpZbBDn/A5fCxGt8iC+x75qPLWqRlXxSXSQ7pAtaAtbTpZbPUgL5
	 LsB0H62UJcC1tEPgdb/C7Bg+5usCcOUju2lp+hZ0qHv3AbNrr49mMWKEOrxoj45Vlq
	 rfdKt8+jYQEFg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 02 Aug 2024 16:37:34 +0100
Subject: [PATCH v2 2/2] KVM: arm64: Clarify meaning of _MASK and _nMASK for
 FGT registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240802-kvm-arm64-fgt-doc-v2-2-b90183df14f6@kernel.org>
References: <20240802-kvm-arm64-fgt-doc-v2-0-b90183df14f6@kernel.org>
In-Reply-To: <20240802-kvm-arm64-fgt-doc-v2-0-b90183df14f6@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=810; i=broonie@kernel.org;
 h=from:subject:message-id; bh=8qgLCzLY9Ucp9hk+V/+vkRMc+zhUAi0FQD5ni0RyeeU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmrP5YO7RJykSH22sWZkJURoH9pVKOPhgIM1gdPhS/
 +N8sOICJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqz+WAAKCRAk1otyXVSH0GgqB/
 0WDRaulOrP3uRjVxV7cEXnjUjPTgiWZAwAaW9ZgP4a04ixdalxkqVoL/02G/SYmvETK6Og5rZ+8EX+
 fmAFAWoBk5mDOIVqWyJeS1PXOaP7AQTNqOjmSxQJymdF2Xmf9HUGGH4EGmmTkKsmJcR7aVL9kmG1UZ
 2dH2Zm2AoCbTEiC/AsCJtwVeXxLYjq1YVlMLIduAjcn/fpjcTS6TQhXfVMfli2HLksIP2SZaJwqdjH
 EWaa3X+N9rj1W6ntw+S9O1PLv4RWaDPFPSs7IeEYzVoeC51zNvUJ80+j/YEwsYtXBNFdQEhIRHjbCI
 jfenPFAsqTXy8TfFtwsGVBK8/bNDPB
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Since the use of _MASK to mean bits where setting the bit causes traps to
be generated is a little unusual add a clarifying comment.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d347483395b4..c2f387905d9c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -343,6 +343,10 @@
  * FGT register definitions
  *
  * RES0 and polarity masks for the FGT registers.
+ *
+ * _RES0:  Bits which are RES0
+ * _MASK:  Bits with positive polarity
+ * _nMASK: Bits with negative polarity
  */
 #define __HFGRTR_EL2_RES0	HFGxTR_EL2_RES0
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)

-- 
2.39.2


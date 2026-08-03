Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6A937EFFC;
	Mon,  3 Aug 2026 23:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798863; cv=none; b=cEm2Vli7TqgUBb/LFLJ3EW73wDKlZnAtNqsP2f2I3b66D5jWR0e7fHw88TpaSkCXY3IidGhs+j04W8jTOkDLqqFu+HpGoNxd8BXvv289rpUYuS/5zJQIOqaVJgEOi8s55xVlDkonM7JjFHYwBlr5WoyO969sHwupYZuNxlx3btA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798863; c=relaxed/simple;
	bh=d3SxEv6RjSY+xiyxMK7Zi+tIruIS+RbgPdYjX8k0TSU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SqCDycNYhRcqPIsH2zoqopdk/37RBRr64yG2/rOQUV7PQJ3gCQ5cmrbieGvDD90F4kI1rXsrs4rkWjTsPMwdl9d2pW7G+Vgv8nWh4mUxf1VMee+ae033ogQ4OXggAPeuzx00zVmHyWi+/kzxBAjrT+88WX2XiRMe36KYqzzIz6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFhSsUr8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFhSsUr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACE21F00A3A;
	Mon,  3 Aug 2026 23:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798860;
	bh=kyh12vLSEfb1JF7lQC/qy5BquW9r8pj96hLZDvx4BW8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mFhSsUr8XlwEYsJpwDLjXxdlpfACVEFSE9LM6DchD+9Bf1HfQ8yALbiHbSNXR1Azj
	 Vrds2UbIhR4+2ipPcCKjRxrra0nrz8I2xnDNAfKPUYXsKWwN3vyRQcmvm0oBUM81VE
	 D8DQMlUPYsaqanehp72HkxVGy5Kw5eXrfjEHBS+H3k7bn6ghJot2NdRk3Tr5B0FJtd
	 CnxIXW6UTgnv7ITbazY02q/AKu1bzaWaAIoRqqnKeReZcEESOtjLusNsJEzfYeIZdm
	 jlER8ep0qMU0tN6qCm+9iPzmad/Rm27+7ZYgDtcb4gTZWqY0KJhdUAVmvDqW7AeeYg
	 omZoktc6d4fUA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:56 +0100
Subject: [PATCH v18 11/14] KVM: selftests: arm64: Add GCS to set_id_regs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-11-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=987; i=broonie@kernel.org;
 h=from:subject:message-id; bh=d3SxEv6RjSY+xiyxMK7Zi+tIruIS+RbgPdYjX8k0TSU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCi4NyQnb7b/tt4qcu29pwgrmnYuE5kleL9V
 znPjXt5eEyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgogAKCRAk1otyXVSH
 0BxtB/4/6luayAMUFSCj1h8ayU90trD1gtsnwpc9Jg90GfpoYAJ02Nf7Oi+80Hugc3S5Jc3i42C
 wlPWlsr3pUTBTT7kkWDIEnHcOgnZyZ+Cgxys5aLGFGJNHZCHxUYgRW76VqLyFLFoNgnGohPGNot
 3Vqd8G3ZWFJoRkarpxGARudaHJZMbcQKou6piUDYiywtkei8B3JRdH/RZoL37X1ELGD/xIeEUIK
 Tg857HkXAYHcRqfeuLep7DgVQZEEsA2oAfZHE5sHlHHGhR+/qUz+Ml4MS1umdwpMssghV+LOouN
 MjuBwro40e1IaakiwOPrTec2uQhZeEG+UBSom6/66jjNjFd/
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Now that GCS is configurable via the ID registers update set_id_regs to
cover ID_AA64PFR1_EL1.GCS.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 7429a1055df5..34e59fbbbe89 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -154,6 +154,7 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 
 static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, DF2, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, GCS, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, CSV2_frac, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SSBS, ID_AA64PFR1_EL1_SSBS_NI),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, BT, 0),

-- 
2.47.3


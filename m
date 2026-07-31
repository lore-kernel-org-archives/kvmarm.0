Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8E4426699;
	Fri, 31 Jul 2026 12:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501482; cv=none; b=NT1oGFRb+zFC6PCrMzchM3953nsu8UVTppjzmUSRVFyCZ/rt5inFYwxTZujDgSKJxRiYgs0+D3cFj8UexB0EnGe9xFe7DiAGS5Aj34ZPMM9mid+h8FQfRPwaGm6JvJ3TliIEz2ojTvPUTKSkNyOal8q5j4uBD9TVYy2DZdlJUjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501482; c=relaxed/simple;
	bh=FT2TSuULmElpPmeYieBAkFgZhV4YidCJrYY1r/mOutI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c4wV6jS9YXPrZQS6j7XMzptkfLvesSAOhRfv2moUhvz/+THV2gynF59EGXphz4Nh1Dhs5642efywXMHO1Pv5Z3Io45a7HVLVMHN3SYpswg9lpcDxsNS/htPci9jhsbOh6QSU6ehD1DCk6+cgK4ap+jTSBbQsQ1xW/TvKJM07xgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R9UFrVzM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9UFrVzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBD71F000E9;
	Fri, 31 Jul 2026 12:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501479;
	bh=eTVFry4MHPWVaAwWLt0EkQTJPTGjneLmXq1Hi8Kp9UQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=R9UFrVzMEk0MHsJl0xBBYp8liPSjOa5onEUBIUnghBe4btgqHtgvi51eMcTO/r215
	 BJMqmtKMZVFvNU75h8je8+U5IeTXiEeKrhzr46MV5CA+dqrDWKwkZ4y3ncyJdaVIMx
	 RDIWK9NR/M/W2OsPUlP9GRJgfn5OFyhrV3hNtekZJsnOSesCp+vmcGDbdYg7lulIQS
	 rUuiAjNp6UdmFL8Kp4C9NWNHGFCiqfEVeCoWWioX774Brc2HU43wAPj/akAuHupgWB
	 7SO9XCzk9Qtkv3UGL7VPqHSSCdBh0EzKDRxK6ttb8GoAMh2+7XmQ0C9Y4vmabO+ng2
	 n4cDBn5hyz2og==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 31 Jul 2026 13:25:47 +0100
Subject: [PATCH v17 09/14] KVM: arm64: Allow GCS to be enabled for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-arm64-gcs-v17-9-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1947; i=broonie@kernel.org;
 h=from:subject:message-id; bh=FT2TSuULmElpPmeYieBAkFgZhV4YidCJrYY1r/mOutI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbJcC5xQAjjbsNTtFkU2/M/yBceaeRJYtOAWSR
 y02p8QyaSeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCamyXAgAKCRAk1otyXVSH
 0HiaB/9YYDHHAIRur9MeISVto8mw8xK6uHrtCMLMVsS8ukyvZL7zh/q2B1VAkRmVIAr3iLED1SM
 /9sEE01FmkE/qedOUKvbPJHrZyY7ecWTTpaet8ZwDTFhzvL0gPTxy5Nui5mz0ZN3rDUWmovFyGC
 XP0+CWI70Gf8VzeVNPXA4aCWo1eQaMf2DYYkICR9maKZMMTkjHZFSpp3y2n/4ivK3VtPGifZZIv
 Xe5xKU+jzh/Qm42hYMyw5N/ravHbenVJTlau3ciYJ6kezFdXYloBtt+w+5Dbhj6uT3VEWdSo7l7
 zgytqACjPFBOSY1LruqaIYCTmjlmJ7FF69vMXYQGZN9Xg8Jj
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Now that required functionality for GCS is in place expose
ID_AA64PFR1_EL1.GCS, allowing guests to be given the feature.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/nested.c   | 3 +--
 arch/arm64/kvm/sys_regs.c | 5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dfb96edbdc43..e588820b1be7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1632,11 +1632,10 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64PFR1_EL1:
-		/* Only support BTI, SSBS, CSV2_frac */
+		/* Only support GCS, BTI, SSBS, CSV2_frac */
 		val &= ~(ID_AA64PFR1_EL1_PFAR		|
 			 ID_AA64PFR1_EL1_MTEX		|
 			 ID_AA64PFR1_EL1_THE		|
-			 ID_AA64PFR1_EL1_GCS		|
 			 ID_AA64PFR1_EL1_MTE_frac	|
 			 ID_AA64PFR1_EL1_NMI		|
 			 ID_AA64PFR1_EL1_SME		|
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3d9f4eb9d093..ba15da63758b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2103,10 +2103,12 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val)
 	      SYS_FIELD_GET(ID_AA64PFR0_EL1, RAS, pfr0) == ID_AA64PFR0_EL1_RAS_IMP))
 		val &= ~ID_AA64PFR1_EL1_RAS_frac;
 
+	if (!system_supports_gcs())
+		val &= ~ID_AA64PFR1_EL1_GCS;
+
 	val &= ~ID_AA64PFR1_EL1_SME;
 	val &= ~ID_AA64PFR1_EL1_RNDR_trap;
 	val &= ~ID_AA64PFR1_EL1_NMI;
-	val &= ~ID_AA64PFR1_EL1_GCS;
 	val &= ~ID_AA64PFR1_EL1_THE;
 	val &= ~ID_AA64PFR1_EL1_MTEX;
 	val &= ~ID_AA64PFR1_EL1_PFAR;
@@ -3344,7 +3346,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				     ~(ID_AA64PFR1_EL1_PFAR |
 				       ID_AA64PFR1_EL1_MTEX |
 				       ID_AA64PFR1_EL1_THE |
-				       ID_AA64PFR1_EL1_GCS |
 				       ID_AA64PFR1_EL1_MTE_frac |
 				       ID_AA64PFR1_EL1_NMI |
 				       ID_AA64PFR1_EL1_RNDR_trap |

-- 
2.47.3


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D7C37DAD5;
	Mon,  3 Aug 2026 23:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798852; cv=none; b=SfWY+DX0gE4g0XVBgxIAqs0diPpBkVfLQR9SHgDIRi4Pprx+Hs4HTdurC/iGCZo6i511KbeNc4u6qbu6Ja34GWYiWfygEDAHOf5mDh7/4Fa19jg9waAehJKuNxt/X9/yVERgEU5zzIq7EUl5cgx+JhvpXEW13TMWkwucQzHtdIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798852; c=relaxed/simple;
	bh=fG68MfhkwRfSg1W6YX0cbN8/yZcNS3S2f4yLKb+2+CU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hFSq7VMm4/VyUKAOwX8jIODRQA3vizpSg+ee2/uFtWKDaVfGrdXRD+twakjyz0FE4df9KktEAPdaAxeik3rkdRmeMknTTJgtuaGxQixZFB4GWvUa1MxwcYH5uxmO7V2NcAwA3ZmZfeO54faDfBZrSTqgN2n4PmncJj+CExap2iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfNuvcWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfNuvcWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DBD1F00A3E;
	Mon,  3 Aug 2026 23:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798847;
	bh=fiugukty1Mn9VBap85XV+9U6g61CkNYwrAZccCYiZGU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AfNuvcWSdk4R6apsQH2JnDApmuBXbQg6asNwcqTyVS7BqpbXagvh7NbqDS307MA7x
	 saoi64x4R1NGCFNK/bZbbIRg4oGJ9RCFMq5i1TCSGa2y6jmiPL1y90Lelj06uca1JX
	 0XkbsIRH7OR6Dj/sTcxBOCYPw5qsW2kOQ3X1VnxelCsxwEsdrxW/pSwUHMmByExxuz
	 kmcNvs3TYj7nHn/0lxvaPGzOAD8vVbAb7vJfOk0QlNkXHzmbZ8lM4AW6mmRbSsqaLO
	 6zX7R1A2RjDc5vUvT9Rrf1I00Xn5bn6JaxfuQu02c0V+CBvcRk3xswBJULmi5MvFD3
	 5Pk2dKFtwEqvA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:52 +0100
Subject: [PATCH v18 07/14] KVM: arm64: Forward GCS exceptions to nested
 guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-7-fd8c40f5ad88@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1286; i=broonie@kernel.org;
 h=from:subject:message-id; bh=fG68MfhkwRfSg1W6YX0cbN8/yZcNS3S2f4yLKb+2+CU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCfDFrrJu6EBWatsQlkDL5fLdxzD6q+uZ194
 xEX8/bZYV+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgnwAKCRAk1otyXVSH
 0P4eB/9zHfXUwqA3slkhU8zpWiO6oeFu2MR+OB2dN1p5kY4ZG138rVq10mYyWQU8QNQ6v1G0jpW
 In9wLKEM2acaBUUiCKckWBNkOJOlCGrneiptUyFmVfn5pmNv6S+KztRxd3gnCJODMFvftwMTFh6
 FJ3CsmvV5hPa1G1Z5/KttX1zHQ/qsbBPkeNgmfmt1iAzurlgrSIKreSMTByopRgvu56croTYSik
 FBMaDy/0JcX9R9KdFmT+fV99wDcVF8BDhzFO5Zmz9I9bOuIxMQfmfEh2+0xULOvImlxQb/oPIw0
 r05PfCDqy41xH/3wlnenzd6JxGRRauMN+CmPtGqR5toa2jxc
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

For nested guests where HFGITR_EL2.nGCSSTR_EL1 is clear or when there are
L2 GCS data check exceptions we need to forward the exception to the guest.
Add handling to do so.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b..63dcc4a0e69a 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -304,12 +304,24 @@ static int handle_svc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/*
+ * We might get GCS exceptions that need to be forwarded to the
+ * hypervisor when a nested guest has HFGITR_EL2.nGCSSTR_EL1 clear, or
+ * for a GCS data check exception for a L2 guest.
+ */
 static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
 {
-	/* We don't expect GCS, so treat it with contempt */
-	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
-		WARN_ON_ONCE(1);
+	if (!kvm_has_gcs(vcpu->kvm)) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
 
+	if (vcpu_has_nv(vcpu)) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+		return 1;
+	}
+
+	WARN_ON_ONCE(1);
 	kvm_inject_undefined(vcpu);
 	return 1;
 }

-- 
2.47.3


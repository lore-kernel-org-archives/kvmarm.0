Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E9452189B;
	Wed, 30 Sep 2026 21:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804961; cv=none; b=lWXa82QvSiMO/JdKUgF415dUuLLOkV7zx1hoIu3DxMsCFSONuhuTzHTy8X4HKjF24aXB9ouzHfBI323wpxWpnEiRsHuokmZw0UoKLucQizdPZaU9syab0XW7DdcqdYGllfCK34MwgJCbyfv4HT+ATvlXU9powXIg/rzmSMrGA8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804961; c=relaxed/simple;
	bh=kVbReCZrKoi+cVaC6OJWcE+twh1TXQHikn7eWoOdtvk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AHILXvAdJEQhWiBMGL/zRyIF9buklTOi4PcFa+E2cT0TdSM0E2+ZcxY67I6SU1T7oMGeHC69uDM1FrQrgXWSKnCwQv3H/q2a/MsJggP2Zk4RrTY3CViyCiSXt1+gy4aqymm6EaetMcgwB3lCYBsikygQEL/uW6Sh8BefEzMrGfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ts8bHGm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ts8bHGm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C94C1F000FF;
	Wed, 30 Sep 2026 21:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804960;
	bh=ETO//ZHEIrAWcvZFpQcrmAKGm+pliNn3pzbd4bW/wbA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ts8bHGm29D1eMA1ta/GX1aqLyyVAi8ruqECban51kmGbRcRgDMsWBcCDAl0t2f3Jh
	 Q/jLdqjBnV+OEHiSbInjqDYJW3odZYvT11P1QpbunBu4HFg50GGd3PsnO/OJfHwjv1
	 cyr+X5i7pYq83Sj6UiV09wpQGnCKVhSv/jpvOH2KXXxkPqugXlyJtbHWmiA1YUapYd
	 C2EPaZNy7XsHTcCZ3Oox0e1+FjyzInMk0f1opkKPGNIiXuqHaBK2Tqu1IibKtTBVaX
	 9XAlCbwpAzGbtk85ULfPQlGSBOguDVYMq/Be6o9croqMZ800dQpGmf9w//yIU3XOy9
	 3b9kjxhA7fITg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:17 +0100
Subject: [PATCH v21 07/15] KVM: arm64: Forward GCS exceptions to nested
 guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-7-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1333; i=broonie@kernel.org;
 h=from:subject:message-id; bh=kVbReCZrKoi+cVaC6OJWcE+twh1TXQHikn7eWoOdtvk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO4QbfvLeVqTJpjsPJjc0EbJR8LurVnuvWMa
 bAxPXZiG5WJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DuAAKCRAk1otyXVSH
 0EzLB/0X4o5J+Ob3x2kpC8lQ8ERNBXCpJ05jLcfpiazZPwXlKoGWfNoYBN6W1t/+QdQX/pWmMvF
 4/9rpQcNiHT8J3tHlFJ0/BsGvEmP3SdsYdVt12wgekEypSAgwPZ72VrzfW/nJlE+yhMTP2xP0o8
 oXzZxyDkTKHz7fihVqNfygtcv1cRcJvyq8c68xHosJaj+3rBUjswzk1DzJ4NHXa6MxNq8PhySPa
 UAJx7D4ehMg6Rbwgp723DbbbjdIBKGqwnkv6JtNYCGl5oyDvLaBUEWRM83zap9K9hxNsmoTc48p
 0/+lkUNYaRVU7dj9yWoo1LGKSQPHFWoTouPxFugwWMtXMgZm
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

For nested guests where HFGITR_EL2.nGCSSTR_EL1 is clear or when there are
L2 GCS data check exceptions we need to forward the exception to the guest.
Add handling to do so.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index db37678dcb05..a8198e96fcb4 100644
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


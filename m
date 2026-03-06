Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801CD3A1E96;
	Fri,  6 Mar 2026 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817009; cv=none; b=rBVeO3b54FC3047RGM+oaXAF4dmZWDiUM8G9PkOlEKg+SghrqXJrzBUy0/7QT0m1lkj6BA+E/k7aR6XmdGkOhQtPqzxkQheSX637eSr8sqLnR0pxGI7UKwtDX+J6miNJczVnlspOlQQclq2YP3VFjjPsO91PG8Gg84KcCQGR4Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817009; c=relaxed/simple;
	bh=AeF1hwoxwxrE+FMHOeHAJ/eu1PU3teMN7UxNIXZFRu0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZlQA6M2onYqUbCukMswTg6lNkDBmi4CfDWIqU5aiRuTSKSuZvi20yGMnzvfyQCfq5tGIb1J9Iq7gyUuNvR9pjWCkmLWbOIZVqO5Xpda2U109RXgDHrOG/ptxl4hM56MXw9R1z3Znp7iBu/HxBjcKvfPldGZmeNHPRzczbA6eYMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r75vkUAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r75vkUAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEE9C19425;
	Fri,  6 Mar 2026 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817009;
	bh=AeF1hwoxwxrE+FMHOeHAJ/eu1PU3teMN7UxNIXZFRu0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=r75vkUAu/Ivoim+qAOgFwBMiq6Degl3W4n8qhfLU1kdj4bUTnAO8wGqGwdYmIA1QI
	 eTAB3nQ7tg8d34Z6XrC4Vox4AfPxC4zhYXFKXbY8Kg/AY0GGn/nVr53+EULqcHxC18
	 X8excN0n0yJTo8FXbnl8z0et54+0vX+A3SBWbzDkuc0CqFMkDdm+zuZNisTosFq5sI
	 sQaoSsrtOmZ/poOHXoyVx2tIF62gIDwm+D4Uf3pauXkKhHQZeSv9V1nC21v9YW3HIl
	 0XmcnK46NoyyODn1+jGxr8q036LCzVg9kwc7rYv2nJ1i/LwHlupPAa2c438mym/GYj
	 zemUZETwL8/rQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:02 +0000
Subject: [PATCH v10 10/30] KVM: arm64: Rename sve_state_reg_region
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-10-43f7683a0fb7@kernel.org>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
In-Reply-To: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-6ac23
X-Developer-Signature: v=1; a=openpgp-sha256; l=2396; i=broonie@kernel.org;
 h=from:subject:message-id; bh=AeF1hwoxwxrE+FMHOeHAJ/eu1PU3teMN7UxNIXZFRu0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwowm0AizuLxb3k3mbTwFO0Nw0hKiV2IvV+IQ
 ZGhfsw3qniJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKMAAKCRAk1otyXVSH
 0NRjB/9CvSUYqf+SB8M1EfZF9tK8iXowB2O5hAp5YQBqreL7Xpw4K+/+OuvVB8C24881Dy+mtlV
 secGqXbax1KsnZuQl/itCOrZdaaxp0n6ONiBptopP6OnpixecCDv3DEY2xtLZRj058MPZF5HUIS
 bMtIrerT/FkHNDM8oKgNxHufFUwhm4o9xWCyhTNX8cCs59HWUcUh/Exx0SxkljV3WOa795FZUGc
 MPThGNES8vTi0zf4cHfhVCs3tQ6H2cCPAhoUxDflvaLzph8WT9hKOXIiIWxnvf0wcdoZPt8p63i
 QCVKTkEBfc77YrmfIUp0Z+XbFH86IkuKKu19Yc+XLkXfgaaf
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As for SVE we will need to pull parts of dynamically sized registers out of
a block of memory for SME so we will use a similar code pattern for this.
Rename the current struct sve_state_reg_region in preparation for this.

No functional change.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/guest.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d15aa2da1891..8c3405b5d7b1 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -404,9 +404,9 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
  */
 #define vcpu_sve_slices(vcpu) 1
 
-/* Bounds of a single SVE register slice within vcpu->arch.sve_state */
-struct sve_state_reg_region {
-	unsigned int koffset;	/* offset into sve_state in kernel memory */
+/* Bounds of a single register slice within vcpu->arch.s[mv]e_state */
+struct vec_state_reg_region {
+	unsigned int koffset;	/* offset into s[mv]e_state in kernel memory */
 	unsigned int klen;	/* length in kernel memory */
 	unsigned int upad;	/* extra trailing padding in user memory */
 };
@@ -415,7 +415,7 @@ struct sve_state_reg_region {
  * Validate SVE register ID and get sanitised bounds for user/kernel SVE
  * register copy
  */
-static int sve_reg_to_region(struct sve_state_reg_region *region,
+static int sve_reg_to_region(struct vec_state_reg_region *region,
 			     struct kvm_vcpu *vcpu,
 			     const struct kvm_one_reg *reg)
 {
@@ -485,7 +485,7 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	int ret;
-	struct sve_state_reg_region region;
+	struct vec_state_reg_region region;
 	char __user *uptr = (char __user *)reg->addr;
 
 	/* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
@@ -511,7 +511,7 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	int ret;
-	struct sve_state_reg_region region;
+	struct vec_state_reg_region region;
 	const char __user *uptr = (const char __user *)reg->addr;
 
 	/* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */

-- 
2.47.3


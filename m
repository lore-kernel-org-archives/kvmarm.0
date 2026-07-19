Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBE83803F7;
	Sun, 19 Jul 2026 23:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502655; cv=none; b=T0qjMqXFd72byY0+0aJbYYxSSNCs/5Kt9MMmpWZesB6zAlkDOgvwD3lrO/6Jkbaf2QOYzvXVVQJMIswC7zesnUsvLQiH+rNkX8YrAhp56MGmUvU/Rq3vEHOCoHgNgGRNBv9Z112cKREKOkESSwary5zPymCUl7qBY31WDThmquE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502655; c=relaxed/simple;
	bh=LymwA3DqasGC4ZFs4/KMSvspNgOVO26BbyCDy7Uzk5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DgKxcmGtyjarjabiIQp2od71FAFnLz2FXLzfwaz1soz4ZBVaM9xEgAW54oREeu46yltLErqWCKCzCNgWSPWiT0xIrOXxQFdUYqHHQ/8gV4vBpKun8W995qOiI/frqXQ8CXrkz/UKkg0J4SsTZ9SV0cNyn/onL/pWDZmOEEjrvHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWl78oUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWl78oUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59F51F00A3A;
	Sun, 19 Jul 2026 23:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502653;
	bh=H8WckkdslO+jqzhb243ic0W1zpfpgFKz9U8uw4dwQBU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mWl78oUnvxwHaXL/sHj+CLVk86T8Unu5lpazkkW9i0xXcU8s4TIoR382HNxxWUDaf
	 zuaNPqTNTYwSfPz2r01pv7bvjyOvcnAQKNkPqlEgx6PVZBTZjyMYaZwRVbwxytScRd
	 nv87qSWLGHgIUgAqPuEn407oF+/qZyxIm9elNIWmBVxVV8ney9UR5cPICwJX0iE3Id
	 PlGeJOCwgK83dVSZQIZ5WtjxzctO+Vh0ZeiqehGfilq2tkXrZ9R+YCGS6SBwvRmVfb
	 B7pcp8ClMilje4YIL8EUZggg84LS/5HGNWQ8sxSAOrWEe/XbI46SxeAqyvLvhAdShp
	 ORDAnfbw2DqPw==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:40 +0100
Subject: [PATCH v13 13/32] KVM: arm64: Rename sve_state_reg_region
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-13-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2449; i=broonie@kernel.org;
 h=from:subject:message-id; bh=LymwA3DqasGC4ZFs4/KMSvspNgOVO26BbyCDy7Uzk5Q=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVkxKQcZdJy3CgVlsYTB2yBImeJBskXWawsGh
 PIdrMofXbeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZMQAKCRAk1otyXVSH
 0PZPB/9wYDWSSwuJoaXegbkA3ojn0bg5GFt/VB8ePBzOuLDDSDK98wtdtnisSNGdTEQEODMmlwE
 TRHMG9m6rYm1abTicdktsE/jloy/lefN5lah0N5YueiMYZ502dFHWXLv9pGw2O0dp/cGhJwVX+j
 EP70Uq7RVtOrF3B2q+m982KWKilxk3T0TtNRFs0rc2lpsX987oc1SyzsoqPoH6iDDuTgE9TWCS6
 HXbfXb4kusiaYk1tkwJH2BabGn1PNNLvLZqgfT/zaxdFwnWlwxA7HGR+deaKEEPK+lGi+HS2Zjn
 vH88tZpsJAdaC5HrQgbTFBFigIpgUA/HS3O9xkfPcrvudQxq
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As for SVE we will need to pull parts of dynamically sized registers out of
a block of memory for SME so we will use a similar code pattern for this.
Rename the current struct sve_state_reg_region in preparation for this.

No functional change.

Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/guest.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 0b789f73bf7c..3ae751e72c95 100644
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


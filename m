Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037A743B4A7;
	Thu,  9 Jul 2026 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622453; cv=none; b=R0m9Ue2APrKcCh3OcylSfm+vjSavD+W6NUb/F1kniDdv1G29uq7h6ny8j0IpwWM1DjAucoz8PnBpV7InRGQIuJvSRItl80tyDjClOpPFNeJDp59GkGlK2DsGJOaHx4jmDA2bqXtDSOg9QAwDMkenfQ2YY+ZQgX1cYBE1sgEmhq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622453; c=relaxed/simple;
	bh=LymwA3DqasGC4ZFs4/KMSvspNgOVO26BbyCDy7Uzk5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mzvF7iwCurJH/H9N1UqLIxtG+pJauUKNc47UL6NZZs6mdyDze63f3blo4iUbxqQwq+yRUNf3d12P0zIus1JSGx2beK2Uk6MZQ4rKbJ6FxdOw9cIJi2g+N3rwhcpX/dm4vqQr542srwacTG2QJBFXj9nY4E+0BJqJtXLKzLMyEZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlPlxFTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlPlxFTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A951F00A3E;
	Thu,  9 Jul 2026 18:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622451;
	bh=H8WckkdslO+jqzhb243ic0W1zpfpgFKz9U8uw4dwQBU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dlPlxFTOihrtyHnEZV+H88T0XJoVHOEenO3yPnvf3RaMQ8boYA/0qV1wPonP0F87S
	 QLsO7M/P+0Eoy+YtlhlMg4QMOEYa5Vb97vZ73rpD3q8RNehXzgR5EgaulQOEdBCLyz
	 qyNoUE2uwAm70+opJk+XW/6Td4ooef+tZQHU/LHXYq+7jTYeFy26mfngWeofT3szIy
	 PaXwey41iBRLFjKDlA/ZHVyBnhrWsVKqattai4MLOcPCdLBKgSffatPcrMRseXwplM
	 oMpJKCy09TsN/42qiOmtGO7xkr2a52b4NClI03ZYSALAw4MMC7rF/XXZBeqdDBbTE2
	 aNiN5IRIo/7PA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:31 +0100
Subject: [PATCH v12 10/29] KVM: arm64: Rename sve_state_reg_region
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-10-d0301d79ef58@kernel.org>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
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
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+rxJEu7Sekl1584rUwiaayoFlVsCzxxoeDoa
 hKPxoF1eEiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q8QAKCRAk1otyXVSH
 0BO2B/0THbdeuRzQNA7FHbTe5OzOQnS4lMTLibBq/lNyz0ieEu1Yvg9UagQb8JuQKDQny3UgTIt
 APBJQ4WCDX1fhXixyBC2AE/K966O1iTIMexQPxZUCihBgizLy80MHz5/T/smboVQkbTk8u1FeyA
 cydk1XYntnfjVYMpepAr9TqRL1eTvTYpTPXRa26lwYVH5MWNZ97VJJdH2JfG6AhVoz0HDDq/+4T
 VzOWCI5GntCxfMm4ZFsJEeTUcZ958m+jjwcAL/D4orUOLi+V34C0M7W2UQfKPvk6s3mWvPIJWCI
 CUkxQENtDBqYG05kBU8Nk4ZEsd2Qd2o7rk3J1SurCrLWaqfe
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


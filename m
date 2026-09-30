Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8775335BA;
	Wed, 30 Sep 2026 21:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804983; cv=none; b=CLj4zPMpHSE8BcTc+DH1EY9SsFWBdRh5+a3xJVHD1Xwsa2bO7fVcvMu0+dSjevsIgQl+YkGq9iW5CUrqE1En4b+VkeIb3Dkr2whWoB7EtKFG+qTWk1af53uK/V1RQsce5DYGTMDdrRU9EckNnzW9lW1dMVra9XQdK2W7mliYprQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804983; c=relaxed/simple;
	bh=XOq2i2Akpnkmw/R7Jj1JMRk+55dESJrYh85L+sVQnck=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Hf/XTS0v/OxE95Tckvi8t40YRMfLjyFzHRXmB24pFY4IpCArRfeEJCCUFKTy6mEDgLnAgfeNTeYHpcKom+m0lOV1EBJWSU/o2OFhKtoW5yQ8B3/Pb1lyBlHxDd7OKbXKLtvJeW2ZwhR95OEAjldVcZSWtSN19yV+ZbP+HrqzIeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IXmbG6jJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IXmbG6jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D21C1F00898;
	Wed, 30 Sep 2026 21:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804982;
	bh=h3lrCthLI1PC2iGCSfULUwv97R+6R+4yOlZN59Nt/3c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IXmbG6jJCbw7N0HXXWrLm91tO1wVlO/YgTjjksE//WqUgUk85PZeLOx56ZdgkhvZW
	 kN38rytbTvvFhhACOaLkNIy+LnaK+ku7ED0MMt1Vl4wUtvJZR6ZY7Iw5Fj7DpcUKl5
	 arm5DBOgjlgtPn91kOu3eXYeazZNau9NEYvznm75YJ/cgSeEs6GYlTRUFwe/qFp/3a
	 j8km+JMykjbQnC39jJUZcNP8blqFbWwie+/AM07g5n+cfbmsysw88KcdbEUyG+osav
	 cmHY0IMIy+bln5/RCSCXqPMZh5MShXQt8bxen/tZ+3vshUTN5DKgjrID6fGFrdFp5Q
	 2DW5+jKmUpXCw==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:23 +0100
Subject: [PATCH v21 13/15] KVM: selftests: arm64: Only restore SPSR_EL1 and
 ELR_EL1 if they change
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-13-3556644cd927@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1555; i=broonie@kernel.org;
 h=from:subject:message-id; bh=XOq2i2Akpnkmw/R7Jj1JMRk+55dESJrYh85L+sVQnck=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO9JuUHyRVDEv1xhfnkijFI8FEvAQ0AbR/91
 YqKDLaXw32JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DvQAKCRAk1otyXVSH
 0Bm3B/0eoqlFUjRCKbK69n2bBkysp01U/eJf6B/+ofQ4MTse0MTyJPLrjZH5mp4lYvI6L6f0P+2
 DpDfyXhk+62t5VKZRXG0Swn1jB2wp836Nk1PgaeAiEa8WYrLgiSmM2cNzdamMl/AfrMb3YjeR5G
 0PIo1cSr8MwraP7Yf8IKPX0AbUNFjkNErvOzBReB4mdbiE60MdVR87gHnzz5DCIFrm8N1uYCnXn
 QCO9hlGLYLkqb1cnG2W4bgj+ueD/RceHYVTkFTLWo43S80fbCKYIanRtks8oIPZAFa4U+tL+iG7
 ub9FCQrBG4UR5jMjN/eJQX9kqqM5IEOzeohlQh2nXCoyiP58
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When EXLOCK is enabled for ELx writes to SPSR_ELx and ELR_ELx generate
GCS exceptions. Currently the selftest helpers unconditionally reload the
saved values for these registers regardless of if the handler didn't change
them. This gets in the way of EXLOCK testing, making it hard to generate
contexts which will generate an invalid ERET since we never get as far as
doing an exception return while EXLOCK is enabled.

In order to facilitate testing of nested virtualisation emulation of EXLOCK
change our reloads into read/modify/write cycles, suppressing the writes
when they would not change the value in the register.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/lib/arm64/handlers.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/arm64/handlers.S b/tools/testing/selftests/kvm/lib/arm64/handlers.S
index 0e443eadfac6..367c22d61cba 100644
--- a/tools/testing/selftests/kvm/lib/arm64/handlers.S
+++ b/tools/testing/selftests/kvm/lib/arm64/handlers.S
@@ -33,8 +33,18 @@
 
 .macro restore_registers
 	ldp	x1, x2, [sp, #16 * 16] /* PC, PSTATE */
+
+	/* Suppress redundant writes to support GCS exception lock testing */
+	mrs	x3, elr_el1
+	cmp	x1, x3
+	beq	.Lskip_elr_\@
 	msr	elr_el1, x1
+.Lskip_elr_\@:
+	mrs	x3, spsr_el1
+	cmp	x2, x3
+	beq	.Lskip_spsr_\@
 	msr	spsr_el1, x2
+.Lskip_spsr_\@:
 
 	/* sp is not restored */
 	ldp	x30, xzr, [sp, #16 * 15] /* x30, SP */

-- 
2.47.3


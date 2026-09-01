Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C22E2D0C89;
	Tue,  1 Sep 2026 21:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299481; cv=none; b=oh17lqKzErHkecL2yK8bWag1YNkB++wOuH/QJcDgE8tArnUkzvg8hc07BAaHnkDh7eCTXmimon9Cse7jfxG9cS7rUPkizoQkv6QbwKeazyG7V3MnVd7lKi7Y/HPcUK0Uc33xD/0lsnJaNGgO9Iw7z9pI73se3fQXuBszexNOqdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299481; c=relaxed/simple;
	bh=kq5inm4XLV9y3q0emrqMvgSlwP7yu7PrdQSzkYGOWPo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MXuCa3ZIaGmwyejC/LlRqFCubZgSbcfrIkfkbV/geEcw5WnO+PoF9H2Fv3X8v1KoO/oE5i9FjDl/0wta/IPxFymEjUpInxHS6gTEYMOyyLyD1pafW0uNzqlGd30OMpFW5RdnCJbqGQNUoqZpzBW68osViMSqmMoD7jhoHxBK0wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZaa0EOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZaa0EOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800EA1F000E9;
	Tue,  1 Sep 2026 21:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788299479;
	bh=nW2uwG3VWmqTYBYq5oWNcIeaMFqReX/mfTA7yT0Lz8Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FZaa0EOECdWg2EgzznRZk6c5LR2LAC5TUfhY0ew/EHHwcGGfLh2DjlILvi/uE5unV
	 VTNCRFXyIOGMPSepAF3zZe3egbb+j4dqiWFSAxHs+/BaJTjYbS6GqdAYJKylb6iZL6
	 4QEtx6wIb0XC3+pshtqlwjGj0EWT3FisTFkab+xa5KyIec1jcYOV2J3dbXgzufoMBt
	 3ulC5lw1giIAc8bzZaHyEHBEu49cg0j5XprAxICF6OtjzwaGPrhTE/blM/9B+XbYck
	 SrgcnEvewn5gohjP6sJoWDM9s8LRwpH5JMX3TuOpZg6MXxuEWoZzAcdO5pXnNQBn1h
	 yyypQuF2d6Yfg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 22:47:10 +0100
Subject: [PATCH v20 12/14] KVM: selftests: arm64: Only restore SPSR_EL1 and
 ELR_EL1 if they change
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-arm64-gcs-v20-12-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1508; i=broonie@kernel.org;
 h=from:subject:message-id; bh=kq5inm4XLV9y3q0emrqMvgSlwP7yu7PrdQSzkYGOWPo=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBql0iliOMUqxh8DIPCCcFfMaZ3eY2IVxW8m+MHV
 xhDFuanEVmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapdIpQAKCRAk1otyXVSH
 0EVBB/0RCAXJEfmE292StzFEMt6Xvh301atWZ16nvdp7WSfV9/IGI9oAnQ+BdlPcSXspY37gzpe
 2QAe9yOe+sdXjCLybMonWti/OK5GdTR45EHQJNJcBFgjL/mOFtKwYSnkpQAUQSozRBWEAZ02zYA
 iK44Ng1rBjrfJpDQKsSevJnC0+/nJkLzFST6dVVpjd/0Vf5/RptCCYm1XEm9aBHZ9tuZwO8fSO2
 i1g/Lk6yytq+hHmaldxudHH6zYzOGgEfIUBcdGrFlR9Vxt028FpJTpRwnmI/ltwoRz+Anb48EVv
 qKexXAtgYwwx07GOL2I8dqWDbyLlJAktHiKXbdSZiCX8Ob0m
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


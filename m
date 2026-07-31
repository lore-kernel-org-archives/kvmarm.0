Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ED042EEDA;
	Fri, 31 Jul 2026 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501490; cv=none; b=PS7Ursp4IBQoJzuGpFYddDb+4aLtuWueTEPaEOaiWbUg0SDOeLeJmAORctWHkE9gSsgHAmq3uF7vHDwe7ulm4qzCw2tc6Cy1fJ39HhA7nIHDsUd3HCSOaqDOog1QYo3+yjIrTRdHaufJCL1JeYygEO94xQVM3Q2Xz1ptymMA7Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501490; c=relaxed/simple;
	bh=kq5inm4XLV9y3q0emrqMvgSlwP7yu7PrdQSzkYGOWPo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nkYaYc/l4PjkAPexgmKvjCgXIPZnCqNCI71IYb+NVY829FhKRSKrinr+mbhbNYM5A31787+ZLrD2ZrRkWEkYzPkCJrgME09KUV567b2Zwk4G96+xNl+uv6WzHRPZvWzyzYZ6iNOdJ5OxqsWG/F5aQT2+jzzuPB2FRm6D0ZsY9BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRPLBaAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRPLBaAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A50F1F00A3A;
	Fri, 31 Jul 2026 12:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501489;
	bh=nW2uwG3VWmqTYBYq5oWNcIeaMFqReX/mfTA7yT0Lz8Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SRPLBaAA3VTtgRW2r2ldajLvKJ1MqweSLObW+8SvAdiDBbwyzEyphKahzpYPlgzts
	 EM4MBTsTokwdnKbLGOwDg2jWcN2JnyB6jfnk5GrZqqBZvt7FGpfdsLSiBdB+RN7Qnw
	 75+PTNjpvA3udyFIdfJk2x2L08T4PaAMVN1er8zaceSGa7RuK/rLXfcdws2zY8UD2u
	 gLF87UwJVV8dwz24auHQOFm1OgP+UG2Y8c4c5P6Xn4/d5MlbCt5LCmiOlPgyjopqCh
	 4ZwfXjPytHIdQpy1W9pd0mEJJr2xvuuva/WBZQpmE/fPu20B28US6j3z4PPZgCDB2Z
	 +plpGy8Lsnyvg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 31 Jul 2026 13:25:50 +0100
Subject: [PATCH v17 12/14] KVM: selftests: arm64: Only restore SPSR_EL1 and
 ELR_EL1 if they change
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-arm64-gcs-v17-12-5e39ca01b14e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1508; i=broonie@kernel.org;
 h=from:subject:message-id; bh=kq5inm4XLV9y3q0emrqMvgSlwP7yu7PrdQSzkYGOWPo=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbJcFnjMOtw0swGPvnW50uvGG391F/yvmA0jXd
 uYSZMtYsCyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCamyXBQAKCRAk1otyXVSH
 0KFLB/4uy9NGwVVvwOBSQZyKtFNFQX2//3ZKfNQgttRdsvPdI10IaDENOqulUF2MxEqFqgVf3JC
 /8PQWi4p1Zr3MDg+nKfn3ZrmpSH10j2p906EBhrfLW7YA8LSGevK8ZT46DB6dQk0BHtsocmSRDi
 awOh6BkKwDM/U9VCXmqbVnu/iJL+6twpknBh9tMgIVgxWO96Be49G0oCPX5wKL0EGQP8ZaRYVKK
 sZPWpGlYZwEBEV1JDfTpJNFuDxp3Ew9/tSvtFJYRCiw80tsVfTsKTnM2yjQ37hfS9SixsGYVZCq
 KoS7TvAbEC7IkPALaVpLnA1yi/II1gukqnCROOHkmajaEqlw
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


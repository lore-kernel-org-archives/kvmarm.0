Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336954E3788;
	Thu,  9 Jul 2026 18:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622412; cv=none; b=XHUZswwtG3qGExM9Dx+YwK9VFrhmiQSS3uHet+flUFOVTW/tuFyQpBUES0e42sg7jtqCcuLDvStLRL7swoLeTv81DAdEgSGYsG3rkgrDjOx9kFsyIpPOwOE8lD6cFTDA91JWyYlYaqM7n29SomeCmvlpF53bEI3KOMaZslDQAQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622412; c=relaxed/simple;
	bh=gzzsP4OMBAKH5syutaWFaVFk6QC8CDQSj953+mInO7w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OaBAR5XCP8cEa8Xh605RdW2y6PLNWM1ROK3RVPxOV6WOM8Bb3TCWuYbG/5Wc6Bk3wtrJoYs5S9Zv9DIsNekmoCRp57rbUWNEJQfKRVKHeFreCQlCWozK2bB1FhC9FfGO57u0G6Fk5oVL1LDlYOmc3zZayTP8uEM1BbtmdTLaZj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZbchbECU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZbchbECU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B45A1F00A3A;
	Thu,  9 Jul 2026 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622410;
	bh=/QjA1AblP9L+Kt9SpYOOkyJVVOOzYmepn7GTlwZFelA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZbchbECU3TgvDU9TfKk07SWKmdAeq0RpQ4u52YETSBtL4NVKmeqgzzVYiwlmp3gkR
	 w7CWPmLyF1YuVVzrKg94orJD1cwQGwg0KaICevffgR2WZL8oCDUrE4zOLwq5hJKZfQ
	 I3Swon6TGYL9TZVro/L/hbj5iDh/Mg/FFczzqtcg2c2EGYNe56HAPd1nedf8lEZX5g
	 d9aNNf4mPQY5NSin65kAMqPBBY4cZER/WqgoCb2Jr7be67l1XjkMzZQ/ssZDMq4Rd+
	 CBZ0PbHkI2yy5xbaAIpJ39qc1MwO/TdWLMm+xsvjVlRc+q/uQNwV8xNT/YlNbZo2yv
	 ruT96phC1mcvA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:22 +0100
Subject: [PATCH v12 01/29] arm64/sysreg: Define full value
 read/modify/write helpers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-1-d0301d79ef58@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=951; i=broonie@kernel.org;
 h=from:subject:message-id; bh=gzzsP4OMBAKH5syutaWFaVFk6QC8CDQSj953+mInO7w=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+rq2VgOet80BJWD6Xh/o3WcW28LRlhze8qrE
 b4cZrVNCe6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q6gAKCRAk1otyXVSH
 0F+yB/4mbTCi3gD2Q4fl6xZyQFLCtztRwO4QXcc69jR3p5oUmCZtxnfmfIMo48auy7toplQM1C2
 nrebDOyEN4RGz+nbVuXPUjCTH7uPFygS7UJg8sEYC8+X/UtmvrwIrrMQE+8NUkrxSWXY+4qEeqo
 qDobBHmgPLc0AAz97bCvy5oDrv3tvHiJCRbFHShnb37WwZT5azCcL9hJFFWf/JYzQ13EW2OnWT0
 kHqh2ke8cZvmG/BTRgwa//QcL508JNaftLrCNfhaTRCLQUdOGkZYfSRiYjj27SnR0Frh5VJeNAF
 32iiyGcb6r+YYrtS2qrEKLEscDXE7FlEPTJNTWZJVGXgs7Dp
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

We have read/modify write helpers for updating bitfields in sysregs if they
have changed but we do not have them for updating the whole register.
Define sysreg_cond_update() for that.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7aa08d59d494..4b96449e0ffa 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1235,6 +1235,12 @@
 		write_sysreg_s(__scs_new, sysreg);			\
 } while (0)
 
+#define sysreg_cond_update(sysreg, val) \
+	 sysreg_clear_set(sysreg, ~0UL, val)
+
+#define sysreg_cond_update_s(sysreg, val) \
+	 sysreg_clear_set_s(sysreg, ~0UL, val)
+
 #define write_sysreg_hcr(__val) do {					\
 	if (IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23) &&		\
 	   (!system_capabilities_finalized() ||				\

-- 
2.47.3


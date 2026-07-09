Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700A719046E;
	Thu,  9 Jul 2026 00:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558363; cv=none; b=eyZ5PJdJI+mY6TMauKdunLmfI5yPnUy9RSkj9tHS/HNxQQWCTBQ82heyenB63Ys9BHkX1kNr2rBVN0r4EPI/mYBtMYdBjPwkcZl1ze5iWEADDs6CbYBEN4cY1dbjuYBKXBEMS/wQt8oVlvR/SLPsPhPBBVJDi31YrLQTRGvQthk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558363; c=relaxed/simple;
	bh=gzzsP4OMBAKH5syutaWFaVFk6QC8CDQSj953+mInO7w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QOMjbpF3eAb1w7gH79ELWjFBkSxwr9pojZBWkQJhIog5FGvh+nnwScyzwW0uxXbZJk8kUbTFkjXrG2HwdYwA1N04BgL7I9hBFYvL26Kn6dTlo1YkExNFHTEkQaZoLiyzxkN812vaMMLzLpEUpTdrcyHDoyinQ2CCrgCqTYJBCXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0myndZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0myndZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F731F00A3F;
	Thu,  9 Jul 2026 00:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558362;
	bh=/QjA1AblP9L+Kt9SpYOOkyJVVOOzYmepn7GTlwZFelA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q0myndZscPje3KfSI9FW3gTMmeeeua8ZEmkFyxQH5dHXOfMHQ78zS4c3gNcLLziyD
	 wp/x5c07v1cb272ufNM6fBjS548LhtWWkE13qk6FLhSFi4MobyhBiXFOG1wvQb4OOY
	 X45QlQKNFVmTOSipZTvhw+F9U68CN1fLccDnhA6ATAJAoytPSvu/+i9YcRlguOeqU9
	 1bkCem437dAIZh/2wT5A1goOnUy/QZX6XISakkOpCiau7NRYOmSCkbqMVHNYIdHEzq
	 66b6jFeq1WUbqOqeD/qK2o8MeBQbZyyLEgXuq0TMApITA9QP+w4va6ll1kV6D9WY3M
	 7SW+4tL/t/rTQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:51:38 +0100
Subject: [PATCH v11 01/29] arm64/sysreg: Define full value
 read/modify/write helpers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-1-32799f66db9d@kernel.org>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
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
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvC6xbwefiZAWBDcPgTG4B4odeWW/j2VD/ZjU
 K38FlUWyGKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wugAKCRAk1otyXVSH
 0DhCB/wNdcq8QmBDkyhUPTERrDg6IB9son2hyTNpRiukmPoofldD+LcSxOXi/xX60Nt8x1nSE8q
 queFKnqaxsZXPzBdz31F/LYsxRKh3VsZskWQksc7TNzIdcbOzw7e7zU462Mq8dGXSGNh7XcjJsm
 aGEaBhwNbKqwTsGFyjHnkJJE1blkTImnfOI9cLE0VfYGB/bOG0AmtA8yj6D4ISA6EpKnxoIsAi3
 1sjNYGifqZ5VyCQ478G4ElHYOggf4njrTPH+pigEXyvNBU5R6f+aCSaY5Vx7I4UZAH7/GY7YsAD
 wsmdIFFLLakwG8m93RtErEZdAhgXq6T65EFXyarS4SPQFXFU
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


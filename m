Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5822C08BB
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165278; cv=none; b=RPlMnymglwJUP2MZYuLApB4Qo/khxNMOinzXDXFxnqBO0UEHS8i2ROtkFehnXBrboY4cKOwEfFNt9iIUWnA+6cgYECo10qU9uc84ffUeKEQZR+7M2VNYk5tzvTS7E2uRFyqN7zzobl4m6dvDMUUdsigmJZ9QlC7I1MKTQy8CURA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165278; c=relaxed/simple;
	bh=W6fy+LMwbjibC9ixMuKXna+h8bnjWomjuBKX3w2rRcU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hgk+sRIC/aCX+O2Nt4wzecjCRvnR3zXbYsDDuSeRlRDOg8L9dJdXmJ/1MZWZZR+jt1jAkZn32bzlSUC1pdLBI8mcH1uuD0evjCWyB2r7BqHMJhDTckx3Vf4vVtoQk8B0cgS/aeZVEaz9nNAp6C+cPRNc4fMPSIyHFpIL+xnVcwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Iv5oJH35; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Iv5oJH35"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19A33143D;
	Fri, 16 Oct 2026 08:41:13 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28AC83F673;
	Fri, 16 Oct 2026 08:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165276; bh=W6fy+LMwbjibC9ixMuKXna+h8bnjWomjuBKX3w2rRcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iv5oJH35gyrEtc+E3yfwnpLkHYJLiA08dQ2N94p5jO3vjDIyuCzUz6swsa8UEZbbk
	 NGlHdwWZdPkC1Z7YVfA/FdS9SW+tAbYcOLsaOhN7tQDw7mVMtZrvA17rp4XqmjC5aq
	 A01Z8GegJ2zxvLPPp82j21+77sY7tRjo8leDsJcI=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 11/21] arm64: Assign CPU DT phandles for GICv5
Date: Fri, 16 Oct 2026 16:39:29 +0100
Message-Id: <20261016153939.913764-12-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The GICv5 IRS DT node maps IAFFIDs to CPU phandles. Assign stable
phandles to CPU nodes when the VM uses GICv5 so the IRS node can
reference them.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c                  | 2 ++
 arm64/include/kvm/fdt-arch.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 3cbd36e2..d4cbcff3 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -54,6 +54,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 			_FDT(fdt_property_string(fdt, "enable-method", "psci"));
 
 		_FDT(fdt_property_cell(fdt, "reg", mpidr));
+		if (gic__is_v5())
+			_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_CPU_BASE + cpu));
 		_FDT(fdt_end_node(fdt));
 	}
 
diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
index 8a0a460e..2b667c53 100644
--- a/arm64/include/kvm/fdt-arch.h
+++ b/arm64/include/kvm/fdt-arch.h
@@ -11,4 +11,5 @@ enum phandles {
 
 void generate_dma_region_prop(void *fdt);
 
+#define PHANDLE_CPU_BASE PHANDLES_MAX
 #endif /* ARM__FDT_H */
-- 
2.34.1


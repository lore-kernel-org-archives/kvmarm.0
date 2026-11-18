Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024739;
	b=phyfvrDyP1mhaoABxeJRjKoTljo3eGeq+DOzYe0KTpqGKlmuwEYEkjO+xWt1C0J13ktc
	 9PDOgcRDHAjC7LmdoewklFoOYql2Pp4SnxHTsuSiwqQCtFTQBmZugtGh1vQO+rAZ669u/
	 cxDozF+Np4R6j6sa3+u3YRcIxxSaHsY5bVRfXvYCIoBeB8AzHzCsF9k3uCAiToGVpkU7g
	 Txos94+ZSjrKwi/7Mp5TFp8FkPN/siF1w7/ciLfEJaSDvxt++IrEO48+6gLbixbGF8PD0
	 jZPeTth9gv/1I0C1YvzJ9aHyf7qGl8llAydQCbtQTIuOl3xIWUCkdvBRwGo7ISVGszQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024739;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VraHm7K29SexX5+u12//lf1RRSNEeWxQZDdYUBE8ma8=;
	b=NKsetvvU6+PZx9WIsjcO36t3m8+9LW4UKprClxtuLShkNeQm0P7QlaYBIxovl201xzhP
	 JoYCTgCb2yzyf4gZj2mCFO8m8uL8ubqjiewLIRCttmIhaC8tWq4C6kCb1ZSBPtBb1NJLR
	 O3Dy85vVuSxv0kOwzzNUEX6lNS+OlG+8nOyUaQqyi5IWXQwRSQ25mt2+ni+JNQU0i/Ey9
	 9DEbruo5vz4GquBRJdJ26mYxjdA0pFPSTn/BQIBFr0IdEil78iPQHoSmb4sbSicQKE3qJ
	 GwuCo8zlemXNDWIf01IlENnRjZGj+vmHKh/gdgZtYLhCSX1wFX5q4dWlaU3TXk3/VHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hTf3Ymye;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9CC606A32F
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F9CC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hTf3Ymye
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DA0C1477;
	Wed, 18 Nov 2026 09:58:55 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 792A23F632;
	Wed, 18 Nov 2026 09:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024738; bh=lRMM8KFMZzejuSmonJyhWiiqR5eUD0xB5XotL3pAJ58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTf3YmyeMLcaecF+eO8XgCh4VFdEl1q+xkIfoTU24/suC+aMzgQL1H4V3AKxLIhbX
	 WRvCxqb7T+3gbGN6twLkquC01A4/nPykHelo/IsBCShpdK/yftssM9IDrSvYPrDD56
	 as/vQWyQjt3sXQFQjF20nWnp9mJgqYRVeWqLPlXI=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 13/23] arm64: Assign CPU DT phandles
Date: Wed, 18 Nov 2026 17:57:45 +0000
Message-Id: <20261118175755.1946977-14-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assign stable phandles to all arm64 CPU nodes. The GICv5 IRS DT node
uses them to map IAFFIDs to CPUs; they remain unreferenced for earlier
GIC models.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c                  | 1 +
 arm64/include/kvm/fdt-arch.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 3cbd36e2..5413956d 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -54,6 +54,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 			_FDT(fdt_property_string(fdt, "enable-method", "psci"));
 
 		_FDT(fdt_property_cell(fdt, "reg", mpidr));
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_CPU_BASE + cpu));
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


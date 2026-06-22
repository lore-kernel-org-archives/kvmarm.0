Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0346347FC4
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 19:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782155230; cv=none; b=Eyjb8OkVg6bxSN5x8RrzoqJp1tG1t3BMfQosbjrSxdWNDwUV2dUVoZuEL07DMCkuMSU1MeWKRaRdYJWvr+es3ii3S45SuzcATflUX/avpsIEO3c+lttDq0XYpSpdllfL3q3MYJK7R4TaRwFtOq9KmCHOvH/gA6ozUH/xv0e0KPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782155230; c=relaxed/simple;
	bh=EZk09mqwniyPaFY6x/GnurTL+HGeh3ghHZEqPVduw8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iaZ9LXKDQy16aHGKJkesWHh2w/uobWSOpbwhFdza0ISr7VZlWVKxO2TMgJ//i0KGSpjhSyNgZlqpwKwJf31oX9ku/EN/jjnmhpbG9f069Y4Z300+Wa/7B4Ili9rrwqt3t+gvQHIto3U3hn+SooJtc5N6B+0eCKikE3Ew2K/qPjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XDXKXiii; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XDXKXiii"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782155227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FUoNtrIxitio2ZcQ79fK9DlQrFdcFNyScyGhi0wHX0=;
	b=XDXKXiiifWQNZIr/g1YmsSsbeyBAfeo6+8/OO+eifiMSpBlOJRfGQRJu9UFoVJQi1Ix0XX
	tdjh/tgmDDXv1UEXGI1ycypC4Wf8M0PJSrFynOimdNkHlJ3vfM99+bN0aw0d/o4kHuYwZL
	uxDgMv+GHevA/N26axb2YqEWvgF0AaY=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Victor Kamensky <victor.kamensky@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Fix sign-extension of MMIO loads
Date: Mon, 22 Jun 2026 20:07:00 +0100
Message-Id: <20260622190701.2039766-2-fuad.tabba@linux.dev>
In-Reply-To: <20260622190701.2039766-1-fuad.tabba@linux.dev>
References: <20260622190701.2039766-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A sign-extending load from MMIO (LDRSB, LDRSH, LDRSW) delivers a
zero-extended value: in kvm_handle_mmio_return(), vcpu_data_host_to_guest()
masks the data to the access width after sign-extension, stripping the
sign bits.

Move vcpu_data_host_to_guest() ahead of sign-extension so the width mask
runs first. trace_kvm_mmio() moves with it and keeps reporting the raw
access-width data.

Fixes: b30070862edbd ("ARM64: KVM: MMIO support BE host running LE code")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/mmio.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index e2285ed8c91de..d1c3a352d5a22 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -126,6 +126,10 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 		len = kvm_vcpu_dabt_get_as(vcpu);
 		data = kvm_mmio_read_buf(run->mmio.data, len);
 
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
+			       &data);
+		data = vcpu_data_host_to_guest(vcpu, data, len);
+
 		if (kvm_vcpu_dabt_issext(vcpu) &&
 		    len < sizeof(unsigned long)) {
 			mask = 1U << ((len * 8) - 1);
@@ -135,9 +139,6 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 		if (!kvm_vcpu_dabt_issf(vcpu))
 			data = data & 0xffffffff;
 
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
-			       &data);
-		data = vcpu_data_host_to_guest(vcpu, data, len);
 		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
 	}
 
-- 
2.39.5


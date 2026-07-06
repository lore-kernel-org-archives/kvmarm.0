Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3594229CB
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 11:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783338943; cv=none; b=s3A5qDTgEbAVt2jzC+d8Zu88QENKqFZ9HBIjmsH/rQS2G6OVXWWwA4h+LTo/XsBayUE8BXoH+dXOJ4VRKnylaY1PfTFmAQ//A4dVHL0xJLKfD/TfS9JICVG279ECBxmZmAJW4lgEM/UdWobp1NA4gnLPhFN5pfmBoyZvXPILSMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783338943; c=relaxed/simple;
	bh=MvyTBnlV6F1Y0RkJd8fmTlVMTsxJcwEujZQjdHbA3lA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VrubR+sC967dOEoc1tGIZT/joLYhlSL4rwD7Mcxcssc0gAPgtJQKAbpIIm4jZ4abvBYg5CUbN1DybY7zSkiUSGC0jDfPG1FTUJ08qC4IhgxXGKIiIYP17I1kyzY9LpqXtM2xfqBw+nFMrUVK5SduKzxNx5oZFYV4mwdhnsAn5TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CXLZklVz; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CXLZklVz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E3q//MDRtQ6+cqWfpozqgGjUkOrI0kTKXH9jfdRrlvc=;
	b=CXLZklVz6RHCalWPNfp55jBWwJMh7owTSc+qNKOeaEoWnuMkpiGCjauqKKACR3MEumyYJd
	6TL1hL6q8o8z4HfxlCQ8BRxJewrJHNHrb21ra+PPHtGiZ6p3QMXJmm8VAk2HDhoE0lzcOy
	/vCruVpafI8pE8/vSdUyYUYnt8YosNI=
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
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] KVM: arm64: Fix sign-extension of MMIO loads
Date: Mon,  6 Jul 2026 12:55:21 +0100
Message-Id: <20260706115522.954913-2-fuad.tabba@linux.dev>
In-Reply-To: <20260706115522.954913-1-fuad.tabba@linux.dev>
References: <20260706115522.954913-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A sign-extending load (LDRSB, LDRSH, LDRSW) from MMIO returns a
zero-extended value to the guest. The architecture performs such a load
as a memory read of the access size, then a sign-extension to the
register width. For LDRSH (DDI 0487 M.b C6.2.225, with the Mem accessor
at J1.2.3.111):

    data = Mem{16}(address, accdesc);
    X{regsize}(t) = SignExtend{regsize}(data);

The byte order is handled inside the Mem accessor, keyed on the access
size; the register width is separate, applied afterwards by SignExtend().

kvm_handle_mmio_return() runs these in the wrong order: it sign-extends
the access-width data, then calls vcpu_data_host_to_guest(), which masks
the value back to the access width (the size-keyed byte-order step). The
mask drops the sign bits that sign-extension produced.

Reorder so vcpu_data_host_to_guest() runs first, with the sign-extension
to register width after it. trace_kvm_mmio() moves with it and now logs
the access-width data before sign-extension.

Fixes: b30070862edbd ("ARM64: KVM: MMIO support BE host running LE code")
Reviewed-by: Oliver Upton <oupton@kernel.org>
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


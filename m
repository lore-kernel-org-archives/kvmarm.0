Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CFD1FA4
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718188; cv=none; b=EnG6C4kRvoNG0dmTZMYHcuqETZcCyuYktUR2+WfAbo0OXguMzay+gPsRluZMf+aU/V0xxELWe9SQdDPy4JIkI6oJaque9ZrWU2N9c+Phg9lKd+4j70vHUD7XzsGvrlqLQ2Iu4NA3sI+i0mlb+IC3YU7J4ai33fecVgvdNRnHGoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718188; c=relaxed/simple;
	bh=WDhOrRRXuWitSIjz07TpU7Vtx5+IJpBMs2WDMk5GAf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFRh9Osqnyy8qj6Wkp2Ce74Z44NkanM/Qv2BtxWxBQLfJ8a1q+hUj53TkS+8IlSAyskvkdNOJBxUfsDUmsaJDVHhbZjcste72WMKESi64hA0vI9at/n8DTcog4adKoyEbFSX6t2LNWNAX2kuPLyBQK6aWZZeEHhnlmoQcxHtwSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gAGdmnkC; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gAGdmnkC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ilFFD+yZkklP7EhMGtuomqJkl+9Tbk2Eb8pKKLekD4=;
	b=gAGdmnkC1+Ih4XZQv+v03CoAVC0Kdcgvq66EQuocgAbUnacL8TSu4uODV4ep542Rlxribz
	qGQeZ/7K9x0XFGXyY/Zx9Yy+cx9PC7PR1889eJxGtjElm2La/HccHRt5sChRxvkKD29b1E
	JtT6KFxEHunAZQhWiG5XBjnTCpFk50I=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 09/12] KVM: arm64: nv: Advertise support for FEAT_HPMN0
Date: Tue, 27 Aug 2024 00:22:32 +0000
Message-ID: <20240827002235.1753237-10-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Everything is in place now for KVM to actually handle MDCR_EL2.HPMN. Not
only that, the emulation is capable of doing FEAT_HPMN0. Advertise
support for the feature in the VM's ID registers.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index de789e0f1ae9..206aff3d88f7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -910,12 +910,13 @@ static void limit_nv_id_regs(struct kvm *kvm)
 				  ID_AA64MMFR4_EL1_E2H0_NI_NV1);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR4_EL1, val);
 
-	/* Only limited support for PMU, Debug, BPs and WPs */
+	/* Only limited support for PMU, Debug, BPs, WPs, and HPMN0 */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
 	val &= (NV_FTR(DFR0, PMUVer)	|
 		NV_FTR(DFR0, WRPs)	|
 		NV_FTR(DFR0, BRPs)	|
-		NV_FTR(DFR0, DebugVer));
+		NV_FTR(DFR0, DebugVer)	|
+		NV_FTR(DFR0, HPMN0));
 
 	/* Cap Debug to ARMv8.1 */
 	tmp = FIELD_GET(NV_FTR(DFR0, DebugVer), val);
-- 
2.46.0.295.g3b9ea8a38a-goog


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621213;
	b=Oa2wp1wzTkP9LEACUdcrq5+NY4+Qk1AIHYTEgcJijrgTKFDvOgRgdgqaUQfNtFwwU9bs
	 xndrDM7N/s68LVbx1VkjPeP66RyvLXJ32JTxFpTQ3v63pGCrr1tb+i+4a2ocmV5bxyE45
	 Z+XZwPtjZVZ1YY37bDJj7Zz9KbZhnnjklKHaPDBO+xSQYk7uQJ/bjLc4PrYcJSE7nFiVV
	 p0CcJ7l0vwOLbjrcsKMByblFyvpNU839aQadE3HnxYQDobMMZs/ImsaQrv8FC8DoZcqet
	 I2elz+j6VaRsfDe73cvR56BiyPaPfGSDyGlu4gOkknCL5WdzxYqSvVEBF9zMRrT+C/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621213;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dD0T8dgSUguzAe93p9YMVxo+6FxHhXvK08KHlYhmqa4=;
	b=hQkD79ZOjMNuYX4WzwBreF6/TMHD6BXoYIScuoXsYkYDZe/gYmQkLvkc73pcOGTGownv
	 8L9m23bGjnMNy8bn+G5RRcjwGRrISmj5tKUzC4yqfERK8Gf3qjCKyYv1aHFJXNajEtjcH
	 B9Eytp07U+cCn4dKDbQVgQIKpgs3H7MR5RKD9ASDgEaOM5wEeAlL8Q2qJGNKwTmasivuG
	 LlCp4nNn9SK+QrvI43cDXzfW8snLEUMACXdCQbNsrUrhz7r884vr1KorwC3q1DCl08335
	 GU5cCUiBbLUpMl8m/qfQq6nYCqhD73omAUPZ5neEbivcT1vNdF8q2Fa09isqZQHrBkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MpcYAwBM;
	arc=none smtp.remote-ip=95.215.58.115
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1065A60A5BE3
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1065A60A5BE3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MpcYAwBM
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=mvYtBRC2OxyaS9QiFUPVqxRONTSDvgDwLjJRSI4wiFw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621211; v=1; x=1796226011;
 b=MpcYAwBMgb2H7Pe4FNA7hd/Sg44aTvWFUOeAYlCDzxN3HcodWx/ILDnRLRt3RFQbgREdenF4
 HYl7rcIJfRfu3bqBXe9uDFTKW0gLyWWDkEM2CrxnVxijEw1rlBrByHNFQ8gp5gO3Zpu/gmiI5nI
 RRYsu4IVEMG0wI/nXPJNV+z0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id aa2ea6faef9e16eb;
	Wed, 25 Nov 2026 15:40:10 +0000
X-Mizu-Trace-ID: aa2ea6faef9e16eb
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/20] KVM: arm64: Advertise the GICv3 CPU interface to protected VMs on GICv5
Date: Wed, 25 Nov 2026 15:39:01 +0000
Message-ID: <20261125153911.106793-11-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125153911.106793-1-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
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

A GICv5 host with FEAT_GCIE_LEGACY runs GICv3 guests, but its own
ID_AA64PFR0_EL1.GIC is 0. KVM sets the field to IMP for non-protected
VMs on such a host, but not for protected VMs, which read it from EL2's
copy of the register. The next patch computes a protected vCPU's
fine-grained traps from its ID registers, and with GIC at 0, EL2 would
then inject an UNDEF for the guest's ICC_IGRPEN<n>_EL1 accesses.

Set the field to IMP in EL2's copy as well. The vgic isn't probed yet
when the copy is made, so test the capability the vgic itself tests.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/arm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2753686982f0b..3b4bc646d894a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2819,6 +2819,12 @@ static u64 get_hyp_id_aa64pfr0_el1(void)
 	val |= FIELD_PREP(ID_AA64PFR0_EL1_CSV3,
 			  arm64_get_meltdown_state() == SPECTRE_UNAFFECTED);
 
+	/* A GICv5 host with legacy support gives its guests a GICv3. */
+	if (cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY)) {
+		val &= ~ID_AA64PFR0_EL1_GIC;
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
+	}
+
 	return val;
 }
 
-- 
2.47.3


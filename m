Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808858;
	b=ODakLvQOfQ1QhqcAcN/QQyzdG5XMb0mkcftC/EpqU/oZTmK/F4Oz4COmvBHXRGE8IdVK
	 NpnOVCB+h4MhhMHSwAF/sqcOUAy3nISvSGOyIpVdgh3cvBlhkIyCodMivISZoBRu9h/oq
	 LVDUTwXMkDcTshdeerDgjPuQcTbR5mG/n1JPNFSeV/k1anR1aXhvfkO9knofRSGKfm7ud
	 wJWobpZUabiHXAgx2DAsoffDKkmsI95b+eRDWPFTiPPN6/ywfEbRr4YHXrtE72ZrDTn9I
	 YJ36qwSZuSOMwtTJWxIcqGAv1Oc7QZtq3EmLPcsC3L5vfiu/+9ZePsLJnDaGgLunYEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808858;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=C0AHV3pkmSBlkgkC6bhKAE+fGlVWZxDBcjbwoZIhJvM=;
	b=DZghtY1eWFEGTWZl9vypSDCv+awj3pXl/uBW2/6Hco6tLPNoV00RhXi5QRnhCcr+xubL
	 vnv0TM6jnKtLYpgZJ18wjya6KxVA1ZUXf+TJQoTOF75I3iL0R4JZARqFDa4YidUW7RisN
	 qfO8M62C5e1d7Ys2MYf1OTq3EeUlm/sOse0I5IdRATwNunz40XY5G9CbxvQ66y1A5CuLR
	 bbTzfoWyGempyJFt590xf4uDZBkMlTYtIyA+0iimDYED904/zoUwLbFBmVdf7+iHqmQpm
	 o50atuoZ2/OpDvasnf0MA1Qyucw0MFaKmUhocNyL7zFpYTefK0GEq1PUzGR1z6Ghe4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=T1ViZNAa;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26712606A329
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 06:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26712606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=T1ViZNAa
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-49412eb1474so1389690f8f.3
        for <kvmarm@lists.linux.dev>; Sun, 15 Nov 2026 22:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1794808856; x=1795413656; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C0AHV3pkmSBlkgkC6bhKAE+fGlVWZxDBcjbwoZIhJvM=;
        b=T1ViZNAawDZq/F68Ut8dBb+9tVzg7Jy+6yAc57/OM2jE9bu4soERxLPjj9RhIKl+rS
         oV/uQzQaPejCB3dZWpDNr5lc6TLboZIDLNdXAu2Elaa9+3uZ4xCmirz2o+arowHgBu5i
         /BQS+mu4udW0SBjDoPrgFmL5gvJhwXaQQYPaZk0asycw6xiHzN9C7sbDaWiWtG4HIOMs
         Uov5MrFnlBj5I5G9pWs4Tt3d8ZEp1Ej6lp8G2kPadj8gRu5pJjptYqhhJ1wZouVLTmbc
         FZx3B+SuWLOPFh2TMW2F/bQ+FoxB7OpEU+jLMluqxwBYIbaDToxSvowzoXj6auL7N+J6
         FFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794808856; x=1795413656;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C0AHV3pkmSBlkgkC6bhKAE+fGlVWZxDBcjbwoZIhJvM=;
        b=fJ2EvO+tusMCMSmwuPkmX2N3C9gOHJK9gb0uDmrCbJibgSBkQ9csSoQN6PcK8mOrwO
         yZCguTv7frd/LS3tJuA+7ZFTb9RNztJYzdzp6xYXOnVqf3sXJNu0nxT+r8pSdErdekxM
         dtTmyK0bTTaLW4DpIM43VpOyAujHHHQHReQLBNvbZd9DcmRcgkZCO3N/0Swc3UvKlqx+
         1SYxkFAg6hs+6qkU8Lt0WlK/PdwMd3W7gQjUn/OKYsxqHMuvZezRl6hTqMaeVDPkqcpt
         eV2m3X4+6DiAJDA4Pk0IARonFGr9D3niXEUxBgaRYlu3iSJ+v9mlbJJabclKUY77d4ku
         FiEQ==
X-Forwarded-Encrypted: i=1; AL+hErGKgumy6AgPSs0imNk21t8IZ0fnhysODoHQQPqC2GDvDPsq/AndZjaTr+Y9uAQwoTM7Xs+8JXA=@lists.linux.dev
X-Gm-Message-State: APuU4Z+AD9FYjP8N8wUXrv8Fu4cNBV7k8LRbZuzJp4HAOjZuEa437QbS
	8jGr4DAq2cLNU1T/kDCwkC6/xGtFDMn9pXLPQbGMKMlpPOjoMBAnXqS+codi8LDt9kY=
X-Gm-Gg: AYBFou0idx1TYgaLVNQkjd4E4M4637m+jupkdogfpuvwjgT40++1lQlQQ5do/lgLvp6
	h9L7tYcbj/nKG3VGI4AZDLOizhClgRM457dhQtUyGxXqjQBKdcqrImj4iaocIJhK+N3g1WoMxSx
	HS+ZYfPp2AQ8ia5PWSh++IvVcs6oIi1115f86k8JqWkSBXitvBiFX1CPX8yBiZabtXYClY3z1v3
	S5JJMOBCHoPvRNA7gT74YqwuEwEjidtABoT9gQOp+T2ppxqw/QOFSGr7VeQphO14RR5SVNNLpw8
	8oRJGXS7mKFV//VDLARbn/A9Q7918OEsctHtauuJLc29z7tCoPN9e6bueGac46gW2OkG0q8Pz9N
	tTsNB/04p4nsX5FDNO0B2tImy5XvPpdmCr1mK3gHFnRWiofIcnWZfu4KYbMQvE6fXc7s8dlXiQH
	jy8hFL8yOqOIOGarT6oFk8NVg38V5/ugNkRKqFUAcrNjRNPUgHYLCmK8KA7GRr5oGX/EJD3r0iF
	7B96ZpuuZjBrFQNLsD1uzjEk9fauJmYlAI/wM1g3AS+2KamwQaxHStOPCMgvUIExsLB6hfLlENP
	jb+jzAQElTrGSZhSczo=
X-Received: by 2002:a5d:5849:0:b0:49e:da28:4d40 with SMTP id ffacd0b85a97d-49eda284d6bmr9895900f8f.19.1794808856445;
        Sun, 15 Nov 2026 22:00:56 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5d03b104sm20840076f8f.6.2026.11.15.22.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 22:00:56 -0800 (PST)
Date: Mon, 16 Nov 2026 09:00:52 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jintack Lim <jintack.lim@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH 1/2] KVM: arm64: nv: Fix AT emulation for TCR2_EL1
Message-ID: <eec50693a12e1ba34d60458ae8fe605ac198a79c.1794808373.git.dan@pereq.eu>
References: <cover.1794808373.git.dan@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794808373.git.dan@pereq.eu>

Arm provides an AT instruction that translates a virtual address the way
the MMU would and returns the result.  There is a bug in the way this
instruction is emulated for nested virtualization because of how TCR2_EL1
is handled.  The bug is fairly minor.

The TCR2_EL1 register has bits which turn on permission indirection
(PIE) and permission overlays (POE).  When these bits are set, the AT
instruction reads the permissions stored in PIR_EL1 and POR_EL1.  If
you have the right features and permissions then in the return value from
the AT instruction we set one bit to either 1 or 0 depending on whether
the access would be allowed or whether it would fault.

However, the bug is that just because the host has TCR2 enabled, it
doesn't mean the VM has it.  KVM doesn't load these registers for a VM
which doesn't have the features, instead the AT runs with the host's
HCRX_EL2, which has TCR2En set.  So the AT uses the TCR2_EL1, PIR_EL1 and
POR_EL1 values another VM left on the CPU, or possibly the VMM's POR_EL0.
Likewise, for a VM which has TCR2 but not PIE or POE, the L2's TCR2_EL1
is loaded unmasked.

The impact of this bug is that we leak a single bit of data to the L1,
but in real life it's hard to imagine how it is useful to an attacker.

Fix this by writing zero to TCR2_EL1 when the VM doesn't have TCR2, and
by clearing the PIE and POE bits when the VM doesn't have those
features.  Also it should be effective_tcr2(vcpu, TR_EL10) to read the
TCR2 for the L1 instead of vcpu_read_sys_reg(vcpu, TCR2_EL1).

Fixes: 477e89cabb14 ("KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}")
Fixes: 23e7a34c8397 ("KVM: arm64: Add AT fast-path support for S1PIE")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
 arch/arm64/kvm/at.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 30d8f062b2c2..06765881a4c8 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1438,7 +1438,13 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR_EL1),	SYS_TCR);
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, MAIR_EL1),	SYS_MAIR);
 	if (kvm_has_tcr2(vcpu->kvm)) {
-		write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR2_EL1), SYS_TCR2);
+		u64 tcr2 = effective_tcr2(vcpu, TR_EL10);
+
+		if (!kvm_has_s1pie(vcpu->kvm))
+			tcr2 &= ~TCR2_EL1_PIE;
+		if (!kvm_has_s1poe(vcpu->kvm))
+			tcr2 &= ~(TCR2_EL1_POE | TCR2_EL1_E0POE);
+		write_sysreg_el1(tcr2, SYS_TCR2);
 		if (kvm_has_s1pie(vcpu->kvm)) {
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
@@ -1452,6 +1458,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	__load_stage2(mmu);
 
 skip_mmu_switch:
+	if (cpus_have_final_cap(ARM64_HAS_TCR2) && !kvm_has_tcr2(vcpu->kvm))
+		write_sysreg_el1(0, SYS_TCR2);
+
 	/* Temporarily switch back to guest context */
 	write_sysreg_hcr(vcpu->arch.hcr_el2);
 	isb();
@@ -1554,6 +1563,9 @@ int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		if (!vcpu_el2_e2h_is_set(vcpu))
 			val |= HCR_EL2_NV | HCR_EL2_NV1;
 
+		if (cpus_have_final_cap(ARM64_HAS_TCR2) && !kvm_has_tcr2(vcpu->kvm))
+			write_sysreg_el1(0, SYS_TCR2);
+
 		write_sysreg_hcr(val);
 		isb();
 
-- 
2.53.0


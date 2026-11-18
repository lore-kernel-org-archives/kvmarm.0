Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015814;
	b=OeMDePfFzWofYgObgNOcTjR4dj+N9VlP3NBSAzgK+ZzHBZFEAzIttmObgvAdB3b5YWRL
	 jHhUZvlGzSmgpLVASkM4K6dy7GBqchEbL3iRSlTN0aAZvHt68nJCuKZ1ntX3xV1SoD963
	 /HhY4N0E2oN5oQgbpI9I6HfWTlWKW0KLhQ3uXxyl2T1rHMuNmscrU0JqjSMAjUMp3rx9E
	 NHqYLP2Y19vpS8p/quxN7n1yYvzqOjC7PJko3A34jlUP01Au8ZK68HMxS+kepp/lLFlZ3
	 ivhSrUojyxNx0DHepkabLb9Lry5cv8QAq3YyWU/+EbiX9AUWlHDsfQcTlD5cntCUGhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015814;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=TxCm5SXDQZvehy91cumJ8DrMIrDWTNnrR4NDVBiT94E=;
	b=QJXcA3GTgIvkgzZ4mhoWp3Q/hdJyBa17I4d6JtK371zzG+qeBY+MRVPL6lfqYCxyat1W
	 0cnql7KsWdDAeLOMWwROlB4TaJKTJdRBr1fUDg9yeFAeR5IBA+a5aXIYuasx6JuBqeO8o
	 3eNVP+tavKa42sfvSf92NdyiXgyhsca9K2i1hKeXdTpi3elpS4qm5zbEwgU9zUfgwHYBM
	 9wTd/t/CFi3AACTCzBf0wM34l3EYQsr5j10Uzbx/lBkSg34HXe2Ja2TER1zvm5o8zM+6o
	 /1HClWDR9rSucB3XVFkuuDcuokwnNEUbCJXMH7A1mZZn0gKfnpAoOrgXLwp5th7EoHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=M4KzCHWX;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0103B60A2621
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:30:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0103B60A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=M4KzCHWX
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4d581da0aaso130621366b.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 07:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795015812; x=1795620612; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TxCm5SXDQZvehy91cumJ8DrMIrDWTNnrR4NDVBiT94E=;
        b=M4KzCHWXo+QQ+5rQTjMLOx4L02D5l8iiq7nSXGX9qKLVnSlDDfAGzyA9DYt4QZ03A/
         /QzfLrsmceyiAC1mhpZkwAdpLOGqgBHpJebTt8dLmzvDezIKy20QHLX2kTMEYSEOpKfL
         5vc8NsLBk3Tb9KpcehUISh4tFMxnMT3IZFEvnQQzaOCzIgsm6EzAsPp1FEybQtT1ifJn
         ONrF0sxtDSVZ6Yy1mJAeDC233JIjViswzaiLG/g8cB5v9v7B9nbauMF2HfX5gv2RutHn
         6AGGXmKLj742IStny9QUJraHct0haDXZBxOvdTmn7ade/UoPvzH7MqEST4Oc6bCZHiZO
         2CHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795015812; x=1795620612;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TxCm5SXDQZvehy91cumJ8DrMIrDWTNnrR4NDVBiT94E=;
        b=127/xQ1kHN4KlbFKEp4u4ekIOgf22ximFT2/NzmV1JA5QZFxQt0Ak3YRGls0GCtqs9
         zazAU7sMMWs5tAXhKKJZeai9Q1PaBiHoxcyCbs1M/xOKgSnzv2LUJHFbf/ra148jVc/A
         kPoLgF38QCLHV/dPPia3ZoIo2M5KL8yL59mDS8t3TGykuZ+Mqtx0SZ52R5Hu52Y7UOor
         M0ZPS2Y/FtBMNb399RZA5rFkYYME3s9BdXm9GqcU8H0CV32ZtNcOMBpiSFDsaCct3zkm
         NwUvTiVOyueYuzFVU319y/wIz9uqocEAPud8mUbdfg3GX2KoPMJNvRvnne3BZIFKqdCY
         9fbg==
X-Forwarded-Encrypted: i=1; AL+hErEeA2OcX4kKcrXYDCURd+dWI42nPr/UXsRMS1LIKljpM+6rayMoC4L3Q5xsMxnfkQ/xiBfpYR0=@lists.linux.dev
X-Gm-Message-State: APuU4Z9V/tLwVtjooth3Dk0pcOuvxAV19CkIGEYWnOHUwtFa32wnWTFe
	G66Tk0ndtL7igPP+yBPgk8nOKZXR1YvzJguh8juYNRArSIEInJPHge7AiJRdDS1hOG8=
X-Gm-Gg: AYBFou1VsErc+9q4Bv5pFOnRDXkjunX5u0tuOpaU0K0xidmCYWps1IfqYsPE2K4SNOk
	Y0pKJ4WbOI1EKCLkXcDzXS0+8hehollK56hCEahBpJE8ujm23BuQ7ZLp4bZcLBzqiEagX8rNCSa
	dBSJiT/D9UgrolspXOlGu8jrd6lQIAHjvs/llBKMFONlhs0YvdjBabgiGwNfsi8tZqJNjjjecl7
	7CTqxLsDlf3KgcMefWHU9HSeKNa0GcOU1k97Mmp91+U1e/+IsJYW7+/12xW/d/PPWhrowNvtui/
	o9Vd6HSLKkkZLso1nq1/PmuWhCDsdsvU5MuewXGxODace9vHZRIC/ng116shzIgIkEP2qm8AFBB
	UY1V1rpcPiSSlutbxDgn9J/HDZz9tBpo+fO2UMe0lcDHDJ2Lr4Oe0rwtjRWpVKu4kt8aIgkQT7w
	Mdel9KW1QZCazTYwW5R/PzEAxUD7RI0m9TIDkBS9CmK5kjDX2HyyATWfvcPrhbHJv05vUTsnM88
	FoSGG7Df7JFFOcm4Y+xQQ96boyEaOlgZZ1afrHOPPm5Z7/pQAITxL2XqX/pgXMTEwnw8ztaxOCg
	cpdAf/jLrVUz9aU4YAs=
X-Received: by 2002:a17:907:9304:b0:c4d:212a:192a with SMTP id a640c23a62f3a-c510e520f80mr286242666b.48.1795015812157;
        Wed, 18 Nov 2026 07:30:12 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c51233c4d02sm11652266b.21.2026.11.18.07.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:30:11 -0800 (PST)
Date: Wed, 18 Nov 2026 18:30:08 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH 3/3] KVM: arm64: nv: Report EL2 registers with no trap
 forwarding
Message-ID: <5a7235e9adff42aa043ac9473dbeb0354dca0967.1795014776.git.dan@pereq.eu>
References: <cover.1795014776.git.dan@pereq.eu>
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
In-Reply-To: <cover.1795014776.git.dan@pereq.eu>

One of the recurring issues we run into is that people add a trap to
KVM but they forget to add a matching trap for nested virtualization.
Add a boot time warning to print a warning for missing traps.

Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/emulate-nested.c   |  5 ++++-
 arch/arm64/kvm/sys_regs.c         | 23 +++++++++++++++++++++--
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8efb21b2d729..0614c3b3a40d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1379,7 +1379,7 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 int __init kvm_sys_reg_table_init(void);
 struct sys_reg_desc;
 int __init populate_sysreg_config(const struct sys_reg_desc *sr,
-				  unsigned int idx);
+				  unsigned int idx, bool needs_nv_trap);
 int __init populate_nv_trap_config(void);
 
 void kvm_calculate_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 9e0c15e6be47..39136a89d74b 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2434,7 +2434,7 @@ int __init populate_nv_trap_config(void)
 }
 
 int __init populate_sysreg_config(const struct sys_reg_desc *sr,
-				  unsigned int idx)
+				  unsigned int idx, bool needs_nv_trap)
 {
 	union trap_config tc;
 	u32 encoding;
@@ -2452,6 +2452,9 @@ int __init populate_sysreg_config(const struct sys_reg_desc *sr,
 	encoding = sys_reg(sr->Op0, sr->Op1, sr->CRn, sr->CRm, sr->Op2);
 	tc = get_trap_config(encoding);
 
+	if (needs_nv_trap && !tc.val)
+		kvm_err("sysreg %s has no NV trap configuration\n", sr->name);
+
 	if (tc.sri) {
 		kvm_err("sysreg %s (%d) duplicate entry (%d)\n",
 			sr->name, idx - 1, tc.sri);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ef4554656ddf..afd7e76bedff 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5978,6 +5978,23 @@ int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+/* Keep the nested virtualization traps in sync with the KVM traps. */
+static bool __init needs_nv_trap(const struct sys_reg_desc *r)
+{
+	/* op1 4 is the EL2 encodings, op1 5 the _EL12 and _EL02 aliases */
+	if (r->Op1 != 4 && r->Op1 != 5)
+		return false;
+
+	if (!r->access ||
+	    r->access == bad_vncr_trap ||
+	    r->access == trap_raz_wi ||
+	    r->access == bad_redir_trap ||
+	    r->access == undef_access)
+		return false;
+
+	return true;
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
 	const struct sys_reg_desc *gicv3_regs, *gicv5_regs;
@@ -6010,10 +6027,12 @@ int __init kvm_sys_reg_table_init(void)
 	check_feature_map();
 
 	for (i = 0; !ret && i < ARRAY_SIZE(sys_reg_descs); i++)
-		ret = populate_sysreg_config(sys_reg_descs + i, i);
+		ret = populate_sysreg_config(sys_reg_descs + i, i,
+					     needs_nv_trap(sys_reg_descs + i));
 
 	for (i = 0; !ret && i < ARRAY_SIZE(sys_insn_descs); i++)
-		ret = populate_sysreg_config(sys_insn_descs + i, i);
+		ret = populate_sysreg_config(sys_insn_descs + i, i,
+					     needs_nv_trap(sys_insn_descs + i));
 
 	return ret;
 }
-- 
2.53.0


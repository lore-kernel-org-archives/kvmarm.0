Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114365;
	b=Zw7z8oymDgY0FQyPHbkvlOHVnQf3lqAh2v+09BeCw+MhW0Nhkn6z+gmyKlSmDFmOObur
	 IQ7gzS6XvCsV/4iFOD6VhlNEIkUMPuYn2FjVi87nMJ2E8an98YBRuya7cj/y+5RWBscUJ
	 +jV7/jfyzf/CUA+o9PDCysMlNjKDKPlJSrYuoOgvom+jl/BooET8ICIj+mcAcOlrj59+d
	 EYljg+xGLEuVXkANIE3jjXk0A2LuTAi9MCVZ2nk8Z/EOUF7cu7+WDPYs8v77dBH+T3YcW
	 DBJW3j+jF2yVgEZYU30ct5fKsTnH1QAlH6gMUPyF/kV1NNI6nOpbJpo6OG8Jab0xN1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114365;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=AHJ6vsYYQy4ZksSL7GxZoPUPCozguL3MZwWjlTE9XOs=;
	b=q9WOqQ+m1Lc/0NmLHrAMuRqvAPPCKvmqfIb2Hh/t1+J9Ysq66IQFz/Z/jLf8PgK8f2DB
	 cWWpfetXi+jWUi3SUvx2+ug5bqXmsHnA1M4w/pYJFCFOQeqRoz8YHyQw706UJBd9xD/st
	 FR+/gx2vmvaNONuMVBk68RvcrjmoRgLt/rdcRg/jlqnez7V5IbFoD8rJWRRqmAzNK0lhd
	 gKB2XMvLBOJmZrb4OurwWvJj0LqtTXgZO8qt5H6TY5ozPj1Xwy4+/sp5WibWtAy4Li4Zb
	 P1ao2AnPeukmlqmWc7z4WC9U+VyivF+XWS2Cp7NedebvFlzGtl0qNXQRbeDrak5T/pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Q8e6Breo;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D74B6072305
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D74B6072305
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Q8e6Breo
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-5727b04b81eso94079b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114364; x=1795719164; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AHJ6vsYYQy4ZksSL7GxZoPUPCozguL3MZwWjlTE9XOs=;
        b=Q8e6BreoA+OlUdmfMd7T60fJrLcZ4g/gEBNFlq/HCfNULpZn7pUPppAtambCtP6ble
         dMiTw/cOI9CwcYSBBproGSdi8O2BSS6Xv2vJnJ33ic6vXOKC160qeOKkPZFd0vO2O7uQ
         d3cj8AD7yagoE7m6rLUMdyamcutcJ6MhNPujkqBXq0qPwwutI4iEkEdeOFCnGyn+sGQm
         NrqomdQBG5cCjIp8yJxlm2ihlpdcco3jiGCx1Xl4JSzlKbWf7buTEAn0ETLLS1OpQb9/
         AczRqIcfeF0LE7VWFEw7DugT/tg1xWDlyvgXx70IN/fcIYNluLqQJHGN4xgQxVYrVQ5P
         43Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114364; x=1795719164;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AHJ6vsYYQy4ZksSL7GxZoPUPCozguL3MZwWjlTE9XOs=;
        b=Rfucc6CHGE++DssNwC4Toj2eU+Up0fLte+yKGW2IKYJz2Dg9OzN1OmkI84InnCjlwM
         P4MWu4Bg7TxYhfE8Tbto0Db1g6zSuidokJ+Vl8xg6BNXXjeNN5pvwKMZfdK/JSICR+tR
         x5vAIvRv5ZOpdYuN+vxFZRYl5jo38UquU46pHW12A6eS+xGK0V3fMENLw6YdHsK36g+Z
         R3ZQEa8zy6m7o0yArXus1a/vvDlCg0eRbroJWpmQWPXJwYxN+cmVrW6dvjSoHhy7Xp7t
         +bkIkxUD9HPbiKUB3hZ7Mgm8H3ZaqWXSpFI2BdSFRBj9trL7FRwHgryHODuXs/NPNxRY
         4b0w==
X-Forwarded-Encrypted: i=1; AL+hErHg0ltNPATxmgDP5tX2l+K/syhxgnEuX8BtGoB/A9Xzx6mtWnqlkpHoMoBcLV9acyZCFvuFNkw=@lists.linux.dev
X-Gm-Message-State: APuU4Z/kXRnAUiCQfYl4kHQksIHM62u44KmJt4rSg5zvZlbnopi/huxC
	jcjWOWxmF64Pn843d9pohUA4KtJG+9DZtNWx5A9X6fKoyCkavG1r9ZB1BwZH/qsbigJdg2sC8FY
	6AGKcnvFlyqZHrqbnOrrtV0tcZA==
X-Received: from iobi29-n2.prod.google.com ([2002:a05:6602:c69d:20b0:9c7:67b2:21c8])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:67c7:b0:4f5:98d:d1ae with SMTP id 5614622812f47-57a0bb8d52cmr963272b6e.55.1795114364230;
 Thu, 19 Nov 2026 10:52:44 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:11 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-30-coltonlewis@google.com>
Subject: [PATCH v10 29/33] KVM: arm64: Forward FGT traps for PMXEVTYPER_EL0
 and PMXEVCNTR_EL0
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When an L1 hypervisor runs a nested L2 guest with a Partitioned PMU
(vMDCR_EL2.TPM == 0), L1 relies on fine-grained traps in HDFGRTR_EL2 and
HDFGWTR_EL2 (PMEVTYPERn_EL0, PMCCFILTR_EL0, and PMEVCNTRn_EL0) rather
than coarse-grained MDCR_EL2.TPM traps.

Add SYS_PMXEVTYPER_EL0 and SYS_PMXEVCNTR_EL0 to encoding_to_fgt[] in
arch/arm64/kvm/emulate-nested.c so L0 forwards fine-grained traps on
selector-indexed PMU accesses to L1, using PMSELR_SEL to check
HDFG{R,W}TR_EL2.PMCCFILTR_EL0 when PMSELR_EL0.SEL == 31 and
HDFG{R,W}TR_EL2.PMEVTYPERn_EL0 otherwise.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/emulate-nested.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 1cd2f42452fe7..9da7e98b4d18f 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1319,6 +1319,7 @@ static DEFINE_XARRAY(sr_forward_xa);
 enum fg_filter_id {
 	__NO_FGF__,
 	HCRX_FGTnXS,
+	PMSELR_SEL,
 
 	/* Must be last */
 	__NR_FG_FILTER_IDS__
@@ -1870,6 +1871,8 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_PMCNTENSET_EL0, 	HDFGRTR, PMCNTEN, 1),
 	SR_FGT(SYS_PMCCNTR_EL0, 	HDFGRTR, PMCCNTR_EL0, 1),
 	SR_FGT(SYS_PMCCFILTR_EL0, 	HDFGRTR, PMCCFILTR_EL0, 1),
+	SR_FGF(SYS_PMXEVTYPER_EL0,	HDFGRTR, PMEVTYPERn_EL0, 1, PMSELR_SEL),
+	SR_FGT(SYS_PMXEVCNTR_EL0,	HDFGRTR, PMEVCNTRn_EL0, 1),
 	SR_FGT_RANGE(SYS_PMEVTYPERn_EL0(0),
 		     SYS_PMEVTYPERn_EL0(30),
 		     HDFGRTR, PMEVTYPERn_EL0, 1),
@@ -2609,6 +2612,16 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 
 	case HDFGRTR_GROUP:
 		fgtreg = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
+		switch (tc.fgf) {
+		case __NO_FGF__:
+			break;
+
+		case PMSELR_SEL:
+			if (SYS_FIELD_GET(PMSELR_EL0, SEL,
+					  kvm_pmu_get_pmselr(vcpu)) == 31)
+				tc.bit = HDFGRTR_EL2_PMCCFILTR_EL0_SHIFT;
+			break;
+		}
 		break;
 
 	case HAFGRTR_GROUP:
-- 
2.56.1.708.g77570a6a1d-goog


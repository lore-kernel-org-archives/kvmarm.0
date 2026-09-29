Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2E63AFAEF
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 09:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672463; cv=none; b=cpZatUaNU7fhkKN8eioM5ueUkQhCdMdRWOvpnGhevMjFpnVDnAmaqBtYmDS5AkgsGr9uf+uH2k+9+WDYxWGGvUDEL/6e+lzAnYExK1bQaS2lhQ4kmnI/tq+w0W1FTahjMGsXt2515g/P8omjXZPHA7PHYEn/wyhqO5XmAD4FEX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672463; c=relaxed/simple;
	bh=Xy7APjAm9vxgY3BoNnyG8EPgyVpnG+Ucz22DNIrqlo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FegU8Jw3lxKLEcxt4tZQRn5xOcm3y8paH5VBx0Vr84ismkDxa8QD7AFDBmKnYTg4SJwIqLGv/IwPVWrHFhQiAs8Eclj1oa33K1w5TPjA15xIPy1SNcDexiBozvmUWLx73/XFtIqZ3jZ7qbTEdRZzHm2LUo24ji8T6GciQIZCidU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eYW4Oymu; arc=none smtp.client-ip=95.215.58.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eYW4Oymu"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Xy7APjAm9vxgY3BoNnyG8EPgyVpnG+Ucz22DNIrqlo4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790672460; v=1; x=1791277260;
 b=eYW4OymuypD3EfH8n9Dph3mgF4IIc7BivWckm2/I2/tNTJND7/3WL8lBuXXr4LTsGLg32ZXE
 RQCEFzV40GJX3Z/vCyo2NMvjV/4dgVAjSHrFacvNapV+W+860mQMhYvg2CaJFqlH/7AtjfuuyEj
 kUtvNA2aT1K0o5mFlgaxxwVQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 939f88d67d5e6d8b;
	Tue, 29 Sep 2026 09:00:59 +0000
X-Mizu-Trace-ID: 939f88d67d5e6d8b
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
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] KVM: arm64: Apply the fine-grained UNDEFs without FEAT_FGT
Date: Tue, 29 Sep 2026 10:00:28 +0100
Message-Id: <20260929090031.3829185-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260929090031.3829185-1-fuad.tabba@linux.dev>
References: <20260929090031.3829185-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

triage_sysreg_trap() applies the FGU bits through the encoding's FGT
entry in the trap xarray, and populate_nv_trap_config() only adds those
entries on a CPU with FEAT_FGT. Without it, a hidden feature that still
traps reaches its handler instead: a TLBI OS trapped through
HCR_EL2.TTLBOS lands in handle_tlbi_el1(), which expects an EL1 TLBI
only from vEL2 and WARNs before the guest gets its UNDEF. A VMM can
trigger the WARN by hiding TLBI OS and having the guest execute one.

kvm_calculate_traps() computes the FGU bits with or without FEAT_FGT,
and the entries map an encoding to its FGT bit whatever the CPU
implements. Add them unconditionally, so that a hidden feature that
traps is UNDEFINED on any CPU.

Fixes: f5a5a406b4b8b ("KVM: arm64: Propagate and handle Fine-Grained UNDEF bits")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    For a nested guest on a CPU without FGT, check_fgt_bit() now runs too,
    but it forwards nothing: a guest without FEAT_FGT has its FGT registers
    RES0.
    
    f5a5a406b4b8b added the FGU check to triage_sysreg_trap() behind an
    ARM64_HAS_FGT gate that populate_nv_trap_config() already had, so the
    check never fired without FGT.

 arch/arm64/kvm/emulate-nested.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 625604019fb32..b8529532b6e78 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2386,9 +2386,6 @@ int __init populate_nv_trap_config(void)
 				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
 			}
 
-			if (!cpus_have_final_cap(ARM64_HAS_FGT))
-				continue;
-
 			prev = xa_store(&sr_forward_xa, enc,
 					xa_mk_value(tc.val), GFP_KERNEL);
 
-- 
2.39.5


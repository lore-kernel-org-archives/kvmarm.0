Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2FE4A2A45
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999478; cv=none; b=EeXIfwLjrSzMoaKq1KB5aIzgdxiVkGPX8d99TCTAj8NfV1am+waYKKBlfRuAKRfkvt0jNdSO6Cbk5GyQrOu1uyOuHIFIiZD3T6KaFEM+M2cT4vKxyN9m3q81PZMc2Kz/YYQpaTJyzmJ3dM6X9yQA2ZfjEPTt0CDfJv7pwyxJPi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999478; c=relaxed/simple;
	bh=DEbyYnw/QNFLD6hov3Wk8Emu00bFpjJHBWq6l30twn8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EyYbEIM2fF1+KePJbkyMandfcBMPDQhKQHwtNaMUNEeso+ToNxs7f9Onz4UCoGiGNjoCRJMdbhefz5A7XLHynHAiyM4fJ3oS1rdpJrbv7VbOci+dQo82Uz2VBGvJspLDV6LWTOkm+WU70eY14eTmJGe7PYgUfwrkbnoUVw7UUrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DeA0SiAV; arc=none smtp.client-ip=91.218.175.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DeA0SiAV"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=DEbyYnw/QNFLD6hov3Wk8Emu00bFpjJHBWq6l30twn8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789999474; v=1; x=1790604274;
 b=DeA0SiAVyCbwA7WhbXf8p5FFtA1y9BGn+/at6/dcBj2TouLzRqimrd+JiZ9IpWw9i28ru18l
 Wvh3EotSdIL7vKByViObc7FL8CeaKxRWxMqAfzHKYtQIq6FEOURtCSE3EEdQu58i4T0q38I4BTy
 Fda4x2vD+FbwbbR2m4svxk3s=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a77cef6fbb8dcc1e;
	Mon, 21 Sep 2026 14:04:34 +0000
X-Mizu-Trace-ID: a77cef6fbb8dcc1e
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/3] KVM: arm64: nv: Read a guest hypervisor's CNTV_CVAL_EL0 from memory on x1e
Date: Mon, 21 Sep 2026 15:04:26 +0100
Message-Id: <20260921140427.2211373-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921140427.2211373-1-fuad.tabba@linux.dev>
References: <20260921140427.2211373-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On x1e KVM keeps CNTVOFF_EL2 at zero, traps the virtual timer whenever
it has an offset and programs the hardware with the offset applied.
kvm_hyp_handle_timer() returns that hardware value for a VHE guest
hypervisor's read of its own CNTV_CVAL_EL0, instead of the CVAL it
wrote. Its writes trap to the kernel and land in CNTHV_CVAL_EL2, so
return that, as the physical timer's read does without CNTPOFF_EL2.

Fixes: 0bc9a9e85fcf ("KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 14aada311bac4..4c965f9b1e1de 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -322,10 +322,14 @@ static bool kvm_hyp_handle_timer(struct kvm_vcpu *vcpu, u64 *exit_code)
 		val = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
 		break;
 	case SYS_CNTV_CVAL_EL0:
-		if (vcpu_el2_e2h_is_set(vcpu))
-			val = read_sysreg_el0(SYS_CNTV_CVAL);
-		else
+		if (vcpu_el2_e2h_is_set(vcpu)) {
+			if (has_broken_cntvoff() && timer_get_offset(vcpu_hvtimer(vcpu)))
+				val = __vcpu_sys_reg(vcpu, CNTHV_CVAL_EL2);
+			else
+				val = read_sysreg_el0(SYS_CNTV_CVAL);
+		} else {
 			val = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
+		}
 		break;
 	case SYS_CNTVCT_EL0:
 	case SYS_CNTVCTSS_EL0:
-- 
2.39.5


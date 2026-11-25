Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621169;
	b=AZCleGdDOaMi6pfdmKBd+NB38znKericaP0dNoqffZJ+rlOz3T82LJLrthgksJ8807Kx
	 YJcsMS2NZ9JWg2x3Tte5Y+YEla6rTv5R/DNhOoTTJrJK9ph3w0xaS8qrTgR90ucqMMv5a
	 U78JNc86fhfgj/SVQA4xzbNOU3/v55S0dbydb9MLbMAPu9kw75BhoLaoWbSQLzlnGk3zr
	 ZilWSGnVm4Vw5ObaqWhCXW2MXugqOeLHEwt6yMNBwYeIQdW06Jf+7Iz4eKi/7+w6nZEar
	 0MY+qqHf1wHW9mnW4GrRNTmrCrIu23uf2xlYjDeFDa6TguHUj9s4JbrMVm9LlBbghzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621169;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k3lgUkbhF48x9uWXDW9CSm5otQP2vPMMqrsbaam6pJk=;
	b=mpdYtk9jtzgbMblU0ThQqeAUG/xry+STFFiSOIkEdggnjQwJDX4q9iV43e1r3BQlo896
	 gwlkVIvBmIVn+WzdkKGpf1imEx2aofXs94K0vFr2m5ocWirT0B0pKPUsvQ/hjhH6wgWHF
	 V4yF48erVeHKYFdYDVQcMOlgwNlUivyeLN21zRgWabs12bIzhj/bFPzvlxg/fUD7dmjdG
	 xHWASbKERGP2/eeqdS0SBRC1oyQQiXtuGIQP2LDANv4cks3SB51SywUrRGSjGCE/MF2Ot
	 CtrlRQKRbN0M0ZzzBqK8pDLCwcuir+Qh8lR7rosh7jLaBGNv/riI5Ly0g8TWAZN6ACg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Gy2It9DC;
	arc=none smtp.remote-ip=91.218.175.108
Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6780606A690
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:39:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6780606A690
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Gy2It9DC
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=IZNUpS1OAqWftHWv01wPPqIUYNpQ1VNp0oAA/VL5VMQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621165; v=1; x=1796225965;
 b=Gy2It9DClKQWo8n+IIMff39GHjaO5XGBYXV/jpSFZRrGhm6Ngo4zulUq1stBLWzaW6o4ert9
 iGYWyhUx79ej+IGopgjxsd590VtpXZ5puU83lQog5v/O9cW7wuTptN5QWDrsUQh4k7lp84lXWrK
 VWPK4OghDtIgd9ssUD5kefJU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7efd5e36bdff3cdc;
	Wed, 25 Nov 2026 15:39:25 +0000
X-Mizu-Trace-ID: 7efd5e36bdff3cdc
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
Subject: [PATCH v2 04/20] KVM: arm64: Remove redundant kern_hyp_va() calls from the pKVM FP sync
Date: Wed, 25 Nov 2026 15:38:55 +0000
Message-ID: <20261125153911.106793-5-fuad.tabba@linux.dev>
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

With pKVM, EL2 saves FP and SVE state through the hyp vCPU, whose kvm
is the hyp VM's and whose sve_state is already a hyp address.
kern_hyp_va() returns both unchanged.

Remove the calls in fpsimd_sve_sync() and __hyp_sve_save_guest(), and
the one in kvm_hyp_save_fpsimd_host(), which only pKVM reaches. The
ones in __hyp_sve_restore_guest() and kvm_hyp_handle_fpsimd() stay, as
nVHE without pKVM reaches them with the host's pointers.

No functional change intended.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e0c55644224cb..ee85a8bc4d798 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -594,7 +594,7 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 		fpsimd_save_state(&hctxt->fp_regs);
 	}
 
-	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm)))
+	if (kvm_has_fpmr(vcpu->kvm))
 		ctxt_sys_reg(hctxt, FPMR) = read_sysreg_s(SYS_FPMR);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9958ca6d7b0a2..57c3f7a2d4b14 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -482,7 +482,7 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
 	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	sve_save_state(kern_hyp_va(vcpu->arch.sve_state), true);
+	sve_save_state(vcpu->arch.sve_state, true);
 	fpsimd_save_common(&vcpu->arch.ctxt.fp_regs);
 	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
 }
@@ -531,7 +531,7 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	else
 		fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
 
-	has_fpmr = kvm_has_fpmr(kern_hyp_va(vcpu->kvm));
+	has_fpmr = kvm_has_fpmr(vcpu->kvm);
 	if (has_fpmr)
 		__vcpu_assign_sys_reg(vcpu, FPMR, read_sysreg_s(SYS_FPMR));
 
-- 
2.47.3


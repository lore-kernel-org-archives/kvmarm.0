Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794557982;
	b=1FQse+xa9YBpzlJhuHG3CBnW0EQY7vFM491/HOFPVeh0kv3Wc9aISJsoWB7W77zqd7P4
	 MedOQqExsHRauigelYh6kIUkHy5RSvro6SRBzBowwnL/8rvhtzo60Z/Cb+TSnnIsx3tTm
	 tbJQFZ36cWqSRlUutydNCof9Q2V0yS6F1bQ2PvqMs04thqqRftHBYVbpLdb8YAeGWgbzt
	 P4gtNhjaPv5xH/7jyJX9mYdbNa0ZF/pKlBaegbMZhlMX7wHKqt+AdrftHzyqf5ud24AHw
	 lzrEs75YWmjtAm2FfPyb+VXi9rNxEFa3zoRHP+0G1OHjVFGYAQ2BjRzq65ayM7T9bLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794557982;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wAS3oQHuzL7ajnzxXYWPyyMndbqhHMc9tInB7WPJ4ZM=;
	b=Jt3h3Jgw/1d686Nxfzx6QRRxA2J+nO8aUvdSdQk598iMOihuLhl8Ua//elj1DvS8Kawp
	 VMSPdK2TX9kJ1huPaxjn2+su8+UxAcVRcf4L1SJH4ytcdEML+IIHdQaiZvUqkkyUR4JKD
	 TB9mL2OVcc17T8iou1EDqhXH9m3ApoePNa2znOCmFMSIIPtnC22asCw5vGmpHd2oaF9tZ
	 zi2rd4oUpF304+n/qrrlxZGqO2jHG74S76gFq9Wj+p8idXwSRNAyycjP4qIOqNsd7dGK+
	 YHbmkOt11oBeLvuvYUXwK8WcIcMapHB8RBy/vINOmZwpH/Vf0OPZWQABxeixcUvYM8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="gLzP/gbA";
	arc=none smtp.remote-ip=95.215.58.74
Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94100606A327
	for <kvmarm@lists.linux.dev>; Fri, 13 Nov 2026 08:19:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94100606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gLzP/gbA
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LM1ni5prrsjlOdbw8JePvasxWgCV5AgG25++/phTO84=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794557979; v=1; x=1795162779;
 b=gLzP/gbAqb1l1eiwC/6XqzzTKGKP1KEgSdHp0/ClapYbYixi6AZamfD+RIhm3tGdbeIYRUOX
 wg/n0eHKkQeJ8N8WtPwNVuijZOPfZDmHsytLqMx8keGN3HZrWIzl1TB47rgSLfq4GZqNo2ae/jz
 U89IKEHAx0t0UYQyv13pM/kc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 143baa0b577e5982;
	Fri, 13 Nov 2026 08:19:39 +0000
X-Mizu-Trace-ID: 143baa0b577e5982
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	ryan.roberts@arm.com,
	qperret@google.com,
	steven.price@arm.com,
	tabba@google.com
Subject: [PATCH] KVM: arm64: Keep firmware Spectre-v4 mitigation on for protected guests
Date: Fri, 13 Nov 2026 08:19:34 +0000
Message-ID: <20261113081934.1715497-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
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

EL2 handles a protected guest's ARM_SMCCC_ARCH_WORKAROUND_2 discovery
query from the host's Spectre-v4 state at init. If the system is
mitigated and the guest doesn't have SSBS, it returns NOT_REQUIRED,
which means that firmware mitigation is permanently enabled. However,
the host can disable the mitigation before running a protected vCPU,
with an ARM_SMCCC_ARCH_WORKAROUND_2 call that EL2 forwards to the
firmware.

The host makes that call for its own userspace, so keep forwarding it,
without hints so that the firmware decodes it as EL2 does. Track it per
CPU, and on a mitigated system enable the mitigation again before
running a protected vCPU on a CPU where the host has disabled it.
Firmware enables it when a CPU powers up, so the tracked state isn't
reset on CPU_ON or resume.

Fixes: fe40ff87ead5c ("KVM: arm64: Implement HVC handling for protected guests at EL2")
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/all/5fa8a1fb-4e2c-4746-8a70-a47f387ef0d6@arm.com/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Tested on QEMU with TF-A. Upstream TF-A implements the dynamic
    workaround only for Cortex-A76, so I patched it to advertise the
    workaround on the Cortex-A57 that QEMU models. With a host that
    disables the mitigation before running a protected vCPU, TF-A gets the
    call to enable it again from EL2 with this patch, and doesn't without
    it. TF-A's handler for the call does nothing there and QEMU doesn't
    model the mitigation, so this tests the calls and not their effect.
    
    Calling the firmware before every protected vCPU run would do without
    the tracking, at the cost of an SMC per run.
    
    Based on Linux 7.4-rc2 (7475ea8b58616).

 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 179d7c8277b88..081a8780fa3b7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -21,6 +21,7 @@
 #include <asm/kvm_mmu.h>
 
 #include <nvhe/alloc.h>
+#include <nvhe/arm-smccc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -30,6 +31,8 @@
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
+static DEFINE_PER_CPU(bool, host_ssbd_disabled);
+
 /*
  * Define a hypercall handler: handle_<name> unmarshals the arguments from
  * the host context and hands them, correctly typed, to the body that
@@ -940,6 +943,17 @@ DEFINE_KVM_HOST_HCALL(int, __kvm_vcpu_run, struct kvm_vcpu __kern *, vcpu)
 			return ret;
 		}
 
+		/*
+		 * Firmware Spectre-v4 mitigation can be advertised to a
+		 * protected guest as permanent. The host kernel runs with it
+		 * enabled, so nothing is restored on exit.
+		 */
+		if (pkvm_hyp_vcpu_is_protected(hyp_vcpu) && spectre_v4_state == SPECTRE_MITIGATED &&
+		    __this_cpu_read(host_ssbd_disabled)) {
+			hyp_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, true, NULL);
+			__this_cpu_write(host_ssbd_disabled, false);
+		}
+
 		flush_hyp_vcpu(hyp_vcpu);
 
 		ret = __kvm_vcpu_run(&hyp_vcpu->vcpu);
@@ -1671,6 +1685,12 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 		goto exit_skip_instr;
 	}
 
+	if (func_id == ARM_SMCCC_ARCH_WORKAROUND_2) {
+		/* Drop the hints, so that the firmware decodes the ID as EL2 did. */
+		cpu_reg(host_ctxt, 0) = func_id;
+		__this_cpu_write(host_ssbd_disabled, !lower_32_bits(cpu_reg(host_ctxt, 1)));
+	}
+
 	handled = kvm_host_psci_handler(host_ctxt, func_id);
 	if (!handled)
 		handled = kvm_host_ffa_handler(host_ctxt, func_id);

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.47.3


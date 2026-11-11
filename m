Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794385669;
	b=IFb6cBsYv/4YwmMSNDrN8C3YW/Du9hE6Or9oQaAC2KKJIN7ymJyCOIAfdHp6ofuX5q+8
	 I8UXGsYcGF871k9dtvJELeCk5J9RyD+7M1pgtH/KIETPqYLuqcXZUr5wf4mYfyNvznJ/n
	 +bO2A8klqsWj21ujZjj98dAS+wQ0gg6Nqzij1fCeXEVdkyRFI3EhxIohzNzpyqsaYOz9+
	 jnIs15JgQJ4lNUpLTKQMFAAwpggeMFAMawxJ2c00gYD7q29TwHzJRUB+dp+FG419aKWOu
	 UYWUFLpF/bkopJNpV8DqiFn7JJs4jjZGgGFXOpqMNRQz1e9sEXPZOz+iuQbUnTA4fyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794385669;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=N91MbDTn6PrZLQH4j0EMDImQVrWd5RIhvpEq9PwZqyU=;
	b=iU9afVpVR15QXCcy8+z62nLNxPHtZodRibFpKIXfGxtnAZO0E6NE5P3dlUJ/tIzCVJk2
	 wFAVhFsGgVB24SLtZbvJdNBfLqzxUxwuInXaFKL5jjUXefK5B66MmY9G0B7BcASsf0bQm
	 1nG4dSHBpj1ZexADBYY6CyMR4Xrofv5f99Uv0K0TvkTZrHQQnxYNDHq6LBwMH7r1fkd5p
	 IkWBZR2SfOXz9fOrXqyKBWY1ZFOq/m43EnHRswmgQVSEHXDydIepKEJ2Lcxhw/GLrQ4th
	 S0yCYDzVQ4AP7OSky0bHDw5lZUGk6zq5PEAQxUIjXjSSNl+58LcXicNHwYyL2bSY9EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fUpnCIrZ;
	arc=none smtp.remote-ip=95.215.58.209
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83B660A2621
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 08:27:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E83B660A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fUpnCIrZ
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=o5IReJ970IqTd3Q+Wne7cEMsCpUkcKmOzJbHBxuzgfo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794385667; v=1; x=1794990467;
 b=fUpnCIrZd23Io7qMIYZ6W9iazjztqKF2N73IFzTIBAt40sA91DmxYkB16ZxQWGDpu0lLYp3f
 EQMemSIcrVbY3zJolfqBxv0N3/Baza7+YU0yucIBL22zL/YU7J1B2KBRnE5LbhNm101vNbi2dzW
 HVT0jXXk/HQ+gMuK6nmYNCSc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8550fa73e993f6e8;
	Wed, 11 Nov 2026 08:27:46 +0000
X-Mizu-Trace-ID: 8550fa73e993f6e8
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH] KVM: arm64: Sync SCTLR_EL1 before a pVM's CPU_ON reads its endianness
Date: Wed, 11 Nov 2026 08:27:46 +0000
Message-ID: <20261111082746.1064567-1-fuad.tabba@linux.dev>
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

pKVM handles a protected guest's PSCI CPU_ON at EL2 before the guest's
EL1 sysregs are saved, so kvm_vcpu_is_be() reads a stale SCTLR_EL1. A
guest that changes SCTLR_EL1.EE and calls CPU_ON before its next exit
to the host starts the target vCPU with the old endianness.

Sync SCTLR_EL1 before the read, as inject_sync64() does.

Fixes: 9d4ec80be2eb4 ("KVM: arm64: Handle PSCI calls for protected VMs at EL2")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    inject_sync64() is the only other reader on a protected guest's exit
    path of a guest-writable EL1 sysreg's copy, and it syncs that register
    first. Saving SCTLR_EL1 before the in-loop exit handlers instead would
    put the save on every protected exit for two readers. A non-protected
    guest's CPU_ON is handled by the host, after the sysregs are saved.

 arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fc0475f0877d1..e421f45383e0d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1321,6 +1321,9 @@ static bool pvm_psci_vcpu_on(struct pkvm_hyp_vcpu *hyp_vcpu)
 		goto error;
 	}
 
+	/* Sync SCTLR_EL1 for kvm_vcpu_is_be(), as HVCs are handled before sysregs are resync'ed. */
+	__vcpu_assign_sys_reg(&hyp_vcpu->vcpu, SCTLR_EL1, read_sysreg_el1(SYS_SCTLR));
+
 	reset_state = &target->vcpu.arch.reset_state;
 	WRITE_ONCE(reset_state->pc, smccc_get_arg2(&hyp_vcpu->vcpu));
 	WRITE_ONCE(reset_state->r0, smccc_get_arg3(&hyp_vcpu->vcpu));

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.47.3


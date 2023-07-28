Received: from out-121.mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD0A179
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 00:08:35 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690502913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=t85v93eDPiEQbd43lSBgju/n0allvEigQSUxRkBWXsU=;
	b=Xsof3DZ0tDSwzWh4jJdnxNsm7wmWHjlNAvNz0ByZ28KL+7BC+AVhuXwIgL39hDG9xVzLjl
	2Q6YskTtghR9j6DFGjo0H8K7EV1FoIq3qTItPwF4Z5ToWbLEVFrPgYrdRecF0ftpASyf/C
	KCP8gvdlAc3l8nD5UvRaLVatd/w3ICA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Skip instruction after emulating write to TCR_EL1
Date: Fri, 28 Jul 2023 00:08:24 +0000
Message-ID: <20230728000824.3848025-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Whelp, this is embarrassing. Since commit 082fdfd13841 ("KVM: arm64:
Prevent guests from enabling HA/HD on Ampere1") KVM traps writes to
TCR_EL1 on AmpereOne to work around an erratum in the unadvertised
HAFDBS implementation, preventing the guest from enabling the feature.
Unfortunately, I failed virtualization 101 when working on that change,
and forgot to advance PC after instruction emulation.

Do the right thing and skip the MSR instruction after emulating the
write.

Fixes: 082fdfd13841 ("KVM: arm64: Prevent guests from enabling HA/HD on Ampere1")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 4bddb8541bec..34f222af6165 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -457,6 +457,7 @@ static bool handle_ampere1_tcr(struct kvm_vcpu *vcpu)
 	 */
 	val &= ~(TCR_HD | TCR_HA);
 	write_sysreg_el1(val, SYS_TCR);
+	__kvm_skip_instr(vcpu);
 	return true;
 }
 

base-commit: 01b94b0f3922039f7d3e0d1eeb33b8891746b65f
-- 
2.41.0.487.g6d72f3e995-goog


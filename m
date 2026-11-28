Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828536;
	b=ydorFL+d4cdjSsRnkx2WFyud5vb6W6Z9hO7pD4453Haa6MeKRav/9JVLw8Ycb2vysXnk
	 L73zZvfONby+TmeArdyVLIz9Md7AeiKu8DjRvoolh54OADc3wlnzKo0xNAvN2Mad4V9zx
	 /QFZx/7/KcLJ11kN09Ur5A0RWZEtt+zXShTi4z/577Ae5ELxSUJU2BJ4KT53nuSG53Pam
	 8uurBXOLDCGP3+pSebyOYP3liWqQzYOqu4Crrn3P+ERBtN8SBmMkj5C80+kiW2Q7apXJk
	 S/oqFQJ68RVgc2MQdWTJtpzmw3sFfrrj0WQlaG/xffb18B3AFbG0Otdh1i93TMMcMow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828536;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=e6ir9BIcJPtNB+CZ0UjTq70ens/z6VXHgq2Ph+DMpuw=;
	b=4HjHvB7Be68918UsHOTg1Rgn+IT8CO/kUwssdjgoLiEp0MXZoFsodLBovdxRKvwHZ9Fx
	 dn8rAHRg+Un8CO/M5C7iovNmVF3xMk1babfzO4Muz5bOrQvwerj8CO/k0+/isvRBi7yXa
	 94eQDEnkKx8mlVJaRlf2eKyJaiyQ1ARE09Q/O19CUcPiUIIuxeIox5F3ksqWoMg2GfjoR
	 EwYRvzGIf44K9wfJVMGsDCtWgRmIUtkntZa9OOWBzaH1UDfJgCq8yklECTCzTZWOLmbaF
	 b9oxnRW/+Eb8t+DgALUB0El2HmWPC5QCQAhKfM1NLBgJi8jdQDSKJxdePLRptfFv1/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VBxlsdTh;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9C9606A32F
	for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 01:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA9C9606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VBxlsdTh
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CED71AED;
	Fri, 27 Nov 2026 17:15:32 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 756F23F632;
	Fri, 27 Nov 2026 17:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795828535; bh=PwWry79G/rHoeNTQeW74SB6yMZ5lKtAhX9zM32V09DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBxlsdThwMzj1IwdiMCITAQi2UbnH44b4L/iJX0KEpwRXt79HYGb6zRq9fCajHnL/
	 GvQsBWb09k+cUJBG95O0ZRQ3JuN9Z6U9sVY45G13DH2essrhqk3FZ8qJ3NGakOv2+Y
	 el/LX8JGnwCGYCddOdKnmTRR3rL3VjaSekIQAEHI=
From: Jia He <justin.he@arm.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 2/4] KVM: arm64: nv: Inject an SEA when the VNCR walk cannot set the AF
Date: Sat, 28 Nov 2026 01:14:45 +0000
Message-Id: <20261128011447.3588988-3-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261128011447.3588988-1-justin.he@arm.com>
References: <20261128011447.3588988-1-justin.he@arm.com>
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

When the guest hypervisor enables hardware Access flag management
(TCR_EL2.HA), KVM's stage-1 walker sets the AF in the descriptor that
maps VNCR_EL2 with __kvm_at_swap_desc(). If the descriptor is in a
read-only memslot, the update fails with -EPERM and walk_s1() records an
SEA on translation table walk in the walk result.

kvm_handle_vncr_abort() does not handle -EPERM. It neither injects the
fault nor maps the VNCR page, and returns to the guest. The guest takes
the same VNCR abort again and never makes progress.

-EPERM can only come from this AF update. The VNCR walk uses the EL2&0
translation regime, which has no stage-2.

Treat -EPERM like the other walk failures and inject the recorded fault
into the guest hypervisor.

Tested with the selftest added in the next patch on a Neoverse-N2 host.
Without this patch, the vCPU exits about 1.3 million times in 5 seconds
on the same VNCR abort and makes no progress. With this patch, the
guest hypervisor receives an SEA on translation table walk at level 3.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-230439@kernel.org/
Fixes: bff8aa213dee ("KVM: arm64: Implement HW access flag management in stage-1 SW PTW")
Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/kvm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 08582fbc09d5..523d71d4df13 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1743,6 +1743,7 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 	case -EINVAL:
 	case -ENOENT:
 	case -EACCES:
+	case -EPERM:
 		/*
 		 * Translation failed, inject the corresponding
 		 * exception back to EL2.
-- 
2.34.1


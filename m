Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE3134E755;
	Thu, 12 Mar 2026 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773324540; cv=none; b=gLHVJ+fkZt5ORiXKtd5YkPu+0aP8hJO/ib6ugJrrkCfhzFjr2xdPG0NeePRoAQl58BO34MbHhslAa1rg7d41AgUnqqqN7IDvCQYTLM6ZRQ27EgXX5n+N87Fa56VNNMqXIL3J7o0+pd7O9DmBGOoEEwsPsJBpeGxB+zPQapmVyjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773324540; c=relaxed/simple;
	bh=TNp+UfKq5Rem+lGqK4AbfI/yFPyPpDKvIcbn9WJmW0E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z0JGMDzgaJu1G27OpSoeMARF6QQlVtl6LZaAQs/Dmr6+Ttnw7All/hn1BaK+sYcvBEIz3I9PsNvUW3rMwdgGvPJpIQ4WbQpZbyS/abZaMIq6xKBdX+ykGEavZuHs5j2zS4XyLjhtmy4OnQ7iavUKEqvD5VP1Vloo/nidbDxDnII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gE00GihL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gE00GihL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1683C4CEF7;
	Thu, 12 Mar 2026 14:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773324540;
	bh=TNp+UfKq5Rem+lGqK4AbfI/yFPyPpDKvIcbn9WJmW0E=;
	h=From:To:Cc:Subject:Date:From;
	b=gE00GihLUHd66Ox+eiHldi/+eQrNGTfiqcDME4tNZmECD7RCHljT84lWQsaXGmjnv
	 wej4ieeCZ7Yf96LZp4V1vjwy0V6Izj8ypNgK5TDxNcj5m93zbeDNnQ3beMnL3uvC6T
	 67jDuYdq12Ex7Dc7n/meGgYmsa8qw2ARJWF3XnmQy1z9RQk8prZORzW/N3o5XKF4Mp
	 jK/ZrKhohbnfi+8aceLO28wZ55wBBxydsXhjY0C6RkeXfX9L3JeGlIVB8w6MKdC3m8
	 3gECc2pR3beIluYm2UBNMlQ9SqTC7jweH0Gz4z71lo0rIWW3fKYMH7MCbnvF7Tdztm
	 Sxd2NLGtv2CKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w0gif-00000001I5r-2QP2;
	Thu, 12 Mar 2026 14:08:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Discard PC update state on vcpu reset
Date: Thu, 12 Mar 2026 14:08:50 +0000
Message-ID: <20260312140850.822968-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Our vcpu reset suffers from a particularly interesting flaw, as it
does not correctly deal with state that will have an effect on the
execution flow out of reset.

Take the following completely random example, never seen in the wild
and that never resulted in a couple of sleepless nights: /s

- vcpu-A issues a PSCI_CPU_OFF using the SMC conduit

- SMC being a trapped instruction (as opposed to HVC which is always
  normally executed), we annotate the vcpu as needing to skip the
  next instruction, which is the SMC itself

- vcpu-A is now safely off

- vcpu-B issues a PSCI_CPU_ON for vcpu-A, providing a starting PC

- vcpu-A gets reset, get the new PC, and is sent on its merry way

- right at the point of entering the guest, we notice that a PC
  increment is pending (remember the earlier SMC?)

- vcpu-A skips its first instruction...

What could possibly go wrong?

Well, I'm glad you asked. For pKVM as a NV guest, that first instruction
is extremely significant, as it indicates whether the CPU is booting
or resuming. Having skipped that instruction, nothing makes any sense
anymore, and CPU hotplugging fails.

This is all caused by the decoupling of PC update from the handling
of an exception that triggers such update, making it non-obvious
what affects what when.

Fix this train wreck by discarding all the PC-affecting state on
vcpu reset.

Fixes: f5e30680616ab ("KVM: arm64: Move __adjust_pc out of line")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/reset.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 959532422d3a3..b963fd975aaca 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -247,6 +247,20 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 			kvm_vcpu_set_be(vcpu);
 
 		*vcpu_pc(vcpu) = target_pc;
+
+		/*
+		 * We may come from a state where either a PC update was
+		 * pending (SMC call resulting in PC being increpented to
+		 * skip the SMC) or a pending exception. Make sure we get
+		 * rid of all that, as this cannot be valid out of reset.
+		 *
+		 * Note that clearing the exception mask also clears PC
+		 * updates, but that's an implementation detail, and we
+		 * really want to make it explicit.
+		 */
+		vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
+		vcpu_clear_flag(vcpu, EXCEPT_MASK);
+		vcpu_clear_flag(vcpu, INCREMENT_PC);
 		vcpu_set_reg(vcpu, 0, reset_state.r0);
 	}
 
-- 
2.47.3


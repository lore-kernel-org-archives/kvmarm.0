Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679F26AB8
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 12:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2239FC433EF;
	Thu, 12 Jan 2023 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673527135;
	bh=TEld5/eWLZ8WYi+kitrePlcWShsqcZJpPVEOUZjvFFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEM1wAB4VmrHlB3wy0Rl6rFU9Q5d1dk8qZ8H/1COQWeuz/uTsY4AqHBPLc5qxJqdH
	 zg9aHY6D3oLFdaLLf60jHj/h6CEVYyALEH4cYmu+pwQPkO2bGib6Bj68zkHSF7K5vd
	 HB/o4GO4S1E/j5JEg25mPHY0qUq2I3y121JgFQPPXIgb2wLbSZuhsnCMnwxc5/PGyE
	 4iHua27VRt3fNhd1ixu78U58BWS8PVrlQcBcOW6Srg59Mw3F3uxWcdX3xt+Jl4NH92
	 qJj3wBJtlnyeHDSP3syEF8tuU2dAHx0udVR3pRoiBf7YA85VZ4+dXJiG1OKQa1sGPH
	 6Zg2uUJGW82hg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pFwr7-001BBa-3w;
	Thu, 12 Jan 2023 12:38:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	<kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org
Cc: D Scott Phillips <scott@os.amperecomputing.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/3] KVM: arm64: timers: Don't BUG() on unhandled timer trap
Date: Thu, 12 Jan 2023 12:38:29 +0000
Message-Id: <20230112123829.458912-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112123829.458912-1-maz@kernel.org>
References: <20230112123829.458912-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, scott@os.amperecomputing.com, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although not handling a trap is a pretty bad situation to be in,
panicing the kernel isn't useful and provides no valuable
information to help debugging the situation.

Instead, dump the encoding of the unhandled sysreg, and inject
an UNDEF in the guest. At least, this gives a user an opportunity
to report the issue with some information to help debugging it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d5ee52d6bf73..32f4e424b9a5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1049,7 +1049,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 		treg = TIMER_REG_CVAL;
 		break;
 	default:
-		BUG();
+		print_sys_reg_msg(p, "%s", "Unhandled trapped timer register");
+		kvm_inject_undefined(vcpu);
+		return false;
 	}
 
 	if (p->is_write)
-- 
2.34.1


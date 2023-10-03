Received: from out-210.mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BAC3F4A2
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 23:04:37 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696374275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VJzQRyLcH37QNveZisoKV3f0cvjImEuUahyzeAbqd4I=;
	b=ieGb1hbivXKHRDapHcoOb6V1z86Kwys6MLmcXGHJtVCX1TrVxK0HHkiF+XefJ2HBOBFAmf
	q67nByD48ZKl8MQDzQ1uRjBCeuJgTqfPz2xBecZCi/MIW9J4FCJeguHNuRMLMGW2qFikHU
	GstEUHUDQUTEnSmkPd5os4vUOYagEXk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v11 09/12] KVM: arm64: Allow userspace to change ID_AA64ZFR0_EL1
Date: Tue,  3 Oct 2023 23:04:05 +0000
Message-ID: <20231003230408.3405722-10-oliver.upton@linux.dev>
In-Reply-To: <20231003230408.3405722-1-oliver.upton@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

All known fields in ID_AA64ZFR0_EL1 describe the unprivileged
instructions supported by the PE's SVE implementation. Allow userspace
to pick and choose the advertised feature set, though nothing stops the
guest from using undisclosed instructions.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 24825b73d365..cf1b2def53db 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2067,7 +2067,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-	ID_SANITISED(ID_AA64ZFR0_EL1),
+	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
 	ID_UNALLOCATED(4,6),
 	ID_UNALLOCATED(4,7),
-- 
2.42.0.609.gbb76f46606-goog


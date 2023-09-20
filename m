Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3EF17D8
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 18:33:42 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695234821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7fiKDFw4FmI+YtcrQ14r5/ooshFPZ0x9Ux0zjbxVWoc=;
	b=eZkEXG6RQHNcI7uAk0MWsubVlvgC9Cy9n8Qg9INUrQ21fpZ1l5MUqjWYsqB4LGHvYvE2BW
	BZMWL1VOawiGsnqY2cBKObU9FbQtvNRac2jq5dSyAqNdq2T6QLgZDq9unjKoZlydI+Kv2u
	B+DN1CAETEWICGURc4a7YdHKVKMexXo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v10 08/12] KVM: arm64: Allow userspace to change ID_AA64PFR0_EL1
Date: Wed, 20 Sep 2023 18:33:05 +0000
Message-ID: <20230920183310.1163034-9-oliver.upton@linux.dev>
In-Reply-To: <20230920183310.1163034-1-oliver.upton@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jing Zhang <jingzhangos@google.com>

Allow userspace to change the guest-visible value of the register with
some severe limitation:

 - No changes to features not virtualized by KVM (AMU, MPAM, RAS)

 - Short of full GICv2 emulation in kernel, hiding GICv3 from the guest
   makes absolutely no sense.

 - FP is effectively assumed for KVM VMs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
[oliver: restrict features that are illogical to change]
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5758cff479d3..8738b0a0cf5c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2061,7 +2061,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = ~(ID_AA64PFR0_EL1_AMU |
+		   ID_AA64PFR0_EL1_MPAM |
+		   ID_AA64PFR0_EL1_SVE |
+		   ID_AA64PFR0_EL1_RAS |
+		   ID_AA64PFR0_EL1_GIC |
+		   ID_AA64PFR0_EL1_AdvSIMD |
+		   ID_AA64PFR0_EL1_FP), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.42.0.515.g380fc7ccd1-goog


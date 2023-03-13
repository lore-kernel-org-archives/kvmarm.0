Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068902569
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 13:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF8BC433D2;
	Mon, 13 Mar 2023 13:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678713046;
	bh=Zt2E0veroutFPMccUo4kO1IGRUDWoAxMPiaSzpEmB4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kY3Qc+EMOP+y06SOqTOvQ5loSmvgidmu1yETcRpE6vrN7HCuwDvpY7vS8nYbRVktE
	 sNTMmozTNfhKzBSGJlWFQAAk1D/Zl7SX10UjKj66SjVo1IKq4mVKIFtz6k2ouh28QL
	 1Bt+PYFMkaG2D82YVlV6xNnT829lWPUxEH5+a28/qILjZo6U8wdYNRIilOvLJLF3ro
	 +wX7VNkt3e8s6PN+I7iN7qIQb67j3vFr8lN/XR/tRzcK47F0Z9i7SFyWqpZopZSGSu
	 b+WodPhYZipJz1qcULlKuogAiDG1TzZs7lgHZdCo1vTsRnnyzg3Xl0euTdQsvn+sUr
	 MMeyM5WmFXCoQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pbhbj-00HEdE-6V;
	Mon, 13 Mar 2023 12:48:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	dwmw2@infradead.org
Subject: [PATCH v2 15/19] KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
Date: Mon, 13 Mar 2023 12:48:33 +0000
Message-Id: <20230313124837.2264882-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Being able to set a global offset isn't enough.

With NV, we also need to a per-vcpu, per-timer offset (for example,
CNTVCT_EL0 being offset by CNTVOFF_EL2).

Use a similar method as the VM-wide offset to have a timer point
to the shadow register that contains the offset value.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 13 ++++++++++---
 include/kvm/arm_arch_timer.h |  5 +++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 11047b3dfb5b..9666e0d0423e 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -89,10 +89,17 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 
 static u64 timer_get_offset(struct arch_timer_context *ctxt)
 {
-	if (ctxt && ctxt->offset.vm_offset)
-		return *ctxt->offset.vm_offset;
+	u64 offset = 0;
 
-	return 0;
+	if (!ctxt)
+		return 0;
+
+	if (ctxt->offset.vm_offset)
+		offset += *ctxt->offset.vm_offset;
+	if (ctxt->offset.vcpu_offset)
+		offset += *ctxt->offset.vcpu_offset;
+
+	return offset;
 }
 
 static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index f093ea9f540d..209da0c2ac9f 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -29,6 +29,11 @@ struct arch_timer_offset {
 	 * structure. If NULL, assume a zero offset.
 	 */
 	u64	*vm_offset;
+	/*
+	 * If set, pointer to one of the offsets in the vcpu's sysreg
+	 * array. If NULL, assume a zero offset.
+	 */
+	u64	*vcpu_offset;
 };
 
 struct arch_timer_vm_data {
-- 
2.34.1


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21092569
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 13:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98DFC433EF;
	Mon, 13 Mar 2023 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678713061;
	bh=CW1z3PJhugxKdwIm9+T8OdkD1WD5mW3UVs9HisXybMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzdB3EVbWXKx0hoc6v+XwYd2pBtxaHo7FU6kpPnAHZXRC+60EVJ75+ttx9I/zR9KX
	 BJSjdyJsGdb8rJL3YShLX9ysMW3jHUxAUNfkuMPBeB9lU8LFJHvV6tFDhdBYNXe2c/
	 R5Kp7G0IbShv7c7obxiij5BPuFABIMVU4fadqh58HBWi6EXOL5CFBeOx1zbmFUOzaP
	 Ywcrc3csUY59Tf+KazujTEPUkjvXH0CtsVGsJUY5LAn6vNT76UFZW7Pf+TaTXEzq8D
	 qxNpU7cUBzk7PDNIw7h7MTZixv6tNeOGu458Kg+fF6X/ZYzJYmRL7R+t0r3enbGRhk
	 DI9FJqg7jIwXQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pbhbi-00HEdE-Lb;
	Mon, 13 Mar 2023 12:48:54 +0000
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
Subject: [PATCH v2 13/19] KVM: arm64: Abstract the number of valid timers per vcpu
Date: Mon, 13 Mar 2023 12:48:31 +0000
Message-Id: <20230313124837.2264882-14-maz@kernel.org>
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

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 88a38d45d352..11047b3dfb5b 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -52,6 +52,11 @@ static bool has_cntpoff(void)
 	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
 }
 
+static int nr_timers(struct kvm_vcpu *vcpu)
+{
+	return NR_KVM_TIMERS;
+}
+
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
@@ -255,7 +260,7 @@ static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
 	u64 min_delta = ULLONG_MAX;
 	int i;
 
-	for (i = 0; i < NR_KVM_TIMERS; i++) {
+	for (i = 0; i < nr_timers(vcpu); i++) {
 		struct arch_timer_context *ctx = &vcpu->arch.timer_cpu.timers[i];
 
 		WARN(ctx->loaded, "timer %d loaded\n", i);
@@ -815,12 +820,12 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * resets the timer to be disabled and unmasked and is compliant with
 	 * the ARMv7 architecture.
 	 */
-	for (int i = 0; i < NR_KVM_TIMERS; i++)
+	for (int i = 0; i < nr_timers(vcpu); i++)
 		timer_set_ctl(vcpu_get_timer(vcpu, i), 0);
 
 
 	if (timer->enabled) {
-		for (int i = 0; i < NR_KVM_TIMERS; i++)
+		for (int i = 0; i < nr_timers(vcpu); i++)
 			kvm_timer_update_irq(vcpu, false,
 					     vcpu_get_timer(vcpu, i));
 
@@ -1302,7 +1307,7 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&vcpu->kvm->arch.timer_data.lock);
 
-	for (int i = 0; i < NR_KVM_TIMERS; i++) {
+	for (int i = 0; i < nr_timers(vcpu); i++) {
 		struct arch_timer_context *ctx;
 		int irq;
 
@@ -1322,7 +1327,7 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 
 	mutex_unlock(&vcpu->kvm->arch.timer_data.lock);
 
-	return hweight32(ppis) == NR_KVM_TIMERS;
+	return hweight32(ppis) == nr_timers(vcpu);
 }
 
 bool kvm_arch_timer_get_input_level(int vintid)
@@ -1332,7 +1337,7 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	if (WARN(!vcpu, "No vcpu context!\n"))
 		return false;
 
-	for (int i = 0; i < NR_KVM_TIMERS; i++) {
+	for (int i = 0; i < nr_timers(vcpu); i++) {
 		struct arch_timer_context *ctx;
 
 		ctx = vcpu_get_timer(vcpu, i);
-- 
2.34.1


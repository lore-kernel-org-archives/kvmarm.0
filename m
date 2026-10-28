Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201527;
	b=HqK7L8XnvaI1qmHEUtDgNjxlVngkb93zhfOWe87UyGJgyPOTt5VYy4Wn04RZcta59ULX
	 9IslRlxPhMyW68mXQHldAw7CZB9NkQCvhbeWkHqjSZcrqiOMYr82tbOsPI6JZfHiu9sFi
	 dpORWpCjrbClG1Unclb9qEmtrdbnbZy/JwXC6iROeUtO5jN44+57BsmBy4L3kPo4wxmu1
	 fJN8kvld4nOLn8QGe0mmGVctvgIYLqmdrVZGE0pAcCRu4FPU+LJurs1w+Jrw8qgKgI9K0
	 dTF/l3Wqnppo/zbcuyuuUH41EvZ0UmZ8oYXz1bHhs4djrnX6BYdFSs/oRw7MH4FmmtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201527;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tNuGjVpCCpWRRwNm7lQ2uEnHwZpiJtdBe9DMgOWbUgg=;
	b=eFomJxUDu2vU0s/3Gjs6mi7jDrtq1j+9Pf+NaM9G1dDgBo+XmrsgQHJujPAJfy4EIbsx
	 p4Yej4yqooqZLd/mOIVMCqXWQLDxdwUYxupAXFwgup0WpyXWb8Vj0YjV5+f4sdT6MXF5n
	 ncdrGsEJSTS5MntZFF7W1JBechUIfFZTqIE9cn/CVJoZbRqIVYbrwY15GC8NM/ihfqQ0P
	 4vKrCfw1uNVZchlBgODTv7BPQy18KbXBPe7T7y7aW/mSOEVFU+hzIg4CdgwSp5J+djrmb
	 fMJvXcnltnXia4627/aqkSDNSB3cp50Q9ShQR/CL1zQKZW6qLfeHLEGaAk2kZPnP7fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="ie83ix/d";
	arc=none smtp.remote-ip=91.218.175.18
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C97606A326
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 15:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2C97606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ie83ix/d
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=jRMgEeT/ywsGUFgWQfUZIBCXSXNOChhJpeoxPBa3hhY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793201523; v=1; x=1793806323;
 b=ie83ix/dHSqljXkwuZVu1bU3xefrb1t5SmJiaZR8otsTzWZLEc1ZRO0i8VGP68TR2hAVwmOf
 yyLkNiIAdYQRCewmF62BQALvLZu5Uwge5aXA0MKunv/M10xSwTgncWPhTHkvGO73OU2DMdz0H0r
 aXOJSdvO1O5M+70ag2TdrjSQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4642add3ff1b0393;
	Wed, 28 Oct 2026 15:32:03 +0000
X-Mizu-Trace-ID: 4642add3ff1b0393
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	Oculytic <oculytic@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 2/3] KVM: arm64: Pass the PMU events to the hyp vCPU of non-protected guests
Date: Wed, 28 Oct 2026 15:31:51 +0000
Message-ID: <20261028153152.1740044-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028153152.1740044-1-fuad.tabba@linux.dev>
References: <20261028153152.1740044-1-fuad.tabba@linux.dev>
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

From: Oliver Upton <oliver.upton@linux.dev>

Before every run, the host records in vcpu->arch.pmu.events which perf
counters to disable and enable around guest entry, and
__pmu_switch_to_guest() applies them at EL2. Since commit be66e67f1750
("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()"),
protected mode runs the hyp vCPU instead, and flush_hyp_vcpu() never
copies the events into it. So the counters backing a non-protected
guest's PMU are never enabled, and every counter the guest reads stays
at 0, the cycle counter included. The host's counters that exclude
guests keep counting the guest as well.

Copy the events into the hyp vCPU of a non-protected guest on every run.
The events only exist with CONFIG_HW_PERF_EVENTS, so the copy is built
under it. Like mdcr_el2, they're host-controlled and never reach a
protected guest.

Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Link: https://lore.kernel.org/all/20240305184840.636212-2-oliver.upton@linux.dev/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
[Fuad: non-protected copy only, tested on the hyp vCPU, under
 CONFIG_HW_PERF_EVENTS, new message]
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d715aa942577e..28a292deecb64 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -690,6 +690,16 @@ static void sync_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 		host_vcpu->arch.external_debug_state = hyp_vcpu->vcpu.arch.external_debug_state;
 }
 
+#ifdef CONFIG_HW_PERF_EVENTS
+static void flush_pmu_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		hyp_vcpu->vcpu.arch.pmu.events = hyp_vcpu->host_vcpu->arch.pmu.events;
+}
+#else
+static void flush_pmu_state(struct pkvm_hyp_vcpu *hyp_vcpu) {}
+#endif
+
 static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
@@ -698,6 +708,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	fpsimd_sve_flush();
 	flush_debug_state(hyp_vcpu);
+	flush_pmu_state(hyp_vcpu);
 
 	/*
 	 * If we deal with a non-protected guest and the state is potentially
-- 
2.47.3


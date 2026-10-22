Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792651620;
	b=yJYozbHJfbrj709TVu/dOZ0BGomU7GUjIk1T59/+sOeGjwLjEN5c7NVn5j+fqLGPPE2H
	 GfsC72r/w75VLQoE076QMhHplErv1MZLmnOFdFi4uRzTXQ7a5IEDy/euMYsNMWs0J4sjE
	 FZnm8LlhM2Y8nuuh+HMRvvbbjUuWTCmrl5M1QcGbOvGfgqyBG/S8FKqLh6k3QgxVo29yz
	 vjkktuYnTQt25XTC0KNK8nU5k8CMdsMIXUjAvLpn0U4B4EV8YgubRBysjr4fuXe9qcUzN
	 2Uph9pLqJAwYyJovZDYRm9a7ta9oSJdwLkQPZz67F2oNEF/HuZoZz+cMU6MVtGYyfgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792651620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U2m1NOxjt9F2BRgX+AxlY6ccXZ7NGdaeYHeYEfzi92w=;
	b=h3YBYNuBuL5z9MU0uuEKnmesT9YvjMYKhOtfkbK5Hj2P2IO2r/F3pk9izlKCxjJTFZCy
	 gxKS2o7zCyc737PGsGRTc+7LimEz9QmBfd7Xxlhqpp2B3NTHW6DY2ya0sr/Gd/mvQvjJ9
	 bgCc4vtTikk91F8nS/RIXQKWKhJ9VMIer513k+dfGTD5PB0wKZ796iHlnQe9KZ1oKjyxM
	 30TdGRGfIzS2mfVE71VDRfLuUg4nCsmT3tDGbkequTWwojU6TFR7YhSF5m0B59d8HIZPQ
	 h8Oplwx1otl+4gWC77pmc1r4K8OjatZQIltxQJlRpsFhnZ5mNlIRtIJz0MnG1fft2Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ijbBONDW;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8170606A337
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 06:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8170606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ijbBONDW
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4d870d54so1067096f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 23:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792651606; x=1793256406; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U2m1NOxjt9F2BRgX+AxlY6ccXZ7NGdaeYHeYEfzi92w=;
        b=ijbBONDW91YEVK0RBz3duLJ9RunLWd2gGwFK02OCeMm0w57y3sab6GW7mUDojEcfiz
         bvv2dvEJxPd/2H0wQwhEXuh7sxdGpyvMmzRxIMEo54ln2T4O0+qUjAufWS1x6EW2hjJ/
         4U2bDbD62+vrdFgxOkLrxNGx5oNEWdBfXJBM4jbyw2syc08PTpVDbPbhEvgvHu8dC65g
         f4VhOmOrMdm2JtC3XdzvQhwpZ9bIv8YzyDwYaeb5t1LUZtkWy/h58kUy9EmG8usR1cU2
         qJnHU4vho7lyVcCFM5XDn7nq53s+oLMMFGi8WybCsMv5IvT84gd3Hq+QmyN+HDAyqBra
         ZS2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792651606; x=1793256406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U2m1NOxjt9F2BRgX+AxlY6ccXZ7NGdaeYHeYEfzi92w=;
        b=a/fJkkuhPHgrjAqM9eSwJa9NHAHPXJQEtvjnsxTPaa98j6QWp+dHzbFXSEBnuyohNE
         2bJ/GCfnLEpDDEKvg9EWOi05iJ1XbKlP3Bi/wwq+eFsZg3CaNmK94UwE+9fZo4RfaEct
         kiI3NjL8rSECBvNDJBXHDPoxcZAGPTNf6ypTHsxSMkFGyWbhjnb5HL+S5QFBgoNIgZ9E
         SSFB1fGukuPLiPrMC+vScRWU3QDmeqGL6gGRRB2htJsEbFzzamCAH8DIehjNMugrT5Cc
         Wq+evJJBl3G96WU7HvJtr0yFJXAe/rHIOyh+n+BNeCn0Ro6TBbqHYF7HT/NPILqGGXEN
         7KwA==
X-Forwarded-Encrypted: i=1; AKwUvBx2uFbMg4VcUMs8iiUnkaPURruWqyNS5oof+m3HwNpJ/SrmpIRtlvrumJMH3sUVbuJvkJqm1WI=@lists.linux.dev
X-Gm-Message-State: AFq9FYIu+8wyPrEWBZbyHQWiDjYF67EVsvqJkZCE7a9th/qjUHq2h0M1
	t2xryCGO3MZCibwhJLwkPhACwq7HGQtj17KQE6EDz1J5K1Hr/R2ujnZt
X-Gm-Gg: AYBFou0eqxGNuRO0gN6t1j+7c9lMzOzfhbhmQbhIKUs3qgCDlCALg/hCa3aBCN2koOe
	V+OJaMGyYNR0ZDp5oybWzX3qzn3DXSeP1/mEY7WA235nijsej/Y3LvgywfyyGLoEf/GyS+BCqoE
	48nk/CUC9El4u7nmMRniP6arvBfuepIvLzfwn40h4CNp3A0K/BYDsHa4js1Ju7h8qKTPruoUIx1
	61xDfwfK1572OuS4xULd9cGgCN88vn1L97dRoD6blgKrjqwB8Xncaqb97MOtCo3PYIYxo6ugIP8
	LBqqt3+KiSxufJkpjNmq9hPIvjcGeq+lHS37zEX/jarnpG7hAkEYTATH4txO37Iit7csRcxCuU4
	18zEpHrzeEIfwqNKX4oY4id1Hl5T0EEFTUZp+7vzKbVMVgH6x1xrFwT4BBU+cSwkNX4OO4evDF5
	LNTHX7MVjm7YXl5pxs8OJH3iJly4tgtoUISzeNiBNDXuxwgx73PXipi/dMYWJhhVDkZT/FM/Tf7
	S2v60X6px36qaDie39TAun1mTmskM4yGMcOC5h3r7HfTHbmcUlKkcGGJr7LrLgMrtc6VSnW2Bjg
	kJph2oYTE2QUskNuodEu+3LEnGQm/drp98OEFOf81YTXak4bnWW6q3dmj1D1qxqZpsZ5aJNEPLo
	ou5twaTyh/eiQdRlO4csZRmKz9Xncb8oVbjhipGsCMaurO6wjtSTaBu9BsLCPeHOUcQ==
X-Received: by 2002:a05:6000:310c:b0:48d:faf4:54a8 with SMTP id ffacd0b85a97d-48e26493bedmr9081092f8f.11.1792651606193;
        Wed, 21 Oct 2026 23:46:46 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ad43-d501-2c28-bb72-120d-420e.310.pool.telefonica.de. [2a02:3100:ad43:d501:2c28:bb72:120d:420e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828cd1sm10215624f8f.22.2026.10.21.23.46.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 23:46:45 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] KVM: selftests: arm64: Test pending writes to active level IRQs
Date: Thu, 22 Oct 2026 08:46:28 +0200
Message-Id: <20261022064628.4206-4-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261022064628.4206-1-kmehltretter@gmail.com>
References: <20261022064628.4206-1-kmehltretter@gmail.com>
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

Add a two-vCPU GICv3 test for a level SPI set pending through
GICD_ISPENDR. Re-pend the interrupt while it is active, first from the
handling vCPU and then from the other vCPU. Require a second delivery
after deactivation in both cases.

Also check that the other vCPU observes the initial pending state
before the interrupt is acknowledged.

Without the VGIC fix, the pending state is cleared on deactivation and
the test fails before the second delivery.

Assisted-by: LLM
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 101 +++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 3cb85932ee85c..81f38e523d3c0 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -959,6 +959,106 @@ static void guest_code_timer_spi(struct test_args *args, int cpuid)
 	GUEST_DONE();
 }
 
+#define REPEND_READ	1
+#define REPEND_READ_DONE	2
+#define REPEND_WRITE	3
+
+/*
+ * A level-sensitive SPI that is set pending through GICD_ISPENDR stays
+ * pending for every vCPU until it is acked. If it is set pending again while
+ * it is active, it becomes active and pending and must be taken a second time
+ * once it has been deactivated. The second pending state comes from the vCPU
+ * that handles the interrupt in the first round, and from the other vCPU in
+ * the second.
+ */
+static void guest_code_level_repend(struct test_args *args, int cpuid)
+{
+	int i;
+
+	gic_init(GIC_V3, 2);
+
+	gic_set_eoi_split(1);
+	gic_set_priority_mask(CPU_PRIO_MASK);
+
+	if (cpuid == 0) {
+		u32 intid;
+
+		local_irq_disable();
+
+		gic_irq_set_config(MIN_SPI, false);
+		gic_set_priority(MIN_SPI, IRQ_DEFAULT_PRIO);
+		gic_irq_enable(MIN_SPI);
+
+		for (i = 0; i < 2; i++) {
+			gic_irq_set_pending(MIN_SPI);
+
+			if (i == 1) {
+				/* Not acked yet: the other vCPU sees it pending */
+				WRITE_ONCE(args->shared_data, REPEND_READ);
+				dsb(ishst);
+
+				do {
+					dsb(ishld);
+				} while (READ_ONCE(args->shared_data) != REPEND_READ_DONE);
+			}
+
+			GUEST_ASSERT(gic_irq_get_pending(MIN_SPI));
+			intid = wait_for_and_activate_irq();
+			GUEST_ASSERT_EQ(intid, MIN_SPI);
+
+			if (i == 0) {
+				gic_irq_set_pending(MIN_SPI);
+			} else {
+				WRITE_ONCE(args->shared_data, REPEND_WRITE);
+				dsb(ishst);
+
+				do {
+					dsb(ishld);
+				} while (READ_ONCE(args->shared_data) == REPEND_WRITE);
+			}
+
+			GUEST_ASSERT(gic_irq_get_active(MIN_SPI));
+			gic_set_eoi(intid);
+			gic_set_dir(intid);
+			isb();
+
+			/* The second pending state must not have been lost */
+			GUEST_ASSERT(gic_irq_get_pending(MIN_SPI));
+			intid = wait_for_and_activate_irq();
+			GUEST_ASSERT_EQ(intid, MIN_SPI);
+
+			gic_set_eoi(intid);
+			gic_set_dir(intid);
+			isb();
+
+			GUEST_ASSERT(!gic_irq_get_active(MIN_SPI));
+			GUEST_ASSERT(!gic_irq_get_pending(MIN_SPI));
+			GUEST_ASSERT_EQ(gic_get_and_ack_irq(), IAR_SPURIOUS);
+		}
+	} else {
+		do {
+			dsb(ishld);
+		} while (READ_ONCE(args->shared_data) != REPEND_READ);
+
+		for (i = 0; i < 64; i++)
+			GUEST_ASSERT(gic_irq_get_pending(MIN_SPI));
+
+		WRITE_ONCE(args->shared_data, REPEND_READ_DONE);
+		dsb(ishst);
+
+		do {
+			dsb(ishld);
+		} while (READ_ONCE(args->shared_data) != REPEND_WRITE);
+
+		gic_irq_set_pending(MIN_SPI);
+
+		WRITE_ONCE(args->shared_data, 0);
+		dsb(ishst);
+	}
+
+	GUEST_DONE();
+}
+
 static void *test_vcpu_run(void *arg)
 {
 	struct kvm_vcpu *vcpu = arg;
@@ -1073,6 +1173,7 @@ int main(int argc, char **argv)
 		test_vgic_two_cpus(guest_code_asym_dir);
 		test_vgic_two_cpus(guest_code_group_en);
 		test_vgic_two_cpus(guest_code_timer_spi);
+		test_vgic_two_cpus(guest_code_level_repend);
 	} else {
 		test_vgic(nr_irqs, level_sensitive, eoi_split);
 	}
-- 
2.39.5 (Apple Git-154)


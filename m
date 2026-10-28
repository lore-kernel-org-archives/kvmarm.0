Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163694;
	b=RIPI32I1yp29luJGUhdcfOSxRIOoVBWvd1e88KBx9BOKd+qLfrAtNph0DtzvmOGiNL6W
	 VtL1nFen3jBJknt3YtwSlvUrRXAAzUbCWSscnWMyp5CjcoB4U4mW25Fdu2EMCreJnWeQA
	 HZg9diIPQhfbYOXYZVeEkPbi18ld8h4g+WfAD8aYwfArZlLPlzEI8tAcOrT1CkefzNtqy
	 UtoVUUQKqobP+RTLmWSyKYNaJugVOJzYkWPC/yxd4Z0GG28ZIYlPkJkt0ermyFklkPStu
	 0kcLOykPpHHWaPVKkV8wEwximbGRLfadEH9iRoqDK7lL72yrCd1KmTgfjKwd5WL96rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163694;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OLhUG1hLaXa/kF9EnkdPlvaJj5GdsFAdoHncTvXoPzg=;
	b=odhjPVZOH2Lzv+tjksSAyK1/G0gX2danhacH/y6mjwGn2QxMc852GIGgU/STwAbo/pQG
	 qj4K1PZlfjkTYVz/Cq+jp0QHLiKYHn1qL7Xx3Pt8PHABllg8nFyamWDy0+OJ0Vhca9Ezp
	 AdSZ0JCkLcsb8PUyeVxCWAbUQTpORO6cmmH1+ICAjpKwN1EzXdFfLHJBMnbf0EpCU6Jkm
	 OV+jeo614d3n49XdLWgle99nmpwjSwHbq8mo4J7KSDu02P/1Var34bJTS0ibWpRVsA19J
	 lnyrI7luunK1fSmUCH0KTRGZES/tKdkvvK74++DcX0d8sv2YeCqcj3PKyDFZ9MP0ljw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Yj24bsEQ;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC3360A5BE0
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 05:01:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACC3360A5BE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Yj24bsEQ
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so4765525e9.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 22:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793163692; x=1793768492; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OLhUG1hLaXa/kF9EnkdPlvaJj5GdsFAdoHncTvXoPzg=;
        b=Yj24bsEQZAbJ2zK3socmmsr2/yIK5ut1npXTSDS4j8ynzJIUT8QITcuCyD+RQ6RIiO
         H//DhElN/m2qK2lhFu92rgq43y35w9iyoCyYc+dGg4iktx5uRfRU4Crzs5OZB/vrnGyF
         ci2QuWRYIPN1bWo11+45xDTeiaK08ifxMusQ7yVnZn949G87DR3zyzV6CRkrOxvmsdvo
         P0wRjqMXzmdfwMEjciMevzclrm7s61smluP985RyaHAJMLfsP4oJEmgTE4yNqgqu320/
         OVnnHBF3vkOnntTPCrYTzDoZaSLcr2lGSOUPbRN7X9pqyHNPeHTc3kTG9qvhxush8F7V
         Sdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793163692; x=1793768492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OLhUG1hLaXa/kF9EnkdPlvaJj5GdsFAdoHncTvXoPzg=;
        b=MqodQKBvGiD50gyR/QmPk9bXawTbPwubaZZfpEK3IRKT/3BXcG/C4qlOAJ6H0c0DWC
         Us52odQwVreJwQYVUc1EmXFdSzdK1+knGkAfbsfu3TT/Y+Z9x6TBxDtXpNT84dzqhr5q
         41Z92U6p1L7RG4iT2zSg6hVgfr7+EPfeU769sdYvdsmoVnm/Lf/E42lGJ30Fo1ciE623
         5tMDz3x7IoRF7ceA1pT271UjUUkmqlz6ikX6arF+sZfneE8KYFs2bozfIdgJSjl+Zqdu
         xYh86gLRfohHMyxFQx7piaup8NyyjWcQHoJk37fx8twjqF//pk8T42MrghsJ+H6Zowot
         7O+g==
X-Forwarded-Encrypted: i=1; AKwUvBzz8WDNTdwiUr2u2i1Xvzx31ijec0Uims/OxcyAThLk6MC2sPbslVpJuFu/emqV4075ljt4jNo=@lists.linux.dev
X-Gm-Message-State: AFq9FYJRp+Oy0vhFtAzdwYP8OG1qsXz6scNJQYAC5fWo6yO0fbOdFmEs
	NiPDmkAYfyfASKBEKIWm/qnhFmC+CWD94JvKp3U1er8sRpD4qf2/dl4YCbC9EvPVKcQ=
X-Gm-Gg: AYBFou3EuVdUcoVUmuOrxCoN2C152KuEsxsfGYBY+/ciIm5rpWMsN/T33dTfnSJz45r
	1UseI9hLOwxHwwvX78Q97ILqXbFchDC46UwzxaVgfVUDiTeNKlUq6GrjWbSA8GSmjjQBZ9919iV
	Q78DFpkWCbPhJfIQwZgpymwtiyElW4FZMr22MdhQSSJE+Cew8IZD7rxsuHyxOy30QCUPAhgznur
	9P7FTEHu9wTivkpzf79PgcnWTBjwxPsnYpPepIaAllp3voh3eQrmqaIcg3rSgXy46ztHbI6d6i4
	G6z6ZJyq6/7LJH6EW6A0GOiSRaTkjy3QYb573+jJpmcjLGFv652Tj+JVLV/eDxVb3V0Z6tvmbfp
	cUUIMiWqk7/+469cPHF84dqXDEe8+AZR1ogKjvXngwtzZr66IqKy0I39vfvwjcchdlELh9Hb3Si
	Ncuoq9D/8WwEuPxVNlpaDN8P+/OOcJk3u2kSwh8/RYBRTFIhk81QCIniyyh0XaWcmr3rNbrWnoS
	G0tSDC0vAd7x+qlDj5rTSIQHKaWj0LrMQw/f3CuZWRanXGxRevZWTueODchgV0UDnfcE3kjL06Y
	69wawNDN1ero/p+VGmcITK7j0qgwHfOP7ApXpx0zownOnuJngLOyWV08kJe2SnBusnpvE+WL3hI
	V4Y1xxj2jC8mYlst3B/AS1kcV8NX+SsodDaJXqvcGmWE4R5Ftyk8q17j1kY8Dw241Zd1s5w12RN
	h8l07R4yuPkXt/yZJW6A0qH/K6aw9fT12o0jmqXA==
X-Received: by 2002:a05:600c:3e15:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4a9961f3d36mr12218315e9.6.1793163692052;
        Tue, 27 Oct 2026 22:01:32 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a45b-7d01-5035-b393-698f-53f0.310.pool.telefonica.de. [2a02:3100:a45b:7d01:5035:b393:698f:53f0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94eb8a60fsm13523365e9.3.2026.10.27.22.01.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 22:01:31 -0700 (PDT)
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
Subject: [PATCH v2 3/3] KVM: selftests: arm64: Test pending writes to active level IRQs
Date: Wed, 28 Oct 2026 06:01:13 +0100
Message-Id: <20261028050113.10046-4-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261028050113.10046-1-kmehltretter@gmail.com>
References: <20261028050113.10046-1-kmehltretter@gmail.com>
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
before the interrupt is acknowledged, and that a remote GICD_ISPENDR
write before the ack merges with the initial pending state without
causing a second delivery.

Without the VGIC fix, the pending state written while active is cleared
on deactivation and the test fails before the second delivery.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 140 +++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 3cb85932ee85c..83091e0384c22 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -959,6 +959,145 @@ static void guest_code_timer_spi(struct test_args *args, int cpuid)
 	GUEST_DONE();
 }
 
+#define REPEND_READ		1
+#define REPEND_READ_DONE	2
+#define REPEND_WRITE		3
+#define REPEND_PRE_ACK		4
+#define REPEND_PRE_ACK_DONE	5
+
+/*
+ * A level-sensitive SPI that is set pending through GICD_ISPENDR stays
+ * pending for every vCPU until it is acked. If it is set pending again while
+ * it is active, it becomes active and pending and must be taken a second time
+ * once it has been deactivated. The second pending state comes from the vCPU
+ * that handles the interrupt in the first round, and from the other vCPU in
+ * the second. A remote GICD_ISPENDR write before the interrupt is acked merges
+ * with the initial pending state without causing a second delivery.
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
+
+		/*
+		 * A remote ISPENDR write before the interrupt is acked merges
+		 * with the initial pending state and must not cause a second
+		 * delivery after deactivation.
+		 */
+		gic_irq_set_pending(MIN_SPI);
+
+		WRITE_ONCE(args->shared_data, REPEND_PRE_ACK);
+		dsb(ishst);
+
+		do {
+			dsb(ishld);
+		} while (READ_ONCE(args->shared_data) != REPEND_PRE_ACK_DONE);
+
+		GUEST_ASSERT(gic_irq_get_pending(MIN_SPI));
+		intid = wait_for_and_activate_irq();
+		GUEST_ASSERT_EQ(intid, MIN_SPI);
+
+		gic_set_eoi(intid);
+		gic_set_dir(intid);
+		isb();
+
+		GUEST_ASSERT(!gic_irq_get_active(MIN_SPI));
+		GUEST_ASSERT(!gic_irq_get_pending(MIN_SPI));
+		GUEST_ASSERT_EQ(gic_get_and_ack_irq(), IAR_SPURIOUS);
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
+
+		do {
+			dsb(ishld);
+		} while (READ_ONCE(args->shared_data) != REPEND_PRE_ACK);
+
+		GUEST_ASSERT(gic_irq_get_pending(MIN_SPI));
+		gic_irq_set_pending(MIN_SPI);
+
+		WRITE_ONCE(args->shared_data, REPEND_PRE_ACK_DONE);
+		dsb(ishst);
+	}
+
+	GUEST_DONE();
+}
+
 static void *test_vcpu_run(void *arg)
 {
 	struct kvm_vcpu *vcpu = arg;
@@ -1073,6 +1212,7 @@ int main(int argc, char **argv)
 		test_vgic_two_cpus(guest_code_asym_dir);
 		test_vgic_two_cpus(guest_code_group_en);
 		test_vgic_two_cpus(guest_code_timer_spi);
+		test_vgic_two_cpus(guest_code_level_repend);
 	} else {
 		test_vgic(nr_irqs, level_sensitive, eoi_split);
 	}
-- 
2.39.5 (Apple Git-154)


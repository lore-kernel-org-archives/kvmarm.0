Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9371A397B09
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 06:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786344758; cv=none; b=uus1zsF5MSYKb1VTQZCi3+P0FXcsxM7ec3KLzSWHR1OokjVNxAevYySk5HNiGI7Ai49mXoiJNtac28tM+Pkm8uu3b4Vuv0X4XVnrzm5OFJ+MyD88+xGgCH7E2vfSh9j4EbYs7wx2Iu5RZH26SepTrg69EbvN9lKeem/2/Iw8m2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786344758; c=relaxed/simple;
	bh=GUNh6H4wQQPS1pj5SNgH2nk098iFIpijKEKdRnV6amM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kjZYVIXlF8FUBONudUwsW8+3oJe0WNumaIq/uY86dsrdW5Jq6ckzmjoCj///r/kMMUojlKtfGXrFnMjJZOSpbDCjKIH+9bzBAz9973KroTiD95YmBNuT97UDzxXZXwLQEUC01xorh6VN9hsKP5TZDKR6fhK079yPrPhTxX0XkDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B1INRcji; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B1INRcji"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495757ccbc1so18853905e9.2
        for <kvmarm@lists.linux.dev>; Sun, 09 Aug 2026 23:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786344755; x=1786949555; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OqEuJEoPbKvmQ82yf9uvBWxpPYFbSngty6vt/ZB4aZ4=;
        b=B1INRcjiNc2u5B5evBi2j0m1K7f/rcfvqzFu4nceOLg1nwbckL5JaXyJq5KrlOs73U
         u8fhrXC7j2p3HKn5GbrrHz1Tz6p+ddCLzNsD4yT4Ez41p84dPXYAG+19bfDqewbjUp6E
         mPqOYwSWbbxPYGSgz8Fb5jWPsaH5REt6Yhya/T/BjPsBxTn5f/8hrZiotcPodF/d0rHX
         G8EeUAZ98p0irBtl5AdnCo5PDCaWlv7+UdL0rDIvxWqpY/TogfPvawVB24vJNcsm14Ck
         ohgZl4lBU930xr7OPEcXIzZA74jDAKoTg8qBENdDHM6xXaOUxS5lBD5thpvbNKcaG//z
         f4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786344755; x=1786949555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OqEuJEoPbKvmQ82yf9uvBWxpPYFbSngty6vt/ZB4aZ4=;
        b=pVsiq8E/EF1Yx55rSIm4jC1SUEbFmPcRL6pgZ6osOQ/GG0yKG9/WMzBNtLZdho849x
         vDN47nKalBGNA8oNo77km5NQYylCqwNEPG93+mQ1nqRTP7metet5jed/c40Gv86DbjDb
         f0YHDjAvIdSfruq0kGo854QW7iU6z5Q3VuIeEn3bMgicEYGFKeb3QWPc+R68aCEYocmj
         bw88aFPjSjcBx1y56OeNggJX4pAIQYV7nZA+PaAzPEXR0dXdhLWkE/ounvQDTHZ6rgmq
         B6qlw2QBllhkQOkTjy+8dHBf6dPV9BvjB6uK9KJLcZ8hM7mduXtxS2W99TKTpWLCOP0a
         tWqA==
X-Forwarded-Encrypted: i=1; AHgh+RoaheSKCR17Gv2jCHzo5u5m1NvKsIFB/EnTbXjcne7/AKcZ41Dv0nWyz8tU9TOVHQfriV75HZY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKUKYXQOFMxKVfVHi8itz3hrrfIyIyO74OUN8MRC9PC49XMcM7
	3lhEnAhpQue7oFqe1uxH4LE52IxIMFq4ofaZb+eAQ5+epZDrb7WmJmBc
X-Gm-Gg: AR+sD119psRFUNHZpmZFeeOundCJlTZtuf2T2RpEK9CJuoCuyb5Pw3iD+zkIVD1oFr1
	D7DRJNy2Ie1QaBTi6hTcNvEQlTL+pmUBKqHG4Z604rz6UczReHlTf2fjkNWYqYfzyEjghU2af0i
	QN3eQ/G3TN2gWgL5mZY1sTRgNl7ePG5iOO51zopJ5+UcmsNaEMFq8w2OlkRW5wyhf4XVoVtDFHV
	xaw6KfrA44t+DrrTKqFkwbo8IqoG1Oqq3QdfJwpLbUMXmaXAliuiXSvuDqiUZKNUYVB/TbrK4RX
	QpTZhUpEXGG9pCoi4fMUUdYVII3C0FrUamVXY6wH5NZTTAVS2C/59PxAn+wTTLyq5vj87d2EADk
	OXrzKUJ1Tla18JoR5uKcV4nfpi9YG0zhN0XHaGHYyn6om6atppdWh97/ChG1pgEsHpVaTey9FuM
	TiXxrDue51MaKIOopfzYa2RxTnKvROM/9GoYSjIk463qKaNhTdQoZd6nJPmx3k+J4L+VfzIbtsD
	x8Wc4gpFmBrGywI8GBdg2eVnL0spdQKpZi3BCWTUvw2h2UDlPhsmTbtzrkDf+a8z0g4ZO2dTgCL
	otRNVS5s+3eSfbU7lvYmTj1QbQlDt0XlerPARvqrWCbvQnRsLMrSfND0qSqQ5BjsoBNujhUWrqm
	2ag==
X-Received: by 2002:a05:600c:c4a3:b0:496:c1f3:e8f8 with SMTP id 5b1f17b1804b1-4994e71eaf3mr490380035e9.7.1786344754823;
        Sun, 09 Aug 2026 23:52:34 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-a1e8-7401-78b1-a175-5d13-e92e.310.pool.telefonica.de. [2a02:3100:a1e8:7401:78b1:a175:5d13:e92e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995420c68fsm358800705e9.1.2026.08.09.23.52.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 09 Aug 2026 23:52:34 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 1/2] KVM: arm64: vgic-v3: Roll back failed redistributor region setup
Date: Mon, 10 Aug 2026 08:52:16 +0200
Message-Id: <4e00fc25aa61ec52e6ef033a53588ce3f5550982.1786344511.git.kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <cover.1786344511.git.kmehltretter@gmail.com>
References: <cover.1786344511.git.kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A later REDIST_REGION attribute can be inserted successfully and then
fail while registering redistributor iodevs. For example, a region that
overlaps the distributor is caught by vgic_v3_check_base() when the first
unassigned vCPU is processed.

The existing rollback unregisters all previously registered
redistributor iodevs. It leaves their rd_iodev.base_addr values set, so a
corrected retry skips re-registering those stale vCPUs and succeeds with
holes in the MMIO bus.

A failure from kvm_io_bus_register_dev() can leave another hole. The
failing vCPU already has its base address and region assigned, but the
old i < c rollback does not include it.

Preserve devices assigned by earlier successful setters. On failure,
unregister only vCPUs associated with the newly inserted region, clear
their cached base addresses, and free that region. This also includes the
current vCPU when iodev registration itself fails.

Fixes: c011f4ea106b ("KVM: arm/arm64: Check vcpu redist base before registering an iodev")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 42 ++++++++++++++++++------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d83019..832a7fe65984c 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -841,6 +841,31 @@ void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
 }
 
+static void vgic_v3_rollback_redist_region(struct kvm *kvm, u32 index)
+{
+	struct vgic_redist_region *rdreg;
+	struct kvm_vcpu *vcpu;
+	unsigned long c;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	rdreg = vgic_v3_rdist_region_from_index(kvm, index);
+
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		if (vcpu->arch.vgic_cpu.rdreg == rdreg)
+			vgic_unregister_redist_iodev(vcpu);
+	}
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		if (vcpu->arch.vgic_cpu.rdreg == rdreg)
+			vcpu->arch.vgic_cpu.rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	}
+
+	vgic_v3_free_redist_region(kvm, rdreg);
+}
+
 static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
@@ -855,16 +880,6 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 			break;
 	}
 
-	if (ret) {
-		/* The current c failed, so iterate over the previous ones. */
-		int i;
-
-		for (i = 0; i < c; i++) {
-			vcpu = kvm_get_vcpu(kvm, i);
-			vgic_unregister_redist_iodev(vcpu);
-		}
-	}
-
 	return ret;
 }
 
@@ -984,12 +999,7 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 	 */
 	ret = vgic_register_all_redist_iodevs(kvm);
 	if (ret) {
-		struct vgic_redist_region *rdreg;
-
-		mutex_lock(&kvm->arch.config_lock);
-		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
-		vgic_v3_free_redist_region(kvm, rdreg);
-		mutex_unlock(&kvm->arch.config_lock);
+		vgic_v3_rollback_redist_region(kvm, index);
 		return ret;
 	}
 
-- 
2.53.0


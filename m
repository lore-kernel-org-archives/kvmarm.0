Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792808698;
	b=XVLIsVvCzaezAv0QxUDWaCPoC2zl8a6mR0kA+6qFtTfKFo+b9/OVzAZ4aAzFkpUfkD0r
	 p7VF9Pmk45MgLtuDnQHTyXI1pdz50Xx6obU+p5CAmy5SrIg5g5cIdm/OjpHBB/nTVGuPt
	 MR2PMvSYsviQg2gFMUeSx/dFZGbhvx7eTQPoExDreO61kaRDkJbo8o1gYP9O94XG2MbEN
	 IYYnsNyjG6ouxYqeHTLL6jBP85qIbnjcDPWhIsrWOUrAr2MoyrHDHYIAbm44Ta29nU1ua
	 9khzLfHMfxyZJVg8F6MIekouRim+OGMhXBQyc2w2xMBurquYewo/j3rJ6ChFgoW2G7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792808698;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=An84VwlzMp3GuZLx6HMKZAlMwrBtzJQu2yyoAEx9ZZk=;
	b=ZNkrDbKJdvzGd3Bi2fdP/PUNN+eaaTAMHuAMvowWFt6LmZXAda4INMBhbN3RDiIvYtea
	 xzoYlKdokIbT21J5q3y1Y/oSNSsROaLhIcut4d0g/UQFaC3Oou/qAa23NxD7Wr6jNG/9T
	 IWN0OcBu0fwO4izUZyL8IlRdnFw8EORymGbJBKElEMLAzT5farboYb5X9zR1Sdqi+T4Wl
	 IR3yXwzplpwbvXbcopsAgU3aYepDtWuxWUCsi7NtP3ca/rWngZrUUL0vk8KKtjX0n5s4i
	 uIXnQytFqvLA7+ep4WyXq3RF2wNxwn4X9S/2O1mOks8FSr8o+Dg48YoiFIwv8GMlmQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Zdbkv1Vs;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243ED606A31F
	for <kvmarm@lists.linux.dev>; Sat, 24 Oct 2026 02:24:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 243ED606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Zdbkv1Vs
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso1751105e9.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 19:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792808697; x=1793413497; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=An84VwlzMp3GuZLx6HMKZAlMwrBtzJQu2yyoAEx9ZZk=;
        b=Zdbkv1Vs3PFI22qzHR/Oq4iYPYqAC5ij8vBGeE4Gfm+qAkiVPk53J/g63/NYaL3og3
         jhaHxVwUTI0p0mLOYY0g0Y1afn8WKwtKBqDKVGmtVFpzePzTY2EQxsIW7Jy2bIlru3ml
         4vqc91eMPnE3J2S/L6jAtpMNEeciYFAfs/hLlPIsoFRhO+OV8QwMQOy754eFj3H/6YGl
         oNj/7BnY0/Yz0UOiDYqA/6sXd4AmHNegG6/ECyQceDUIP0UQTaPhMeXlFbjUznFI5gX6
         gCnAZ0HHtRvSNhwl1kPbvTJ7Gct1wlYxK4f32AwCVmDBtDKTN8JDLNL4Bbp2Ze8FfPvV
         odxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792808697; x=1793413497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=An84VwlzMp3GuZLx6HMKZAlMwrBtzJQu2yyoAEx9ZZk=;
        b=LEXN3amN+vP76Lcv0Wz2+pveGkhGlUl+rR6GxZ2ZxrYGbuaIwiKZJYH/1/lKO2EhLj
         +mzMii8wxLH7+iNrI3vwezg9UeMqRWUMs6AmBucYy4bRyLu+C6YT2F4sXU73RoOUbwFN
         oBiiaTg/gWdIejvQ6X3Bw/0ZDOa+z1HjgEhUryccFOJAdASgJYvy14Rvcd3GrJoFivoe
         dvdSoH/vRTMMx0zD1LPEzjlwHuTYI1fAkAisUpHBZmBh1WHt90mHt7r2ABXb/af5p2yi
         ll0FbuQjmK5xSmxZ9GjZMtawpanWNd3cVFDssZxE+YYeQmOHMNDgOtdNVMWEFbgUUkXm
         qWCw==
X-Forwarded-Encrypted: i=1; AKwUvBwosWCw+kxuVx6j4TpGitM5ecJKQFzQIcXGsj9PKwjqKAHEEbZHc/xl9Kx31X8ptJfjmSPaRkU=@lists.linux.dev
X-Gm-Message-State: AFq9FYIbtyOpB8wtxlN9Mcu4NG1xzytUGeBbn8DaPauSH/za0WRn+FXS
	F36W2U4ql5wZvkpGrD/8fHVqPltZWun7pomLv0vBtZtO3KjoqZo49clg
X-Gm-Gg: AYBFou2G0meXYno28Ph6EogmpxY6AX9NnnrKC/60ZtbeySKlbnv65T7xuwAGAdbTMrn
	0B4NQSYKZYxn8BO/RGJp5n+V2f8G1xcxZp6ZpAl4yC3TqqX04RQaWifTo5vM9ckJS2zK9Vq5QnM
	LNv+TSONBp3avT0lQE1IxPl1BRUGfxFmvBGmqv3PVPhOP098DgZD2D8VxuR7eNaF5weTCBwQBKh
	yWa+0JPky7i7NUy4fPyuHzQlzYweOBf3x7bc08Adz3AfY5IdejOIFmk8DcGBwXCha6Ktc8maDL/
	a4tdQtB/+fw9hDS6cbD8tuXep7znBl8fV63vc8fxjDdOp+oqeO1r6LiRh8LUnTog5BE+r1QSLtZ
	tpeXiMV+bW7vui46eD5FxkKX6KjPG81sDPDdEgvzNEajGawwAsnzP0gV4aQfAigxHmith5sFkuH
	gHEjJ8AnFboUv3c/IC16AetUY7p2vMQu3TH71U7KoXHJlZA2us34uvTEXk8xBMjqFmtyzxXdW2N
	KgFWfbwd8qvt1U9IoLSlParzYHma3d9CokBBPGCPB1DVu+BPeDp+iuey5Y6XugFuqWoYXCnvvF8
	p3d+1w8gB7Xrg8gnWgm35TXowA==
X-Received: by 2002:a05:600c:6384:b0:4a2:526b:d410 with SMTP id 5b1f17b1804b1-4a35aca72e2mr9122565e9.13.1792808696426;
        Fri, 23 Oct 2026 19:24:56 -0700 (PDT)
Received: from ASHA ([2001:630:3c1:164:1a66:daff:fe85:4026])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a5698f1sm21088415e9.8.2026.10.23.19.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 19:24:54 -0700 (PDT)
From: Amir Noohi <amirmnoohi@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Radu Rendec <radu@rendec.net>,
	Igor Velkov <iav@iav.lv>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <cdall@linaro.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Amir Noohi <amirmnoohi@gmail.com>
Subject: [PATCH 1/2] genirq/manage: Provide irq_set_percpu_irqchip_state()
Date: Sat, 24 Oct 2026 02:24:49 +0000
Message-ID: <20261024022450.629980-2-amirmnoohi@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024022450.629980-1-amirmnoohi@gmail.com>
References: <20261024022450.629980-1-amirmnoohi@gmail.com>
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

irq_set_irqchip_state() acquires the bus lock and the descriptor lock of
the interrupt. A per CPU devid interrupt has a single descriptor for all
CPUs, while its irqchip state is per CPU, e.g. each GICv3 redistributor
holds the active and pending state of the PPIs of its own CPU and GICv5
keeps that state in per CPU system registers. Callers which modify that
state have to be pinned to the CPU anyway, so the descriptor lock only
serializes CPUs which update their own private state.

KVM on arm64 sets the active state of the host timer interrupts on every
vCPU load, i.e. on every KVM_RUN ioctl and every time a vCPU thread is
scheduled in. When many CPUs load vCPUs at the same time, they all spin
on the descriptor lock of the same interrupt, even when every vCPU has
a physical CPU of its own. A global serialization point on the same path
was removed before in commit 64b6d1d7a845 ("genirq: Get rid of global
lock in irq_do_set_affinity()").

Provide irq_set_percpu_irqchip_state(), which sets the irqchip state of
a per CPU devid interrupt on the calling CPU without acquiring the
descriptor lock. The irqchip callback is still invoked with interrupts
disabled. The caller has to have preemption disabled and has to ensure
that the interrupt is neither freed nor reconfigured concurrently, which
is the case for an interrupt it has requested. Interrupt chips which
require a bus lock are rejected, as the bus lock may sleep and cannot be
taken with preemption disabled.

The function is not exported as its only user, KVM on arm64, cannot be
built as a module.

Signed-off-by: Amir Noohi <amirmnoohi@gmail.com>
---
 include/linux/interrupt.h |  2 ++
 kernel/irq/manage.c       | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 3bf969ad8fe0..ab20129615d4 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -507,6 +507,8 @@ extern int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 				 bool *state);
 extern int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 				 bool state);
+int irq_set_percpu_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
+				 bool state);
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 # ifdef CONFIG_PREEMPT_RT
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index bdb47837c66f..e76fe1cec9fb 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2777,6 +2777,42 @@ int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which, bool v
 }
 EXPORT_SYMBOL_GPL(irq_set_irqchip_state);
 
+/**
+ * irq_set_percpu_irqchip_state - Set the irqchip state of a per CPU interrupt
+ * @irq:	Linux interrupt number of a per CPU devid interrupt
+ * @which:	State to be set (one of IRQCHIP_STATE_*)
+ * @val:	Value corresponding to @which
+ *
+ * Variant of irq_set_irqchip_state() which sets the state of the calling
+ * CPU's instance of a per CPU devid interrupt without acquiring the
+ * interrupt descriptor lock. The descriptor and its lock are shared by all
+ * CPUs while the state is not, so acquiring the lock only serializes CPUs
+ * which modify their own state.
+ *
+ * Must be called with preemption disabled on an interrupt which has been
+ * requested, so that the interrupt chip hierarchy cannot change
+ * concurrently. Interrupt chips which require a bus lock are not supported.
+ *
+ * Return: 0 on success, a negative error code otherwise.
+ */
+int irq_set_percpu_irqchip_state(unsigned int irq, enum irqchip_irq_state which, bool val)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_chip *chip;
+
+	lockdep_assert_preemption_disabled();
+
+	if (WARN_ON_ONCE(!desc || !irq_settings_is_per_cpu_devid(desc)))
+		return -EINVAL;
+
+	chip = irq_desc_get_chip(desc);
+	if (WARN_ON_ONCE(chip->irq_bus_lock || chip->irq_bus_sync_unlock))
+		return -EINVAL;
+
+	guard(irqsave)();
+	return __irq_set_irqchip_state(desc, which, val);
+}
+
 /**
  * irq_has_action - Check whether an interrupt is requested
  * @irq:	The linux irq number
-- 
2.53.0


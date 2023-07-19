Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9126A111A9
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 17:54:05 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-573d70da2dcso64396337b3.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 10:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689789244; x=1690394044;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0kxZ4Z80lUcSFdp3GgQl/jQwBGNAtEogOtDD6DT+le8=;
        b=NdNKIYqEldjUUQV4h+XNM1ILmBpma9z9AEdBtYn1qcrFOenwJmBXrHw6mTbkprQj8p
         r+YtkbikqlLfJdQZIoTiQv/TZpBxRXEg0gSoK35Ky48bcLRFCn0Qj0DsnXRublL7LccU
         VbZhu6d+zj+n5OuXYLNNjo3SaPP6NC8/yNGWRhVbEHVJlHuLX5Gsll/rQ8aLyHWCbZUs
         /8pD6jrn0k0jGKj8o91kas/Vof7SZ7T7M6Y8JVFS9L6EnZODlq5wuOfEPi4IxaVWx6IY
         g0cXiBg3AzBUjksD04dElZ9FVrB9vd1h8Wu2ap7UEulstmwA86OoTJopktyhvQXeMD9s
         GkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689789244; x=1690394044;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0kxZ4Z80lUcSFdp3GgQl/jQwBGNAtEogOtDD6DT+le8=;
        b=W2ifwPJeDjVKpkyORamLGcNsEGZk6JC9vN/biwyYWgucz0nMmkeOSkW9ieXWNKBfbB
         StmQ0Y7AxsOeYBYXpRmtIY9lIYtHG6F4IKJxw4C9MntA1DEZ3rMJoTdLSwdxxmoqVPZO
         Slr4bH9a4k+QI+3YTY6IpAF5Lk6Z2sVPc2e8w4fhGrNfTeyR4mOKSs16rX1NXQ4VFnYV
         yFfi9RfIfnYlWNbLqN5AeFfxVSuAK5u5G8yRhRqS+s5RDRv5ujbqq7PnlCC26dTV/SYg
         MT3llkPUT9hPGbJ8jVUF27azBvj+cvlvwy2a/FTi+b2Wet7PalC5BOLbEyLqUSKnMHHZ
         vJKQ==
X-Gm-Message-State: ABy/qLY/t7OUzz+jmBukLP99LfKiT8qu60wgwDPQTga/8giP8/wSyn8H
	Qpx+LCKbHqEKsepTsh2gwKxjV6Zn+ENE
X-Google-Smtp-Source: APBJJlHzC655GgaoeeexqmchzYWVTbKP9Ygbn4QXSHn76tJOWPJ5nIAjVrvG3mrJnq+Ot9jVn2qgg1kU3KfD
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:d00a:0:b0:56d:502:9eb0 with SMTP id
 v10-20020a81d00a000000b0056d05029eb0mr34446ywi.6.1689789244409; Wed, 19 Jul
 2023 10:54:04 -0700 (PDT)
Date: Wed, 19 Jul 2023 17:54:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230719175400.647154-1-rananta@google.com>
Subject: [PATCH] KVM: arm64: Fix CPUHP logic for protected KVM
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

For protected kvm, the CPU hotplug 'down' logic currently brings
down the timer and vGIC, essentially disabling interrupts. However,
because of how the 'kvm_arm_hardware_enabled' flag is designed, it
never re-enables them back on the CPU hotplug 'up' path. Hence,
clean up the logic to maintain the CPU hotplug up/down symmetry.

Fixes: 466d27e48d7c ("KVM: arm64: Simplify the CPUHP logic")
Reported-by: Oliver Upton <oliver.upton@linux.dev>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c2c14059f6a8..010ebfa69650 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1867,14 +1867,10 @@ static void _kvm_arch_hardware_enable(void *discard)
 
 int kvm_arch_hardware_enable(void)
 {
-	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
-
 	_kvm_arch_hardware_enable(NULL);
 
-	if (!was_enabled) {
-		kvm_vgic_cpu_up();
-		kvm_timer_cpu_up();
-	}
+	kvm_vgic_cpu_up();
+	kvm_timer_cpu_up();
 
 	return 0;
 }
@@ -1889,10 +1885,8 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
-	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
-		kvm_timer_cpu_down();
-		kvm_vgic_cpu_down();
-	}
+	kvm_timer_cpu_down();
+	kvm_vgic_cpu_down();
 
 	if (!is_protected_kvm_enabled())
 		_kvm_arch_hardware_disable(NULL);
-- 
2.41.0.487.g6d72f3e995-goog


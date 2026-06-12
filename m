Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A68392806
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 11:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264059; cv=none; b=kh7csS2HjQGtr4wcVdMpQaJR2614wLXpUX4INeYWrP5NF2BdcAoQFc+l5as0QuCGQlYrlEs8rFLudKS+winqlJ5EC1kz0hGNN6rU4eBCGxKxm1ryMODyUhQKlxQTJReR033N7PIkJrYy4cBt2f03dOZ7JYbeodBpqEruxnn5CAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264059; c=relaxed/simple;
	bh=39WpqfsqMXIC7gz122vRXwFEhrpbSRz2/WCB6ufDKeg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZkUuoawkeGyhlgIPjxNNahtCsl2nnkdjDjIBG5uzMtyn7AuxLKBX22iCZJTThD8xV9RE9f8j5/wvNqtYoF6YtFC7FIbqG9QBNE5LVjuUNZfkihttcqZjDeN75bxgtSAbItggi+cJARJmZ8MH6jVMDIhqfVuFO9BRJ85AP2+Vbgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BdJT5aFB; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BdJT5aFB"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-68d9309b510so741020a12.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 04:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781264055; x=1781868855; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xa5/25SiNRkAqSjzYKvz46uYWaA8u0CL9trp73+tAk4=;
        b=BdJT5aFBVheWxJFI8qUgAaKbb+Wnl855uF2tweBiPuSCv2ObQJ/Klv/uAuuYKjqvE9
         oVM/vSCzi51fN1/c3J6JqnZ8bWDER0i5pQcM9WUgeWuji1D2ewZrb940a/W5a+rZWc5k
         qpZ6SVf0U4a75LignVPtaArmCoGfX2YS+vxkgfJ3lmSn9EOtAbmZdY7KpiE4j8XzZXoq
         jqWxcAcsWQ2ij0tOkwbDEnwUFq9VF36zg5hoCL5pjiXoWR5XE2bZtr9iD4Wp2BBGuaNq
         aCLbppjTRXT1Aov6ljBKEC3mbofAeATD+kJS6R7wZ9AoMQ+ikIzalh1QBTwL2/RLssGV
         Vkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264055; x=1781868855;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xa5/25SiNRkAqSjzYKvz46uYWaA8u0CL9trp73+tAk4=;
        b=NogXWEphL3WJuXq88cLZJMJ2ruUJVYhQOjksVg8gq9TGzQ/WdH8uWZlzNd4yRb6y/G
         l8WHftibSA3NSsm8rR277syN9yQJaeiLv4R4bvTPHXHQMqWspWaua4grNkHxD85q7gUq
         vLCpvCKoMZrWovcu03gCQG6jbpxUmkuy3wePXTomnciefeP4ZNXPHc0eVK6RVbpEQ2nK
         MIJq55TZEDwO4v5GgOMGXvyiUE5fK/JSlaDa7P0QPm3ChJuMWsGWtZtUYf8oSclq89Bu
         SpPyy77WXyegj1+wIkpzhNTACXER8RFZ4ajbhlLWvy9bCmA5uZilaBftWybExasfpG8w
         wJOA==
X-Forwarded-Encrypted: i=1; AFNElJ+tnf0Q82Ks4r6AEQ2hFWi09ouKHEC+OLOAAasW2mNio9rZyy22YRTzgi6lD0/7J0bw7me99eQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YybaFgw4E15ohnsfdKRs/Dsqj1sP1HRu/cYrCq0xAj82fLsZZFm
	lXzNmX3CPLdqEQQsPOJHZriSOl2i47nN7jfvXwqM0zhM+MX/R+zwrqN8WGtBcINMamqZmfchRgP
	mKg==
X-Received: from edber23.prod.google.com ([2002:a05:6402:4497:b0:691:acc4:471e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3607:b0:691:956a:cf6a
 with SMTP id 4fb4d7f45d1cf-693785fed15mr1080488a12.12.1781264054903; Fri, 12
 Jun 2026 04:34:14 -0700 (PDT)
Date: Fri, 12 Jun 2026 12:34:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612113414.1022901-1-tabba@google.com>
Subject: [PATCH] KVM: arm64: Sync SPSR_EL1 when injecting an exception into a pVM
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Andrew Jones <drjones@redhat.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When pKVM injects a synchronous exception into a protected guest, it
re-enters without restoring the guest's EL1 sysregs and writes the EL1
exception registers to hardware by hand: ESR_EL1 and ELR_EL1, but not
SPSR_EL1. enter_exception64() sets SPSR_EL1 (the interrupted PSTATE)
only in memory, so the guest's handler reads a stale SPSR_EL1 and
restores the wrong PSTATE on eret.

Write SPSR_EL1 alongside the other exception registers.

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Reported-by: sashiko <sashiko@sashiko.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8c3fbb413a06..1a7d5cd16d72 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -268,6 +268,7 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
 
 	write_sysreg_el1(esr, SYS_ESR);
 	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
+	write_sysreg_el1(read_sysreg_el2(SYS_SPSR), SYS_SPSR);
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
 	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
 }
-- 
2.54.0.1136.gdb2ca164c4-goog


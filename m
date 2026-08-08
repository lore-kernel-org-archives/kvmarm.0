Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15B436197D
	for <kvmarm@lists.linux.dev>; Sat,  8 Aug 2026 08:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786179517; cv=none; b=NQjNOsZZwoluRqXagSLeJ/Ef+R5mXoaop6k9yxpDzQQVlptY1kA6PrI9+Di5P9xxHOWrJ/FmDRG9ikUuchk0rTnqT1r00Zb9zMvPLcZSwIyE+QIjat01BQe5hvxGM/N8c/4dE7sqx7NKQZzqK4H95icd0ESYu72+ef5MeNNmUh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786179517; c=relaxed/simple;
	bh=yZk+++kSee3JvNzACwuptz4ROqE71reOY1As/HQTYeY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PLJLnn8HIMU8G9ros/lGhQq4Qrxnnry/qIbK7imZDMhzGaPGh2btXuGgh85w1fbUg70GbYCklYQ45zzVBS/iFSuB5TkUFXeUQVArhS1FQWSTYK5a1g0XJDiAQjVqZ20jC4Lv4wAuXW3YTzv7SIqAx9zfOFY3c11xP91e2QQsElY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GI7y0jVB; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GI7y0jVB"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f84ac1990so195105f8f.2
        for <kvmarm@lists.linux.dev>; Sat, 08 Aug 2026 01:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786179513; x=1786784313; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=56TnglbK1xrAvqmnbHBS7x8Hfawflf/2HSwwBboYSo0=;
        b=GI7y0jVB9v/FZTCGqERTzrPyGSZwaIGTrhn4zO0iae9eo32stfnmqASTgmiHREr1S3
         8p0YymeH9Ys9+rU00hIEDKbvXVOc5eHSHgiP7FzujpKynx3f+jfWh+21ScD3Oo7636dL
         PkgQTWo26pg9zYuR1QcUr323A8i2bVJAgumaNTNhslz7VBj0C1Td26TFNTAwRoz8fJPb
         WOb3JVGrpicwIt9su/BEIWB4uMTs+IDIDZEUMWr5QXu+uDg7ofnXMhsVqZQ45tQAjG1T
         NwB15u8flGAJ43Pq/TD/W4BowcIp8ITlcAFXXPZn3hxO3kWk96ihaacWx8OoeodojhK2
         Rz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786179513; x=1786784313;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=56TnglbK1xrAvqmnbHBS7x8Hfawflf/2HSwwBboYSo0=;
        b=o2bbs9o18MEA+PZbCK38O8k6W9/kxcj/aBc0trKs/AQ/6xlKGfNVXjANYY6e464ogY
         pCdVU/ZOSNsPtTcT/zB/9Vy2lnT0cIDOcYqChU240TysUXVwItUmy8PKchgV6On7JxpW
         7NqBpS4JMi3Eenb59TMiO61HaLtA09jTWfxTPcQmLv67u1fYGyWXj/0ZRTGXQd1y43pr
         0FEG5EGxRCpapd59HCApHg9UQVJYuj+M8E2UApq2XdGpVN+fhkvg/XWz32EujrBCWDso
         HfLEAS3mERiqDF8uM73aM7QJua/ratmXxkYy/cHr9INqKn6/8DofnQCb0iHRU8c/5ysm
         hviQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqqg0psudvDsQrcN6PxPzAJ/JG1wOgsaAtDOhUOnaaTcTytQfT4Q5roxGPeO2W8vjWXSKC3Iqw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVBQmD/z13TqoLbo/GGR5/RBlg/W97jXKrkp+Sd3WcNIUFqYJJ
	Osyo0CpToJNJPhsvf3D1XAbhpKIgJLW9quX0QzaPwvB7xaU0LTcgH3uILvXbfAZq44RNvazVLv5
	E7jUqmh7DNS6LJQ==
X-Received: from wrqv10.prod.google.com ([2002:a5d:4b0a:0:b0:47f:586c:8371])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46cc:b0:493:bd2a:93be with SMTP id 5b1f17b1804b1-4995e085347mr124527135e9.6.1786179512744;
 Sat, 08 Aug 2026 01:58:32 -0700 (PDT)
Date: Sat,  8 Aug 2026 08:58:23 +0000
In-Reply-To: <20260808085824.732659-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260808085824.732659-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260808085824.732659-3-smostafa@google.com>
Subject: [PATCH v2 2/3] KVM: arm64: Fix timer offsets for non-protected VMs
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	yaoyuan@linux.alibaba.com, Mostafa Saleh <smostafa@google.com>, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

With pKVM, protected VMs always have offset of zero.
However, timer offsets for non-protected guests fail to take effect
for two reasons:
1) In __timer_enable_traps(), enabling of traps check for
   is_protected_kvm_enabled() rather than vcpu_is_protected(vcpu)

2) The vcpu timer offsets were never initialised and kept as NULL.

This is problematic for cases when the timer is trapped in the
hypervisor as the with the case of broken CNTVOFF_EL2, which leads
to the hypervisor and host using different offsets and causing VM
hangs.

This can be confirmed by running the arch_timer selftest which fails:
./arch_timer -o 100000000
Random seed: 0x6b8b4567
Guest assert failed,  vcpu 0; stage; 3; iter: 0
==== Test Assertion Failure ====
  arm64/arch_timer.c:137: config_iter + 1 == irq_iter
  pid=310 tid=312 errno=4 - Interrupted system call
Guest assert failed,  vcpu 3; stage; 3; iter: 0
Guest assert failed,  vcpu 1; stage; 3; iter: 0
==== Test Assertion Failure ====
  arm64/arch_timer.c:137: config_iter + 1 == irq_iter
  pid=310 tid=313 errno=4 - Interrupted system call
Guest assert failed,  vcpu 2; stage; 3; iter: 0
==== Test Assertion Failure ====
  arm64/arch_timer.c:137: config_iter + 1 == irq_iter
  pid=310 tid=314 errno=4 - Interrupted system call
[...]

After the fix:

./arch_timer -o 100000000
Random seed: 0x6b8b4567
PASS(vCPU-1).
PASS(vCPU-3).
PASS(vCPU-0).
PASS(vCPU-2)

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: cb0c272acebd ("KVM: arm64: Initialize the hypervisor's VM state at EL2")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 14 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c |  6 +++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 24d6f164129a..89f3d5fb55ca 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -529,6 +529,20 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+		/*
+		 * Timer offsets are pointing to the untrusted KVM copy,
+		 * which is pinned in __pkvm_init_vm() for the VM life time.
+		 * It is worth noting that hyp_vm->host_kvm points to an EL2
+		 * linear map address and timer_get_offset() will use
+		 * kern_hyp_va() which is safe as it is idempotent.
+		 */
+		vcpu_vtimer(&hyp_vcpu->vcpu)->offset.vm_offset =
+			&hyp_vm->host_kvm->arch.timer_data.voffset;
+		vcpu_ptimer(&hyp_vcpu->vcpu)->offset.vm_offset =
+			&hyp_vm->host_kvm->arch.timer_data.poffset;
+	}
+
 	ret = pkvm_vcpu_init_sysregs(hyp_vcpu);
 	if (ret)
 		goto done;
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index ff176f4ce7de..51b4f5010b66 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -45,11 +45,11 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 	/*
 	 * Disallow physical timer access for the guest
 	 * Physical counter access is allowed if no offset is enforced
-	 * or running protected (we don't offset anything in this case).
+	 * or running a protected VM (we don't offset anything in this case).
 	 */
 	clr = CNTHCTL_EL1PCEN;
-	if (is_protected_kvm_enabled() ||
-	    !kern_hyp_va(vcpu->kvm)->arch.timer_data.poffset)
+	if (vcpu_is_protected(vcpu) ||
+	    !timer_get_offset(vcpu_ptimer(vcpu)))
 		set |= CNTHCTL_EL1PCTEN;
 	else
 		clr |= CNTHCTL_EL1PCTEN;
-- 
2.55.0.654.g21b8a5bc05-goog


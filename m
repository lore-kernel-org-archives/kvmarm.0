Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795427282;
	b=lLnzWmlDytr5jNEcVDFI100pgR01oNvFbJQFpc3qgpZxrPJC5KEIUVwcdj2rMHwDGL2J
	 UoLC05lq7D6PE4kDn0jqXG4LYNAo4FsEpfXhBulTfW3h70JVMCOOxBnT/LMpRgFNzdd9F
	 DJQHif6UZte+dsJ5EVMXKMf0vWlreOhZldMA3xVWRRE1rz1B41hb9M+2EGIGQmS5G2Hrx
	 v7C2lLg04BITpZ9j1j5V5sJH7nbj1ndNn8xgMKJOtUXAot2GBvJsQ62mPeiLqOYvdRJ/D
	 Nz86KAYWtsec/vKNGAyUNUBUsTZX/F4coM3NJ+K94fOd2rIaWWP0J3rH1ggMTI/AuKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795427282;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=xXoaW7puZQVXtPvVEP8J871ckV5Jm7nnXRP/lyhSBaM=;
	b=KeOafI5A941G2GUiQxpYBIfyM17jMmU21KFRl0RBPa4HE4MtBW4A5p/dwcXDhLg8OIQT
	 0qc/QGac7qVganxA3ePrH8Q2PSoZ6NyEc1Kp9Tf6ihlaQrJR6rM4nLKPL0fD64zHecdco
	 5eG24Raww1+gix9XPkELmNegyY8ifY9O1RpUmmolaTh981k/eUBJq8hgJG0HjgI+9HZcf
	 86dC6ss8Kg062vyqjgZVerrAML6Xsgh6TM0Y8lX3qnWej+08hsv9RPjYU7Wrs3Q86Acdr
	 3E6ugoiqoRKHXIuJD8LPdEFWcbTfz0WTo/1hUhAInvyEgz7g9pmW/mKHbZ78PaWF34A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=K4VKNPrw;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE4C606A31E
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 09:48:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABE4C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=K4VKNPrw
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4a32576da88so1734156f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 01:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795427280; x=1796032080; darn=lists.linux.dev;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xXoaW7puZQVXtPvVEP8J871ckV5Jm7nnXRP/lyhSBaM=;
        b=K4VKNPrwTHdjCFjTk5Iioi5USn9wEkP9gSvz1Z9agnah2dZy48ulSQK/Jm8ysB89Ny
         0jg/aiIc7aKq2N8FwwM7hZTmy2F3TPjy1nLrZVcSNXoTuRo4MfqAIyAiaKFdYyIFAEPu
         Leism+k4v/XXQ4SbVuQeiAk/perogU9vpQYAAq6BinZMa8t4E0plTR6v6hXAn7DvDZtF
         14u+CC6P9hynnernIBt0W5dDfLRSGdFIYSwPVBXyG4aHl+CzvGOM0vZfNni0o3RjyCdM
         1mM2pGQDGz3VN1m2thG+5VgWP8OtYXl4T6sBtkflvSmVZJ3q8sdrwhdOB6gadL6U1wfb
         F0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795427280; x=1796032080;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xXoaW7puZQVXtPvVEP8J871ckV5Jm7nnXRP/lyhSBaM=;
        b=rxqT1LSnz5nlg6p3mfnLHqzKOkIrLHSU1xn5I6/6vyaF7qufA0iGWXbXuJ8LcTlJPO
         RbDZNNbWqa7VNra67e7UttMPQZgz7r/ahQHUfMTFV51YK1TeXGcS4Oo7/vlLUgE3MQmI
         pNNl7jVDuL+u5oHkHbqae82jtRbSuYxrRNO6zxc49dtxfKjbNLn1t2YRx/bt2rtDo1JX
         STCf6qv/HR9tsNROeB4LsuNjODJZXZ+W2GF/kgsFP71/z56C13OzrpYzZ7g9VVXjppzL
         +FNq43yNyh50LXXPBhe182eiyeQAOzUX2fIPQrU6gKutFssEoL0Uz0XoRWtNOy66fUoZ
         ZwWQ==
X-Forwarded-Encrypted: i=1; AL+hErEasm+Woj/5Rpzh32u1G3EDJQrs1vBcwFZVgR9rjYVSWCcJ39In5CneUA0XCN/c8JH0DiRhLGg=@lists.linux.dev
X-Gm-Message-State: APuU4Z+XlziWdN31g4ZvE8G3YCmo0ZBfxX6c447uViF+MbCy+326iM34
	BeHrFM+ly4pkQ61sAzBwcXcV24Pks5U1bbJB4MlYWQZaTglwP+pT0Mx20XPavcEdcf8=
X-Gm-Gg: AZFdTZe7wYnSgmaXtrV5HzkSnkzQIVNAW9cx2hh24xgdNaURxor/v9H214UnZSuDslN
	cFOmNhR2mNgyI86QIivF1iz4fPHni6H1WuaHzCsjDIJrfetwohfe8tWGtKvlRwDIbAYpV6T3f8K
	Fdaf10LZMec3MvAKCpxXL/8sMwZPYR5pztIOC8J3mvW6v/4qSi0TZRp0eEwzQ2j03Tc2drfz4pM
	J4l8uAW3va5RPJeEItBWmDhI3v3w4EjANwFJueMgTnlfdWC1sHjQ9ptmuF4TQfpfUatjEb2zKYW
	UkMYTQrEEeQ4K9jgIIplo8+VAm/irXSW7O8momVeBHTc187jDJ1ek5u5qT4a1KNjXYkyBVZEd5A
	lh90kdUcvYCBIDGmBf+t5HtPKdpLAtGQdms7DiJc+yjfvuD6sYaR9UuCjmuK+qHiXfMTgXcdi58
	HyGGUSu6srirpXjd8E4wpE+l/zYpSiZoBjCZFZ8slDRWmuCq2yN6w8HDit1/x1QVBbyyN1CabKd
	3Pr9YNyPciFMuYXSWaNhjktj3qwSTEr+tr2SvZ4IIryvGXyYRTidARs4nmMwOKyA2NNVvTC0CH9
	B80LY8LIdN9EG7pXLenw
X-Received: by 2002:a05:6000:26c1:b0:4b3:b495:d5ad with SMTP id ffacd0b85a97d-4b3b495d6efmr3113266f8f.23.1795427279778;
        Mon, 23 Nov 2026 01:47:59 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110ba3sm17295126f8f.35.2026.11.23.01.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 01:47:59 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Mon, 23 Nov 2026 12:47:42 +0300
Subject: [PATCH] KVM: arm64: nv: Reset MMIO state when committing a nested
 exception
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261123-stale_mmio-v1-1-73f9c67a1bb0@pereq.eu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/02MTQqDMBBGryKzbsAkNEKvUkqZxKmO1FgyKoJ4d
 5N20+X7ft4OQolJ4FbtkGhl4Slm0JcKQo+xI8VtZjC1cVqbWsmMb3qOI08KrUXXNNZ6d4V8+CR
 68faV3R8/lsUPFOZiKAuPQsonjKEv0Z+rNHAcJ++xAeuQAAAA
X-Change-ID: 20261120-stale_mmio-a33a67733b65
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org, 
 Dan Carpenter <dan@pereq.eu>
X-Mailer: b4 0.16.0

KVM has two ways to commit a pending exception, commit_pending_events()
which also resets the MMIO emulation state, and a direct call to
__kvm_adjust_pc() which doesn't.  The EL1 to EL2 path in
kvm_inject_nested() uses __kvm_adjust_pc(), but it needs to use
commit_pending_events() instead.

The scenario is: the vcpu exits to userspace for an MMIO access and
userspace then injects a synchronous external abort or an SError using
the KVM_SET_VCPU_EVENTS ioctl.  If the vcpu is in L2 context and L1 has
asked for the exception, then kvm_inject_nested() enters the exception
straight away and vcpu->mmio_needed stays set.  On the next KVM_RUN,
kvm_handle_mmio_return() completes the access in L1's context so it
skips the first instruction of L1's exception vector and writes the
MMIO data to one of L1's registers.

Replace the __kvm_adjust_pc() with commit_pending_events() so that the
MMIO emulation state is cleared.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-221074@kernel.org/
Fixes: 9aba641b9ec2 ("KVM: arm64: nv: Respect exception routing rules for SEAs")
Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/emulate-nested.c   | 2 +-
 arch/arm64/kvm/guest.c            | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0614c3b3a40d..c75b0c623824 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1354,6 +1354,7 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 
 int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
+void commit_pending_events(struct kvm_vcpu *vcpu);
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 39136a89d74b..5a7019bb719b 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2921,7 +2921,7 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	 * Make sure the exception actually took place before we load
 	 * the new context.
 	 */
-	__kvm_adjust_pc(vcpu);
+	commit_pending_events(vcpu);
 
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	vcpu_clear_flag(vcpu, IN_NESTED_EXCEPTION);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index ba4570c52a91..b7d36c2abfdf 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -770,7 +770,7 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void commit_pending_events(struct kvm_vcpu *vcpu)
+void commit_pending_events(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_get_flag(vcpu, PENDING_EXCEPTION))
 		return;

---
base-commit: 5a7235e9adff42aa043ac9473dbeb0354dca0967
change-id: 20261120-stale_mmio-a33a67733b65

Best regards,
--  
Dan Carpenter <dan@pereq.eu>


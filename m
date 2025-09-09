Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D03F1F30A4
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402683; cv=none; b=JYxc4+FqpT90MmFMLFbepST2InI0qB21oXSA9wY/cQd0xwnnYizc+gug208w8s8khMbbJFwduSLQHGrEFXLIttZdR4/e044m/cM1PQgaDw/KN+U3uOFoJodmCR4om/RZ9etl9rEOt7B2VfOu7aUccfZOU6MR/41cBeo5+g8K7rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402683; c=relaxed/simple;
	bh=OZWg0iHzUD1nPzo+eJhkE7pa/t3DlDVEobBDEMYrJS4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wmt5cPz6CvG2TRnu+VkeEWThz6dNpi5cl3gzTOe3SUe6MtT5XIkITR+bDGxgjxWqlNygxg3AwMX3A/9qxv5nKak3++evHGkxjUbL2FpwDT5tekkX+Vo9wC/FQgR2od9AXLXnx8SV2SpE2I31UVQzI7OtoSQ36EfSSaNuyagBOc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qczmbS1E; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qczmbS1E"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3df07c967e9so3255679f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402680; x=1758007480; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qx11gj8wugh91DQHrF/zFIF/LGk3OrIBY2Reh4u6c8=;
        b=qczmbS1Ea+vaLaKhrbzH6b8chVC+1JMKHiYonf0Lt2PHtjLatOWtR7VH8PYq8HUyi2
         LOBlPS+6Nn9I6dMgDnLMu9lrNq+TA53kE8YlPeXkoYEZPIVEcHo5wbYfxg57HZEJ6gS7
         s6nCYo6ovu5xjuNu9TQh72eKvYybP7fspaZWOyAFnB3dJENZRyHqJfnYVGFfjb6Ysl7I
         X4WuGE5qIhM3dpIafRQreO4x50MzvQITAnIPEVMXhQCHM/2+6XSJkrhe3O/GMajarCh9
         HBuOWb4Uhe9MZfX2RiaUO9t6K4HwJzHSVWwF6n1q7Ay5sgMYcyqnPL9vgFLelC3HlvMl
         WMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402680; x=1758007480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4qx11gj8wugh91DQHrF/zFIF/LGk3OrIBY2Reh4u6c8=;
        b=KhioIq3wIiq+jS7sP+T7f3y6y4DJWUiZgQjdJj+MM5k0w85cAAkpx+hDI5mXLkPABs
         fhJ/dCCt6rxEaA3TrfGTK24FpAJsYubOuwQwqGcp6UW0mELMlx4znkdjIMhDk5Sa+wCB
         Z9EQZU+k/Mo1GIWi9gbLFy+p+6Vw9yP9YpPipDRTpNMnFGXNO03MaFe/Z/JX+fyG19S5
         qU3iIwXsoOCGHcaepjK5V5Vyx7UBEeRxHhNRmnTiYE92HoKdR68VbfcSCrqyn+EDKjRS
         zhQ/mfd5y+kp8HbW1zO7Mf8A2oU4luEPltPw5KrqBo1u8ALO/atoeBffJHLeheEHvFdi
         qMEw==
X-Gm-Message-State: AOJu0YzHNPC4VCMziRw8N32WLG0TI7pAbnJIj1bBWloIEnwTaH2T4Nxz
	qgOwQUEA3a0u6VVj1PNmUELMNaltDZGYexfT6s+ryvjyZ13d2GM3tpvf0v37qBjdcT0cLFpZb2s
	6IkXUbayMYHdQW932kgVjTMa2p6DB5Mmf8BmLKug6G1s6EpYjm8r4x147/YYsVf6wE27zonWLXi
	mBrT5gspBxFZ+x3AFFNmpTe63GkLQChV0=
X-Google-Smtp-Source: AGHT+IHPFTrhjpZ2wM5zdNNqDPRxoK6n1iwyDwhPpVI5CSZEiJBq43M7y3dJyiWMrNeF1p7tcW/REefapg==
X-Received: from wmc24.prod.google.com ([2002:a05:600c:6018:b0:45b:79d1:abcb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:3101:b0:3de:8806:ed08
 with SMTP id ffacd0b85a97d-3e64c87e270mr9061946f8f.61.1757402679776; Tue, 09
 Sep 2025 00:24:39 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:24:29 +0100
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909072437.4110547-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072437.4110547-3-tabba@google.com>
Subject: [PATCH v4 2/9] KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The 'pkvm.enabled' field in struct kvm_protected_vm is confusingly
named. Its purpose is to indicate whether a VM is a _protected_ VM under
pKVM, and not whether the VM itself is enabled or running.

For a non-protected VM, the VM can be fully active and running, yet this
field would be false. This ambiguity can lead to incorrect assumptions
about the VM's operational state and makes the code harder to reason
about.

Rename the field to 'is_protected' to make it unambiguous that the flag
tracks the protected status of the VM.

No functional change intended.

Reviewed-by: Kunwu Chan <kunwu.chan@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2b07f0a27a7d..7ad997dabddb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -252,7 +252,7 @@ struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
 	struct kvm_hyp_memcache stage2_teardown_mc;
-	bool enabled;
+	bool is_protected;
 };
 
 struct kvm_mpidr_data {
@@ -1441,7 +1441,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.enabled)
+#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
 
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 338505cb0171..6198c1d27b5b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -406,7 +406,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
 	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
-	hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
+	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 }
-- 
2.51.0.384.g4c02a37b29-goog


Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B6A33987
	for <kvmarm@lists.linux.dev>; Sun, 17 May 2026 18:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041617; cv=none; b=dBzKM+mgw7tUBEcbqD98jB4MrIcIEBlpso9vkedWhrD6jyHawUlVtjCTXhtvY9eiBKnQ0a3k0xh+4JcMf21zyGNVTOoPNRwqR8Lx/bkjolgb94/v/EmNT0nogEfineT+jkeBqRop5v0Cm9Z4pd3FRr9PTYRSxuKqV4tflFtt/5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041617; c=relaxed/simple;
	bh=8MW3Q6anTw0mMAQ2n/kBjmr7GxkK53PFrDHsjAsCODk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K0q3JSb2zWbhaMptO3E45MgMcfTs63Qdo0pCBfIEbEhpwEsBSGWWoHjPqfpVKE+nV2DXZ7vIanJohrVGRPoG0LaHf3HMK9iww7eiwCjiZPiJkvw7h5Ejj+yjBSzXWr+PaD4iuckmcxdeZYfGhVVqL4YN707LanExIHM+l5e3azw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=diOpa7X9; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="diOpa7X9"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-90fbf21d9d3so322444385a.1
        for <kvmarm@lists.linux.dev>; Sun, 17 May 2026 11:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041615; x=1779646415; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Td6FiAaTmTkeflxhImr5px9zzqspJuHFjJUaI/KnqV4=;
        b=diOpa7X9qbUv/0PAM/FID9J3Tqk7ZpVko9LOoaGRZPiew1s6inPEISBbtElCZ79wF+
         Ksm/7UrGNEkkSnokuFC55qpVCDyWIdwBYwncQiGWZIZKFwsOCc/qzEPSUu2WIGEQZtfk
         Y4jrtyCgNU47LTEYi6GCKRyKnCCoS/KguSPZN84q/+426cVTEX5bRH1dBQrcEkV7FzFQ
         4C/ryd/Il9MdDy3oASe04WdCf95uuP1vO2et6RGaobtzZfDfix6Ukm447ddnw30fKIIA
         qR1wKyjqdi4SfZOMDipZtYv91yGkHcUgQgvVAg8nWOYWqCXqrzubd/UVicmwY43LroO3
         46pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041615; x=1779646415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Td6FiAaTmTkeflxhImr5px9zzqspJuHFjJUaI/KnqV4=;
        b=lLRZ2J08rVR0UTInTwWh8ULs5IQd+KUkkuQOTfii+Qn++kCDl5FNPBAZARmfxA59J2
         BjhD6HsRfvKNquF1qWF+dCHqRSo31v+9ex9FvGCgzymVPS4jn9FOb0085McD1yeyJIq1
         C+zAXHFwslOPBCwAZKD1jzp1zZiJuPZlfcvRk3edwn4+bOhCLFQhzPQri4bmqIegQpiJ
         tbypB8Yu8RIr5Z2mryuafLeU08hKjw2ZHNqczD1yTo6lwrR5cNdazPtLICYRPe8/Ml3Q
         VrCvan33UYzfOrPPekNb1gfXaCfeVpdhQBTSUXmF4cg4Z87PyWpj6RGjqm/0MpH9hbn5
         LWmg==
X-Forwarded-Encrypted: i=1; AFNElJ/G4If754hRAYb9+wOYdmcWrkRbCOdnoQw7wWitp9EkeuU+WPa2G62eXrQnvQ7YMOFDJFawZMQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv6oF26q1inxVBVXDE9y8pTtEKJN5Ha5jRlFcSau0aKR2rIFbJ
	jgRhjrGx8FgBf976SM+GRw4BedMEEK/RGZg5nZdC6xC8832GHHZhnkE9
X-Gm-Gg: Acq92OEbmDavXFkIz4WYxPwPDqBPRUreskIKDapQ+JhM/VcBsdg9IFwm5pdvmGor6ON
	BP9KfLWqmCz4kXhRmbuQMvGH5iWNZvzeQIi+Fb5ORIsHAA7f6d4+FCWYlkOjg34LmqsADgcGGm2
	0PbFLYnjA9x88DD5pP/8pSUum9VL9+kE8IcwMgrXiFDT6ks0JzCPLTGghmfw+VPCNSR7sfYI379
	KhkPRLv77Jp8m/v8SWbhTxCMYjLL35wjWytuaOrx6Jc9a9aY94dP76r6MjCwzGx4wbBdoUEmhcl
	ubRm/AIqydr9cWaw/8ttVSXlxjo9C8ctLmw4z2uj0qWfM1zQBtJ5s66yLZK6IZO206d+iFG6b6B
	9WoHZ79g8fbgTMZjrh8yIR9HAgkbYN8GvXJskMwo2nW9kAUibEcV/oGvbeLU9Dq6r8C5tCRLGbD
	SWkDeQfK05k5uF8U6NJQYRnwHtsnjqcKEl+Ms7l4dzTsNh/yDuWM0l6h71dMOB1Y4l9I/cli+HI
	Y2qFf18M5KGjeiIwLDaiqdXdY8xBbADUx8Pes3zy4g=
X-Received: by 2002:a05:620a:45a9:b0:910:87f4:9a26 with SMTP id af79cd13be357-911cde539fbmr1929262685a.41.1779041614662;
        Sun, 17 May 2026 11:13:34 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bc936407sm1237378485a.22.2026.05.17.11.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:13:34 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic: free private_irqs when init fails after allocation
Date: Sun, 17 May 2026 14:13:31 -0400
Message-ID: <20260517181331.367676-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Companion to commit 250f25367b58 ("KVM: arm64: Tear down vGIC on failed
vCPU creation"), which added the missing kvm_vgic_vcpu_destroy() call
to the kvm_share_hyp() failure path in kvm_arch_vcpu_create().  The
kvm_vgic_vcpu_init() failure path immediately above it has the same
shape and still needs the same cleanup.

If kvm_vgic_vcpu_init() allocates per-vCPU private IRQs via
vgic_allocate_private_irqs_locked() and then vgic_register_redist_iodev()
fails (for example when kvm_io_bus_register_dev() runs out of MMIO-bus
slots, or vgic_v3_check_base() rejects the configuration), the function
returns the error without freeing the private-IRQ allocation.

The caller kvm_arch_vcpu_create() returns this error directly, and
kvm_vm_ioctl_create_vcpu() jumps to vcpu_free_run_page on
kvm_arch_vcpu_create() failure, which does not invoke
kvm_arch_vcpu_destroy().  The vCPU struct is then released via
kmem_cache_free(kvm_vcpu_cache, ...), dropping the only reference to
the leaked allocation.

The comment block above __kvm_vgic_vcpu_destroy() explicitly anticipates
this case ("vCPUs that failed creation are torn down outside of the
kvm->arch.config_lock ... it is both safe and necessary to do so
here"), but the caller never actually invokes the destroy primitive on
the kvm_vgic_vcpu_init() error path.  Call it now, mirroring the shape
of the kvm_share_hyp() cleanup added by 250f25367b58.

Per-failure leak is VGIC_NR_PRIVATE_IRQS * sizeof(struct vgic_irq),
roughly 3.8 KiB rounded up to 4 KiB by the kmalloc-cg-4k slab.  On
systems whose /dev/kvm policy lets unprivileged users open the device
this is reachable to any local user; reach is policy-dependent and
varies by distro and packager.

Confirmed with kmemleak on v7.1-rc1+: 50 failed KVM_CREATE_VCPU
attempts (run with the per-VM MMIO bus pre-filled to NR_IOBUS_DEVS so
vgic_register_redist_iodev() returns -ENOSPC) leave 49 unreferenced
4096-byte blocks whose allocation backtrace is

  __kmalloc_noprof+0x390/0x4d0
  vgic_allocate_private_irqs_locked+0x68/0x1c8
  kvm_vgic_vcpu_init+0x78/0xd8

With this patch applied to the same tree, kmemleak reports zero
unreferenced objects under the identical workload.

Cc: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>
Assisted-by: Claude:claude-opus-4-7

Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 176cbe8baad30..5d5e2f81b9c94 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -554,8 +554,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_destroy_mpidr_data(vcpu->kvm);
 
 	err = kvm_vgic_vcpu_init(vcpu);
-	if (err)
+	if (err) {
+		kvm_vgic_vcpu_destroy(vcpu);
 		return err;
+	}
 
 	err = kvm_share_hyp(vcpu, vcpu + 1);
 	if (err)
-- 
2.53.0


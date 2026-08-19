Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F415D3ED5D9
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 22:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787179389; cv=none; b=U79EFHJEHtjKkDQtGv2I9tg/GZ/xoHg/TUQm462Il7rPbLHzSNBgzQE9/ZZZZhnBJ+h++feK82JVGsr90VCLq4p/N8tCF6M2YDYduygQsbySf5oavHP07IorGcdjbC2VjaGSGl7Qs6Uizrh+kXZb3v8UGi1QFztIGGctWFmBRS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787179389; c=relaxed/simple;
	bh=97Q0jynUUZzSZ55O7Qyxq5A1GqvKcQd4O682s26kE50=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i4ZovvsPQfrKxgPn0mP+nkGb52cZS0taXa5rQmEbYPofrA4Bg4bBIqpdE4pRCNdMA1w0pbK8PTodXnzmh9cT+T3eXMpBtySBCVlUpCeXb4ttY0N4uXNlsizxL68qXFzsiHDhs1Q94Kj/MvnWKKTehvJ3YpIcL+yJoq28S9qAQGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l/Y+fED0; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l/Y+fED0"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47f6609c657so734385f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 15:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787179386; x=1787784186; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ls308eL6NV0loSgiW60lY9W5Z4q6fPeju3Nkz+urIAI=;
        b=l/Y+fED0SVBL9v+clR1MjmnkEMw7hHxJIOOhNDQ49rls5tcsP+nO21+NHYYwIEpLb3
         Z7MWWjNhgAfKZKLGiWY0DU3p58rFeCnKLVXzfk+1HGMvjyUI1j6fG4E8oWcPd4xVMuIj
         QVvTlrywoTFlEaSSZ+m8a5DuijuHxhC1iavToESp9PYoBXmul0Ar0hUYNXK+iyIkH7/1
         ORAHg7hE0sKOkeQ9lPKh1LIzqQSCiUZqcl/0JDCnz/hC3mxMS5XYKI0LLLTBfRwqRo+E
         Db7D0gGULFC8sKMRcx0BOdHo07XryvoMP5uXSLkJ2GWCnu9dAdudlOoCZbCP/kEf7OFV
         wpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787179386; x=1787784186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ls308eL6NV0loSgiW60lY9W5Z4q6fPeju3Nkz+urIAI=;
        b=VKZdu513uO2gWSublx5ytvg1imRhQru0MwRB0pV6wvfb0Qqviyb05ZEc8u0Y878DlP
         5/AQ1vAwsyg5OZhE71RELNuxLOTQSgTodpIVReaXbeNbvv5gis9WklmVgXti7S1LWBms
         n3ORupVa1uzYzphblUyJlzBbrJgy48CrWgWOYAhqZyyDl9KnE7R1PpltGmjsYIqqALqO
         xxiCT71s7PBNTXrMXY9JDNQnD3s+Oyh3BWbwpmij5sQCSIJULoQhkwXlGbFtWvOYGtd+
         d3bMCEjQm1zf217+1zveMMBANYxorcZ9kdyCLu+WDusvOcV5X5N6tIApN+1KjOW7u0AA
         //aw==
X-Forwarded-Encrypted: i=1; AHgh+RqRWY8amPMb6RJ+dnt5UJwH9yHnW6X8/uiJw9KTnxAVfU+aDFShuFbqFr7Smjxe+GugtK986fg=@lists.linux.dev
X-Gm-Message-State: AFuF++lUL8xVqgzijp2BLGr+mZDclo5BSdaiHa7PgWJkftCf91sftzrf
	GuFZWntqoUyZ7nci0QLzFAdfX3ekQV8IlEl4XLZNnFyERLUfvGkIoE/p
X-Gm-Gg: AR+sD11zBSqIAmBryiUlG/+C+/W88KhcSLAyLHJnKArT4QI7N2Gy28s7wlFcCH9+GJe
	PxnuteBZzIvVZtLVvD0j0kVTgPHbmJeKOSB7vTo62fASIgXz7UnFJ0Ui1XapVkNfPKaCDQABQeR
	JBYyVi2t4aBOnD0rJZOG6bEhnQJ8R4wEavBHEw/b01kOJjaxrQJ5hS3psq3U1Ohy/n5HJ2fnPr5
	sMYrOhZD2gWyBkatn+K0HfoTNd9nzdG0NOJ+jwKP7CtXL8WpJN+Z1N3ZmnXlRDcqlsjrAvyR3kC
	ZezFjm1eJch8JC94ITp0AmVmxAARiWY0NuH0r34uzXMhQE+CY1Tb/z3o833pp1yiuREY+9OxzFP
	OtDikDDURx8cdGs/gLbbsvlR2nDmYW9bKQUOb6SKJ0l3FBvTabWvuBEr84RiFixq4lCDFS/gQOd
	wtDOZfCqtp+9EtvDlGh91OP2m0DCPYCjhLLxLNPPV0vUSJXuQ9DLaiAVaxCEaXt+N8ZqVCbUxTQ
	C/lwYgSC4+a+rLf6E+XTEjhx4XBxvNLpCZlnpUd6LDlwA+mg1XkybQ2WXtMYkBDGAVsxe5P000X
	d3X2bCJrt5MEtGOm1Qf1poBkFNZKN9kKAocUV0yiazTn3bpaYDZtyk8aFerCMT44ntM=
X-Received: by 2002:a05:6000:4619:b0:47f:5b52:5579 with SMTP id ffacd0b85a97d-482b1fe8a4bmr14986627f8f.18.1787179386081;
        Wed, 19 Aug 2026 15:43:06 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ae9e-1d01-58d3-443d-4fa6-01cd.310.pool.telefonica.de. [2a02:3100:ae9e:1d01:58d3:443d:4fa6:1cd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1450e61sm8553317f8f.13.2026.08.19.15.43.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 15:43:05 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 3/5] KVM: arm64: vgic-v3: Unregister redistributors before freeing regions
Date: Thu, 20 Aug 2026 00:42:27 +0200
Message-Id: <20260819224229.82948-4-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260819224229.82948-1-kmehltretter@gmail.com>
References: <20260819224229.82948-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_unregister_redist_iodev() uses rdreg to return its region slot. During
VM teardown, kvm_vgic_destroy() frees the regions before unregistering
their iodevs, so vgic_v3_free_redist_region() must first clear every rdreg
pointer.

Unregister the iodevs before kvm_vgic_dist_destroy(), while the regions are
still alive. Temporarily drop config_lock because
vgic_unregister_redist_iodev() takes it; slots_lock remains held for the
MMIO bus updates. The region destructor no longer needs the vCPU scan.

Suggested-by: Marc Zyngier <maz@kernel.org>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    | 11 +++++++----
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  9 ---------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 0a3df6d3a691..df6d0bdda4a9 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -570,14 +570,17 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		__kvm_vgic_vcpu_destroy(vcpu);
 
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		mutex_unlock(&kvm->arch.config_lock);
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			vgic_unregister_redist_iodev(vcpu);
+		mutex_lock(&kvm->arch.config_lock);
+	}
+
 	kvm_vgic_dist_destroy(kvm);
 
 	mutex_unlock(&kvm->arch.config_lock);
 
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
-		kvm_for_each_vcpu(i, vcpu, kvm)
-			vgic_unregister_redist_iodev(vcpu);
-
 	mutex_unlock(&kvm->slots_lock);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 331d203acb43..77a611564f8e 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -967,17 +967,8 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 
 void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdreg)
 {
-	struct kvm_vcpu *vcpu;
-	unsigned long c;
-
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	/* Garbage collect the region */
-	kvm_for_each_vcpu(c, vcpu, kvm) {
-		if (vcpu->arch.vgic_cpu.rdreg == rdreg)
-			vcpu->arch.vgic_cpu.rdreg = NULL;
-	}
-
 	list_del(&rdreg->list);
 	kfree(rdreg);
 }
-- 
2.39.5 (Apple Git-154)

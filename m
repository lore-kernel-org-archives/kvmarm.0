Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DC43EA976
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 22:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787179387; cv=none; b=EfbcGBOklo4soHEQSuxpsE3wkMk+NEnMFmvNxntERNdSgl3+ibGnV5hNMahgdtrztVY0Xu+j67dfHGBGueigvjfUj9mQbF5/mawW5r8YHG8PbzhG1RsH9EF68z/dSc7t7AoducSfJqW1bTzr2MfQjICPBEl7bvVoarfVCrpunI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787179387; c=relaxed/simple;
	bh=2UF/dpEtNwUpXIy2/lsLjKtKkOc89V1LHpzMmRW/PXY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D11vtEeNP3IXioFfNhg7EsHOvJdSY881m3h67ziLI6yx9KIHQ7pIYkoxHEvyihOYqTKBKzfewu95dkgLjS7dfBrmWxDXbBF1mcEK/vxBtW46mqS5BDpnGng0S6tyHf9S1fQXMJSdb2Qm2LwQ7mzkPSy+o7BdHRwrET06qjIfeyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LIaV+qcG; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIaV+qcG"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso2901245e9.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 15:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787179383; x=1787784183; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3M8fODVTfcIR6x1BvOAoZIGong7qKVQ1WDu7Gk51RQs=;
        b=LIaV+qcGL3tOhffH3M091xAt3NuCUaph/4hh3fOfVOG7fQQlkpvXWKPNTSRg1pCb9+
         KEAM+PhLi3UR8C10DMbcGebb91M/a+ZPDVRp4SBNTFEItvOcCz1Vr4LYQnLr+Pbl0sxb
         +jB+Cz5VuZP4cIhxIyZakipPddedhcyIItE1FQxHl+Er0qtDMfu/DH+K69+FWgI9GdBg
         LmoJSqFL4CQaF1kmiJuUkJu3wlopIH6gkFQOvjYFslfKScwrHUHDX/gKvh5I7BOdkgGb
         AsDUvDqA5AsbVgfPaHufPBLCR5pJu0jSAEpA6fCrQZ55LmiZ6cpjEuBqaEllu572m3Yt
         j5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787179383; x=1787784183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3M8fODVTfcIR6x1BvOAoZIGong7qKVQ1WDu7Gk51RQs=;
        b=Ow18ipgb7TODPwLmYZJTY47U3FkuzdJ2TxZ9OQXj2BKEJ69+A0YqCX+Voh2XqZngHH
         n52fL7ZBxrFTqhubJBZIO1QBHqQwcBqenmsq+D6IVoK3twUVXELQOPCJqbznDwY29gOX
         iZXxRe3Ob9UD6rtiTEqJXcvJB/wSccWLkhVw/1NFJZxq1kTnYanEdDp1/1t6rD2ZXsGY
         GvfIRmJqFxiul/LAHw90H9q9xAcPqmdFgZfCtVHDau5y0Rb5bry9FdHKikIfHR6T+0qZ
         q+wIS3z3JvHmEqW+8RarFrnAVZthiJZUAC44zUhd6RcbqciyBC3o0T+2quUoyUmadmBa
         8FXw==
X-Forwarded-Encrypted: i=1; AHgh+RokdEztJ2kh/NyQHCVGvqs1EkcSVNgSuHz+/3eBHtRyegjah03cW4XI2qFrRzVd/lRNcy/ID3w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVt/XFE7Yue7qbMWDGO1UX6TTzg8oyMQlEIq7Gevc6WSlchsr3
	KD/H3C9glKkWebSLXfyLTJPHRPb3vQfNfv7/3H+CCgJT53M3aikOdGa8
X-Gm-Gg: AR+sD12i82j627NbgFMPMkeWK2xr9T9YgvSjwGcHPBQdhx8qELE2il4KdkECh/KG7XO
	8sCX9+tFMU/TWDEHQZGI93qn2KmvW1MY2erM2aUr8cAGk377IMj65gaFX1eszK/u9aA90nQzIVw
	+naHRgo3QUT/RjbW5w1rtlK7yOZ2B5OQT26CgHZQkLCph3ZESkOtzYtij27vbuF5dbsC9AkgEJ/
	toN1zh/DCotRqlhSMGlYnnhz5MskERDyaBJiyneE42PpHHZYHM+cAqgDQA36UgypI3ezJe3N+tX
	8d5YLW1VqKzLHXNTQI70eErP87jbX0v4s3H9ielhnAogHUccFwDkBdpiDaCz/KudVfZ72O6zPJL
	TOYgENlTot0kSlf+VsefcYzDoike8ONut1IMbzW9MwFSA47SCN641G9mcSIjd1cKrNNIHCTdzeY
	owi/AYJ6i3y1jSkkXKG/pEQjnoes/cs7P0P8533/h9XNdej13BkAqQQs05x82x97xablesx9Bbp
	tLLskHS6Wv+/7M5CXNAoZlE+wuhTpgYaOHkSzWaLvnAwpiVlSphwP6g+KmSGYRSSxDAx3cXHMKL
	21fU4YEjxu/EAVvp6boyaJskfaAK7eVei+RJnB8Oeb6nHrU1PhQ/WPBBgwzaMG4e9yk=
X-Received: by 2002:a05:600c:4309:b0:499:60e5:248a with SMTP id 5b1f17b1804b1-499b06ea247mr24837485e9.4.1787179383250;
        Wed, 19 Aug 2026 15:43:03 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ae9e-1d01-58d3-443d-4fa6-01cd.310.pool.telefonica.de. [2a02:3100:ae9e:1d01:58d3:443d:4fa6:1cd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1450e61sm8553317f8f.13.2026.08.19.15.43.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 15:43:02 -0700 (PDT)
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
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 2/5] KVM: arm64: vgic-v3: Reset assignments after failed region setup
Date: Thu, 20 Aug 2026 00:42:26 +0200
Message-Id: <20260819224229.82948-3-kmehltretter@gmail.com>
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

A REDIST_REGION write can fail after redistributors from earlier regions
have been registered. The rollback removes their iodevs from the MMIO bus
but leaves rdreg and base_addr set. It also leaves free_index unchanged. A
retry sees base_addr set and skips registration, leaving the redistributors
absent from the MMIO bus.

Make redistributor unregistration clear the cached assignment and return
the region slot. The failing vCPU already unassigns itself, so the existing
rollback resets the vCPUs processed before the failure. A retry can then
assign and register all redistributors again.

Fixes: c011f4ea106b ("KVM: arm/arm64: Check vcpu redist base before registering an iodev")
Suggested-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index c75caadbd1d3..331d203acb43 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -852,6 +852,7 @@ void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
 
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
+	vgic_unassign_redist_iodev(vcpu);
 }
 
 static int vgic_register_all_redist_iodevs(struct kvm *kvm)
@@ -869,7 +870,7 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 	}
 
 	if (ret) {
-		/* The current c failed, so iterate over the previous ones. */
+		/* The failing vCPU has no assignment to undo. */
 		int i;
 
 		for (i = 0; i < c; i++) {
-- 
2.39.5 (Apple Git-154)

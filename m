Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF81654A7FD
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082818; cv=none; b=cJakocyf1Ab0QMg1s5mwIKru/CMNRz3AgUFX9fltB6R9vSNALIhbkRLpDxJHDdNYf+JPgreOZVYzkqtQez9rSL2kn41UZ5ndBpCulrofrEfRucrlCLw2s/aD/kiF3hn1KUHsdzx+mFk3H4aDmu4npJVG+4euZLtMA0op01afWi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082818; c=relaxed/simple;
	bh=w0v4/Cc0aZSRCWoynVPgXYj7n1ayw0SGNTNFER2zP+8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=enweZfS/9ABxdHr/7O3+v62r1Z5lZH7fx9pv/O8psAK0oF9pf3qTluz/V+CqKVYJUon+qhjTMGnYjJvn1J6cJCzNBJ0SxTOkWol3zaz59MRNpSuXiIukFA7SxsxZyD+yY2YqlWuD1TSabyN0I+V1acWcGj0XbRaxq6hhfkUww5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vVpMJAPy; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vVpMJAPy"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a615ab0c06so5303320a12.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082813; x=1790687613; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jVQjAaBFFW3dvBW1v+aV1twyKPPe74xtBKnCer/p5k0=;
        b=vVpMJAPySApLlBOGl+Gz0isZz3maQXsamXepc/LxOZeCDYKBKybDg06ovYcjSDIV/Z
         qWVAhybBoMO3FXaAv/uehvio3PwNUMsY7jURyxdmmEERnX6RD8JnKQqA1aGk1fWNiZBd
         8xC1WmqQ3NFV8PtguJZGk+XIONGy/MQv61hzuF2wTZH5eR5DH7Qzi5d3LB1X7obBXHMt
         inZoSmtJY4aOWGYeNUyVuHAPaqmnQQ61HIp7+5ykkz6p68nAXWxLAM3NRn59OzgcTLy5
         +KHWP7k/0b8CUdPLizEkBJC+fMOarpm96ezPhZF5dBfuwVNG0lHtJLDUMX6nfNT6biOc
         PG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082813; x=1790687613;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jVQjAaBFFW3dvBW1v+aV1twyKPPe74xtBKnCer/p5k0=;
        b=KYaK6eGWbQb3SUahLHASG+GKkcGq3TN63QOieT43yRZC++Ur7zMVtdWXZiJ/liSbgo
         1rX6i7Ma5qX1sVULnGf7tjK4Zt2ZpIakRwaTQa/fKuo+O+0rSvEs+elEgFy1yK7Ilk5N
         F8eF461vxbCIJ477a2fEOGrtqAtNoXY6KY5hWjYOvNzia878mxrQ2lrRhUecoLP7lqq9
         7TwZcDogi9Wh7PA3Mvde2tMBwYD3GiOcOVXRa5YhLidssffuKB3tpwziYjHhfWFANyXN
         undLJOANbV4B6XGTwsB0R14swBSbA3l0/dx2VgOKY+w3OEiePVTtQSuqn8LFpvYOGOLT
         lySQ==
X-Forwarded-Encrypted: i=1; AKwUvBzwHoD6Oi58jfGc5OHn5NH1zOEbTk8nuvKiU+KoS5DW4Am09B4f2yNUlgyzpSUN26jPYVDHN34=@lists.linux.dev
X-Gm-Message-State: AFuF++lD7dTgTNaKGKQYAcjNNucXYlL+hL8LU99zAX92hJ+x+MzORbPW
	+gNq8ruinaXjB0FeoPjSPbbAI9YZ892oMf8HUHDL5JqPVQROFA9GP70WQdM3RvPtdvpUijvS/Vq
	6KDhXeipiqGup0Q==
X-Received: from edqt6.prod.google.com ([2002:aa7:d706:0:b0:6a9:c0e0:494d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:52ca:b0:6aa:734b:1a1d with SMTP id 4fb4d7f45d1cf-6aa734b1b6bmr7367534a12.23.1790082812533;
 Tue, 22 Sep 2026 06:13:32 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:58 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-26-smostafa@google.com>
Subject: [PATCH v8 25/25] KVM: arm64: Add documentation for pKVM DMA isolation
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Populate the section for DMA isolation in pKVM with the newly
added KVM IOMMU and pKVM SMMUv3 driver details.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 Documentation/virt/kvm/arm/pkvm.rst | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
index 514992a79a83..ce67e2ae1f9a 100644
--- a/Documentation/virt/kvm/arm/pkvm.rst
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -77,7 +77,28 @@ Status: **Unimplemented.**
 DMA isolation using an IOMMU
 ----------------------------
 
-Status: **Unimplemented.**
+Status: Supported for devices behind SMMUv3 supporting dual stages
+of translation.
+
+With ``CONFIG_ARM_SMMU_V3_PKVM``, the hypervisor will take over the SMMUs
+on the system and provide an architectural emulation to the kernel SMMUv3
+driver.
+
+If some devices are not behind an IOMMU or behind another IOMMU architecture,
+DMA isolation is not supported, as a driver must be provided for that.
+
+DMA isolation is enforced by dual stages of translation; similar to the CPU
+where a driver can register their ops through ``kvm_iommu_register_driver``
+and implement ``host_stage2_idmap`` to shadow the CPU page table.
+
+The page tables for the stage-2 SMMUv3 will be allocated from a pool created
+at boot with size configured from the command line "kvm-arm.iommu_pgt_mem"
+The size must cover the worst case scenario for leaf mappings of system memory.
+
+This implementation trusts the system firmware not to allow the untrusted
+host kernel to bypass the SMMUv3.
+For example, by resetting the power. In that case, it is the firmware's
+responsibility to save/restore the SMMUv3 state.
 
 Proxying of Trustzone services
 ------------------------------
-- 
2.55.0.1082.g2b9226bbc0-goog


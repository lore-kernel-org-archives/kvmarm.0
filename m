Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FED47F2C8
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116789; cv=none; b=l/3Q3YS7JxUaU8jEgLpid+Wpr/qKVI0/LITk0zv+DAFpLpFX7YYnOi/blZV+BCskHSnT5DUGXPFm+4Fin7Dsnr2Pd9pUcdOsy8e5NFcMLDsulDg1zcpLrg5GEkDwa13pAHxXFTzunple8Hqk379pzyKSIQMGOaFMT6iLlG6PonM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116789; c=relaxed/simple;
	bh=X92nv7EtYWCgdhcWR41Vd3TMlIXF4weejIJGzxYYk/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V7MXI6mPutMlPf8fhQoLDnoj/hHdFaedeOS8DYIR9zdsEHWo3YlCl5glZvSIQM/CAuB/Y3w0HO8w0dBSAxnRSzPoFjBcRFKtpdTaXX0M9aRPc/ELGlzO7IcmG3VUjDHuz4Sp91TybxJf05VpTbrBqv7+HzRXN0RFXgzHfQ2gC2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gONcTZ4h; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gONcTZ4h"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4953c5d6d87so6753295e9.3
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116784; x=1784721584; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5C0qOSsi5b2SM4RQ0BVtOxMAlSvEVPuXW/TZ/ZTmFdI=;
        b=gONcTZ4hc/aRH9JKNHeFcW6qeeytJtBCGZhPAWWhqE0N5qzBku2S0Ho1s3cx4prMsc
         Npq4JAJgxoXj81uMjkTp23wOI93MQt3Rd1kh/etG69CTa9HKnWCUHqS/s3q/ILwyI7wP
         L2UWKBO4Y+aKwV9QLwzkmcdFckza0jTM30munVGie3rKQwgM9QVaucjLXulvq9/+KjHY
         djgXH+x8JljSgwC+ipeS5Tf3AKjGtO8wIV6fDV9Pi1bL90iHNg3EjtszLF+/M7KuYSyt
         jsYUqmHWgkVnl1mOxbUGjdLiTbbYv0qqpP/iO8ud477Ef8rZtcyf962aAsBTk/h663tG
         PXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116784; x=1784721584;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5C0qOSsi5b2SM4RQ0BVtOxMAlSvEVPuXW/TZ/ZTmFdI=;
        b=UWXODnrE1RRR9sXrjmsM0ab/zvaVwQ6Nh6bEEbVVrFt8wb1GUNha3xXk/1ovIdfSCA
         4ZaoYpgsVwEZadihWcXzBEDmRpZX1+eAiakGr+TpFUj4NVdCnfYvK+hWs8cmskuzLYWZ
         8VGGI7kSXHbRZaJzlTWujzicnlRafleQYHlYWH5ZmACoVuKCyXBRQxbX0qjwkYrNUPku
         KoTfYScYksTXDgSTRTX0a+/OiMqte/mCWQFEpWXG6ZPivobYdV9LLjpHmBzyMSP8nV4p
         0nptAhupozQ6Xy0y1AzEMtm6bPtFByxcVsCTBxoEDFc1VE01K6mVZHZkv+hXBGqcSF91
         ER/g==
X-Forwarded-Encrypted: i=1; AHgh+Roetfpw1wCl4/nxY8qLkjblY4HS2fRm51QD2NvYZ6A8XtwYhy+nLSbRYUp23FdOCEDeRsTfEDw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2soWbZPjOv5TvqHALMlw3gWwQu7zqa8vFYaRZNYU3BQDhIBKY
	Ov5aAw58WmSERo9va9t2eapqSSHlYoTFeme1C5ai2mE7zkRqErBoqTV6NDxYl38XhC5rbOW50/Y
	vClsTY2MDOTIX8A==
X-Received: from wmiv11.prod.google.com ([2002:a05:600c:e40b:b0:493:ab17:3e61])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:16ca:b0:493:c1bc:79bd with SMTP id 5b1f17b1804b1-493f88180f9mr114853395e9.20.1784116783668;
 Wed, 15 Jul 2026 04:59:43 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:59:05 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-25-smostafa@google.com>
Subject: [PATCH v7 24/24] KVM: arm64: Add documentation for pKVM DMA isolation
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
2.55.0.141.g00534a21ce-goog


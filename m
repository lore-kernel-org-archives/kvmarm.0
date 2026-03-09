Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE1D3EFD30
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073586; cv=none; b=E7MEsD69Se9w9f6eEbn3/fMwfSHAo2J5xeAtErbZdepCQVx0egpwYsPN/LPAyf8q9Kjh2qx8hGhlLjo9Q8tlHRMl3ySypowoygio04ZeZOLw6sqgC/gRdJ91GolSBG9+cuCBdBKvZrQQRy8A0p1S40VlJZiyOmVIB/x2zRITveU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073586; c=relaxed/simple;
	bh=cWmCVGc8Z9dVFyLjcgMh+d+QoVHI1pxbCmuYrrytJC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CZeQqwmxyTMmTY/Wd7vxdtyrpI2bSXcZAXXQIoaR7+eqmB4SEbjl4RqA8q+HZXW54uNH0jXQ8MC5yr4REonwvRsaWA8jsIPF1kVFHhoAZHr1Wcp1HV/iG2z1/P05EZ4lXHT0lYbzBkdkxZIGRxf3bVu3iqMPZcQMUwn+UxOvKx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CFnBT+P2; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CFnBT+P2"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439b3011be7so5656772f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073583; x=1773678383; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+KUjQbuHQJ21p2RQALWJdLghrvcyrBZVXJ9cfGciG9M=;
        b=CFnBT+P2xJ05soQs/IXd6Nfi43tJ5Lte3MQBVK71xj7LO2LA+80PehUKIe3pdDZKyj
         T6/yh+sb8FEMqxZ/JToanWBezZBxyJs4Cy/HwGufQ7U1eLQNGiUxIIlVHNu+hMZeqddL
         s3hnX6VtHvmUGGi1MHrXD0qUlqKZCiSwMB7FI9tEqna1YlI5Ou69NsmjqSrH5kyWHSrh
         dzVc/WyTVSnom3NqNMiw6W+8jk5zYe/rrDUxFxob6ac/h+ymx4mVzYZFYY7ViJRbVSXP
         Pux57FllsN6t8KaeNDpn9qh31CN6/fiDp2AXrxhgPOZ7NBS6f8LfyFcqqhN/zOP6oizv
         Spjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073583; x=1773678383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+KUjQbuHQJ21p2RQALWJdLghrvcyrBZVXJ9cfGciG9M=;
        b=A2Ovb7qHbSunmMpcmNaoOIaR0vPAtoOqRkx55hYOLGd/S1N5L/OEvqMb8yIUlCdFGD
         s0WVimOcnD1LgSW5+7tDWLKxFOaIMgaM1J0YuoiV22yO+osNXqpva2w3jUxRPeQL6wc/
         5qGWPf2dsqxgZ3KGCQ5IYdFDr+PqwzLrifsnvYYiduGlzdXIlm5cOx4ATdZDvWkghgTz
         BxulMsaOLKxwU0nu8/oPO4e8jgo+eoqZ3/yx2E/dfkcC+cMflbDz2fw0OYDLvkOfvo4t
         5i4jOH0ARha3hOKfY/7mck2uqJqX6052/PnFGl7Q6AfIGuBjr5c0XUazDBRiLxkjB/uB
         ro0w==
X-Gm-Message-State: AOJu0YwV68ye3kB3A5fsR+UVQCvP1ZJ1IvdJ1mzP3K4somIL8hAHaArj
	jaZjkI/bypyo4QzyeAaVCMAS2CaRGi8S3kEbbxWacl24fFNZE2ou5Z68zVEKMs+TVzZzX89VhN4
	gdzttZpL6aZ/cEExk59buiQ==
X-Received: from wrbfu7.prod.google.com ([2002:a05:6000:25e7:b0:439:c9ec:823])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:178f:b0:439:be3b:ddb6 with SMTP id ffacd0b85a97d-439da653249mr19834479f8f.59.1773073582885;
 Mon, 09 Mar 2026 09:26:22 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:25:08 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-23-vdonnefort@google.com>
Subject: [PATCH v14 22/30] KVM: arm64: Support unaligned fixmap in the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Return the fixmap VA with the page offset, instead of the page base
address. This allows to use hyp_fixmap_map() seamlessly regardless of
the address alignment. While at it, do the same for hyp_fixblock_map().

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 218976287d3f..c98cec0c150f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -244,7 +244,7 @@ static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
 
 void *hyp_fixmap_map(phys_addr_t phys)
 {
-	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys);
+	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys) + offset_in_page(phys);
 }
 
 static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
@@ -366,7 +366,7 @@ void *hyp_fixblock_map(phys_addr_t phys, size_t *size)
 #ifdef HAS_FIXBLOCK
 	*size = PMD_SIZE;
 	hyp_spin_lock(&hyp_fixblock_lock);
-	return fixmap_map_slot(&hyp_fixblock_slot, phys);
+	return fixmap_map_slot(&hyp_fixblock_slot, phys) + offset_in_page(phys);
 #else
 	*size = PAGE_SIZE;
 	return hyp_fixmap_map(phys);
-- 
2.53.0.473.g4a7958ca14-goog


Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB3534D92C
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 07:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791184855; cv=none; b=KiI3EDfhXwgWqTwTHWcNURSA+Rkjk5KytXWmqox9+urOi0M/N5HAdRiBqJkPn4tPMuSI5m7UPgnYuv/8E4JX8ngAvG7HOvd8EOHkur0uZcVFMmKaXKQlsoosHXi81PwnxrdXwnTfBHoF3Yiz9D/fsGnA+lOimoRhe+9z6Ht/XE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791184855; c=relaxed/simple;
	bh=UztVvrP3/qoq0z0m9CiC1KLLRGcckeoaS1oc1gDRxDk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RZt4Ixe0pCuUgDDnPyy4X8dZolh8UAnmZohzlCKxPNaFC3g8u5mF3XdG0GDwtmyYaaaoH4vfqa4qdPWMKDUmn8xVB1UvsyLBvX/Hdn7IcdHstuQ+rVvYRS6mDp130f9BA5RwFlgRXZTU639I5qisJSOdDXy2EPkXCL1tEQ1Mso8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KuTWMVYR; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KuTWMVYR"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a175fdc37aso418145e9.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 00:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791184851; x=1791789651; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VJ3aIExDf7Vwm1ZzRemWe9zF2SleuBxqq66clvypQjw=;
        b=KuTWMVYRLSJrL+J5/RhYkP/hjYArAIbSCU4mGvlzawv3WsoN4MV6Yy/QOyRWg2clof
         5N+NX3V+VJktmh9DKvgLZJgBaWVAtuGxCujyVmBuEvmHjiG1mBitA8iWZbI+5e1jjisE
         cTK89CsclNEj+EoprlnVFRAhMekiOBeqC3mIUma0q7oC2OMfof4RV5yjFBJp1Ivx6rF9
         BeACoLfAOIoFyk+wfEx/v3PCw5Doxtdh66b0dmZGj9a9ac1zuuluPpT5FpitCIE0YphD
         bYQLI4mowQpVb24NNz2KeWVLEXBP+F7a9IdtyahfZK2cq8caFReeSJEvoYtutILjYe7a
         zIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791184851; x=1791789651;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VJ3aIExDf7Vwm1ZzRemWe9zF2SleuBxqq66clvypQjw=;
        b=0qDZqPDYsiH9LR+InoTnUz9DisCCy3GGCb+8FgKWR+/AiYxPhil+4dADnfm9yXtFTZ
         oC2Vhn3ZvQhcG8LweICqiJFAi7xXz9cObdIPTShlp32S3dERoGE5oAZ3BD3tMTC1WeW/
         +3OlRiD70PuSYKqEvEd9+2snFuRmV9ZwyeepJkwwpkDC+nW04zWmbQDsO5PwxTDqnwdT
         eiudfhsBxyhTiWM0MWnMkK/GjI69yxdrzv5bipz9fNDhn4Ujll6MGmGzDofgRLVoIeQv
         zlZbIeZwajf+lYaFz3nyV7Bvm+GzpfIejQfWX+N/NP2yqA94JyiBR+Syx5PBmeMy0n5J
         ht4g==
X-Forwarded-Encrypted: i=1; AKwUvBzAAbVe6wBwhZeisCHe39HiYuNI6xTIFEMcjVrkIXTPFNutHcleRsps96tcuY0ykZI4UgFN9KE=@lists.linux.dev
X-Gm-Message-State: AFuF++lRoi3YNm6tE39rXerRwjjpVPX1Q/TeP1q+iZcUaN6yQDVd2O4L
	YCRT9OLKUtK9nGGRNqXffiLsnjYlJJwHdJiLsLm2PiWkgXyoI97y56r1cxDsJLyborvB5bCzrws
	NYi4d8UvmIEGH309A9W3TUw==
X-Received: from wmbgy25.prod.google.com ([2002:a05:600c:8819:b0:4a1:738b:7acf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6287:b0:49d:1df8:156d with SMTP id 5b1f17b1804b1-4a1680f5050mr86675175e9.18.1791184851211;
 Mon, 05 Oct 2026 00:20:51 -0700 (PDT)
Date: Mon,  5 Oct 2026 08:20:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261005072046.2246900-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: pkvm: Drop keneldoc markers for the allocator structs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

chunk_hdr and hyp_allocator are private. Their description is not
exposed to the API documentation. Drop the kerneldoc markers.

While at it add the missing description for chunk_hdr::data.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/alloc.c
index c1881c0011c9..e1e6dd21cda1 100644
--- a/arch/arm64/kvm/hyp/nvhe/alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
@@ -28,13 +28,14 @@
  */
 #define MIN_ALLOC_SIZE 16UL
 
-/**
+/*
  * struct chunk_hdr - Chunk header
  * @next:       offset from this chunk header to the next one.
  * @prev:       offset from this chunk header to the previous one.
  * @__unmapped: Internal field containing the offset to the unmapped page
  *              boundary, multiplexed with the allocation state flag.
  * @hash:       Hash computed over the chunk header.
+ * @data:       Chunk payload.
  */
 struct chunk_hdr {
 	u32			next;
@@ -45,7 +46,7 @@ struct chunk_hdr {
 	char			data[];
 } __aligned(MIN_ALLOC_SIZE);
 
-/**
+/*
  * struct hyp_allocator - Heap allocator
  * @start:		Start in the allocator's reserved virtual address range.
  * @end:		End in the allocator's reserved virtual address range.

base-commit: f0406245cb9855e6318335a8a223551354291a46
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A94E335BC4
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598593; cv=none; b=X7cGbO9Yo+mNUzjl5tSdAj9LpRCI9qqb62mZdYazW5jyGHmXCsM4g+WS6k/lxYPTo4xb+D7Tl34eg6Gtqksb51Bi06muaZfdy1/eb/gVVsZY3JLstAnEtDecHcu141SgSltxSbg3TVxjwkTSrHGfMUeQlYk6LJf/Up5E/RYEoJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598593; c=relaxed/simple;
	bh=2UhKxpWUkIifGUgfHcgz/LXU79xXY7bzYokZjULRNnc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JLgM/ZwNsr6ELTpiFxfU1KZ271lIP6N84GEoev/Mjpy1BttbAJY5eQSwPsZp57mGQT2U4hDTQ82Kw+A3b5u6xMQj79gxXzMyD7gQhttUyNDdboQQK2IoYMJjRoJKzPDQv3rjnINoVFhjSvM9mXBVzsZBMNGp3Ni8QF6Vzzr179o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cz2repXw; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cz2repXw"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3dae49b1293so457960f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 06:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757598590; x=1758203390; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GDn63HL1kwJS/kY3r585sacU2JfuR+fJZeZdcH4A9XQ=;
        b=cz2repXwCHqv2Gy3+GQI4RKkDu641G5+/LVY/+NATAUeyqEGjC37YII+l+o5x+ZiP5
         Y1IIWpPedHs5Kqjst9cxPzW8y3KaiOfWmQ0oQfTYw3XcLyRAfcG+AA7ITcPGSJQNOHLY
         bsFsCrZ0hDPpO6v5SgSUWYB3YIt94kPbnJ1+WHc/E4ahYKYJysoFjSF/UFjTM15ZdJd/
         GK2/GRUzGki7Syg0h9Emf1EwXM6UFnwgTzVmkNhh0z512KNjv0xiGXVtq4uYv2kBELLR
         nmubmNqAWIO2E4OPgW9PjSsYt4LZowQLU9wN3pfnH20r0EusZxMPsfDDF575de+nV5ol
         6L6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757598590; x=1758203390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GDn63HL1kwJS/kY3r585sacU2JfuR+fJZeZdcH4A9XQ=;
        b=JaksLS0uOzhl1JQJykpJ0HtoRRGJMYCnZX2SqeQKw4Kd2mffpV36bFTFfx8GlAHBjA
         zSgnRUOERXN18IgXvbFQaULvZSSiwQRtylDiTRoF7NlljkrZ+DZiCR0Leli0i0Ude1oE
         UmrNL2p8YKgZOnSvCvJ/uQLtqNUIBFo9UHCGEmDpKWmeBFW5GSiZnGalPryPn8RYdZLI
         aJiHu2UvvpgWIgxrmI65Ae5mRySfdJpNqXMk9EoMu6z/BFuXsDz6jenRw6Ch0dzYWOKu
         YGFRhrTdl+x/9jY6nNS58oFTljq22TNUHOV21Nsa7iLndToIIdisdSuBo0MHe5a0ifYH
         XqaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXua45POsokTXINxyW1uEImNzsOyBlRQFHpmvnszy3Ij5nZdL2ZhrRFUwK/RjXNN61DeuBE+Tc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxo9xJAwj06BWBOi8QZEpAjZAd+WxBSiLBKxXcYJTvJUKW5+Ey/
	vRyXvCcBJA/1NbcJX4Gx7IIwiia1gIrQsmgwOexrKRldP6v5gZjxDRRA
X-Gm-Gg: ASbGncvPCw1rT5PhKLygsEqXc+6Vozqy6Y++/lM0Yo4teoHt+YFCLH1+qhrklOGrHus
	QFkRotqaiwRprjIxjAz4+TEiqhCNJpM5fuuuVY+JJRz2lF1+pu0YsCd2tiwRbaKyn2kvPrw0ghA
	yTMgMY2z860ssIYq5RfCIMpbNdKyqaBouAfrUgm6NkoHE/hz+hM1GRL39MA7xYWsDTkAsE18e3s
	n/ziqURMGMg5H1G6P/caPVu01kNI55ASDyTn2L9OIt/P6y1PjH9qZX1TYjH6rBbRJbKArWeYUGL
	p7OJRd5InwxiLn2LY+kjp8/hhbxd5insYYPI4fx0sSm0WgVYgBKNVqepqk+n1IG2VbbD+pmqiyY
	pcdSkz7O9quhZ7v3q3ma1BJ2Fao7YIVf3fycySGG8GT9CBdEE40lBhJSHg0MQ9JOnXI+Qaeqc
X-Google-Smtp-Source: AGHT+IH6i2Rlk1oZZIkubpWUyVstEoqiFYIwX8SUUvSh7jWZ3DNV3Wa4AF6A7KNkrZ7i9r1nUbzyjw==
X-Received: by 2002:a05:6000:4023:b0:3e7:5fca:2177 with SMTP id ffacd0b85a97d-3e75fca25admr2356651f8f.11.1757598589695;
        Thu, 11 Sep 2025 06:49:49 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760778915sm2608361f8f.12.2025.09.11.06.49.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Sep 2025 06:49:49 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	isaku.yamahata@intel.com,
	roypat@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.com
Subject: [PATCH 4/6] KVM: selftests: Fix unaligned mmap allocations
Date: Thu, 11 Sep 2025 14:46:46 +0100
Message-Id: <20250911134648.58945-5-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250911134648.58945-1-jackabt.amazon@gmail.com>
References: <20250911134648.58945-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

When creating a VM using mmap with huge pages, and the memory amount does
not align with the underlying page size. The stored mmap_size value does
not account for the fact that mmap will automatically align the length
to a multiple of the underlying page size. During the teardown of the
test, munmap is used. However, munmap requires the length to be a
multiple of the underlying page size.

Update the vm_mem_add method to ensure the mmap_size is aligned to the
underlying page size.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c3f5142b0a54..b106fbed999c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1051,7 +1051,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	/* Allocate and initialize new mem region structure. */
 	region = calloc(1, sizeof(*region));
 	TEST_ASSERT(region != NULL, "Insufficient Memory");
-	region->mmap_size = mem_size;
 
 #ifdef __s390x__
 	/* On s390x, the host address must be aligned to 1M (due to PGSTEs) */
@@ -1060,6 +1059,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	alignment = 1;
 #endif
 
+	alignment = max(backing_src_pagesz, alignment);
+	region->mmap_size = align_up(mem_size, alignment);
+
+	TEST_ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
+
 	/*
 	 * When using THP mmap is not guaranteed to returned a hugepage aligned
 	 * address so we have to pad the mmap. Padding is not needed for HugeTLB
@@ -1067,12 +1071,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	 * page size.
 	 */
 	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
-		alignment = max(backing_src_pagesz, alignment);
-
-	TEST_ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
-
-	/* Add enough memory to align up if necessary */
-	if (alignment > 1)
 		region->mmap_size += alignment;
 
 	region->fd = -1;
-- 
2.43.0


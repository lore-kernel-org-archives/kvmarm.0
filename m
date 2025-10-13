Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F98A2153E7
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368542; cv=none; b=fXsVjMDOnfTr7APZflMx3snOgFiCeYBOM8GmqL0n5g5NyUroq6GmaTvvif/NO5ImhPxD8CkngTZaOlzAZdMYmprMxsdVqkA3m4ks0pjN77P2JaEJtgslmC9ZBetynyCQsD7jaaUqDhCtVU0xlwQLkH5d7zcff1pRMWOjFIz/FvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368542; c=relaxed/simple;
	bh=2UhKxpWUkIifGUgfHcgz/LXU79xXY7bzYokZjULRNnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwLMm7LFH8/A4rrm3A9HHrNTNEf6X1hfjGoNJWqRiXtHD8EsjEhr7MY4uZbsT0Ib4CQhn2PNsumSacvROHLZJMoDkeyeF7W2uUQqkUgTxwImgYlkmegUp7Zc+OO9UwrdUi1zdtoq1pxY6LdXFYEaxzDJWt2k/oBIcVFcsMdDE8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KseyYZIr; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KseyYZIr"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e5980471eso23142085e9.2
        for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 08:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760368539; x=1760973339; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GDn63HL1kwJS/kY3r585sacU2JfuR+fJZeZdcH4A9XQ=;
        b=KseyYZIrj+UKNCpgwMNtWtBw48SRw76E+SJAs/A9HrTEHLKcCm7U8nWCJz8gWFGZBL
         mqXNAeL+qz+W/nv5pDD2p8o5T3DIPZJ1y4+dgUqqnglflcoZ3jxrrWnRqNXHMBR06Qy8
         GG7UtQdf8ERauuAIOW2U9zoqnRobS3/O2crrTCUNUNSCgcf8fNdXv5jwPovM0x8MDVaL
         zJRmh7+kt43I4gtJ/j5m6qQXIaNZYZqfrrNSsfWhZ3WG9ippvVMUqHtxcsg1VQtj8Wtc
         cA9I/wZnkxzcqXocDE8yOm8fwUAf4J7+SKX71QumZsnRxf99+C0zASzbcwJNENbWFP0d
         enSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760368539; x=1760973339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GDn63HL1kwJS/kY3r585sacU2JfuR+fJZeZdcH4A9XQ=;
        b=tvnfGyuJGbcoqNgwp3i5JyJJrKtXV2ROn3PNaqW/mPrDdi3d+uivc2I1nBERLsS/H2
         4c3YgdHcnWxqQ781VnRRigQc+loeXbpLEoZ/mGjZ3YDM7Ew3b1FYCq8EijBfF/yzXrAn
         Mlp4C87hV87N8lWo40UGcwZ8mY75uixeaHxejKuoBh7bbZfDSJSE0Q9dVPjTSAoPqRBE
         4NbMfbvIJbl3NUMlK5UqrPiK7dIkflLoVMmbUeiHkJSuzQQmNcsMjotIru95tBoboH0l
         eUSSyCLu82jBGi6IXwEr6OKU3ecQYcXybWce6DctfjDk67w3cqzkl7AXQNktZAHiSu01
         xr1w==
X-Forwarded-Encrypted: i=1; AJvYcCWZ5wZCPOcjEY2olBWFJnATAPOjc0c8sBgjXHQTCkg8Y5ihZHiuc0D8Of8e6Iduaz8FH44nmVA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPIClLniONhyPlriyyK5NFaZqp2Et3wQqxRqW7j+U1HM52oRD1
	/X4KODAwm2SiY2oc+y1erjoqPOu6D+LeO0lNa3yP7Lip0K7d32Xk012S
X-Gm-Gg: ASbGncu9HKCI9MmpmhP9ASBuuGMzARqXAEAvVvgrLl8ZqQEqduM3FyetDpcE7TYqi8W
	c/4V36s9/4zCDwaRxigcOgApOek7nZ7ohmeEEvLSiT9ivTTCBuKjB9hL6tHWkDoJOgjM8pR3SWh
	XJszFwqh8nhrvE7rty6VUD0lNpO22JyVUJlT59ptSofHfOUc8ikXTC1RC+4mGrawo+1L/D3HV4Q
	v4u6np2+sC1iytDN/mKIqGrnjl22PgSUbSaqAWOi/O5Fc4/PnOc91sQlMa5JkrFjT9KA7WP5EWu
	upI5kI9R2Re2VqBX0oDY+LzBexBnKJ7URxaEjnbaXWy7ITJngP+ePPBxNXtFwu/WfncoKhhOR56
	uzMLQCj1FA8h5/wwhP4GCjmvRsIpNm51MTF9sIFDzSH2oedrrq0WSi7LoWzkSYPDyN2PImeyUVh
	OtRmZ5
X-Google-Smtp-Source: AGHT+IGwJqj5PmL4e2MI1le7nNOJW+jd0SIfBCswYBmaCJKr1jrFAghd2jBuPptFtHUN4Hmx6R2roQ==
X-Received: by 2002:a05:600c:4752:b0:46e:49fb:4776 with SMTP id 5b1f17b1804b1-46fa9a9f05emr138719385e9.11.1760368538589;
        Mon, 13 Oct 2025 08:15:38 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.3.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab36a773sm135545825e9.0.2025.10.13.08.15.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 08:15:38 -0700 (PDT)
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
Subject: [PATCH v2 2/4] KVM: selftests: Fix unaligned mmap allocations
Date: Mon, 13 Oct 2025 16:14:59 +0100
Message-ID: <20251013151502.6679-3-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251013151502.6679-1-jackabt.amazon@gmail.com>
References: <20251013151502.6679-1-jackabt.amazon@gmail.com>
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


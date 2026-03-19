Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E79122083
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 01:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773885268; cv=none; b=eX0au1eTLt0ylbO1rpdbeHbgS3P42NDlrwUHiTETMK4sAjExS4sRkticJ76sGw9CMAi1TDvtHYYwP62Aon96frhPYkZoQuMyRQs18KaLn4zOVii88lczrfsVMx7hMtXLJXsV4k9F0vK/s3o/KEypz3fffY1eYqq7pI0xbNK1HoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773885268; c=relaxed/simple;
	bh=Qh2vnbr/G0FbsYPFv/wdBgpWST+Ly6gdwfvFztr3eTI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hpCk6GT+X4Cf6cnnJJ8MKgHIfIPT8NJff0/YMJsKsdLisIQQAzbSxbA45GZtbegHaG1EiDdA3V568QoksupKvaJDYzNsDRw2xw8U/QLpXZXKrz8IqBnfunGbH6bbENZqqGzGT1H5k1AxLbHMH2pS0lXJhLmRYzvxYNE4r0rqW94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bubSGhRI; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bubSGhRI"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c74217894d9so378105a12.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 18:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773885263; x=1774490063; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IphLt+X2YEUN0QZS0TcE47jvN82gWZ8dBXENMhkBUfg=;
        b=bubSGhRI++o7ye5+J+w9D72ihq0M2q+VegVIFPhoGLNUqLiVAti8XNFE+K2hdM4Z/U
         G23hCwRfNy5VUcB0fstq2El3PzW/wt3mtSby5iChJclbD7YsTcVuDeajn73adYoLBns7
         TPO7fv0CMf6VeLYaVDceRXUEWa5A9YIY3H9n/z82KZzzN/2Wo2HLs+1nMg00fpts0Tf0
         4uHftTz41sHQwFQXM/K6Wot3GBYecVSPCcYV1qJWl9DOMyqAFo3zemPm04b6ov+v5HY9
         7YYCgXLgELvXh+Zeqx1lGgr2cT+jv05bt9vsDDRoI0qNfVu8IABeX2HXqbNMsE2d5oHT
         DtkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773885263; x=1774490063;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IphLt+X2YEUN0QZS0TcE47jvN82gWZ8dBXENMhkBUfg=;
        b=UbKMFPFcRHrIygt8+bV1QCpZe3+yYklGDhNjZR+mto/uZdxCm/dvSNOdSfxJK8192w
         71GZ5j5PqipptEzBKFMYC9oXIuLeXprR2y1KyN72809/OQHXVLYLoQtXKmIvqfHnCwoU
         o2QvmhOeazMkBHoq69QvsTt2VbGttMzV5jNCHncSkGtvgDFWUjQkO42x9YKWvfMWtTOh
         fjr8rYlp6KSIDz3AsGQp9WjMvIdrIGmyRenGJKIItufYiThmFlIp4dC1LoCZEwilGVBL
         gOqBojXYVo9Zp6OmJnwWsYHJh5Z1Wonq1CMWlDDolBeQla5Hqw7cVWbJAL6gU6lR9h5e
         1akQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTVNBgho5+0BsIoUwl/e3LVTOo+43lWrn14k5QsEsIMRYEPvLCy62dTW0AVjPU1wyQeAqu79Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyec+GEDeqFodoryTLZzDT0Lo1aaY0f+yIlR7ZWFzrXBYZm49/i
	0EknBmVfshhrF+TLCarVr1IPCJM1ItQRiT3Drv7pImGCbc2Qt+eET3LIccdEvtplSs+YoAEeUUg
	x
X-Received: from pgbbz36.prod.google.com ([2002:a05:6a02:624:b0:c6e:1f6a:ef71])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:b84:b0:398:787c:d2e4
 with SMTP id adf61e73a8af0-39b99d4bd9amr5301199637.17.1773885262711; Wed, 18
 Mar 2026 18:54:22 -0700 (PDT)
Date: Thu, 19 Mar 2026 01:54:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319015418.2871262-1-morbo@google.com>
Subject: [PATCH] KVM: arm64: vgic: Annotate struct vgic_dist with __counted_by_ptr
From: Bill Wendling <morbo@google.com>
To: linux-kernel@vger.kernel.org
Cc: Bill Wendling <morbo@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Gogul Balakrishnan <bgogul@google.com>, 
	Arman Hasanzadeh <armanihm@google.com>, Kees Cook <kees@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	codemender-patching+linux@google.com
Content-Type: text/plain; charset="UTF-8"

Add the __counted_by_ptr attribute to the spis pointer field in struct
vgic_dist. This pointer field points to an array of struct vgic_irq
elements, and the number of elements is tracked by the nr_spis field
within the same structure.

The nr_spis field is initialized in vgic_init() (or earlier via
userspace) before the spis array is allocated in kvm_vgic_dist_init().
The nr_spis value remains constant during the lifetime of the spis
allocation, making it a suitable counter for the array.

This patch was generated by CodeMender and reviewed by Bill Wendling.
Tested with the KVM selftests.

Signed-off-by: Bill Wendling <morbo@google.com>
---
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Gogul Balakrishnan <bgogul@google.com>
Cc: Arman Hasanzadeh <armanihm@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: codemender-patching+linux@google.com
---
 include/kvm/arm_vgic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f2eafc65bbf4..1cca87623d92 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -284,7 +284,7 @@ struct vgic_dist {
 	/* Wants SGIs without active state */
 	bool			nassgireq;
 
-	struct vgic_irq		*spis;
+	struct vgic_irq		*spis __counted_by_ptr(nr_spis);
 
 	struct vgic_io_device	dist_iodev;
 	struct vgic_io_device	cpuif_iodev;
-- 
2.53.0.851.ga537e3e6e9-goog


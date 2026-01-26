Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F59337BBA
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424289; cv=none; b=YzhBpU1wv/x4YRCikOTjm2DlylwQNOGsKiO8W+4wLwbZMsO+MDDkstAXfMqp8vercoKiStTwsMoe7i/oiVH16EHN5QAYymS41ahX7Yg+rMd1McrosFjYhKDZKVC7X5IwuPaZrxy+9zLuCKSAIjq4F+C0oYUDcDe4xFTUFbt80L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424289; c=relaxed/simple;
	bh=oo4/5f4YHfSVUMNCfUHjyArRgPM9xVrZtPhrVV+hXu4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OaWBhXSY1E+yQqusB3fADYz2qe5Lm8uNKp74M2Ju2E0e2m34C7ApOG9G4uHwiIUSGFCRxHSpbcUuYx5lnp7LnTEZ3uaYdsFgQjsB5nazs0B09WKy1brkYAHI8MRqmyFHy/ORcRRpLA7FOQxce+i+BqDn76myRAmTM6NYalJuAyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RkTwBU0G; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RkTwBU0G"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4801d21c280so28371735e9.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424286; x=1770029086; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JHa7j/CKtQd71sr9sGVN3KtiKJalnxGKPFOliEGiPCE=;
        b=RkTwBU0GFiz0L7Gz4DoeAfTVacdltvDoGvaaDh2brSqQMwQYkKCxnrW3lqHp6nmSR8
         X3cKIwq2kYAhUDDK2m0G6PoRkaZ0T7Xc2BUOExODtND/CS+AUHNIwUUPmOEGSWXPHnh6
         LtGCQMCj740s3XCN3WQt6ns+Wb7T8OlLYEblTddVFAnqSopTEOTYWlZiSQPoxv/V+MgA
         UswiFwJ/pxdscmHeyXJWOuc6xO6gOK7uUlR13suJDRpiEyv7Ry77CkUEjJlW+fcHmpi8
         kFsC9bWXFTzYnDfRljGVt3W6NDq6iJ0U1CB2Tpw3rX7Be6XvnX8Itkb7h+hPxKT4uG1S
         +eag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424286; x=1770029086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JHa7j/CKtQd71sr9sGVN3KtiKJalnxGKPFOliEGiPCE=;
        b=MvCApeqDOcC2hj90sBtV0r/Msrmf/gx/IYEyfVW2B2Qd3DwwnBnWt5BaR9AdLny4ZJ
         dd8YBUsHSb4sFHwC8XplVKR9NGpzofCaJPRDYkaQTN4u52tO55JG7rtml4lINtobMsfb
         w/E+0gyM2NYvQrbh5+/qG8JJIDyPTsTGySYqCgaRmT+3Zu+5tNrI/QNHi4rirkQaLk9C
         Hdwzy+iHSO5fVuiqtaLwXh6PhLTmB0My/T9nisuTXfZjt0+BtNcLEE6u488mco7fkFN2
         65nIaGOu4SrR6m8bYQQ9JvXHwAtDahYLyapHlhXD6eKyzDfRk3JTX9d3EYTRzA5jvtgD
         jE9g==
X-Gm-Message-State: AOJu0YyPOGcBM85rZjcZjGMG1hZ8DrrpqPuyU1VhhwNUx7a4i9Ere3KX
	e6mOhZncS6PfIm4/TNq7zOATzg2tQwpQsVW3D3EnHLRhtBgJY+7/96Uu0C8ZfAhN1zvGCy8vApN
	b6MTalLeHDh9M7O9PYyThNA==
X-Received: from wmpx5.prod.google.com ([2002:a05:600c:1885:b0:480:4a03:7b7f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8a1a:20b0:480:4a4f:c36f with SMTP id 5b1f17b1804b1-4805e6f7fddmr42640155e9.21.1769424286085;
 Mon, 26 Jan 2026 02:44:46 -0800 (PST)
Date: Mon, 26 Jan 2026 10:44:11 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-23-vdonnefort@google.com>
Subject: [PATCH v10 22/30] KVM: arm64: Support unaligned fixmap in the pKVM hyp
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
index ae8391baebc3..a6eafd72f87c 100644
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
2.52.0.457.g6b5491de43-goog


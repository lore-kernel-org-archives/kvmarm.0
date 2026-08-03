Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC24A371D02
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751873; cv=none; b=ctDo9mcrxLOZ4SB8C3ezq88stfneyK6l3RdZms38LfiHg/MzjVpYNaUdjAsAVRpg8qRllB94wuDxQIvDtz0jBV4pjRhrcL2oWuxtePktoNndg3F5qiiUpXiCI+iXtIG+64kUAxoglYNczBZbXobfkX/UbUqeNHFPbMi4cqqi9rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751873; c=relaxed/simple;
	bh=vGgE3sDaJXIg4YiCqgaqsLHSF2gFHqx5HCNVTyvX6ro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pmJYobF9oLd/SZFXDowwrGpLEPS9oGAtX9le1H0ySXXpt3EWBUE71/x2N0LslCMR9GdJcs/H1EtvTD8V8fmOTPTOtjVrnkTueNah44t+Db4SNMqbw+4eVVm/fPA4u1EhsXnWc4rhNwJuwsj0K66W6ZcWJxJyFa0xB0YwJcyTV1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dNcNmWDU; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNcNmWDU"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49571407d1dso13553075e9.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751870; x=1786356670; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N6TeYs4RXNnlLq03Nmw/3D+up68HnwIKjwAEcJQqjZ8=;
        b=dNcNmWDU0TnEziY6w9eeMSeambq6U4Jrc31nmxbLjZQNsV3DactxkCSrgHWLXG8JaJ
         iycppEtYr6ckKb/vftZnarlBk4+kuf4iYPBLInyVsSF82APhDFnSavsHvZLUH4p7ByDJ
         CZuK63OTs2OG1JYl3CTT2xVKGTq7e/0E1hAhcAy8FNzzjmLaDBdNgDrFNfsiiwa9S4mw
         WXJvwhbtDyeWshLN1pwp1WuRNaG5sWn414F4KInRzmbkVRvAm4ECJw4a4rQb4Sgy/Jk0
         37MRWcIKsA7egjGpCuGubtoST2VFn+pdNeIvUH9N3Blj5SubooagX5TrC0/z298NNT/O
         yJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751870; x=1786356670;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N6TeYs4RXNnlLq03Nmw/3D+up68HnwIKjwAEcJQqjZ8=;
        b=elGGYoszd7MgHtri7/ncwIQTht0Zbw/F66Xfe29M91Ie3G5JSty+Sr79pKHu14DeJD
         BTjiNbaHiizvf7yBbV1mmLjM6/IN+WPCa3kZATWKA7X7/6bVBcpMs+Ujw6q847+A+bjF
         EFlbzm35ToHEliBeSyhWAKeYFJ2kWRWxwPNJboVOtmovlAeihLuFYqTAz+vZJyYZ1+yO
         s2SZd/Z+1kyNSp/IZUWwNjUePzrGP/VFv6mc+JZcF6h5TqV5E5Km5IE/n9Yt4uxWL/tz
         njhcPuozlihx2pYNR3vmKAUTmnTMDkc+7PmEhtkgMAR2TkOLOx1lsXYWtLbO/TWS8dXB
         8UxA==
X-Forwarded-Encrypted: i=1; AHgh+RoiXVpifpEaqiCy4kvdC/iDM2voRRygYfSKAISOWjPpu5W+fwwsEj2NuIX8l05emZng/7AQgH0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxavmaz6/tXg2zpnPs9u/jRQRh2KDwT+BLiibyyTVP10W9heVim
	UL5+2ScKg6RubM1VtmSkU69gYpPdHwxiaNQthbucWA4mB631UXil3Ir7Qw4ZESYdNm11O/cjIAy
	3Xatn4C9CwHuYXDIR+RzcbQ==
X-Received: from wmsk23-n1.prod.google.com ([2002:a05:600d:8497:10b0:493:e006:3161])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8711:b0:495:52a5:8829 with SMTP id 5b1f17b1804b1-4980c652515mr251315495e9.11.1785751869935;
 Mon, 03 Aug 2026 03:11:09 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:57 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-14-vdonnefort@google.com>
Subject: [PATCH 13/20] KVM: arm64: Handle huge mappings in __pkvm_vcpu_in_poison_fault()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
allow __pkvm_vcpu_in_poison_fault() to work with PMD_SIZE mappings.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 47c5c6b4869e..2340706e41d3 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -964,7 +964,7 @@ int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (ret)
 		goto unlock;
 
-	if (level != KVM_PGTABLE_LAST_LEVEL) {
+	if (level < KVM_PGTABLE_LAST_LEVEL - 1) {
 		ret = -EINVAL;
 		goto unlock;
 	}
-- 
2.55.0.508.g3f0d502094-goog


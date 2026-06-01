Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4903C0A02
	for <kvmarm@lists.linux.dev>; Mon,  1 Jun 2026 14:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780325615; cv=none; b=Pj/QGdmevH4yrw8nMr9h7SQ8KdEjGPdc8xh4u4J/lrJHi3wj5vLHy1qMw+L86/HKuyjnaURckg/BxAkgptrxGcGgV3YaFjzPPRv/VhdK56DHkT85FM+Jn7FddR/P0dynhhwOrr4Oo84QeOtz726UtfU1pn/M+5mZ7iZAxdtwH9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780325615; c=relaxed/simple;
	bh=w2mR078FU5SKyF8iU76eGa6vXLrGgT0KaRUbbDZdrt4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QElfqdlBnOLXlmQ+C0w9exmWgIuvVYusiEknywBiKIv+p7hH55PU8ipGBoK29ibPdaLaB04+uA47qTHdPGoG8eIQoww4mvj0Vcq25nWr3KW+KMeohxq2bKwhNYWDVvDpudlp1eXeN3k/1XtlhBSFv8bRBKB2lQmki9XEF4BK/1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FT/9yYmc; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FT/9yYmc"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8422a92b6d6so893577b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 01 Jun 2026 07:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780325612; x=1780930412; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MrfSnj/PLsXTbxRf/etluSw853v8MTiPenNyLUiYWok=;
        b=FT/9yYmcwKyhqmqoFhqZF5UyUoLyvoh/3wcVTyUkLeaUB3y3XJ3rvuJNJtgMgj83uN
         VsSKkCrH1f4n4p7SkADIBmnKRPHk85UYkS210oxaVZDyiS274yTs8qN4tzEyUNY4munL
         egReHShCCOXsWnOpTvpzDg6nYyKGzIyYSG7g3ojdHPl8lbs3nNxAMQoV1xTQQzgn4Zve
         tuU+Ga9xN7mMiMGiRlAk8Wbt0W+uIQ/tfLrpUHVY8fyyOGx1lhxV+uMZMMZEhFuZ/C4O
         5HDgVO6FLPvkSFgdShplJXWHya6WF159SqSxSTJV0AFRR0uRqpoeIPounBpjLTdOufVI
         dUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780325612; x=1780930412;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MrfSnj/PLsXTbxRf/etluSw853v8MTiPenNyLUiYWok=;
        b=rcXny+1z9mvtscCyyoApch197TxRdNfB5r4qZsVo4NgVYxmFzBrxlB7V4ZkOcCSTux
         War+k2LH2vvePdvGLqYJ+ISIRlC8xPHBEdQ8kZIv+WYhxgKBxrDCFgT7qDHKmKHz/6rq
         ZmBw7HDPVEv38u/SIfJoAfP1C9BUjmkcNtS2G3XF+1ax2/c1JadhanesxsQPjWIYImMC
         oQjZU14Vd81nAWVSApzTKl2IIHzJGKUzyF4MQME0rmrtxCqPvnWs41dCksQXbl8PSJzh
         FGus1dsDm0BQTg5uIq9hHuYc1KkaQbxy1CGku1WGGwUZYg6lCTmnTdF/aKik1jxRrnLL
         WWxw==
X-Forwarded-Encrypted: i=1; AFNElJ+6c0IH6y7MqeuTS6RWld5P5Va2U1WPfwG3CbYghDEQ+GXrDThnw65DP94r55mU8PGYweVCinY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIogS9dtKa4vyz3ZHANtZU3VlT++nJE3ORMUSjFh3xUgT81uQ2
	jFawlP84uUv0+cmIZJ5Uui41RGORpqrgFdmcAeuhl2yYuV2x+2bgBe4z
X-Gm-Gg: Acq92OENgrWT+g2S2BLf5rqCTFqszgwnet3Yl3xF+FvoSX5rM/bCr5/aIG6hy+gxv0O
	bOb55sML6viH5GwBGlGjk/4EJnwBtjvuaRlPYTOBJFPvZKEjqWBUpIsIaom4GFczQnkwrmnOfqz
	H5jsXKHX+pKyW4vYXlwfSHoCAFAGJgs4bjMyd8Rx5PxBSr8JzaGyHEPN2OgIMLhKjrMGYA1kVbv
	+kFFzTivSb+MXELNMyleZH16UjnCAaqQqTHT4NeguBJbfkQqGS7KqXcyIP7hsS7FcShG3M375Nf
	rgOzHQ51ccGTpg+SewLuhOIL4heLUkuLC2t+1uLhyDtena07+3tmJKuN6Bbdb8AN3J65rbQxRLf
	8srEaHsNLQwOP8T3GPYizyUmCZeJttC6vDgWWmM/c1svOcRHkZvr/8s1QVu7DZ28SKuNgMD+4Vr
	pyS0Z/nWFbAFE4rYNQol4l3V4M0e25vijTexig/u8MBzABbhskU2S7rg==
X-Received: by 2002:a05:6a00:1310:b0:82f:51e8:b38e with SMTP id d2e1a72fcca58-84210c54cccmr11705575b3a.24.1780325611586;
        Mon, 01 Jun 2026 07:53:31 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8422e712309sm7686388b3a.59.2026.06.01.07.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 07:53:30 -0700 (PDT)
Date: Mon, 1 Jun 2026 23:53:26 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kees@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH] KVM: arm64: vgic-its: Drop the translation cache reference
 only for the erased entry
Message-ID: <ah2c5lu4JbUg7dj-@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

vgic_its_invalidate_cache() walks the per-ITS translation cache with
xa_for_each() and drops the cache's reference on each entry with
vgic_put_irq(). It puts the iterated pointer, though, rather than the
value returned by xa_erase().

The function is called from contexts that do not exclude one another: the
ITS command handlers hold its_lock, the GITS_CTLR write path holds
cmd_lock, and the path that clears EnableLPIs in a redistributor's
GICR_CTLR holds neither. Two or more of them can drain the same cache
concurrently, and if each one observes the same entry, erases it and then
puts it, the single reference the cache holds on that entry is dropped
more than once. The entry can then be freed while an ITE still maps it.

xa_erase() is atomic and returns the previous entry, so put only the entry
that this context actually removed. The cache reference is then dropped
exactly once per entry even when the invalidations run concurrently, and
the behavior is unchanged when only one context runs.

Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 1d7e5d560af4..1e3706ac3b8e 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -597,8 +597,10 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
 	unsigned long idx;
 
 	xa_for_each(&its->translation_cache, idx, irq) {
-		xa_erase(&its->translation_cache, idx);
-		vgic_put_irq(kvm, irq);
+		/* Only the context that erases the entry drops its cache ref. */
+		irq = xa_erase(&its->translation_cache, idx);
+		if (irq)
+			vgic_put_irq(kvm, irq);
 	}
 }
 
-- 
2.43.0


Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAECC185946
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047059; cv=none; b=hDkkPy2djeSun9aYINos0IZy7v70JTlF1WIeRVsyzebYAKiR2jmwkfYJK1dSzdrBAnabQSOBo2/5xiNL60Qarz/xbFB77ePWU888lM7UTHXH7/87weP8gU51ybJufKoyRJvj4vjSelYNM4RgGg95e5AVO1jisx45FrjgdYNaRmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047059; c=relaxed/simple;
	bh=WyNAlQoRSlaQbJNtJku/DZE31pU2tETQT6EsDmgk7cU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P9TFeJgYUZDDZX0skV/ZstfmhqidZgGZTiYiuaxAzwv54PIx7hNWaYSkgOF6QBY+LyQliqNyW6G8DztBBWhNMm9FHWmI1i5hz6Mt8FwwCgDxMz+51WucXn/DBfZ5MpAhVZkTA+80yC/YGl8/qCQZTDwwsnYHuH4KdyZqHCvTUMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IYDU7tTJ; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IYDU7tTJ"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-374c3402d93so3503101f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047056; x=1726651856; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yejuAYdn5/QbIt85/V9/g+97PUpnS0RfPemDihHOcTE=;
        b=IYDU7tTJwhhQzN/4ZiBvwYztYsJR6slFcH3hFXOrVoT0nOLHHXIcfl+RRuMph8v0D0
         /rr9iEKlDKbsOIA4vYDwPX21ok33PNuPhFo7k0U+SPq75lyRpy/36BrEfRr5ScEEnrv5
         +GGSU14/vRD11nWhLM5Em3BXGeic0WFzrGGzstHEwFcmPmXHAqzMUFWhqJqs8p0+dGFY
         flmPUhcwMFDkRYyhyLSUkjscVwGA5s+AgPwKq7QnpVk7HX9Hyj4Xt5QML8VS67Dz73Z4
         AyRxSe/ys5tHXbdQ5auQPD/hrunCzKCEuuTWCcfxtHErkpzlO4cyNAa9GEvxeSFQzrdF
         RHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047056; x=1726651856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yejuAYdn5/QbIt85/V9/g+97PUpnS0RfPemDihHOcTE=;
        b=UFm0DpEzfnC/KwXPrPvSUdqcujVQZ1wSBUmHz2moEbR8g7fkE5jvCUh0nkweGoSMpc
         bs1ZK4gIuyErBp6ljNiJ5UKb4922E7wy944RKmfsH8Y+Os/vHfgnd7AFzsVLCJhM7cRb
         woU/4f+HXkW/ukjsDvIpXjAxyiprjZ2v9sMHdmPbqHPLhg1QdX+R9jLa7OdXtpMHeqoU
         5aQFGia5QUYdMu95C5LBJLktcFOakHMIzXGFxG3vmlwrnTvvJLRpmP87woLzKSIO0PPl
         mh9NFpOUsJVRHctAchSzayZk/M2G/Axc7VzIB8qByQ8HhH5Bhn4piRwrzt3M2LkCdLyf
         LhrA==
X-Gm-Message-State: AOJu0Yw3cZPK3DVCab0AY4rk+ecUJOBsj52FLsKbJhP6sX74anEJIAE4
	9BsNjRlOFQIr/3kkPzR6uOGhBLlVFvvL8W7He9g6SxcEAazMKaHyPfvssIEtqLd7S2HEeRy/77g
	9KH05aBqnrSfi9EbrSw==
X-Google-Smtp-Source: AGHT+IH3JK62CsMjZY6SFuOrVbxoHTbhIFQKDf2kfn8b46cEmKNMGKp9tKKeHqg7ZrDPIMVbTdlp++65L0GaDZBF
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:adf:edc2:0:b0:374:b238:79e5 with SMTP
 id ffacd0b85a97d-378895c63e4mr21238f8f.2.1726047056142; Wed, 11 Sep 2024
 02:30:56 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:21 +0100
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-6-vdonnefort@google.com>
Subject: [PATCH 05/13] KVM: arm64: Support unaligned fixmap in the nVHE hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Return the fixmap VA with the page offset, instead of the page base
address.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 8850b591d775..c5a9d8874eb2 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -240,7 +240,7 @@ void *hyp_fixmap_map(phys_addr_t phys)
 	WRITE_ONCE(*ptep, pte);
 	dsb(ishst);
 
-	return (void *)slot->addr;
+	return (void *)slot->addr + offset_in_page(phys);
 }
 
 static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
-- 
2.46.0.598.g6f2099f65c-goog


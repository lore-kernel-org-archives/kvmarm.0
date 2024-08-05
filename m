Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EAC15C13D
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 17:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879228; cv=none; b=Yo9qiUezPGOxHUN+GQfHX/kU7yybloK3yyu1VRg9kS1T7G5Br8kpMB809xWX4QyPQIu+mOZEqWZwkjOqXfsSIqD8iPLjciVem+9zrgTrsCGE5rNs0hJV+7Et8E06agbIgvGA/UxdbrD1wNc5SAeXQ9XC2C0523e8JAIM2DaOaH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879228; c=relaxed/simple;
	bh=Zfgo2T5Z8ixTevEHjtLUGGbCOSi8rIMCmEUR2CFBOKE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aXC5KLhHTs7oB/u0/eSDlA+FyIhkqQvru1gkdZHxkpWIGcS9GnhiTBBdxut3Rw9r1GVBKrnaopiiYCwVQevRKQkdd+92FDny+7JMn9wv9M8maQtxAYEVehLGsxQHysts4IjWo5qiR3HEgfEOIKEh+/Wz80Xv6UjaM++z2m3QGTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vflg/OLT; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vflg/OLT"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-68f95e37bbfso56617027b3.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 10:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722879225; x=1723484025; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H05O9T3Ox5CpRnJDTmEZCPImDa43qtJg11hSfsrrifs=;
        b=vflg/OLTJ1RtgVMjE8KjnXnCYhnZ73VT69iTBOvuKMKanRQi6PM8UCHwSojsMhycsN
         ZgIjtdJvjH+UTiymOFHMEwOjMFSPPjs7pTCJ3+DcIJtPk3d8qPM+KrxEgkGvaJcNa4X+
         MUIw4ckQYVv1uN9G49xdfufvNIfI7DSSBmtdejXvQpMWPBYbIKenHTRZqtVDJHFAMHga
         2XnuDYBgYCSBXAeGDCEInW4RZoH6/AnQmkIFchNSK9lDvkPLk1brIF8uyeGjJB2KWK0v
         l8DCg2zmeYaFZaKSoPxTLj0tVLGHckuB/3bvdvoGY5cdmWl7rG+TEjuwORPzfBZXt2/f
         Ly2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722879225; x=1723484025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H05O9T3Ox5CpRnJDTmEZCPImDa43qtJg11hSfsrrifs=;
        b=wC+sdxbT8uqAQYlxfZ9ByYmQ2hmanrz0OellCdGjYgrXInXhnQsmiZRp/wti8Znoc1
         XPOkdH50u53Wdr4GarJ7soHfBTjkgal4cT+FtDA36lpAPxnLt6dmX0xMWt5U8OvWHoFI
         YuxArt0XF6nlEW9CJCAa8oCsQ12X5A3lEixUEwNmfXezzF55ekRhlwiuM2TyclgUCZT7
         p0/EBZchaH/4WXgEffRyrX0ks3cVx13BSBVYCtW8fmfBfqTugjFnF3DOsjbkCj6ystLM
         Y90or7Ir6Fby8dCufxsb9CZoLRXcflICcAc233mK+rAh6K4Zw/LXCAewVpR+uGQVj9Fc
         l7UQ==
X-Gm-Message-State: AOJu0YzWoD5z5gNkoIEPbdpUezbICrKVVvIqSx3bPSXosUURgrjfkzZg
	5tNpi5FZxd+8EvWx94iBBAdRpjNUSWSOA1ltq9jOiaQ2RsswqyPV01nkSQil5ZUCRgg+Y9U0tVn
	2w2vuBxVQmMG0rvyY2Q==
X-Google-Smtp-Source: AGHT+IHsOD5YRnEw+D15bNoyyt5n/Vawa4b7qZVdFbq8DEDAkiXUJYvnAc5v2UIvgt8+ZyRPnnfMKxSEZPVyBIL3
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:6902:2b02:b0:e03:31ec:8a24 with
 SMTP id 3f1490d57ef6-e0bde422b24mr78861276.8.1722879225124; Mon, 05 Aug 2024
 10:33:45 -0700 (PDT)
Date: Mon,  5 Aug 2024 18:32:28 +0100
In-Reply-To: <20240805173234.3542917-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240805173234.3542917-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805173234.3542917-6-vdonnefort@google.com>
Subject: [RFC PATCH 05/11] KVM: arm64: Support unaligned fixmap in the nVHE hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
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
2.46.0.rc2.264.g509ed76dc8-goog


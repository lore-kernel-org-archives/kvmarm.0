Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5744528A409
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550149; cv=none; b=gZHiMXdPNixlNlJHfk0ruCUdsm/x7DTV0xxKEsARWEYftUhAeqIeQMI6XIK6wK7/QaKCiIvpIm5RPkj+U9gtNjOYoAK2gYSTjOzgmyu59+5X73XEnJhNQIoK0WcS+UmAgE8APS+E41jf0IKrK6MpDArEG3yMFR7/qBsmLUO+VCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550149; c=relaxed/simple;
	bh=6nhV7XpN3WZyy+/QohB9tJlpXsrab2K78OgulSH7QaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QJrNOPdeklO0k0nfSv1piSXxj+HXO1Z3oW9INnFji3gl/As6r8QoGQY1qs98apIAPcHvPB8myxG3grySHlTXbJoO0uHzxHYmn0B/rEDnvBtPOO6zZ3FRE1v0i75UJonuF67cCP4IVVlXGnjhRmgelU2zdA41WBpwCNaFDglLNGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x5FDfwkw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x5FDfwkw"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-441c96c1977so18404735e9.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550145; x=1747154945; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uwe9TWcp7UhmX4oZw7S8iXQCB83ssWQWzCZsAER4ojM=;
        b=x5FDfwkwmduXyZShRPrJ53pa5aexNYFSiUhxU+N6dZI/n7puJ9AKI14rynxofewkUg
         qCgoWgoyGJ24T/Q/OCtGznSecCkEn9vNUA8d6Jx8hFAa+YVkfWQn7h98tVWcKAJh/zfA
         lZlZ1kjvl/sCYhuTwt+7sGGOqPzqTrkrM+Eg1wNaSXG4cZXFO24izzo7QHNF2/sgwcBV
         RrkAr4KSLOATFgKHVn4LxmIGhHhwxTTmk7Th3VEA/kpWfieYFVgz+SyaodWOyj3tLmuo
         L0rsfqrAJXRxgjRoQ+6GQivtTosa85TCQrzJKg1Ez17SW1q2VbRhVIAzscRv80+eYnnG
         WlMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550145; x=1747154945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uwe9TWcp7UhmX4oZw7S8iXQCB83ssWQWzCZsAER4ojM=;
        b=sE9Y6WcvVmUm3UvFv1nzSV8BeVD7kDs5VWmwdi8XpBQEoVu8nS39FOmBBw5YNabR1I
         +bue+UdQ/h5PS5Z/2KDfjkGYkd2u6XGHy9CkLZsQ51lOASjSKxBeKFvBYwAigzveaAJw
         PopevECFiXPsJmKikhZpVEzoqtd2sAlp60fuwa6nJX1hPM0JB4CkqNz2g6UoJ/eI5E8P
         HtQtzo+hqN9a4WO6zGmWWnJ18inWHAUtklOi3TaJBxJsT2WV8Ao0R90rIr663lm3vTm/
         ni1MzGfbIJp/b6hOlllId3D9F1s/NdlzSQdwVdjevOvLABheWmDBEUdP5QdWPzmdgfSz
         beUA==
X-Gm-Message-State: AOJu0YxtbsgXAS+gpeHEpaOt4DmZxJRjnZg++/f3lRZtspMUQ3qO/YeV
	U1RqQedoXEABQtP+F5Rk/KJ9DCV/lGQGxUMfntvCp1akqsL8yCl1eb4nR9EVBj7mTVY+hnfwa5g
	qOU0OtUXV6z6ezMs5mw==
X-Google-Smtp-Source: AGHT+IFD0lWDGk03I/L52reS0E96znl56Cu/MfnVewrpbgBLyMFf/ajBPFdbrDJBI3q4GHyXoNdIe4tdhRJb9WFi
X-Received: from wmbz22.prod.google.com ([2002:a05:600c:c096:b0:43c:f6b3:fa10])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a03:b0:439:9424:1b70 with SMTP id 5b1f17b1804b1-441d054c884mr38006405e9.30.1746550144942;
 Tue, 06 May 2025 09:49:04 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:10 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-15-vdonnefort@google.com>
Subject: [PATCH v4 14/24] KVM: arm64: Support unaligned fixmap in the nVHE hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Return the fixmap VA with the page offset, instead of the page base
address. This allows to use hyp_fixmap_map() seamlessly regardless of
the address alignment.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index f41c7440b34b..720cc3b36596 100644
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
2.49.0.967.g6a0df3ecc3-goog


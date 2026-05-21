Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6C93D75A0
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 12:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779367588; cv=none; b=iE9SGfxNl6aZWdl3fbps2SOSk/QcccYmL5ettTUjVHDVqyb9ONSUDJGzukgP0IvjluaAYh+X4FHFIotf5TOIZYjsDAOAta1B0mAk2VEnFHVhlnmp5x4s1OWw1+XHsY9fAFXblaQEYn6YXgLnUKBNOX1sNoDNRvzgCFg8f/5/RF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779367588; c=relaxed/simple;
	bh=zqHLVl1+KIOPvRWlg59jJNowpfgMDBqDDcs45mcnUPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eBNgN1ByvSY30bg3UWZtgiRrlhAh5nOKl6nMmwCp8VRZadaeIGawox1jGIbbRvWpCso6oaeeZhNbRuAOJeDJOEWNRP62pWy3n81fQZRqftiGW5mom/VO/4tDkS0wD4l/r0VIssCjH1MHNk0pndhvuvHWxv5CltPCQIykEtH4VY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lo+zbLR7; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lo+zbLR7"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fd8162ed7so44304125e9.2
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 05:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779367585; x=1779972385; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k5/wPOhYT+XNTnHhWuUbsn8hIMZp5hhEHwfl/Nd0UJw=;
        b=lo+zbLR75UABRrDMItEd6HiyJcVXQ5p/bige70QgT8+g4X6s30thPzCSNJOhRch4oM
         wkJInWN4Q/m4P9Gp0eGvUNVa5kDZi8VlISoA01smlbs/6AwmLep+APh27OMAHkqVxpzs
         9KZtPlurMexiy6+OojboisCGPUTW1D1qeS/A29qMk1QSu9ns216enCNkUScUluefZ2V5
         t1+0iLSd+Dyi7xtJGkboSkB/N+AByb9GPXjwAeFnsCBUONfLQvGdsITbYJ3HJTAlA3D1
         aXx2/8hCAfLzonBVozTYSFbNF65WHTChvf4wIiQ7ePxGbTwONdhMZwjCbpTZm9YT/9Kd
         HE3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779367585; x=1779972385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k5/wPOhYT+XNTnHhWuUbsn8hIMZp5hhEHwfl/Nd0UJw=;
        b=fg8L/SwaBH/7jY/d2odkTQywIXCcWxc5QmCH0RUVhPB8t0qEEqEPR9huFqBV6uVre7
         SXFRy4imGnKNa7r84LQuqxLMJQ+iDWOmB1ZU0yPQpkMK4vTS8pShug2lHRw8sNFXpb8t
         1iwqmtUtOgo9UAUzbvvo55PuKuIIAFQQ5az/tfcKfxwjpvgJcbC30pYPqSKEdi1G4G6i
         VYwtHEs0r/XlYL0B+T8yN8wa81g3XGZFSppO3q+TiyE6rGUwRh9JN5t030v7ivrOtHBC
         FV8roXn7X2eeuKAH4ZlIBoZPtwRzG+PFkb1i2IFJKSwpYw1jqD/7ia6QHo9BHNramB0Q
         bxUw==
X-Forwarded-Encrypted: i=1; AFNElJ8eTibmKH/FvL72Z81KdzAfWMW6/HZYbwreRB9QzNGPMna4zbnt+j76JZs7JqULTrfQLpQ1k7g=@lists.linux.dev
X-Gm-Message-State: AOJu0YynVEUL3CVop+qys+jNvIXvDokwUFhVUVf7s8cVQbpR4GbQOl9R
	rV21WDvGC2OPL8j4+Nc5uMxwNR+FSx3vdAfb7oM0fojvtjiNYC6vzsH8dp+66FHqDg40W76MuR1
	YlS4eTith0gGIQ4TXXN3Qpg==
X-Received: from wmrc10.prod.google.com ([2002:a05:600c:aca:b0:485:3a2f:2f7e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b0c:b0:485:4388:3492 with SMTP id 5b1f17b1804b1-49036036692mr34346335e9.11.1779367584557;
 Thu, 21 May 2026 05:46:24 -0700 (PDT)
Date: Thu, 21 May 2026 13:46:11 +0100
In-Reply-To: <20260521124613.911067-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521124613.911067-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521124613.911067-2-vdonnefort@google.com>
Subject: [PATCH v2 1/3] KVM: arm64: Fix meta-page unsharing in pKVM hyp tracing
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

As the hyp_trace_buffer_unshare_hyp() function name suggests we should
unshare all the previously shared pages, otherwise we leak hyp-shared
pages which won't be reusable for hyp memory.

Fix the typo by calling __unshare_page() on the meta-page, ensuring all
previously shared pages are correctly unshared.

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 8b7f2bf2fba8..06805b426101 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -189,7 +189,7 @@ static void hyp_trace_buffer_unshare_hyp(struct hyp_trace_buffer *trace_buffer,
 		if (cpu > last_cpu)
 			break;
 
-		__share_page(rb_desc->meta_va);
+		__unshare_page(rb_desc->meta_va);
 		for (p = 0; p < rb_desc->nr_page_va; p++)
 			__unshare_page(rb_desc->page_va[p]);
 	}
-- 
2.54.0.746.g67dd491aae-goog


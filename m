Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750341D7E5C
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402865; cv=none; b=Ko5ttErnc8RifBBOWjI7pBsUK+tT00SsgPbaq8Ky65SIPYPOlBw6rypv7jt+i1xkOYKNlpF7r2mTqhlmb30fK4d3q/uQ+1XKlf9fCZ8yhQvq8AUevLe8LKU1/lSdWmSk/SsBuN4TAEjef5KhVntlahHpAwJzeyd9mNDCBucJZUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402865; c=relaxed/simple;
	bh=oIK25k9bycvTVzsTkwmIx1RZPV+DV84Nx1oo308pa9M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UuqT2osqQAaiRylw9bZ6WqtGkOpxjHR2RZU2Vjzcbbh/+PeIWDXCLcvXACZsTt72ZVN3OnojZpkxkw7v49d/RKUZkvZppF2SX+R1X+wcxUYInRRHomVuklpWB2uK4jO4SztNzNuM27IdJTksO7Jgg/D5TAdS8UGdTM5uTSY/z6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RNmhu1Jn; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RNmhu1Jn"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-442e0e6eb84so14758135e9.0
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402862; x=1748007662; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ROhVGMzsFKUKcbl+uc4M+NtezlfJHXVXpAYtpBvAgk4=;
        b=RNmhu1JnRrgKQu3pac3T/sohQyeGL94k5df47h2NptsGpNhFIOSDRihOEYl9dHab3T
         eSiRVBKeoExM1O0uCXl7KBrJlLsnb+nfDEWAfDREJZfjgUTEZ07DQQWcIxNrpak2dSO/
         7QD9FvlYGEqo8z5ourLGGzNz6plx6haUwt2hXIYz0gW1OhkhTIhVPSsS5FNXdLSeWt9p
         HODpnh3SuBaNtuq6BRwlMJG8greaEKJXbN6sW1sE+mbsHhT4IXGDXbx4G7liaA/Qr7Ds
         KbQUh4oYOnybicAaL986eFJU8wI6t+HHzFzFi14r742UeIfPW3TwQCtxYvd7382DeM9w
         aFCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402862; x=1748007662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ROhVGMzsFKUKcbl+uc4M+NtezlfJHXVXpAYtpBvAgk4=;
        b=N3cPzbRY66WvD3ClKeMUzyG2ofAa/w+qWXxBlZO2NU2pK3ecJzk7r1ZQYMAOW57SeW
         fQRzSXwZVReVZsjIzBK0P9YhF/e+uiLY+gpImSeT7oedaR3UzLVEMqLbOGmbteReimbC
         /gfXBlaasUW0l8FeAEvEpweNNgVRV43TJflXhCNyPnfVozodgsmb1jXgiY0EJ8LIkeZU
         Ub9+55yfIIZnkUDrZL7+fT0CkJrTEx2WOWxC93hwklPWZ4LnIoTaxeD4/tk6qJgVHD0m
         RONJOIayVG/pnAE3ou1xenBLDn8Gr9pC4F33a8tS4q8jMnBlIT631M8StVGYc+92NjFZ
         G4TQ==
X-Gm-Message-State: AOJu0Yw1qYMDjvCKpKfukONuQHUQXFkEc/CDEq76zj6X/g8DBpXfTaoV
	4RxUeC+rwOzDCs8+GgkhXPqQ+iiS36pJw8D6aNE1p8YYD3naxJPC427eI540JdHvQ3GUdAK2I5z
	fLAWzu4bCJoEUOu0IOB9fJg==
X-Google-Smtp-Source: AGHT+IE25G0/BjDIzRGhaY+tUE0a1T8as9PDGc7bUXR9TD/pYwUJpZs3atjTMCsK34rjbeQcFKFoizPiNPQFaZsH
X-Received: from wmbfm27.prod.google.com ([2002:a05:600c:c1b:b0:442:cd25:eed8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83c3:b0:441:a715:664a with SMTP id 5b1f17b1804b1-442fd6607c9mr27539065e9.20.1747402862237;
 Fri, 16 May 2025 06:41:02 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:21 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-16-vdonnefort@google.com>
Subject: [PATCH v5 15/25] KVM: arm64: Support unaligned fixmap in the pKVM hyp
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
2.49.0.1101.gccaa498523-goog


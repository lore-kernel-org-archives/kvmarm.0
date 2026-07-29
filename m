Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF27047DFAF
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327228; cv=none; b=pPo3Ew/AKXu9a/VHdZdalNVp9axGs8chu5Q6gZr3Dh7DsZjpusHrspvMn/RCOfLDrlZ7BjrEQTnwaqRSbit9sWqQ6C64wciyjIMCkE0w7FQFN9CaZSwJG6WxF3zh1Vu9tuAHhpSJQUGfigBiJOLngoPNbGLIOVq2Svse9n3VqAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327228; c=relaxed/simple;
	bh=DRkkIWBuFzFT31KUfBxmspUQ9PRlcHfFBdZOlHPMeCU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E/ujJCcYzmWuGZ8/bgPu4nxkL3QYZXFhdsfo6P25r9gzN+tHY7e6YcKLAFpX6XeVvpxqtKgDgRTim/gTaUQpismwQoBYyZ+TqYvadOl2MfsHkpRru+wZ1Yi6w6aZypGYzlTzMWPpI4mip7dINgoVAJyCV12dtkIFwwfGfTtgaSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vWnKYmPl; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vWnKYmPl"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493fa6e28a7so11675305e9.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 05:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327225; x=1785932025; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pT6ME6+uuPUFrDLhBZ77UVbhr4cwcY1ivaQIEa4otBU=;
        b=vWnKYmPlck0gcrByDMlZBYPYNH4ttCP0EWyKAZ7VNePFCKIdKqpYh2SkQbHCVIqHbC
         p0GvjKYicKr99I0FT9xTfuIidKC8B33i757sWhqNA1ezvpaT6nFuyOpWuEEe9DrzMMpX
         ewGxD6JP1sKLD5WYznNvpPrPSmJ7aa8qWg2bDUBuPh9a9llLsxRIbCbsEKc8I6wYgA4p
         yDPXAWEyzv/EAfCeltvqJGJ6hV9NKkDHxOI+jqMSYaEQB0/VUb/jxrUgmdR/B/qbRMkj
         Jw+W8PDTnefEAdaMIYqm+N26TNf91CefyznjLOuCoVz3bIjE/lSTlBWe1nbo3zN3yZWe
         jFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327225; x=1785932025;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pT6ME6+uuPUFrDLhBZ77UVbhr4cwcY1ivaQIEa4otBU=;
        b=T/znE/wRtAaw+lxP7SNYl33KNXBW78PHovbdcB/semXOutmUcnMF5Y6CV4XUi+iKLN
         flR2xzwEe8zEgg9Zh9Ag9pD+q3bBn43n9n2chsMcJ4jfYnKKCYjOaoB6bLV38oEE8Yn2
         8mDvXFW3yl73504icOP7kKYsWzJrnoTBYYLHaNZVA12RwjFQfAh2tbpaVDLcpmb+CJ3B
         h7DcGPdJOh7FnVORt3/w/e8IHUjJ2hgQdYQImEYNe6McERbVWk/ipo/N09rhUAgI9JXR
         O5NrRdLyWFkAaecaa/iH6fZuKRExS+0v2b6cyH9LUpj5xw/BXg+scNKmseAl2rHGrLZF
         GnoQ==
X-Forwarded-Encrypted: i=1; AHgh+RoWlO1xXQyWtg3RaQI0Qp8w7Lw2J35QunYjxieDoID88G2HtPbiapNd68zVQ9ehXy0o5v59GA4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFlCMZ6G8IE8e59heO8AmhF8/e1Y49a23kd+W/TsT12E9842Wy
	QteBUGGiudqX2P2OdzwpQsQM/tYK2712j273OOMHLjjBlLgfIaTmg5OXtiygPJUQ8u1ICaZ6qsQ
	S0R0qPDHJgikZVDxc1XLklhBEUtADcw==
X-Received: from wmsk18.prod.google.com ([2002:a05:600d:8492:b0:496:c04d:501e])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e52:b0:496:df96:ea8 with SMTP id 5b1f17b1804b1-496df9611bamr36752175e9.17.1785327224777;
 Wed, 29 Jul 2026 05:13:44 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:13:06 +0000
In-Reply-To: <20260729121306.1519473-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260729121306.1519473-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260729121306.1519473-8-sebastianene@google.com>
Subject: [PATCH v8 6/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow the host to send FF-A notification queries to Trustzone and proxy
these messages from pKVM.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index c22fe4514741..712811e89435 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -678,8 +678,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
-       /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
-- 
2.55.0.487.gaf234c4eb3-goog


Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A137E52120A
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801588; cv=none; b=omx+aHhxeiAFKS4L4dG0Yp9heJWsCAJ/pqzUwUk+Cf+t73wbUuNjicaOXIs55k8lvVNmPItPnJvXprUMtHBl7ui7BG/Iu+D866HNuw2khAxqAGKU0HGHORRZDyt5z2QpFq/3C53VwlJWrjI3Da3+mksUrSCYXi9qfI/NzPOzj+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801588; c=relaxed/simple;
	bh=BVQs2KMfxV/tT9rQPMbT3YixzDlqI/g+6wdyT9j5U6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uMZ3fwkzUin2EthteFY/sJQqAbbsJIPek26flHef5lp1kZ8CJCbkgQcqGyzYBZ+ItUBMXhA7Zsrsw/RI4MEMVji8OvyVekNFHN1bg+oIN3eilI23qS5MrCD4OFLjZqcCk9eOLx7TEUe31p5XLhZKGTQAmcrSJfjcTc0kTWz905Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=avqgCe37; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="avqgCe37"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490a767b782so29896945e9.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 10:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788801585; x=1789406385; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pgNVIw8B8D8cs9XgDbUZbP9oPGN4jX1fGCXxaqN5ORM=;
        b=avqgCe37VZP3FuYzRAA6uS2R8okoadwoZg/fWTkuNhTsYUp2HDMk723s2cHOCNRdh6
         EX/2Hg5UfA/jz0/rvC/nqjgdXA2M8khpMdqzj1lSLEuZKpZLLif8J7X4eDz1/19jnmU7
         bQquTacSnqzaEk6LLbEyZ6HWGeSoSxC1tEcV3b41K3zyJGjT9Mw2xfVY9jfnS+TtNtBi
         su6jQKx93+V6QWoB9rsgT/s7lyH8MTibF/eNSko6WHci3rTjVx09tGyaWZjTF3C8dStB
         wB3jU4QLGnS3sGat9KQ8tT3yvALGv9uhHB9i8v6mWjtX3G0bOwnM/QTUkOIyHbcjfsvy
         TexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801585; x=1789406385;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pgNVIw8B8D8cs9XgDbUZbP9oPGN4jX1fGCXxaqN5ORM=;
        b=iCVEkLGsijE9pLiIIA8C5SDsl6IoWonvqNGCdX8LwkWkukFP9HyTusl4rHbQmpqVn2
         M4my/FR8Kd1En9isenjBgQkVrx2A2anvp/4Q8B25WTjdOnoISjJ3cfIr8qR6X1AeFI7h
         0+FCYfDGwJ6FZsTAztVKpz7Wzb05UcJ7GF6K95kd2CAe+3oNT6/x+owsYYv71bzuihFW
         k0Fvj+FIL4RWBeLyeTzAl2Ad/Zxf8I0bgo4GuKGJJnJpV9a+tcpbAuPu8MNkvOMvzM78
         Djn9K6C4h5JezFD9XqNcwkRVZcUJP4snKgubLDWbkIII/Qw+EOAvsHlwZeP9XmE0rwMZ
         3gmw==
X-Forwarded-Encrypted: i=1; AKwUvBy9FLW1cqC6hpUmiwl8J2Fg0KBJhGFYTlgLSiwsvV2nzGUkLTqOXpoWBE2bfABT23fB3mg3Wc0=@lists.linux.dev
X-Gm-Message-State: AFuF++kVnfGVckjgmX/gP+m9tVuXZxZw8HA5+D7OcIWH/niolRjIcBc6
	YEt3jeDrgTA5K+PibKr8U5ZRuNrWMzxKFxdr8ZBpqk5a7gg56rFnKjl1ejY/p/dhyxNZ6ttTFj7
	pDL0gVLPv0uM4euCGSiljE9ReyyAWZA==
X-Received: from wmbgx24.prod.google.com ([2002:a05:600c:8598:b0:499:bb2f:becf])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:864a:10b0:49c:fc89:59cb with SMTP id 5b1f17b1804b1-49cfc8960ccmr150937795e9.5.1788801584621;
 Mon, 07 Sep 2026 10:19:44 -0700 (PDT)
Date: Mon,  7 Sep 2026 17:19:28 +0000
In-Reply-To: <20260907171930.4037166-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260907171930.4037166-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907171930.4037166-7-sebastianene@google.com>
Subject: [PATCH v9 6/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
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
index e11fb06df63d..2281ac2e42fc 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -694,8 +694,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
-       /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
-- 
2.55.0.979.g7e5102b832-goog


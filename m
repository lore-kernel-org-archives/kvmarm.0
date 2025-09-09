Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF00E2FB093
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402682; cv=none; b=XDMAVS4U9FWnRF8z7pQg8zCK5KGZjY9Zv/kAVqUNBlmGg57ym/Dn//BG5B3JZn+drM0REMMv/zBaF7uyonz7KE4V7rEfPig1lyusqdOL3W/vF98MROGzkIBXPyHNUyO0jA3pjKT+t/ZJSUMaYeD0RIHjmq8A42d/eJpO3RDZMmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402682; c=relaxed/simple;
	bh=6fQXwARYdlhF4dybfCcwfO437mgP9pfXjQRRMZq6CM8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hc9Ch79w6MwXxB/Ywc+aC/s6D+KksY6wdQgFtfq+Po2draJTVxMPPM+CSXScVZjJCzIwGRMvm5zq7GPXmfKcdt6G5HVRwKgtP4ijs0xCF+MrH6FakG4gVrMlEaBDN4PzCqYY3jve9R830ovfBQGuqtQ4bkbMHX3n68gxwvHdxwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AKpngBwp; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AKpngBwp"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45d6c770066so27032405e9.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402679; x=1758007479; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WsHbhKmZ1OiSK/41wYLgD6WQvQTZzuDhvBEA7U0ooi8=;
        b=AKpngBwpuT12SNXwuJDuL47tD1R9LPUX/cYzmEX28ddC3NSXNaQxmqIfSuUr844fJM
         MComtYTum7miIYISZ2KiOwjp8hDwJr71yMw5354uBGSqzw2XQBE8w7H9Vc1Hz0VlRPGc
         tHWzF/T9HlsQtrx0Rzk9i5u7BjBid2XmCiYV7fbi9dfP+L0hMcdtwpsvAIkAuaSdOMIW
         tOojTX8rbqnzY9VEJeHIy9w1MdRYFVN9cF3VA9w9dbHc0aMuNEdsR9CzALZ2gqnvwik5
         lVSMCvhiZjgVm7RzmNkYBwcYMXRsCOpbnyI3bi7PUPgGdOcxBtuVn3mc51g4ztlW14c8
         veBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402679; x=1758007479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WsHbhKmZ1OiSK/41wYLgD6WQvQTZzuDhvBEA7U0ooi8=;
        b=qZZWQXRT6wUX9TnaXD8NSB0hsfOjxwM+/okmrvh1i/rltbSVL3igfVsvXzPWrVgqkd
         91J/1U7jJoCUbEeqQn3kTI9/bYEEZfKlCAe8NvkYD/fREsCWgyVJCAbPJV/IHmfe/pMm
         RTazUwG9es+/vxxDXdfJI43ek8Ekg9B+HRv3eItnp+bsjL7i5toT5/gXQwUuiLs8jhEs
         ZDEpam3DeNSExNvMGiMHE2+AJDChx1ILtyLds00V2DqxAlB0l8ee1weRo6WWZniPi7xz
         yBc+GI2V18cogGPJ6uyCLKSOh/8Qj4NSnyFoJIOHPoy1XWd0FwbdVSrqCDgQqNKZEkyU
         +Ywg==
X-Gm-Message-State: AOJu0Yy+t6YVhpauM6XdMVKZJ8/ifUjt4WYMI/TAwHc8x7u/rAZWKZ6J
	vCS+wacJvW/AQfhev4eT2A/hZdZ0oxBdEGPIUrhIdLrBzWCmn/WKKmHjRNxOoWNhXMeVT350sBz
	QSK3jzRV3pmBPdoPly4v9J4qJy7HsI8usZS/bjzk5AZvqD2ieFwNCCaa2Vivx2qD+bLqhmgQyhZ
	YBH41d0Hx2XovBJDzmivye9mvNeWvUAAI=
X-Google-Smtp-Source: AGHT+IEjHXd/BhJMwSGnT2Xvlzjm7L/RZRRvSSkROQ/d/q1T9xTETHpI4ZDw256azJRTjyVe9QNwUwT+Eg==
X-Received: from wrs22.prod.google.com ([2002:a05:6000:656:b0:3e7:4198:a820])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f46:0:b0:3d8:e1de:7e4f
 with SMTP id ffacd0b85a97d-3e642da5119mr7394196f8f.21.1757402678976; Tue, 09
 Sep 2025 00:24:38 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:24:28 +0100
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909072437.4110547-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072437.4110547-2-tabba@google.com>
Subject: [PATCH v4 1/9] KVM: arm64: Add build-time check for duplicate
 DECLARE_REG use
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The DECLARE_REG() macro provides a convenient way to create a local
variable initialized from a cpu context in the hyp trap handlers.
However, a common error is to use the macro multiple times in the same
scope with the same register index, but for different logical purposes.

This results in valid C code that compiles without error, but introduces
subtle bugs where a developer expects two different variables to hold
values from two different registers, when in fact they are both sourced
from the same one.

To prevent this entire class of bugs, modify the DECLARE_REG() macro
to declare a dummy variable whose name is derived from the register
index. If the macro is used again with the same index in the same
scope, the compiler will fail with a "redeclaration of variable"
error, turning a subtle runtime bug into an obvious build-time failure.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
Note: I considered a more restrictive compile-time check to also enforce
that the register indexes are sequential and without gaps. However,
achieving this without requiring significant refactoring of all the call
sites results in too much churn. This patch catches most (or all) of the
related issues we have run into in practice.
---
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
index 1e6d995968a1..ba5382c12787 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
@@ -12,7 +12,8 @@
 #include <asm/kvm_host.h>
 
 #define cpu_reg(ctxt, r)	(ctxt)->regs.regs[r]
-#define DECLARE_REG(type, name, ctxt, reg)	\
+#define DECLARE_REG(type, name, ctxt, reg)					\
+				__always_unused int ___check_reg_ ## reg;	\
 				type name = (type)cpu_reg(ctxt, (reg))
 
 #endif /* __ARM64_KVM_NVHE_TRAP_HANDLER_H__ */
-- 
2.51.0.384.g4c02a37b29-goog


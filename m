Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0C61EB9F7
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 14:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734101905; cv=none; b=RGgkeq4xC1ZJTLtX6XtkmlhAHOnnsAHMheycKnilRDVRTYRMln2VnFWQW0NoZ511EPk0kKs36O5mrikJ8RW6RUy132A1T6RXuraW4DS20EB3aw1x0+KQFZ6A1KKAFtOtYp/YZV7J/aGb9Roz2ypzajaAgjOPU22ZCKTZfMiP5l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734101905; c=relaxed/simple;
	bh=u84ym6n/fXoo6ecjCuKAXs4qruznKdtHsEHdBV/R6yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb7MTeSQSgfHycHVvu14DLbbpR/EmNkb6vH6Zh1urzGR9/JfrPosr5/gc0320HYAXceikxWgSEkhlacHIzBI6SOVPosEBlYFQcVMYYXjJO56srFa1IOp8GbmjiH5NodPV7dVrMURaiv9E9eOJKjjOliGySbvubG9CtLe3qvtldk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=my/321iG; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="my/321iG"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5cedf5fe237so3062444a12.3
        for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 06:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734101902; x=1734706702; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4qEMLxfX1BseC/FdkMrRBTdE/BHic3wsmzo5oEqfeQ=;
        b=my/321iGN4OFGkSh+VRNeel5ds3MbG/edKSkVmAgk2UyTB7uFAmIvANSMlj+thOw0I
         AnLbmSe0mK6wSkXtTUnIz7e/hp5QWjEEANkeMhRrLswq1uA033Z69eiG6aF4vT2nEORZ
         89BJXeu/IcPNQT47OIDMYp54wIzyPGsWLQpdljbn30EM7mSUneSxKuEU4SZaRh/k5I86
         o45O/MVTFHM6onG4qJMg2mKwYLMFMuBX1JQ6v5SR6JIKuP8nyNTQx4UvtvZzRzXUtKHV
         O1xoSFj79qXh9llM8B4fo6PXtxu7p9TX28TGh3Jd6YEy8yf98ftX88BXsA6kfL/nYFdc
         vlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734101902; x=1734706702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4qEMLxfX1BseC/FdkMrRBTdE/BHic3wsmzo5oEqfeQ=;
        b=iRUHAoN99DKdJH99pfdVebaceI5WwLf5ml9stYMDxgZllX8/giel8xxf1Yk6Pk9OJg
         FYKidoN7G0qtSUImLk8Cm/gd6nvsnN9tYgBg7jwPs5Ql6t+seqwKglTU/W4vC/DR/6uh
         7pLLdR9xopHhth3kQb0OayYGoD4zDNXDtEsn0eZBoqrqMy3X3zxU3N2aEJZ8HlgF2BHF
         9HNTAF5yxvtJflfSs/h8a9d+XK1HvYsyLZcEp2bJC0HsIPX0QTgXQ5Qrvj23q6K3Hgho
         h3zHb0vbQVzNCokYXYA++4B7pLkQSIqolgFPOjJFd3EMs3IH5U3Gi+s4h/KhhjFvfjKm
         5i1w==
X-Forwarded-Encrypted: i=1; AJvYcCWruhJC7NWMUQQGRsT2pkLTZJuZnYc0TUPKZqYAFXDDPOWnwLZ3XA4rsLKs6LRLCtkue0Zb47E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwL+OLehT7JmJG4aZ/NfoCrn2WrE3XBzKHCUmdh32xVTL7WLyU+
	KLvAEddK2lW4gJyWuSAPs4UyZYXcODFFj6575iBIoT0OLWtP+K8b
X-Gm-Gg: ASbGnct8lONmtmZId7MkzCw9in2k82eCgDVBIVSrtLAo8wBYCbmIKlL3NvnWhZzh2ec
	3FrVEVsXRwecP9OLgry2oHE0xwzzea4ADeeRPYpNR1O8ZmmH6orlJdGxgmjy1MZjH9zeqdmSwMb
	We8D0Vt1kHeBZ0cALkKKcM7SWrt6HUWF3kQmFhHtm/Ee1blcdnPrxFHyfCnH2IznoOHCYKzaEU/
	iX9ZZo5U6G9/FONxS3yO6An4zVbBUhctxQWt0p8AUvNyi98fb+yOXlHjoQLprxp5g==
X-Google-Smtp-Source: AGHT+IFFvoMSIBChWgea1OnryG31unMF7LtnV6rYFz6R55l7bdMGVY5c0jGGqI8Y+CKjTdPlJAQFJQ==
X-Received: by 2002:a05:6402:50cb:b0:5d0:d5af:d417 with SMTP id 4fb4d7f45d1cf-5d63c2e9df2mr2151151a12.1.1734101901967;
        Fri, 13 Dec 2024 06:58:21 -0800 (PST)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3cedbb8fesm10048424a12.22.2024.12.13.06.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 06:58:21 -0800 (PST)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] irqchip/gic: Correct declaration of *percpu_base pointer in union gic_base
Date: Fri, 13 Dec 2024 15:57:53 +0100
Message-ID: <20241213145809.2918-2-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20241213145809.2918-1-ubizjak@gmail.com>
References: <20241213145809.2918-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

percpu_base is used in various percpu functions that expect variable in
__percpu address space. Correct the declaration of percpu_base to

void __iomem * __percpu *percpu_base;

to declare the variable as __percpu pointer.

The patch fixes several sparse warnings:

irq-gic.c:1172:44: warning: incorrect type in assignment (different address spaces)
irq-gic.c:1172:44:    expected void [noderef] __percpu *[noderef] __iomem *percpu_base
irq-gic.c:1172:44:    got void [noderef] __iomem *[noderef] __percpu *
...
irq-gic.c:1184:26: warning: incorrect type in initializer (different address spaces)
irq-gic.c:1184:26:    expected void const [noderef] __percpu *__vpp_verify
irq-gic.c:1184:26:    got void [noderef] __percpu *[noderef] __iomem *
...
irq-gic.c:1184:71: warning: incorrect type in assignment (different address spaces)
irq-gic.c:1184:71:    expected void [noderef] __percpu *
irq-gic.c:1184:71:    got void [noderef] __iomem *
...
irq-gic.c:1231:43: warning: incorrect type in argument 1 (different address spaces)
irq-gic.c:1231:43:    expected void [noderef] __percpu *__pdata
irq-gic.c:1231:43:    got void [noderef] __percpu *[noderef] __iomem *percpu_base

There were no changes in the resulting object files.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-gic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 8fae6dc01024..6503573557fd 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -64,7 +64,7 @@ static void gic_check_cpu_features(void)
 
 union gic_base {
 	void __iomem *common_base;
-	void __percpu * __iomem *percpu_base;
+	void __iomem * __percpu *percpu_base;
 };
 
 struct gic_chip_data {
-- 
2.42.0


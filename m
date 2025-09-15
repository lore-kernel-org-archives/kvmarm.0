Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEF42C0F8C
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973292; cv=none; b=OSTzBYa4c7vbMVKpjEHIsHWs6px9H5/ohRavtZd3DRPdm8gf1L9Vrb2JFV8zPLUzqKkPxNuC231wYYz4lL4PhLGSKsy7HZ5C6utHPdPZHRkDEJ8WwccbTTuowt3aOZ/KpDyXf2/xX5msB6FwNZIbaIlXWWAvXekpczvfs0rEeZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973292; c=relaxed/simple;
	bh=Bk5KjA4JdS/NCumF4B+M4o8ki0+1/OPy8Zsgtq0+E5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px5LvL+H7PpZ7F1MiFJDyw0tgmeMOyBRQFRxrBVM6qQWtTLKauAAHduEGMzQSE3tRfqSi6tfIey5onZCFaFjRgkqnnKXsSMKL2HBwra7Cwl8eTGWU66G0LZTRPXBOG14lKOnbD8kW9eRGiNov0fnRV7M4RtCOsxMFxA2rSURpgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Nhtf8r8c; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Nhtf8r8c"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-7814871b581so13028416d6.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 14:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973290; x=1758578090; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1Wf1YB0SsfvRNrXE8RjpeDW1RLS6E9uJSM4diZKivw=;
        b=Nhtf8r8cGGi3Oxg95GYyPADvV2D8RYKFA7IGRUh4wOUceh+d2jW+N4Ep1miq6f0cPz
         8Kt77O/e9P8qvkqcZrRdNBr8DHVBm9eHjSpCZz2qGkKNiGMU6jLWMc/HX2n34oxc71u3
         SZg2JE6aMEFMnG7kkJBS//tP63FZYczI2/QaZK++5Yfj0O7Ops59f8sE7fsPHW0oEAN1
         bhZqXrzuA2MePtz40rx0uDOBV5SfXm+syeAIeKVlR2v1ell9Z4+MEe/cRmKmP6FBuuJm
         kw/+pdMeKj1GMBt9WBh/DDZ34kUGZ5wio2q53SRyeAk5s8vHtRRFrSLIxxu37JzAlKeF
         zrww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973290; x=1758578090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1Wf1YB0SsfvRNrXE8RjpeDW1RLS6E9uJSM4diZKivw=;
        b=Q9Un9fs4EMWBigcYMvtM5reIkLWG6rKPtqJKAFHT4k1KBvmWP0gx7knlW++Hjzn13H
         ziopoeaeeA8k14Dso3Ew+7UQgtmBuNFhSZ8sDw9PNyVd//lwmxgnxvs5JSo3E3Vu8WHG
         Q/6x2hBTlLlguTQKsF6C/tEfCXU0YN0x9EYOskqGxQtuwbbKBNzgt/De2/LWP36RSLU2
         /JChtSLFdHQ72ngY/h1FjgbRtjsquRKaub6gCu9CnCDyURHFP9gneMBcViTXe2UFVw36
         MFgBXducFfa3YbXOzP6RUaJy2EmFOF7l+ESw9pnquur2ZKIT6Wm4sP3eXtYJ53sIYDh8
         4BVw==
X-Forwarded-Encrypted: i=1; AJvYcCXA8PZIJ0RVg3CDjay1T8ZZ8yiZj+x/5E3r4WXcc4C4YABpvsN3iz4VbUyjiH/zBNYJLMOMdtc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrsO/QBiol1L359Jcz4E7FqkTyV6wptV0QjbiicS9003Rm/Hbd
	UlVUJh+mzXcLSCLEeT2iVTZ7R9udpo1bZMQVlgXiXLrOnggSDwamZJ4DN99dYpaD6VI=
X-Gm-Gg: ASbGncsqXS6UflmX9jy5bNrB0JZDzc5Y+p5Ht2xuCmas3qAlvYE+a1+6QVmZaxiTzmY
	dqPatMOjsNHZiiOwIHOX0gzZEiXk6Ihh1R7KXVufPTH+OOa3jYW2RyHemXrDVA+zPzLWhAhGjtq
	uD1R2AfI1ZeXRluMWCTUIiCa3x/IqbNOjxcHjfrqXGDshnNufwnNtEWEnw21hnpm892ILnEjw4+
	cNg2Q/zaoMm7nvd5iF2hyUOxZJ6AVn7abkzN32sGQXgHL0v5dtTO/c/j0xMgM27k6caD2Zz59aK
	At4yQfx8dnz3V/+WujG5tEZ4CcdP6rbOXZBUbSGiaAjyEGWeVARNDlcU7jva50N4K4kdl0yh4fl
	IVEJFKDMppTFPAEOuKU4ohd0QIJ9ICKvAFdW/odV3Cnc/7+1Rv/pBJJ/Fea32CQsK1ucDg6HLf6
	RmGwBHzZZbZFynPxP9RJXJ3LrAFSsO
X-Google-Smtp-Source: AGHT+IEJAtu0zt8kOgDGhE3gvqekHDqO6GH/t48ORW60nfsydMY5t/sT9Xnm7A1gzaPfgepEiGjW1g==
X-Received: by 2002:a05:6214:21e2:b0:740:fffe:c0e5 with SMTP id 6a1803df08f44-767c3a5483amr201042416d6.50.1757973289714;
        Mon, 15 Sep 2025 14:54:49 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:49 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 1/4] Makefile: Provide a concept of late CFLAGS
Date: Mon, 15 Sep 2025 23:54:29 +0200
Message-ID: <20250915215432.362444-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
References: <20250915215432.362444-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow architectures to provide CFLAGS that should be added only after
all other optional CFLAGS have been evaluated.

This will be useful for flags that depend on other, generic ones.

To allow 'LATE_CFLAGS' to make use of the $(cc-option ...) helper,
assume it'll be a lazily evaluated variable. To further ensure the
$(cc-option ...) compiler invocation overhead won't be per-use of
$(CFLAGS), enforce its evaluation prior to extending CFLAGS.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 9dc5d2234e2a..0ce0813bf124 100644
--- a/Makefile
+++ b/Makefile
@@ -95,6 +95,10 @@ CFLAGS += $(wmissing_parameter_type)
 CFLAGS += $(wold_style_declaration)
 CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
+# Evaluate and add late cflags last -- they may depend on previous flags
+LATE_CFLAGS := $(LATE_CFLAGS)
+CFLAGS += $(LATE_CFLAGS)
+
 autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
 
 LDFLAGS += -nostdlib $(no_pie) -z noexecstack
-- 
2.47.3


Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CEF2F0E50
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968356; cv=none; b=TmggRYqCMTZoKWWQjS61wYMN46/5eYUr8n/oYH6ETW8U9XuILnD3HWinfUr7aBsBlGZTXfnjTPQVyeCIXtW1NQ00nsTYUBIIG5D6Mv7i3MumzbxsEI28i1GKoeUYkZXtzQYmoCYJY4+pKZGusapwmHt3HsdPtYNHiBNUqCiOMF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968356; c=relaxed/simple;
	bh=T2AAAwNCvFAm9YUhWYISU/OAnWzXdQk+10RnZrJqatc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B3Kc6KSIoVfxuOWd7GZSOZWNrFWIIaSiGRZyLmFE9cjskRXtbt/5a+Q8LFysQLmojQjK3IoBThxvLvNXEj4n3aeiJG88HSzHBrq95+2WPuBjArlYR/18Qmy7DgX7YIk6TsYXFZ/j9YcilirH3Xn0FcKy2ZarHKoaCdQ5MdRN1rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g3ZzX8u8; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g3ZzX8u8"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-40b2c2e52easo645866b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968353; x=1751573153; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EHt9BrBIYqZp5kZ5sjlL9mrhswYvvwFRhl772iB1+XY=;
        b=g3ZzX8u8i3NnlPEfNiLDAh8pd0CWUGMZ4CANJOK60wrTLfwYIZIsD+//cJ7KRHmjhp
         I2HSIWx9XqYIyEm8nLqqrNGcUJKXsVv6J1plqYTaXrt6Jbj9LBRC4GtIH7shD0sveYeb
         DAwvn4ccpStx5vLns9iDuhtegWwLaXg1ip1Z7x9IGpcWsqBrpG1oxnMlqTSURvykGpj2
         OtMY7RY89dmnEdGOczd7tzgAM9G+1HhhDZEbyS6wKQ5GP0cI0ha1AAk9Tm4gdTlwtPk5
         bpgv9OMYzVt9NHuVPM5vHAHGow3uSKMAIfiZuWQy8YxMZ0Vnsni7C66NS+dJis8N5ZgI
         rfnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968353; x=1751573153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EHt9BrBIYqZp5kZ5sjlL9mrhswYvvwFRhl772iB1+XY=;
        b=qKvY37ZcO7LOiT9ayNyBioZAZe/kA8jfCtP3geUArk+TEfovw1sLIvq+KmEJP816wD
         tcc/ES8c6ZNi3w2aH4slxpDmGfNMTvDuVd86DO1Dh85DvteskUSIV61Wo4WBhc6UQQZG
         u4nCG3f5i/Fq3JxyaRleIKNYSSIyqQRQrJFN5HRKs2oIxBtFsJ20O8Hty9kXO3HT0oRJ
         mJHdJARYQbvvCFiqE+50+oW1DG+HXFfeK0H1qqRf4EXelORtafjYpii/px52NMNlfCp6
         7HNmSXrkQv1DJgGr7HwHK7OJ2Eh53Mqv65zh0g03yafyakZJ2bc/wSEtWm9bDvsIwyNT
         DGmg==
X-Forwarded-Encrypted: i=1; AJvYcCXDgH15hUhQu4Go/4777/vUhCOY6L202cNqWx9BG3wc7lf6sA0xB3DEujdJRCReEjfZOpohJUM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9rHoo4fFMOF5bdx1Bqr8Xl3Nmgz/xrRinA4IwQtJCE5aF4Gt3
	8j/h8IR20L8nXzauDZLyu2SQo/i2aeSD3M4Oh1Gn1m97jolsns8Pbmh6umxlVBPhQdso2mipuPm
	mKJpSUGjpXsWfckvLnU+4YKApKQ==
X-Google-Smtp-Source: AGHT+IFlRtE1eWK/FMjUnULxroCH+ZQKYqxRY5qaFdZ+f+SoiV9KEwtPmc0HwZMn2/GT2thgfmq4kS9LjJKIm6e5aQ==
X-Received: from oibcj14.prod.google.com ([2002:a05:6808:1b8e:b0:40a:c2da:1f99])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6a87:b0:409:59d:2fb with SMTP id 5614622812f47-40b33c77bfdmr516313b6e.11.1750968353579;
 Thu, 26 Jun 2025 13:05:53 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:38 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-3-coltonlewis@google.com>
Subject: [PATCH v3 02/22] arm64: Generate sign macro for sysreg Enums
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

There's no reason Enums shouldn't be equivalent to UnsignedEnums and
explicitly specify they are unsigned. This will avoid the annoyance I
had with HPMN0.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/tools/gen-sysreg.awk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index f2a1732cb1f6..fa21a632d9b7 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -308,6 +308,7 @@ $1 == "Enum" && (block_current() == "Sysreg" || block_current() == "SysregFields
 	parse_bitdef(reg, field, $2)
 
 	define_field(reg, field, msb, lsb)
+	define_field_sign(reg, field, "false")
 
 	next
 }
-- 
2.50.0.727.gbf7dc18ff4-goog


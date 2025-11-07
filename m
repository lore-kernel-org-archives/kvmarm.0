Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB6B31B805
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508352; cv=none; b=DuztL0uFWoEGkM+mi2sSjAXK7A5gZpNxWyulfm88tw/2En+geAdX4YZ+VY31Ge/K08qDXRovjURsxkTBMU/jiHCSxGrcIbbfjPYD4IStLyPIDO0/+/2+iOtfF4ULNHiPXSv6nJED5x1AFXvROjlVKhONjYOBUOfwyKb+3SznZNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508352; c=relaxed/simple;
	bh=K6BFdGsDSreoyO+1qzHWDmbuE9TGzb/eB9/SColmUFY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tSwsfolq1vap9it4MYSeeVZIokjBGlb2RGJ1RdsAfHlhW2crblrlmRMsdUR/K9IKRKye9W35UzkAFEhstX/JCmVQZEV5XnmkbkihVGOi+9OJNPOdDy0p/1tbmVEzQsAsSrMIwziXFJZNFYQUvl/tgO5LrRp3PKY9xGEqtjSvyZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N3N3qUd6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N3N3qUd6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775e54a70aso5884645e9.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508346; x=1763113146; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8iSqv7nsn+0/xw84T8G+e+uKy51ge38OdRp2we4P8U=;
        b=N3N3qUd6eW14ktyoGyvI9CihEvEbxw4tGSTsYXbS3VEJXwuhz8u/4rdq39i+0CdbMQ
         yO4UBrPdq0kS/TKnkOb02X/IBG0nXPaDcdALq/4AqCJ7MNfgnePX6+G1Dm8AdOqabidT
         17OAqtye/yNK/EVputlaPnYq4GilMPbOdbLFi5YIJtqyiL1DJcKnn4IlhBfspxpIA6Oo
         ag2qDSRp36jYP2CWHz+AmAsASM/JnaswcK5Y193HDg6kpCnxpVX70fsJOg4Y/QCU3AUQ
         XgmYTqBqEP9AUo92z+R/x0JN39TB/RMewNvwuVAwbrnglOUa+UkVq0W9RZzuO6an7Ha4
         4UsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508346; x=1763113146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8iSqv7nsn+0/xw84T8G+e+uKy51ge38OdRp2we4P8U=;
        b=tAlNZkPfomwy9CjVcP43/xlGx1CXWuA/We6q2Ov4BHu17908BeG+uEDNcJLQ2HU5BA
         2bk03eAEqrRFI0QIezibRTFMhaZzUP72Rlvve4RDTQ/b98FxcLmyolswGHJPi/itPGht
         ou+uWMuEa3jqvgxCKROUcqIzTAbtgufkvYBAcRaYEFo4dEaNLhx5yMtnxI28uY2KvslE
         h4To+wFEWBu9O+r9bWrYvY3mVwWTmmYMEbHTSgTMoafJ3G5gNSLVHZ9IsBd60T92JfVz
         eGhng9upcyXcaz2mG0K0mcZVdT80cCbzzI5e+C+HMi3OqRvVLG9M9s+XREP84CEwyvVi
         XZqQ==
X-Gm-Message-State: AOJu0Ywj+2SgvtE5b2ks27TYJb4RrSXIhp5lNHZElNeEg3dSgwrCbORg
	M/SnmtRgsX8jzOBk4cqgn5catDunq+oAjSRVtMi3FW93hXnegiOFTw2zh7VaxU/hiMGx/1czUPL
	qE0Dnr7FeZ6FG3LMJf16K9w==
X-Google-Smtp-Source: AGHT+IHsR3qBiRucA8EKV6gtWcPn+2ggqqibNDj6Tp411vd1dft0CpDHY+pu14k+X5SUIXMeB/b4TqMhsuxDYA6Y
X-Received: from wmbju15.prod.google.com ([2002:a05:600c:56cf:b0:475:d898:b23c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3113:b0:471:3b5:aeac with SMTP id 5b1f17b1804b1-4776bcae3d2mr20603165e9.15.1762508346413;
 Fri, 07 Nov 2025 01:39:06 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:31 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-20-vdonnefort@google.com>
Subject: [PATCH v8 19/28] KVM: arm64: Support unaligned fixmap in the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Return the fixmap VA with the page offset, instead of the page base
address. This allows to use hyp_fixmap_map() seamlessly regardless of
the address alignment.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index ae8391baebc3..75014dc7d82e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -239,7 +239,7 @@ static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
 	WRITE_ONCE(*ptep, pte);
 	dsb(ishst);
 
-	return (void *)slot->addr;
+	return (void *)slot->addr + offset_in_page(phys);
 }
 
 void *hyp_fixmap_map(phys_addr_t phys)
-- 
2.51.2.1041.gc1ab5b90ca-goog


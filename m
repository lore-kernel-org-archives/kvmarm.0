Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAFC1F9EC0
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736336772; cv=none; b=Aw9xbRtf9IbE6SCsyxx5FcVxTJFJaUHKwueiFNFUj8dWk8y0HzB15q9jrllg1cBMW8Kdx0/ktrKZgUKgUpN5qVw3u7KQTqxLgpN7qw7K+7wVPyhktTP8pAlIMyY7GiwZOqogr9SstvRWXMnmejq0Xgn2oy82PkCgQ1NgMMP0NAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736336772; c=relaxed/simple;
	bh=99RxVF8AfFvewf/cOdPqL4Drw3x5C4hmfCSpLeCPtKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P8Pi9X2hyrXD8XMNY29Cm0mtCavN3XK2ux7eEuxxwRclYjWF+BS3KJdY2InnYCHS3jLbJC/XwW8LWqwAEBBUrnxn+/dCcIYw4Rv51rscokm65y6q09+AckUddVrq4+TqEYdjl4eyIzoaXIXbRb/BFMVXQwQj9UMXDNPB52PGcSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VcTOoQSj; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VcTOoQSj"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-38634103b0dso9861740f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 08 Jan 2025 03:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736336769; x=1736941569; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HgqmOH6a98TkR8jot/1TlGkful6kxHKFlf+7ityvX30=;
        b=VcTOoQSjw7i/ISX1l0oEWTiOigQQVUBmTKXSxbIb0L3AYOM/sQrdELrcERNi0lrXPk
         WG3Rx/rOtbfWXVql5/y72u/yvbkU9akLCv7uWl0yAqWl+7cc6r+AhHRfh0j7XpqV6BqE
         Xvwg2uc4DpNeEKqXekY1+Rx+6m54j9jpgZmLyC1CWhEh8vsxCarHIkEHAneSPzQ2/7XF
         jP9ZFamclTEeQXGe/s+AXK4qa+KDrIHkKKvR3zp10+xtoeyGep+Ve0cLGMcsPfmjTwYC
         FlbEcDoPJYf2LWMyCJk1QnCdl1USNYWh1938bWW/8yKObQY/JYNc5KoHsKiw1G/3848e
         ijyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736336769; x=1736941569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HgqmOH6a98TkR8jot/1TlGkful6kxHKFlf+7ityvX30=;
        b=ts729INoBN2KK00yvZUjTbsKZqCXvqw+Xek2wkSi8tWyeDyJ3YxTikm3ZUnIfYAf9n
         zoQOJfdwQRja1F6AmGzNLcpnzZ5tFtlgOiNmR3V9cL0Bqk9VloCHUWGsmElm36GV4LoJ
         OI/ofTJu4lXNDgl6V/veb9pG7Pzfv97e/GWk9Ai2lYEuy1y1u7EbHqusd74TSE5bXsHl
         pcUsztnvtogtRfsb4UmHjiTPHhZhFfq0W53qYR/gjFCzYc++RFS8cqz92ytPrMWepQok
         8p7FLfqaiKaRaeEyuywMUSna3jZDcS/RhohbHd4zYzsySJaTSVP++EmsFFuX7dglVYsR
         wNFA==
X-Gm-Message-State: AOJu0YwRKwSP+2jfPy/AdynMbBu/BZlpsfJ/es5EeE7dlyqZuycWWu3i
	+lC09CAh7Bc4S81Ty6M6WS7G6TnJP13V0YrISIHrRbRz4ABLG8AMkKQlesJhzyAq7xNnx4GCj+G
	WIA//YbQni/OygWOuzA==
X-Google-Smtp-Source: AGHT+IHABYhHikttLpH7oYEhUoNKTD1qad9ksTQqIL4Ho8ntiowfjJExOtYJ50MZIueli5bhMxdFJKoQ2+rthSB6
X-Received: from wmbfl19.prod.google.com ([2002:a05:600c:b93:b0:436:16c6:831])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1a89:b0:385:fc8c:24b6 with SMTP id ffacd0b85a97d-38a8730b2femr1999023f8f.27.1736336769590;
 Wed, 08 Jan 2025 03:46:09 -0800 (PST)
Date: Wed,  8 Jan 2025 11:45:28 +0000
In-Reply-To: <20250108114536.627715-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250108114536.627715-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250108114536.627715-5-vdonnefort@google.com>
Subject: [PATCH v2 04/12] KVM: arm64: Support unaligned fixmap in the nVHE hyp
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
address.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 8850b591d775..c5a9d8874eb2 100644
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
2.47.1.613.gc27f4b7a9f-goog


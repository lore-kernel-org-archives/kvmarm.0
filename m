Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968D9221F22
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399333; cv=none; b=UUmK8naoCDhpTkd5MoVKvkIecZYyqnRlt6nFjwwcKYJC3kM78tDPjab+0NbPTmjmbWafO02yl98E0FbsSOYX9uXtU7sS3aX0V1zFTToHPhCypniPtUSXe87eBebJ41jpfmjtQVsTlbdsPSw7RJkXMVOp1hmEtad1QUkwMNPw2uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399333; c=relaxed/simple;
	bh=F56QYlJoDZJ+5vN4/HPXUDdjBW0FdSUoL0+uYMqsb5Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZYBAErKmD9d805i9O0TPn4FJXIP3ao81xcQYcGOFAgSlacAQe6GCyvSX/SxPFPu5KOlUwnotWuc9YOLIJ5EsbNqnH+scZBFVXuwlhRg5Wo3sZ283GDOAoh1v9rDdqjU9LxTxZqJYzH2Zwi97B7nme4JffMucHGOHfjZ9Flv2GZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EQaTXGyt; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EQaTXGyt"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43947a0919aso33704865e9.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 04:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740399330; x=1741004130; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=boWUnC75AglyvSxymfq6WOxHhiCHfMqe3a7p6Cadurk=;
        b=EQaTXGytVa4cwjIr1ntF9OD6u5zPeFs/yZ9M/Z9LsSbSgWzsEjQZn9JvuyTxNO0xzK
         GxOJLPTHrO8cU/1LmZfPoXo/rHiFR868xsx2WBlUKsL7vJ/udWZ8ipGNxAlBJqDCF9qA
         4mxMJDESyrzGvZ4kguUtu+T1B86lQvGjwfsdR1AvKAV8F+Ij8ltQufqZSTt9t51k8tBj
         JcwhmE4sjE0URHMwx/ogZWIWyyVnItOSmFpEXY6cfB0NUv8+o01eRHdqTNoZw3tOJa7m
         6CvC/mSY2GsYIZSkHhCVSAN7iDafpPpNyqpTTDVtNkz5JkmuHrJjNDj2IUl3AcLtZ36c
         Oxxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399330; x=1741004130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=boWUnC75AglyvSxymfq6WOxHhiCHfMqe3a7p6Cadurk=;
        b=kO/OZUpHxeAAxjcK2xroC3iWFJTiN+B7jx2Ih3mhD7uy+ruaTFFvuQRGgkgjpYRrAW
         U1yfNfln4obAbHDEqz+RsrreYqgI5YUxHpxZuV499KXCvorAuyY8HQeIna4qGBLRJUQE
         onYqtP/wSOd6gTUk4Nku+BSD8mfmr9GHza86tkB0BaasCrIzO9Lifhh9uS1tllUMjHal
         R2NwD8puIEWHGHspGt2BNOl247fLVtJ8Pa289WITRD0IQgBcIZQ0SYdviO8aFFzZ5SIf
         mNczzkB0oW4//CBeZqnafFcXy5zS2e6rPZ56Dk7COuTeE8BRz7aBXes33EUm/oVciVGP
         JWFQ==
X-Gm-Message-State: AOJu0YywiWWH7q//BKeNgoEc43kUsgFFaR0D0s4zfLiu90ZGszIS3JD1
	7NE4+3+0G8ANwL+j2Qz8rNDlYmD+mj9iPbIRVlcdUMKfwDAzsDwI5S5bo5BoJ84N5L/hho7gZyj
	J/9QzVIiKbV5exb68mg==
X-Google-Smtp-Source: AGHT+IEZCk3oy+HQSHrsEDAqwXlupd0xHmeS8IuL0N9dhMMAdmGlo9OyR+iiK51V+OKl7+wJfLEr+VwrJuInfXQr
X-Received: from wmbjg14.prod.google.com ([2002:a05:600c:a00e:b0:439:4366:35c2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f88:b0:439:96aa:e502 with SMTP id 5b1f17b1804b1-439ae1e6a2fmr119293615e9.12.1740399330189;
 Mon, 24 Feb 2025 04:15:30 -0800 (PST)
Date: Mon, 24 Feb 2025 12:13:45 +0000
In-Reply-To: <20250224121353.98697-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224121353.98697-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224121353.98697-4-vdonnefort@google.com>
Subject: [PATCH 03/11] KVM: arm64: Support unaligned fixmap in the nVHE hyp
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
2.48.1.601.g30ceb7b040-goog


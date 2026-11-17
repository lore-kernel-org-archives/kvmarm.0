Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937465;
	b=NCZ/ZLBSkVu18i3Z/tMatDTMWGMti4MQTQVfsRxXqsE2tPoH1LGA4MNN6N9cYildMM3g
	 vRVf1F1vUo49/Hm9yZimIGkCPI9wDU483cmr51lc8hmbSwSimf1Hp/StFaayTpWtFHqYV
	 fIV+slVenOalDP9pK9+W5WPw80v2qtYiAgOmOEIMQkyO2God8TC9xSJ4pUZ7yw3px+GVO
	 2jz9J8vmWbZeJT/DqGvA4/P+aEhQQdwpeoXV/OMMImSXbb2Vbba0Kgp+xA0mg6q+oHt4J
	 abC3jvoQ9GghjsCP8UH6SI9TvAZ/rUpIJSKwDfoH5R6uAFTlSTww5WqiyTW3qu7jrfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937465;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=qgmMhmn1xDiM5SvUXkFRuSY7uuW23V8W83iIcntUoUQ=;
	b=Fso70jF+lYIk7ChFwzIf+MuIk+am8l4922GnEmVQhmpTkFIyXACVkZVCI2lUGHOMqrzC
	 SthZ181Zi0JzEyuvm9x+18BCUWus1gLifxdY0d9nQIMlEMbvDPFu/Z0aTD6oC0bkgGeV/
	 UkcGvgrK7yx7cnQFwqRFng4rORYCEo/gQpW7FLOFJapOPe16jIFXM9NyLzFB+GnfcyA1B
	 JXT015HumphbW1D/WcSrWaLztJskqZv/WJAQEZyYU56JMy5clraN5HMPPxOV1zJz48xPI
	 2YhfjL3lBZ5Jvl/1sUTWfMNDId5vfznwREU82wwkwF0wIkPJEuyY5v2VZdwZhMUi77g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TyujYIcT;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3EC606A32F
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF3EC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TyujYIcT
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b59665acd6so72454a12.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937463; x=1795542263; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qgmMhmn1xDiM5SvUXkFRuSY7uuW23V8W83iIcntUoUQ=;
        b=TyujYIcTVY2oE6h12RUzELDTm7h9wjQgXEs8nPr2L66P5XQkSlgscCuY3aKR9M61km
         LjIdcpwq38Ucn9wV9++CEZWcuTa6SQU8jfDcLwehjfCjgCDe9/hj8KXGIscoqY6n7sQ9
         7hE4FyqEqBptafyLD3OGot8a6crQ1UnUbxTXz6TU9L98x7VZDyc3Xxb4fTG5xPpwCMI5
         hMqhT7OZ9VNLYikiV52PG2UKLV5+6G0OTmYQ761lHwMKRY962iIzFw+50HJhJU4zsnHy
         7tXshNDgSUgGHmPNVd9evjrQXj3L/hAtrL/LjubKhgC9gOyAjpGAwF3SDDcGR1Dp9bDA
         1IFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937463; x=1795542263;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qgmMhmn1xDiM5SvUXkFRuSY7uuW23V8W83iIcntUoUQ=;
        b=w1mVAr93trTOlnS+0xPuaE7VbrNUuX4nJHNR4+RRL+9OU2mnKrCsdJj9Qm+56mV2PL
         WKBKm22LUahjeGdo3nbzmXkI1RfqiQZDv0i62TxUXX5q0ZewFrPWfVbAi9Lc54v+4r91
         o8Rn0E0RaMokWSCfHSByP2YU47IRus+YRlUXbNIqIwIRyq7lGZzuEEHYFC16gc5nmluS
         zMdf74hyGuutEuUKRUUUBeni7wDuR/kaUFvWxv+GW4Z2MV/67U+D25fesb5vkipUbdt0
         Vc8fokURU6YFVQWpKSzU3uz9xqpE1eI4DKJbsRXVGe6BuhBIbrgWc35FXY/7G6BQcsC5
         isFQ==
X-Forwarded-Encrypted: i=1; AL+hErGhwn9JwfuIWwmbBZwGvD1D72aq1CZgC/5Ijaof0YORoITVGkqVDxpT1DmMR+8tsqldsjStNWQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z9UVFmW/Lw+XuWzT4i/+QAAtFqe0ugHz3pv5ejEQsUSmj/UymE4
	Vzx6mAAFm+5XYQ1UJ0QL3F/G8Y0pvWlllSYNjP8x0rCQ9+O+1+S7fGhr2Ohr7rJmHJhle2JOkog
	jHuJWN3tRj6GsQhJ8J29lbw==
X-Received: from edyg9.prod.google.com ([2002:a05:6402:1809:b0:6b5:70a4:c77d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:84e:b0:6b5:8200:3e97 with SMTP id 4fb4d7f45d1cf-6b7c0c8819cmr11481471a12.33.1794937463185;
 Tue, 17 Nov 2026 09:44:23 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:45 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-7-vdonnefort@google.com>
Subject: [PATCH v4 06/23] KVM: arm64: Reject zero-sized ranges in pfn_range_is_valid()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

pfn_range_is_valid() validates that a [pfn, pfn + nr_pages) range fits
within the physical address space, but does nothing when nr_pages is 0.

Luckily, there's currently no existing check that could be evaded.
However the pfn_range_is_valid() should make size trustworthy and 0
could be problematic. Explicitly reject 0 range size.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8d5bfae67396..385a7ed12b3c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -400,6 +400,9 @@ static bool pfn_range_is_valid(u64 pfn, u64 nr_pages)
 {
 	u64 limit = BIT(kvm_phys_shift(&host_mmu.arch.mmu) - PAGE_SHIFT);
 
+	if (!nr_pages)
+		return false;
+
 	return pfn < limit && ((limit - pfn) >= nr_pages);
 }
 
-- 
2.56.1.708.g77570a6a1d-goog


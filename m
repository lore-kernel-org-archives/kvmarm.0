Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B511A3E63B2
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508575; cv=none; b=dm5O62hrPQ7cfKU0PW5mWKWjV5d6EKdi37fIaFS1XewALy3uYTvEj0NFLi3CuIYDirhVz3SCLFmWryndAjdEMnYUkwCu8ooLCEWYGnJ6ERPPoUo3HaCmtG96tOlLUw8kGnqib//B7PL7w3TSRkZWUwFBXv3MrsD+gHrI7h7Uijo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508575; c=relaxed/simple;
	bh=1MOtcGMLEjVHJArhMTga6+xmIxLVS6LignNv8fVZX7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L4NJkNWnM34uY5ssKs/ZpVkIe0fjHiFIJMv7afkSNvYtKQ05Q4HZGM/dtNhi+mpEnM38qCcM8pWv8kJLxRXPmkxuVs2A6ktGo7LzVL0opuLIoeFPEc8oDmnQLgPBPb5B9d3XHwjRhmKy3rN0KEaqpVukMS1T95lHSF7VOSOysOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A3YYYHow; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A3YYYHow"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6984787eeddso1069220a12.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508571; x=1786113371; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6sXhCxcibbJ3/EZ2ScJyrxsR4ZxuB2GfnnCFHZbPKV8=;
        b=A3YYYHowGOvF1mVEaecv2pGEXU0OI7+iAzPjK2wADAgT7TAXFGtUW3gmFdkeydpOP1
         KLDkCmYpLKKnHjx3catK5b/QDP0L/SFp+PknzdksY8GIsW0mqwRr70KjdXAxiCrHzFPQ
         zDM/2UkJt7LzYUjguEpD5LqZ4NuJ97QnOwQjgHJuJD0DVxicuOiHlH9g6TX8OB932Jph
         Jw6g3UsCbzGB797T61OkHjNE11Tp1AqRzuoE+WziL6pG8lUrmfWfW48b2pse4hpakdBy
         gfOXbPffQKwp+atoNx0KS2MzC7F0QeyEgpFKA9H1GZA+UvlixFdzMOXXmKfr0n+c6uIW
         8b4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508571; x=1786113371;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6sXhCxcibbJ3/EZ2ScJyrxsR4ZxuB2GfnnCFHZbPKV8=;
        b=KnHGHrlUQPuZJHHDVW+guA25RhuxRUELxdGDRS57ZCWgE7QfORtBIEZRZaNvwGiTJG
         V7QOrfvrO9UXrFN8PRmPSC0bs6poWkqaBx3c+0cLjB8nrSd1GIAIquYxiOkhOepgyfSB
         ge5i5XNqKSKH4Vcu+CDnLwJz/uWzeoLujwBuWulb0KMkwkgsmIG9WJStQcXHhVEAt0NL
         c0J25KkMibeHvK1QUmfZqUqHsLJHpBic+JjCgl0ZdWrd5VGhjB+LuOaxuNHAdv6DCFJh
         wy3eUIe3cUe2NO6mrSKt/6jjZh9N++cBf0NmbTPztSqj9yrBrT9SLPaEKLv+A5YwsQIi
         tJOg==
X-Forwarded-Encrypted: i=1; AHgh+RrnVT1i10GbmYwZAFKQF/W16Hc8pIV/YTMCF/B8apHqQrndScSdqPKSfw37iBShZwqDKKlzL28=@lists.linux.dev
X-Gm-Message-State: AOJu0YycY4An5schYk3YqTcY9aHSBPGJLO8tt3R95EbJm2ta99lRJIFR
	dQNwxWjN5f8KBARLMAuzFU8HPTlABYqMPhNis9t18f/W2snYJNRuvhN/pSbyf4ZVBCjRGhK0TI/
	6+v2pu8q5DtqTmSlc+o8txQ==
X-Received: from wmej10.prod.google.com ([2002:a05:600c:42ca:b0:495:66f2:4250])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2747:b0:69e:98e9:b0b9 with SMTP id 4fb4d7f45d1cf-6a098d092d4mr1378124a12.25.1785508571290;
 Fri, 31 Jul 2026 07:36:11 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:39 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-16-vdonnefort@google.com>
Subject: [PATCH v4 15/17] KVM: arm64: Reject hyp trace descriptors with fewer
 CPUs than hyp_nr_cpus
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

While a trace descriptor with fewer CPUs than hyp_nr_cpus currently
causes no functional issue, such a configuration is invalid and would
cause the hypervisor to skip ring buffer initialization when allocating
backing pages in EL2.

Enforce nr_cpus == hyp_nr_cpus during trace descriptor validation to
guarantee that every possible CPU has a valid ring buffer descriptor.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index e7e150ab265f..6e716295247a 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -181,6 +181,9 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 	desc_end = (void *)desc + desc_size;
 	nr_bpages = desc->bpages_backing_size / sizeof(struct simple_buffer_page);
 
+	if (desc->trace_buffer_desc.nr_cpus != hyp_nr_cpus)
+		return false;
+
 	for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc) {
 		/* Can we read nr_page_va? */
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, 0) > desc_end)
-- 
2.55.0.508.g3f0d502094-goog


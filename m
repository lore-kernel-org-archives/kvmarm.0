Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A263340A7F
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508575; cv=none; b=hkZnYuZDJZ+XEnkbr5mvAun5u2YEV0hdoF5p6J/rEmasBBR40MSw/lTcnbtt7AgpP4+YtRg8PBSwaXJYkD+Rne0oXdZvRyuW2G/+gUQdWMDWBzpRfNfN46Z5gHQS+kf+opIVmeXPPjyYbcWaV0lVnjRxRKR9w8VQYp8JyaSv0LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508575; c=relaxed/simple;
	bh=sbzUq1p6bSfGe0Wyz6THgkGeO6zZRuzmFCw0+lFrfWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OBAyyHiTDsXjkCAOeb/iVEcnQ6SNSJB+M8AIVlv25wBdeukTZevAdOBmuaOGtjeXKM7UVP8McsH4HCt25nAibfdBI6AGht7sTD89Ra0042ZtTfALDZmA9FTJr3EQ7d6ms/SvRL12ZRj5bj11jUOWkehNv3fjKkS+SH5+mZoBOvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rNAZkguq; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rNAZkguq"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6984787eeddso1069245a12.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508572; x=1786113372; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5WScly32cO/pWys+NwDAhbqd6QITQjPoTI8up8SEAyk=;
        b=rNAZkguqfjRH9kc+nbMDs1DM93zM9Nyjy3aMGxrXOUxR/afWdk2UpgrSEWRzriOwbr
         fvvJjlpBYxonK0l0nPVP1VwQmQy1aENS72yaqxN5sEzVXeVNx37IpPMogKwGYpQ20qLq
         0kbqc6oLJpdxWvg144IIjh0LIOOPuXpiV/UVTGuPAOSw8U3KKnma4luoLziCu/OQYb9B
         30y7I/8ksHTLZnvU41iHjcMQrCSw+lsw9q1BPPcWgWYQ/9WqxyQI7fo8ibyd6Db3IVwv
         cXjPIsRU3Ga+uL4kCz2J2zQQB5OzAe5++qDR5wX2AlCRmVf7rCm51dqDEyPvZMALebNe
         9yhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508572; x=1786113372;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5WScly32cO/pWys+NwDAhbqd6QITQjPoTI8up8SEAyk=;
        b=NtLo/6qp7W0CjEar0icNB0uiDnqhrLBUaeksEkG4DB3OYrTBJ6Yk6LQ8mhYEfnvYi9
         UrTuetibE/eflw0YDnYyfCMkPJPF0gHIdkMGGbzgeRF07pjpRFsq8WoS0WhnMwzyZdc9
         ZSqhFCnCYiOLBD+Zes4bAaDIInI1GKarKgPGF/YXb4Fqjg1G2UmgMMW2kdj8dMDNxX9U
         t3CGAFndftsOcrf6H26SXOTqBF8zOPucviQsko5fRf2i7l+5RAHF3Kq+NKQC/9BDi87v
         QZCLE5kBa8ZwCmiLPpETkmK6+qB+R/NCknrMvwHhDL9KVBFm3psbz5XtgqmAuJ4ZpoxY
         UWug==
X-Forwarded-Encrypted: i=1; AHgh+RqaWYwjrGmH+89rVoRcWnZo31/IkPtx5z11s+j5D4UXXJ4LxO2ZzC/T2grDC4E+kJYXdwaIzY8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYKgLocbSErdmwkNgU4njpXiqGvZr/Xx5FK1kwiA0Z1uciADVv
	rx3Y/Bfz4MZvrx3U6oMRguMHKxefQ+bHR6XUKhwe+cyERtx8/sxLmllP3H4rFRftIsWTTlyBKg/
	iI2TRVpEea0chlR2J1YIgeg==
X-Received: from wmjx19.prod.google.com ([2002:a05:600c:21d3:b0:493:c42c:7e97])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5046:b0:6a0:9465:3e0c with SMTP id 4fb4d7f45d1cf-6a098d1bc48mr1448179a12.32.1785508572350;
 Fri, 31 Jul 2026 07:36:12 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:40 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-17-vdonnefort@google.com>
Subject: [PATCH v4 16/17] KVM: arm64: Reject hyp trace descriptors with fewer
 than 3 pages
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A trace descriptor with 0 nr_page_va allocates a 0-size bpages
backing region, which makes the ring buffer appear unloaded. Reject
descriptors with nr_page_va < 3 in hyp_trace_desc_is_valid() as this is
in any case the lower-limit for simple_ring_buffer.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 6e716295247a..96afa3d6de2f 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -189,6 +189,10 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, 0) > desc_end)
 			return false;
 
+		/* simple_ring_buffer_init_mm() expects at least 3 pages */
+		if (rb_desc->nr_page_va < 3)
+			return false;
+
 		/* Overflow desc? */
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
 			return false;
-- 
2.55.0.508.g3f0d502094-goog


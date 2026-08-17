Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE8C3D3339
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975255; cv=none; b=N9AqajCqhFm748jZuVKQXeyywpqzYEdTBaT0crcBf8xF/DOwpyrQ6jJQSwHpED1dWWv++GGv/TW1lPpPZOoZXUo4vB/pSYqYqpO4sCkbMLMwLuiG2R0oaQoWMQIqrb3pyj23N+2q/I54BcZgVvhXB6uEvrIA5+ERx92f+J0YBnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975255; c=relaxed/simple;
	bh=E052iV/UahZwZLqHPoeCbZVIwICG9funR37mcSBDpLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HL25WbgX3oesbnLobBXIrjm1uy+9Bvn0PYgqpLPB8XKXEIq37DvDulNsHDnBjIECaaBEyVhgLQzZth7i0Sfq0xFRrxVDgauRyj5CC5GL4qOvlqLWfGvX4+iszJjIoXx0f64bDCET154Q0wYsc+m+oNhEeWlHpJt1+a2aCfdnaP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AASG8pCS; arc=none smtp.client-ip=91.218.175.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AASG8pCS"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=E052iV/UahZwZLqHPoeCbZVIwICG9funR37mcSBDpLA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786975251; v=1; x=1787580051;
 b=AASG8pCSgOFWhZbj8SiRj1SD92svnqN36kIsJGN3tfuuY+IuI42WFTEcHlsteGczxcNJTQUy
 1IuDDAAc9UlD2Iy72FQPqZOGIyYTqW2siJN3NegB3Q80ax49Kq7+Ws1zHf5cErWjlteR/1hdBmD
 /UzMPOEXvoBZJ7d6GGTl90jg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f46.google.com (209.85.167.46)
	by smtp.migadu.com with ESMTPS id 6434ab9d61c40b34;
	Mon, 17 Aug 2026 14:00:51 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso17908e87.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 07:00:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Roh8ndNKUcWiARBcQovcvRwjpNLDVgvH3gK82YA0KoKDU3RN4n432ShLNHKp8Ul6HHlLhdBjFI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzG1YKEAO1CF7cKSjQQnu3MiO2RZhPvQ4qdVCvbCL/LW0uzi0br
	MbmffknmpSq4idCFzEpjEUTMnKly9vFEUlRY+Gd//ke0hlthhAo/qVlWe8ZJaKT5T3/j604VwCQ
	4mcCnejpd9dphqqtHDgEy5IpaeL+4G11BL9yYUgMc
X-Received: by 2002:a05:6512:3b13:b0:5b2:a967:c0c9 with SMTP id
 2adb3069b0e04-5b47085689amr10313e87.7.1786975246266; Mon, 17 Aug 2026
 07:00:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com> <20260731143541.956291-17-vdonnefort@google.com>
In-Reply-To: <20260731143541.956291-17-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 17 Aug 2026 15:00:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxniWpQ4YXF58FiqvG2mdnKO+xvtqwSVU8CFiNMEfradQ@mail.gmail.com>
X-Gm-Features: AcwNN1W_AAsd7_VB-Kj-kfRzJQQpYdjSQX1n6UdwIFTBXMf5NarxswUq__9s38w
Message-ID: <CA+EHjTxniWpQ4YXF58FiqvG2mdnKO+xvtqwSVU8CFiNMEfradQ@mail.gmail.com>
Subject: Re: [PATCH v4 16/17] KVM: arm64: Reject hyp trace descriptors with
 fewer than 3 pages
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Jul 2026 at 15:36, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> A trace descriptor with 0 nr_page_va allocates a 0-size bpages
> backing region, which makes the ring buffer appear unloaded. Reject
> descriptors with nr_page_va < 3 in hyp_trace_desc_is_valid() as this is
> in any case the lower-limit for simple_ring_buffer.
>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


>
> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
> index 6e716295247a..96afa3d6de2f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> @@ -189,6 +189,10 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
>                 if ((void *)rb_desc + struct_size(rb_desc, page_va, 0) > desc_end)
>                         return false;
>
> +               /* simple_ring_buffer_init_mm() expects at least 3 pages */
> +               if (rb_desc->nr_page_va < 3)
> +                       return false;
> +
>                 /* Overflow desc? */
>                 if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
>                         return false;
> --
> 2.55.0.508.g3f0d502094-goog
>

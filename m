Received: from mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF795175A6C
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 14:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787063022; cv=none; b=iDACU5A5xQh1yfyrACgCZroV1O7fLCh2CdHg657WuPXrpKNSFUW5fNTN8hZACDrSADH3RfX6vGCECxbhHFqcMxEqW3o4HpAiuP0Bx8bWWFUElRYeO0/fE2UlA3jISvq8ogfw4GuyoJvl2xB2RL3xGginrQFJfLzjgUa0v3FYI7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787063022; c=relaxed/simple;
	bh=2zqtNHuHM9vTn2QiWb1DKB4n7bPmtKuVIDCe9D+lr/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XJn9Tm+HdP9INvD+QAJnbyuG6VMyOkeMJuaqmF+qoVkQOGbUNPQjsH0Hl9kqKZ9AS7mcu+m+LX8q/NT74HvJTEEVhNjTL1S9YW86Mhh1Vu9HvQLJu39G+Bi+BRvHinau/wuZX8+jcN8QknLkrDRcYVnntaY3+pWahcl6wiM7MbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g1PFWZlm; arc=none smtp.client-ip=95.215.58.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g1PFWZlm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=2zqtNHuHM9vTn2QiWb1DKB4n7bPmtKuVIDCe9D+lr/E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787063017; v=1; x=1787667817;
 b=g1PFWZlmNQxWJrFMOjXUJu8hZwIJUBSzXxAteESsWL99h+fSQRbCjofRSu9wBP5La5kqwhnR
 hqUrd4EkJvlwMotSB6X6xDVOFpek3N24Wrwp/MJwO3D8RB3OrQNJDqMdAugx7qTnsoc7WQ0WgP+
 eLxCx+XwVJz7cFX44NUVXPWk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f50.google.com (209.85.167.50)
	by smtp.migadu.com with ESMTPS id 7bef91e02fa480ad;
	Tue, 18 Aug 2026 14:23:37 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a8173142so7075e87.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 07:23:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp9j3HcsGV+BKi0FQIUe4sqh+bVa4/vu5O2fDv78eiJNNkiPHvq8pM2msDp8lfleSCxP7b222Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyv45hkIvAcS9UWDNE/10FNuLkbTbAplTSU1uI7UAFjT7aKd4R6
	f5boDd0yE/dCaet2JORm+jAWICeDRar9r+3Gj25ORd8fQ90lkFY1Nt7VL4wcl4ys7LxPX5g5YGZ
	nYeyUsgfbt5mEX5RDWjp/vlImgPpIFhgGtYE/Z0IH
X-Received: by 2002:a05:6512:10cc:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5b471ecc992mr219425e87.2.1787063012292; Tue, 18 Aug 2026
 07:23:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com> <20260731143541.956291-5-vdonnefort@google.com>
In-Reply-To: <20260731143541.956291-5-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 18 Aug 2026 15:22:55 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw9KcKgGDgD=khN8qGPgJAe9POhu1uLby9abDbogwu5sA@mail.gmail.com>
X-Gm-Features: AcwNN1XmyjAJIba9VPk2Ku7RXpeskFOmZC11eun7x4m1kPjfLEO1BYO5VQp3BtI
Message-ID: <CA+EHjTw9KcKgGDgD=khN8qGPgJAe9POhu1uLby9abDbogwu5sA@mail.gmail.com>
Subject: Re: [PATCH v4 04/17] KVM: arm64: Add a heap allocator for the pKVM hyp
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 31 Jul 2026 at 15:36, 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
...
> +static int hyp_allocator_destroy_chunk(struct hyp_allocator *allocator,
> +                                      struct chunk_hdr *prev,
> +                                      struct chunk_hdr *chunk)
> +{
> +       struct chunk_hdr *next;
> +
> +       next = prev ? chunk_get_next(chunk) : NULL;
> +       if (!hyp_allocator_can_destroy_chunk(allocator, prev, next, chunk))
> +               return -EINVAL;
> +
> +       /* Last chunk in the allocator */
> +       if (!prev) {
> +               allocator->first_unmapped = chunk_unmapped(chunk);
> +               allocator->head = allocator->tail = NULL;
> +               return 0;
> +       }

hyp_allocator_destroy_chunk() has only two callers, both in
hyp_allocator_free(), and both pass a non-NULL prev. So this !prev
branch cannot be reached, and nor can the matching "if (!prev) return
true;" in hyp_allocator_can_destroy_chunk() or the false arm of "next
= prev ? chunk_get_next(chunk) : NULL".

The empty-allocator reset it looks like it is handling already happens
in hyp_allocator_reclaim_chunk(), in the addr == allocator->start
case. Could these be dropped?

With that:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

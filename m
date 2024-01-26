Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D4E22EE3
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 20:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706299252; cv=none; b=Jjzk2bDhjuNLqyhi6UPG1RZmCX8ChDdIbQ9tUv5b+x24APosOr0pJHzEcFK36KwlD5gD6FlEb1wRsqUxf08Bx2FP4M0q8DZl7ELab73nTN9QMEOjDGOvXMZ2IFMWkBe0S6FxoTM0SLMHDmUfJhqS/uu9Y9ol6byBkUwxJJZlutA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706299252; c=relaxed/simple;
	bh=fcxQ3bc2/ycZVVRavVndN2TW1bmrjhqtW752nshgov4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YHD87IkFRKMVMfARFIDVIUpZC1cJEvbPlhV4wUqqVmanmHmWApNAvP464OdjJQQXQgdhA0+146g/Gz/VJUU+AEqh5nznPlQ39G2uvXMk1hjmkMwQATiy9/hMvO0F5J5S442PK5XLMZkNzgLAqWrfLo3F+8YxGm+gR6nF4tmDFjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y85u0fbC; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y85u0fbC"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d72d240c69so20375ad.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 12:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706299250; x=1706904050; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MimXWUdcIvN0nH3+dB3+knWCETvDzwsFYg6Za1niF5A=;
        b=Y85u0fbCJjCdMA13kOAVGUPsK4RtwYRj9H7GyRLR3UXJvh3LHOX7qvrDSKWbCO5zet
         K1s7guEXAXv8hEiubNItHwTS5QXQ9NDm8VRf5bNCUm2HZcRemKzeF7tz8TIoCliin0gc
         g9ABHxtkWl3/O6xLWZL+KYOlVEygbfO7DJbJrhCNi1sJda4O+1ivNmtKISv4fxmZ+yoW
         j3y9lYz7OuLkaoi+yf9Myzxi/U1E7P9csDMPoVyJj3MyAwHmqUEXGKPVxQFz9NEtMcrw
         LFj9heDSUQo7XhJpLI1DVncGh2+E6IS7uPkl8nOLyYFaaQJ3YmyfPyCWuDN4RogGhhbp
         Q02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706299250; x=1706904050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MimXWUdcIvN0nH3+dB3+knWCETvDzwsFYg6Za1niF5A=;
        b=ke0qdYbwOLyr4OWiFHVjJIecJxy2VkAtszxu15rJL6Ipt/z8e/Dl8v5T9AzGHa5gSL
         Vk6N+kvOWYJG1TwR1cBXPCuxH6QHKn9LHQtEFgWjji/VdoT2iTAiIFx9WarqXB6yY5il
         j689Vy5gCfjIZfV31DYM4Xx6LHCTpfb/P4XCa1uZLcZytiKXYakG+n2UmxIPOi6u7aMq
         MFc33mW/gwkOxGQrSHoDG7zGTvoS594yDAFqx3OIye+r419+DzNVQBqsZ/NPTnBgRZhi
         5pRtEN4vx3TyvTOPj8fQBxgbqHSQ+WXXgfLAk9jifD/rkVGR3BHH7KuPQFSxziqg21IF
         QXeQ==
X-Gm-Message-State: AOJu0Yyi19wbdasCvRcutVm3qZk0sgE+L1sBirOXQZk7ZPvDvTdRUIA3
	DFio4JAfWw6ZF30wYBdODMnKSOPbzhe/wL+kXG9oqtEIMJskmzhg4Nng5IcJ2E9tgIK+RyHA8b/
	yJJtu1wbF1DcNkOk+9CyE0nqHw8uOCo0sbWyc
X-Google-Smtp-Source: AGHT+IFUiaxxx/fnNfe3njsMipgqF2fdYzG/YBwFDzOMI+2YRba8r80bUR3upqDy6QVJlcre5NJrJ1mYmBGhuhzNf/E=
X-Received: by 2002:a17:903:1246:b0:1d8:a782:6cc2 with SMTP id
 u6-20020a170903124600b001d8a7826cc2mr127996plh.13.1706299249979; Fri, 26 Jan
 2024 12:00:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240125164256.4147-1-alexandru.elisei@arm.com> <20240125164256.4147-12-alexandru.elisei@arm.com>
In-Reply-To: <20240125164256.4147-12-alexandru.elisei@arm.com>
From: Peter Collingbourne <pcc@google.com>
Date: Fri, 26 Jan 2024 12:00:36 -0800
Message-ID: <CAMn1gO6hx7yaFHEYVbkpPocAxQmQc3JBgppcNSJw9SUfyvjwbQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 11/35] mm: Allow an arch to hook into folio
 allocation when VMA is known
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev, 
	maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, arnd@arndb.de, akpm@linux-foundation.org, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, 
	mhiramat@kernel.org, rppt@kernel.org, hughd@google.com, steven.price@arm.com, 
	anshuman.khandual@arm.com, vincenzo.frascino@arm.com, david@redhat.com, 
	eugenis@google.com, kcc@google.com, hyesoo.yu@samsung.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 8:43=E2=80=AFAM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> arm64 uses VM_HIGH_ARCH_0 and VM_HIGH_ARCH_1 for enabling MTE for a VMA.
> When VM_HIGH_ARCH_0, which arm64 renames to VM_MTE, is set for a VMA, and
> the gfp flag __GFP_ZERO is present, the __GFP_ZEROTAGS gfp flag also gets
> set in vma_alloc_zeroed_movable_folio().
>
> Expand this to be more generic by adding an arch hook that modifes the gf=
p
> flags for an allocation when the VMA is known.
>
> Note that __GFP_ZEROTAGS is ignored by the page allocator unless __GFP_ZE=
RO
> is also set; from that point of view, the current behaviour is unchanged,
> even though the arm64 flag is set in more places.  When arm64 will have
> support to reuse the tag storage for data allocation, the uses of the
> __GFP_ZEROTAGS flag will be expanded to instruct the page allocator to tr=
y
> to reserve the corresponding tag storage for the pages being allocated.
>
> The flags returned by arch_calc_vma_gfp() are or'ed with the flags set by
> the caller; this has been done to keep an architecture from modifying the
> flags already set by the core memory management code; this is similar to
> how do_mmap() -> calc_vm_flag_bits() -> arch_calc_vm_flag_bits() has been
> implemented. This can be revisited in the future if there's a need to do
> so.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

This patch also needs to update the non-CONFIG_NUMA definition of
vma_alloc_folio in include/linux/gfp.h to call arch_calc_vma_gfp. See:
https://r.android.com/2849146

Peter

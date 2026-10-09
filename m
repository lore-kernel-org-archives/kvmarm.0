Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577693F787F
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 08:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791535164; cv=none; b=fvpmAHuuXRXlhyjPmIjyjz/Lez45uJ8v6BOUGHpKY3Dxl4zFWEKEO5VPvCQ7CI8uMfWmUPmHVB0q7ApMPScxXyJyQiR1vBtpAZA7WW6wbIdhW4ucYIA8Urr/wdvcKs/RhxikVaHV69FZIHS06Z9bDgERLhx5E7jG70vQ4oXMXrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791535164; c=relaxed/simple;
	bh=4/ack9nltpgYw2NW/uBT/gEtynaJZa7muR/CB9wBG+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGF2i3yFt0uquppv/Q8P/n9IB0i6sqH8e6OadoigAnJb3qtz9TZf2UqAo+SFmobSCDA4tvk8+PJey9C2Ub2SzT2FYQGOer11swgCQh8dyfTvykWuYuNOW4j1TzR02jh58L+ywGf1CaIuupqU5CBUqI21Ze+uOHv/egnDzH9nDNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UfEtgSIg; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UfEtgSIg"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-487049569b6so2655093f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 01:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791535161; x=1792139961; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HuxXA+MntcnCOxad2X2sYG+nW8j/CwA8P+nRSnKOkVQ=;
        b=UfEtgSIgZrxqpSoIamyPoKpkR/f3BFChbvPS3bOnY4eKEnkoP7Za7cu/pAwu8n32iT
         tXAed6RY/jQ7VSIWAntl4DzDR0bIWrzm6qSP4ceKCQQRXYL27P67zNY2g3UISnN57dzE
         Hch62lHf0gJ3NKSMOtW4ZBWMU4SiBZN5lqOlCBnNgcR2AhCNH69258LmLSAHJ1WO+LHG
         KeTcRxKqZO6xNuGYi8nBtMZGlm7Iq8WwSWxLaJOaw9WNqTAOfZm2u0N4e4xVrpEMzaJE
         GTyOZSTNkXxp3iEKxsIYhr3s0u0Ut9faXcfo79VwX3joWBX33lIf0hqMftCWe4WWrw7D
         PaJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791535161; x=1792139961;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HuxXA+MntcnCOxad2X2sYG+nW8j/CwA8P+nRSnKOkVQ=;
        b=igyDEQWJ+muVMeMQvlAhLgSS7UfkqJ9ov9DxXOF8z4CkT3EURaw0yj9hb9LEe8R2ro
         5lPEvBKvy+S0TrwfA79UZrya7dwhVQDq+r0HPM1N7nKElzOUnH2hYYnVvvkg8mQLWG81
         DfshaGkaxLt4O0B72dKijBcactj6WlNRIjFTmQ9Oehz6MubXrbGukU7wjsbrGyJ08Oq7
         QXN4+OlNye/FS4kNK5JWVNLujU/ky60tf4POWXJqtUBkIMAyf7pmlmFsPR5E4ewQkfhN
         KTNGTmfjVyh30nEwEYqHfM+Nn2zWY320rYvDQE6juUljI61DXrJ8cJiAlNP0a1Z/6vpd
         DXcw==
X-Forwarded-Encrypted: i=1; AKwUvBxtAz1JM0Q4n3R3Qu2Xj5kn0kdLx3Ht3DdEnZc5IPS3q+NwwIrH4I5ULEsfZGZaPd/Yp+7FH7I=@lists.linux.dev
X-Gm-Message-State: AFq9FYKBc4zE4kdPhgkZXex7jRugC9RHWt9qIZQ7QlJhaPRGZBFA+zSG
	nGSAKvTCn6x+NBW2NEh6gNdghYgv0ifC4i0dCfnhpMB7chW1qtQ0sxM3WwuIBRcJfg==
X-Gm-Gg: AYBFou1VsNoAsBgvDIRyFP0cBCInxkBCOUemci7H5D+SED5Y4yiGya7DJhgC0IZV0n5
	Cm9+ePC7x360+bMxZs3vMPmifsV35wD8UzUvz78kU7X8ZSn8568DkXcYG0PdhVSa+6u3v3OSznE
	WEkM7LAN7YS8oskFTRfWrQxfvDFfqb6jGYPJvWDRdbh+uWi2kc2eMEsftTZhNEO1VpJSOtoTNu0
	dazJ6qTLO8BTl9MQrtvvQ2xBVQ2w56W9buJHIj76L7gXgHrzskkTTkRlR8V0ONMmwnjDZaWmR4M
	W23w34EZU93EZfCiJgKwbZPXuhnaJM5zXfmMOAmC3xUwsxwPXiYL3m2mu0dKEU4hPsGvOz9rQn9
	qAKIQm1vfx7LbyELClsijg02rv4sKogoHn7hnXtBhMKAj3g1RLWas8gR1rlVdPGzWomkZyzZEGg
	v0rxTe6uUts55ReNSnwW8LrIudsZOS/FmhLxz66kdsSsn9RaYMJ+et25O5W48u3XEneNYIXODFV
	V12ypP9BTAhkmRhnURFdqkli8s8LSVwON+BgAYdLIUmpXMKm/LgjNw=
X-Received: by 2002:adf:f6c8:0:b0:48b:70e:7bd4 with SMTP id ffacd0b85a97d-48dbaaea42bmr1516998f8f.28.1791535160947;
        Fri, 09 Oct 2026 01:39:20 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9acfa28sm2745702f8f.51.2026.10.09.01.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:39:20 -0700 (PDT)
Date: Fri, 9 Oct 2026 09:39:15 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v1 2/2] KVM: arm64: Fix bpages backing allocation size in
 hyp_trace
Message-ID: <asioMxhIlMm9PSQK@google.com>
References: <20261008104212.3134550-1-vdonnefort@google.com>
 <20261008104212.3134550-3-vdonnefort@google.com>
 <CA+EHjTzpKk3hUTriyRF-YWkNQpQ82vuJoqKkW+uo+6n5f2mhmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzpKk3hUTriyRF-YWkNQpQ82vuJoqKkW+uo+6n5f2mhmg@mail.gmail.com>

On Thu, Oct 08, 2026 at 08:13:29PM +0100, Fuad Tabba wrote:
> On Thu, 8 Oct 2026 at 11:42, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > hyp_trace_buffer_alloc_bpages_backing() computes nr_bpages as
> > (PAGE_ALIGN(size) / PAGE_SIZE) + 1, whereas trace_remote_alloc_buffer()
> > takes into account the buffer page header.
> >
> > Align the bpages backing allocation by using
> > __calc_nr_pages_ring_buffer_desc(). There's no need to validate
> > nr_bpages again, it has been before with trace_buffer_desc_size().
> >
> > Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
> 
> Should this have Cc: stable too, like patch 1? The undercount is there
> since 3aed038aac8d for small buffers, and 442ffa742daa6
> ("tracing/remotes: Account for ring buffer page header in size
> calculation") makes it reachable at ordinary sizes.
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> Cheers,
> /fuad
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>

Yeah I wasn't sure, because __calc_nr_pages_ring_buffer_desc() was introduced
later.

But I can figure it out once the patch fails to apply and provide the
appropriate backport.

Thanks for the review.

-- 
Vincent

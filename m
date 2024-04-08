Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7347CF25
	for <kvmarm@lists.linux.dev>; Mon,  8 Apr 2024 13:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584588; cv=none; b=A2m350JghXLUOyn9geZeg2DZKCdu/Gii4D7vSsWoruv7Ot0mCGe8Do/o/rYW6k74jPWmLht5zcICa2RdAA8PjHocaaRUSotCzKcjUhZkzUxq1oz/4s7/GY5pEfr0ShPQIede0hxG4ZWmLueOyWhzWfAsVVcxAe1n8b1J3HuAm1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584588; c=relaxed/simple;
	bh=Sv1lonJMRVR+UVuirFpH2YmZNDikOQMGGjjjY3UJLc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=INJCpkiif4mq7GoYezPWgNrahQODCrh4v02qu+CzEcpC6F1P0D05+tiaOjlhE1R79Se00tBLiMACDQr05LhbToWFNparPDBfyYmUr/pvNNssT+X/TNw7zkNt2B8a7Un6b+ELhnqufScn4uBzzy/LIzqb61rh1L7fCy5dLOXUUE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jSkc+D6j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jSkc+D6j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712584586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rmNJpHW5Hyb1elegWpLMoq/S1yVvTDK8DJLj5yKd5mI=;
	b=jSkc+D6jQ67V96JT6DTwSNSLxH1rUBZFARNc5R/BSk3H3V2rn8hWEMn53rcmm7qECEhwzv
	4DlNbLLRfAPjUgG4ztQxrrxWKNMTWd3TDmrn7o+jk2HQhR30ZhaNTPBH5Cvke1QkWwDuGc
	aITJkULCtA6UgkkomweJs2wnjLj5alE=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-XqOK1wTKOZGQP8as-YFUrg-1; Mon, 08 Apr 2024 09:56:24 -0400
X-MC-Unique: XqOK1wTKOZGQP8as-YFUrg-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6ea20a966b0so46684a34.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Apr 2024 06:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712584584; x=1713189384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rmNJpHW5Hyb1elegWpLMoq/S1yVvTDK8DJLj5yKd5mI=;
        b=oNbXS8mRZGdoYgbjI9gGuJwnzC4TaK9JoPiPQBR8lA27KQsa5t3FJhdOqmUqYLkiFL
         6w3sGsU7+OlZZ4lvxUiIWiEI9/9u6wDC23gmjpXGeFnsBor7B7C1jrH4FyJsCZcIeS1Y
         /5sfqoKnoJfLzfUtA7NXNUjkzvLtOlM+LhOHYPm9rZgjErxkqe/3K5ClLO3YUKO8a95E
         f9wAdHUs8ic7OawsqRJkMxowxgaavLUKW0O5GaDaqbKcrFA5nqIfIp+9JLjVFEz/dlIy
         Cje8Q0BMXySDIpPsirC2q140skmmW/2BrBwI87S6ZyEfwYr19RKsUtxwqWSH250H5K4O
         rCaw==
X-Forwarded-Encrypted: i=1; AJvYcCXKPMd+ZiVMsXJOsXvOnKtsamWQqjB2Mzojp4rFhhPlNbSLJEKXOBbw+1+dShrjP1C3+rIgu42kbxWZKe04dUaCQYJHuxs+
X-Gm-Message-State: AOJu0YxtGn3byTRXek6XsORsnIkoS3hMiYdSmZAbHh7gW/VwuRgOnkZW
	SlqOJbvo8cKmSIShmC9MsGOqGDoJqs28FqETgYpruK2fQreTlvcXc8suELgzap47BmtChhqjnRf
	uj4tNbZvm6L8l9J1pH63E0EsnNSxRBFjplajJfzA6IvXkFX4f6LVktQ==
X-Received: by 2002:a05:6830:a5a:b0:6e7:592:87ab with SMTP id g26-20020a0568300a5a00b006e7059287abmr9702525otu.2.1712584583704;
        Mon, 08 Apr 2024 06:56:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/6cZVOu40ZE5XkeceEvB5GWIk5ESL9MdZGK/RmwIM5NG0Lyufyd1ejET8K1FRMeVweFzXgg==
X-Received: by 2002:a05:6830:a5a:b0:6e7:592:87ab with SMTP id g26-20020a0568300a5a00b006e7059287abmr9702473otu.2.1712584583118;
        Mon, 08 Apr 2024 06:56:23 -0700 (PDT)
Received: from x1n ([99.254.121.117])
        by smtp.gmail.com with ESMTPSA id vw25-20020a05620a565900b0078d63baf516sm1301217qkn.129.2024.04.08.06.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 06:56:22 -0700 (PDT)
Date: Mon, 8 Apr 2024 09:56:20 -0400
From: Peter Xu <peterx@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
Message-ID: <ZhP3hDhe2Qwo9oCL@x1n>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240405115815.3226315-2-pbonzini@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Apr 05, 2024 at 07:58:12AM -0400, Paolo Bonzini wrote:
> The .change_pte() MMU notifier callback was intended as an
> optimization. The original point of it was that KSM could tell KVM to flip
> its secondary PTE to a new location without having to first zap it. At
> the time there was also an .invalidate_page() callback; both of them were
> *not* bracketed by calls to mmu_notifier_invalidate_range_{start,end}(),
> and .invalidate_page() also doubled as a fallback implementation of
> .change_pte().
> 
> Later on, however, both callbacks were changed to occur within an
> invalidate_range_start/end() block.
> 
> In the case of .change_pte(), commit 6bdb913f0a70 ("mm: wrap calls to
> set_pte_at_notify with invalidate_range_start and invalidate_range_end",
> 2012-10-09) did so to remove the fallback from .invalidate_page() to
> .change_pte() and allow sleepable .invalidate_page() hooks.
> 
> This however made KVM's usage of the .change_pte() callback completely
> moot, because KVM unmaps the sPTEs during .invalidate_range_start()
> and therefore .change_pte() has no hope of finding a sPTE to change.
> Drop the generic KVM code that dispatches to kvm_set_spte_gfn(), as
> well as all the architecture specific implementations.

Paolo,

I may miss a bunch of details here (as I still remember some change_pte
patches previously on the list..), however not sure whether we considered
enable it?  Asked because I remember Andrea used to have a custom tree
maintaining that part:

https://github.com/aagit/aa/commit/c761078df7a77d13ddfaeebe56a0f4bc128b1968

Maybe it can't be enabled for some reason that I overlooked in the current
tree, or we just decided to not to?

Thanks,

-- 
Peter Xu


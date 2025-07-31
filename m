Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D976629CB32
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 08:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753950862; cv=none; b=pnxvVCiZPYMRHdDuoryNQx4LCJ3ogeVyNVAw7+7FAbDc/7gv+dRYQ2+JHavP8OoCr/+hmWi1rZILMIdT5grD4Nxe6r1F0BRClkawAB1S+TzWwgzD+EF7pSJEAsoagaUai77l1H10gZJhH6TROhmJyWuemHRVohn1fe1TV0/j8P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753950862; c=relaxed/simple;
	bh=eiNYedotPctc6xPTtf1N6xVN29fIlNTNoGPInQPwrIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KOy7KTx7yXlDVyLJiKi2rPNayYxar73wbYtSgP69c8Eq465mFfbGbSaYwNtXP2YBGSdJSl8fGDkdGor55sG51sWPWjun2KJcDqEvVk0SzHOnWHAxv/EiLpWH+Fvj2FxhFV9r+qEtKXOkvia+AaorL91YTjkrDwnc4KBQVSOhxlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B6jFkNMP; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B6jFkNMP"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4aef56cea5bso67441cf.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 01:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753950860; x=1754555660; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eiNYedotPctc6xPTtf1N6xVN29fIlNTNoGPInQPwrIg=;
        b=B6jFkNMPnCkIRitGTUSdyQGyWRqQWBoe2Mdk9IgmqC+/SDIylaFlpsrqrgkPFuPOp8
         R2AG2UtboXC+n54sAJK7BaJR1nRnymEp0mB3V5Xb5cpXMKznr6Nxrpq0lsYN8aum06fz
         Ak0HLYkydcQqXM5dCt4QJ9hUmhOgvLAnhWKkFsBnft8Xx2tNl7gb6Me5EebJubwfWm08
         KSb4KLLYolLFfBIAAVrgLqouM8C2SQjucKnhQUu9hKdvwFO4kyjDDQP/hUOVi7d2+sY/
         PkXksG1obObriSMaqIlauhq1p4CserhUJ86Ln3GXEJV2vc+hvkrA5Oz/RPMROQoMapFn
         U+Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753950860; x=1754555660;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eiNYedotPctc6xPTtf1N6xVN29fIlNTNoGPInQPwrIg=;
        b=qFcszUR4uifDjQtliLuAZBg6oNxAHcHJAD/lNWDo964bfRH5uVSkmE+EtbAtIe8efO
         WjCKE9uUezMMxjoRmPHd6MeBXRjlaODgymzQQ+ryUHur50fQ+BVhlZC63DzQd+JtSFDK
         iNUgFb3IvPz9MfKeVg7M/W6Jt4mdW+8fuCRSdOQL1GWHw/HS6/Ydiqk+Tlx67czWxgXy
         Wa6FJ+cy3R9nJWwWUlXq25buDN2PtBicx5f5g0DSQS5TuKLIOA6O2pLrRsrJsNO/R/AO
         hFpMt5LV+GNlvzy7KUpDOnm8UJSkuYjPxQu1FkoCsWB9WFrMs7Z3B6xiO3NjgdZDZ804
         bSdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtuzGknkvlEEq8au1ok5KXW2cRHHWc5iARv+WGU4WKsJpyNFL44lLtGQj5ApsuDK/q6nU9dco=@lists.linux.dev
X-Gm-Message-State: AOJu0YxD1zGlfMKV5VcyavBZJjix3FmhfHlmXkPbyxvJhe1EU2Sy7j+w
	1hzx0Ivgwg4bY4m4kQmBcdUWKiSVVTv0hvqqEPl6c9QSeI5UAy3OcolQM9sU6+oxZVerMp8d/G1
	GcICDJsmNOiMtnLMkEu2LMfhL3tuRK3X3QzPea5ac
X-Gm-Gg: ASbGncunR1WBZgZmIhIklnievohLBwolzVWXw2MNEJdFkKKh6kU0Lvqw91h/AtSE0La
	YPool2pZxJ42ISN5jtWOm4G+awZ8ePnt1Za5NCCqy1J/cYtQp9IzNHf7KR+sqwNnUSru0fAkX8n
	gnmlK9hwc9/pPXedJkIW296a1dKT34DawtvOXW+IhLiPppzjyQtviTjO21SEvH69NED1k33yCJc
	ci7DNS2lu+3brxU+Q==
X-Google-Smtp-Source: AGHT+IHWSj7+ppidqQQ7crIyrSg2wcIE/rWj46ZOv/ucXGZB3xZ7fB2xhdup8ZybMJXt3sd69EoqALJyiMp0TePdZrs=
X-Received: by 2002:a05:622a:9:b0:4a7:e3b:50be with SMTP id
 d75a77b69052e-4aeeff8952dmr2421461cf.16.1753950859428; Thu, 31 Jul 2025
 01:34:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-13-seanjc@google.com>
 <CA+EHjTwuXT_wcDAOwwKP+yBetE9N46QMb+hUKAOsxBVkkOgCTw@mail.gmail.com> <c320b7a3-bf75-4f9e-bd72-4290fd9fe9d9@redhat.com>
In-Reply-To: <c320b7a3-bf75-4f9e-bd72-4290fd9fe9d9@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:33:42 +0100
X-Gm-Features: Ac12FXzoE81EGQG0C5ZbrL6pv7Gwfmxe6c2Z4n5qEJHhSLSLb8R4m4jCH0y1OFY
Message-ID: <CA+EHjTx8KiDS+WcB9gpWaKtmEaC40gdE1ZDaMJydHfMJLVLbwA@mail.gmail.com>
Subject: Re: [PATCH v17 12/24] KVM: x86/mmu: Rename .private_max_mapping_level()
 to .gmem_max_mapping_level()
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Tao Chan <chentao@kylinos.cn>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 31 Jul 2025 at 09:29, David Hildenbrand <david@redhat.com> wrote:
>
> On 31.07.25 10:15, Fuad Tabba wrote:
> > On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
> >>
> >> From: Ackerley Tng <ackerleytng@google.com>
> >>
> >> Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
> >> in anticipation of extending guest_memfd support to non-private memory.
> >>
> >> No functional change intended.
> >>
> >> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >> Acked-by: David Hildenbrand <david@redhat.com>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> Signed-off-by: Fuad Tabba <tabba@google.com>
> >> Co-developed-by: Sean Christopherson <seanjc@google.com>
> >> Signed-off-by: Sean Christopherson <seanjc@google.com>
> >> ---
> >
> > nit: remove my "Signed-off-by", since I'm not a co-developer, and instead:
>
> The patch went "through your hands", right? In that case, a SOB is the
> right thing to do.
>
> "The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch, or that he/she was in the patch's delivery path."

I see. I thought it only applied to the current re-spin.

In that case, sorry for the noise! :)

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

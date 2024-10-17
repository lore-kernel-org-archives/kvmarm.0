Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD94B1DF97B
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729186826; cv=none; b=e/+9SukneA6rtP7ET7aitPe709R10BOjqiKJPPQs7/Yy9zH6DbK0TmnwNHB9hAOMb87FwDpC2q6VBEJPFtxeZabYdwwx333dWuaHRkVV2A3FYkUHHY1tPZ+WZ/mbCw1fHRw96AxCDmhslFoZOdTwpHHvufBDK59DGme5bV60AxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729186826; c=relaxed/simple;
	bh=dLn9d36dm2CDpdmYI4TuowHAHoMiQT1DP6ItK2LTOeo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=paetv5JUje0lwdFiUVuYdaqsTVNL2rIlf36sC96q0zyCKxfq0MHjvZ+loSdHacWdfONdvuFNUdUU1EjV3ZXm4JtnhjrEQbOLj0dIX9OK4pw4UH1LjC3j58XIVVzD9gKtSbHlgDNqei2af4baW64nr0IsyXCY1FKmdsoSYUL2xDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I1g8OwGq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I1g8OwGq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729186821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Me+6kqYD5L+igZgkevVfUHfhQZBz6G5zZyQw2Dfa0gs=;
	b=I1g8OwGqf6YirsjBBkqseZgg1vdODMPIu+txknTOu90dE87mkadJ0leCnEZmkyJD6SiFvP
	3kZBr2r4wAbg+suF8N49TnxFKMXs3dgD9fZvIzvSMuIXxaGl1TNcVJ9RiMhLGCKCcp/dH3
	W4AHH9tLO7dMBUnybRsN7idNViSWn5s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-0LvXhe7jN4mO0PH-VhNMRg-1; Thu, 17 Oct 2024 13:40:18 -0400
X-MC-Unique: 0LvXhe7jN4mO0PH-VhNMRg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4315f48bd70so2034365e9.2
        for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 10:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729186817; x=1729791617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Me+6kqYD5L+igZgkevVfUHfhQZBz6G5zZyQw2Dfa0gs=;
        b=GG+jlCWNG6VDUb7ic/5Ks5BNnJgAI7n6l54vQhonJ+4Vr63+3fzx2Ugt95MW/dsSqX
         RSyWSX4nI9aVSYi7xdlRGOWGE8+QugZiAsCkH3YJ3J6y/wMjEmjk3QbvjWBRtFPppWNo
         RtoyhDkZtt9+iJBRGvwoqc1E5yoAYSRtrR7tIk0OhMTL1VdQaSmwfzeyvPLDdYNa0zi/
         WOTPOPuHvO4u6L+PQI94d2Jr66inLWN42td7ZLcMR5MHW6JBk8OSWhiOAk3cxUJYkZbD
         cpm29IymUz4d7mJFLTrMWLesKx2hj3BnnarJyfIH8FOSuRoTugvCA4y3ala9AtAWv9Iv
         aevQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlHgoVgGSXTIViykFAfIniWqyVXjS76cgIuYlzP1D0rX6ATXzty+8y3a//wEHiMRVN2kulKJ8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWB3p9nmk1vILjBvXECOSD7EMccepcYeSOgSTOI+9E2NoK64Vg
	N+TXKQQCSsj1tpMlzjpHuMJl+oZSNSRfza7/32+tYdXhsZ6UFSNjdjveAXFBGumWdq+4x+EStab
	JIagBnAfIPnKAFtOW5ER3H+hcvV71QEU6nP+q9z45n1Qde75ZgfqMNyPFASUnA5IQdZ27j27bH4
	eOSqyTxiam1g7voWy6rDBVAT5DPXGN
X-Received: by 2002:a05:600c:1d8e:b0:431:57d2:d7b4 with SMTP id 5b1f17b1804b1-43157d2d7b9mr36506995e9.26.1729186817333;
        Thu, 17 Oct 2024 10:40:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJXjIUBFBzWhc81QoCH/SVoEivw8XmjKVFXrcy86zA+s4Bvx/9zH7hnQ9Z4/zbRof1LT4xgUF82luj5UeBHDI=
X-Received: by 2002:a05:600c:1d8e:b0:431:57d2:d7b4 with SMTP id
 5b1f17b1804b1-43157d2d7b9mr36506735e9.26.1729186816975; Thu, 17 Oct 2024
 10:40:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 17 Oct 2024 19:40:04 +0200
Message-ID: <CABgObfbQW-3vp=mNcR4giUGZ_gxhuRykvKj8gzBDY7pOg6xdBQ@mail.gmail.com>
Subject: Re: [PATCH v13 00/85] KVM: Stop grabbing references to PFNMAP'd pages
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Yan Zhao <yan.y.zhao@intel.com>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Andrew Jones <ajones@ventanamicro.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 8:24=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> v13:
>  - Rebased onto v6.12-rc2
>  - Collect reviews. [Alex and others]
>  - Fix a transient bug in arm64 and RISC-V where KVM would leak a page
>    refcount. [Oliver]
>  - Fix a dangling comment. [Alex]
>  - Drop kvm_lookup_pfn(), as the x86 that "needed" it was stupid and is (=
was?)
>    eliminated in v6.12.
>  - Drop check_user_page_hwpoison(). [Paolo]
>  - Drop the arm64 MTE fixes that went into 6.12.
>  - Slightly redo the guest_memfd interaction to account for 6.12 changes.

Here is my own summary of the changes:

patches removed from v12:
01/02 - already upstream
09 - moved to separate A/D series [1]
34 - not needed due to new patch 36
35 - gone after 620525739521376a65a690df899e1596d56791f8

patches added or substantially changed in v13:
05/06/07 - new, suggested by Yan Zhao
08 - code was folded from mmu_spte_age into kvm_rmap_age_gfn_range
14 - new, suggested by me in reply to 84/84 (yuck)
15 - new, suggested by me in reply to 84/84
19 - somewhat rewritten for new follow_pfnmap API
27 - smaller changes due to new follow_pfnmap API
36 - rewritten, suggested by me
45 - new, cleanup
46 - much simplified due to new patch 45

Looks good to me, thanks and congratulations!! Should we merge it in
kvm/next asap?

Paolo

[1] https://patchew.org/linux/20241011021051.1557902-1-seanjc@google.com/20=
241011021051.1557902-5-seanjc@google.com/


Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE413E3DAF
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 17:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731378; cv=none; b=nliBEbZy5D6JO/V/Zx+wzWQcYe4fr3vOqTYXaf43TtTVKr53gSWBG21yfc4abfQ4EAvKZBthGpSDKG3G9pxRuQGztaz1hdyKyNBM6mZgMRzQaW9v4XAQb/W5J8KsE4JRaoc1kIBDwQuxwWJXqLkKuUhfGEwFMCdqTWXKh8FsnKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731378; c=relaxed/simple;
	bh=44nrwl9MtsM8nG2wYpqGAWFgiMCuaPB9R7DRYfG94no=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l7xsqwbGzV3/6PRhftl6rWHii/a/6QnS6MtJytp09xgh6SFGJ0lh0emmr1p9F8p706Wq42wpeL0pvllWHFGF0oXU2cH0U7xss6A3LFpmW6O6QMSmOGn36heSKCkDmi6o7jb+/GKIpTiFFy8cImT237aAStqeqDvhgKYjYdIeB9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q3F5Sj9X; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q3F5Sj9X"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4af66f40so55984755ad.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 09:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772731376; x=1773336176; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p1wGeuRJ/eZ0ds4iRA1USsFNUrpQJYzw8H7jxKUj2JY=;
        b=Q3F5Sj9Xnql/2WoPcpifQUQpuhRoTtFTRqAb45tRqS5AHAqIm8cqLZU9PjUtE3vYXT
         DxLWehh3ENAiATU1KFV8jM2BGCM1t+BQd9Sn/Jt9XCx2cuY+I0nrlz0EwnQTnV5nkNu3
         afCH+o5ic76H/6BMvFJPjxNDIJQu6teJ1g2CtKq/m9ISOqAok28rHlTBWOhOMpiuS7Iy
         2vUaR4bRUK6MdICRCU3+GHCryAa2mhyt4BJPxeqqWLQM7h15dDUiHqS0pLLvzGgC24OV
         c+gW/AFgZ0WBxBRSSIts4DPYN1Bs+0O8na/kxc0olIWjRpbGjSKjKMzGPpY6D8xAYYfZ
         TS6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772731376; x=1773336176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p1wGeuRJ/eZ0ds4iRA1USsFNUrpQJYzw8H7jxKUj2JY=;
        b=k7DWIXh27T9PAujwF81go3FnXMMKkcxHC14q7yfqVpqQmID8Soiz4b3oBz3rdRZr+m
         WGr+WgEAFaLnsHD5v7tou6d1Py1YOUdKderK1WI3CVhd/IYfT4oTLSDim9UAo+gGspBJ
         t5je5sDb254hoh5sH27183g01TOzYDawP3HZcKxiSzmtVbls+vSt1WxXJxGWGqv1Gsq9
         rDqFg+/K8ktQ/97JCGSPHjk8ASP+LzWX+ZXJ96DW8ZQl0bq66QvEwmX0GWzJwjgcnjep
         i/SSu1UNQ2G7LTlTp3znz6fMkrQEI7o32Ty7DRGjsrSQS4i6is8rrI0d7KNOX65XrXxP
         ISwA==
X-Forwarded-Encrypted: i=1; AJvYcCXZH+DZci4Vy2tf7WvR5Y5Y4YoTMFfzwa84p0saJ7dnrC88REmQyFYDU95wYXnn4T1hsiOX0fU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yypm5r9JKjW8Yu+cSiljs7WiMIsxV670A9IettirIz8MFLCUtrx
	8rfvPn9+KdN1lhQQRFvsqC2Pmt9vNWNVO13wGdOayFikKOy9u4O2ESmOwn13ySkX4qFnUtPs6Du
	62FIKHA==
X-Received: from pgbda4.prod.google.com ([2002:a05:6a02:2384:b0:c73:7810:6005])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:166e:b0:2ae:7efa:b2ee
 with SMTP id d9443c01a7336-2ae7efab422mr8334235ad.45.1772731376023; Thu, 05
 Mar 2026 09:22:56 -0800 (PST)
Date: Thu, 5 Mar 2026 09:22:54 -0800
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
Message-ID: <aam77t8fe5RKSr2Q@google.com>
Subject: Re: [PATCH v2 00/10] KVM: selftests: Use kernel-style integer and
 g[vp]a_t types
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, Bibo Mao <maobibo@loongson.cn>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Colin Ian King <colin.i.king@gmail.com>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 20, 2026, David Matlack wrote:
> This series renames types across all KVM selftests to more align with
> types used in the kernel:
> 
>   vm_vaddr_t -> gva_t
>   vm_paddr_t -> gpa_t
> 
>   uint64_t -> u64
>   uint32_t -> u32
>   uint16_t -> u16
>   uint8_t  -> u8
> 
>   int64_t -> s64
>   int32_t -> s32
>   int16_t -> s16
>   int8_t  -> s8
> 
> The goal of this series is to make the KVM selftests code more concise
> (the new type names are shorter) and more similar to the kernel, since
> selftests are developed by kernel developers.
> 
> v2:
>  - Reapply the series on top of kvm/queue
> 
> v1: https://lore.kernel.org/kvm/20250501183304.2433192-1-dmatlack@google.com

Sorry, I was too slow and missed the window to get this into kvm/next without
causing a disaster of merge conflicts.

I don't think you need to send a v3 though.  I'll prep a v3, a branch, and send
Paolo a pull request during the next merge window.

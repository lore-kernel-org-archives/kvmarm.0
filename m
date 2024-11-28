Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC1013D8B0
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 08:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732783366; cv=none; b=HR7VYs/W2h9/ZGl35MINorcEdAaY4GLApDFZu5qDl8wfA62o+s5VHLHB5BUhex0oa71DdZdxG7yuW62L5vbrWszpxMxYX7tEKi2TZhTY+2rnzDduT7k20xxU+8YBfiSptoQbexCNk1XLIJID05kyeNN5IKOHgi0I2/Vqb1OhdPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732783366; c=relaxed/simple;
	bh=7ZZDaAfSE8cvMEwpoEXTL1xwZPoGe7nBEVbFQ7QIRF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TclxctX5SsXBAjMDBr8HmNPaiM8dbX7DE7NY0pH45oIq92ELXbxMEGxjJ7CWnIAMvoWmYr9rcxb0feHhnHbSGoHboF53dvXRkG8La1ezkhobIoXtgQVw7b8P9hUAy3PncN6elU+f5BDqBTXHGQns0F6m/QXZUycnj+js0uOyLfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=c2r04KDI; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="c2r04KDI"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5cfc035649bso671574a12.2
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732783363; x=1733388163; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pqNO4mcpLsB6nl6y5oYnZ+p9PNe/HBxDvPKQfTS22pA=;
        b=c2r04KDI6Da9+TLZXJQGw+g5rHX/Y3Sh/+8apwrBtFTQJBj5UVtuEoUY+5M2MewvZO
         ZfIy2lkFnUrlAtHK2DWiMFbv8PbLMUMi1xlY+fSrgoGniTfxHOKbcfXMSXEDeJif/4e1
         VTd1CwLRheFpVfD8pip4pWMSv+KD7ZHIfwG5ZclP7T5R3LVNwWIDgm/pLBBKVqDh6JE4
         aW94MCQxdafd0na5XLm/wXEzEjoQQa0dWpuEl/C17xy4V1mXEGo6UAs80REEexFHFkFF
         09cft55n5fx6amQFsM5S9SkJhHx/JSgV1plbYetcpoySTKXB2xuMrO5i5KJeZIEGskkF
         2R0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732783363; x=1733388163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqNO4mcpLsB6nl6y5oYnZ+p9PNe/HBxDvPKQfTS22pA=;
        b=Ad+Qhy1jCjgL0o/u2iAwcp20inRY3YkCSvfOTipQkAgdxDWSqB6tZegzDmDhAUhr3L
         Jlo6aCXobOIRJyUZOKRsSW+V4O9SZ/PlAyWb0R5T3T6MwxPPX65drpA3xS7CB+JAGqkA
         T9Pazbjy1iQEjnes/ZH/hubRD7ZHc3RRS9Pcxcih8vfR3Hn8TCs/h78RuP59lVnYzZ57
         jXyAjzh6938DH+lyArqpZneOb7z9LgD38nZBaCMNZExUpE2CxeRqooh1uij/XF6MZ8Nf
         Nkl8SuortjIpMklAIkIVRfu0wZ9eXaC//aBunC/+GtC42DmU994tFYNBlGu8y9c9nA2r
         hK8A==
X-Forwarded-Encrypted: i=1; AJvYcCVImy7/rhRfsQB5mTOuFaK68Ki2zizyDrIqd9MVmbzDyEgSPbJb3312LMGT1o8e7tz9tW7wL0E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyx5lzYeB/RTEU4VN5Fk7VWgaUS2k0cxf3GpJWBGrn5b9atq8hD
	PA4gRqPczr7PUZj5Dw/phEpCqO4dAF5t4dPWZyWedMMLzJLFQKcCdM4T1NKZT5U=
X-Gm-Gg: ASbGncsNOJ90WaWZQb4ID5BWh3zW2b3pMAEU/2IlcaLdRe7U3EBVT/niLAfRJjaJ+8O
	Mwb79bUkJBXFkJJ/QEv+OfHS20yxwDBgkDz9koyzoMCM3xprEn6Da2RcGzNv0Bs5WzbNfiqLeia
	Ok3QrpP7m4ZZqFOzLcRD4ixQlGiat1XoIWSAuVc6zxv4jv255jMTcNsYPgwCo2rjY5o2YDlPGFO
	Ln1/jiWPbKtrZzAYBPx0r66jqoxVxVZ+0SA0C7BvOoxNG4zgA3pyDZRthOHDXQojknXfl+T1EFh
	Fv8ttUkQ6CYVWDjEITi0x/VV9mxKGG+xUJA=
X-Google-Smtp-Source: AGHT+IEtMpQZWj4endJlLK3Ilr+mbQxtLK9EL+/Wn1Pn2YYjrHxtBwEvTjmbyjJN4oWe/ENTW6ynRg==
X-Received: by 2002:a17:907:688f:b0:aa5:d1c:3dac with SMTP id a640c23a62f3a-aa580fdd57emr475064966b.36.1732783362949;
        Thu, 28 Nov 2024 00:42:42 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5997ffc1bsm41610466b.83.2024.11.28.00.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 00:42:42 -0800 (PST)
Date: Thu, 28 Nov 2024 09:42:41 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>, Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [PATCH v4 14/16] KVM: selftests: Provide empty 'all' and 'clean'
 targets for unsupported ARCHs
Message-ID: <20241128-24a975e227dd4b86393f21ed@orel>
References: <20241128005547.4077116-1-seanjc@google.com>
 <20241128005547.4077116-15-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128005547.4077116-15-seanjc@google.com>

On Wed, Nov 27, 2024 at 04:55:45PM -0800, Sean Christopherson wrote:
> Provide empty targets for KVM selftests if the target architecture is
> unsupported to make it obvious which architectures are supported, and so
> that various side effects don't fail and/or do weird things, e.g. as is,
> "mkdir -p $(sort $(dir $(TEST_GEN_PROGS)))" fails due to a missing operand,
> and conversely, "$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) ..." will
> create an empty, useless directory for the unsupported architecture.
> 
> Move the guts of the Makefile to Makefile.kvm so that it's easier to see
> that the if-statement effectively guards all of KVM selftests.
> 
> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore   |   1 +
>  tools/testing/selftests/kvm/Makefile     | 336 +----------------------
>  tools/testing/selftests/kvm/Makefile.kvm | 334 ++++++++++++++++++++++
>  3 files changed, 340 insertions(+), 331 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/Makefile.kvm
>

Acked-by: Andrew Jones <ajones@ventanamicro.com>

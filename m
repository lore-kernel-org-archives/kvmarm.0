Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5181D5AC6
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 22:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734388408; cv=none; b=ByeU38f7pWU3vvFRLLTmiTNjwLj0grAaTR7+LdfYUEmhrQDdZVvABgFG01Q7mZu9m2UP5b84dbztTpnhxYmTflFfCtnwAKqO01QPEBxn+6Jadubb/WRzarOQOxezSIQtg0x5geBbevme66zDd+B+hdKLTABtgyc0+jjc+d1xSy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734388408; c=relaxed/simple;
	bh=AQ6L0FE4N7ae+Cg2Eu7wbgOie9mHJiVhQr34moiqfqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=RVBr1YMstbHizWKDqlM28A9i/DGildA+WpkE3jw0GK7r4ZU0d4So8iP6wA/H6Qzc2xAahlVfQ25X7NBQSbUolXh5K7HEQclx7MwI/yWO/Ny4/9+IECTEKrjPQXaKsSRJrYQd3yTTCQWHLKy6mDlrCGjz7/ufmTOZW3X6/QrOKm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BaR+m4J2; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BaR+m4J2"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7fd312feb10so2856484a12.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 14:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734388406; x=1734993206; darn=lists.linux.dev;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9jJCzoGzQp+cdjga58qGUwc3ffJR9vhNALvR1f7QLKI=;
        b=BaR+m4J2/9XWPlTD0NWD2Q83yqmV2i8VKeMZlpvjLfBQQopZNeaCQI+d/fHoMn/nYg
         8uyUaa3O40njUMKwZlND2hdxHcbohKoyiBjFHz9d/JPyC6ff0sreYX9YkyBiwT21tcqy
         9f5MneM+OKbFR0sz28VoscqDdQbWyEiDk87UAVBOsapS9Ds+q0EhMT48otealOiIR55B
         MPiP+DeQebE/ayTmEHfezl02rHzWgZ2dzybzbx4YbEJd5o3J38nzFsIWlWw0pupBMVRw
         1XdHYN3CdLJYn+iEn515gigVAOiWC6GBAnr+Danju5IUhZWcfwOYMk98I1ZNGvuxNeSt
         zbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734388406; x=1734993206;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9jJCzoGzQp+cdjga58qGUwc3ffJR9vhNALvR1f7QLKI=;
        b=tmu4h0mvRfY9LSX5tqbpUsxFGCb7hkZosBvWKfwdbnJ53Xc4SmlNBjXQCeRE5bdJ0C
         UF/GLYvZmyBuGNKIG/objRNFEbj/7OWayG8I0FvBND6SovyO+4oAGpdtodHrUVgkUDgA
         atNE3phXwF06zCgeEV29jcXUK8gEGZLG1aignNELUu+JVRX+F/BlAPB9kUCqWamNYsPG
         DO5yFiz1gPI0pkVDMNUV5CcZ4ePXvcseYi8rUW2J73h4KbXZHEW9KZhTDDDmhgY+FLQI
         +PZEPs+I2+6TJP+UbGYUcnX1XOGBNrpl/bmhVdsUQHb0RNGzJSAzFxnG839wWNPFKkuK
         FM1A==
X-Forwarded-Encrypted: i=1; AJvYcCUNZa5ydMVcGDldIT9ROAO6W9wToLv9RgUotlAWa0qjjPIo46meGdUIX6NLI8pPC34hPuVQr20=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6D83YfuyGePOJbigSxquOv1QvZ4HVK8hW34X+ZJ3A6ZyrIqrU
	iAaQxB1oYi/PTFsHpUCWwHZszp4rpGVHqzdYlCnw+cqKBJAxCyTFkGkoCYVTXSlhR/tGihRplh5
	vWw==
X-Google-Smtp-Source: AGHT+IHhtWHdid0XDbI59B1aoA+CN7rFIH/zmVAk3APPQqAwY7oJZB6TaL0aH/5JThWes+dWQrGdtB7EGl0=
X-Received: from pjd5.prod.google.com ([2002:a17:90b:54c5:b0:2ef:8eb8:e4eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c887:b0:2ee:6e22:bfd0
 with SMTP id 98e67ed59e1d1-2f2d7eece80mr1530327a91.21.1734388406334; Mon, 16
 Dec 2024 14:33:26 -0800 (PST)
Date: Mon, 16 Dec 2024 14:33:24 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
Message-ID: <Z2CqtL1R0-368hO-@google.com>
Subject: Re: [PATCH v4 00/16] KVM: selftests: "tree" wide overhauls
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 27, 2024, Sean Christopherson wrote:
> Two separate series (mmu_stress_test[1] and $ARCH[2]), posted as one to
> avoid unpleasant conflicts, and because I hope to land both in kvm/next
> shortly after 6.12-rc1 since they impact all of KVM selftests.
> 
> mmu_stress_test
> ---------------
> Convert the max_guest_memory_test into a more generic mmu_stress_test.
> The basic gist of the "conversion" is to have the test do mprotect() on
> guest memory while vCPUs are accessing said memory, e.g. to verify KVM
> and mmu_notifiers are working as intended.
> 
> The original plan was that patch 3 would be a single patch, but things
> snowballed in order to rework vcpu_get_reg() to return a value instead
> of using an out-param.  Having to define a variable just to bump the
> program counter on arm64 annoyed me.
> 
> $ARCH
> -----
> Play nice with treewrite builds of unsupported architectures, e.g. arm
> (32-bit), as KVM selftests' Makefile doesn't do anything to ensure the
> target architecture is actually one KVM selftests supports.
> 
> The last two patches are opportunistic changes (since the above Makefile
> change will generate conflicts everywhere) to switch to using $(ARCH)
> instead of the target triple for arch specific directories, e.g. arm64
> instead of aarch64, mainly so as not to be different from the rest of
> the kernel.

Paolo,

Unless you or someone else have concerns, can you apply this to kvm/next sooner
than later?  I'd like to start applying selftests changes for 6.14 and don't want
generate conflicts, and I really don't want to have to rebase and push this series
out again.

Thanks!

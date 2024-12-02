Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4A970800
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733165271; cv=none; b=XASlFV9OIApZ7lkMxYTFXGtsxRoB6+YYvB/QFB15DbgQEnOepkSbbLiu64U7Saw4STSHhM/lv14GHx8O1YFlK/XjwV7UqmgUPT/XitgMQiMRfDYOp1OHHGfbMtsH6bSdgAbFlTXNm7s+sE/4uPBsA6kopwmP9G72X5rNYVqIP5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733165271; c=relaxed/simple;
	bh=/WDv/GV0NhSrxZ0Vl7TJjeNE20slEbisRuFwg3yb7uM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LjnrO5WSilg9HtNq+80+8QjX/S/2hzbUsQbtOb93MA8WxnDHHZbjSP+iT12+2e6xGcN1E4mrZZONzXFuBfjcJD7QB0yo7mTh/86hdl9XYFBIle/FxTr/XXtS4Ias5CbA3ND5S4CBOvlTdCcpiQBYwevcDlf9NeSzcJC6DilSSGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SSzJ2gkH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SSzJ2gkH"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso2298992a91.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 10:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733165270; x=1733770070; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u34wPynLWdSa99IQ6xhu/7M3+TIv2HNu87ct2rQpiWw=;
        b=SSzJ2gkH4Urc+pnhxMqbyNMThj6aja6mJDvzY0IM2D2VCoK0gv9AU4LkbBWfiDhlLj
         gNSD0+KafpPiaxTWCkEehcu3ViiPFZRoP8Fur5srE1WA2504I4lgsCmvx6gCZT/nVgwO
         mCCLcFj7a6fVA9q7GlrchULFBVlB2HeQ597gJ0jAchkBHGfkZHEOk097EgrJcFt9uy6C
         IP+0m32ynZLRtRKX7iUPUn+lehuZV1zQxT2rgSu6Ra0ZyiqAReSnUYxy0TJ3SieAVFip
         tS7YTbt5Z3v5VFPki3EnJr8myMDPT+g3oqM5YR5sKoXAGaMUeryt/v6b1TjsptW8jOkx
         opWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733165270; x=1733770070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u34wPynLWdSa99IQ6xhu/7M3+TIv2HNu87ct2rQpiWw=;
        b=i43mJhYScP09Gyku3QKcozWmyzCQiTK2F+hW3H08NPI5Es2T6BTzVoqyYNvSQFz22e
         oasL8GBvhkFjB+PXhKud/euvrApn8bMzdxRttDZMFjS0nt0p1G+Jg130JHeF/a9QP+/s
         Yk5t0w6YD3dUBJxzdm+Xiqry5FJvo5fvVJzRYBvLRT9SJTE+UBAOnH/mi8HAcYMLMwvg
         N5A09PW+xb4cAAhzCX8QggHIPe7DfGMBUGv+Nwuq2rQVJ8ErvPI5Ijo8Dd2Mc3ztX5xu
         Lh6bxN7oYXUaBU9TSO54959IUf+oXYCtevavKXOvMp5nMfyiRBNRelsPy0TS9iYo7F6i
         i9fw==
X-Forwarded-Encrypted: i=1; AJvYcCVYkB2Fon4li5qTya8Ea3kmuxa0q2gmQNxwOAp3ZoNjXa0R2KT3eW3Cwr4qu9Dzx4vsbMlhF3s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2J/cBkUNxsN1C7TKqtNFIax4lWnt6xv0ik5LXZLKig4X4dBdZ
	aidDNbplLJc71+BQzzBNSlEPRzjZoqZVBl6Ckm//p6HR1SnVgd2hD1/0GcMYx73s48nJ1NZ+GER
	CYg==
X-Google-Smtp-Source: AGHT+IH1lOkxtOKe5VZ1YQsUZ2R4iUJCkzIbDFJGQzaxTbOPx9DRSSWOWSynHC4tj/4TdwIvmt3yGcRJFdA=
X-Received: from pjbsv8.prod.google.com ([2002:a17:90b:5388:b0:2ea:6aa8:c4ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd2:b0:2ee:c5ea:bd91
 with SMTP id 98e67ed59e1d1-2eec5eabed1mr7923335a91.29.1733165269950; Mon, 02
 Dec 2024 10:47:49 -0800 (PST)
Date: Mon, 2 Dec 2024 10:47:48 -0800
In-Reply-To: <20241128092546.7a5b3f30@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com> <20241128005547.4077116-16-seanjc@google.com>
 <20241128092546.7a5b3f30@p-imbrenda>
Message-ID: <Z04A1Oh0LCKtCN4p@google.com>
Subject: Re: [PATCH v4 15/16] KVM: selftests: Use canonical $(ARCH) paths for
 KVM selftests directories
From: Sean Christopherson <seanjc@google.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 28, 2024, Claudio Imbrenda wrote:
> On Wed, 27 Nov 2024 16:55:46 -0800
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
> > similarity index 94%
> > rename from tools/testing/selftests/kvm/include/x86_64/svm_util.h
> > rename to tools/testing/selftests/kvm/include/x86/svm_util.h
> > index 044f0f872ba9..b74c6dcddcbd 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> > +++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
> > @@ -1,8 +1,5 @@
> >  /* SPDX-License-Identifier: GPL-2.0-only */
> >  /*
> > - * tools/testing/selftests/kvm/include/x86_64/svm_utils.h
> 
> this line clearly has to go ^
> 
> > - * Header for nested SVM testing
> 
> but I think this one can stay? ^

It should go too, the header contains declarations for helpers that having nothing
to do with nested SVM.

On a somewhat related topic, the file should probably be "svm.h", but that's a
future cleanup.

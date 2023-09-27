Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8E923742
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 12:40:48 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-405417465aaso101049285e9.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 05:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695818446; x=1696423246; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zXUOi+JREodzQHSQ402wcT88ukT7b7/9+gTGSenR88w=;
        b=bfjPO20sZLBgL8ht04i1mgsaSVx4vAesaC0M7M3luMsFjXzWga5Y5pFfKMuwYqZVss
         YAMdDm9V3wQXH8f6Y/6Z0BU5jPd1rIgnq7SHE3gQddjYNfnp8K1xsT18DUbIj/mzbjbp
         6RENXgl8Wn8OMOiiDhCOIL/vhNW8Usjw98njWTD6/WU4c5VFssQT8Rjbz/kEX+Sbancq
         H1AShIFDfAM0TrNhAkPIRcUoKPWVa6qwesqNcewF4nCZXQjsUApUvJCmYxCJEOxjXfun
         o86ZhQvJj2xrYuNRh/R6jBbGI2jQ0fnOTpTdt79yMjhYWM9zflj25iSqwhIsZWXlxm/x
         c4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695818446; x=1696423246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zXUOi+JREodzQHSQ402wcT88ukT7b7/9+gTGSenR88w=;
        b=Tj3QHQ6tePEzLZvkx2NoAZg+1JLc5xBXpyXI2/Ddltw9dY3HEV/671NO2oamfLvZVO
         Sd1xxF1Acc+g1MX0eZDJGs1objwp1m0/7TxTNdZX4uUMbb2NEUANIPUt3jrDG6JYYuMg
         mrG8WTWvtDVbHdeJtimsp+qAlumM4k/AOAZ55avx7pKS2sxzkUTuiNVKCWqSZM/4Celo
         AI+CWS/y9SMaf2RdBJuEq+7D2m5juaU8Cpe2LJ87CPx8CwX0NAyn/Lg9L7THhYbJJTyU
         MIeyMgF7m5tT18NJTrdtawGlN83XZ606S+k4YtqkP3szAU1hBgXkiuUVqwr7nd/gCHsx
         op4A==
X-Gm-Message-State: AOJu0Yyq2fxv/NA3zRhTSwc8IQYR8q0yK6jS+krZRwwAB8Ot1pcshjw/
	XN477V2JXhM0xCFYFagDKYXGRQ==
X-Google-Smtp-Source: AGHT+IHTiJfzH4R2S2zx3UycaTxvv70UewfXLJAgimn3+0N5yJ9BUcEJoD5bNo9nIy1/zyCbRvn2nA==
X-Received: by 2002:a05:600c:b52:b0:406:3fda:962c with SMTP id k18-20020a05600c0b5200b004063fda962cmr1734995wmr.31.1695818446474;
        Wed, 27 Sep 2023 05:40:46 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id j10-20020adfd20a000000b003142ea7a661sm10613871wrh.21.2023.09.27.05.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 05:40:46 -0700 (PDT)
Date: Wed, 27 Sep 2023 13:40:42 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
	will@kernel.org
Subject: Re: [PATCH v1 1/2] KVM: arm64: Do not transfer page refcount for THP
 adjustment
Message-ID: <ZRQiypIrEVFAo_3Y@google.com>
References: <20230926181932.1650692-1-vdonnefort@google.com>
 <20230926181932.1650692-2-vdonnefort@google.com>
 <ZRPTDJwcImUTHbm+@casper.infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRPTDJwcImUTHbm+@casper.infradead.org>

On Wed, Sep 27, 2023 at 08:00:28AM +0100, Matthew Wilcox wrote:
> On Tue, Sep 26, 2023 at 07:19:31PM +0100, Vincent Donnefort wrote:
> > With folios, GUP affects a refcount common to all pages forming the THP.
> > There is therefore no need to move the refcount from the tail to the
> > head page. Under the hood it decrements and increments
> > the same counter.
> 
> FYI, this isn't new to folios.  get_page() has _always_ operated on the
> head page of a compound page.  Here's how it worked in 2.6.12-rc2:
> 
> +static inline void get_page(struct page *page)
> +{
> +       if (unlikely(PageCompound(page)))
> +               page = (struct page *)page->private;
> +       atomic_inc(&page->_count);
> +}
> 
> I can't be bothered to switch over to the linux-fullhistory tree and
> show how it evolved, because i think this sufficiently makes the point --
> you can backport this patch as far as you like.

Thanks for having a look!

I'll refine that description in the next version.

> 
> Folios just make it obvious that this is what's going on.  And that's a
> good thing!  Making the MM less inscrutable is a win for everybody.

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D97C32793
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 15:32:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D3974D28B;
	Wed, 24 Aug 2022 11:32:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9COcPCCOhcmB; Wed, 24 Aug 2022 11:32:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A5274D281;
	Wed, 24 Aug 2022 11:32:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAA6E4D27C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 11:32:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZPR-puxyOvQ3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2022 11:32:12 -0400 (EDT)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD7754D277
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 11:32:12 -0400 (EDT)
Received: by mail-pg1-f177.google.com with SMTP id w13so10262161pgq.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 08:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=UZnSHBhLdMOKtTsvoHUMcnhpm7mRfzt47Yx1rwe6TYo=;
 b=ZLLZ1sQgjDCQZCR6iPbiV+dqJNVFlqF98MJZe+fMBspnKcQ1UNH5o3QOOx9DF7zBKA
 4NTZQU8BcU6LZoqrr74W5W2rChziUMwFRSTTGrC513hiwIJ39DS6AjzTbmueQdO2STE0
 t09KkGjDmYbiMqWw8kicU5n4mAAvwqsvfR4L8kRTE4YxLV1mXG0u1f2lpXeh4xy6gdFe
 Wv/tpw2JwZvjKVZthEj5z4x1vSTS+evVhLMdntp8ICLZ2wM3nwRTCYJP9MatbCfSirsX
 fcVMxPNOyrjAZQmeXvPefg+H+k8Jj7MzekfI//odudIng7UsH3Qp7cbIUqf69180zIUj
 AbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=UZnSHBhLdMOKtTsvoHUMcnhpm7mRfzt47Yx1rwe6TYo=;
 b=UlzKobW4D2RCkPw69wgkZDQciW6JsnuYFMBMrhFuXmmPCID/iVCKVGYBxVPOaaz2pH
 2uD2oqKuSM7G3IH58k0yEwFZp2udu0y6mZFQzC1oqEDPBO9HAB1N+Y8DWMNWVBbSZgtk
 CiqiUW3z3yzKmDtkGSSqP9cKlhxUJ0ghj2vuOjGXXzFQgRFLEaK8GHjTVZA6H88jWNXm
 S5zYsX1rN6gqyQZoEDAZXKhjwZYkWcDnrDRxmKOGdBKF2zPTIYsWkVi6ZSvbQkE9gSip
 V2b6idXmvwFATnVX+Z8DEm/9BazKFZ8wO2gnJ/nvjlC/O+WmOtiYh+Qp9fDi878lk4yr
 XH3w==
X-Gm-Message-State: ACgBeo0W171g3/TX4yLvg+UCVRqKOHSuSpAZiDgJiE42r72+3/NVDV6H
 DbzDGcA4GJbUAqQi0Zcl0RXCpw==
X-Google-Smtp-Source: AA6agR5QWDXsHQ6VWlCNVAAXtH2sA1tM24WXPqXY0c9+lwwnmRBfulv0M4b7+RjikXl1y2MhtN3W7Q==
X-Received: by 2002:a63:8343:0:b0:42b:3b1a:89f6 with SMTP id
 h64-20020a638343000000b0042b3b1a89f6mr859171pge.26.1661355131607; 
 Wed, 24 Aug 2022 08:32:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 d5-20020a17090ad3c500b001f53705ee92sm1567101pjw.6.2022.08.24.08.32.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 Aug 2022 08:32:11 -0700 (PDT)
Date: Wed, 24 Aug 2022 15:32:07 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v4 5/6] KVM: selftests: Make arm64's MMIO ucall multi-VM
 friendly
Message-ID: <YwZEdzHtWEfCpr7B@google.com>
References: <20220824032115.3563686-1-seanjc@google.com>
 <20220824032115.3563686-6-seanjc@google.com>
 <YwY9BYDUeiT87/Vs@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YwY9BYDUeiT87/Vs@google.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Tom Rix <trix@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 llvm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Peter Gonda <pgonda@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, Andrew Jones <andrew.jones@linux.dev>,
 linux-arm-kernel@lists.infradead.org,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Aug 24, 2022, Oliver Upton wrote:
> Hi Sean,
> 
> On Wed, Aug 24, 2022 at 03:21:14AM +0000, Sean Christopherson wrote:
> > +/*
> > + * Sync a global pointer to the guest that has a per-VM value, in which case
> > + * writes to the host copy of the "global" must be serialized (in case a test
> > + * is being truly crazy and spawning multiple VMs concurrently).
> > + */
> 
> Do we even care about writes to the host's copy of the global pointer?
> I don't see how the host pointer is used beyond serializing writes into
> a guest.
> 
> IOW, it looks as though we could skip the whole global illusion
> altogether and write straight into guest memory.

*sigh*

This exact thought crossed my mind when I first looked at this code, but somehow
I couldn't come up with the obvious solution of using a temporary on-stack variable
to hold the desired value.

Something like this should work.

#define write_guest_global(vm, g, val) ({			\
	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
	typeof(g) _val = val;					\
								\
	memcpy(_p, &(_val), sizeof(g));				\
})
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

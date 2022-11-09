Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91220C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 22:42:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12F6F4BA2F;
	Wed,  9 Nov 2022 17:42:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nip6f7zG49N5; Wed,  9 Nov 2022 17:42:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD4734BA25;
	Wed,  9 Nov 2022 17:42:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 364E84BA23
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:42:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vCMyusFdzxVo for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:42:16 -0500 (EST)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14E474BA07
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:42:16 -0500 (EST)
Received: by mail-pj1-f46.google.com with SMTP id
 q1-20020a17090a750100b002139ec1e999so104705pjk.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 14:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=ZKiMsUeXYzlgxWfF0WcmHUUjbEiQdWPsUbhG4FuUTvU=;
 b=cD4gLgROz4g4LtmSRbdLXGAjaJuR6pnQPfjazM0yU0Hn/lv/WT5o4Her5FZZKbaJvo
 3llk8DYE2nZDW2sbqQRiQfbjE1ZapQwwU0U2Cv08c9Ebk8FU0i0XK4awq7K7iidJf8OH
 3GcfjHTDxs/DR50LOoQvFL4LWTUNBDsk4dxtwc4SeMTKq2oVpauMgfCUNtsr3uNWy3cz
 RpG+CtA8bVTi2doo034FUCj8Kt6OAO4pYKClaQOLsbg15mz+DJmaYa7LRAgZji6biWZu
 +q6Wz7oH6l72tqHN4GUlfyDALVakTWYywy2upo+HFDthGSfQgKq+AvRIE4mmZZ0GudzA
 bgyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ZKiMsUeXYzlgxWfF0WcmHUUjbEiQdWPsUbhG4FuUTvU=;
 b=XVjEw5eVFS+O/HrQGphWQOrbR3lwtT32W5AL7uS2JEXNFPwDwsP0byfyzG0pZmDH3B
 d85zwT2OGzF+O+dtt5ekjGYd+O4dAO+ji07B8rd11SwlyI1d9kqrePiHB91O/6ScchGP
 +1V6KX3OgMCWlnScQRIDQohAENQ4QhTT/L602d5ZBQSFJzu9+ljSJZ89qZSeTBSRRfUi
 Y66hWyN9FRs56XMT7WcHjFYuWHQHIAiurDWOL+cywAFZ63+Doga05flOpWWXlI7ElqfK
 ZWkXyETE4Rp4xwtyEOsvoM/1joxO7rFeAL9HTaixiDcb1saJ/XSqQVssH3P1yd1t7kxt
 p3zg==
X-Gm-Message-State: ACrzQf00G/0lJu1RKCpfhGWsAMX4Ol3X8aVuy0yRSJjox2IVIhcUL61X
 apNFfSjs++Dw5LrO9boeDmpBBQ==
X-Google-Smtp-Source: AMsMyM7VhBvIBJZq8DOffvWOeCdh5Qe5jEL63Uu0jploe/nMqN4VkZSgtUrZB0hVopNblvbQ13kL9w==
X-Received: by 2002:a17:902:e811:b0:186:8a61:ea76 with SMTP id
 u17-20020a170902e81100b001868a61ea76mr63663058plg.10.1668033734747; 
 Wed, 09 Nov 2022 14:42:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 f5-20020a655505000000b00434760ee36asm7850505pgr.16.2022.11.09.14.42.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Nov 2022 14:42:14 -0800 (PST)
Date: Wed, 9 Nov 2022 22:42:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v5 09/14] KVM: arm64: Atomically update stage 2 leaf
 attributes in parallel walks
Message-ID: <Y2wswsHgDHIIXram@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-10-oliver.upton@linux.dev>
 <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Nov 09, 2022, Ben Gardon wrote:
> On Mon, Nov 7, 2022 at 1:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > @@ -1054,7 +1066,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
> >  bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
> >  {
> >         kvm_pte_t pte = 0;
> > -       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
> > +       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, 0);
> 
> Would be nice to have an enum for KVM_PGTABLE_WALK_EXCLUSIVE so this
> doesn't just have to pass 0.

That's also dangerous though since the param is a set of flags, not unique,
arbitrary values.  E.g. this won't do the expected thing

	if (flags & KVM_PGTABLE_WALK_EXCLUSIVE)

I assume compilers would complain, but never say never when it comes to compilers :-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

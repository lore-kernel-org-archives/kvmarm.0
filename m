Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83DAC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jan 2022 19:19:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D98949DED;
	Wed,  5 Jan 2022 14:19:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LUijkpANwM39; Wed,  5 Jan 2022 14:19:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C81F49E18;
	Wed,  5 Jan 2022 14:19:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6827449DED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 14:19:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oeH9njnR5LAN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 14:19:50 -0500 (EST)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CD4749B08
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 14:19:50 -0500 (EST)
Received: by mail-pg1-f170.google.com with SMTP id 8so66912pgc.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 11:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=qoub34JKMYw80YSVF2J+hWLmoHzppRyhKwTIl4ud58A=;
 b=eJrm9vSQlYbjzA48SXuyQTX4vpv+0waa/m6b4+CGvv+TU/vaqalx+wW2nsSxEQ/9vt
 A1suumBCxyzaCyNgn32IdqREfwZqOk/nXRQaoAh5CC60NGExeXlyi31EGxNmYxTQEX4E
 sQifAS+vZypu+S3JY78d2kp/YnmHYIUm5hak6fwjzowpaKSAXq5lBDIqAjzDrUlgI6lA
 KZYptrb10ts7MYcBXTd91Zphk5IkT12dQBvNVkTmAySlUziWKC75l3HxKYPl617awyGC
 o8+l5yF/ne1DrgpDW61L5Cb9yCX34IVOYNXYh6PnfvMZk7x3F7tG0p/lLsdCZ42dXxXJ
 EFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qoub34JKMYw80YSVF2J+hWLmoHzppRyhKwTIl4ud58A=;
 b=XMZW0gT9TtQR8qW7yP2JLQuuqwfJSbwtx/cL7KLREDP6j6/NtwRIsz7+gWbSyiLAyW
 44d4yVbA10k9Jx5ZGtKZuOM6s5vwgN/p5/mRd1YQixhZ9XGt2X4cwYEU0yilgQwfQ//u
 THT+VZKkzVkiDUHbfVhTniVCxLidiA0dsqAepMRgxWAvlPNY77XvH1wt/ZXoqpHCk7Ft
 WGM7XuPm5D/Syp+YNWrOEqT7mgrx28Ji3mMfOimA/iN2Q9m7oK6fIvrYVGij46DjjWgW
 YgvUo3EJts0NcTN0iOO97E2SltgeGCMZ0X4IordpU7oxe6O7QOsQeDZl+9QUe+fvyJH9
 tcQw==
X-Gm-Message-State: AOAM533h0CPLPKZf/etvH/y3bAvl7tKcaPmMUyYLqAVZnODBmiU2h+3p
 0OQX8qSfaDBovAPPUJCWeQ37jg==
X-Google-Smtp-Source: ABdhPJxye1sjvjOvj00utsHDdoqYNY5iCIYZuac2xNc6/XTpseq2jJOALu2rGleR4A8aeXodNqfdiQ==
X-Received: by 2002:a63:1422:: with SMTP id u34mr49958790pgl.135.1641410389102; 
 Wed, 05 Jan 2022 11:19:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id a17sm3400933pjs.23.2022.01.05.11.19.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Jan 2022 11:19:48 -0800 (PST)
Date: Wed, 5 Jan 2022 19:19:45 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
Message-ID: <YdXvUaBUvaRPsv6m@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YdXrURHO/R82puD4@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Wed, Jan 05, 2022, Sean Christopherson wrote:
> Ah, I got royally confused by ensure_pfn_ref()'s comment
> 
>   * Certain IO or PFNMAP mappings can be backed with valid
>   * struct pages, but be allocated without refcounting e.g.,
>   * tail pages of non-compound higher order allocations, which
>   * would then underflow the refcount when the caller does the
>   * required put_page. Don't allow those pages here.
>                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> that doesn't apply here because kvm_faultin_pfn() uses the low level
> __gfn_to_pfn_page_memslot().

On fifth thought, I think this is wrong and doomed to fail.  By mapping these pages
into the guest, KVM is effectively saying it supports these pages.  But if the guest
uses the corresponding gfns for an action that requires KVM to access the page,
e.g. via kvm_vcpu_map(), ensure_pfn_ref() will reject the access and all sorts of
bad things will happen to the guest.

So, why not fully reject these types of pages?  If someone is relying on KVM to
support these types of pages, then we'll fail fast and get a bug report letting us
know we need to properly support these types of pages.  And if not, then we reduce
KVM's complexity and I get to keep my precious WARN :-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A31C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 21:02:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C49504B11C;
	Tue, 11 Jan 2022 16:02:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Vcxn1+aoLj3; Tue, 11 Jan 2022 16:02:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B566C4B12E;
	Tue, 11 Jan 2022 16:02:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D42F04B11C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 16:02:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6uXdH-Mnj5Nu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 16:02:34 -0500 (EST)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B215049FE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 16:02:34 -0500 (EST)
Received: by mail-pl1-f176.google.com with SMTP id g5so629704plo.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 13:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KP22ekfBfvtfdZJuVQAmoq8mG19AH/gb+o7LwKndtYs=;
 b=b/P8JT3dnswhxIdvQnrQuqhUXUeaJ1GZbigQbjs9sIgAsLD4ixy/s9Rim/uumbTLr/
 hmGE2gF+yj3wXwhJDjoJSf4WpKTRuKft/UrhmsJkf5Azn1VA4pEjq43xO1U3N+tkODSg
 eeTWU3giubfEZBDAtAknNHCKhI3uHiiSqFL8sWsVZHbLKYLv0X3rYSQzgk2vmJWN1bsG
 SLdXXggYx8s7P5c8ITinq5w6zb4DiX/DF10A+2g5TS7DFlo3S0ejJcTqPTjkZym09X2q
 J0fl5UOW9MgoArXIXRf7WEokjCoStGC5HvkEW/r6ZdroAIzUo8HrwmoXbHwhAOITQNh8
 6Mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KP22ekfBfvtfdZJuVQAmoq8mG19AH/gb+o7LwKndtYs=;
 b=p+B0njFyqDFzkP/sdDu9/JGXu2oPzk3aJzvU4VxLyKuEE3dPbzBwFeSsheM9Z3Gr9F
 UFe6IF/aN15/160aw7A6Pdwoy2dC7UP6NkpTWSkwareHKiIUoxE+TkERtEL+o3mIr2aG
 6vMgXRP8K6sLpylx0fLnDKcPF4p3xGSvIwYV3ORCSH7lcf4/DICjcVLJo1H+hSBA37EZ
 LuRD0dkJ6rlPB95SjYe615khnmv/ELYKa3lp7GShpoMKF2DieatCtdEZz1EnnecAlUL6
 C7S6AZHDpeLIxHvKlNaet7P3MUIsIWdYqdKzlj+z6qMBos0+aq4oFptSq7X/omGfL3xH
 S7mw==
X-Gm-Message-State: AOAM533ie3bqKjosk0L6SJpP4bzdjb2wX+5A6Q0MWLPS2zWcc5NPkSXK
 SSDmnAkygmiMAKZw1vtwC5GJPw==
X-Google-Smtp-Source: ABdhPJwYyA1X7Bfg45oD8YBhBwdA5jD7QS6C7HOdCnRZ2tfTgfGILyCszz8uNmzWyZLAkeSMiyLXGg==
X-Received: by 2002:a17:90a:9284:: with SMTP id
 n4mr5133516pjo.109.1641934953660; 
 Tue, 11 Jan 2022 13:02:33 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id h19sm11844710pfh.112.2022.01.11.13.02.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 Jan 2022 13:02:33 -0800 (PST)
Date: Tue, 11 Jan 2022 13:02:29 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: debug: mark test_[bp, wp, ss] as
 noinline
Message-ID: <Yd3wZaEVMTjdqpk2@google.com>
References: <20220111041103.2199594-1-ricarkol@google.com>
 <Yd3dvorNkP7eercw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yd3dvorNkP7eercw@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, maz@kernel.org
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

On Tue, Jan 11, 2022 at 07:42:54PM +0000, Sean Christopherson wrote:
> On Mon, Jan 10, 2022, Ricardo Koller wrote:
> > Clang inlines some functions (like test_ss) which define global labels
> > in inline assembly (e.g., ss_start). This results in:
> > 
> >     arm/debug.c:382:15: error: invalid symbol redefinition
> >             asm volatile("ss_start:\n"
> >                          ^
> >     <inline asm>:1:2: note: instantiated into assembly here
> >             ss_start:
> >             ^
> >     1 error generated.
> > 
> > Fix these functions by marking them as "noinline".
> > 
> > Cc: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> > This applies on top of: "[kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for debug state"
> > which is in https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue.
> > 
> >  arm/debug.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arm/debug.c b/arm/debug.c
> > index 54f059d..6c5b683 100644
> > --- a/arm/debug.c
> > +++ b/arm/debug.c
> > @@ -264,7 +264,7 @@ static void do_migrate(void)
> >  	report_info("Migration complete");
> >  }
> >  
> > -static void test_hw_bp(bool migrate)
> > +static __attribute__((noinline)) void test_hw_bp(bool migrate)
> 
> Use "noinline", which was added by commit 16431a7 ("lib: define the "noinline" macro").

Will do, thanks for the pointer.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

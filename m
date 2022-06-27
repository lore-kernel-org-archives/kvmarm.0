Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474FEC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jun 2022 16:27:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D276640AEB;
	Mon, 27 Jun 2022 12:27:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oFwe+zFyegH4; Mon, 27 Jun 2022 12:27:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D63834B1CB;
	Mon, 27 Jun 2022 12:27:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55D9340AEB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:27:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KHusJbfIff2t for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2022 12:27:16 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51F0340597
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:27:16 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id
 n16-20020a17090ade9000b001ed15b37424so9935019pjv.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 09:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=mvInyOfSwUwozjAA99zs61ByhccL7VTO1x3ICoYmzBc=;
 b=ajnq7ke4Zz4McbdwS+PvHKW0VTT+5/HKbvbyUSU1xxNO95siL3s1Jpz428GFKykOXg
 d8VB6gCmL6MAhNlqxOFU83q7MUtfZqaThTeljwRubrjY3FXr/nSrG8ysRcwC3JY9oXHY
 E/nazIf3ro2KlZr4d5FeO++ZCODHw1FvBEgFN0RUD7vpMXappy8dWxMkU57GzU0Zjw2G
 vT0p9IwlEukEh7Kxuyd/5hL3Huv66bpmY8YLrafTKaNkvkRpdXflG8tpbnFvxHj6/fm2
 e1NOsQAKbZvXwYzS6mETspy+MSA2+b26DyQwX1r3nMVNhSoR9V6muHqeAQbGFgyO+Apl
 N6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mvInyOfSwUwozjAA99zs61ByhccL7VTO1x3ICoYmzBc=;
 b=ZcVPmIdHEXfTAWSvvNyAYU5k2Y68kuSzXEeRP/Rnh/6N8pUzQ8uyK3ADqos9TvTwrI
 LCIJkthsS02nn0MlJQaGqHaEz3TyokZWSHV9yXkV32u8b7T14cZiW/13q4ZZk5CM9abR
 xNUzRSznhXzMQLw2zVfAzSlOwgM1a8FG+dvVUihxagb04+hRzaH0D8SZaHsFaSisPiz9
 s6ilpjzvutRnmmox7nExxKUJZKBgMlKkRPLaIe7LicGxek7zgBBl9cTPRcns5e+66xGM
 bI/4QhM2oNIRefygB3PvzuhfBT+jhLmG3dQoKut6T5LalaXQL4AxV43Qqz61Ut6PBn+t
 FM3g==
X-Gm-Message-State: AJIora/xE1T+QCRKP/K4r9KRZN3RvnuDt/Wma7l8SPWmbV9SbCFia1tF
 CgUBv1pXHorLTo9Oc75Edhq9OA==
X-Google-Smtp-Source: AGRyM1tcFjGd3kEd1e3VvK1h2C/OoW2/ELgvNDxXEU16p6UpdQ8fqhAPxyZ462XWYdnE86YgJ158JA==
X-Received: by 2002:a17:90a:14e4:b0:1ee:dd88:f38c with SMTP id
 k91-20020a17090a14e400b001eedd88f38cmr6385973pja.62.1656347235128; 
 Mon, 27 Jun 2022 09:27:15 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 q3-20020a17090311c300b00164097a779fsm7614578plh.147.2022.06.27.09.27.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Jun 2022 09:27:14 -0700 (PDT)
Date: Mon, 27 Jun 2022 16:27:11 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <YrnaX/GzivdLPel5@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-2-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-2-yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 061744c436d99..894d6317f3bdc 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -973,6 +973,7 @@ You may not have all of these fields.
>      SReclaimable:   159856 kB
>      SUnreclaim:     124508 kB
>      PageTables:      24448 kB
> +    SecPageTables:	 0 kB

If/when you rebase, this should probably use all spaces and no tabs to match the
other fields.  Given that it's documentation, I'm guessing the use of spaces is
deliberate.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3095C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 23:30:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2504B8F2;
	Wed, 19 Oct 2022 19:30:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OYULPnPPc3A5; Wed, 19 Oct 2022 19:30:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02CBE4B912;
	Wed, 19 Oct 2022 19:30:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5F284B908
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 19:30:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6JJ5FXlTvi-L for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Oct 2022 19:30:01 -0400 (EDT)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDC1E4B8F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 19:30:01 -0400 (EDT)
Received: by mail-pj1-f53.google.com with SMTP id pq16so18244778pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 16:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=qruOvYNq6YtcLgC8q9oi5W0wV4Pui1eBKPtr9rOj7ao=;
 b=pNS4i1/uTE4ZjPfTxUlttdhibsboeayO977TaMrS1sYkQiDeEdxdrNp8fYJxt/nlLl
 rY+UubEWMRQGyUBH2CE+gvS0hQUwfZ/g/f+7WQ6ctLMQLVeSVueJHSewAFzsjHLFpDjv
 0q8T/L/ZOjlxQwcPOUqlV8+Qcu76Jd9tybLqBjXd5Kc+YuYYIEkeQn3/nUUnm7j1b7QX
 kY3YVqJu2O4STBO5JPK3vMHrMDesVjvETNBxFs/zxcBLH4y84LB7dem38QmEhj3zJ1Wj
 /vVR/HnRTX4H68Fhk5dHUkhFlI0AlPNABY+kfiysYV98/fuDZZoF7SKrdyuyByK+7H2G
 ++8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=qruOvYNq6YtcLgC8q9oi5W0wV4Pui1eBKPtr9rOj7ao=;
 b=VhHuBk/OT7mwjKnDxdygAqeCcl01tGi4z3xwyLiPe1aNAlRV8jveFvNs7IqaybMBdM
 ig/iKe2ysLjUwvB+etmWhiH5vEUNxHL1hP5/2Uc5BUu5I8zXirb0Wiz3fV+WhnVazRdQ
 tUnpPxeLnG/KbKzTQhC6W/tSdMwrjM8Vhq/nrzD9hrV5ZAqADVCdE7ikVCiu/5G6rJo8
 5PfN2qym/FnppS2aEv8MB7PYmUNPVX0c3p2cpJkckIVXKx80JBwPrYPe2G/o7gGrq6mH
 Cleb1vxgZRYOysRCek8+jn8TEV4wG4Mmjq2IzVNTSsujbcs0G0yYYNUFceO33MH4/9pp
 rNZA==
X-Gm-Message-State: ACrzQf0x7DJAAmtnnH0LFX81V0JZqhoo8SaY2++L9Bzu5DR/XqOGQxTq
 vdmrhfJqmM2nX43WHyhDCQ+soQ==
X-Google-Smtp-Source: AMsMyM51FW42zS56Z56v3OpmK3a6FlWgAAbvrNLxA+8YZJ8dKFrQg5/eqpzDYRzimT6KdDBkOpGsRQ==
X-Received: by 2002:a17:902:e890:b0:185:4ac7:9757 with SMTP id
 w16-20020a170902e89000b001854ac79757mr10900658plg.150.1666222200834; 
 Wed, 19 Oct 2022 16:30:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 d25-20020aa797b9000000b00561f8fdba8esm12367909pfq.12.2022.10.19.16.30.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 16:30:00 -0700 (PDT)
Date: Wed, 19 Oct 2022 23:29:56 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y1CIdN5kcJPaZdqv@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007232818.459650-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221007232818.459650-9-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Oct 07, 2022, Oliver Upton wrote:
> The use of RCU is necessary to safely change the stage-2 page tables in
> parallel. Acquire and release the RCU read lock when traversing the page
> tables.
> 
> Use the _raw() flavor of rcu_dereference when changes to the page tables
> are otherwise protected from parallel software walkers (e.g. holding the
> write lock).
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---

...

> @@ -32,6 +39,33 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
>  	return pteref;
>  }
>  
> +static inline void kvm_pgtable_walk_begin(void) {}
> +static inline void kvm_pgtable_walk_end(void) {}
> +
> +#else
> +
> +typedef kvm_pte_t __rcu *kvm_pteref_t;
> +
> +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> +{
> +	if (shared)
> +		return rcu_dereference(pteref);
> +
> +	return rcu_dereference_raw(pteref);

Rather than use raw, use rcu_dereference_check().  If you can plumb down @kvm or
@mmu_lock, the ideal check would be (apparently there's no lockdep_is_held_write()
wrapper?)

	return READ_ONCE(*rcu_dereference_check(ptep, lockdep_is_held_type(mmu_lock, 0)));

If getting at mmu_lock is too difficult, this can still be

	return READ_ONCE(*rcu_dereference_check(ptep, !shared);

Doubt it matters for code generation, but IMO it's cleaner overall.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

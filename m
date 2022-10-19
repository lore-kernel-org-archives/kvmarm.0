Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818B653BD
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 23:30:01 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d24so18696867pls.4
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 16:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=PabUAwMoCbhP7iB4LDMmplZ+hW56EH3d7PE3+lDCPiYVaVKhGlU7gEGe5qAkNw8A7C
         ITKIbb8jlQpOk+UVWju4WAmihhyTQp6MOoyfCnAUfbAkuRI6UONV9yFzZzTcgqlQ0G3c
         Nf0RbHwYjRcKjXk+34/gpcsmKfTa6SP7y996d/fK6yHmtMo0X1kSB75xCkvve0GtvpQX
         UbCOu69b2Xbg4eyGMRFYm8aPTeCxAC9jIcg44v3g5I1kRxVUhncSqnMx/2EP7qFYeVuV
         7tVbWW1D1QtkY9CheHtIwDlWbKolvsNnhjJ4a5S4RgN0hslErLQYtCYH7LJnWBrbcCHA
         unjw==
X-Gm-Message-State: ACrzQf2i6sYkbR8w4t7prvbsdeiY3BtnUJAWP0m4TXf3KuNecRx2QJEN
	hJbDpOaeNO4K+7yOAfJK8OszcQ==
X-Google-Smtp-Source: AMsMyM51FW42zS56Z56v3OpmK3a6FlWgAAbvrNLxA+8YZJ8dKFrQg5/eqpzDYRzimT6KdDBkOpGsRQ==
X-Received: by 2002:a17:902:e890:b0:185:4ac7:9757 with SMTP id w16-20020a170902e89000b001854ac79757mr10900658plg.150.1666222200834;
        Wed, 19 Oct 2022 16:30:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d25-20020aa797b9000000b00561f8fdba8esm12367909pfq.12.2022.10.19.16.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:30:00 -0700 (PDT)
Date: Wed, 19 Oct 2022 23:29:56 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y1CIdN5kcJPaZdqv@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007232818.459650-9-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007232818.459650-9-oliver.upton@linux.dev>
Message-ID: <20221019232956.SQPEJjLbR8vvqyQvSffCittyO3CcaFTDdNWE_KtCotY@z>

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

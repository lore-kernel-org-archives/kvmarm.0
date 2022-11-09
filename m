Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67444107A7
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 22:42:15 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so85441pjl.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Nov 2022 14:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=3JvRy4KfGdtSA/UFJHE/SSVRyjc/AurKTVVH9V9kvQdTcEqrAxaFyfL4jPLlPrIjPF
         ZAgnTfOFjMol3GdjI7aj0WSaFZlpolABqkX8h/JX89IRrTlrPgGtA3xD8c1OjTvcPTKw
         IjO1PpAXdEH4PwjvZ5TW44YVIvgAMCkS/RJU9EVEB6rQ+VNjbuxQMLPfEcgiOy5VT87g
         ghjCWOO8S1kGQN+HTK21U2pR2GuSNuiLRTt2uipwE64wIlyv4bLy4bIynCRvMbIfw+di
         SL7Tj1CszQ3zA4DjxPASv05FHbuZugGbIWJEQx/RoVpee5RMTRfRUxEqr2d8E6Be/0RK
         4t7g==
X-Gm-Message-State: ACrzQf2D6PwrvmSgutcHRa5NBOW/2rdCOvNzyCPlijqFaXgm54Nr+Z5t
	Q/BQq/r/4GcIcE2+7IKkX8bK5A==
X-Google-Smtp-Source: AMsMyM7VhBvIBJZq8DOffvWOeCdh5Qe5jEL63Uu0jploe/nMqN4VkZSgtUrZB0hVopNblvbQ13kL9w==
X-Received: by 2002:a17:902:e811:b0:186:8a61:ea76 with SMTP id u17-20020a170902e81100b001868a61ea76mr63663058plg.10.1668033734747;
        Wed, 09 Nov 2022 14:42:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f5-20020a655505000000b00434760ee36asm7850505pgr.16.2022.11.09.14.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 14:42:14 -0800 (PST)
Date: Wed, 9 Nov 2022 22:42:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ben Gardon <bgardon@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 09/14] KVM: arm64: Atomically update stage 2 leaf
 attributes in parallel walks
Message-ID: <Y2wswsHgDHIIXram@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-10-oliver.upton@linux.dev>
 <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
Message-ID: <20221109224210.0uQwWuksReKykGZTknOzDpurgBgASDoKoLMxT5dYiaQ@z>

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

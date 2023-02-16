Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3529BD308
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 22:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676588152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WsJAQPdgfmyRCdBIfmljb6PSA+KVi0kNYA3whbtDzGE=;
	b=DHRiAYSjcsDDcxs8PoOioXboGPqApCxe10kW+xOpIZvMy4uR5zwDVDlSYD8DRskieVrfCL
	cbswfVfdgP2WHEobYyQtbo6CpuGPVq6p3ima6AM9RgroyIz9lArqCE1LpD9P2OExe28e2f
	EycCJ0HKFBZogPJeSPkh1ASWzbTtBxg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-222-7Eg2ESzDPdy-BEMe6xnzAw-1; Thu, 16 Feb 2023 17:55:50 -0500
X-MC-Unique: 7Eg2ESzDPdy-BEMe6xnzAw-1
Received: by mail-qt1-f199.google.com with SMTP id cd3-20020a05622a418300b003b9bd2a2284so2090472qtb.4
        for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 14:55:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WsJAQPdgfmyRCdBIfmljb6PSA+KVi0kNYA3whbtDzGE=;
        b=moaDPKSWaC1kqQ7t4zDMyy/+yMYMLKmm4cC7HyDkq4JcYVtKTKRuRe4UwFa8OIkf3B
         DRw7y+QholJVNNL3yMpxpFqV6WI/MgGVrSiihGcjwjJHlI/udhUDxMowyfEU3GD165V2
         tdIrt63IlTM6ONAgPHKc+Rhy8Kxnk3uPd5AtZTeGmaeNciZldxuHhSjkYqMhk9c1YbrG
         AEr5F4+LQ4Nh9iadq0a2Ymt6f4w3wa7HYrNdGLz9mssH0VbtpXfJkF0TCMAWdB7I6/3Q
         3/fLYP5wRuDPTvk7lxHWQmYsqMlI7KLmtkjCZmooOl/5xaMHp2UabVG3Dsq4cuS3s3JU
         P15A==
X-Gm-Message-State: AO0yUKXobnQOZKlG4vOVCKt/XLLVA1MScQUSgEarEjPfLuINUpObHWTM
	CNV8u+6ZlpE9vXxziTJa1RRJFV0qiPLi4NkS/pqa6zkQnEFF3rsVRYwMOLbv+hvv1xyXxgEe5+g
	Phy6//aRJFBooE3aw
X-Received: by 2002:a05:622a:1052:b0:3b5:87db:f979 with SMTP id f18-20020a05622a105200b003b587dbf979mr14520330qte.5.1676588150334;
        Thu, 16 Feb 2023 14:55:50 -0800 (PST)
X-Google-Smtp-Source: AK7set+WU3Uxar4FQEfigjScvOSNMorobMDegsajbzAUL2/ymdc3m3y2cKgUDCySPQH/BrPQuXkBAg==
X-Received: by 2002:a05:622a:1052:b0:3b5:87db:f979 with SMTP id f18-20020a05622a105200b003b587dbf979mr14520310qte.5.1676588150092;
        Thu, 16 Feb 2023 14:55:50 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-56-70-30-145-63.dsl.bell.ca. [70.30.145.63])
        by smtp.gmail.com with ESMTPSA id 2-20020ac82082000000b003b2d890752dsm1301870qtd.88.2023.02.16.14.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 14:55:49 -0800 (PST)
Date: Thu, 16 Feb 2023 17:55:48 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Ben Gardon <bgardon@google.com>,
	David Matlack <dmatlack@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 6/8] kvm/x86: Add mem fault exit on EPT violations
Message-ID: <Y+60dIGWIXEuHpwW@x1n>
References: <20230215011614.725983-1-amoorthy@google.com>
 <20230215011614.725983-7-amoorthy@google.com>
 <Y+0VK6vZpMqAQ2Dc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y+0VK6vZpMqAQ2Dc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi, Sean,

On Wed, Feb 15, 2023 at 09:23:55AM -0800, Sean Christopherson wrote:
> > @@ -4230,9 +4231,25 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  	}
> >  
> >  	async = false;
> > -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> > -					  fault->write, &fault->map_writable,
> > -					  &fault->hva);
> > +	mem_fault_nowait = memory_faults_enabled(vcpu->kvm);
> > +
> > +	fault->pfn = __gfn_to_pfn_memslot(
> > +		slot, fault->gfn,
> > +		mem_fault_nowait,
> 
> Hrm, as prep work for this series, I think we should first clean up the pile o'
> bools.  This came up before when the "interruptible" flag was added[*].  We punted
> then, but I think it's time to bite the bullet, especially since "nowait" and
> "async" need to be mutually exclusive.
> 
> [*] https://lore.kernel.org/all/YrR9i3yHzh5ftOxB@google.com

IIUC at that time we didn't reach a consensus on how to rework it, and the
suggestion was using a bool and separate the cleanup (while the flag
cleanup got NACKed..), which makes sense to me.

Personally I like your other patch a lot:

https://lore.kernel.org/all/YrTNGVpT8Cw2yrnr@google.com/

The question is, after we merge the bools into a flag, do we still need a
struct* anyway?  If we can reach a consensus, I'll be happy to continue
working on the cleanup (by picking up your patch first).  Or if Anish would
like to take it over in any form that'll be also perfect.

Thanks,

-- 
Peter Xu


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5BC3D6E
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682089211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O1eD+/HAE2ibby7fBYttdYlgng32940ka9+w3I/e2es=;
	b=KbpdVBfcoNE68XRuc+oywmiopWouAsMm1mPKRRF19et+XoVAXLXM2o7O87KgF6VIOqMG+r
	jBLpKcu+Mp4jkCAM08KgSCXmYG6yWqkmfmFyuw2A4rSvLuLFIjIghom+NitdEaZLl/YiYP
	JpygwPeyVYBEi1VHWLza8dnWWXzUf0E=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-e2FNr7zNMWS_CWfF3VqR0g-1; Fri, 21 Apr 2023 11:00:07 -0400
X-MC-Unique: e2FNr7zNMWS_CWfF3VqR0g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-74deffa28efso32898785a.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 08:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682089207; x=1684681207;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O1eD+/HAE2ibby7fBYttdYlgng32940ka9+w3I/e2es=;
        b=LLPFx3r/p5tEqNBDRDALliCt2cEX7rht621RFpsCiIzA4p9EBQWVdP1NfW7VE/NI0A
         KHINL8xKPiG/tLFw/cmv6kTVyUS/hlXX3571CJfif7m4O5hGr0ZJzOTN7Aov6Amf5Oox
         /d1dEauXcPqPCmp8D8XQz+HcJlil5aD/11p3xjmH7jLtSjEVqYXRdWN8cqLw9Z56dgCJ
         WUwnZKwKpF0ee75mZcH7hvQCaWRyoxqGwebT8pO9sruQuu5rwi+EWkCJQKzNw4afpKAl
         qWVaNe91o9Xvpad9a1D3kG5yWdNmoU1zX2zeueJpPoiRJV5xcu3FUPKG5UKyfe20i4Dh
         2sTQ==
X-Gm-Message-State: AAQBX9eggBryk9wdkf5tXf/hiwVjNetqRDTIqQXSGlNzbYz84mMkbr6r
	oKUcZIUp0eZNKg2KzP5TrDRBZ/vB9mvc3DtkbYasEiG9P/LJgBwcV75AFliO9TASOU3yDunYLrS
	fikXTvuTeqsdRpgZq
X-Received: by 2002:a05:6214:5292:b0:57d:747b:1f7 with SMTP id kj18-20020a056214529200b0057d747b01f7mr8222991qvb.1.1682089207233;
        Fri, 21 Apr 2023 08:00:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350abE8OOKINlp9ikA9nBcO1DarZM/69Hep1ja9PiFv9sNe3YH+zBqqL3lVQhGsvpO9IWhF94/A==
X-Received: by 2002:a05:6214:5292:b0:57d:747b:1f7 with SMTP id kj18-20020a056214529200b0057d747b01f7mr8222950qvb.1.1682089206905;
        Fri, 21 Apr 2023 08:00:06 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id q17-20020a0ce211000000b005f5b71f75f3sm1213482qvl.125.2023.04.21.08.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 08:00:06 -0700 (PDT)
Date: Fri, 21 Apr 2023 11:00:04 -0400
From: Peter Xu <peterx@redhat.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
	seanjc@google.com, jthoughton@google.com, bgardon@google.com,
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 07/22] KVM: Annotate -EFAULTs from
 kvm_vcpu_write_guest_page()
Message-ID: <ZEKk9Ff1ok025BFj@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-8-amoorthy@google.com>
 <ZEGmAnnv5Dq8BgrW@x1n>
 <CAF7b7mqR97H=z05XN-qv97Tp=Qqr4y6kBgckkVRu5XLDpwJTUg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAF7b7mqR97H=z05XN-qv97Tp=Qqr4y6kBgckkVRu5XLDpwJTUg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Apr 20, 2023 at 04:29:38PM -0700, Anish Moorthy wrote:
> On Thu, Apr 20, 2023 at 1:52 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Wed, Apr 12, 2023 at 09:34:55PM +0000, Anish Moorthy wrote:
> > > Implement KVM_CAP_MEMORY_FAULT_INFO for efaults from
> > > kvm_vcpu_write_guest_page()
> > >
> > > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > > ---
> > >  virt/kvm/kvm_main.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 63b4285d858d1..b29a38af543f0 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3119,8 +3119,11 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > >                             const void *data, int offset, int len)
> > >  {
> > >       struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> > > +     int ret = __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
> > >
> > > -     return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
> > > +     if (ret == -EFAULT)
> > > +             kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset, len);
> > > +     return ret;
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
> >
> > Why need to trap this?  Is this -EFAULT part of the "scalable userfault"
> > plan or not?
> >
> > My previous memory was one can still leave things like copy_to_user() to go
> > via the userfaults channels which should work in parallel with the new vcpu
> > MEMORY_FAULT exit.  But maybe the plan changed?
> 
> This commit isn't really part of the "scalable uffd" changes, which
> basically correspond to KVM_CAP_ABSENT_MAPPING_FAULT. There should be
> more details in the cover letter, but basically my v1 just included
> KVM_CAP_ABSENT_MAPPING_FAULT: Sean argued that the API there ("return
> to userspace whenever KVM fails a guest memory access to a page
> fault") was problematic, and so I reworked the series to include a
> general capability for reporting extra information for failed guest
> memory accesses (KVM_CAP_MEMORY_FAULT_INFO) and
> KVM_CAP_ABSENT_MAPPING_FAULT (which is meant to be used in combination
> with the other cap) for the "scalable userfaultfd" changes.
> 
> As such most of the commits in this series are unrelated to
> KVM_CAP_ABSENT_MAPPING_FAULT, and this is one of those commits. It
> doesn't affect page faults generated by copy_to_user (which should
> still be delivered via uffd).

Indeed it'll be an improvement itself to report more details for such an
error already.  Makes sense to me, thanks,

-- 
Peter Xu


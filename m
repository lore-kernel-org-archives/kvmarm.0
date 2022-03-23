Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE7FC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 16:31:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A20AA49F35;
	Wed, 23 Mar 2022 12:31:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oQTHo01QnRbX; Wed, 23 Mar 2022 12:31:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 787BC49ED1;
	Wed, 23 Mar 2022 12:31:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E29A540C95
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 12:31:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GwxcUrKJiPGI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 12:31:23 -0400 (EDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DC3A40B80
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 12:31:22 -0400 (EDT)
Received: by mail-io1-f51.google.com with SMTP id z7so2339344iom.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 09:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=AlyA01ihneYGdhEvQM86PHNf9KfO67kvj0GzTGLAXNU=;
 b=nz1opHZjdVPlTkjXUEgUlHpKpA9whYmdgayXgRb4JITVwirZcQAIssljBegsKOx70N
 bYc9NvDOz2/3RJESS9l2j2Gyd4J78aZ96vFXT0WfK3/erqhmsb9EQoy0udyTH1OnFx1i
 DUYCzNb1DIiJu6R1b9BLPdoxxJpoNYnyAyBi2zfut0GTNF5GNSzWbjclfqg79iZPocT3
 wM+nx6rBF5DVNmucW/a1zwbTRPN1NxoQztGKXHdbF+nOBLk5QmAZic3b8Mmvd0vCo26n
 eWDg+69yZAcZg5S1519bZVprQtjQfKPU5b7Suehnm910QeS6AdPCCPTHeM75zi4DeHhc
 4UgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AlyA01ihneYGdhEvQM86PHNf9KfO67kvj0GzTGLAXNU=;
 b=FnIdTd/+KvVf1h+z0UO4G87Qpgc6HfVcVqdNeIzHV3h2Zq0e2adN0h2F1suHab7Gwv
 gjVg1hUDC+BRjMM4Ae5kQN5c8yr4hfYqOsh6X5ZfiifIVxHeH2PfwQ4B029NLl+b//pG
 JAzth54hLmWGbAy03k+zV5rDUW5hO0ySNG1foaTOuF9qeYY/0fPSeWzGhMY0Jcg+1SQI
 flLLhfekwJEUxzliy7rxZI1s/Jq7pRd7JB6BuVE3VUcffBNb1xjHSzJSYuD4cXsiaBy4
 +HdEq7rMb2z4x/7dEFXYrk6el5COwRRhHsNj1PTFIElc2Xn7LedD5447Y+eGRfuL3W9F
 9YHQ==
X-Gm-Message-State: AOAM531XUUcBqSB+s4g91DYMbTJ9W6Yx+BL6pdz15wkZ4o/Lgndoz3vJ
 ni7J7SLGtVH/acsXejswtG3U5w==
X-Google-Smtp-Source: ABdhPJzKmpUihyVIHd9cxsIGck0LnT5sXqaA34p4IFpjbGtlOfF8Eg8k9JB/wHFNggITLsEovYzBow==
X-Received: by 2002:a05:6638:4781:b0:31a:6f26:e8a7 with SMTP id
 cq1-20020a056638478100b0031a6f26e8a7mr364247jab.33.1648053082060; 
 Wed, 23 Mar 2022 09:31:22 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 r9-20020a6b6009000000b006412abddbbbsm178642iog.24.2022.03.23.09.31.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 09:31:21 -0700 (PDT)
Date: Wed, 23 Mar 2022 16:31:18 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 03/22] KVM: arm64: Support SDEI_VERSION hypercall
Message-ID: <YjtLVqBbL0jyFFZy@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-4-gshan@redhat.com>
 <YjoPxLAMIPobBzS0@google.com>
 <d8e151e5-080b-dc87-b7e0-9031a7928853@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d8e151e5-080b-dc87-b7e0-9031a7928853@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 23, 2022 at 08:46:40PM +0800, Gavin Shan wrote:
> Hi Oliver,
> 
> On 3/23/22 2:04 AM, Oliver Upton wrote:
> > On Tue, Mar 22, 2022 at 04:06:51PM +0800, Gavin Shan wrote:
> > > This supports SDEI_VERSION hypercall by returning v1.1, which is
> > > the specification version we're following. The vendor is set to
> > > 'KVM'.
> > > 
> > > Signed-off-by: Gavin Shan <gshan@redhat.com>
> > > ---
> > >   arch/arm64/kvm/sdei.c | 10 ++++++++++
> > >   1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> > > index 8a9b477b8977..5a3a64cd6e84 100644
> > > --- a/arch/arm64/kvm/sdei.c
> > > +++ b/arch/arm64/kvm/sdei.c
> > > @@ -118,6 +118,14 @@ static bool remove_all_vcpu_events(struct kvm_vcpu *vcpu,
> > >   	return pending;
> > >   }
> > > +static unsigned long hypercall_version(struct kvm_vcpu *vcpu)
> > > +{
> > > +	/* v1.1 and the vendor is KVM */
> > > +	return (1UL << SDEI_VERSION_MAJOR_SHIFT) |
> > > +	       (1UL << SDEI_VERSION_MINOR_SHIFT) |
> > > +	       0x4b564d;
> > 
> > It looks like the SDEI specification states that the vendor-defined
> > version number is 32 bits. Could we just use one of the
> > ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_{0,3} values instead?
> > 
> > ASCII 'KVM' is neat, but in reality guest software will just throw it in
> > a macro regardless. Might as well use one of the values we've already
> > trained it to use :-)
> > 
> > Also, it would appear that guest discovery of SDEI relies upon KVM
> > reporting a valid SDEI version. IMO, this patch should come at the very
> > end when KVM actually implements SDEI.
> > 
> 
> Yeah, I was sticky to the pattern of "KVM". However, I think it's good
> to reuse the existing one. Lets use ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2
> if you agree. Its first two characters are "VM" at least.

Sounds fine to me. The only other nit I'd say is we should define a
macro for it too, something like:

  #define KVM_SDEI_VENDOR	ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

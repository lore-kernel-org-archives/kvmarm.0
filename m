Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF75C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 06:47:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC9EF610D1
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 06:47:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC9EF610D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 501E14B10C;
	Fri, 24 Sep 2021 02:47:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3pwpkshnAfDa; Fri, 24 Sep 2021 02:47:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 109F04B09C;
	Fri, 24 Sep 2021 02:47:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9054B086
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 02:47:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pfSXkNOPsRVE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 02:47:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0280D4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 02:47:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632466057;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=j2KQr45baQYJYr6dUnfIDkxfbuPODwumfELuFXI+bXM=;
 b=JFr2AYqUFNoTFJzP3tyfjsxVBA68DricjWCc825kiZSSkBkuv/c3qesHCbu43s5LcWTydP
 A+pyl1SuISfvcmPwMAcE0vmmAkq2s/bxvez+wpU8aTgc2R20M8Khw8XJk6tflJW2c4eMJP
 h2Yu5VTfSOnU/BLT1meetIMGCGUwPqk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-SKTm9yDpNW-RQou3HfItXA-1; Fri, 24 Sep 2021 02:47:36 -0400
X-MC-Unique: SKTm9yDpNW-RQou3HfItXA-1
Received: by mail-ed1-f70.google.com with SMTP id
 n5-20020a05640206c500b003cf53f7cef2so9241241edy.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 23:47:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=j2KQr45baQYJYr6dUnfIDkxfbuPODwumfELuFXI+bXM=;
 b=KH7MoDmBQzJB41BuniG51LuLbdcuH4ciP8oUD42wNlWV7Fy6bEeLRBAsGADXpASN7U
 btQtk6XeFXY0PpPxYWyY8z284UpDDjEtcYHlCfHKbXhYwWVw4xTQ4++GggdvTRF/bzLP
 OhNCHiUFPpgkG/NWnumA0oqbFBP02wW9QOZy5WsrehKr5vwXkYPzLFSxXLpxn4K82YNo
 /0LsfYFLzZNVlW18/aAYHN1R7XtuAC/u3mKMsFAwJZbWNumuiapXgR18iTZ7PdQkoKv7
 glo0dmO9r6za5sRNn+8scYWJm7ya4ZydBe8/Awb7DuF3v0f7wQ5bYud8Qs9ASGhs5MS2
 oKiA==
X-Gm-Message-State: AOAM530OMIIAt2O2+/6UlzaFZ6q/r7eCwUtyuFqWyL7lCEfW7ukRZoOj
 v98Hfh1uBIV7U94uHONnqo6GKilVeeZBhEs1dhUkIrHIqwoTOFfW/sljT1ovC6Ip+cj3PYNoMM0
 ba9Jha3wUKkwbUAchlm/cU2CG
X-Received: by 2002:aa7:d459:: with SMTP id q25mr3275080edr.62.1632466055109; 
 Thu, 23 Sep 2021 23:47:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaN40OP+imxKFV5YmCeh+GS/xyWgZCQsY0YIEujkDc+8xVH6Bjx9zUITPQQ59lKIzSrEPQTw==
X-Received: by 2002:aa7:d459:: with SMTP id q25mr3275065edr.62.1632466054928; 
 Thu, 23 Sep 2021 23:47:34 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id z3sm4374149eju.34.2021.09.23.23.47.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Sep 2021 23:47:34 -0700 (PDT)
Date: Fri, 24 Sep 2021 08:47:32 +0200
From: Andrew Jones <drjones@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Message-ID: <20210924064732.xqv2xjya3pxgmwr2@gator.home>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
MIME-Version: 1.0
In-Reply-To: <YU0XIoeYpfm1Oy0j@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Fri, Sep 24, 2021 at 12:09:06AM +0000, Sean Christopherson wrote:
> On Thu, Sep 23, 2021, Oliver Upton wrote:
> > While x86 does not require any additional setup to use the ucall
> > infrastructure, arm64 needs to set up the MMIO address used to signal a
> > ucall to userspace. rseq_test does not initialize the MMIO address,
> > resulting in the test spinning indefinitely.
> > 
> > Fix the issue by calling ucall_init() during setup.
> > 
> > Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  tools/testing/selftests/kvm/rseq_test.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> > index 060538bd405a..c5e0dd664a7b 100644
> > --- a/tools/testing/selftests/kvm/rseq_test.c
> > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
> >  	 * CPU affinity.
> >  	 */
> >  	vm = vm_create_default(VCPU_ID, 0, guest_code);
> > +	ucall_init(vm, NULL);
> 
> Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
> going to remember to add this next time I write a common selftest, arm64 is the
> oddball here.
>

Yes, please. But, it'll take more than just adding a ucall_init(vm, NULL)
call to vm_create. We should also modify aarch64's ucall_init to allow
a *new* explicit mapping to be made. It already allows an explicit mapping
when arg != NULL, but we'll need to unmap the default mapping first, now.
The reason is that a unit test may not be happy with the automatically
selected address (that hasn't happened yet, but...) and want to set its
own.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

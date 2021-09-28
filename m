Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D829AC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 07:24:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 422D561058
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 07:24:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 422D561058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C3BC4B0EC;
	Tue, 28 Sep 2021 03:24:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Q6P4ydCE27i; Tue, 28 Sep 2021 03:24:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6714A19F;
	Tue, 28 Sep 2021 03:24:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A5D24A19F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 03:24:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X6D6Gtxh4dzK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 03:24:15 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF97240762
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 03:24:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632813854;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bWGC7oTmfGjxKcdKJd504L6aMYPeDx74J8LvM7PKm0s=;
 b=UXBo4Vt/JmParNzdvclNOlkKETqIKNyFTWuwxu3pVmo4OFfvkgo2VjvF0GIZm1G1GYKWNZ
 lSXVg92tivzGbB6sNWbLvM/tN8U+e+ip1pfFCASlKlepE00ORvFo7FM1SSGsAuupxEu8X5
 Pfs/RHRrMdlDxkEQPY+M0v2eRdw2P2A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-DXRZQwoiOqixlgcozkqGHg-1; Tue, 28 Sep 2021 03:24:13 -0400
X-MC-Unique: DXRZQwoiOqixlgcozkqGHg-1
Received: by mail-ed1-f72.google.com with SMTP id
 s12-20020a05640217cc00b003cde58450f1so20808957edy.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 00:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bWGC7oTmfGjxKcdKJd504L6aMYPeDx74J8LvM7PKm0s=;
 b=NbEavWjojoFlOZNLVYnI1rCzCFw0D7Hm55KE5yJMY6gB4jrDFMYJRIjly7SfQYHqUH
 XFyaSXCY+NIRjBy5/KsrPfo59C2qo2PEEJ7GCgu9OaMaACVwpZtlNN0/TgKyMMa2n0GA
 UWQ/xWGakx+MZJEwgN3XLVMX5IXPWdGpH6+Tsxf65iCdZkcjlOvCpOlJGCI6Wxnwy3tl
 WYxP9RvueTEDt9nw+xUcU0uljdojg5xvpnrvA/UKMV8z2uFjmHDyJL5kpqOMd5xwrWo5
 EKk+3h51PW/e0oOVq8KJYS9//+MCVQxLfiE7cnm+6irEMncR634hslms4aXk/C3pdPy3
 JpwA==
X-Gm-Message-State: AOAM530p3GcXBrRAJbEbh1p+l5oPrnb0B8VmkU4ZqdwaLemWJw9NU324
 oeSNvhm12Pg+YGWix2ooVRJCKMrNiKuxe/hk1BE8Qv4uwA2h0bTslBVzU39zPeX8ByGVvU0BH4u
 oCeYb74vz+dfl3Qll4zgFhJRv
X-Received: by 2002:a17:906:6c83:: with SMTP id
 s3mr5124256ejr.13.1632813852137; 
 Tue, 28 Sep 2021 00:24:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAUxOXAqxe7tw2Hl4EfMfwGMkveziu4koresAVxFaRgDKbcZMqmqP/pKKJj5b+3QAkJO8dxg==
X-Received: by 2002:a17:906:6c83:: with SMTP id
 s3mr5124236ejr.13.1632813851955; 
 Tue, 28 Sep 2021 00:24:11 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id q12sm9791038ejs.58.2021.09.28.00.24.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 00:24:11 -0700 (PDT)
Date: Tue, 28 Sep 2021 09:24:09 +0200
From: Andrew Jones <drjones@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Message-ID: <20210928072409.ks6b6u3rs7qngije@gator.home>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
 <20210924064732.xqv2xjya3pxgmwr2@gator.home>
 <YVIj+gExrHrjlQEm@google.com>
MIME-Version: 1.0
In-Reply-To: <YVIj+gExrHrjlQEm@google.com>
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

On Mon, Sep 27, 2021 at 08:05:14PM +0000, Sean Christopherson wrote:
> On Fri, Sep 24, 2021, Andrew Jones wrote:
> > On Fri, Sep 24, 2021 at 12:09:06AM +0000, Sean Christopherson wrote:
> > > On Thu, Sep 23, 2021, Oliver Upton wrote:
> > > > While x86 does not require any additional setup to use the ucall
> > > > infrastructure, arm64 needs to set up the MMIO address used to signal a
> > > > ucall to userspace. rseq_test does not initialize the MMIO address,
> > > > resulting in the test spinning indefinitely.
> > > > 
> > > > Fix the issue by calling ucall_init() during setup.
> > > > 
> > > > Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > ---
> > > >  tools/testing/selftests/kvm/rseq_test.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> > > > index 060538bd405a..c5e0dd664a7b 100644
> > > > --- a/tools/testing/selftests/kvm/rseq_test.c
> > > > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > > > @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
> > > >  	 * CPU affinity.
> > > >  	 */
> > > >  	vm = vm_create_default(VCPU_ID, 0, guest_code);
> > > > +	ucall_init(vm, NULL);
> > > 
> > > Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
> > > going to remember to add this next time I write a common selftest, arm64 is the
> > > oddball here.
> 
> Ugh, reading through arm64's ucall_init(), moving this to vm_create() is a bad
> idea.  If a test creates memory regions at hardcoded address, the test could
> randomly fail if ucall_init() selects a conflicting address.  More below.
> 
> > Yes, please. But, it'll take more than just adding a ucall_init(vm, NULL)
> > call to vm_create. We should also modify aarch64's ucall_init to allow
> > a *new* explicit mapping to be made. It already allows an explicit mapping
> > when arg != NULL, but we'll need to unmap the default mapping first, now.
> > The reason is that a unit test may not be happy with the automatically
> > selected address (that hasn't happened yet, but...) and want to set its
> > own.
> 
> My vote would be to rework arm64's ucall_init() as a prep patch and drop the param
> in the process.  There are zero tests that provide a non-NULL value, but that's
> likely because tests that care deliberately defer ucall_init() until after memory
> regions and page tables have been configured.
> 
> IMO, arm64's approach is unnecessarily complex (that's a common theme for KVM's
> selftests...).  The code attempts to avoid magic numbers by not hardcoding the MMIO
> range, but in doing so makes the end result even more magical, e.g. starting at
> 5/8ths of min(MAX_PA, MAX_VA).
> 
> E.g. why not put the ucall MMIO range immediately after the so called "default"
> memory region added at the end of vm_create()?  That way the location of the ucall
> range is completely predictable, and while still arbitrary, less magical.
>

While we do hardcode zero as the guest physical base address, we don't
require tests to use DEFAULT_GUEST_PHY_PAGES for slot0. They only get
that if they use vm_create_default* to create the vm. While trying to
keep the framework flexible for the unit tests does lead to complexity,
I think the ucall mmio address really needs to be something that can move.
It's not part of the test setup, i.e. whatever the unit test wants to
test, it's just part of the framework. It needs to stay out of the way.

You're right that we can't improve things by adding ucall_init to
vm_create though, even if we added my suggestion of changing ucall_init
to be an unmap-old, map-new type of thing, since we'd still always need
the deferred ucall_init call to be sure we got it right.

We could replace the mmio address search with a hardcoded default address
though, probably the start address of the search (most likely that's the
one that's always used). Then, if there's a problem with that address,
an explicit ucall_init with its optional argument would need to be
provided in the unit test, along with a comment explaining why it's
there to ensure nobody removes it.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

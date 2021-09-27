Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A720CC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 20:05:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 184BC60FED
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 20:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 184BC60FED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B904B0B9;
	Mon, 27 Sep 2021 16:05:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J6U0mdJeNHBg; Mon, 27 Sep 2021 16:05:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D3FB4B093;
	Mon, 27 Sep 2021 16:05:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32BA74B08A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 16:05:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MT2fGexgxk9K for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 16:05:20 -0400 (EDT)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D0CB4A98B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 16:05:20 -0400 (EDT)
Received: by mail-pf1-f175.google.com with SMTP id k26so12309665pfi.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 13:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=J1OTP+7DOGmeKvtWkpynSAHibvAphxBoBf7TlJ1W75g=;
 b=nJh8y9Ji6F34ZL+jQC5GvuQsdn5mLwOEp8jloJUDmMe6dn3HrdoI/S/FslqkPVgtgh
 xKjv46ot3H+sEkrUr3qHSBTFbHa+owZkstZR5JBmM58W4ka0J3+XU890WfZgQ92ELms3
 7Ifyncde5P2FEeumN+HL3eg3VYKdnsuCVs905IJP3D9NGkuCAk49lQ286dmIV/zoeuY1
 OH5jdcRW0CDNLKmGnDLvIbx0GIPiSvh6mteEIVaa2231AnsJFSjZHYarcSnZexORgcFx
 ipYHtuIOyhe5oHruK/O8EBryz6Vd9zZzKrqJ894QDcOvAG845h6P2g9WYbpb5HD74Ui/
 IKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=J1OTP+7DOGmeKvtWkpynSAHibvAphxBoBf7TlJ1W75g=;
 b=G8R9NfOAdXbU7jx81pspFWtqEB2/SY2nkFcCZ4dFZqMwTkoXfwmTFZIFJY+C4bczu1
 ZtngawtxUYy5qizl8mBBK0d7SgqexO8QeQYGgH6ltPpYL3o56EnBFjoIFZ5y2J/0rd2T
 qlV87ueY8yvYMJRDxXaV9r4nIS0g3YKp345eJ7H4U/YgENO4Hi8xeJ2hC1NYqiNEyo6o
 EwMNgR3H5++HgygxLgWD9unxBUJe3gziAryqxCsLHptKVW/b3/5foAO3MA/O8NbJ1JfJ
 2dduWCLoeWp0ZQh/X77y+Dh+AZnK1xEMq+wAypZQFeCveTin50HuOWH6xrZ+wYlAMt8C
 rV5A==
X-Gm-Message-State: AOAM532PttXHx+0AvxCl4LSHysEwQBKe7+5IOz9Voaq/JJdRBum93BVp
 S1TU5YbLQgSEm7jrqUd1c5LwlQ==
X-Google-Smtp-Source: ABdhPJxTlxHvtc5rugG/tFQUBdwxNnPR3lb994WAssd3KxL7MTB0W9h/Ymf1p6dZMMoJeUKmlzLzpA==
X-Received: by 2002:a63:4f0f:: with SMTP id d15mr1226386pgb.464.1632773118918; 
 Mon, 27 Sep 2021 13:05:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id 2sm252633pjt.23.2021.09.27.13.05.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 13:05:18 -0700 (PDT)
Date: Mon, 27 Sep 2021 20:05:14 +0000
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Message-ID: <YVIj+gExrHrjlQEm@google.com>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
 <20210924064732.xqv2xjya3pxgmwr2@gator.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210924064732.xqv2xjya3pxgmwr2@gator.home>
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

On Fri, Sep 24, 2021, Andrew Jones wrote:
> On Fri, Sep 24, 2021 at 12:09:06AM +0000, Sean Christopherson wrote:
> > On Thu, Sep 23, 2021, Oliver Upton wrote:
> > > While x86 does not require any additional setup to use the ucall
> > > infrastructure, arm64 needs to set up the MMIO address used to signal a
> > > ucall to userspace. rseq_test does not initialize the MMIO address,
> > > resulting in the test spinning indefinitely.
> > > 
> > > Fix the issue by calling ucall_init() during setup.
> > > 
> > > Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/rseq_test.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> > > index 060538bd405a..c5e0dd664a7b 100644
> > > --- a/tools/testing/selftests/kvm/rseq_test.c
> > > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > > @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
> > >  	 * CPU affinity.
> > >  	 */
> > >  	vm = vm_create_default(VCPU_ID, 0, guest_code);
> > > +	ucall_init(vm, NULL);
> > 
> > Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
> > going to remember to add this next time I write a common selftest, arm64 is the
> > oddball here.

Ugh, reading through arm64's ucall_init(), moving this to vm_create() is a bad
idea.  If a test creates memory regions at hardcoded address, the test could
randomly fail if ucall_init() selects a conflicting address.  More below.

> Yes, please. But, it'll take more than just adding a ucall_init(vm, NULL)
> call to vm_create. We should also modify aarch64's ucall_init to allow
> a *new* explicit mapping to be made. It already allows an explicit mapping
> when arg != NULL, but we'll need to unmap the default mapping first, now.
> The reason is that a unit test may not be happy with the automatically
> selected address (that hasn't happened yet, but...) and want to set its
> own.

My vote would be to rework arm64's ucall_init() as a prep patch and drop the param
in the process.  There are zero tests that provide a non-NULL value, but that's
likely because tests that care deliberately defer ucall_init() until after memory
regions and page tables have been configured.

IMO, arm64's approach is unnecessarily complex (that's a common theme for KVM's
selftests...).  The code attempts to avoid magic numbers by not hardcoding the MMIO
range, but in doing so makes the end result even more magical, e.g. starting at
5/8ths of min(MAX_PA, MAX_VA).

E.g. why not put the ucall MMIO range immediately after the so called "default"
memory region added at the end of vm_create()?  That way the location of the ucall
range is completely predictable, and while still arbitrary, less magical.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

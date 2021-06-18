Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A46C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:23:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5441F613AA
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:23:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5441F613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD832407F1;
	Fri, 18 Jun 2021 04:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E4nMSQsTbMys; Fri, 18 Jun 2021 04:23:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90A794A522;
	Fri, 18 Jun 2021 04:23:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CBAE4A4E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:23:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pYlx0dO0uYkz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 04:23:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0043F407F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:23:43 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C11F6121D;
 Fri, 18 Jun 2021 08:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1624004622;
 bh=8kIa5sNlt0Pl69kW6P6wTngWvlRlxxluJS87VDmBN58=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=UCkJDdBNLND5GZiz2ir5ovYNPwCGZK758duSM4PdsRVPZV0Mhoa2Lr/wFa597auAS
 Cg+eqS67Tefemzt2Ct2SrkgUota8ywVzoO3dhRgt/YFEZjUwVRJfaawwoZRqyFAIXF
 htQDGfut8cBg5MTrkT24Anjlgi3/h5hx6t3dhEGU=
Date: Fri, 18 Jun 2021 10:23:39 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Paolo Bonzini <bonzini@gnu.org>
Subject: Re: [PATCH v11 2/7] KVM: stats: Add fd-based API to read binary
 stats data
Message-ID: <YMxYC8syYRBhbBAq@kroah.com>
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-3-jingzhangos@google.com>
 <YMxEqvKyGnZinMOS@kroah.com>
 <f2616b8e-0cf8-570f-4bd3-7ef5cbcb37b0@gnu.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f2616b8e-0cf8-570f-4bd3-7ef5cbcb37b0@gnu.org>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
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

On Fri, Jun 18, 2021 at 10:02:57AM +0200, Paolo Bonzini wrote:
> On 18/06/21 09:00, Greg KH wrote:
> > > +struct kvm_stats_header {
> > > +	__u32 name_size;
> > > +	__u32 count;
> > > +	__u32 desc_offset;
> > > +	__u32 data_offset;
> > > +	char id[];
> > > +};
> > 
> > You mentioned before that the size of this really is the size of the
> > structure + KVM_STATS_ID_MAXLEN, right?  Or is it - KVM_STATS_ID_MAXLEN?
> > 
> > If so, why not put that value explicitly in:
> > 	char id[THE_REST_OF_THE_HEADER_SPACE];
> > 
> > As this is not a variable header size at all, and you can not change it
> > going forward, so the variable length array here feels disingenuous.
> 
> It can change; the header goes up to desc_offset.  Let's rename desc_offset
> to header_size.

"Traditionally" the first field of a variable length structure like this
has the size.  So maybe this needs to be:

struct kvm_stats_header {
	__u32 header_size;
	__u32 name_size;
	__u32 num_desc;
	__u32 desc_offset;
	__u32 data_offset;
	char id[];
};

I just guessed at what "count" is as I do not remember at the moment,
but obviously "count" wasn't descriptive :)

Wait, what is "name_size" here for?

> > > +struct kvm_stats_desc {
> > > +	__u32 flags;
> > > +	__s16 exponent;
> > > +	__u16 size;
> > > +	__u32 offset;
> > > +	__u32 unused;
> > > +	char name[];
> > > +};
> > 
> > What is the max length of name?
> 
> It's name_size in the header.

So it's specified in the _previous_ header?  That feels wrong, shouldn't
this descriptor define what is in it?

I'm not trying to nit-pick here, I'm actually confused now.  Structures
that contain "headers" should have in those headers at least two things:
	- declare the size of themselves if they are variable length
	- declare offsets to other structures

Don't put a size in this header for the size of a later structure,
that's just extra complexity that is not needed.

Think of this as a stream of bytes across the wire like a hardware
descriptor.  We have loads of experience dealing with this with
protocols like USB and Greybus and PCI and the like.  Let's learn from
those experiences and not try to mess things up where we don't need to
:)


> 
> > Why aren't these structures defined here in kerneldoc so that we can
> > understand them better?  Putting them in a .rst file guarantees they
> > will get out of sync, and you can always directly import the kerneldoc
> > into the .rst file.
> 
> This is a problem in general with Documentation/virt/kvm/api.rst.  The file
> is organized to match the kerneldoc structs to the ioctl that they are used
> for, and sometimes a ioctl includes different structs for each architecture.
> 
> It is probably possible to do it using :identifiers: and/or :doc:, but it
> would require running scripts/kernel-doc on the uAPI headers dozens of
> times.  That is quite expensive at 0.3s each run, but that's what you get
> with Perl (gcc -fsyntax-only is 20 times faster).

Is that what v4l and drm do today?  That's still safer and more
"obvious" than trying to keep two different files in sync which, as I
well know, almost impossible to do well over the _years_ in which you
will have to maintain these files.

Let's make it easier for everyone, put it only in one place and if
people want to see the documentation, they can generate it (it's
auto-generated on kernel.org anyway), no need to worry about multiple
passes or not.

thanks,

greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

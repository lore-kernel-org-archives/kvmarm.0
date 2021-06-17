Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D548C2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 11:43:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B0108613F1
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 11:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0108613F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42F4B49F92;
	Thu, 17 Jun 2021 07:43:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9ASI8SwbvLAE; Thu, 17 Jun 2021 07:43:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C17340874;
	Thu, 17 Jun 2021 07:43:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59BF740874
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:43:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 16t1XvnfAyhI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 07:42:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D7C44086A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:42:59 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB03B613FE;
 Thu, 17 Jun 2021 11:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1623930178;
 bh=+rV2EQw4mSBWtxauWo8Ivv6JJIjCR1BlgSQtCti76T4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=fOsz88jdOjhZ6ScuC0eG149FufoNS0FvGcFvsN69ADiQV5mtHh1W87F+LbRS8yvVo
 mbmy2yIjlKp44Se/pz59+wlrtaiRV/m81uwUJ0a6bMI1jGc8ExV0kvEn0W5446aUVQ
 3NzuOTVD5WkCd7FwIPYkOZszEcVq8A8n4m8GhHS4=
Date: Thu, 17 Jun 2021 13:42:55 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH v10 3/5] KVM: stats: Add documentation for binary
 statistics interface
Message-ID: <YMs1Pwf+nSQsfVUW@kroah.com>
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-4-jingzhangos@google.com>
 <YMrkGZzPrt0jA1iP@kroah.com>
 <0d959828-da89-bceb-f7cc-35622a60c431@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0d959828-da89-bceb-f7cc-35622a60c431@redhat.com>
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

On Thu, Jun 17, 2021 at 01:29:22PM +0200, Paolo Bonzini wrote:
> On 17/06/21 07:56, Greg KH wrote:
> > On Thu, Jun 17, 2021 at 04:41:44AM +0000, Jing Zhang wrote:
> > > +	struct kvm_stats_desc {
> > > +		__u32 flags;
> > > +		__s16 exponent;
> > > +		__u16 size;
> > > +		__u32 offset;
> > > +		__u32 unused;
> > > +		char name[0];
> > > +	};
> > 
> > <snip>
> > 
> > > +The ``unused`` fields are reserved for future support for other types of
> > > +statistics data, like log/linear histogram.
> > 
> > you HAVE to set unused to 0 for now, otherwise userspace does not know
> > it is unused, right?
> 
> Jing, I think you planned to use it with other flags that are unused for
> now?  But please do check that it's zero in the testcase.
> 
> > It is not a pointer, it is the data itself.
> > 
> > > +string starts at the end of ``struct kvm_stats_desc``.
> > > +The maximum length (including trailing '\0') is indicated by ``name_size``
> > > +in ``struct kvm_stats_header``.
> > 
> > I thought we were replacing [0] arrays with [], are you sure you should
> > be declaring this as [0]?  Same for all structures in this document (and
> > code).
> 
> In C code [0] is a bit more flexible than [].  I think in this particular
> case [] won't work due to how the structures are declared. In the
> documentation [] is certainly clearer.

Look at all of the patches that Gustavo has been doing all over the tree
for this work, you do not want to make him do this again here.

Gustavo, is [0] ok for fields like these?

thanks,

greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

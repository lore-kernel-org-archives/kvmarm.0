Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71B6C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:31:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 242BA61396
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:31:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 242BA61396
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A574A40FC7;
	Fri, 18 Jun 2021 04:31:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MTrS8nNAJf3u; Fri, 18 Jun 2021 04:31:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F129040870;
	Fri, 18 Jun 2021 04:31:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72B4140870
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:31:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zti71tq4Pa0q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 04:31:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25150407F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:31:25 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F5C860FF0;
 Fri, 18 Jun 2021 08:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1624005084;
 bh=IlI2xoknvp6cj5Rqd8Uau9s9Kd6ZolRir32me078cFs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=PIyln4rhWLixs0LTS7Bu13tEWBmArcje3C0Q9GU2Hl/4kYAZ+8gKQnXA0MlPaVoDW
 p4zawkMPjCt5QhuU3d1fjFoKAPJYJ8k43KS60RjuCpcGZZT8diWmrOt+7jTvWZdxGa
 dDrWh0bN0ZTXeA3YdzopcLfHGTbgk+y5u+9NKB3M=
Date: Fri, 18 Jun 2021 10:31:21 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v11 5/7] KVM: stats: Add documentation for binary
 statistics interface
Message-ID: <YMxZ2Z9s5YRvhetZ@kroah.com>
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-6-jingzhangos@google.com>
 <YMxE8pUrbQkwlpbD@kroah.com>
 <0036c55a-72d6-7b5c-a6fd-3a285476e522@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0036c55a-72d6-7b5c-a6fd-3a285476e522@redhat.com>
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

On Fri, Jun 18, 2021 at 10:26:59AM +0200, Paolo Bonzini wrote:
> On 18/06/21 09:02, Greg KH wrote:
> > > +	struct kvm_stats_desc {
> > > +		__u32 flags;
> > > +		__s16 exponent;
> > > +		__u16 size;
> > > +		__u32 offset;
> > > +		__u32 unused;
> > > +		char name[];
> > > +	};
> > As I mention in another patch, this should be sucked in directly from
> > the .h file in kerneldoc format, so that everything stays in sync.  I
> > bet almost this whole file can be put into the .h file, look at how drm
> > and v4l2 does this in a way that you only have to write the above one
> > time, not try to keep it in sync in two different places.
> 
> V4L's userspace-api/media/v4l is absurdly good and I'd say it's by far the
> best documentation of any Linux subsystem, but it's all handwritten just
> like in KVM.  In fact, grepping for kernel-doc directives in Documentation/
> gives no hits for the V4L uAPI documentation.
> 
> DRM has great kernel documentation, but quality-wise the KVM userland
> documentation is on a completely different level compared to DRM; just
> compare https://www.kernel.org/doc/html/latest/virt/kvm/api.html to
> https://www.kernel.org/doc/html/latest/gpu/drm-uapi.html.  The latter is not
> about how to use the DRM interfaces from userspace, it's about how to
> implement the userspace interfaces.  It is full of kernel struct definitions
> that should have no place in a uAPI manual, and does not include
> documentation for almost anything in include/uapi/drm/drm.h

Ok, it's your maintenance burden, not mine, I was just suggesting a way
to make it easier :)

I'll not complain about this anymore...

thanks,

greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

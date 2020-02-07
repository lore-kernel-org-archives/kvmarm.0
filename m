Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BC9C2BA83
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 21:46:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E82D20720
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 21:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cY0noU41"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E82D20720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3C94A4F7;
	Fri,  7 Feb 2020 16:46:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d6wBDzBnE22O; Fri,  7 Feb 2020 16:46:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B03784A4C0;
	Fri,  7 Feb 2020 16:46:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C18D4A4AA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 16:46:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QOXwJM6z3VXt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 16:46:30 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 080744A4A9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 16:46:29 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581111989;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WG242BmndwBfu/MjtxpwMCr6pklOwypN4g+lYWDvs4k=;
 b=cY0noU41qv2oJaRFBzIIA3AWMyH1CT7lRzxaH/xF3UBNdQKdQypJaOBsQYOPy+ssYLP0yY
 /XRC9bmcZPKbO6sbyQb9dZZcUsfx9jJV9pNJUPnB+Fx6EsUcS6NiwVU/X7c8ktcV15QJjt
 jhViG/hkfkRG+KlH9neTczfnacCYojo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-lFUxCFntPICfB_hlwkkA5Q-1; Fri, 07 Feb 2020 16:46:27 -0500
Received: by mail-qk1-f198.google.com with SMTP id q2so378589qkq.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 13:46:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vVYpZUcLEUs3sOrjbIqPes1hb8KpqKLOy5PIHOTaenw=;
 b=MfBaicwg0Xl1hUnUZKsqAhJNG4vzruRqYB4tEB3JfsXyH1y0uFtdyc5SmoHnBOmZSD
 GyPZPubHooJ1IxnWl9HDi1AlQxfHOErpAnSCidppVTGr34RO1GM2m5ZrvJlgEMFvGcrn
 Qcy34tbJydl5Rwg96IJWibKUr5VWvgF7pud24FHpCJ8fdnjQIz8akbYCuibzYGwDuxvi
 FCiOjwB+i8yBZCymwcD7O0whGGayILvH78VfCh0lTXBAeeQL/pQJoeD5ZGRvdnvgWlmO
 fB8Xwc5cHVoUueKGRWXMZ2+yZGBvFzGXvGjK+T0ZSzZbK5xuRJ4rRoZBy69q/JOM8mvG
 MvXQ==
X-Gm-Message-State: APjAAAWfCUAo479WheA6jlN/fGVOOo/ov6+523Bt8rBJcki3b3nN2SiF
 B2ZG1jbib91mRVsC29RDoK5EStEr83Goi0bqul8Fv17DZlMrgugPmUnR/BUGccswXxE7gmvlc0q
 hE44stUrDToocXKVtqSdItkb1
X-Received: by 2002:ae9:e910:: with SMTP id x16mr988275qkf.90.1581111987472;
 Fri, 07 Feb 2020 13:46:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwxRGnu4XDnzwjnf0DDkOxM5HXmG3kOePeoAJPNmuK0HFHObXtw0rsBdJC1716CoqHguYzOkw==
X-Received: by 2002:ae9:e910:: with SMTP id x16mr988252qkf.90.1581111987166;
 Fri, 07 Feb 2020 13:46:27 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id t16sm1892401qkg.96.2020.02.07.13.46.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Feb 2020 13:46:26 -0800 (PST)
Date: Fri, 7 Feb 2020 16:46:23 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 17/19] KVM: Terminate memslot walks via used_slots
Message-ID: <20200207214623.GF720553@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-18-sean.j.christopherson@intel.com>
 <20200206210944.GD700495@xz-x1>
 <20200207183325.GI2401@linux.intel.com>
 <20200207203909.GE720553@xz-x1>
 <20200207211016.GN2401@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200207211016.GN2401@linux.intel.com>
X-MC-Unique: lFUxCFntPICfB_hlwkkA5Q-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On Fri, Feb 07, 2020 at 01:10:16PM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2020 at 03:39:09PM -0500, Peter Xu wrote:
> > On Fri, Feb 07, 2020 at 10:33:25AM -0800, Sean Christopherson wrote:
> > > On Thu, Feb 06, 2020 at 04:09:44PM -0500, Peter Xu wrote:
> > > > On Tue, Jan 21, 2020 at 02:31:55PM -0800, Sean Christopherson wrote:
> > > > > @@ -9652,13 +9652,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > > >  		if (IS_ERR((void *)hva))
> > > > >  			return PTR_ERR((void *)hva);
> > > > >  	} else {
> > > > > -		if (!slot->npages)
> > > > > +		if (!slot || !slot->npages)
> > > > >  			return 0;
> > > > >  
> > > > > -		hva = 0;
> > > > > +		hva = slot->userspace_addr;
> > > > 
> > > > Is this intended?
> > > 
> > > Yes.  It's possible to allow VA=0 for userspace mappings.  It's extremely
> > > uncommon, but possible.  Therefore "hva == 0" shouldn't be used to
> > > indicate an invalid slot.
> > 
> > Note that this is the deletion path in __x86_set_memory_region() not
> > allocation.  IIUC userspace_addr won't even be used in follow up code
> > path so it shouldn't really matter.  Or am I misunderstood somewhere?
> 
> No, but that's precisely why I don't want to zero out @hva, as doing so
> implies that '0' indicates an invalid hva, which is wrong.
> 
> What if I change this to 
> 
> 			hva = 0xdeadull << 48;
> 
> and add a blurb in the changelog about stuff hva with a non-canonical value
> to indicate it's being destroyed.

IMO it's fairly common to have the case where "when A is XXX then
parameters B is invalid" happens in C.  OK feel free to keep any of
these as you prefer (how many times I spoke this only for today? :) as
long as the maintainers are fine with it.  And for sure an extra
comment would always be nice.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

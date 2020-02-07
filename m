Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B69EC35242
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 22:24:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7B0720720
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 22:24:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IZBWHpIA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7B0720720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 089184A598;
	Fri,  7 Feb 2020 17:24:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fhe9+UqTWXvt; Fri,  7 Feb 2020 17:24:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB6CB4A50F;
	Fri,  7 Feb 2020 17:24:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCEA14A50F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 17:24:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d1FYD5QuFTl7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 17:24:45 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86B654A389
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 17:24:45 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581114285;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=8RjmlokPjnkH8oZxzrYec3fZUGAfizyuGXB6oCxb2rQ=;
 b=IZBWHpIAcZRy1Z7ensrxvtWOArn6t0SSsKLt7D+kio0hX62LLxvKHph7hEpR7r/zKowrvb
 m5ADt4WRbn+KfOqlaYoW9LdOEIRhEMuMuRrvoNWzmr19nLNtTo4wD3xcfHvRES26VSi32r
 3UcrQmx+P2L3IBoqLjidLQW/9eOGxxc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-0A_oMxaVNfKTsfvv6imluw-1; Fri, 07 Feb 2020 17:24:42 -0500
Received: by mail-qk1-f200.google.com with SMTP id q135so442376qke.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 14:24:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JRnjR1s6c5pJE2ossLQbJM2NZYkPQ/exCWBRJ0Gziy8=;
 b=lItpmeocQIr5XSnQ1svoFCU4d8+gOES4teyctCYKCUfbGCJUSFx4YXngBwZZT2NLCs
 BjOt4rBotFYUwZvuQN21GaVf4JH+UvwdPxlKlyssfUZi9IjYn2oooLYchhtloo9zYMKk
 aVuyPpiMvu6XtwKOyiExdWm7fxD9xPsnbfrtLWaxt7AfqO+8nv7IMrBRwJKyuUfra+G1
 67sZSbEomRq1a4nQFoS5SG378kcvPlkyX25MiCRbCsDgZilRunMIDd3TxGWhl3v9bpmu
 jhUJ4x6uLsLzxfx6Fl6WM+4FLMDiPKtJZC4zBLo+0yIuYUsNaJ8Eltfu4lf16MdY9UTt
 g+wA==
X-Gm-Message-State: APjAAAV1mXp60UXLimzS+GLNPbg+cYVHKiSY7eL9LRqwNomjbern3ZlV
 wgIrFK12CNhhf81bucvfpWeET3a5cDtw961/giuQoBH5gmGBfyMOCqpn3Ok1slRXkM2pwYDEfYe
 w+Bxzghay4o2jjv2zSVA1i4FO
X-Received: by 2002:a37:c53:: with SMTP id 80mr1117251qkm.285.1581114282356;
 Fri, 07 Feb 2020 14:24:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdmbvsmW8pfTDFhkNFpJOBOyIyACeKZQZlqIgbOpE5taqn1c19m2GAF/qQjzf2ieRiXzn8Xg==
X-Received: by 2002:a37:c53:: with SMTP id 80mr1117228qkm.285.1581114282106;
 Fri, 07 Feb 2020 14:24:42 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id j1sm1933090qkl.86.2020.02.07.14.24.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Feb 2020 14:24:41 -0800 (PST)
Date: Fri, 7 Feb 2020 17:24:38 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 17/19] KVM: Terminate memslot walks via used_slots
Message-ID: <20200207222438.GH720553@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-18-sean.j.christopherson@intel.com>
 <20200206210944.GD700495@xz-x1>
 <20200207183325.GI2401@linux.intel.com>
 <20200207203909.GE720553@xz-x1>
 <20200207211016.GN2401@linux.intel.com>
 <20200207214623.GF720553@xz-x1>
 <20200207220325.GO2401@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200207220325.GO2401@linux.intel.com>
X-MC-Unique: 0A_oMxaVNfKTsfvv6imluw-1
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

On Fri, Feb 07, 2020 at 02:03:25PM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2020 at 04:46:23PM -0500, Peter Xu wrote:
> > On Fri, Feb 07, 2020 at 01:10:16PM -0800, Sean Christopherson wrote:
> > > On Fri, Feb 07, 2020 at 03:39:09PM -0500, Peter Xu wrote:
> > > > On Fri, Feb 07, 2020 at 10:33:25AM -0800, Sean Christopherson wrote:
> > > > > On Thu, Feb 06, 2020 at 04:09:44PM -0500, Peter Xu wrote:
> > > > > > On Tue, Jan 21, 2020 at 02:31:55PM -0800, Sean Christopherson wrote:
> > > > > > > @@ -9652,13 +9652,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > > > > >  		if (IS_ERR((void *)hva))
> > > > > > >  			return PTR_ERR((void *)hva);
> > > > > > >  	} else {
> > > > > > > -		if (!slot->npages)
> > > > > > > +		if (!slot || !slot->npages)
> > > > > > >  			return 0;
> > > > > > >  
> > > > > > > -		hva = 0;
> > > > > > > +		hva = slot->userspace_addr;
> > > > > > 
> > > > > > Is this intended?
> > > > > 
> > > > > Yes.  It's possible to allow VA=0 for userspace mappings.  It's extremely
> > > > > uncommon, but possible.  Therefore "hva == 0" shouldn't be used to
> > > > > indicate an invalid slot.
> > > > 
> > > > Note that this is the deletion path in __x86_set_memory_region() not
> > > > allocation.  IIUC userspace_addr won't even be used in follow up code
> > > > path so it shouldn't really matter.  Or am I misunderstood somewhere?
> > > 
> > > No, but that's precisely why I don't want to zero out @hva, as doing so
> > > implies that '0' indicates an invalid hva, which is wrong.
> > > 
> > > What if I change this to 
> > > 
> > > 			hva = 0xdeadull << 48;
> > > 
> > > and add a blurb in the changelog about stuff hva with a non-canonical value
> > > to indicate it's being destroyed.
> > 
> > IMO it's fairly common to have the case where "when A is XXX then
> > parameters B is invalid" happens in C.
> 
> I'm not arguing that's not the case.  My point is that there's nothing
> special about '0', so why use it?  E.g. "hva = 1" would also be ok from a
> functional perspective, but more obviously "wrong".

I think the answer is as simple as the original author thought 0 was
better than an arbitrary number on the stack, which I agree. :-)

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

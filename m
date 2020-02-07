Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DB5C35242
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 18:18:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A4B120726
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 18:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AEKvEFJw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A4B120726
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2FCF4A534;
	Fri,  7 Feb 2020 13:18:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nELIVK+Xsigr; Fri,  7 Feb 2020 13:17:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 869064A524;
	Fri,  7 Feb 2020 13:17:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4BC14A524
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 13:17:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zsxz9F2V6Fqg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 13:17:56 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E43794A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 13:17:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581099476;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zZJ4qP8Dp5obTldW76MuAHNAAKAcx/3dX73hUB9dtQo=;
 b=AEKvEFJwZ88mn5VJ6/9cgwIiJ34mmci8v5WOgG2AAfiWBgI/6oDWya/HncVKgw4JiljwwM
 l/ZrYNGSi/hInjiMLKLJXwdCxKduWfXbIsfqECJLP4NqQTPRMKTD7YDGV+yxgo6IeBBvcs
 P2Tclz4hO4X2CrTMMwYcbQr/kJ0ZKg4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-m79cGzc4PBmwhbjngUuWXw-1; Fri, 07 Feb 2020 13:17:52 -0500
Received: by mail-qv1-f71.google.com with SMTP id r9so55078qvs.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 10:17:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cPT63VS6JkFJRjpL5MMsWxNfN8Beu47vJy8tbC2r7XM=;
 b=VJuMquJizhDxFiNaQ4/OsLZpRIZP5N1lUVuaTRkOBEtrfV7q2G767iTPkbGoFAzUbc
 WVFvKRfwVoqCpU9zyDn/pFQFshbcQoudNXodXise/fjUHiKQDpvYzXWfOYu191uKvowF
 MtgsujtRQr8I8ZibCTX+oZjRfdDnQbUpAgvmd4KYPrjzf7lpISgAifOTzCksrWIsnW4L
 lkA11HMjHOZHWPVHhB9nkWL6HrmiZ+gm/gD+Un2YW+oCofGv27fZ+ZhWz8VZ1U2yEHN3
 wGoHZYNy7aFiA2av3rfYPJLvDGCLNpa9HCmZYH3xBZ5I/7/AhYScGSB9bDOz9fARV9cK
 txUQ==
X-Gm-Message-State: APjAAAU/UTyvC7cojke8Q5vCF8RH6+5CDKMAKwVe4EgQMj5a7KSY/ONv
 5ROVLzWpBesmLzUyR4Cg9AQZUxESIl1r3eOJ3O5VkG48/ROKc7ttPk2B73UAu0chCq7glS4GQhR
 sp4/AA6EN8UE8B8Q5Zt8l08p2
X-Received: by 2002:a05:6214:1253:: with SMTP id
 q19mr106732qvv.75.1581099472153; 
 Fri, 07 Feb 2020 10:17:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqzRox8Bo7fyFYmNOjYNh/V3B0M3O5rtHPF6if8Y080MuT3a3U4ayt/3NWDSUCkErG4IzY/vdw==
X-Received: by 2002:a05:6214:1253:: with SMTP id
 q19mr106704qvv.75.1581099471868; 
 Fri, 07 Feb 2020 10:17:51 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id b24sm1725899qto.71.2020.02.07.10.17.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Feb 2020 10:17:51 -0800 (PST)
Date: Fri, 7 Feb 2020 13:17:48 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 12/19] KVM: Move memslot deletion to helper function
Message-ID: <20200207181748.GC720553@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-13-sean.j.christopherson@intel.com>
 <20200206161415.GA695333@xz-x1>
 <20200206162818.GD13067@linux.intel.com>
 <20200206165116.GE695333@xz-x1>
 <20200207175912.GG2401@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200207175912.GG2401@linux.intel.com>
X-MC-Unique: m79cGzc4PBmwhbjngUuWXw-1
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

On Fri, Feb 07, 2020 at 09:59:12AM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 11:51:16AM -0500, Peter Xu wrote:
> > On Thu, Feb 06, 2020 at 08:28:18AM -0800, Sean Christopherson wrote:
> > > On Thu, Feb 06, 2020 at 11:14:15AM -0500, Peter Xu wrote:
> > > > On Tue, Jan 21, 2020 at 02:31:50PM -0800, Sean Christopherson wrote:
> > > > > Move memslot deletion into its own routine so that the success path for
> > > > > other memslot updates does not need to use kvm_free_memslot(), i.e. can
> > > > > explicitly destroy the dirty bitmap when necessary.  This paves the way
> > > > > for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> > > > > NULL for @dont.
> > > > > 
> > > > > Add a comment above the code to make a copy of the existing memslot
> > > > > prior to deletion, it is not at all obvious that the pointer will become
> > > > > stale during sorting and/or installation of new memslots.
> > > > 
> > > > Could you help explain a bit on this explicit comment?  I can follow
> > > > up with the patch itself which looks all correct to me, but I failed
> > > > to catch what this extra comment wants to emphasize...
> > > 
> > > It's tempting to write the code like this (I know, because I did it):
> > > 
> > > 	if (!mem->memory_size)
> > > 		return kvm_delete_memslot(kvm, mem, slot, as_id);
> > > 
> > > 	new = *slot;
> > > 
> > > Where @slot is a pointer to the memslot to be deleted.  At first, second,
> > > and third glances, this seems perfectly sane.
> > > 
> > > The issue is that slot was pulled from struct kvm_memslots.memslots, e.g.
> > > 
> > > 	slot = &slots->memslots[index];
> > > 
> > > Note that slots->memslots holds actual "struct kvm_memory_slot" objects,
> > > not pointers to slots.  When update_memslots() sorts the slots, it swaps
> > > the actual slot objects, not pointers.  I.e. after update_memslots(), even
> > > though @slot points at the same address, it's could be pointing at a
> > > different slot.  As a result kvm_free_memslot() in kvm_delete_memslot()
> > > will free the dirty page info and arch-specific points for some random
> > > slot, not the intended slot, and will set npages=0 for that random slot.
> > 
> > Ah I see, thanks.  Another alternative is we move the "old = *slot"
> > copy into kvm_delete_memslot(), which could be even clearer imo.
> 
> The copy is also needed in __kvm_set_memory_region() for the MOVE case.

Right.  I actually meant to do all "old = *slot" in any function we
need to cache the data explicitly, with that we also need another one
after calling kvm_delete_memslot() for move.  But with the comment as
you suggested below it looks good to me too.

Thanks,

> 
> > However I'm not sure whether it's a good idea to drop the test-by for
> > this.  Considering that comment change should not affect it, would you
> > mind enrich the comment into something like this (or anything better)?
> > 
> > /*
> >  * Make a full copy of the old memslot, the pointer will become stale
> >  * when the memslots are re-sorted by update_memslots() in
> >  * kvm_delete_memslot(), while to make the kvm_free_memslot() work as
> >  * expected later on, we still need the cached memory slot.
> >  */
> 
> As above, it's more subtle than just the kvm_delete_memslot() case.
> 
> 	/*
> 	 * Make a full copy of the old memslot, the pointer will become stale
> 	 * when the memslots are re-sorted by update_memslots() when deleting
> 	 * or moving a memslot, and additional modifications to the old memslot
> 	 * need to be made after calling update_memslots().
> 	 */
> 

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

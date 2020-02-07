Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D718C04EB5
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:06:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB191214AF
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="egLsZbLP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB191214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67F3E4A5C6;
	Fri,  7 Feb 2020 11:05:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xhh6Kp6oFE1Y; Fri,  7 Feb 2020 11:05:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D3A24A534;
	Fri,  7 Feb 2020 11:05:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDA2A4A524
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:05:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hoC1oEoTaCbq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 11:05:55 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A51034A389
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:05:55 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581091555;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=BLEVywtX/maNqEMEgdMdwF4jCircP8s45PaTEGjDtRI=;
 b=egLsZbLPw9vHxz/5R/Nw0s52vvjJ83IsEpid46UG5a6uoN5HKMckrLHM6wB0yfRVTPYy0d
 xO/M/JTh0Y6CVU2Br3GTg+BFXX4UR3nL8F0n4MRYteJO3HTMMBB36NDVQ2+0HzfWFneNYt
 veCYl507be2V/GVyryilPk91i0CxeOM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-9zSr4ccKNWuqDKiA3tGzZw-1; Fri, 07 Feb 2020 11:05:50 -0500
Received: by mail-qk1-f200.google.com with SMTP id w29so1741798qkw.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 08:05:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Bqsgg9qLeLOSmneB4WSB2dg3BsO/26WgQ0bE3+4CQXQ=;
 b=XyvpQ/nCH+0uhlsofl/w5jLQ4oRzEe4Ok9UzSlZnlaxrEhb+K85n0UNH6Eci0JayEj
 QPcJCqmX9/xbXKINq7gfclGejUK14Dza9MEY40SJ/aMXMO+AB1KfPVXQRxfNAYMonxcm
 XwYyaEjLh9bJtH7ZU87j20BIefy1xzC93haqQZ7hRrkjfd5+xtRYoY4PicA8xkvYddX4
 5opgQh2Yuz+Q+u7WVG1FhlBkOL6EPNRLdXwnnJpKIs1ZRk/UpOge8o5sCW1/57PR1Ydp
 gqefyGt5jm7oHodjFLH8bpfsWQG26bEaC66+GhVPfEGwj0ar6CrcmdClysubA5098A/Y
 TPzQ==
X-Gm-Message-State: APjAAAXnvEUyaqeAYIKwr1MRRrCFDcuvGH0IXG80FvT/x64AsPk6cQwV
 zr5VzRHrOgdeiElbfan6xEcQ62TZVFJFZ1W+YasyFCTqj00MJYgL9/l4HGNfb24jlQSoG6Tlmup
 D+fIC1w1KYE3ARiHy6v8CFBR4
X-Received: by 2002:a37:c0c:: with SMTP id 12mr7542949qkm.425.1581091550086;
 Fri, 07 Feb 2020 08:05:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBU3fSbdWuwCNOt5og3uav2CnBhaKLUx7zFmWTkehMEXphwviUtToR7q9BtKv4R+OEmMKY/w==
X-Received: by 2002:a37:c0c:: with SMTP id 12mr7542902qkm.425.1581091549699;
 Fri, 07 Feb 2020 08:05:49 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id 69sm1462245qkg.133.2020.02.07.08.05.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Feb 2020 08:05:48 -0800 (PST)
Date: Fri, 7 Feb 2020 11:05:46 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 18/19] KVM: Dynamically size memslot array based on
 number of used slots
Message-ID: <20200207160546.GA707371@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-19-sean.j.christopherson@intel.com>
 <20200206221208.GI700495@xz-x1>
 <20200207153829.GA2401@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200207153829.GA2401@linux.intel.com>
X-MC-Unique: 9zSr4ccKNWuqDKiA3tGzZw-1
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

On Fri, Feb 07, 2020 at 07:38:29AM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 05:12:08PM -0500, Peter Xu wrote:
> > On Tue, Jan 21, 2020 at 02:31:56PM -0800, Sean Christopherson wrote:
> > > Now that the memslot logic doesn't assume memslots are always non-NULL,
> > > dynamically size the array of memslots instead of unconditionally
> > > allocating memory for the maximum number of memslots.
> > > 
> > > Note, because a to-be-deleted memslot must first be invalidated, the
> > > array size cannot be immediately reduced when deleting a memslot.
> > > However, consecutive deletions will realize the memory savings, i.e.
> > > a second deletion will trim the entry.
> > > 
> > > Tested-by: Christoffer Dall <christoffer.dall@arm.com>
> > > Tested-by: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  include/linux/kvm_host.h |  2 +-
> > >  virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++++---
> > >  2 files changed, 29 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 60ddfdb69378..8bb6fb127387 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -431,11 +431,11 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
> > >   */
> > >  struct kvm_memslots {
> > >  	u64 generation;
> > > -	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
> > >  	/* The mapping table from slot id to the index in memslots[]. */
> > >  	short id_to_index[KVM_MEM_SLOTS_NUM];
> > >  	atomic_t lru_slot;
> > >  	int used_slots;
> > > +	struct kvm_memory_slot memslots[];
> > 
> > This patch is tested so I believe this works, however normally I need
> > to do similar thing with [0] otherwise gcc might complaint.  Is there
> > any trick behind to make this work?  Or is that because of different
> > gcc versions?
> 
> array[] and array[0] have the same net affect, but array[] is given special
> treatment by gcc to provide extra sanity checks, e.g. requires the field to
> be the end of the struct.  Last I checked, gcc also doesn't allow array[]
> in unions.  There are probably other restrictions.
> 
> But, it's precisely because of those restrictions that using array[] is
> preferred, as it provides extra protections, e.g. if someone moved memslots
> to the top of the struct it would fail to compile.

However...

xz-x1:tmp $ cat a.c
struct a {
    int s[];
};

int main(void) { }
xz-x1:tmp $ make a
cc     a.c   -o a
a.c:2:9: error: flexible array member in a struct with no named members
    2 |     int s[];
      |         ^
make: *** [<builtin>: a] Error 1

My gcc version is 9.2.1 20190827 (Red Hat 9.2.1-1) (GCC).

>  
> > >  };
> > >  
> > >  struct kvm {
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 9b614cf2ca20..ed392ce64e59 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -565,7 +565,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
> > >  		return NULL;
> > >  
> > >  	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> > > -		slots->id_to_index[i] = slots->memslots[i].id = -1;
> > > +		slots->id_to_index[i] = -1;
> > >  
> > >  	return slots;
> > >  }
> > > @@ -1077,6 +1077,32 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
> > >  	return old_memslots;
> > >  }
> > >  
> > > +/*
> > > + * Note, at a minimum, the current number of used slots must be allocated, even
> > > + * when deleting a memslot, as we need a complete duplicate of the memslots for
> > > + * use when invalidating a memslot prior to deleting/moving the memslot.
> > > + */
> > > +static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
> > > +					     enum kvm_mr_change change)
> > > +{
> > > +	struct kvm_memslots *slots;
> > > +	size_t old_size, new_size;
> > > +
> > > +	old_size = sizeof(struct kvm_memslots) +
> > > +		   (sizeof(struct kvm_memory_slot) * old->used_slots);
> > > +
> > > +	if (change == KVM_MR_CREATE)
> > > +		new_size = old_size + sizeof(struct kvm_memory_slot);
> > > +	else
> > > +		new_size = old_size;
> > > +
> > > +	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
> > > +	if (likely(slots))
> > > +		memcpy(slots, old, old_size);
> > 
> > (Maybe directly copy into it?)
> 
> I don't follow, are you saying do "*slots = *old"?
> 
> @new_size and @old_size are not guaranteed to be the same.  More
> specifically, slots->memslots and old->slots are now flexible arrays with
> potentially different sizes.  Doing "*slots = *old" would only copy the
> standard members, a memcpy() would still be needed for @memlots.
> 
> A more effecient implementation would be:
> 
> 	slots = kvalloc(new_size, GFP_KERNEL_ACCOUNT);
> 	if (likely(slots)) {
> 		memcpy(slots, old, old_size);
> 		if (change == KVM_MR_CREATE)
> 			memset((void *)slots + old_size, 0, new_size - old_size);
> 	}
> 
> to avoid unnecessarily zeroing out the entire thing.  I opted for the
> simpler implementation as this is not performance critical code, for most
> cases @slots won't be all that large, and I wanted to be absolutely sure
> any mixup would hit zeroed memory and not uninitialized memory.

I made a silly mistake on reading "slots" as "old".  Ignore my
comment, sorry!  And please take my R-b for this patch too:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

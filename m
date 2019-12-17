Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0099C2D0CD
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:51:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57EB52176D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57EB52176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E20F94A51C;
	Tue, 17 Dec 2019 17:51:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VX7hVLgASprl; Tue, 17 Dec 2019 17:51:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FC234A597;
	Tue, 17 Dec 2019 17:51:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D938E4A521
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:51:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jrqU4uydlzFr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 17:51:20 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5926A4A51C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:51:20 -0500 (EST)
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 17 Dec 2019 14:51:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; d="scan'208";a="247654290"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga002.fm.intel.com with ESMTP; 17 Dec 2019 14:51:18 -0800
Date: Tue, 17 Dec 2019 14:51:18 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v4 07/19] KVM: Explicitly free allocated-but-unused dirty
 bitmap
Message-ID: <20191217225118.GF11771@linux.intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-8-sean.j.christopherson@intel.com>
 <20191217222446.GK7258@xz-x1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191217222446.GK7258@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
 kvm-ppc@vger.kernel.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

On Tue, Dec 17, 2019 at 05:24:46PM -0500, Peter Xu wrote:
> On Tue, Dec 17, 2019 at 12:40:29PM -0800, Sean Christopherson wrote:
> > Explicitly free an allocated-but-unused dirty bitmap instead of relying
> > on kvm_free_memslot() if an error occurs in __kvm_set_memory_region().
> > There is no longer a need to abuse kvm_free_memslot() to free arch
> > specific resources as arch specific code is now called only after the
> > common flow is guaranteed to succeed.  Arch code can still fail, but
> > it's responsible for its own cleanup in that case.
> > 
> > Eliminating the error path's abuse of kvm_free_memslot() paves the way
> > for simplifying kvm_free_memslot(), i.e. dropping its @dont param.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  virt/kvm/kvm_main.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d403e93e3028..6b2261a9e139 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1096,7 +1096,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  
> >  	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> >  	if (!slots)
> > -		goto out_free;
> > +		goto out_bitmap;
> >  	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
> >  
> >  	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> > @@ -1144,8 +1144,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> >  		slots = install_new_memslots(kvm, as_id, slots);
> >  	kvfree(slots);
> > -out_free:
> > -	kvm_free_memslot(kvm, &new, &old);
> > +out_bitmap:
> > +	if (new.dirty_bitmap && !old.dirty_bitmap)
> > +		kvm_destroy_dirty_bitmap(&new);
> 
> What if both the old and new have KVM_MEM_LOG_DIRTY_PAGES set?
> kvm_free_memslot() did cover that but I see that you explicitly
> dropped it.  Could I ask why?  Thanks,

In that case, old.dirty_bitmap == new.dirty_bitmap, i.e. shouldn't be freed
by this error path since doing so would result in a use-after-free via the
old memslot.

The kvm_free_memslot() logic is the same, albeit in a very twisted way.

In __kvm_set_memory_region(), @old and @new start with the same dirty_bitmap.

	new = old = *slot;

And @new is modified based on KVM_MEM_LOG_DIRTY_PAGES.  If LOG_DIRTY_PAGES
is set in both @new and @old, then both the "if" and "else if" evaluate
false, i.e. new.dirty_bitmap == old.dirty_bitmap.

	/* Allocate/free page dirty bitmap as needed */
	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
		new.dirty_bitmap = NULL;
	else if (!new.dirty_bitmap) {
		r = kvm_create_dirty_bitmap(&new);
		if (r)
			return r;
	}

Subbing "@free <= @new" and "@dont <= @old" in kvm_free_memslot()

  static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
			       struct kvm_memory_slot *dont)
  {
	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
		kvm_destroy_dirty_bitmap(free);


yeids this, since @old is obviously non-NULL

	if (new.dirty_bitmap != old.dirty_bitmap)
		kvm_destroy_dirty_bitmap(&new);

The dirty_bitmap allocation logic guarantees that new.dirty_bitmap is
  a) NULL (the "if" case")
  b) != old.dirty_bitmap iff old.dirty_bitmap == NULL (the "else if" case)
  c) == old.dirty_bitmap (the implicit "else" case).

kvm_free_memslot() frees @new.dirty_bitmap iff its != @old.dirty_bitmap,
thus the explicit destroy only needs to check for (b).
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

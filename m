Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B6FC33CAC
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:51:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85C2221775
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8Z2Rz5B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85C2221775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1A354A1B0;
	Thu,  6 Feb 2020 11:51:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tNkGcsEduSK3; Thu,  6 Feb 2020 11:51:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBFAD4A32E;
	Thu,  6 Feb 2020 11:51:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85AF74A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:51:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f3Nv9SkyWLUU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 11:51:26 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C27C4A1B0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:51:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581007886;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5uqDteyIESKHBqFfefG3/Fe5X/W69IoC1lkhBv3/qEc=;
 b=N8Z2Rz5BUQ59TPhOfRv39XxR4Mo5Z47hyqyiK46lX3oeR7yqQbuujfwmZsI2m0Xzml1msS
 tR4wDpaMDf5k9a+8mzYv7PkAeYfLZR0Un4oF9Pvpfej7MuBnV7RNkZ97BXEHr4lJA0CQzJ
 DLFR4U/u0cuFPA9RBHyxwhKlGPgRlx0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-K9PjqKkhM7q1c2-dEHCfBA-1; Thu, 06 Feb 2020 11:51:21 -0500
Received: by mail-qt1-f198.google.com with SMTP id x8so4245853qtq.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 08:51:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6wEZC2xS1ICrNAGJ+8QI1N9zsFW9IzwC/0IJCgjt8nk=;
 b=nmGl8Qjo14303FzfPuAZ3ltOW/h13b0mgvCW1F6dBbVrzNSExrkOf74d7xIs+y0njn
 FtA/skSC0XjlCnEUNY0pJGSLVyLykly+vtbjdAC9Wm0a9wGbXDR5dpB+HEYxTUeV016W
 /keuW14yU5ghQInH0v+HILI1UmB01wb1x/2iVwUjXJ6SfgSaSxdnMWbSazOW+uiayXUp
 DAn6HP/rr129TPreVSMbljI8dDiCQrLK05qy+aqWRglOsMfTA/0TPPhbXvuiF5AvTfk5
 e5EIYX5LgVe2YKq2xaG8tmTcWJ69TS0D1WxiZKk1WKOTesjJ05BiZcXldWQ+UBl7fxXa
 zc+w==
X-Gm-Message-State: APjAAAWGuHkqs8kjlAaC/zPzvCUnivo5+Ga5QPAzdB2Kv0opcYH5+Wfp
 t8LbcTU0wvS845Okv6BnquNOnJ/HpGYuUiNT5T+h6IwvLRqiE4aH7ngpqMCcWyrX6WeL1RepHDI
 5gIQuom2SSak/fqMWRniO1SW0
X-Received: by 2002:a0c:ed22:: with SMTP id u2mr3142544qvq.13.1581007880668;
 Thu, 06 Feb 2020 08:51:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqx/jX2RKvHGf3JDTGGU+D3o2LP4p21Bk3Kl7+mbxJpFhXmYhA374b5M6RMOGMp7RFtjxv6e0g==
X-Received: by 2002:a0c:ed22:: with SMTP id u2mr3142516qvq.13.1581007880314;
 Thu, 06 Feb 2020 08:51:20 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id v10sm1058913qtj.26.2020.02.06.08.51.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 08:51:19 -0800 (PST)
Date: Thu, 6 Feb 2020 11:51:16 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 12/19] KVM: Move memslot deletion to helper function
Message-ID: <20200206165116.GE695333@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-13-sean.j.christopherson@intel.com>
 <20200206161415.GA695333@xz-x1>
 <20200206162818.GD13067@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200206162818.GD13067@linux.intel.com>
X-MC-Unique: K9PjqKkhM7q1c2-dEHCfBA-1
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

On Thu, Feb 06, 2020 at 08:28:18AM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 11:14:15AM -0500, Peter Xu wrote:
> > On Tue, Jan 21, 2020 at 02:31:50PM -0800, Sean Christopherson wrote:
> > > Move memslot deletion into its own routine so that the success path for
> > > other memslot updates does not need to use kvm_free_memslot(), i.e. can
> > > explicitly destroy the dirty bitmap when necessary.  This paves the way
> > > for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> > > NULL for @dont.
> > > 
> > > Add a comment above the code to make a copy of the existing memslot
> > > prior to deletion, it is not at all obvious that the pointer will become
> > > stale during sorting and/or installation of new memslots.
> > 
> > Could you help explain a bit on this explicit comment?  I can follow
> > up with the patch itself which looks all correct to me, but I failed
> > to catch what this extra comment wants to emphasize...
> 
> It's tempting to write the code like this (I know, because I did it):
> 
> 	if (!mem->memory_size)
> 		return kvm_delete_memslot(kvm, mem, slot, as_id);
> 
> 	new = *slot;
> 
> Where @slot is a pointer to the memslot to be deleted.  At first, second,
> and third glances, this seems perfectly sane.
> 
> The issue is that slot was pulled from struct kvm_memslots.memslots, e.g.
> 
> 	slot = &slots->memslots[index];
> 
> Note that slots->memslots holds actual "struct kvm_memory_slot" objects,
> not pointers to slots.  When update_memslots() sorts the slots, it swaps
> the actual slot objects, not pointers.  I.e. after update_memslots(), even
> though @slot points at the same address, it's could be pointing at a
> different slot.  As a result kvm_free_memslot() in kvm_delete_memslot()
> will free the dirty page info and arch-specific points for some random
> slot, not the intended slot, and will set npages=0 for that random slot.

Ah I see, thanks.  Another alternative is we move the "old = *slot"
copy into kvm_delete_memslot(), which could be even clearer imo.
However I'm not sure whether it's a good idea to drop the test-by for
this.  Considering that comment change should not affect it, would you
mind enrich the comment into something like this (or anything better)?

/*
 * Make a full copy of the old memslot, the pointer will become stale
 * when the memslots are re-sorted by update_memslots() in
 * kvm_delete_memslot(), while to make the kvm_free_memslot() work as
 * expected later on, we still need the cached memory slot.
 */

In all cases:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

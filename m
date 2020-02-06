Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659D5C35247
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:41:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7B83218AC
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UE7VA9j5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7B83218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ED7B4A3A3;
	Thu,  6 Feb 2020 16:41:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XjIUnfiZ5To0; Thu,  6 Feb 2020 16:41:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06BD74A4C0;
	Thu,  6 Feb 2020 16:41:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C71244A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:41:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qB+ksyWuopBk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 16:41:15 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4FD64A389
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:41:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581025275;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=miTk2jHvXEeon48FMT6UBcqphMo6SpNxcWIB57XG7sg=;
 b=UE7VA9j53uhRgOs4eYoJ/gzeKVxCZEML4YohnEL7bTeVGXOmXbt/RSoDlpCwVtKkIVALED
 HmYWsZe2Hb9Dttiy98TP/VrDtgaxRrZvsdmLEpuh7Urih2EuXAOntPv65MNkk6onaAUsH6
 TU2AyIVTm/o4gJdbMzgzWHNBcIXp6iw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-8_n17ScNPQaTxOEgmqUMmg-1; Thu, 06 Feb 2020 16:41:12 -0500
Received: by mail-qv1-f71.google.com with SMTP id g15so4579971qvk.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 13:41:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fv7hocxnCQMQx/Ef0JfmL5g1BsW3yRUgDUYfbGA1aT0=;
 b=emDfIujQebwtJAPChL/KCjuoauhlQxA7mBgATUApmYD62rt+QvQuQQuoEmEGwXBZZe
 n3wE0wLP0lLSYSwEvuq3y30wGrGcQb5iZVS2acIvXBio1/FYLVBoh2SI7dOPVT74l+8m
 SyxNPX33U6DkHCZ5qclvXMavxt3y+u7xL1D7qkxLlYIyDwPeS7HtkK01Jr5mXGxKAd20
 kW9Ik2LtQnjZLU5q3rhou5LS+YcYM/ayqwrLbd/1B2x9S9H/3QFKi32DAgemQtH1qG70
 jxNH7sC0hE1P4Wnve5DZotuwX3n42/vt6SOcEqZxgzp7v1Uhfd3dw1s+qYgXbb3li2QZ
 V+Ug==
X-Gm-Message-State: APjAAAW5A6TfxinRUNeW74GhPsDjg2dpaJBvj1NA67shW7LJEZNZQ+6G
 WV1mFhG9U58gThHA3MXMD1odZEhDafuA8JYuj/ZOM0hOumCldcM8nfBhmOCkxyvMLO6yQLpL5Ic
 fvYz9K15i82BTqiuiT+8Rv9v5
X-Received: by 2002:a05:620a:7f2:: with SMTP id
 k18mr4541150qkk.207.1581025271641; 
 Thu, 06 Feb 2020 13:41:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxJgBpP+Sn/XW78feM1lgNrPZNv0ribzryOvpKTws4jf2FMfbWVePD88+Gb3lvt+IGO4p+aFA==
X-Received: by 2002:a05:620a:7f2:: with SMTP id
 k18mr4541080qkk.207.1581025270452; 
 Thu, 06 Feb 2020 13:41:10 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id w9sm304509qka.71.2020.02.06.13.41.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 13:41:09 -0800 (PST)
Date: Thu, 6 Feb 2020 16:41:06 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200206214106.GG700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
 <20200206200200.GC700495@xz-x1>
 <20200206212120.GF13067@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200206212120.GF13067@linux.intel.com>
X-MC-Unique: 8_n17ScNPQaTxOEgmqUMmg-1
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

On Thu, Feb 06, 2020 at 01:21:20PM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
> > On Tue, Jan 21, 2020 at 02:31:53PM -0800, Sean Christopherson wrote:
> > 
> > [...]
> > 
> > > -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
> > > +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
> > > +				  struct kvm_memory_slot *memslot)
> > 
> > If it's to flush TLB for a memslot, shall we remove the "dirty_log" in
> > the name of the function, because it has nothing to do with dirty
> > logging any more?  And...
> 
> I kept the "dirty_log" to allow arch code to implement logic specific to a
> TLB flush during dirty logging, e.g. x86's lockdep assert on slots_lock.
> And similar to the issue with MIPS below, to deter usage of the hook for
> anything else, i.e. to nudge people to using kvm_flush_remote_tlbs()
> directly.

The x86's lockdep assert is not that important afaict, since the two
callers of the new tlb_flush() hook will be with slots_lock for sure.

> 
> > >  {
> > > -	struct kvm_memslots *slots;
> > > -	struct kvm_memory_slot *memslot;
> > > -	bool flush = false;
> > > -	int r;
> > > -
> > > -	mutex_lock(&kvm->slots_lock);
> > > -
> > > -	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
> > > -
> > > -	if (flush) {
> > > -		slots = kvm_memslots(kvm);
> > > -		memslot = id_to_memslot(slots, log->slot);
> > > -
> > > -		/* Let implementation handle TLB/GVA invalidation */
> > > -		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> > > -	}
> > > -
> > > -	mutex_unlock(&kvm->slots_lock);
> > > -	return r;
> > > +	/* Let implementation handle TLB/GVA invalidation */
> > > +	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> > 
> > ... This may not directly related to the current patch, but I'm
> > confused on why MIPS cannot use kvm_flush_remote_tlbs() to flush TLBs.
> > I know nothing about MIPS code, but IIUC here flush_shadow_memslot()
> > is a heavier operation that will also invalidate the shadow pages.
> > Seems to be an overkill here when we only changed write permission of
> > the PTEs?  I tried to check the first occurance (2a31b9db15353) but I
> > didn't find out any clue of it so far.
> > 
> > But that matters to this patch because if MIPS can use
> > kvm_flush_remote_tlbs(), then we probably don't need this
> > arch-specific hook any more and we can directly call
> > kvm_flush_remote_tlbs() after sync dirty log when flush==true.
> 
> Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
> that prevents calling kvm_flush_remote_tlbs() directly, but I have no
> clue as to the important of that code.

As said above I think the x86 lockdep is really not necessary, then
considering MIPS could be the only one that will use the new hook
introduced in this patch...  Shall we figure that out first?

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

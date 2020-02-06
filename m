Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7DFC352A3
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 22:04:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 15C442192A
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 22:04:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CZ6l8geq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15C442192A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A0B54A535;
	Thu,  6 Feb 2020 17:04:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bQy7R5mEg0mt; Thu,  6 Feb 2020 17:04:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6871C4A418;
	Thu,  6 Feb 2020 17:04:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18AC44A418
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 17:04:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NnemIkVIiOwS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 17:04:02 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F10A24A3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 17:04:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581026641;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/6BekcDT9n3zN1TnOpoj1GWb65h2d7UBWogt94JZQto=;
 b=CZ6l8geqaPcxZE17XK4T0TV8mxd9Zd+CyRYNz4nxYAUnvZ+kiP+8QohpWMHKUateOoD59F
 VgQ//FzkId2WjvagJBP0vh4uonx85khz62JVWrKcJOLE0a2eK/qWryjhNIEJcXL7NdTU0u
 vxgwGAQziRLa2d+zUg1oJhJjQfEB3mQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-QpeqE144OxKzhSpQfMRFSA-1; Thu, 06 Feb 2020 17:03:59 -0500
Received: by mail-qv1-f71.google.com with SMTP id dc2so4622859qvb.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 14:03:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dz1uoo006UjtoREFQWYnwIS83IIptUYIWImaDlSbYB4=;
 b=R/ErvMJF4/iCiTbdE2RPFmNv3PAwC7z4jpBkE48BsQoGefyPLCUxVOegVaMnkQAdLQ
 zKJWpRI2/VCs8DktAi9UflIXVuisHR1cDJuoUHLtFduKJLn+1DasONtq+Jf0VThbymoS
 6EA0lEwRv+XTL/OF1pPPHeH8cyuoI2pmJcG0B4fKX/DDM4tAMjlpFLvyrJHNI2aALrUy
 OiySxD6tcIjo5gbrh/9iUcOstj9AjRx0kcr5yfA5fIGE0nr0Yk1TuF28DH1TmpNKSezn
 AOHwB/16JmMGbclunHSyQpUfvSa2fVdyts9JEZw3Oen89CLvbHQnVnhYzsd0+nuQ28xH
 b7Qw==
X-Gm-Message-State: APjAAAVOfRLpnvPJOC2sFnAPs4oKNzEsXTcbxKckTCx5clAAcBvR2kmW
 WcTCsrJkKxUyahFXOr//wZzDfWs3oBvOhS4s0YAOHSXBlSjZPow6aviN6zuATLZjmmmp/EruQ9e
 EoW/IP64MLUOOhBXayVEmntaN
X-Received: by 2002:ac8:7396:: with SMTP id t22mr4707013qtp.269.1581026639167; 
 Thu, 06 Feb 2020 14:03:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwu2LJdikIjEQUWHwIaSDYrGQrBVVncwkTn7Iy+PzbVsPREs+ohxiEeOt5zr/YlX26hX6iftw==
X-Received: by 2002:ac8:7396:: with SMTP id t22mr4706974qtp.269.1581026638877; 
 Thu, 06 Feb 2020 14:03:58 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id i7sm312515qki.83.2020.02.06.14.03.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 14:03:58 -0800 (PST)
Date: Thu, 6 Feb 2020 17:03:55 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 16/19] KVM: Ensure validity of memslot with respect to
 kvm_get_dirty_log()
Message-ID: <20200206220355.GH700495@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-17-sean.j.christopherson@intel.com>
 <20191224181930.GC17176@xz-x1>
 <20200114182506.GF16784@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200114182506.GF16784@linux.intel.com>
X-MC-Unique: QpeqE144OxKzhSpQfMRFSA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
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

On Tue, Jan 14, 2020 at 10:25:07AM -0800, Sean Christopherson wrote:
> On Tue, Dec 24, 2019 at 01:19:30PM -0500, Peter Xu wrote:
> > On Tue, Dec 17, 2019 at 12:40:38PM -0800, Sean Christopherson wrote:
> > > +int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> > > +		      int *is_dirty, struct kvm_memory_slot **memslot)
> > >  {
> > >  	struct kvm_memslots *slots;
> > > -	struct kvm_memory_slot *memslot;
> > >  	int i, as_id, id;
> > >  	unsigned long n;
> > >  	unsigned long any = 0;
> > >  
> > > +	*memslot = NULL;
> > > +	*is_dirty = 0;
> > > +
> > >  	as_id = log->slot >> 16;
> > >  	id = (u16)log->slot;
> > >  	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
> > >  		return -EINVAL;
> > >  
> > >  	slots = __kvm_memslots(kvm, as_id);
> > > -	memslot = id_to_memslot(slots, id);
> > > -	if (!memslot->dirty_bitmap)
> > > +	*memslot = id_to_memslot(slots, id);
> > > +	if (!(*memslot)->dirty_bitmap)
> > >  		return -ENOENT;
> > >  
> > > -	n = kvm_dirty_bitmap_bytes(memslot);
> > > +	kvm_arch_sync_dirty_log(kvm, *memslot);
> > 
> > Should this line belong to previous patch?
> 
> No.
> 
> The previous patch, "KVM: Provide common implementation for generic dirty
> log functions", is consolidating the implementation of dirty log functions
> for architectures with CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y.
> 
> This code is being moved from s390's kvm_vm_ioctl_get_dirty_log(), as s390
> doesn't select KVM_GENERIC_DIRTYLOG_READ_PROTECT.  It's functionally a nop
> as kvm_arch_sync_dirty_log() is empty for PowerPC, the only other arch that
> doesn't select KVM_GENERIC_DIRTYLOG_READ_PROTECT.
> 
> Arguably, the call to kvm_arch_sync_dirty_log() should be moved in a
> separate prep patch.  It can't be a follow-on patch as that would swap the
> ordering of kvm_arch_sync_dirty_log() and kvm_dirty_bitmap_bytes(), etc...
> 
> My reasoning for not splitting it to a separate patch is that prior to this
> patch, the common code and arch specific code are doing separate memslot
> lookups via id_to_memslot(), i.e. moving the kvm_arch_sync_dirty_log() call
> would operate on a "different" memslot.   It can't actually be a different
> memslot because slots_lock is held, it just felt weird.
> 
> All that being said, I don't have a strong opinion on moving the call to
> kvm_arch_sync_dirty_log() in a separate patch; IIRC, I vascillated between
> the two options when writing the code.  If anyone wants it to be a separate
> patch I'll happily split it out.

(Sorry to respond so late)

I think the confusing part is the subject, where you only mentioned
the memslot change.  IMHO you can split the change to make it clearer,
or at least would you mind mention that kvm_arch_sync_dirty_log() move
in the commit message?  Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

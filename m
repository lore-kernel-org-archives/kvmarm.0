Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD24C2D0CD
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:37:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93EF9218AC
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KeVWuQcY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93EF9218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28A024A8E0;
	Tue, 17 Dec 2019 17:37:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fnZ-4HmoBxD9; Tue, 17 Dec 2019 17:37:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17B874A5A6;
	Tue, 17 Dec 2019 17:37:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C17D4A4AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:37:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2JfmZmhqsSLO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 17:37:38 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF834A418
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:37:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576622258;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9EsUXbZY6U+Bm0swUVD6VBLhpD0mHgCBqOKLzv1eXnA=;
 b=KeVWuQcYRnrCgaTDq2zwhebfdvCKftTo2CKOzwnnbSD5xDJaR/68XlHzsarI3lb0LXh/vG
 NO5QYVlJhpMUTDruytIJpQkCbz3rXkhwbEbVNEUNfK/TrvLINusBVzxy8HsX4oRK9BGUEr
 l8aUCJzI7sImCi7VMIgdR9RGFxozzHw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-1PBzfvJzNi2SIJSVMo26pQ-1; Tue, 17 Dec 2019 17:37:36 -0500
Received: by mail-qv1-f72.google.com with SMTP id g6so163315qvp.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 14:37:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=4AxsEtCek/f0aziPe+wCZz9Hjxg7TgpaT9NrNyuqheA=;
 b=eC6fneo4waQqNFhUScUYntAQInqsXK1MSNgKkjjGaMIKMBXh2RNjqJYAtMmAKxN0sd
 LHs8Lz1a77kR5+V/70SoQJSdRNPKGFRhjmG5XBTC88lRZqexGnQvLwHvR0vGiq//SW8u
 a5uPb9HWFEA61J8ixGbACMlZq2wKTIrlxJvl+EQUQMMvDobYtALivAGNaKM/hp3Ydrp9
 SoJkD9jXVlEJxzFasJJPV/Y7cNLN8k+WUxVAgH6N6XE3Aw2emSRk8uLxTUIlXqb40Ur5
 1yCmqz+KLcGC4XNm/nMllHJmWivaNcjbqFz8OJHk8+1bZVvD+PZNO5KG5738xaYQTOcm
 j54A==
X-Gm-Message-State: APjAAAWZ+6MAKjc9NnZRCiHhHXg59DAs1YBzTK44S6s2eLRSBKCsiw9S
 5UcJ+I+iXJkN8Y9hjq6JREhQzvsPmo5AJRQJArMFKZqYHoJkNYyvZhlv+4cOc37JWaXlySXEqOB
 biYa4XD4/8W20yBS/lSe1x3w8
X-Received: by 2002:a37:4d45:: with SMTP id a66mr374445qkb.65.1576622256394;
 Tue, 17 Dec 2019 14:37:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqxl93uuG9B4gn7WP+rric6T9Je7Dj1Ol6DxMKHs7+zQRPC1qeoFeX2QtpGDhXhtHyWXATL+iw==
X-Received: by 2002:a37:4d45:: with SMTP id a66mr374408qkb.65.1576622256150;
 Tue, 17 Dec 2019 14:37:36 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
 by smtp.gmail.com with ESMTPSA id g62sm11961qkd.25.2019.12.17.14.37.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 17 Dec 2019 14:37:35 -0800 (PST)
Date: Tue, 17 Dec 2019 17:37:34 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 01/19] KVM: x86: Allocate new rmap and large page
 tracking when moving memslot
Message-ID: <20191217223734.GL7258@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-2-sean.j.christopherson@intel.com>
 <20191217215640.GI7258@xz-x1>
 <20191217222058.GD11771@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191217222058.GD11771@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: 1PBzfvJzNi2SIJSVMo26pQ-1
X-Mimecast-Spam-Score: 0
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
 David Gibson <david@gibson.dropbear.id.au>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Tue, Dec 17, 2019 at 02:20:59PM -0800, Sean Christopherson wrote:
> > For example, I see PPC has this:
> > 
> > struct kvm_arch_memory_slot {
> > #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> > 	unsigned long *rmap;
> > #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
> > };
> > 
> > I started to look into HV code of it a bit, then I see...
> > 
> >  - kvm_arch_create_memslot(kvmppc_core_create_memslot_hv) init slot->arch.rmap,
> >  - kvm_arch_flush_shadow_memslot(kvmppc_core_flush_memslot_hv) didn't free it,
> >  - kvm_arch_prepare_memory_region(kvmppc_core_prepare_memory_region_hv) is nop.
> > 
> > So Does it have similar issue?
> 
> No, KVM doesn't allow a memslot's size to be changed, and PPC's rmap
> allocation is directly tied to the size of the memslot.  The x86 bug exists
> because the size of its metadata arrays varies based on the alignment of
> the base gfn.

Yes, I was actually thinking those rmap would be invalid rather than
the size after the move.  But I think kvm_arch_flush_shadow_memslot()
will flush all of them anyways... So yes it seems fine.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

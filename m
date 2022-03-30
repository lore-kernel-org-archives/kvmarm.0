Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B50C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 30 Mar 2022 18:30:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 422E940B03;
	Wed, 30 Mar 2022 14:30:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rW0xHoSj-Ilt; Wed, 30 Mar 2022 14:30:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E338449EBC;
	Wed, 30 Mar 2022 14:30:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09BD5408C1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 14:30:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d6Uk1Rg-BWca for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Mar 2022 14:30:29 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A92A74087B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 14:30:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648665029;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=RZbGTsE6fj+tWEXGzmO8DRMy8Cnx5er20TMqeDcb2Ps=;
 b=DNf8MTKDF/DYRQViU+G0054tVcBrV29xlB5AVaRq1F6oTI5H9NslWB3riFQWDbjAS9ChsF
 3YgfJWlthEoAL7MyomwYm5byiLkqS1sfYgpQ/9yb8IH/2Xkfp8R4QXZ2Gs52CDLPinnBdB
 NQbmvixveVtJbdm0WnOxQhfWrpicavU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-fZIUPFY-OsmuaSYzVwVCAg-1; Wed, 30 Mar 2022 14:30:27 -0400
X-MC-Unique: fZIUPFY-OsmuaSYzVwVCAg-1
Received: by mail-qv1-f70.google.com with SMTP id
 k20-20020ad44714000000b00440fd2c4a0aso16675229qvz.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 11:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=RZbGTsE6fj+tWEXGzmO8DRMy8Cnx5er20TMqeDcb2Ps=;
 b=d692CvVwzWb8EneHg7hXHwD/X+DDpssuZTXohWM4GV5eLl4ONW/8WplqeCUZDmBpun
 7XjjuGjGXZSmuHLrktL62nkAzYnIedNbGphPo4gb4VccXoM9KRWx+XjjL/cIc/kFApnh
 HAg24K+9kvdNBlUBsjdPT/yD85Ou8J6L1gavXyGnBFYBYPHaKBxXI9sJo7wWRV8akLCb
 EJ2H0fyrHq+SctL65WGJggPL6xu6tBxTlf/ezhK4irBr7oJPxMed+axH9kD13Me1wmAd
 WVGb9OHSSCxSMCwIq7MNhUu39u6qD3uXG6p5IQiPRL8FVxZXkwPUY2UWJyWWXJ0e+7rW
 omOw==
X-Gm-Message-State: AOAM531t+b1OW/uh9IlSIYh2lZkL5qDICnueUBORRRvQbcNbtpdgoLO2
 /qB4Lr5L/x7cnZMBbzoFt02KZ2mX/tv8mc5pZ+3sY4fxIMP21nMK3NYn3gQMAsPEaWFVQmZuH4H
 8kbObu01UfHhatmkK3TlokiL5
X-Received: by 2002:a37:414c:0:b0:67e:6d68:c585 with SMTP id
 o73-20020a37414c000000b0067e6d68c585mr756748qka.196.1648665026790; 
 Wed, 30 Mar 2022 11:30:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxV7GTt34CXdG/qDCogIthPSHMHYYlDRsKEVG6uvoZamRv82rxB1y8ernA5KphBy4D/a0zmOw==
X-Received: by 2002:a37:414c:0:b0:67e:6d68:c585 with SMTP id
 o73-20020a37414c000000b0067e6d68c585mr756718qka.196.1648665026496; 
 Wed, 30 Mar 2022 11:30:26 -0700 (PDT)
Received: from xz-m1.local
 (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
 by smtp.gmail.com with ESMTPSA id
 p13-20020a05622a048d00b002e1ce0c627csm18698113qtx.58.2022.03.30.11.30.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 11:30:26 -0700 (PDT)
Date: Wed, 30 Mar 2022 14:30:24 -0400
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 16/26] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <YkShwFaRqlQpyL87@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-17-dmatlack@google.com>
 <YjGgjTnP/9sG8L+2@xz-m1.local>
 <CALzav=fZQYC7YyTbZqbkYTYVUXCq4skc6pkQ2S59BoSxbkKUhw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALzav=fZQYC7YyTbZqbkYTYVUXCq4skc6pkQ2S59BoSxbkKUhw@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Tue, Mar 22, 2022 at 03:51:54PM -0700, David Matlack wrote:
> On Wed, Mar 16, 2022 at 1:32 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Mar 11, 2022 at 12:25:18AM +0000, David Matlack wrote:
> > > In order to split a huge page we need to know what access bits to assign
> > > to the role of the new child page table. This can't be easily derived
> > > from the huge page SPTE itself since KVM applies its own access policies
> > > on top, such as for HugePage NX.
> > >
> > > We could walk the guest page tables to determine the correct access
> > > bits, but that is difficult to plumb outside of a vCPU fault context.
> > > Instead, we can store the original access bits for each leaf SPTE
> > > alongside the GFN in the gfns array. The access bits only take up 3
> > > bits, which leaves 61 bits left over for gfns, which is more than
> > > enough. So this change does not require any additional memory.
> >
> > I have a pure question on why eager page split needs to worry on hugepage
> > nx..
> >
> > IIUC that was about forbidden huge page being mapped as executable.  So
> > afaiu the only missing bit that could happen if we copy over the huge page
> > ptes is the executable bit.
> >
> > But then?  I think we could get a page fault on fault->exec==true on the
> > split small page (because when we copy over it's cleared, even though the
> > page can actually be executable), but it should be well resolved right
> > after that small page fault.
> >
> > The thing is IIUC this is a very rare case, IOW, it should mostly not
> > happen in 99% of the use case?  And there's a slight penalty when it
> > happens, but only perf-wise.
> >
> > As I'm not really fluent with the code base, perhaps I missed something?
> 
> You're right that we could get away with not knowing the shadowed
> access permissions to assign to the child SPTEs when splitting a huge
> SPTE. We could just copy the huge SPTE access permissions and then let
> the execute bit be repaired on fault (although those faults would be a
> performance cost).
> 
> But the access permissions are also needed to lookup an existing
> shadow page (or create a new shadow page) to use to split the huge
> page. For example, let's say we are going to split a huge page that
> does not have execute permissions enabled. That could be because NX
> HugePages are enabled or because we are shadowing a guest translation
> that does not allow execution (or both). We wouldn't want to propagate
> the no-execute permission into the child SP role.access if the
> shadowed translation really does allow execution (and vice versa).

Then the follow up (pure) question is what will happen if we simply
propagate the no-exec permission into the child SP?

I think that only happens with direct sptes where guest used huge pages
because that's where the shadow page will be huge, so IIUC that's checked
here when the small page fault triggers:

static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
				   unsigned direct_access)
{
	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
		struct kvm_mmu_page *child;

		/*
		 * For the direct sp, if the guest pte's dirty bit
		 * changed form clean to dirty, it will corrupt the
		 * sp's access: allow writable in the read-only sp,
		 * so we should update the spte at this point to get
		 * a new sp with the correct access.
		 */
		child = to_shadow_page(*sptep & PT64_BASE_ADDR_MASK);
		if (child->role.access == direct_access)
			return;

		drop_parent_pte(child, sptep);
		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
	}
}

Due to missing EXEC the role.access check will not match with direct
access, which is the guest pgtable value which has EXEC set.  Then IIUC
we'll simply drop the no-exec SP and replace it with a new one with exec
perm.  The question is, would that untimately work too?

Even if that works, I agree this sounds tricky because we're potentially
caching fake sp.role conditionally and it seems we never do that before.
It's just that the other option that you proposed here seems to add other
way of complexity on caching spte permission information while kvm doesn't
do either before.  IMHO we need to see which is the best trade off.

I could have missed something else, though.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

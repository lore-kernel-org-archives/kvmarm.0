Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328B6C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 01:04:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A24A061284
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 01:04:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A24A061284
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5CF64B192;
	Thu, 11 Nov 2021 20:04:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 777AbFf1gIHC; Thu, 11 Nov 2021 20:04:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D18894B199;
	Thu, 11 Nov 2021 20:04:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72B704B188
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 20:04:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JWuWvKTHQi7y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 20:03:57 -0500 (EST)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B17AE4B162
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 20:03:57 -0500 (EST)
Received: by mail-pf1-f179.google.com with SMTP id x64so7072712pfd.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 17:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=OqiUBkPNwVtm2ZpjSEzoYhMNAp4tNbVTba3KEv6WN8w=;
 b=pc7ejE9G9f2/DNPzPS7XIXvJtmGfBaF2LxIzkZwFvEfuQOri3Y1155wjk7xjt2PNCJ
 kE24TIPjCcGgUSYiX3UWCA1DBdTKkT1C74bahVgNb9tmSS/hJEwGE9hxKY7yJMJ5/gnk
 kd+TrPPKr0MuJqBAypaAOFEn7+cRqbZm+iMfctLBeivKDevpGMITf+s6vQitBcPNGTgw
 /amQnFMW1BnWMyjEaECoc/twxm/ddAt9qLXsEQJ21ZE/S+ANAhdIOkrMWTDwWGDr9sqH
 T2DNYEPOqsm0H4/svC1i15A5EDGrV+fHlrcxZdbN2PUtjvWHGe4Hnq190TEFtTm6CJzc
 ynvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OqiUBkPNwVtm2ZpjSEzoYhMNAp4tNbVTba3KEv6WN8w=;
 b=0t8IK+N63JIK9q/tFRELsamWuT92fTGq5bRnzYwFLD8bTA1k3WGJNvR66bW2FLWJP5
 uUSEaxuiDCNKx6G2ZAUv5xVq6st0hjFGTX1p8x6WN2mFYTIsuRnxqYTQIzYMwFIGtEUp
 o9bPWqnnMdFAQQqVBMSWq/bnYbqsCgBmGSUW1btQiuGHLzOZwrLKe26FF1Fmm2L1Gp3m
 RmRfOJQVESzdPx++wNJKXzttmJQwM+lrQCINZmzjXsLh5EF3g4SXbmJKxjUp8J7yK9+w
 lk+gBnl5qv/hEumKbX/IdfjYg1xvy2/8vOMF/x/dUFW4SopisTrobxOYB/TI+ynjKXs8
 1HVQ==
X-Gm-Message-State: AOAM530fxe5YWtJnWs0eYuCNjibWbHDKiLw9suwhoS807RL6ra13QXj+
 myLVbBzy0gYkQ1LPzuuasANwFQ==
X-Google-Smtp-Source: ABdhPJxMgoJUa9ek+o+tvzW6z5WeFQCDZekoSsl946lRj2FCOsMM6fcE3+3c50Ng/MtZ8Re7BsLCDg==
X-Received: by 2002:a63:1441:: with SMTP id 1mr7559189pgu.66.1636679035969;
 Thu, 11 Nov 2021 17:03:55 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id t13sm4096818pfl.214.2021.11.11.17.03.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Nov 2021 17:03:55 -0800 (PST)
Date: Fri, 12 Nov 2021 01:03:51 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 23/30] KVM: Resolve memslot ID via a hash table
 instead of via a static array
Message-ID: <YY29d7Vb6aiv93mu@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-24-seanjc@google.com>
 <f0b364ed-bf9e-5de9-0449-6d7ba3682405@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f0b364ed-bf9e-5de9-0449-6d7ba3682405@oracle.com>
Cc: Anup Patel <anup.patel@wdc.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 kvm-ppc@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Nov 12, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > 
> > Memslot ID to the corresponding memslot mappings are currently kept as
> > indices in static id_to_index array.
> > The size of this array depends on the maximum allowed memslot count
> > (regardless of the number of memslots actually in use).
> > 
> > This has become especially problematic recently, when memslot count cap was
> > removed, so the maximum count is now full 32k memslots - the maximum
> > allowed by the current KVM API.
> > 
> > Keeping these IDs in a hash table (instead of an array) avoids this
> > problem.
> > 
> > Resolving a memslot ID to the actual memslot (instead of its index) will
> > also enable transitioning away from an array-based implementation of the
> > whole memslots structure in a later commit.
> > 
> > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   include/linux/kvm_host.h | 16 +++----
> >   virt/kvm/kvm_main.c      | 96 +++++++++++++++++++++++++++++++---------
> >   2 files changed, 84 insertions(+), 28 deletions(-)
> > 
> (..)
> > @@ -1259,17 +1257,49 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
> >   	return 0;
> >   }
> > +static void kvm_replace_memslot(struct kvm_memslots *slots,
> > +				struct kvm_memory_slot *old,
> > +				struct kvm_memory_slot *new)
> > +{
> > +	/*
> > +	 * Remove the old memslot from the hash list, copying the node data
> > +	 * would corrupt the list.
> > +	 */
> > +	if (old) {
> > +		hash_del(&old->id_node);
> > +
> > +		if (!new)
> > +			return;
> > +	}
> > +
> > +	/* Copy the source *data*, not the pointer, to the destination. */
> > +	if (old)
> > +		*new = *old;
> 
> This way of writing it (that, is re-checking whether "old" is not-NULL)
> suggests that it could have been set to NULL inside the previous block
> (since the last check), which isn't true.

Yeah, I think I was trying to minimize the logic delta in future patches, but
looking back at the diffs, that didn't pan out.  I've no objection to folding
the two together.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

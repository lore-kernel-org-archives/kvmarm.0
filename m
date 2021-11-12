Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AEBC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 01:05:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9A0861106
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 01:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A9A0861106
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34FB24B199;
	Thu, 11 Nov 2021 20:05:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L3cEtuimHQpH; Thu, 11 Nov 2021 20:05:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28B934B231;
	Thu, 11 Nov 2021 20:05:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADE094B199
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 20:05:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S8LwCCc7SSaP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 20:05:32 -0500 (EST)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A73924B192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 20:05:32 -0500 (EST)
Received: by mail-pf1-f180.google.com with SMTP id z6so7067368pfe.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 17:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=qIP3115D8X5svI1diQgiEcs//yqAqweVaUHfcv0HJnk=;
 b=gf554YHamci0DjUeVoZGJM9DOyXF+0SyUupZIF5IPY2cI9p2DatJ2USEjqu0xXifqV
 edjai3eTEtZQ8kQGbZs7d7Z7C15ddHZCGcYL3l3HeGlZRfffhdcwYAuRyJSd5gETgxWT
 yLNteK8tM4CfxpX7aPSWrcYkn7XhezHyrLOvS/D7LuUOUaU64FC3UuIcMReDTB79mTES
 QgRrs4WD82tMKsnnw7WDZ1CrEmW96jd/E14dYVs3INUpTy+GkkmVW2cT4+YCL5cjsCPL
 +tIV730AkW1ZKhOoB0H06e8044D6Lc1J08cwloc48Jw1uNWmresmiA1nxkB4w8of5HB5
 mVBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qIP3115D8X5svI1diQgiEcs//yqAqweVaUHfcv0HJnk=;
 b=AzFx8hRiuq1dIA7SUuax+WQ+cGvIAAy+k0ms7oZnH52IInCbTaleN+9T35Vk7ankYr
 7vE38xa1+ymSJvnjOAvdQ3eD5LeS/qXeE4mTAX0lCggZqJCPE0MfN5PlXt4C2eKR9e37
 FWt66AJmKJiTMzhTMtmDPj++k038elCORnmUC9ml2TYVeRZSUaZzPLs3Lj4Y2owFnO04
 AbKE6upUJmuZ/tZpufUYinNS5+6sfyHVquVpEjWU81oGFYBnYA9QhaIH4Aw5/CEY9NdU
 8Fv+mpEMxgCxl/IfDy8uP3q0wPM1wlnyPP4Xy9VzPauGNVA1lpp5nH+tW4CNQap48lp2
 twGQ==
X-Gm-Message-State: AOAM5313hIGNB3rHywDvnyGGQhGgcZH3OVBgu673Bo6ltJwD7wVrOIuW
 A/5zdR6ASKaCmCCHeldjIbDjrw==
X-Google-Smtp-Source: ABdhPJx45D4HU2DqXINd3JCy7/gtFEnfRNSJTdzRC106LwgioqW5s9+ZH9bnEHC0LBIDe1RslUxzZw==
X-Received: by 2002:a63:8048:: with SMTP id j69mr7469829pgd.111.1636679131571; 
 Thu, 11 Nov 2021 17:05:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id b9sm3251946pgf.15.2021.11.11.17.05.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Nov 2021 17:05:30 -0800 (PST)
Date: Fri, 12 Nov 2021 01:05:27 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 24/30] KVM: Use interval tree to do fast hva lookup
 in memslots
Message-ID: <YY2919Td8f+F4EDr@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-25-seanjc@google.com>
 <d76707b5-8710-b1a6-0cc6-defdaf9e37b7@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d76707b5-8710-b1a6-0cc6-defdaf9e37b7@oracle.com>
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
> > @@ -1262,22 +1274,32 @@ static void kvm_replace_memslot(struct kvm_memslots *slots,
> >   				struct kvm_memory_slot *new)
> >   {
> >   	/*
> > -	 * Remove the old memslot from the hash list, copying the node data
> > -	 * would corrupt the list.
> > +	 * Remove the old memslot from the hash list and interval tree, copying
> > +	 * the node data would corrupt the structures.
> >   	 */
> >   	if (old) {
> >   		hash_del(&old->id_node);
> > +		interval_tree_remove(&old->hva_node, &slots->hva_tree);
> >   		if (!new)
> >   			return;
> >   	}
> > -	/* Copy the source *data*, not the pointer, to the destination. */
> > -	if (old)
> > +	/*
> > +	 * Copy the source *data*, not the pointer, to the destination.  If
> > +	 * @old is NULL, initialize @new's hva range.
> > +	 */
> > +	if (old) {
> >   		*new = *old;
> > +	} else if (new) {
> 
> Unnecessary check - if "new" is NULL then the code will crash anyway
> accessing this pointer unconditionally...
> 
> > +		new->hva_node.start = new->userspace_addr;
> > +		new->hva_node.last = new->userspace_addr +
> > +				     (new->npages << PAGE_SHIFT) - 1;
> > +	}
> >   	/* (Re)Add the new memslot. */
> >   	hash_add(slots->id_hash, &new->id_node, new->id);
> > +	interval_tree_insert(&new->hva_node, &slots->hva_tree);
> 
> ...in these two lines above.

Yep, definitely worthless.  I think this was another "plan for the future" idea
that didn't actually add value.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FB3C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 01:17:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 689B16134F
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 01:17:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 689B16134F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D895B4B1A4;
	Mon,  8 Nov 2021 20:17:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D28OWZ6XWrMM; Mon,  8 Nov 2021 20:17:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F2124B178;
	Mon,  8 Nov 2021 20:17:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B62E4B12F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 20:17:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KdVeYXLUQA+V for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 20:17:45 -0500 (EST)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14BA44B11B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 20:17:45 -0500 (EST)
Received: by mail-pl1-f180.google.com with SMTP id q17so5779772plr.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 17:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=gT3MUMtIZ0PS90yl0lE9QBzqwoRSMBq2QOt4vNKzTys=;
 b=b13sxWM9K5iisnYPadl4iOffaoys9RijOi3mTsZncT79yh0EYcQ5zP36xW3B53gbfI
 hf38uXQxIRmk/GO8JXWSnV+gRSRIGZYtVYUdIsHAt6HO9GbiW9mBH/HQFPbdGVhmJzAE
 d+5xCaoOiMJhRE25WFHguzeVSIifxnExemfwDQtGBdPF4S9WTr8CvKXghy1m1SqKVnwm
 EERujOqfJ1YA7bmWxiB6FDxmsEbHoK9/PEVJSGjKx5CzfV6eZDPa/bWo0671IUu3X0m3
 XIR3TxcculNhN3pd4DHjS7KL7tM8G3YWRmURA4LG43nJsj/84/En3IvJRGamYai7QoJh
 2EpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gT3MUMtIZ0PS90yl0lE9QBzqwoRSMBq2QOt4vNKzTys=;
 b=RHfGN4yn70nzsefbNxbdBH47cf4qYDZqTbj0vvJrJuWHtAa32J+2gIPnBSB3Di9Ycl
 dOfBZxg/w5bm8L1hDXOG+DB9qLTz3AlML9imiG2xR/KllRO9T+dhB4DH/r0RVACTrSjz
 5PHormYObY8/kTUyP326IBC0+e3gtYLlEazFtEbn26uyLJnrHJA1Oq+Iya5Kp3tXYDoe
 d9EOjX464wzoYBFRlOxhfydQIo0MABdlnQGH3R7bGPYI1fvlNhyWnAIkz5jDfDTtaNpG
 vC4yOnobQ8i1iHipa89P3HZ+VyC/hQeBcN31BVQqoJKG0QOOk0e2BOIxnbllKxpz949Z
 Fjqg==
X-Gm-Message-State: AOAM5338IVJfvbn/8wy2C1/HK6lkN0FnLm14hkJikIFhvOw+avYh+560
 IIxzZ8DdrNAkyXRZT4KxGjOHVQ==
X-Google-Smtp-Source: ABdhPJxdGShKmFpj2IYQOxd+oGtoXe5J3Pj9Ip1XNoCcHBZfb0/9N7iKTadK2twJpq0wRG+MfXG5fA==
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id
 i11-20020a1709026acb00b0014276c3d35fmr3494468plt.89.1636420663931; 
 Mon, 08 Nov 2021 17:17:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id q13sm18256433pfj.26.2021.11.08.17.17.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 08 Nov 2021 17:17:43 -0800 (PST)
Date: Tue, 9 Nov 2021 01:17:39 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 01/30] KVM: Ensure local memslot copies operate on
 up-to-date arch-specific data
Message-ID: <YYnMM17yXMq8cCTn@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-2-seanjc@google.com>
 <6407c2d3-854b-edf6-9990-b54a5baedd0a@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6407c2d3-854b-edf6-9990-b54a5baedd0a@oracle.com>
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

On Tue, Nov 09, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > @@ -1597,6 +1596,26 @@ static int kvm_set_memslot(struct kvm *kvm,
> >   		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
> >   	}
> > +	/*
> > +	 * Make a full copy of the old memslot, the pointer will become stale
> > +	 * when the memslots are re-sorted by update_memslots(), and the old
> > +	 * memslot needs to be referenced after calling update_memslots(), e.g.
> > +	 * to free its resources and for arch specific behavior.  This needs to
> > +	 * happen *after* (re)acquiring slots_arch_lock.
> > +	 */
> > +	slot = id_to_memslot(slots, new->id);
> > +	if (slot) {
> > +		old = *slot;
> > +	} else {
> > +		WARN_ON_ONCE(change != KVM_MR_CREATE);
> > +		memset(&old, 0, sizeof(old));
> > +		old.id = new->id;
> > +		old.as_id = as_id;
> > +	}
> > +
> > +	/* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
> > +	memcpy(&new->arch, &old.arch, sizeof(old.arch));
> 
> Had "new" been zero-initialized completely in __kvm_set_memory_region()
> for safety (so it does not contain stack garbage - I don't mean just the
> new.arch field in the "if (!old.npages)" branch in that function but the
> whole struct) this line would be needed only in the "if (slot)" branch
> above (as Ben said).
> 
> Also, when patch 7 from this series removes this memcpy(),
> kvm_arch_prepare_memory_region() does indeed receive this field
> uninitialized - I know only x86 and ppcHV care
> and kvm_alloc_memslot_metadata() or kvmppc_core_prepare_memory_region_hv()
> then overwrites it unconditionally but it feels a bit wrong.
> 
> I am almost certain that compiler would figure out to only actually
> zero the fields that wouldn't be overwritten immediately anyway.
> 
> But on the other hand, this patch is only a fix for code that's going
> to be replaced anyway so perfection here probably isn't that important.

Yeah, that about sums up my feelings about the existing code.  That said, an
individual memslot isn't _that_ big, and memslot updates without the scalable
implementation are dreadfully slow anyways, so I'm leaning strongly toward your
suggestion of zeroing all of new as part of this fix.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

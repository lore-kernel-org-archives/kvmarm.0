Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1F6C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 10:04:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0DC249F30;
	Tue, 15 Mar 2022 06:04:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UY6D7WlnSLAW; Tue, 15 Mar 2022 06:04:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE0D549F13;
	Tue, 15 Mar 2022 06:04:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0984B49F07
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:04:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WGFxe0WvJgIy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 06:04:23 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0BFA49F03
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:04:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647338663;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=e3sYeRog9xVBlURoyGNfLxZdt5XjPC0pgpdORBabjrk=;
 b=IG0NCml4K35mb0/VwfcjH1Q7IMmtTgyBuI44/ygMYbJPOu/Tw+oKRprTBisZGvg88QxL2i
 gQQujbiBm6/rgtaBiBBJveByoysPUxPR8y7TMTZERe03ufsvswJXk6p3tLcbAwsi8L4v27
 eWsytpYUvrq3C4MDuRNlROMlCSFqf0g=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-2G-2d-rFNN-gAletlW17tw-1; Tue, 15 Mar 2022 06:04:22 -0400
X-MC-Unique: 2G-2d-rFNN-gAletlW17tw-1
Received: by mail-pj1-f71.google.com with SMTP id
 p5-20020a17090a748500b001bee6752974so1692525pjk.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=e3sYeRog9xVBlURoyGNfLxZdt5XjPC0pgpdORBabjrk=;
 b=Ax8dS5RN/ZpY7DtbUKfplFXHVvDYFRhC3vTFO2iDFEcZ8XpEtMAtq77ZNnsnStBoaK
 CC+cE88K7Ei6QE7/MGKxLsr20/hHLqaPZ4ePal2f5BEiFIzUpIJMdzkgRiDzWPzox8tC
 wLmqPBI0d+GzPjId3ZbGmyCPwoYOPuGYSoUW9oLzlvvtRtQpvDpd8KYYQ1pOL+qz4O6f
 2SisFpbL0pMJlDkJe9cjA/moGxihctnWEsnfVfW5gWk8t8IVkoAnPxaxCMDa9es/yjZq
 AWJNca1NPr3jqH2lkigfXwpApts+Se6bbdU/t7wykxMAzeBmjy0Gx6z22pLunny6idYV
 9OJA==
X-Gm-Message-State: AOAM533q3EL8tGbH/OEAgK72n5neUalvMJCIJtYM8g+YChF8cK4lIwUJ
 Vyeh08Lo1YRzjddApMmcdGDgNa0aGEA73g4fdY3lGeCIPk2HdJ0Lh0keku+/UjQJbv4fCx/Yrwp
 ApHtBBt1fFOi0TBC3blgRmPGI
X-Received: by 2002:a17:902:bf07:b0:14f:a3a7:97a0 with SMTP id
 bi7-20020a170902bf0700b0014fa3a797a0mr27411312plb.105.1647338661064; 
 Tue, 15 Mar 2022 03:04:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/mxd/EICNmoMZpJXHgMSaHmG8FbtpYeONh4CGs4wC9FfIAYpFlKVQt5+VFKco/YMnRgFgaA==
X-Received: by 2002:a17:902:bf07:b0:14f:a3a7:97a0 with SMTP id
 bi7-20020a170902bf0700b0014fa3a797a0mr27411274plb.105.1647338660772; 
 Tue, 15 Mar 2022 03:04:20 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 5-20020a17090a1a4500b001c54dc9061esm2475481pjl.51.2022.03.15.03.04.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 03:04:20 -0700 (PDT)
Date: Tue, 15 Mar 2022 18:04:11 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 08/26] KVM: x86/mmu: Link spt to sp during allocation
Message-ID: <YjBkm8mYKNc5sdpU@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-9-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-9-dmatlack@google.com>
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
 maciej.szmigiero@oracle.com,
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

On Fri, Mar 11, 2022 at 12:25:10AM +0000, David Matlack wrote:
> Link the shadow page table to the sp (via set_page_private()) during
> allocation rather than initialization. This is a more logical place to
> do it because allocation time is also where we do the reverse link
> (setting sp->spt).
> 
> This creates one extra call to set_page_private(), but having multiple
> calls to set_page_private() is unavoidable anyway. We either do
> set_page_private() during allocation, which requires 1 per allocation
> function, or we do it during initialization, which requires 1 per
> initialization function.
> 
> No functional change intended.
> 
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Ah I should have read one more patch before commenting in previous one..

Personally I (a little bit) like the other way around, since if with this
in mind ideally we should also keep the use_mmu_page accounting in
allocation helper:

  kvm_mod_used_mmu_pages(vcpu->kvm, 1);

But then we dup yet another line to all elsewheres as long as sp allocated.

IOW, in my opinion the helpers should service 1st on code deduplications
rather than else.  No strong opinion though..

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

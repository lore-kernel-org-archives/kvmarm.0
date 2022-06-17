Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB351C43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 15:02:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48B5349F31;
	Fri, 17 Jun 2022 11:02:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9brqOOvfKA0R; Fri, 17 Jun 2022 11:02:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A8E04B32D;
	Fri, 17 Jun 2022 11:02:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B13164B2BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 11:01:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0zPAoMPxy7s8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 11:01:58 -0400 (EDT)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E37E49F31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 11:01:58 -0400 (EDT)
Received: by mail-pl1-f171.google.com with SMTP id r1so4090647plo.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 08:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=67qC+hjpQQ8/u9lImvfqVDPKc0MC50T6OyuazzxQTOs=;
 b=rcfjRAXxIPRtebzytFQ4rdSLQPqdVJUVxjkJrOP2+ko477yKr0ij30QC5VTxQvmOZ1
 bFDDGtEpXpALWRNA0AKUnQh24Ko2VZIH+URIKsdIq0cycBHC6uFgxJU9+xElyqc8enXi
 h8CN/B/Frtq3zfIeRuxjL024ZWbiEDZgVBKOOL1LsuCCvGmmVR08SIqY8f6S6o4Xlo5T
 bCUAM0Ri8COUC7loHrkQgZQk6SBAQ+fUUa+AdDjmblGImt7BZanv1Pn5xBfUFA8ISN2H
 g2VrKo7DWnK0HLqxyahPVDdaz0lu7ZBRlpMfVPvpgyT87bUFm74HAYxaB2zDe5kuSQVV
 DaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=67qC+hjpQQ8/u9lImvfqVDPKc0MC50T6OyuazzxQTOs=;
 b=HjtWpunLT8IXXp3nSb7cXsWiKKiLvhEPL0urHkKiC5ICEkBb7PA2ZFvrWhTYBWNPhv
 t2S/sJTqYzcTFVn3+fvKfJKZDBbLefsSj96hAiPSEee5EOQcK96pHk+iMm2pF5JxvB7P
 SlGjidvDKN6drrpqBTHSlswp9TIWhbrQglqaA09mpMwRx+DD5BjlDlSLCoBGUnTK2KCr
 ROKkARpBj+C79Ykbj4dSPE7fkbUVrD7kF6ex0yYw6iwPkWgQ6B7rdJI2M4TcFZbkQ3p2
 WIcAXsP9KOxgx2zlmJNRAdxyVOh4P4le4bYJMCB6P1WXFSQxVmw650Ar5I61FzPlVM41
 r+nQ==
X-Gm-Message-State: AJIora/PU3/hnBHVu8B4kAD+Hdw97OE5M9Am3ZbgmOFkGpchxziSvzCj
 0Xes0iAFNNmKFcwh9rUwZYxn8A==
X-Google-Smtp-Source: AGRyM1uFEQsMzgu/EpRCLWD/tpRg2MiJuqY9ezxKkezmOL1sxRiLi0E4PmGYF22syg3VejhQ2hPZIA==
X-Received: by 2002:a17:90b:1e4e:b0:1e3:47e4:92b6 with SMTP id
 pi14-20020a17090b1e4e00b001e347e492b6mr21981003pjb.47.1655478117043; 
 Fri, 17 Jun 2022 08:01:57 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 s17-20020a17090a5d1100b001e0d4169365sm5724411pji.17.2022.06.17.08.01.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 08:01:56 -0700 (PDT)
Date: Fri, 17 Jun 2022 15:01:52 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 10/22] KVM: x86/mmu: Pass memory caches to allocate
 SPs separately
Message-ID: <YqyXYJsoZGgp7l62@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-11-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-11-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
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

On Mon, May 16, 2022, David Matlack wrote:
> Refactor kvm_mmu_alloc_shadow_page() to receive the caches from which it
> will allocate the various pieces of memory for shadow pages as a
> parameter, rather than deriving them from the vcpu pointer. This will be
> useful in a future commit where shadow pages are allocated during VM
> ioctls for eager page splitting, and thus will use a different set of
> caches.
> 
> Preemptively pull the caches out all the way to
> kvm_mmu_get_shadow_page() since eager page splitting will not be calling

Uber nit, "eager hugepage splitting" to provide a mental cue/reminder for why
those pages are direct.

> kvm_mmu_alloc_shadow_page() directly.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

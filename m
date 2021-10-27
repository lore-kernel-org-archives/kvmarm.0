Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11B5C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 14:41:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C2B3610FC
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 14:41:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C2B3610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7784B1A4;
	Wed, 27 Oct 2021 10:41:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id moL2cAUp9P+q; Wed, 27 Oct 2021 10:41:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D67424B18F;
	Wed, 27 Oct 2021 10:41:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 627684B15A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 10:41:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4I5nfxSRmGsr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 10:41:35 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F64F4B09C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 10:41:35 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id
 n11-20020a17090a2bcb00b001a1e7a0a6a6so5349615pje.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 07:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=6OXSnlnR0rRr4zd42xResiJ3HjI4vG4520z7JUuMyYs=;
 b=BjRC0MDFBU5q9E3Xn8qZmMldFXyvZ//eySha9xAzB0jmoDoGvnBh5rZJNDCpSwdREy
 9EoAYcD7qkeaNtvcOM9mdpbf0o5Zx8GfPrl52oPVsVupbvte1MAYXeh2gVgPvsjmKTcr
 OvG3N8s6IdOwoiORDWmu79MSfTC8tCdjVwsKVWNIZ01jMG+JmYVN7Tn36JxeYZuyLkmP
 l/68I6qwCJelKOJxW8ZO7A5e+myyHTZHJETfMvox2BFMDLmdkBWjqGYYnYuVXEvP/t+D
 dTunWvGIgVZuDjHHD1Ty/XEe2DuBSz3CLrLeXdA9pKLBh6KsJK0Pre9s46e4k0Dr+ooy
 7X+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6OXSnlnR0rRr4zd42xResiJ3HjI4vG4520z7JUuMyYs=;
 b=MuMctsuDs6JYwhaFsV3GbrrwF4SbBalV8uoogfCyxTMUNsktEZu5sqVszkbw8khBDZ
 nmXxATDoVZ6z5uNg+oJ91eXl3ccjd9+zO9zrkMfDme4/dEfCEuKvSRaLFwi86NtFmBNr
 DHb3YDnri27yRrNYPgo7nNoPBqksQJymiNPD+IwEGU25NkyCEqtYmYjnK02aeZKRPKLP
 X8PXCn1rwvVLBzchYo5DTR8vrZAU+h8QYaDY5CQZtiTvKA7fScB3GX0wEi5z7Hg094xT
 nTx3NNkMHQYnOt17P0/SczQk66Za1jnXHMKiO0yJtn76UBdB41wn9uEDgq37qubmI4R5
 cIAg==
X-Gm-Message-State: AOAM531filAC9PKJPA+iE5Z1GSkGaa9YUQlPh2LtQVTcxaX3RS/K4VX9
 EmjbFWyhzfngLCk2p3lnJQ8AtQ==
X-Google-Smtp-Source: ABdhPJwpvrRMvTZfA8g36IWigq/Ddl2lTxPKT07H9cOHEBI6XhDgd4CVWZEorIKgU9/kACcZuDTlgw==
X-Received: by 2002:a17:902:e812:b0:13f:3be8:b15a with SMTP id
 u18-20020a170902e81200b0013f3be8b15amr27601253plg.49.1635345693861; 
 Wed, 27 Oct 2021 07:41:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id e9sm203521pfv.189.2021.10.27.07.41.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Oct 2021 07:41:33 -0700 (PDT)
Date: Wed, 27 Oct 2021 14:41:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
Message-ID: <YXllGfrjPX1pVUx6@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 09/10/21 04:11, Sean Christopherson wrote:
> Queued 1-20 and 22-28.  Initially I skipped 21 because I didn't receive it,
> but I have to think more about whether I agree with it.

https://lkml.kernel.org/r/20211009021236.4122790-22-seanjc@google.com

> In reality the CMPXCHG loops can really fail just once, because they only
> race with the processor setting ON=1.  But if the warnings were to trigger
> at all, it would mean that something iffy is happening in the
> pi_desc->control state machine, and having the check on every iteration is
> (very marginally) more effective.

Yeah, the "very marginally" caveat is essentially my argument.  The WARNs are
really there to ensure that the vCPU itself did the correct setup/clean before
and after blocking.  Because IRQs are disabled, a failure on iteration>0 but not
iteration=0 would mean that a different CPU or a device modified the PI descriptor.
If that happens, (a) something is wildly wrong and (b) as you noted, the odds of
the WARN firing in the tiny window between iteration=0 and iteration=1 are really,
really low.

The other thing I don't like about having the WARN in the loop is that it suggests
that something other than the vCPU can modify the NDST and SN fields, which is
wrong and confusing (for me).  The WARNs in the loops made more sense when the
loops ran with IRQs enabled prior to commit 8b306e2f3c41 ("KVM: VMX: avoid
double list add with VT-d posted interrupts").  Then it would be at least plausible
that a vCPU could mess up its own descriptor while being scheduled out/in.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

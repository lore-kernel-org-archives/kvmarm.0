Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614A1C43334
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jun 2022 14:54:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D26F84B282;
	Tue, 21 Jun 2022 10:54:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v6KuX4zPCMF2; Tue, 21 Jun 2022 10:54:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEA214B2B1;
	Tue, 21 Jun 2022 10:54:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB3AA4B283
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 10:54:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jDD5hVDBwjoj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jun 2022 10:54:23 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DF794B248
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 10:54:23 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id
 h9-20020a17090a648900b001ecb8596e43so4470132pjj.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 07:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ePpQR91B1wy0uIyvmn3lmteXD4y16fGYbzlfAq99TJo=;
 b=coFv7I5Y78JhXoxS37XR9c+mZYbk7SXPwuO7aREgBr4Q4xY/8nD/BF5WkQBHENLFnR
 M2swZ0YHKkbeZ6TusTYTCyinn24BoObIO+T5wnAXl9f2sGVIP8rG2F0nAbxkmCVGoPfH
 dAA8jbBGQ+fJqAoZJEhloFcXw4ggDv8whrRonPLp5/G9ruQkcs3nglSNUwAkZ1SThAWs
 1rcmQq3sdA0WobCN3wZET42yLYirfqnABm0YdtxHceX3EHLEBkMtv0LKHMPI3jgadxxF
 dsa+Azc2y1bTS9+0PGwluDhQy+WUsYOcrTtvwmmyLjgGWHBJwb4h86H6/giVMU3D/eNI
 BJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ePpQR91B1wy0uIyvmn3lmteXD4y16fGYbzlfAq99TJo=;
 b=XFEgPlqqsoRVpT6fc1endDRc9moGSfyYfPPgMro9rgRR0x2sHH8wDwqR1UhyzexHpD
 2GsTnFnQ+A3DBwk/gaYqe/hZgqwca+dxBWhSWXA2+R9UFEj/smc7onQUzijzHyJIvXBY
 7SVSxABHWZ8Yqd9TByjyiPwsiReZkrqn39J4sEMfD0yoZgdn5hq+BZQEedUbDW7GAW8U
 UDiFF9iDe9DhHpd3Dsw/RMB9zrVX1tWSW3JzNmD10EkKmRrUV93VZnPBJ4qWP6uEh9P6
 FKPUo9X9l/4R8DjgcDJlvdc0Wjvwjx2a6EetwGYfX7uInvG+uSJ6s5R1Je3LF5R5/6yK
 gxmg==
X-Gm-Message-State: AJIora+iIcF/Q+p2arOZDJJvbQHMq3Qs7UoRkFV4SwU1y80xrHkh8I7q
 0+QcRcBag1tscnB+mZlyFeYk7g==
X-Google-Smtp-Source: AGRyM1vbuWPmzs8GSCKmhq+oi4jC8RW6CP9GBVkjErftz4qJu7wc14nAXYcvbe2B5lTWXF3n/kUg1Q==
X-Received: by 2002:a17:90b:4a82:b0:1ec:bb6b:38d0 with SMTP id
 lp2-20020a17090b4a8200b001ecbb6b38d0mr7523665pjb.213.1655823262366; 
 Tue, 21 Jun 2022 07:54:22 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 b21-20020aa78115000000b00518764d09cdsm11307136pfi.164.2022.06.21.07.54.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Jun 2022 07:54:21 -0700 (PDT)
Date: Tue, 21 Jun 2022 14:54:18 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] KVM: selftests: Consolidate ucall code
Message-ID: <YrHbml1HAfDtvMfn@google.com>
References: <20220618001618.1840806-1-seanjc@google.com>
 <19bba1a0-8fb7-2aae-a65a-1111e29b92d3@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19bba1a0-8fb7-2aae-a65a-1111e29b92d3@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Atish Patra <atishp@atishpatra.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Colton Lewis <coltonlewis@google.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm-riscv@lists.infradead.org, Paul Walmsley <paul.walmsley@sifive.com>,
 linux-riscv@lists.infradead.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Jun 20, 2022, Paolo Bonzini wrote:
> On 6/18/22 02:16, Sean Christopherson wrote:
> > Consolidate the code for making and getting ucalls.  All architectures pass
> > the ucall struct via memory, so filling and copying the struct is 100%
> > generic.  The only per-arch code is sending and receiving the address of
> > said struct.
> > 
> > Tested on x86 and arm, compile tested on s390 and RISC-V.
> 
> I'm not sure about doing this yet.  The SEV tests added multiple
> implementations of the ucalls in one architecture.  I have rebased those
> recently (not the SEV part) to get more familiar with the new kvm_vcpu API
> for selftests, and was going to look at your old review next...

I had forgotten about that code.  My idea of a per-VM list[*] would fit nicely on
top, though maybe drop the last patch from this series.

[*] https://lore.kernel.org/all/Yc4gcJdhxthBKUUd@google.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

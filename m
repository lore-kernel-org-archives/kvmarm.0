Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4C3C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 01:21:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 863B861242
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 01:21:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 863B861242
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A0CA4B1A9;
	Mon,  8 Nov 2021 20:21:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qxkUOPf+61zK; Mon,  8 Nov 2021 20:21:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D88BD4B16C;
	Mon,  8 Nov 2021 20:21:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9D9C4B125
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 20:21:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a1X1tE1K7bsb for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 20:21:13 -0500 (EST)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93CAB4B11F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 20:21:13 -0500 (EST)
Received: by mail-pf1-f181.google.com with SMTP id m26so17833371pff.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 17:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xrX5PIQ5N2CnAG0B54w4TYQMlOw3gRJk552Ipp+ebKw=;
 b=Stz43RdVom5q6hSvN+LnhdAH1B5D0RUDmznyrJp0pQFRjJeWUrzR/udLPaY2tilNCt
 XcgrdLFIIf2+mR8m54M6dT+Dbrc35be5RRM9b9uL9pOdJ4j7hQwoxKcdUZiCi2W8rFeo
 mmXBUYtpY4TQWJozh8/OxpMOOMnVYCLM8GwnYcFgDNGHVKOZqBpYEqqfKv0BxApaEO6w
 QHgCpUm2hA6iGp0NqZEk59gkrY4Hh/+mLGmE93ORS8+YVRoDiSXYWhEz8HkG7mLHejSo
 f65DHHDi9o/I209K1+WG4QDyN4k9mmBRl/VShVuSsU+pG0yGr+qfqYoTiN2J1n0hf0oV
 3pUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xrX5PIQ5N2CnAG0B54w4TYQMlOw3gRJk552Ipp+ebKw=;
 b=AWhCRQxo2oLJOJfUyLKLDkuybVkWTOVYBVnMdYwBfs0xYZ1IvUXv4ulcsVzWgZYtTf
 xaqD6CvGeQZInXXVCQiGIDXerdUuBZK8O2d8jLfimcG1/XFhUxtgqnb5Axcie1fiU1md
 4p0Kz95pyscr5/v7r9SUX/7VUwkfAcL2iFc5Tz1g/WzDv8pBfk2kbGR2snw1vCDR6RE1
 d/vHDGZcl6V/vUzYFf0XIpvqAvzwITSKgOG9IJMx4TpS/itYhDqYb/AzBuvNl6xitOMG
 0UAM6L63H5ywFdhLU7pNp5yjvqV81ZvvNjLOZaP0jAH/tk0WW8jMIJ1v7Ppxh0t7gLaw
 ULcw==
X-Gm-Message-State: AOAM531vknOeRewJV3BK9Sl5l7rcEghrJ/0ne7PGr4xBbW6bog1Dbcub
 KmfT/FP6ky9axaX8rQH/ai8hOA==
X-Google-Smtp-Source: ABdhPJzT4cwDWE/OiPQTr+XYp5T2lNnL8iaG9fSc3ur50OFq8TyJ/z2y4+XiWK6EYq8MqHpQV5QIIA==
X-Received: by 2002:a63:8a4a:: with SMTP id y71mr2992478pgd.378.1636420872463; 
 Mon, 08 Nov 2021 17:21:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id t13sm11751282pfl.214.2021.11.08.17.21.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 08 Nov 2021 17:21:11 -0800 (PST)
Date: Tue, 9 Nov 2021 01:21:07 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 00/30] KVM: Scalable memslots implementation
Message-ID: <YYnNA5lZNXXdX/ig@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <cb4f5d6e-9535-dd57-d8ee-3b593a81f3a6@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cb4f5d6e-9535-dd57-d8ee-3b593a81f3a6@oracle.com>
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
> By the way, do you want your patches and my non-invasive patches (patches
> below number 23) merged without waiting for the rest of the series to be
> fully ready?
> 
> This way there is less risk of conflicting changes to KVM being merged
> in meantime while we are still discussing the remaining patches.
> Or worse - changes that don't conflict but subtly break some assumptions
> that the code relies on.
> 
> For this reason I am strongly for merging them independently from the
> more invasive parts.

Merging them as soon as they're ready would also be my preference.  That said,
I'm hoping we can get the entire implemenation queued up for 5.17 sooner than
later.  I'll do my best to respond quickly to try and make that happen.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

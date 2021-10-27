Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2229C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:08:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 636C760C51
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:08:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 636C760C51
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5DB44B135;
	Wed, 27 Oct 2021 12:08:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w9mF-rB78RHg; Wed, 27 Oct 2021 12:08:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A189A4B153;
	Wed, 27 Oct 2021 12:08:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F3F14B135
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 12:08:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fcGvFXPPitrd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 12:08:16 -0400 (EDT)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E215449F6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 12:08:15 -0400 (EDT)
Received: by mail-pl1-f181.google.com with SMTP id n11so2336588plf.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 09:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=nuCG2sDmKSazCUE8+q7TBUWWroJna3waN17Ediudyfo=;
 b=WayoYs/G9RdOkLoLrW/BVqQ6VHPjU7g6BiG68joHyMmGiaL20yIAm/sjYdgZ0AcKJs
 34UBgRu//I/mwxBVohule4Yths3kAXuGugB26iPsHfMV54dBZzCrAdfuAma3wIvwLeK6
 5skY2C5JFSSaU21tpOr7VxrfykS9z8ABV/qEMvBoTKNuCyH2eBt8P1cnnpOyhrcPdGo+
 3TUr8nLyCGNKiIm+cC1pm1SLzFfEEKhREJTeZJJEMdJpd9SDcl6sMun3hCIhWgt/3aha
 W9nnj4Eu9amjlrLiAUIeygQ3FCEkFDEH7LYoF5wU+epaInjt/QY5/ndeDbqHbN0vOY3t
 ydmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=nuCG2sDmKSazCUE8+q7TBUWWroJna3waN17Ediudyfo=;
 b=muycYZMbWL3n6S/p3z+4jIS1WAQZopd680EOiy2kfQUXbMECMUc/GBnyyQjiaTulBL
 DMM70cUau4cLUIXuwh12vDlSfwfiS5CzAk8d8dwlMXnGC7ppiaIGI98K798t0HjJ55Hw
 X8lDxdeinyJeOcHbDJqmFbWxsccK/+IKxl3UN71w93+eH8VAkl7fqge3HgFQ2XI/Xzet
 3r9j4qLhi5nzJHnrVLzSAaX1/ozq8Ak6RcgsMrRVyUyVQU6hTjCTObORVksPg2ieHhh6
 vBVq2CO2X1f8GBoOTNYZFW5R59nKesq8EpiNT/yNH8eN4eeQ8f0Nh25qCdLPpjdXV0Hi
 pDmA==
X-Gm-Message-State: AOAM530867ymxXFaB8UrtH4vbzjPi9c6vdbXHSWrZbPbuPwC9XKbc9xr
 eEPDMvaOZr7DDPJL0CKB4X3JZw==
X-Google-Smtp-Source: ABdhPJyPOfADHe2BvEKrk8mpN6Tt9+dFmmc+qUaNZEHu6/XAOEzQt/0dcBcXvuMjJIUFdj/Jqau95A==
X-Received: by 2002:a17:90b:3ecc:: with SMTP id
 rm12mr6856073pjb.48.1635350894901; 
 Wed, 27 Oct 2021 09:08:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id lb5sm205466pjb.11.2021.10.27.09.08.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Oct 2021 09:08:14 -0700 (PDT)
Date: Wed, 27 Oct 2021 16:08:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 35/43] KVM: SVM: Signal AVIC doorbell iff vCPU is in
 guest mode
Message-ID: <YXl5anv0Lyjx1cws@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-36-seanjc@google.com>
 <0333be2a-76d8-657a-6c82-3bb5c9ff2e3b@redhat.com>
 <YXlrEWmBohaDXmqL@google.com>
 <185502d7-861e-fa5c-b225-419710fe77ed@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <185502d7-861e-fa5c-b225-419710fe77ed@redhat.com>
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

On Wed, Oct 27, 2021, Paolo Bonzini wrote:
> On 27/10/21 17:06, Sean Christopherson wrote:
> > > Does this still need to check the "running" flag?  That should be a strict
> > > superset of vcpu->mode == IN_GUEST_MODE.
> > 
> > No.  Signalling the doorbell when "running" is set but the vCPU is not in the
> > guest is just an expensive nop.  So even if KVM were to rework its handling of
> > "running" to set the flag immediately before VMRUN and clear it immediately after,
> > keying off IN_GUEST_MODE and not "running" would not be wrong, just sub-optimal.
> > 
> > I doubt KVM will ever make the "running" flag super precise, because keeping the
> > flag set when the vCPU is loaded avoids VM-Exits on other vCPUs due to undelivered
> > IPIs.
> 
> Right, so should we drop the "if (running)" check in this patch, at the same
> time as it's adding the IN_GUEST_MODE check?

LOL, I think we have a Three^WTwo Stooges routine going on.  This patch does
remove avic_vcpu_is_running() and replaces it with the vcpu->mode check.  Or am
I completely misunderstanding what your referring to?

-       if (avic_vcpu_is_running(vcpu)) {
+       /*
+        * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
+        * is in the guest.  If the vCPU is not in the guest, hardware will
+        * automatically process AVIC interrupts at VMRUN.
+        */
+       if (vcpu->mode == IN_GUEST_MODE) {
                int cpu = READ_ONCE(vcpu->cpu);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

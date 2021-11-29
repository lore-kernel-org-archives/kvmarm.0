Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4717C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 17:25:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49CE14B16F;
	Mon, 29 Nov 2021 12:25:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tP9APBxAVZIF; Mon, 29 Nov 2021 12:25:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D1F4B166;
	Mon, 29 Nov 2021 12:25:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35A774B156
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 12:25:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R8Og4mSi5SQa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 12:25:30 -0500 (EST)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1DBB4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 12:25:30 -0500 (EST)
Received: by mail-pl1-f176.google.com with SMTP id y8so12743313plg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 09:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Bxpm877ucu29+swtwCcWrV9CPuVdsV2sIZfuT/jfRmc=;
 b=OQsEdj0rbR41/5YmIUdSrIJYCBGgCTUy9MQ5b9N87MM6uHjwmzAsHY1InGAtcJzzT0
 kXYHaRVbVnijPR96HzFaJq33Sw0nxu7KBR5alKkujlnpJgTb7ASLVjrwO1SSGsYoOkaQ
 K7cyD5kT9W1uMzNVmFhkVgYWGz7yTXUI7MuAi/f6xjABudDnAM1CxSfahAqvYF0vFr+z
 P1vOrLjB/9DR5TYDkZ2qVm7gvSexhNg5yeXAFAs7Vo4H0IrRkItMjbCy7SznqoFOYmJJ
 HNBdnQMeynqmiQ4BF5DB9MM0TzHLeCRZF1Krj6haC25keEJILJKSu+fr0lje3TcmjayD
 +Y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Bxpm877ucu29+swtwCcWrV9CPuVdsV2sIZfuT/jfRmc=;
 b=E8Xf56z83FHzD3P9B4evbWH7rCcinTNl1+9CRoUqT45JXdh7QtHPWk2Kbyip+tzN/Z
 wPcVCr49j/Ir3srHdW5VCRyJKS1v7zb/u2DtsHxg0BpavWawyAcG9Prn0x85VOFOcgKc
 CFRMJ8hQIm1ptdETzGSyCdCbmbIqOMzv3cV/Hujd6YG621nPd32ltCYPsRk2gD4Wewij
 pxJLopFmePwOzTOFU8yPcGcVNFDrQLqOqkX48p5wARpTW4YzZr5lTbqA+jZECjzXhRNz
 72pVSWra1/CUuh+EdESniq9BZwPRIXn9Gk5M3d0fgV7254NpUykfT73BC8E0lVlq9/Ar
 AN2A==
X-Gm-Message-State: AOAM533yfcDlfPksKb9Ihi6ms1dpji+GyhMNvDb1v4YEmocyJ4i4Mi+A
 bOIMjKCz9m8L5lC+lFeon6haqQ==
X-Google-Smtp-Source: ABdhPJykBaUp6Ra73BKveHHRMZh4OnjUi7muGD2LnVC8BwpUUYIBB4aGQnyy+EYpnJ0P8dJ+mpdu6Q==
X-Received: by 2002:a17:902:7289:b0:142:805f:e2c with SMTP id
 d9-20020a170902728900b00142805f0e2cmr61761710pll.42.1638206729695; 
 Mon, 29 Nov 2021 09:25:29 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id m15sm18877279pjc.35.2021.11.29.09.25.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 29 Nov 2021 09:25:29 -0800 (PST)
Date: Mon, 29 Nov 2021 17:25:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Message-ID: <YaUNBfJh35WXMV0M@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
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
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Nov 29, 2021, Maxim Levitsky wrote:
> (This thing is that when you tell the IOMMU that a vCPU is not running,
> Another thing I discovered that this patch series totally breaks my VMs,
> without cpu_pm=on The whole series (I didn't yet bisect it) makes even my
> fedora32 VM be very laggy, almost unusable, and it only has one
> passed-through device, a nic).

Grrrr, the complete lack of comments in the KVM code and the separate paths for
VMX vs SVM when handling HLT with APICv make this all way for difficult to
understand than it should be.

The hangs are likely due to:

  KVM: SVM: Unconditionally mark AVIC as running on vCPU load (with APICv)

If a posted interrupt arrives after KVM has done its final search through the vIRR,
but before avic_update_iommu_vcpu_affinity() is called, the posted interrupt will
be set in the vIRR without triggering a host IRQ to wake the vCPU via the GA log.

I.e. KVM is missing an equivalent to VMX's posted interrupt check for an outstanding
notification after switching to the wakeup vector.

For now, the least awful approach is sadly to keep the vcpu_(un)blocking() hooks.
Unlike VMX's PI support, there's no fast check for an interrupt being posted (KVM
would have to rewalk the vIRR), no easy to signal the current CPU to do wakeup (I
don't think KVM even has access to the IRQ used by the owning IOMMU), and there's
no simplification of load/put code.

If the scheduler were changed to support waking in the sched_out path, then I'd be
more inclined to handle this in avic_vcpu_put() by rewalking the vIRR one final
time, but for now it's not worth it.

> If I apply though only the patch series up to this patch, my fedora VM seems
> to work fine, but my windows VM still locks up hard when I run 'LatencyTop'
> in it, which doesn't happen without this patch.

Buy "run 'LatencyTop' in it", do you mean running something in the Windows guest?
The only search results I can find for LatencyTop are Linux specific.

> So far the symptoms I see is that on VCPU 0, ISR has quite high interrupt
> (0xe1 last time I seen it), TPR and PPR are 0xe0 (although I have seen TPR to
> have different values), and IRR has plenty of interrupts with lower priority.
> The VM seems to be stuck in this case. As if its EOI got lost or something is
> preventing the IRQ handler from issuing EOI.
>  
> LatencyTop does install some form of a kernel driver which likely does meddle
> with interrupts (maybe it sends lots of self IPIs?).
>  
> 100% reproducible as soon as I start monitoring with LatencyTop.
>  
> Without this patch it works (or if disabling halt polling),

Huh.  I assume everything works if you disable halt polling _without_ this patch
applied?

If so, that implies that successful halt polling without mucking with vCPU IOMMU
affinity is somehow problematic.  I can't think of any relevant side effects other
than timing.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

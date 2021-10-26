Return-Path: <SRS0=G0pq=PO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D4DC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 26 Oct 2021 14:48:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E12AE60E74
	for <kvmarm@archiver.kernel.org>; Tue, 26 Oct 2021 14:48:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E12AE60E74
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6092F4B0B8;
	Tue, 26 Oct 2021 10:48:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DE1ugVxhJYXZ; Tue, 26 Oct 2021 10:48:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3E34B0D9;
	Tue, 26 Oct 2021 10:48:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6FB64B0B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 10:48:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GRJUaTRCZIUJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Oct 2021 10:48:08 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 552DC49F5D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 10:48:08 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 v1-20020a17090a088100b001a21156830bso2495558pjc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 07:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=t+GavL7jaDIOLO9+HWOF0JpCL4n+9982OXgOJJO3B68=;
 b=mMtlNqAGEx5moOXiuoulPA91tzGA7QXfJoC+FMrgS7kXKDaeQEPhlrtU0/6hIAVeF6
 4XgOag3S8f64bxtieFkoj/CBTBoyg71uy6bYxr2fBQK7J8y0qvj3yp4nxsZiGo0ugwoy
 chqWhQbdF2M/ss8dRD5cMeGRjF2i7TFbnWAE4XD/Gn+/ew4eCp8tBNWFi6mKqTjGiuSB
 4K+eMtDT8TA09mAfuKwzPO/bGE/KLqBK8ggRwFAk21MDpCSdzSupIOVWDECUMDk9Gucp
 WDZDdD8wswuh2DToiC42rEb1Gvw+Zc82wwd7L/2Pn0t+7EwhXqTAcJo8pcrg6fGfmqKg
 9NUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=t+GavL7jaDIOLO9+HWOF0JpCL4n+9982OXgOJJO3B68=;
 b=hzgITYwWQ3MpKiAmoFTAKBe1/xkWMUYV1IlvHZsMAClKIQ/9ULN5L3vsV87Us2FRIW
 HlQA9dfzRCsHkDz1kfw1og7alGambMEKRVyRjYYajxucjHfRCZEZeP9nvwiUvP00o2ux
 fdWYXAJ2cXhDoIljFM3n5EeiIXBTCXogCNkMF+TixeJBYe+Nm2GcOpeChe6w84ipF47R
 DF54A0I1UXN/bnq1P++g4+8gpvC5UBsQCtWP1o64MizXrVFY6aUOh5enHbnfSsGtnPAB
 zcxvO8T0iBk92rHtv581QrjYfKB2PJ3maVKDox0DFb354XkURPcclRST9JaaxxpUBgYw
 pNrA==
X-Gm-Message-State: AOAM532FjcT5CMlOv8wj8j3jAdM0BSqezWss/MWyOdXH5dCg9635TzXk
 g6gyeRkIAXPsBdbMprOR4TIQlA==
X-Google-Smtp-Source: ABdhPJwehmwFySoaS1hi2p+T+LiAO8upF6izWYrpOOMtkZkPW5L2hiCqpK0gC/Rhqd0TA7qN0BGQqw==
X-Received: by 2002:a17:902:e88a:b0:140:25a7:4a1b with SMTP id
 w10-20020a170902e88a00b0014025a74a1bmr22402882plg.67.1635259687236; 
 Tue, 26 Oct 2021 07:48:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id fy8sm186294pjb.47.2021.10.26.07.48.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Oct 2021 07:48:06 -0700 (PDT)
Date: Tue, 26 Oct 2021 14:48:02 +0000
From: Sean Christopherson <seanjc@google.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
Message-ID: <YXgVIvYhABnrP2Jo@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <04b1a72e-47b4-4bde-eb9e-ba36c156ff0d@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <04b1a72e-47b4-4bde-eb9e-ba36c156ff0d@de.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
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

On Tue, Oct 26, 2021, Christian Borntraeger wrote:
> Am 09.10.21 um 04:11 schrieb Sean Christopherson:
> > This is basically two series smushed into one.  The first "half" aims
> > to differentiate between "halt" and a more generic "block", where "halt"
> > aligns with x86's HLT instruction, the halt-polling mechanisms, and
> > associated stats, and "block" means any guest action that causes the vCPU
> > to block/wait.
> > 
> > The second "half" overhauls x86's APIC virtualization code (Posted
> > Interrupts on Intel VMX, AVIC on AMD SVM) to do their updates in response
> > to vCPU (un)blocking in the vcpu_load/put() paths, keying off of the
> > vCPU's rcuwait status to determine when a blocking vCPU is being put and
> > reloaded.  This idea comes from arm64's kvm_timer_vcpu_put(), which I
> > stumbled across when diving into the history of arm64's (un)blocking hooks.
> > 
> > The x86 APICv overhaul allows for killing off several sets of hooks in
> > common KVM and in x86 KVM (to the vendor code).  Moving everything to
> > vcpu_put/load() also realizes nice cleanups, especially for the Posted
> > Interrupt code, which required some impressive mental gymnastics to
> > understand how vCPU task migration interacted with vCPU blocking.
> > 
> > Non-x86 folks, sorry for the noise.  I'm hoping the common parts can get
> > applied without much fuss so that future versions can be x86-only.
> > 
> > v2:
> >   - Collect reviews. [Christian, David]
> >   - Add patch to move arm64 WFI functionality out of hooks. [Marc]
> >   - Add RISC-V to the fun.
> >   - Add all the APICv fun.
> 
> Have we actually followed up on the regression regarding halt_poll_ns=0 no longer disabling
> polling for running systems?

No, I have that conversation flagged but haven't gotten back to it.  I still like
the idea of special casing halt_poll_ns=0 to override the capability.  I can send
a proper patch for that unless there's a different/better idea?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8789C43462
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 65454610A5
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65454610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 009654B609;
	Thu,  1 Apr 2021 05:28:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vcb4oWg4VHhR; Thu,  1 Apr 2021 05:28:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C23344B62B;
	Thu,  1 Apr 2021 05:28:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A5964B4E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 16:16:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I+r0SsZVKUlU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 16:16:05 -0400 (EDT)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72B6D4B4E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 16:16:05 -0400 (EDT)
Received: by mail-pf1-f181.google.com with SMTP id c204so15375112pfc.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 13:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=jlWSSoi6sy6UHWMT+v1PaZmsAgCmFgO2q1+KR74XicI=;
 b=CQY8x+TvnMDSfSmiD2oXUHMuQLXZ38oXtxiRbVY/bMFC5iyRXRtUNJEI/nL8QGZJO3
 uCZeJr/LCn8UE+xniYVb/4u0+jxWUWA+q7hUvk92LCcFLkS/fJqFt+tNz2QcklwQQaWn
 HvmjLhB61wZx5a5mvaQtupa2/vEyFX9Vua2CFTe6XDyB1KEIrw7j4MAG1vVvIOYtt7P3
 pHQharrI6lixPIKmzhnGtbgX+luBHbesS+HGqteLdSBUx8hGONbonRnToFN5Hs5EJ77K
 vKUbLwvu9gSWWmSpGD7GsVEqiFtnjRQ/qBYqBI2cKy6097T2AypJtX31JiYLExgQSWnk
 FlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jlWSSoi6sy6UHWMT+v1PaZmsAgCmFgO2q1+KR74XicI=;
 b=Rr2qqHyygD/C0U48COhdTbXrEIztZ6YV5CUX4FWUNU2zd5c0/lkH4Qq16zbnWaQE2C
 tLzEKv1Lt/114vBicbCRSVKI286mJDG4rkoAxskomYDHEzd5e/qksh8/PZCyrIfu9HdB
 nnF1s6iKWQHcUZBwdfZm4VX++CpRjg2hwp+RGZWRAVtk20sxN7IcD83sRf3KV27mKRDV
 p/xvRckOzkhMyanp2jAujyA8I/CHI8hbKpKQbC87P6092xFtYTIWWzXxZ2AQdwAyofMJ
 U5cIaFQIelSxOjjPPI3U6pR24XN3sEjGdcrHz+7Tc32hcJcZPiJqecl+yMQaqV3oP7LK
 OrgQ==
X-Gm-Message-State: AOAM532o3qQODivL6BXXaLOHCc5sSzYFU7ffaCi9csEXjxzTaRbG0U2z
 1aFxBfmCCZkWy67oLv5cp8YSRA==
X-Google-Smtp-Source: ABdhPJyQTtvfP4m42vBD0iJXhxNzS92c8e0qkUYdFgjeJAzyVz49/jbMuCy/LNbWI3efb+yjNskWQQ==
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr4731324pgu.18.1617221764095; 
 Wed, 31 Mar 2021 13:16:04 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id 144sm3196471pfy.75.2021.03.31.13.16.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 Mar 2021 13:16:03 -0700 (PDT)
Date: Wed, 31 Mar 2021 20:15:59 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGTYf9sWVIJqqswq@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
X-Mailman-Approved-At: Thu, 01 Apr 2021 05:28:17 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 26/03/21 03:19, Sean Christopherson wrote:
> > +	/*
> > +	 * Reset the lock used to prevent memslot updates between MMU notifier
> > +	 * range_start and range_end.  At this point no more MMU notifiers will
> > +	 * run, but the lock could still be held if KVM's notifier was removed
> > +	 * between range_start and range_end.  No threads can be waiting on the
> > +	 * lock as the last reference on KVM has been dropped.  If the lock is
> > +	 * still held, freeing memslots will deadlock.
> > +	 */
> > +	init_rwsem(&kvm->mmu_notifier_slots_lock);
> 
> I was going to say that this is nasty, then I noticed that
> mmu_notifier_unregister uses SRCU to ensure completion of concurrent calls
> to the MMU notifier.  So I guess it's fine, but it's better to point it out:
> 
> 	/*
> 	 * At this point no more MMU notifiers will run and pending
> 	 * calls to range_start have completed, but the lock would
> 	 * still be held and never released if the MMU notifier was
> 	 * removed between range_start and range_end.  Since the last
> 	 * reference to the struct kvm has been dropped, no threads can
> 	 * be waiting on the lock, but we might still end up taking it
> 	 * when freeing memslots in kvm_arch_destroy_vm.  Reset the lock
> 	 * to avoid deadlocks.
> 	 */

An alternative would be to not take the lock in install_new_memslots() if
kvm->users_count == 0.  It'd be weirder to document, and the conditional locking
would still be quite ugly.  Not sure if that's better than blasting a lock
during destruction?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

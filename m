Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54496C43461
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0F4260FE8
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0F4260FE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 649F54B60A;
	Thu,  1 Apr 2021 05:28:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R-aJy+0N8cqS; Thu,  1 Apr 2021 05:28:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB924B631;
	Thu,  1 Apr 2021 05:28:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 581464B4C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:05:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9ZwoTNL0r0Tk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 17:05:54 -0400 (EDT)
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com
 [209.85.215.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 253A24B4AF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:05:54 -0400 (EDT)
Received: by mail-pg1-f179.google.com with SMTP id t140so146747pgb.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 14:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=OsMJWVQ5QwySc9J0D6/CmIltvLje627dYrulaN3pAYw=;
 b=Wc7aKMlkMupX5QKCwfzZVYqMCo1X7BRsT/Kkkx7EwXhoN5RNV7t4FFC66e9PTmv1hx
 B5fa6/ZZRBlZ7u8xuFDL9LYZr/z14+WE4xRb24HmRER5FPe8woSMl7enlu5vXfvWMl1b
 ME7U4jYEdyICvfRyN6+B26dJ3dEizwHNQsWpWevkiP4PnR+3Jmdg2xy/JJIDOEUUXaQ0
 ltEvaex2B8+pIp7NiAF68Y5qiyuu4234eP6u6hPNTVxaQ9AE8rdIKMAy3U8FEPBYR1GF
 8MWtaTrm5lKR+WYnx0BpHgfhq0fkF/UBhRko1T8H4itpPFwtvOhfmo0NCytN/FJUUsy1
 332w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OsMJWVQ5QwySc9J0D6/CmIltvLje627dYrulaN3pAYw=;
 b=OciDjBKNd872mInsbKpW4KWDfbb4tkvGTFu7vmICCoAh0MfLL7+j+eG4Lw+w0SwNGD
 fkE3yFCRKADNT3BceVdyYcXuxYGFXb9pXTKuQ5VOysrD8LNO8Ts33E2WO3t1HKwjsDCV
 ZTGDIJ7ulev/thGyHARwrMCvnG73NwxtDqAdRSP7GE+4wc1+08CyjU4U/8R76wjtXBV+
 S7Ix72LFBwDChyeDDsSwqzYKxbFhGh/rWgsF8zAoxoh/iYPLETlZ1305ZRyriCthmwfb
 WZrzHO/J8KL+eDj0K+sW9nzbm+Lwt6kIcmprY3PgrvLJgLaLEo3GpQ1SRxE4l4GkW8ZN
 PD5Q==
X-Gm-Message-State: AOAM5319kuoiJNhmRUw0qMLTQsZ18MShIrkWQYA544tG5tdJxobrvuK6
 omvVGbaYgKc1M9JFroSM42jj0A==
X-Google-Smtp-Source: ABdhPJyf0uPjw7GKqed+RHpnFRPgnZODnH1LNH3LjT1TYsTNjhWE3dnO3pT+GkRqgzOjMV1yU6flMQ==
X-Received: by 2002:a62:6497:0:b029:220:d96a:8a79 with SMTP id
 y145-20020a6264970000b0290220d96a8a79mr4625909pfb.23.1617224752934; 
 Wed, 31 Mar 2021 14:05:52 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id na18sm2894150pjb.30.2021.03.31.14.05.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 Mar 2021 14:05:52 -0700 (PDT)
Date: Wed, 31 Mar 2021 21:05:48 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGTkLMAzk88wOiZm@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
 <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
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
> On 31/03/21 21:47, Sean Christopherson wrote:
> > Rereading things, a small chunk of the rwsem nastiness can go away.  I don't see
> > any reason to use rw_semaphore instead of rwlock_t.
> 
> Wouldn't it be incorrect to lock a mutex (e.g. inside *another* MMU
> notifier's invalidate callback) while holding an rwlock_t?  That makes sense
> because anybody that's busy waiting in write_lock potentially cannot be
> preempted until the other task gets the mutex.  This is a potential
> deadlock.

Yes?  I don't think I follow your point though.  Nesting a spinlock or rwlock
inside a rwlock is ok, so long as the locks are always taken in the same order,
i.e. it's never mmu_lock -> mmu_notifier_slots_lock.

> I also thought of busy waiting on down_read_trylock if the MMU notifier
> cannot block, but that would also be invalid for the opposite reason (the
> down_write task might be asleep, waiting for other readers to release the
> task, and the down_read_trylock busy loop might not let that task run).
> 
> > And that's _already_ the worst case since notifications are currently
> > serialized by mmu_lock.
> 
> But right now notifications are not a single critical section, they're two,
> aren't they?

Ah, crud, yes.  Holding a spinlock across the entire start() ... end() would be
bad, especially when the notifier can block since that opens up the possibility
of the task sleeping/blocking/yielding while the spinlock is held.  Bummer.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

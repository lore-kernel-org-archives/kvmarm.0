From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Tue, 07 Jul 2015 09:10:36 +0200
Message-ID: <559B7B6C.3060900@linaro.org>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
 <559A7425.4050506@redhat.com> <559AA02A.6060703@linaro.org>
 <559AA552.3010400@redhat.com> <559AB62C.9000503@linaro.org>
 <559ABDC5.3060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CA2C57D56
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 02:59:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6OGILtXS1heP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 02:59:29 -0400 (EDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
 [209.85.212.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED1B657D43
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 02:59:28 -0400 (EDT)
Received: by wifm2 with SMTP id m2so50032918wif.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jul 2015 00:10:57 -0700 (PDT)
In-Reply-To: <559ABDC5.3060200@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/06/2015 07:41 PM, Paolo Bonzini wrote:
> 
> 
> On 06/07/2015 19:09, Eric Auger wrote:
>>>> The good thing is that this helps a bit forming a lock hierarchy across
>>>> the subsystems, for example irq bypass mutex outside vfio_platform_irq
>>>> spinlock, because you cannot have a spinlock inside the mutex.  I think
>>>> that all of your six callbacks are fine.
>> arghh, no that's wrong then. I have plenty of them in the KVM/arm vgic
>> part :-(
> 
> I checked and it's right...
> 
> /me rereads
> 
> AAAARGH.  You cannot have a mutex inside a spinlock.  What you're doing
> is fine.
Sweated up (+ heat wave in France). Was about to read again the
"concurrency and race conditions" chapter of the linux driver bible.
Might be worth anyway ;-)

Many thanks for the review

Eric
> 
> Paolo
> 

From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/13] arm64: KVM: VHE: Patch out use of HVC
Date: Fri, 10 Jul 2015 13:02:56 +0200
Message-ID: <559FA660.2050102@redhat.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
 <1436372356-30410-8-git-send-email-marc.zyngier@arm.com>
 <559D5A8A.4030901@redhat.com> <559D63EC.2090602@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7165E584E9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 06:51:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jr125v9sToL3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 06:51:22 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DE68584D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 06:51:22 -0400 (EDT)
Received: by wicmv11 with SMTP id mv11so11057594wic.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 04:02:59 -0700 (PDT)
In-Reply-To: <559D63EC.2090602@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 08/07/2015 19:54, Marc Zyngier wrote:
> Alternatively, I could move it to arch/arm64/include/asm (renamed to
> kvm_vhe_macros.h?), which would solve this issue. I just gave it a go,
> and that seems sensible enough.

Yes, that would do.  Alternatively:

* create kvm_hyp_macros.h and put more stuff in there from kvm_mmu.h

* just put it in kvm_host.h

Whatever looks better to you.

Paolo

> Thanks for the suggestion!

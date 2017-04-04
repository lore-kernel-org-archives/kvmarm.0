From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 6/9] KVM: arm/arm64: use a vcpu request on irq injection
Date: Tue, 4 Apr 2017 20:59:02 +0200
Message-ID: <1344d869-8de5-86e7-764c-3f19ad59b55e@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-7-drjones@redhat.com> <20170404174208.GB31208@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D72F40948
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 14:56:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jQm8kI3kdj1s for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 14:56:57 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EB5A40625
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 14:56:56 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id x75so7432537wma.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 11:59:09 -0700 (PDT)
In-Reply-To: <20170404174208.GB31208@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/04/2017 19:42, Christoffer Dall wrote:
> 
> this is not going to be called when we don't have the vgic, which means
> that if vcpu_interrupt_line() is used as you modify it above, the
> request will never get cleared.

Heh, I'll stop pretending I can give positive reviews of ARM patches and
keep bash^Wproviding constructive criticism. :)

In fact, I forgot to add that x86 recently moved to request-less
kvm_vcpu_kick when hardware interrupt injection is available.  This was
after I noticed that requests were just used as a workaround for
incorrect ordering of local_irq_disable, vcpu->mode=IN_GUEST_MODE, and
so on.

Paolo

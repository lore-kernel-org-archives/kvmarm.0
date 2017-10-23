From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] KVM: arm/arm64: Allow usercopy to vcpu->arch.ctxt and
 arm64 debug
Date: Mon, 23 Oct 2017 12:40:58 -0700
Message-ID: <CAGXu5jKoLP8jN4ZtRQnFpy6RWK1JJTa7eBuA2p9huBfh11bWvg@mail.gmail.com>
References: <20171020232525.7387-1-pbonzini@redhat.com>
 <20171021184545.2497-1-christoffer.dall@linaro.org>
 <CAGXu5jKJ2jPz2540ZLCwmcdVZxrgnhVPHs0uumiJm2o0ZgpVag@mail.gmail.com>
 <20171022074418.GA3805@cbox> <d2a7dcec-060b-6279-1c1d-a18b3eedb394@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2076C49D21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 15:39:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TWZyNn0P2aTE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Oct 2017 15:39:44 -0400 (EDT)
Received: from mail-io0-f193.google.com (mail-io0-f193.google.com
 [209.85.223.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5609F49D44
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 15:39:44 -0400 (EDT)
Received: by mail-io0-f193.google.com with SMTP id n137so21415530iod.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 12:40:59 -0700 (PDT)
In-Reply-To: <d2a7dcec-060b-6279-1c1d-a18b3eedb394@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, KVM <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 23, 2017 at 7:14 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 22/10/2017 09:44, Christoffer Dall wrote:
>> However, I think it's much clearer if I
>> rewrite these to use get_user() and put_user().  v2 incoming.
>
> I'd actually prefer if you all do a trivial conversion to
> kvm_init_usercopy to begin with.  In fact, we could just change the
> default from "0, 0" to "0, sizeof (kvm_arch_vcpu)" in kvm_init.  Any
> other change can be applied after the patches are merged to Linus's
> tree, especially with KVM Forum and the merge window both coming soon.
>
> I'll send a v2 myself later this week.

Okay, which patches would you like me to carry in the usercopy
whitelisting tree for the coming merge window?

-Kees

-- 
Kees Cook
Pixel Security

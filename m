From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Fri, 30 Sep 2016 16:54:28 +0200
Message-ID: <de375a6e-095c-a17a-0db7-876a5619df42@suse.de>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A9844113E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Sep 2016 10:45:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yc0QjJga06zx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Sep 2016 10:45:00 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E574410B5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Sep 2016 10:45:00 -0400 (EDT)
In-Reply-To: <20160927190806.22988-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 27.09.16 21:08, Christoffer Dall wrote:
> Hi Alex,
> 
> Marc and I have been looking at this during Linaro connect and have
> slightly reworked your patch into this small series.
> 
> It would be good if you could have a look at it and test it out.
> 
> I've tested it with your QEMU, and it works for UP, but secondary CPUs
> fail to come up, and it looks like the kernel never gets an IPI for
> those CPUs from userspace.  Any chance you're willing to take a look at
> that?

I still need to see whether I can come up with a prettier solution, but
for now this works:

diff --git a/target-i386/kvm.c b/target-i386/kvm.c
index f1ad805..8b9a084 100644
--- a/target-i386/kvm.c
+++ b/target-i386/kvm.c
@@ -2393,7 +2393,11 @@ static int kvm_get_mp_state(X86CPU *cpu)
         return ret;
     }
     env->mp_state = mp_state.mp_state;
+#ifdef CONFIG_ARM
+    if (kvm_enabled()) {
+#else
     if (kvm_irqchip_in_kernel()) {
+#endif
         cs->halted = (mp_state.mp_state == KVM_MP_STATE_HALTED);
     }
     return 0;


Alex

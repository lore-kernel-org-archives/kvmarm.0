From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] arm64: KVM: VHE: save and restore some PSTATE bits
Date: Wed, 6 Sep 2017 14:10:11 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F2015EA4DE@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E46440C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 10:12:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V-v+GPHEcQix for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Sep 2017 10:12:09 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00D2B49C2E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 10:12:08 -0400 (EDT)
Content-Language: zh-CN
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>
Cc: Huangshaoyu <huangshaoyu@huawei.com>, "Zhanghaibin (Euler)" <zhanghaibin7@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi, Vladimir

> >> Do you see effect of "PAN is unexpectedly enabled"?
> > In fact I did not encounter this case, but I think it can exist.
> > I think if host OS dynamically disable PAN, it wants the host kernel access the user space address space not through copy_to/from_user
> API.
> > Now if it is unexpectedly enabled, when host kernel still accesses the user space address,  it will happen MMU fault exception.
> 
> And this is expected! The only allowed channel for kernel <-> user is uaccess API.
> 
> I guess that you have test (and that great!) which violates that rule (for testing purpose, why not?) and now you are trying to fit kernel into
> it...


If you think that makes sense for it, we do not consider the paste.PAN in the world-switch.
For the pstate.UAO issue, do you agree my fixing or you have other suggestion?  Also to other reviewer. Thanks.

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 9341376..c3dd761 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -21,6 +21,8 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>

+#include <asm/exec.h>

 /* Yes, this does nothing, on purpose */
 static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }

@@ -121,8 +123,13 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
        write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
 }

+static void __hyp_text __sysreg_restore_state_vhe(struct kvm_cpu_context *ctxt)
+{
+    uao_thread_switch(current);
+}
+
 static hyp_alternate_select(__sysreg_call_restore_host_state,
-                           __sysreg_restore_state, __sysreg_do_nothing,
+                           __sysreg_restore_state, __sysreg_restore_state_vhe,
                            ARM64_HAS_VIRT_HOST_EXTN);

 void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)


> 
> Cheers
> Vladimir
> 
> >
> >
> >>
> >> Cheers
> >> Vladimir
> >>
> >>>
> >>>>
> >>>> Cheers
> >>>> Vladimir
> >>>>
> >>>> .
> >>>>
> >>>
> >>>
> >>
> >>
> >> .
> >>
> >
> >

From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Question on corruption of host/guest vfp switch  hyp function
Date: Thu, 18 Jun 2015 18:16:04 -0700
Message-ID: <55836D54.7070009@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A76A56063
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 21:05:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ouFhxosnKswO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 21:05:23 -0400 (EDT)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B9DB55FEF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 21:05:23 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQ600AHA3ITKLA0@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 18 Jun 2015 21:16:05 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


  I created a HYP function and call it from kvm_arch_vcpu_put().
It dies in restore_vfp_state right at the 'ldm' call.

Is the calling convention bad? Or anything else?
vcpu structure is corrupted right after that instruction.

I expanded the restore_vfp_state macro below, without
the ldm the guest boots (of course vfp restore is
not complete).

I'm running this on FastModels 9.x

Thanks,
  Mario


+ENTRY(__kvm_restore_host_vfp_state)
+       push {r3, r7}
+
+       mov     r1, #0
+       str     r1, [r0, #VCPU_VFP_SAVED]
+
+       VFPFMRX r1, FPEXC
+       push {r1}
+       orr     r6, r2, #FPEXC_EN
+       VFPFMXR FPEXC, r6
+
+       add     r7, r0, #VCPU_VFP_GUEST
+       store_vfp_state r7
+
+       add      r7, r0, #VCPU_VFP_HOST
+       ldr      r7, [r7]
+       restore_vfp_state r7
+
+       pop {r1}
+       VFPFMXR FPEXC, r1
+       pop {r3, r7}
+       bx      lr
+ENDPROC(__kvm_restore_host_vfp_state)


+       LDC     p11, cr0, [r7],#32*4
+       MRC     p10, 7, r6, cr7, cr0, 0
+       and     r6, r6, #(0xf << 0)
+       cmp     r6, #2
+       @ldceql  p11, cr0, [r7],#32*4
+       @addne   r7, r7, #32*4
+       @dsb
+       @sb
>>>>>>>>> Corruption here and dies <<<<<<<
+       ldm     r7, {r2-r5}

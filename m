Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF7AC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 17:28:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07E9C60240
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 17:28:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07E9C60240
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C0104B0BA;
	Mon, 27 Sep 2021 13:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NVp3vaMCA-tH; Mon, 27 Sep 2021 13:28:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2363F4B0A0;
	Mon, 27 Sep 2021 13:28:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 065C14A19F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 13:28:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sTTL8XscQp-E for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 13:28:20 -0400 (EDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41A5149F8F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 13:28:20 -0400 (EDT)
Received: by mail-pj1-f44.google.com with SMTP id
 nn5-20020a17090b38c500b0019af1c4b31fso600178pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 10:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ecZR8501JUA5HjJ4//gNp1dcXa6TfEaO5GlBtu6Su+A=;
 b=GOtOu1nR9l539q+qbEcVbGsMPn51n8QQ32PMYKIi6hIg46kqbYOo+hyGorxaHeXyiT
 V2tIDEC+I97Rg1zmhvPqeSzBeiBlCMUjmjZANJZzM9jX9QQBGLcV5QiWLXLdjVMX2MuS
 sScGZznLE19gExlLe/Ai7FS2B5zHwdMU7MKsUpu1yak92XJeVKQbMEKqZ/hzEY/0boo6
 sDlwFotvdcbYnahoS2c2Z8+mFOK1SJ2AB2kkvp6KT1bpJ8KctGOFh9LaiyRBGQUAyp5S
 j7e9humkRF8Tiv6iuLdNX3komtUTfGZHyDUAJJ18POrEa009r1yW8e9FcOZick20MEx6
 O+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ecZR8501JUA5HjJ4//gNp1dcXa6TfEaO5GlBtu6Su+A=;
 b=aX/TvbJbp5OjMwVhRvXMedpCekevXH18hnyGqQTZzm4w48ge0+j74935je5B735QDu
 3cXb/7d8R90j6VrCwVS35cYIvNUuNsAYalmbstto9YCQpKwOggkIJ5F4mvj8WIHc9Mv6
 6ScBi27ZGyC9Wn0FDS1EPsrFlNWxKKrC4m0tWAlEBszMXrEc6b1fgbvPwTyjWx6K1xTN
 UoOm9HhGxQs9+5QM9uqpFMc/Rea7JRjV4C3srLpvqr6SSTq/JH+u3oGPfbiaoznO05b9
 4ZGZsD6K7H0aIhQmNqoBJ05AS+gXpyfRqcovWGWWKqaTlaohw3YtRr2ywte5LQifR+sD
 T74A==
X-Gm-Message-State: AOAM533PqQv7YeN9Vbe/vpaXHyYa4MvqCL0hGmQPGyD6GHeiPGi05JLX
 mZP5HtVfiJS/c/9CUE5FnhTVsA==
X-Google-Smtp-Source: ABdhPJxsqRCUhYx/WDAlHwlUhNALt8ImrF7i3ClqjdGVCi9orteLX/2Ra1fBVLm7dJRGmXOdFcEtpg==
X-Received: by 2002:a17:902:9895:b0:13c:94f8:d74b with SMTP id
 s21-20020a170902989500b0013c94f8d74bmr678633plp.20.1632763698990; 
 Mon, 27 Sep 2021 10:28:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id c8sm17798035pfj.204.2021.09.27.10.28.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 10:28:18 -0700 (PDT)
Date: Mon, 27 Sep 2021 17:28:14 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 07/14] KVM: Don't block+unblock when halt-polling is
 successful
Message-ID: <YVH/LjCqk/9PfDHn@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-8-seanjc@google.com>
 <878rzlass2.wl-maz@kernel.org>
 <80d90ee6-0d43-3735-5c26-be8c3d72d493@redhat.com>
 <877df3btgb.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <877df3btgb.wl-maz@kernel.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Sun, Sep 26, 2021, Marc Zyngier wrote:
> On Sun, 26 Sep 2021 07:27:28 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > On 25/09/21 11:50, Marc Zyngier wrote:
> > >> there is no need for arm64 to put/load
> > >> the vGIC as KVM hasn't relinquished control of the vCPU in any way.
> > > 
> > > This doesn't mean that there is no requirement for any state
> > > change. The put/load on GICv4 is crucial for performance, and the VMCR
> > > resync is a correctness requirement.

Ah crud, I didn't blame that code beforehand, I simply assumed
kvm_arch_vcpu_blocking() was purely for the blocking/schedule() sequence.  The
comment in arm64's kvm_arch_vcpu_blocking() about kvm_arch_vcpu_runnable() makes
more sense now too.

> > I wouldn't even say it's crucial for performance: halt polling cannot
> > work and is a waste of time without (the current implementation of)
> > put/load.
> 
> Not quite. A non-V{LPI,SGI} could still be used as the a wake-up from
> WFI (which is the only reason we end-up on this path). Only LPIs (and
> SGIs on GICv4.1) can be directly injected, meaning that SPIs and PPIs
> still follow the standard SW injection model.
> 
> However, there is still the ICH_VMCR_EL2 requirement (to get the
> up-to-date priority mask and group enable bits) for SW-injected
> interrupt wake-up to work correctly, and I really don't want to save
> that one eagerly on each shallow exit.

IIUC, VMCR is resident in hardware while the guest is running, and KVM needs to
retrieve the VMCR when processing interrupts to determine if a interrupt is above
the priority threshold.  If that's the case, then IMO handling the VMCR via an
arch hook is unnecessarily fragile, e.g. any generic call that leads to
kvm_arch_vcpu_runnable() needs to know that arm64 lazily retrieves a guest
register.  A better approach for VMCR would be to retrieve the value from
hardware on-demand, e.g. via a hook in vgic_get_vmcr(), so that it's all but
impossible to have bugs where KVM is working with a stale VMCR, e.g.

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 48c6067fc5ec..0784de0c4080 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -828,6 +828,13 @@ void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
+       if (!vcpu->...->vmcr_available) {
+               preempt_disable();
+               kvm_vgic_vmcr_sync(vcpu);
+               preempt_enable();
+               vcpu->...->vmcr_available = true;
+       }
+
        if (kvm_vgic_global_state.type == VGIC_V2)
                vgic_v2_get_vmcr(vcpu, vmcr);
        else


Regarding vGIC v4, does KVM require it to be resident in hardware while the vCPU
is loaded?  If not, then we could do something like this, which would eliminate
the arch hooks entirely if the VMCR is handled as above.

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..efc862c4d802 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -365,31 +365,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
        return kvm_timer_is_pending(vcpu);
 }

-void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
-{
-       /*
-        * If we're about to block (most likely because we've just hit a
-        * WFI), we need to sync back the state of the GIC CPU interface
-        * so that we have the latest PMR and group enables. This ensures
-        * that kvm_arch_vcpu_runnable has up-to-date data to decide
-        * whether we have pending interrupts.
-        *
-        * For the same reason, we want to tell GICv4 that we need
-        * doorbells to be signalled, should an interrupt become pending.
-        */
-       preempt_disable();
-       kvm_vgic_vmcr_sync(vcpu);
-       vgic_v4_put(vcpu, true);
-       preempt_enable();
-}
-
-void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
-{
-       preempt_disable();
-       vgic_v4_load(vcpu);
-       preempt_enable();
-}
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
        struct kvm_s2_mmu *mmu;
@@ -697,7 +672,6 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
                        /* The distributor enable bits were changed */
                        preempt_disable();
                        vgic_v4_put(vcpu, false);
-                       vgic_v4_load(vcpu);
                        preempt_enable();
                }

@@ -813,6 +787,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
                 */
                preempt_disable();

+               /*
+                * Reload vGIC v4 if necessary, as it may be put on-demand so
+                * that KVM can detect directly injected interrupts, e.g. when
+                * determining if the vCPU is runnable due to a pending event.
+                */
+               vgic_v4_load(vcpu);
+
                kvm_pmu_flush_hwstate(vcpu);

                local_irq_disable();
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5dad4996cfb2..3ef360a20a22 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -969,6 +969,16 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)

        vgic_get_vmcr(vcpu, &vmcr);

+       /*
+        * Tell GICv4 that we need doorbells to be signalled, should an
+        * interrupt become pending.
+        */
+       if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vpe_resident) {
+               preempt_disable();
+               vgic_v4_put(vcpu, true);
+               preempt_enable();
+       }
+
        raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);

        list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

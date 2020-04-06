Return-Path: <SRS0=tdS3=5W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA30C2BA1E
	for <kvmarm@archiver.kernel.org>; Mon,  6 Apr 2020 15:14:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ECD0E2339E
	for <kvmarm@archiver.kernel.org>; Mon,  6 Apr 2020 15:14:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QR7kZD8x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECD0E2339E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 934854B183;
	Mon,  6 Apr 2020 11:14:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qGMsVHOew3Xc; Mon,  6 Apr 2020 11:14:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F9B24B18D;
	Mon,  6 Apr 2020 11:14:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B06F4B154
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Apr 2020 11:14:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fCH4a42yuXyP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Apr 2020 11:14:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DB984B12E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Apr 2020 11:14:39 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BD36322206;
 Mon,  6 Apr 2020 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586186077;
 bh=HLTjh6deKNcgUl2LBBzz4egKGS8y0szuWCPXV1N1ims=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=QR7kZD8xTGeRVGb70bx4v5zgrIKTwEE4rX8OONXSp38sWYVsxnY+TOT+O5HFft9r/
 fngLf+D07utVU9AdAQ3aJmxgS2bdQU+A2h13rDxPJ2+cbCsfQFML8c8bTMlBFXNyOx
 XiDwgmgxnugQK4310p2UlYtvjAsXi02e1W26Sokg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jLTSN-00187d-Tp; Mon, 06 Apr 2020 16:14:36 +0100
MIME-Version: 1.0
Date: Mon, 06 Apr 2020 16:14:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: Julien Grall <julien@xen.org>
Subject: Re: I{S,C}ACTIVER implemention question
In-Reply-To: <c90bdfa0-00cf-170b-4319-e270e8aaef7e@xen.org>
References: <c90bdfa0-00cf-170b-4319-e270e8aaef7e@xen.org>
Message-ID: <2a201532b992fca74b4f193f53fc71f9@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: julien@xen.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 sstabellini@kernel.org, George.Dunlap@eu.citrix.com, Bertrand.Marquis@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Stefano Stabellini <sstabellini@kernel.org>, George.Dunlap@eu.citrix.com,
 Bertrand Marquis <Bertrand.Marquis@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Julien,

Thanks for the heads up.

On 2020-04-06 14:16, Julien Grall wrote:
> Hi,
> 
> Xen community is currently reviewing a new implementation for reading
> I{S,C}ACTIVER registers (see [1]).
> 
> The implementation is based on vgic_mmio_read_active() in KVM, i.e the
> active state of the interrupts is based on the vGIC state stored in
> memory.
> 
> While reviewing the patch on xen-devel, I noticed a potential deadlock
> at least with Xen implementation. I know that Xen vGIC and KVM vGIC
> are quite different, so I looked at the implementation to see how this
> is dealt.
> 
> With my limited knowledge of KVM, I wasn't able to rule it out. I am
> curious to know if I missed anything.
> 
> vCPU A may read the active state of an interrupt routed to vCPU B.
> When vCPU A is reading the state, it will read the state stored in
> memory.
> 
> The only way the memory state can get synced with the HW state is when
> vCPU B exit guest context.
> 
> AFAICT, vCPU B will not exit when deactivating HW mapped interrupts
> and virtual edge interrupts. So vCPU B may run for an abritrary long
> time before been exiting and syncing the memory state with the HW
> state.

So while I agree that this is definitely not ideal, I don't think we 
end-up
with a deadlock (or rather a livelock) either. That's because we are 
guaranteed
to exit eventually if only because the kernel's own timer interrupt (or 
any
other host interrupt routed to the same physical CPU) will fire and get 
us
out of there. On its own, this is enough to allow the polling vcpu to 
make
forward progress.

Now, it is obvious that we should improve on the current situation. I 
just
hacked together a patch that provides the same guarantees as the one we
already have on the write side (kick all vcpus out of the guest, 
snapshot
the state, kick everyone back in). I boot-tested it, so it is obviously 
perfect
and won't eat your data at all! ;-)

Thanks,

         M.

+
+/*
+ * If we are fiddling with an IRQ's active state, we have to make sure 
the IRQ
+ * is not queued on some running VCPU's LRs, because then the change to 
the
+ * active state can be overwritten when the VCPU's state is synced 
coming back
+ * from the guest.
+ *
+ * For shared interrupts as well as GICv3 private interrupts, we have 
to
+ * stop all the VCPUs because interrupts can be migrated while we don't 
hold
+ * the IRQ locks and we don't want to be chasing moving targets.
+ *
+ * For GICv2 private interrupts we don't have to do anything because
+ * userspace accesses to the VGIC state already require all VCPUs to be
+ * stopped, and only the VCPU itself can modify its private interrupts
+ * active state, which guarantees that the VCPU is not running.
+ */
+static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 
intid)
+{
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	    intid > VGIC_NR_PRIVATE_IRQS)
+		kvm_arm_halt_guest(vcpu->kvm);
+}
+
+/* See vgic_access_active_prepare */
+static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
+{
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	    intid > VGIC_NR_PRIVATE_IRQS)
+		kvm_arm_resume_guest(vcpu->kvm);
+}
+
+static unsigned long __vgic_mmio_read_active(struct kvm_vcpu *vcpu,
+					     gpa_t addr, unsigned int len)
  {
  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
  	u32 value = 0;
@@ -359,6 +390,10 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu 
*vcpu,
  	for (i = 0; i < len * 8; i++) {
  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);

+		/*
+		 * Even for HW interrupts, don't evaluate the HW state as
+		 * all the guest is interested in is the virtual state.
+		 */
  		if (irq->active)
  			value |= (1U << i);

@@ -368,6 +403,29 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu 
*vcpu,
  	return value;
  }

+unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	u32 val;
+
+	mutex_lock(&vcpu->kvm->lock);
+	vgic_access_active_prepare(vcpu, intid);
+
+	val = __vgic_mmio_read_active(vcpu, addr, len);
+
+	vgic_access_active_finish(vcpu, intid);
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return val;
+}
+
+unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len)
+{
+	return __vgic_mmio_read_active(vcpu, addr, len);
+}
+
  /* Must be called with irq->irq_lock held */
  static void vgic_hw_irq_change_active(struct kvm_vcpu *vcpu, struct 
vgic_irq *irq,
  				      bool active, bool is_uaccess)
@@ -426,36 +484,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu 
*vcpu, struct vgic_irq *irq,
  		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
  }

-/*
- * If we are fiddling with an IRQ's active state, we have to make sure 
the IRQ
- * is not queued on some running VCPU's LRs, because then the change to 
the
- * active state can be overwritten when the VCPU's state is synced 
coming back
- * from the guest.
- *
- * For shared interrupts, we have to stop all the VCPUs because 
interrupts can
- * be migrated while we don't hold the IRQ locks and we don't want to 
be
- * chasing moving targets.
- *
- * For private interrupts we don't have to do anything because 
userspace
- * accesses to the VGIC state already require all VCPUs to be stopped, 
and
- * only the VCPU itself can modify its private interrupts active state, 
which
- * guarantees that the VCPU is not running.
- */
-static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 
intid)
-{
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid > VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_halt_guest(vcpu->kvm);
-}
-
-/* See vgic_change_active_prepare */
-static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
-{
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid > VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_resume_guest(vcpu->kvm);
-}
-
  static void __vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
  				      gpa_t addr, unsigned int len,
  				      unsigned long val)
@@ -477,11 +505,11 @@ void vgic_mmio_write_cactive(struct kvm_vcpu 
*vcpu,
  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);

  	mutex_lock(&vcpu->kvm->lock);
-	vgic_change_active_prepare(vcpu, intid);
+	vgic_access_active_prepare(vcpu, intid);

  	__vgic_mmio_write_cactive(vcpu, addr, len, val);

-	vgic_change_active_finish(vcpu, intid);
+	vgic_access_active_finish(vcpu, intid);
  	mutex_unlock(&vcpu->kvm->lock);
  }

@@ -514,11 +542,11 @@ void vgic_mmio_write_sactive(struct kvm_vcpu 
*vcpu,
  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);

  	mutex_lock(&vcpu->kvm->lock);
-	vgic_change_active_prepare(vcpu, intid);
+	vgic_access_active_prepare(vcpu, intid);

  	__vgic_mmio_write_sactive(vcpu, addr, len, val);

-	vgic_change_active_finish(vcpu, intid);
+	vgic_access_active_finish(vcpu, intid);
  	mutex_unlock(&vcpu->kvm->lock);
  }


-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

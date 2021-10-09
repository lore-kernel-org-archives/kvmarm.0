Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B82FC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5EA860FD7
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B5EA860FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67B824B199;
	Fri,  8 Oct 2021 22:14:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UZWXjJ1GHUDX; Fri,  8 Oct 2021 22:14:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7B14B1A2;
	Fri,  8 Oct 2021 22:14:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 647714B136
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c5Eos-U1rqSB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:14:13 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 249894B1B6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:13 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 p8-20020a056902114800b005bad2571fbeso3625781ybu.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=EO1DdjrhtpmWzjh1EvgBT+lYKJFtXbnNZvFnyTdrLr4=;
 b=SgQ6bc6sO/D2BDTT6qtx0WAi/ReMNLqD/ixklFc6XJsme6RvEAyibaoCcZ+6xQ5OkI
 ktC+f/9gaqy4GxqOHggOKkREje58nPcOr+Pu+vPxOlkYQMNw78hFOqCmgpg1tqeYBceP
 M02XL4PQM1TiYW71SKXsn2Ur2YlXd0iyCAEhOd4fAvr/JazoIpUsKNmjyf0Ni6JCCcKO
 7pxB0Pn+7ZUH5KunCEUOb6F/O+SJ9Gms308Iz4L/bVBrKppOYhyW2loCqRXdzIS5KBo7
 R+hLo/RYtlg4VS+ZdP6EH23BDWdpgqinGPjzLjDVYfoK7og0eyFX+gDYPLeJnrZbmP2N
 MJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=EO1DdjrhtpmWzjh1EvgBT+lYKJFtXbnNZvFnyTdrLr4=;
 b=uRr4d7PlzN0v5Shc5+R1nRFRv+fNrsKYLqsW7OdX8Du7HwBiKucLWDgpUjHiZB3D1F
 6KmyMjCo3fFAnxWF2r7CHSAXeqiFUh2x1yBHCZUS4T464s0br4ft+uIFsK2npsHWzHez
 umbAzdoUYnOsCvC2jHrQ1QQE+VFeQh+vyNIyAtu+mxJOXpf7ohli8AgIa9SyO5Ug/eaa
 EUylou0/k3LtrUz3mWXYg3bBTTqQiMtLY0ggYxB0Qvp4SuHXnw2OeVskzBzBHDk7Nfzt
 /xUtcDmFPW+FRYbui/Up5kC6nozeXEAP2sH1nXt9NDHEiTyRVu0XpvLLNH2pAZGKGbFL
 Yk6w==
X-Gm-Message-State: AOAM532+tCq6LscRPWFTc0LM8e76Z18RA+V5atq+rVI6y5fM8a+p2D97
 hetjWWF7N/uGGSwbhvFB6sXM61eKmZ4=
X-Google-Smtp-Source: ABdhPJxzzIeOZb6NcqAHHKw15hpgOp6kx7Tgw+3WfUCiAT/0ER9Qq3B+94h2kbS9kEsVCOMb8KmVqa9KyAg=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:22d7:: with SMTP id
 i206mr7801852ybi.355.1633745652715; 
 Fri, 08 Oct 2021 19:14:12 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:30 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-38-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 37/43] KVM: SVM: Unconditionally mark AVIC as running on
 vCPU load (with APICv)
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Always mark the AVIC as "running" on vCPU load when the AVIC is enabled and
drop the vcpu_blocking/unblocking hooks that toggle "running".  There is no
harm in keeping the flag set for a wee bit longer when a vCPU is blocking,
i.e. between the start of blocking and being scheduled out.  At worst, an
agent in the host will unnecessarily signal the doorbell, but that's
already the status quo in KVM as the "running" flag is set the entire time
a vCPU is loaded, not just when it's actively running the guest.

In addition to simplifying the code, keeping the "running" flag set longer
can reduce the number of VM-Exits due to incomplete IPI delivery.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 53 +++++++++++++----------------------------
 arch/x86/kvm/svm/svm.c  |  8 -------
 arch/x86/kvm/svm/svm.h  |  3 ---
 3 files changed, 17 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b43b05610ade..213f5223f63e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -967,6 +967,15 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/* TODO: Document why the unblocking path checks for updates. */
+	if (kvm_vcpu_is_blocking(vcpu) &&
+	    kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu)) {
+		kvm_vcpu_update_apicv(vcpu);
+
+		if (!kvm_vcpu_apicv_active(vcpu))
+			return;
+	}
+
 	/*
 	 * Since the host physical APIC id is 8 bits,
 	 * we can support host APIC ID upto 255.
@@ -974,19 +983,21 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
+	/*
+	 * Unconditionally mark the AVIC as "running", even if the vCPU is in
+	 * kvm_vcpu_block().  kvm_vcpu_check_block() will detect pending IRQs
+	 * and bail out of the block loop, and if not, avic_vcpu_put() will
+	 * set the AVIC back to "not running" when the vCPU is scheduled out.
+	 */
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	if (svm->avic_is_running)
-		entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id,
-					svm->avic_is_running);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 }
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
@@ -1001,33 +1012,3 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
-
-/*
- * This function is called during VCPU halt/unhalt.
- */
-static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	svm->avic_is_running = is_run;
-
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
-	if (is_run)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
-}
-
-void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
-{
-	avic_set_running(vcpu, false);
-}
-
-void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
-{
-	if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
-		kvm_vcpu_update_apicv(vcpu);
-	avic_set_running(vcpu, true);
-}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 89077160d463..a1ca5707f2c8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1433,12 +1433,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (err)
 		goto error_free_vmsa_page;
 
-	/* We initialize this flag to true to make sure that the is_running
-	 * bit would be set the first time the vcpu is loaded.
-	 */
-	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
-		svm->avic_is_running = true;
-
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
@@ -4597,8 +4591,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.prepare_guest_switch = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
-	.vcpu_blocking = svm_vcpu_blocking,
-	.vcpu_unblocking = svm_vcpu_unblocking,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7f5b01bbee29..652d71acfb6c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -169,7 +169,6 @@ struct vcpu_svm {
 	u32 dfr_reg;
 	struct page *avic_backing_page;
 	u64 *avic_physical_id_cache;
-	bool avic_is_running;
 
 	/*
 	 * Per-vcpu list of struct amd_svm_iommu_ir:
@@ -529,8 +528,6 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
-void svm_vcpu_blocking(struct kvm_vcpu *vcpu);
-void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

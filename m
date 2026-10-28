Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214191;
	b=NV8kPReDlUHSMidCrh7gN/5nK8zDmzgwEb+hpxJYIIZLNoUPz3OT8eaY+Sf0hXqONVy6
	 r054jOQrk/OY1toR6vU+HIrdx+wkwNDothk9v4zxiQ0cw6NytweAeGrwvl5OPhS6AmI4n
	 L1a64mtmA9szNNGJc16M4qJfq/0axv2bEF7ko5jASNabpu6L2ntnTjzlLbObmGt3r1ee/
	 7XAgpQc4jbS1CdeZZslQA5DvvIOolZb+j601RBrMrcp093zbU/VNJKcAzGEI7OfR5t4PK
	 P0a06Yvdsy7fhKiF5CqjXpAKOHZySWikj4dZoDQoQvD+owaaANZJfFLWyXjVsCyLSYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214191;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Reply-To:Date:
	 In-Reply-To:Mime-Version:References:X-Mailer:Message-ID:Subject:From:
	 To:Cc:Content-Type;
	bh=jCCEmu80ia44kI2vyDb6i59VDXRIs93I0WproZ1Xw/A=;
	b=BkuaselhLxnlpXoCsK/vVivtpvJJxqo1eFmyQWOmkZPbpq8JUZ6snS3+sI0Cn1cIbJmq
	 D/SiOaKHCaBe40tWNGtWd7WM1xTTZVOkepKcEEwm6n1P4p0sT1knSe75tEOdGknpj7kF2
	 nj7nZcTWsqH3AM28gLG4j+Zwd8NdlsB/Dni7c5UKkObJ2P6LBnQ2+Z7GAjwJYWzkcc0a7
	 xdzLIwrOmoiqK5jLhZwdVcq41bL6Tj5oKl2M9W4gVbRaEcgAnuo1BrfrqCQ/JU+c2pwbi
	 R7XfaaMEIMDfEUz6QKutlJu/cJrrmrEV8zWOdTbUvI8YnQDEfQZDMsu6312NLM2Qk7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Dj/A115K";
	arc=none smtp.remote-ip=209.85.215.199
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF8960A6F41
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 19:03:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DF8960A6F41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Dj/A115K
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd68bf391e1so906844a12.3
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 12:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793214191; x=1793818991; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jCCEmu80ia44kI2vyDb6i59VDXRIs93I0WproZ1Xw/A=;
        b=Dj/A115Kfai53vfOtjXMo6icsx1jq0jH7AgPjA/mad90De9FOpi/xRwdjk7kfGws6Q
         fFJ2W5xNsEN386A41Gv6cDqEdgfGNmXE/OR39QXmyiYYG+rX+el39TID2+b5b0X0dfYg
         MyztI5vhpNm7ulitJgYgG+GoV/imFi6KKt2QG9MuORKLM8kmN0PDSX/uE6AEMjlBlnRe
         Jb+22r/1l9Euih7t03hjMH3CEEttdmC/07DNNGnBiQ+Xpn4mXNGIg3D18o858dVTx7GN
         zeXLRLWjPmR4auiaSBQ0T1HiGjv/88LiJ8E0wrNApWNBTb1RQRT3Ox0qbFUvIo8ooZJl
         VNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214191; x=1793818991;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jCCEmu80ia44kI2vyDb6i59VDXRIs93I0WproZ1Xw/A=;
        b=dk0qhEx5dyHLtqOtAAIc98f9Tbml0wG8Zjf5nnxQw8wuwiuTeq3JnpyKJ2jQ16TcZA
         c9C5ouB1KQIwkR4njorPDeVef6y2WmpNeJZ5a2ewOJXSQycsVRINkCVpd9iHSwMqZ/R1
         2g8W8kmwwqN3lHfH08Bd8IG3W5+/O0Zr2nOnEWYSMz53gJyi56wp1R59LAjUjIxezzB/
         BKHJTl22kE27EnxMBEgW+lodg5IFBNjB/KG8jYH5f/AsJRUS8b1iBqYwzcYmqDEym7Tw
         HndfNWTLKywUYxax2qv2kELXo6rw79b/h9y5PGvr65dpDrKmz5/DL6jAQ5gSy5/k/guF
         lsgw==
X-Forwarded-Encrypted: i=1; AKwUvBztdanXKZsv9CuN61DGRI/D7g6HM94x+umLwlFOK/yJVT+f7tu1v4nxkxsYrFhRFWGCa/Lk9p8=@lists.linux.dev
X-Gm-Message-State: AFq9FYINOqjYi1uuHRzZ3hflOywS83ySzyV2obFrp9QtTRK3f3pFnOcB
	sKzL6VaY/R9Tw152ue89DD1ghE7Q+n8jaezn0qKZkr/7moNiBqKtj2StfkBlIEwPj51rtPL1VJa
	aV5erYw==
X-Received: from pghv3.prod.google.com ([2002:a63:f203:0:b0:cd6:b233:e4aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b06:b0:3ab:b64:5893
 with SMTP id 98e67ed59e1d1-3ae581bc654mr2418362a91.53.1793214190430; Wed, 28
 Oct 2026 12:03:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Oct 2026 12:02:59 -0700
In-Reply-To: <20261028190259.1819571-1-seanjc@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261028190259.1819571-1-seanjc@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028190259.1819571-8-seanjc@google.com>
Subject: [PATCH 7/7] KVM: Drop kvm_vcpu_should_kick() and use kvm_request_needs_ipi()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Stefan Teodorescu <fane@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop kvm_vcpu_should_kick() in favor of kvm_request_needs_ipi() to fix a
bug where KVM will fail to wait for a vCPU to exit guest mode if the vCPU
was already marked as EXITING_GUEST_MODE by a concurrent non-waiting kick.
Because kvm_vcpu_should_kick() (was kvm_arch_vcpu_should_kick()) only waits
(and sends an IPI to do so) if the target vCPU is fully IN_GUEST_MODE, the
sending task will proceed even though it hasn't actually guaranteed the
vCPU as fully exited the guest.

The flaw is most problematic for SNP VMSA invalidation with in-place gmem
conversion, as KVM invokes kvm_gmem_invalidate_start() => rmp_make_shared()
(via kvm_gmem_make_shared() in quick succession when in-place conversion is
enabled.  I.e. if the target has been marked as EXITING_GUEST_MODE but has
not yet received the other kicker's IPI, then updating the RMP will fail as
the VMSA is still in-use and subsequent accesses to the page will encounter
unexpected RMP #PFs.

Note, the bug exists and affects VMSA invalidation even without in-place
conversion, but is significantly more difficult to hit as PUNCH_HOLE and
.release() have to wade through a lot more code and several locks to get
from invalidation to kvm_gmem_free_folio().

Note #2, currently only x86 uses kvm_make_request_and_kick(), i.e. this is
a glorified nop for all other architectures as the KVM_REQUEST_WAIT path is
never taken.

Fixes: 309d28576f0a ("KVM: SVM: Fix SNP AP destroy race with VMRUN")
Fixes: d1a3c2162334 ("KVM: SEV: Forcefully invalidate SNP VMSA if its backing gmem page is zapped")
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f1792256576b..f99a714698e3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -191,7 +191,6 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(vcpu_put);
 
-/* TODO: merge with kvm_vcpu_should_kick */
 static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
 {
 	int mode = kvm_vcpu_exiting_guest_mode(vcpu);
@@ -209,11 +208,6 @@ static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
 	return mode == IN_GUEST_MODE;
 }
 
-static int kvm_vcpu_should_kick(struct kvm_vcpu *vcpu)
-{
-	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
-}
-
 static void ack_kick(void *_completed)
 {
 }
@@ -3935,7 +3929,7 @@ void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, int req, bool force)
 
 	/*
 	 * Note, the vCPU could get migrated to a different pCPU at any point
-	 * after kvm_vcpu_should_kick(), which could result in sending an
+	 * after kvm_request_needs_ipi(), which could result in sending an
 	 * IPI to the previous pCPU.  But, that's ok because the purpose of the
 	 * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
 	 * vCPU also requires it to leave IN_GUEST_MODE
@@ -3944,7 +3938,7 @@ void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, int req, bool force)
 	 * check also modifies vcpu->mode and KVM PPC needs to avoid that side
 	 * effect for unknown historical reasons.
 	 */
-	if (force || kvm_vcpu_should_kick(vcpu)) {
+	if (force || kvm_request_needs_ipi(vcpu, req)) {
 		cpu = READ_ONCE(vcpu->cpu);
 		if (cpu != me && (unsigned int)cpu < nr_cpu_ids && cpu_online(cpu)) {
 			/*
-- 
2.56.0.313.g2479322e68-goog


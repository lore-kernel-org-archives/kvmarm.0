Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114358;
	b=1KFrc892G77VwXfo7oh9GHKsfxT+y71Z9FLU+foN7rMdPrUxMNPkeQfYbTd8l0eRt8TW
	 SKHO0gN/qGrCuy9ixeW+fDVXtNEDTn2jlV5wK5kNDcQqMsK6Rstb9zlSFpKD6zXQMtfwz
	 b/Y8VTHGCadhngFpWDl/xyqrpTGS74lJxwH1oxPknYFKeu87viBDg8m7qVNTgBkJi7Lee
	 ikspU7QeNApnC+EEM0RqYfPDEr1OAnuj0VhyLnru7fFNLIVrNF1wbTmBygWB1xJEedkVx
	 XcXJkhXuLdtFYkrJfTTJ6oOtE6b+RoP8JCWQMbV+sMDfo8P0vIskrEMO34KiHtVWlGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114358;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ZrQiJeW1/ZGAZNj9EqpY+oYKcoF1CcN9MBzVSNJZPxc=;
	b=sFEMzMBs+IbpUcoAf13nKSqVkMVkqXDbsrZnOTY9n8XUHRNdKUNO5o17BXffKIgNoe8H
	 qsrFRHO9De8X3+Q6jDUPgJgUnbbCJjr1pa4PAb31WM5Z0qC0I+nVQYWyhSvN8BmeFa9+4
	 vx1QNq1m8LkVcAhUTOyOukAKfhea+cnQj+t+Lg7suMxDVRW4fZKZiJ6wsUlI4cMv6I79y
	 Pis578if2Y2IxDWOAeQUTX7auGBy481JzlW1ZIA+zahgWkA+YchK8sAlYEldizh/Re1wZ
	 FtTJHCiomrv23DLCZ7JW6YS9CxuyaYa8/wVzNE8Rnnd61o1pwgimPGC5ATEL2Rf1NQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="K3F2lje/";
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F56606E8CE
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2F56606E8CE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=K3F2lje/
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4cbf700ddccso164858b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114357; x=1795719157; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZrQiJeW1/ZGAZNj9EqpY+oYKcoF1CcN9MBzVSNJZPxc=;
        b=K3F2lje/POtqLKPoWJQoj5KhGOKB+rdv7QaHN241wE4QOd8+bE8HaBZ69/LQiuVEfa
         NtbJnpQFYmT6FclB/vo+TM0RjqsrsLPlo5EjFZsco4dhJrXqItVYcn4pyGOdQO2jBPGh
         pST2jVl+xBj/vaBFQz53itH3aizF9YSVzjmKYwxHp1at1d507VOMyoBQq8RzKztBfUpT
         AlFnK8SrPaS/o/0dlAknv0XAth06menaAIy/ebmKmQJRrlBolVJvFraFaEYEEwda1XQS
         0zqBRfA1j/RFzvDvuB3uI9ZZ4gOpac+C6U5f1DuigLX1dBmGQ24cGRTGZ8jKESKrXKD5
         /cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114357; x=1795719157;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZrQiJeW1/ZGAZNj9EqpY+oYKcoF1CcN9MBzVSNJZPxc=;
        b=Ee+gWCu0uRLM/t4vhdQrH8ogyMIE84ZE4zFLA/qS4YxPpM6sbIoqzjUK5vSRLHrAZz
         9WYfXlrPeJlk+bINuqqQNSdnBu2IA9Sfj7Jb+uweaCVPKT31wkOfzBfZ5x0gjvE1jMPO
         vS4dMwGv5rBJy49mAQ5N38jr1lgXVu7mKYmUF6oRW6LU1D2GAnKadIUeS3nmH6wPwkqx
         dU6Ne2CWeL6hmp7AT6qAYKD9pXBRD1VmMmyt3vRxhLXyJ27WYS6PslveJwox+rdhr+Mz
         LanuSqdT+jZnedchOy4N3POSPXE+s0aPfmMDcTqFcM6HM5wXFrNmloTbAK6v+kVua19V
         Bwdg==
X-Forwarded-Encrypted: i=1; AL+hErEDx3bOMEZa+NjzQI1xQMsX9mUtNw0WolDNH/lJTcw+KfSL88W30j9g3K+lWnPW+QX/IubBKbc=@lists.linux.dev
X-Gm-Message-State: APuU4Z8ubL1ryOp1CXhvJhW9OhTsGxaETRkoiPvsd5K3TEWIaD54zcnN
	DWwpJDPDuYsbPyOW0vht01tVS688e4FspgY79ilP6JihjuyDqXHWmEDqxTbf9P50F+uOnSLYS+h
	V0wUh24EJR7eOsDediqYXZhfnxg==
X-Received: from iof12.prod.google.com ([2002:a5d:9c4c:0:b0:9c4:b80b:7605])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1384:b0:4ce:a4fc:a848 with SMTP id 5614622812f47-57a06a0da3amr989109b6e.6.1795114356571;
 Thu, 19 Nov 2026 10:52:36 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:03 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-22-coltonlewis@google.com>
Subject: [PATCH v10 21/33] KVM: arm64: Allow kvm_vcpu_pmu_resync_el0() to
 resync filters in process context
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Previously, kvm_vcpu_pmu_resync_el0() only scheduled
KVM_REQ_RESYNC_PMU_EL0 when called from interrupt context (such as an
IPI reprogramming host perf events). When perf_pmu_resched_update() is
invoked synchronously from process context during vCPU load/put to
reschedule host events around guest-reserved counters,
armv8pmu_enable_event() calls kvm_set_pmu_events() and
kvm_vcpu_pmu_resync_el0() in process context.

Update kvm_vcpu_pmu_resync_el0() to call kvm_vcpu_pmu_restore_guest()
directly when not in interrupt context so that newly rescheduled host
perf events have their EL0 exclusion filters applied immediately.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index dbbe219ac874f..d3fd438a57b09 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -213,14 +213,17 @@ void kvm_vcpu_pmu_resync_el0(void)
 {
 	struct kvm_vcpu *vcpu;
 
-	if (!has_vhe() || !in_interrupt())
+	if (!has_vhe())
 		return;
 
 	vcpu = kvm_get_running_vcpu();
 	if (!vcpu)
 		return;
 
-	kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
+	if (in_interrupt())
+		kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
+	else
+		kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 void kvm_host_pmu_init(struct arm_pmu *pmu)
-- 
2.56.1.708.g77570a6a1d-goog


Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A14C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24B5F61139
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 24B5F61139
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAFCD4B152;
	Thu, 16 Sep 2021 14:15:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JJD4ACtQDjw7; Thu, 16 Sep 2021 14:15:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B60EF4B13B;
	Thu, 16 Sep 2021 14:15:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4D9A4B10D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SMiq3IMTSCWb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:45 -0400 (EDT)
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com
 [209.85.161.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82F5C4B199
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:45 -0400 (EDT)
Received: by mail-oo1-f74.google.com with SMTP id
 k1-20020a4a8501000000b0029ac7b9dc82so20602533ooh.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/xw1HPEE3yg6hDZiSRSN4mqpJW+LQ6wXxySnmKRFyJ8=;
 b=aeIy+Fj9Ddx5QaJjlHoSsG2pqbF8w2bOPA1NUF6/sz/meu/pc2y7XH5Frw9KOhU9jX
 /kH/TSaeEzKpU3E9F4mu2P4UwMb8CA8hVkOuGgpkMxluodvQx0JB40MGxrC/28jBzSpS
 tOcue5Y0S/zW65/M/S+fci0vMm5hJ5aXdp3cKtcIkEKR27UTz5eqwFNzBMVkFzM01TOD
 rlmCukD6+Sq5NdvlmiFK9SoTsk9V7CF9hxsEpXwf31yhlcLh4USsTGsziVGOqmjspN8o
 0Ky6X+cH1ZOM4CgbuHJIjBmRAlEsdJzbNTWMO+pHL8eK5LJOZ0KcX4fxKffaaQujOn7V
 WyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/xw1HPEE3yg6hDZiSRSN4mqpJW+LQ6wXxySnmKRFyJ8=;
 b=63etVC+TLmP15HXRrn6t0UZ3+llBn5xMIomm/WEfcVFZWzK7+jS9dKdnVW7mEidbTR
 Lgok9qYH8madoEc8URfD/HcPFfvZomnH5Ppq3CGKjHNDgyacj+CvBjVO/OdhuIZhFe69
 Y/Pic8xKB+2a7nYSjDwlzl9yUmXUZYzAVjugUv/VHpFxrV11pLG4+PQ4HZFNx268u/SD
 z2qh5dHUWsP6HYjIYR7s4K/kDKPtuyEWporve7KSxeK1hgg8XwUuxsjVdLWRD7EmTMrg
 350sFDPAYhslr8uJrKxuOuYzbdGq+EBAofW3Nr6jK8orB0gd3LQwFSbp8YYwJa5DpS1h
 gzsA==
X-Gm-Message-State: AOAM531v6/JwnNRi54LuQIVBsB/YmfDYfWOP2ekogMNqUaUw5aejVZSa
 y3b11FStDzNsHrl2on1Z+/CcnLHfgLU=
X-Google-Smtp-Source: ABdhPJwhSdiutQtzePdJzjaNwKrgENSZ7USY45/SDq1qTsydz5Pm4qLqm2IgqkpSSQFsIfTfuENKHUrRnnM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a9d:7f07:: with SMTP id
 j7mr5952745otq.84.1631816144992; 
 Thu, 16 Sep 2021 11:15:44 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:34 +0000
In-Reply-To: <20210916181538.968978-1-oupton@google.com>
Message-Id: <20210916181538.968978-4-oupton@google.com>
Mime-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 3/7] KVM: x86: Fix potential race in KVM_GET_CLOCK
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
outside of the pvclock sync lock. This is problematic, as the clock
value written to the user may or may not actually correspond to a stable
TSC.

Fix the race by populating the entire kvm_clock_data structure behind
the pvclock_gtod_sync_lock.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c910cf31958f..523c4e5c109f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2793,19 +2793,20 @@ static void kvm_update_masterclock(struct kvm *kvm)
 	kvm_end_pvclock_update(kvm);
 }
 
-u64 get_kvmclock_ns(struct kvm *kvm)
+static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 {
 	struct kvm_arch *ka = &kvm->arch;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned long flags;
-	u64 ret;
 
 	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	if (!ka->use_master_clock) {
 		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-		return get_kvmclock_base_ns() + ka->kvmclock_offset;
+		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
+		return;
 	}
 
+	data->flags |= KVM_CLOCK_TSC_STABLE;
 	hv_clock.tsc_timestamp = ka->master_cycle_now;
 	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
 	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
@@ -2817,13 +2818,26 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
 				   &hv_clock.tsc_shift,
 				   &hv_clock.tsc_to_system_mul);
-		ret = __pvclock_read_cycles(&hv_clock, rdtsc());
-	} else
-		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
+		data->clock = __pvclock_read_cycles(&hv_clock, rdtsc());
+	} else {
+		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
+	}
 
 	put_cpu();
+}
 
-	return ret;
+u64 get_kvmclock_ns(struct kvm *kvm)
+{
+	struct kvm_clock_data data;
+
+	/*
+	 * Zero flags as it's accessed RMW, leave everything else uninitialized
+	 * as clock is always written and no other fields are consumed.
+	 */
+	data.flags = 0;
+
+	get_kvmclock(kvm, &data);
+	return data.clock;
 }
 
 static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
@@ -5832,13 +5846,9 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_clock_data data;
-	u64 now_ns;
-
-	now_ns = get_kvmclock_ns(kvm);
-	user_ns.clock = now_ns;
-	user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
-	memset(&user_ns.pad, 0, sizeof(user_ns.pad));
 
+	memset(&data, 0, sizeof(data));
+	get_kvmclock(kvm, &data);
 	if (copy_to_user(argp, &data, sizeof(data)))
 		return -EFAULT;
 
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

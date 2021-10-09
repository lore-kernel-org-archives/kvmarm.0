Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA470C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FA8661027
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8FA8661027
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C2C4B08E;
	Fri,  8 Oct 2021 22:13:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id siA8ZQsfcqjx; Fri,  8 Oct 2021 22:13:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C05E4B136;
	Fri,  8 Oct 2021 22:13:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18CD04B121
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kjoBlzm9UM35 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:20 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C2AB4B13E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:19 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 i21-20020a253b15000000b005b9c0fbba45so15081945yba.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=v9oEyavsvbZNuuh7Q+PKViZhWtX7WRERjDZsEYQR4V4=;
 b=SCbmKo34lA8oU3dDYTZHOvAjjDoLBR2GtJ37FhHZtdcyaf6gZ6bVC5uP3+oE2UTrpm
 SJ1/Of1dkXNWhoAvrrrc0TBpKSCl7QbMbUP05V4KS7XrfFN5yznrDd3S3rpM+VJAfNxW
 sgJsB3R3InfKb1YxSdio9cjUyN5vLtdRPSuiKEuzXF8FYwyexaMMd9+vSRILinVV6qSV
 xoprkuvodBmblmVDAvTCkF2/PUTZlIljlA8Ho6n+DzaVU4wysVfev3JmNpwSBGxwUiGy
 zAM+39D7BSF2N/tsIW4ULNBWFxHAGE3XzfEwYZiASKhZBF1Ybs3+4AJhw+TkNz0XHMRV
 DQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=v9oEyavsvbZNuuh7Q+PKViZhWtX7WRERjDZsEYQR4V4=;
 b=CReOuBO3naI9JZ/2Q0cbb+2OtpU4ps63bxLdLyiff/fmD/AG6UWy9oS9rIcf1ahXr6
 gDBBzSJjP+bHhHh707Qb5fFbKK850TzTpLvipbkPSpL7a/oxv6Porc215cak540o63Qu
 CZB0OwVd2Kot5L7zas+Wd9niFzslDtiyAfuEt2SL6tMf3Me6zLuXVHx1odQ+uvumHOlo
 xj0S9qhIHcJMEjxThGfsacZOZYAHRsCoi9l/KBUNhLG9bcpOsMvtxMdi7RL54KHSbr59
 ygVftQyYrgsbgqNQK9I+Ogi1L2ibKkBKmxkbwn3nC3S4rpYCQ2jEwDsbGx9a56R5LoZA
 B4pA==
X-Gm-Message-State: AOAM530Vj3Z8QCrInj5Vd8CFKczKBtS6TntlSfPbtKK47zftEXb1mjE0
 cVYRZAlteXASydmV1giZTP3aGTSbiWE=
X-Google-Smtp-Source: ABdhPJwUqQu18tVTrfSb9It/bTdj70+Yz1bQzfPNIbddjOrg1SwRs7KNWGr+9IBciM02rc1wp9LnG/EuPwQ=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:4cc3:: with SMTP id
 z186mr7298391yba.212.1633745598902; 
 Fri, 08 Oct 2021 19:13:18 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:08 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-16-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 15/43] KVM: stats: Add stat to detect if vcpu is currently
 blocking
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

From: Jing Zhang <jingzhangos@google.com>

Add a "blocking" stat that userspace can use to detect the case where a
vCPU is not being run because of an vCPU/guest action, e.g. HLT or WFS on
x86, WFI on arm64, etc...  Current guest/host/halt stats don't show this
well, e.g. if a guest halts for a long period of time then the vCPU could
could appear pathologically blocked due to a host condition, when in
reality the vCPU has been put into a not-runnable state by the guest.

Originally-by: Cannon Matthews <cannonmatthews@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
[sean: renamed stat to "blocking", massaged changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h  | 3 ++-
 include/linux/kvm_types.h | 1 +
 virt/kvm/kvm_main.c       | 4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2d837e06eeec..bdaa0e70b060 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1462,7 +1462,8 @@ struct _kvm_stats_desc {
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
 			HALT_POLL_HIST_COUNT),				       \
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
-			HALT_POLL_HIST_COUNT)
+			HALT_POLL_HIST_COUNT),				       \
+	STATS_DESC_ICOUNTER(VCPU_GENERIC, blocking)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2237abb93ccd..c4f9257bf32d 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -94,6 +94,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
+	u64 blocking;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 42894ff7c474..a36ccdc93a72 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3211,6 +3211,8 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 	bool waited = false;
 
+	vcpu->stat.generic.blocking = 1;
+
 	kvm_arch_vcpu_blocking(vcpu);
 
 	prepare_to_rcuwait(wait);
@@ -3227,6 +3229,8 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	kvm_arch_vcpu_unblocking(vcpu);
 
+	vcpu->stat.generic.blocking = 0;
+
 	return waited;
 }
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

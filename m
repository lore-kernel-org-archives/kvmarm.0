Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDECBC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67B0161260
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 67B0161260
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BB974B168;
	Fri, 24 Sep 2021 20:55:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ttBh8XHMPMoR; Fri, 24 Sep 2021 20:55:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E81D74B163;
	Fri, 24 Sep 2021 20:55:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B7F74B121
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uEp+Hn5L67B2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:40 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02B5B4B08F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:39 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 s5-20020a056902120500b005b603c714b0so5774979ybu.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=FC6lH+ozNX1rSn/Zvey/qYq1p870FyZo4a/L9N/Tnnw=;
 b=H1jaweJg22GIvKz5wgIWDSWv9jBnold6xO8+Vir58J3vlW5yvGMJeY+RWUfUakOq0R
 orXdIRa207F1tk4zi8vuNL8CHfSf+xkMzWW/nJggJB4dETOCDuAFmo/uxwSrXfHa281o
 qUP6uOeam12R8fIodx3kiS3/hgxxDJx4AhPCjd3rZUC9XrvKS1+XNmDeTDwaJ19xQqhV
 cyard+R6ZMOtQO+e0PqanrPIokG2Of63+8xBF7DfYrbPWcKhcpKGH/k2SRB/D5Z/gfcU
 kBugNJHQN0/5+P2fD4RJGRBJy0JvWbzcwyoR231nRb6G1W76P8apmJbzeaDCVzireilR
 R6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=FC6lH+ozNX1rSn/Zvey/qYq1p870FyZo4a/L9N/Tnnw=;
 b=nQfDEqbfje6nKnWkG1TYaFlE0PIiyCGsRCGxpQl0aYLFjVTXSxAiyQbbuKrewxi/Df
 tToWXQKU5kZD/eZbAWw8Yp0ign39cGZnFBku+ouYFvDBtSUcxFEa6YyCm8Igkpp+bEoJ
 611qvpn2PyYPqogSmEFFpfCm3NbGt7PezBRUSYzctjseKDrEkHWRF0yFuFU3PwZvHMJT
 e34IV6CNetPAcZW7MQ+bGuQWpwHLB6xR3nScSo722kVfelQrawYYPkbMnCvZEUuIEzq2
 Udd7TfA34V4MK/Jn2LXerH8m8/gBqkAlj4F3lD9Pww5ssn8E4kzDOnn7ZpLjgS4hlgsO
 ryHg==
X-Gm-Message-State: AOAM533eRgoTy7LtQPa3/l+pnTtns4lL9emOvxVNf/zpgpO2uUrtNxjr
 iSq3WZScHCwWgpcMK2+KdX3NPdOY4fQ=
X-Google-Smtp-Source: ABdhPJxLhkd4HzFL3dM1t/bnW3GVwOoYRsLTHfSU097HYEpOs+mMFMdF2Jxk4a9ePTkex/UXZCMknlTjhiQ=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a25:d747:: with SMTP id
 o68mr16209002ybg.488.1632531339489; 
 Fri, 24 Sep 2021 17:55:39 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:18 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 04/14] KVM: Reconcile discrepancies in halt-polling stats
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, David Matlack <dmatlack@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

Move the halt-polling "success" and histogram stats update into the
dedicated helper to fix a discrepancy where the success/fail "time" stats
consider polling successful so long as the wait is avoided, but the main
"success" and histogram stats consider polling successful if and only if
a wake event was detected by the halt-polling loop.

Move halt_attempted_poll to the helper as well so that all the stats are
updated in a single location.  While it's a bit odd to update the stat
well after the fact, practically speaking there's no meaningful advantage
to updating before polling.

Note, there is a functional change in addition to the success vs. fail
change.  The histogram updates previously called ktime_get() instead of
using "cur".  But that change is desirable as it means all the stats are
now updated with the same polling time, and avoids the extra ktime_get(),
which isn't expensive but isn't free either.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 12fe91a0a4c8..2ba22b68af3b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3202,12 +3202,23 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 					  ktime_t end, bool success)
 {
+	struct kvm_vcpu_stat_generic *stats = &vcpu->stat.generic;
 	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
 
-	if (success)
-		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
-	else
-		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
+	++vcpu->stat.generic.halt_attempted_poll;
+
+	if (success) {
+		++vcpu->stat.generic.halt_successful_poll;
+
+		if (!vcpu_valid_wakeup(vcpu))
+			++vcpu->stat.generic.halt_poll_invalid;
+
+		stats->halt_poll_success_ns += poll_ns;
+		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_success_hist, poll_ns);
+	} else {
+		stats->halt_poll_fail_ns += poll_ns;
+		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_fail_hist, poll_ns);
+	}
 }
 
 /*
@@ -3227,30 +3238,16 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
-		++vcpu->stat.generic.halt_attempted_poll;
 		do {
 			/*
 			 * This sets KVM_REQ_UNHALT if an interrupt
 			 * arrives.
 			 */
-			if (kvm_vcpu_check_block(vcpu) < 0) {
-				++vcpu->stat.generic.halt_successful_poll;
-				if (!vcpu_valid_wakeup(vcpu))
-					++vcpu->stat.generic.halt_poll_invalid;
-
-				KVM_STATS_LOG_HIST_UPDATE(
-				      vcpu->stat.generic.halt_poll_success_hist,
-				      ktime_to_ns(ktime_get()) -
-				      ktime_to_ns(start));
+			if (kvm_vcpu_check_block(vcpu) < 0)
 				goto out;
-			}
 			cpu_relax();
 			poll_end = cur = ktime_get();
 		} while (kvm_vcpu_can_poll(cur, stop));
-
-		KVM_STATS_LOG_HIST_UPDATE(
-				vcpu->stat.generic.halt_poll_fail_hist,
-				ktime_to_ns(ktime_get()) - ktime_to_ns(start));
 	}
 
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

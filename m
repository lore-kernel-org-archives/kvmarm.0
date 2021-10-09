Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84BDC433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66B34611BD
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 66B34611BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B67E4B129;
	Fri,  8 Oct 2021 22:13:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VHcNWJId1S2p; Fri,  8 Oct 2021 22:13:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D0284B11C;
	Fri,  8 Oct 2021 22:13:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D44194B10B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uej9oW0CW-aa for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:12:59 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E12494B131
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:12:59 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b5-20020a251b05000000b005b575f23711so15168847ybb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=C+i8NrMil/B/zUdg/nLE/M0TZQFBBWIIBWMi/JAr4uc=;
 b=je+n3lLm4A0uVSi9vpvS/05S8oYMXrlHSB6veYJTbVDTpbNd4p8mCzawy0O3YfBv0U
 VkYS1gQyXD+Vhv2MKKEDypDIAmAUZV7+XoKV2GNHaTVHTXEEief1nVbXKyPAlhbnV2Iq
 AgDv18LthCBgw3zhOl5b0oeHGLTEvaCSkl5+xlvQQtEny0Ld/9Zg4+QFyGyrsCI8av18
 DmcjgY9VieQy4PNiTx9Rjpoa5+HAuInKE44ebmh0tt4Cev6vzGuTfdj3Hb7+Xq+pKABX
 ReTheEfMC8DB/Mq2Zd65wAAdUEOkI6Nw5jw5fMSe0n/pdwq1ppMu0LuEVStnZqxTNlvJ
 ADqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=C+i8NrMil/B/zUdg/nLE/M0TZQFBBWIIBWMi/JAr4uc=;
 b=YbggL1UbALAGzi127QYy2vGJyl5+j3z70Mr9XlZAoQ712d+rrLyOikeJNSZGYOqLAn
 IwTgIosIzpPqRNNSbykecj17sP4O7bzyfdzNwjq4cHaSaFhwpt6+X6B7qexr5JjXuOvw
 HgyAu2DbDkhS1y2c3InAdzL1EriKB1BOB6BBSLp7iis5dp7uElBJsG47cSQTF4meKNxq
 WX9gGyEB4J+crsoEeqgg6OgmsJKMmTMeHme521rRWVff7RPdI3jbTYBB21WHBx1FwdQh
 xuhdyhqyCX+ftVxjNM49wB5Hs7b/E3vie8HG7DVsnQPDh6tsP3JDA6PFf8o7+xh4Zf23
 jtaw==
X-Gm-Message-State: AOAM533ebPH6cusbVDoO+ARUtENmYSsqcsCeHvUCPMCMUOMfduRSqpT6
 +1tkzYrrbT24f68UWLZW4LM+WV/8jPk=
X-Google-Smtp-Source: ABdhPJyW87IQPywEIwG24n6yL9o1TEbn2OC7doTlKy4ci1tI1vJZKdBQ5pgX2pnD7h6R4lIJ9DAvEJ8oiwA=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1105:: with SMTP id
 o5mr7903925ybu.518.1633745579491; Fri, 08 Oct 2021 19:12:59 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:00 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-8-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 07/43] KVM: Reconcile discrepancies in halt-polling stats
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

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4dfcd736b274..1292c7876d3f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3204,12 +3204,23 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
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
@@ -3230,30 +3241,16 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

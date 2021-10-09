Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03ABC433FE
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E50161040
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5E50161040
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1137B4B12E;
	Fri,  8 Oct 2021 22:13:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zQxDZbs-jXS4; Fri,  8 Oct 2021 22:12:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF2294B11A;
	Fri,  8 Oct 2021 22:12:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26B9F4A193
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:12:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y-zdYspwgdE1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:12:57 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 402D949F5F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:12:57 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 i16-20020a05620a249000b004558dcb5663so9798973qkn.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=duVCxds/Xk54aU09i5UIkyaIUq0yJMQJZI9wZA2YDlA=;
 b=Wv/kcG4ULQxV2PKupeA3o9viF1KOUTbF8+9gkKByWbWPMHCHTm+TZZg7F5whB1kJEv
 00RE4Q8btFY4lrjbmtjP6hVSSAYJJdql8WRFW8k/FQZNMBqfykiFr2BiQA+wfe28C543
 SWlusb4mpYdymW6ZMpaM7mrIbRvVwIrPb/jvum8yisSKEvO7UFeRbl7H6trZAhauAzQD
 a1bpHkCHoYH6NJt8GSDU7cMPxIgXQRKLxIkS2NtUm9+Lov6n2e8PGJQvej1YmfsKCffW
 TihOARLN4ummUTvbvoWa2j+nguD9Os55BuiemMJ8jed6VNGgNVOfE7xoH5rBJNb4aOyN
 lvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=duVCxds/Xk54aU09i5UIkyaIUq0yJMQJZI9wZA2YDlA=;
 b=JRlVJjgX0lsLzy8q3QG2PlROOQUXC11spLWg7t+T1DIN+4g/cty1eFcNwMwZR4W7fa
 jY+CzmLfJ/EkDzFwTzvSd/zBfLpOFgWZyDVYs9sgORTI4zJaQ5BgIMJraX/J2Jvu1Z47
 VNM/TX9nweB8U6FiFCFXZ8UoLJ+D9DuM0+5YDlMV3ozZ0lazIXLhw6ciEIyYs4Uct8Em
 qlWpG6EtDv6j5qahTphnd/UbfUGH8bB6rgBCbqGrY2FTVplpsI183NZZXP0CRtd9y3Vc
 Yd6TPKOAGPC2WiZuYV/JakWkBN6rXy6RryGcGP71NG4ox/M/FxNj0RFDUqi3YUJajjvS
 uJrg==
X-Gm-Message-State: AOAM533/LZjzRIHHWH1LlraVzsZxKbkIDU8lkA7B6MCTUCGFaAHBeQgr
 A6jQTm20Ji4gJzYgwgcFT+GCVMukwSw=
X-Google-Smtp-Source: ABdhPJzReckbemypX4PIoTmT2KiRT9pVyd7dG9YNXxxpVcLBpBPcyP9Rkq3/2bNbj++4tivC2JpyLGM9nrE=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a05:622a:1055:: with SMTP id
 f21mr1892047qte.24.1633745576813; Fri, 08 Oct 2021 19:12:56 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:11:59 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-7-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 06/43] KVM: Refactor and document halt-polling stats update
 helper
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

Add a comment to document that halt-polling is considered successful even
if the polling loop itself didn't detect a wake event, i.e. if a wake
event was detect in the final kvm_vcpu_check_block().  Invert the param
to update helper so that the helper is a dumb function that is "told"
whether or not polling was successful, as opposed to determining success
based on blocking behavior.

Opportunistically tweak the params to the update helper to reduce the
line length for the call site so that it fits on a single line, and so
that the prototype conforms to the more traditional kernel style.

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6156719bcbbc..4dfcd736b274 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3201,13 +3201,15 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static inline void
-update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
+static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
+					  ktime_t end, bool success)
 {
-	if (waited)
-		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
-	else
+	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
+
+	if (success)
 		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
+	else
+		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
 }
 
 /*
@@ -3277,9 +3279,13 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
+	/*
+	 * Note, halt-polling is considered successful so long as the vCPU was
+	 * never actually scheduled out, i.e. even if the wake event arrived
+	 * after of the halt-polling loop itself, but before the full wait.
+	 */
 	if (do_halt_poll)
-		update_halt_poll_stats(
-			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
+		update_halt_poll_stats(vcpu, start, poll_end, !waited);
 
 	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

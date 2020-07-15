Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76213C433E4
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B9812065F
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="LPVEDOuw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B9812065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9D574B357;
	Wed, 15 Jul 2020 14:45:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UUwK39oTEzkB; Wed, 15 Jul 2020 14:45:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6D2B4B381;
	Wed, 15 Jul 2020 14:45:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B54A84B381
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TjImTM0xUvyd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:32 -0400 (EDT)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9DB94B3D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:31 -0400 (EDT)
Received: by mail-ed1-f74.google.com with SMTP id m12so1337462edv.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uPSQdfylTe0ut7Y+LTjoOGoIVmgn8FV+w+ubJc/3Pd4=;
 b=LPVEDOuwUqTX3evDFdlap3NZcz/aTZMbiTdJIwFa30IMaqNgKmL8SM6xgB+MdjWK/6
 Dv87TIzO2isIGznz8S2EWAtCoSKEauZbV4keAKpvBXlTLkuVM+6GlJ5JmtNj81tbns9O
 ZxudmEEa3Np7NJq7xD8/8d3MrrcBxOZYDjacGhU7EYpnJdBqeTSbnhP+fsM8if8onlmv
 BpApMhBfqJaj9Sv/gfgQSYGy498DktD1V8KChejj9HuWzYlsRrkxlfQ5h2LgwcSooF3w
 VcPmV3tT9lKVL/r78XkGN+2pJjLqe+5sJ4FDCI/GwW9XRI/TvKh+yyma2xU2DYMxo09F
 Eo+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uPSQdfylTe0ut7Y+LTjoOGoIVmgn8FV+w+ubJc/3Pd4=;
 b=LjucS1EiJJcyYgC9nQ/wII4l2X1+2tFKSYOFdnUk803TfvAXGT8QbaTUXw0OMtDB9i
 xtaEnI8KPUrtm+i1yJ66k0YZ+wZKoWmq17zv9FlPDjhOrW5KMZt0VnH5nIqL0yJY+yvu
 f7bJtGSugw7aXpiY38aYg08Iq5oyS+4oyVMpEzAlVvufDgGPu8Hge7sAbR4QCbKSI6N6
 eGWZ7wXh3ENtGv+w3UDFljslzaFpeZNE9dLlUv9UQgTP1ONzdxMzx/SoilSYv5trSigs
 i+FR2AJG4k7d8Ihogt1OpP9ViASY/Y92bEYDfBQeTJLsfXgLct6yVY7I8/eqCAsz97e6
 4q7w==
X-Gm-Message-State: AOAM532dWmaYSczXci6IBV7TCFduFPyAnz/f09WwFQ44XN7XOO6OhyE7
 8MqzG4VpF7V8U2ZMh48hYXcRjZnL71h7GTQCQh48CYTx0sPb3QhgptIbyVzH2UEQjD0oWHgERc1
 zdTFc8Ociyf0bIvjkICIo8oq2vj8TCkEcXkHWBdkcNnoSEtGNMD9+wq9mVwdk5P/7CZdYUg==
X-Google-Smtp-Source: ABdhPJxhzKwO2tQfthLclqXFH5uVVgM39Zy6QU5KwftgZSn/1XTItLJ0nCWWwJ04YpnS9sUrDe5LVdCPC1A=
X-Received: by 2002:aa7:da89:: with SMTP id q9mr978292eds.273.1594838730519;
 Wed, 15 Jul 2020 11:45:30 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:20 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-20-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 19/37] KVM: arm64: nVHE: Drop host_ctxt argument for context
 switching
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

The host's state is being stored in the host's vcpu context and not in
kvm_host_data->host_ctxt so the reference is no longer needed.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 8cd280a18dc2..ae830a9ef9d9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -144,8 +144,7 @@ static void __pmu_switch_to_host(void)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
-static void __kvm_vcpu_switch_to_guest(struct kvm_cpu_context *host_ctxt,
-				       struct kvm_vcpu *host_vcpu,
+static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
 				       struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
@@ -185,8 +184,7 @@ static void __kvm_vcpu_switch_to_guest(struct kvm_cpu_context *host_ctxt,
 	__debug_switch_to_guest(vcpu);
 }
 
-static void __kvm_vcpu_switch_to_host(struct kvm_cpu_context *host_ctxt,
-				      struct kvm_vcpu *host_vcpu,
+static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 				      struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
@@ -219,20 +217,18 @@ static void __kvm_vcpu_switch_to_host(struct kvm_cpu_context *host_ctxt,
 
 static void __vcpu_switch_to(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *running_vcpu;
 
 	/*
 	 * Restoration is not yet pure so it still makes use of the previously
 	 * running vcpu.
 	 */
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	running_vcpu = __hyp_this_cpu_read(kvm_hyp_running_vcpu);
 
 	if (vcpu->arch.ctxt.is_host)
-		__kvm_vcpu_switch_to_host(host_ctxt, vcpu, running_vcpu);
+		__kvm_vcpu_switch_to_host(vcpu, running_vcpu);
 	else
-		__kvm_vcpu_switch_to_guest(host_ctxt, running_vcpu, vcpu);
+		__kvm_vcpu_switch_to_guest(running_vcpu, vcpu);
 
 	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 }
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

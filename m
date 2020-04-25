Return-Path: <SRS0=i7fx=6J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB69C55186
	for <kvmarm@archiver.kernel.org>; Sat, 25 Apr 2020 10:24:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B948420704
	for <kvmarm@archiver.kernel.org>; Sat, 25 Apr 2020 10:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R5UEs3rf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B948420704
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BEE34B269;
	Sat, 25 Apr 2020 06:24:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jZp+zfDUuBBW; Sat, 25 Apr 2020 06:24:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 368174B239;
	Sat, 25 Apr 2020 06:24:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE4754B21B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 06:24:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yRUnrSWekkxx for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Apr 2020 06:24:31 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C36D74B1E9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 06:24:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587810271;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AiiGjxMSfR/3HcuLZdv0rh/BGKXUkSP2JfWB96AlEV4=;
 b=R5UEs3rfkcxmFXqmegr8xxrcqVDr8feMITNUPcLwj3NjGw4GcL3NNWcDNrW8in4iLtLwHY
 gM4jQ5BF6buHS7MR995yMOFddELpY8Vb/xdpNr0hJdtX/u9qs/o6BxLUsP6Zn1YhNOejRp
 duvokAL4teBYLz1Bx1BtDug7CnYpmbs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-f4muo0AfNgCx-VZqlLYWNw-1; Sat, 25 Apr 2020 06:24:29 -0400
X-MC-Unique: f4muo0AfNgCx-VZqlLYWNw-1
Received: by mail-wm1-f71.google.com with SMTP id h6so5040811wmi.7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 03:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=AiiGjxMSfR/3HcuLZdv0rh/BGKXUkSP2JfWB96AlEV4=;
 b=OK9M+3Z0qJS7dM+l5tayDCuFiMdhb9XlYcohNtcxmHQM7whFBwsAyLGiE48lbweENG
 U8IH6MtUrxUpcYUQD/8CjayyGw/fkIXAatBJ0TkN4lN4VsjeUtIANPOubbQSp1bfeaHu
 ZN94K8JfM5X1Hv6T0j3nAlcWGN3CT11sACAIU+03b7i4lraPZd4lAQ78WyxkMmqGjmWF
 HidXlHNgxFuNCsMxXCutY3hdFIoVnlgqtufFQttE3ZHfvYQ5LuUPpIjQb1TaIeptHAtZ
 Yb1lDAXZhv+snfQQ1ecpmjfipuMq5/ZrjF/HqRekg9XWk/Z+TaeQRIaZx4Q7KMNIlJuU
 BKTQ==
X-Gm-Message-State: AGi0PuaScyTRjtyeth8oieRWlCYzqhebzcG4Cp67gWz8KsPXct7FMsvk
 +QKI8KZjetopcoXxKN+5xdfjMlckv6jYLqWX/Hq1sQ5n45B3leL9/CsNUTpK02V/BSlmjxHucu8
 ++FPe1zSqq8DFWA1fZ4N3nOdN
X-Received: by 2002:a5d:5745:: with SMTP id q5mr17541305wrw.351.1587810268503; 
 Sat, 25 Apr 2020 03:24:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypJCsnbfHqFriQbI24TXuIAXrqXN8iqz6uh+Ag2xVYIfCBS/H8oNA4RK58IzO9hfko5vLHJ96Q==
X-Received: by 2002:a5d:5745:: with SMTP id q5mr17541287wrw.351.1587810268284; 
 Sat, 25 Apr 2020 03:24:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926?
 ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
 by smtp.gmail.com with ESMTPSA id t17sm11580360wro.2.2020.04.25.03.24.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 25 Apr 2020 03:24:27 -0700 (PDT)
Subject: Re: [PATCH 5/5] kvm: Replace vcpu->swait with rcuwait
To: Davidlohr Bueso <dave@stgolabs.net>, tglx@linutronix.de
References: <20200424054837.5138-1-dave@stgolabs.net>
 <20200424054837.5138-6-dave@stgolabs.net>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <69af54bb-8632-fbf7-d774-da9a954ff1b7@redhat.com>
Date: Sat, 25 Apr 2020 12:24:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200424054837.5138-6-dave@stgolabs.net>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, will@kernel.org, Davidlohr Bueso <dbueso@suse.de>,
 peterz@infradead.org, maz@kernel.org, bigeasy@linutronix.de,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, joel@joelfernandes.org,
 torvalds@linux-foundation.org, kvmarm@lists.cs.columbia.edu
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

I'm squashing this in to keep the changes compared to the current code minimal,
and queuing the series.

Thanks,

Paolo

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index bbefa2a7f950..feca3118b17f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -230,10 +230,10 @@ static bool kvmppc_ipi_thread(int cpu)
 static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
 {
 	int cpu;
-	struct rcuwait *wait;
+	struct rcuwait *waitp;
 
-	wait = kvm_arch_vcpu_get_wait(vcpu);
-	if (rcuwait_wake_up(wait))
+	waitp = kvm_arch_vcpu_get_wait(vcpu);
+	if (rcuwait_wake_up(waitp))
 		++vcpu->stat.halt_wakeup;
 
 	cpu = READ_ONCE(vcpu->arch.thread_cpu);
@@ -3814,7 +3814,10 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 		}
 	}
 
+	prepare_to_rcuwait(&vc->wait);
+	set_current_state(TASK_INTERRUPTIBLE);
 	if (kvmppc_vcore_check_block(vc)) {
+		finish_rcuwait(&vc->wait);
 		do_sleep = 0;
 		/* If we polled, count this as a successful poll */
 		if (vc->halt_poll_ns)
@@ -3827,8 +3830,8 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	vc->vcore_state = VCORE_SLEEPING;
 	trace_kvmppc_vcore_blocked(vc, 0);
 	spin_unlock(&vc->lock);
-	rcuwait_wait_event(&vc->wait,
-			   kvmppc_vcore_check_block(vc), TASK_INTERRUPTIBLE);
+	schedule();
+	finish_rcuwait(&vc->wait);
 	spin_lock(&vc->lock);
 	vc->vcore_state = VCORE_INACTIVE;
 	trace_kvmppc_vcore_blocked(vc, 1);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7c2d18c12d87..c671de51a753 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2737,10 +2737,10 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_block);
 
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
-	struct rcuwait *wait;
+	struct rcuwait *waitp;
 
-	wait = kvm_arch_vcpu_get_wait(vcpu);
-	if (rcuwait_wake_up(wait)) {
+	waitp = kvm_arch_vcpu_get_wait(vcpu);
+	if (rcuwait_wake_up(waitp)) {
 		WRITE_ONCE(vcpu->ready, true);
 		++vcpu->stat.halt_wakeup;
 		return true;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

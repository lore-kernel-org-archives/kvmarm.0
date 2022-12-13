Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0DEC00145
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8DE54B951;
	Mon, 12 Dec 2022 19:17:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3a2yv07WZPVF; Mon, 12 Dec 2022 19:17:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C89714B97A;
	Mon, 12 Dec 2022 19:17:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E034B946
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MlH+0Rlu5dVx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:03 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D525A4B944
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:02 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 f8-20020a170902ce8800b00190c6518e21so122748plg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=VfLoNklydv1Rx7BbDoYbdEShyybLFjnrLL1BXeied2s=;
 b=Np8Pq4oyEyyT2NyWGRKhWCpWIKtgc9sp8/et+JS0meGK40iG694E/NYaxXnGXI0TeV
 pAqfSNQC9vcFF79zhXWsirFoGVcn/ax8QgBGxRa1cPYoIDxMNNUz5Jy5AAULOm6SCGAc
 A2EcZLEvvZLS7jcBAxKT7lr/7OJrXxxqMEoWAQweL0OpkQpBF4AL+mTwyhLSigeUVQn6
 9Uvgy3sr74Bmqei662+yAOCZ0l8TL9YTXwynudahz8OX6nc2S0ETlzEpyU5P3RT68+za
 4pvvwlntGLripZEbM1cWf+TCuKTaMguNXMxoTUo9YXqHgb5qZ0Tn/RXjzCP4PZWndVdL
 rjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=VfLoNklydv1Rx7BbDoYbdEShyybLFjnrLL1BXeied2s=;
 b=F8CB0efnwCYRPvUnJ5Gy3vM5dxOWQVnn0IZT/BaqHwVcnic1Q7h43iaWg22EEDbGYK
 zOkQg2QzzzShYCNNopQeksmVfAKECob6jTqY1zJuRNqE17jzmxY0vpHzsEZM5qdtMja+
 NmgiNmM/+9A2lic+l3NLhvxXSrnsIiNeKQevCYuZQcEM6gwFKLmG3epjiijSefEnuniR
 r7168qYCYp5Lkn7IW45oc2tpQCMnYSmBR1ofxHasdL4bt3fcNqG88S1PejtRTKfKuDFp
 zC0WC8EuwZ5DiQX4od5SJhf/NQT++VLn9T0ohs0RL5Sef5WNH4NlvEPmC4lIbqGp3QV0
 n6Qw==
X-Gm-Message-State: ANoB5pkiR3CBMUU5qjTnakTMfztnmHCq6Niqb8hsK3k8xH7e7660P54A
 nge+U+ru8xN7nfTCueM+hGRJNJt4Q58=
X-Google-Smtp-Source: AA0mqf7S5eF8bMFJxVX+zccSnQS8wrFbP/BiB/u3t9DV1AwKakqfaO4vcQavHYooXhlu853wx6mxrrDMel4=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1010:b0:219:1d0a:34a6 with SMTP id
 gm16-20020a17090b101000b002191d0a34a6mr4049pjb.1.1670890621685; Mon, 12 Dec
 2022 16:17:01 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:42 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-4-seanjc@google.com>
Subject: [PATCH 03/14] KVM: selftests: Fix divide-by-zero bug in
 memslot_perf_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
 Tom Rix <trix@redhat.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Check that the number of pages per slot is non-zero in get_max_slots()
prior to computing the remaining number of pages.  clang generates code
that uses an actual DIV for calculating the remaining, which causes a #DE
if the total number of pages is less than the number of slots.

  traps: memslot_perf_te[97611] trap divide error ip:4030c4 sp:7ffd18ae58f0
         error:0 in memslot_perf_test[401000+cb000]

Fixes: a69170c65acd ("KVM: selftests: memslot_perf_test: Report optimal memory slots")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e698306bf49d..e6587e193490 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -265,6 +265,9 @@ static uint64_t get_max_slots(struct vm_data *data, uint32_t host_page_size)
 	slots = data->nslots;
 	while (--slots > 1) {
 		pages_per_slot = mempages / slots;
+		if (!pages_per_slot)
+			continue;
+
 		rempages = mempages % pages_per_slot;
 		if (check_slot_pages(host_page_size, guest_page_size,
 				     pages_per_slot, rempages))
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

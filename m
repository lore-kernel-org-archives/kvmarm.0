Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F017C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 01:35:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9A24BB65;
	Fri, 18 Nov 2022 20:35:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Y4-PTEs37A2; Fri, 18 Nov 2022 20:34:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E0F4BB4F;
	Fri, 18 Nov 2022 20:34:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 978B44BB52
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:34:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WtJaCYKjx9zs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 20:34:56 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46C454BB4F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:34:56 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 a8-20020a621a08000000b0056e3c6c0746so4009289pfa.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 17:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=ainK2RDn+jZipfmA59p8DPXtbCjd5fvmnXnNzM45Lqs=;
 b=ElbaUsSFUGAHxw9FaGIh9WqW076YqYTniSp+9sLgIbyAZGXc9q18pS+d+PVOfEWLyg
 Kx/QdBqkeFSoCaN0e1TOjAh4OmvJCcZTfbRkoIs9Pa9Ier3h3eU6dfc5nhMeLRYb7If1
 R8gMGaRsYzdOWxgY6umO5g2RAl06ZRzk4tCJFWsOlqsTdFgeOz+FKVhUFHG0gjETIWMB
 SJsXPpuWt8ijNGjeVGXQ26qTfp0uSqxFA3Tr0kPraQUGqTQxkgiCsPpjq4Ug8UUJokHo
 3S2V7A4WGHkj82py+dbabm8Ds9t2svz5QsJ1xSBiuk9loWQwWH1Z8uCRnLa36e7zSQDg
 hRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=ainK2RDn+jZipfmA59p8DPXtbCjd5fvmnXnNzM45Lqs=;
 b=1RxeGyCk7+UDRbEfED/p0dcR2Xy218u+JR7T+WKNENJPLYc3cDjBVhYv5t5ADcPKNf
 A1G5J3XBsFzGyXyzC+C0RcMh4A2PVqnwsArcQsME4cu9bSGRBPdXKE7YancXpuQYyEzV
 ZEf4d7fpIj3XTQ/hNtDZurMI268uKt30YHmkqGKaqjwjGq3Os4HXN5wruWXSrn2g5xtX
 qdN5LJqKASABLArNHm6Cn+G6YKr9mYhG0i4NucgzS8QdTWNcV7zdXIHe9p/lOi1Jwq6n
 a0WbZJeZArJ6J/x6IVI22gwH86IhJ18pOEzvbkyK+D/dGnYCaJCYLtYXchWWHkOyox3n
 DGQQ==
X-Gm-Message-State: ANoB5pnbXN/6rlWL3JnkePfAfSpZMO0sRKzWz8SYbpdTcEq31q36R705
 MywhtN9gxe0bEIz2f7CyoIkJduxZdK8=
X-Google-Smtp-Source: AA0mqf6tFBmKyZhX4sewzWE/FLSMviulSVp5ypejrlokkSGEnAY1MSlwDguv1kCBOyWnNtV82VmzeHcBdl4=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ca14:b0:187:3fc8:986e with SMTP id
 w20-20020a170902ca1400b001873fc8986emr2206032pld.4.1668821695384; Fri, 18 Nov
 2022 17:34:55 -0800 (PST)
Date: Sat, 19 Nov 2022 01:34:42 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-2-seanjc@google.com>
Subject: [PATCH 1/9] KVM: selftests: Add rdmsr_from_l2() implementation in
 Hyper-V eVMCS test
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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

Add rdmsr_from_l2() in hyperv_evmcs.c, it got left unintentionally omitted
when applying code review feeback on the fly.  Intentionally duplicate
the code that's in hyperv_svm_test.c, the helper really should not exist
(L1 shouldn't clobber GPRs) and will hopefully be removed sooner than
later.  Until that happens, deter other tests from using the somewhat
misleading helper (it doesn't actually read L2's MSR value).

Link: https://lore.kernel.org/all/Y2FFNO3Bu9Z3LtCW@google.com
Fixes: 860e80157068 ("KVM: selftests: Introduce rdmsr_from_l2() and use it for MSR-Bitmap tests")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
index d418954590b1..ea58e5b436e8 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
@@ -31,6 +31,15 @@ static void guest_nmi_handler(struct ex_regs *regs)
 {
 }
 
+/* Exit to L1 from L2 with RDMSR instruction */
+static inline void rdmsr_from_l2(uint32_t msr)
+{
+	/* Currently, L1 doesn't preserve GPRs during vmexits. */
+	__asm__ __volatile__ ("rdmsr" : : "c"(msr) :
+			      "rax", "rbx", "rdx", "rsi", "rdi", "r8", "r9",
+			      "r10", "r11", "r12", "r13", "r14", "r15");
+}
+
 void l2_guest_code(void)
 {
 	u64 unused;
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

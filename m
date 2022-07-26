Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7740C43334
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A614C2C1;
	Tue, 26 Jul 2022 03:38:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q-vKi9qYNJ-7; Tue, 26 Jul 2022 03:38:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 484764C455;
	Tue, 26 Jul 2022 03:38:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E79444C152
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mzTWsb5huXK9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:37 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2489F4C553
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:37 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31f3959ba41so21023497b3.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jqHv3wNh5seyZnCSMu1rVV5xcStpMLXUKBtcU3Y1j6g=;
 b=ocN5AR1zWFMJEdlfQYlUgBVvqdAFbwAuvDwmF8/WQF7flrQZy/d2lABpWZ90I1DGwj
 uBDOTwVB3d0mowFCuMBvFItzze3IgDYvVeY7MF+0YCht4BAY9N6Rvg3LgAdPwNAO7Zqa
 UWsoXpemhN+pJ+qvZZlKIlMkVeXNiyHkkrkksywHf4jDn9qkfULtI3MYl337w8Z1pIi0
 hGesxH4lpG5OYmornCWfc/StZhbhdxa0VAvVvGMJ8tJ7mP8FUQKCMgedSz5c27wL4aN1
 Y/7E4OfVr6mEd/aTfmMEtKFSKRG5k/Q6b/oS8yrnS7U3v1pA8SbmNiuNjfXvoeXZ3KFi
 sMjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jqHv3wNh5seyZnCSMu1rVV5xcStpMLXUKBtcU3Y1j6g=;
 b=xyacZeR7MWXPMsXuHlSo3k1mbfbyzKVfitaScv/IKKY/DlS2BiVe5tRIbtIlC1dR3I
 k7kEl9lqiLNbAEvl2trSucgb65MXG3KjJa4itwrK2cTyniOWnPTAWjzKaqx9BwUmOjJu
 9j0o7gDl9F6HpxMFmzRDjbfGiGUMEKXnJPMitwo1zXPWrLyUFpV3IyFEm/OlTEBYbydJ
 l5UVkAwyHI+VeZhUf4u/8YXyugtm+Fzl6fUCVy4OtU+P1N3nO5/CED8CA5WejgOJ2Art
 4+aOwt49FqG8NoLDbhzPQXFzLRZB1lOECfW4S5glwZhmJ60uAta9nIqCS4Q/+GDaEwqL
 xbCQ==
X-Gm-Message-State: AJIora8PHUO9fMiyHRnN1t8f1nxuIeewX2Ea7OGOcpczvo42JW837WhE
 4ADzxdotcOUkeY4rkLbStwe5Mqhr26E5pjEYXA==
X-Google-Smtp-Source: AGRyM1topRzJUtRGNFO9xj3XVL9vGf78Qw66LXXmx8qTxzqFbDxaG+0vvCO+D0Dnu6p0fFCleQQnl3iTvjkdyPhgxw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:640a:0:b0:671:3386:f860 with SMTP
 id y10-20020a25640a000000b006713386f860mr6983680ybb.423.1658821116945; Tue,
 26 Jul 2022 00:38:36 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:50 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-18-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 17/17] KVM: arm64: Introduce pkvm_dump_backtrace()
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

Dumps the pKVM hypervisor backtrace from EL1 by reading the unwinded
addresses from the shared stacktrace buffer.

The nVHE hyp backtrace is dumped on hyp_panic(), before panicking the
host.

[  111.623091] kvm [367]: nVHE call trace:
[  111.623215] kvm [367]:  [<ffff8000090a6570>] __kvm_nvhe_hyp_panic+0xac/0xf8
[  111.623448] kvm [367]:  [<ffff8000090a65cc>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
[  111.623642] kvm [367]:  [<ffff8000090a61e4>] __kvm_nvhe_recursive_death+0x24/0x34
. . .
[  111.640366] kvm [367]:  [<ffff8000090a61e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  111.640467] kvm [367]:  [<ffff8000090a61e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  111.640574] kvm [367]:  [<ffff8000090a5de4>] __kvm_nvhe___kvm_vcpu_run+0x30/0x40c
[  111.640676] kvm [367]:  [<ffff8000090a8b64>] __kvm_nvhe_handle___kvm_vcpu_run+0x30/0x48
[  111.640778] kvm [367]:  [<ffff8000090a88b8>] __kvm_nvhe_handle_trap+0xc4/0x128
[  111.640880] kvm [367]:  [<ffff8000090a7864>] __kvm_nvhe___host_exit+0x64/0x64
[  111.640996] kvm [367]: ---[ end nVHE call trace ]---

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v6:
  - And range check when dumping pkvm stacktrace, per Oliver
  - Use consistent nVHE call trace delimiters between protected and
    non-protected mode, per Oliver
  - Fix typo in comment, per Fuad

Changes in v5:
  - Move code out from nvhe.h header to handle_exit.c, per Marc
  - Fix stacktrace symbolization when CONFIG_RAMDOMIZE_BASE is enabled,
    per Fuad
  - Use regular comments instead of doc comments, per Fuad

 arch/arm64/kvm/handle_exit.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e83e6f735100..c14fc4ba4422 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -371,6 +371,39 @@ static void hyp_dump_backtrace(unsigned long hyp_offset)
 	kvm_nvhe_dump_backtrace_end();
 }
 
+#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
+			 pkvm_stacktrace);
+
+/*
+ * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ *
+ * Dumping of the pKVM HYP backtrace is done by reading the
+ * stack addresses from the shared stacktrace buffer, since the
+ * host cannot directly access hypervisor memory in protected
+ * mode.
+ */
+static void pkvm_dump_backtrace(unsigned long hyp_offset)
+{
+	unsigned long *stacktrace
+		= (unsigned long *) this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
+	int i, size = NVHE_STACKTRACE_SIZE / sizeof(long);
+
+	kvm_nvhe_dump_backtrace_start();
+	/* The saved stacktrace is terminated by a null entry */
+	for (i = 0; i < size && stacktrace[i]; i++)
+		kvm_nvhe_dump_backtrace_entry((void *)hyp_offset, stacktrace[i]);
+	kvm_nvhe_dump_backtrace_end();
+}
+#else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+static void pkvm_dump_backtrace(unsigned long hyp_offset)
+{
+	kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE\n");
+}
+#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
+
 /*
  * kvm_nvhe_dump_backtrace - Dump KVM nVHE hypervisor backtrace.
  *
@@ -379,7 +412,7 @@ static void hyp_dump_backtrace(unsigned long hyp_offset)
 static void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
 {
 	if (is_protected_kvm_enabled())
-		return;
+		pkvm_dump_backtrace(hyp_offset);
 	else
 		hyp_dump_backtrace(hyp_offset);
 }
-- 
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

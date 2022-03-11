Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9006FC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:57:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42BEE49F16;
	Fri, 11 Mar 2022 12:57:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G6aU7akoNgfC; Fri, 11 Mar 2022 12:57:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10D9249F09;
	Fri, 11 Mar 2022 12:57:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1629449F0F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id at9bUA1WTaEB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:57:44 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69C9649ECF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:43 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 f19-20020a056e0212b300b002c67321e5b4so5296987ilr.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BxxrnSwrIA4lSZ5dK5jxyr2r2tLhZUFOrxcbnlilois=;
 b=fa5WoWeDUYBwu4AqAKpVBlulmdk6ITEQVYZONtJ2u9pcPIxaUyOx/pOBQgOFg52Yd/
 wSfGcWikT539Mu8oowRqbz3fzCMwnwM2i5FeKo6/JzeMJsuGnlAwC+RArs0TelINjAXJ
 YiiylZhsdD+TKZvFRp2bvcQju/VH3KxGC+y7ml99Qp85+xH7mQOVUVbQSpIhRWsaekAN
 zUx51OPbUCnvBVDxI6VrdMmWwvrjuDqtvEB+rxlLXPR1SULdF0qUS6NAVJnqAB18H1g1
 DwvvD2Doyg3jUEWe2BlVwIkjcpUQlP74u15eK66wr6aSPlw3R/xOQ6q7VbMENibsurOl
 iEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BxxrnSwrIA4lSZ5dK5jxyr2r2tLhZUFOrxcbnlilois=;
 b=L14C1QJdxVENv893HFIZDcQdijT0LPk6blu69rBRhXyn17qtt4EqvE/bnJA9/p+Gkm
 txBnlVYAeGaX5V3ZshcZtZH9k3IDu7jC14LhhPl4s+m+AxQFdtcYsVlnPa8PCnICQG8y
 vxxc1P1bA7opo+hsIqPD5rSiBDaJewlfwZkKUoF9Qvrart+9CoLyiuNlxeWhrdzE6oyV
 EAmP8EzmIAhGEVYM/mq7Emi7VG5UeL9a5qGgFnz1CzX/G5gTVx7Nw8Osp+lSE13aS5de
 sWnwYIIQpootiGqUklPV6g7yuAlTG7Sy47NFCRrmS0Az9lXK4kU9Ugc+K/XqWpmHVpau
 L2zw==
X-Gm-Message-State: AOAM53334SHSLgbrcQaANyPs0jQRb6pOCaPnhvhnd1dlvy9AeS9T7Xwn
 54NFWOGx2ttSodI4+HLeBOIptSsyGOURXXhNYMAEA9GVN4ehw32URQCcQ6Ly51sgpLeJPDcqR5A
 3wprThB+J9IBfeQ7f8PP3vQWjtrfKbgQ1sgdWncfdk2uX5sXreN8vcVWVQh+ClTRLIoBp6g==
X-Google-Smtp-Source: ABdhPJwX1T89M6pC5yjyrmOZYn4413egwXefNOi34Uw2IPjEjKr6OBMM3S5JvF/Oiv1+jz9CqWb3dK8SDTQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:2388:b0:314:1ec0:b012
 with SMTP id
 q8-20020a056638238800b003141ec0b012mr9295720jat.224.1647021462801; Fri, 11
 Mar 2022 09:57:42 -0800 (PST)
Date: Fri, 11 Mar 2022 17:57:15 +0000
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
Message-Id: <20220311175717.616958-4-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
 <20220311175717.616958-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 3/5] ARM: Stash vcpu_init in the vCPU structure
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-arm-kernel@lists.infradead.org
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

A subsequent change to kvmtool will require that a vCPU be reset more
than once. Derive a valid target/feature set exactly once and stash that
for later use.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arm/include/arm-common/kvm-cpu-arch.h | 18 +++++++++---------
 arm/kvm-cpu.c                         |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
index 923d2c4..4027afe 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/arm-common/kvm-cpu-arch.h
@@ -10,18 +10,18 @@ struct kvm;
 struct kvm_cpu {
 	pthread_t	thread;
 
-	unsigned long	cpu_id;
-	unsigned long	cpu_type;
-	const char	*cpu_compatible;
+	unsigned long		cpu_id;
+	struct kvm_vcpu_init	init;
+	const char		*cpu_compatible;
 
-	struct kvm	*kvm;
-	int		vcpu_fd;
-	struct kvm_run	*kvm_run;
+	struct kvm		*kvm;
+	int			vcpu_fd;
+	struct kvm_run		*kvm_run;
 	struct kvm_cpu_task	*task;
 
-	u8		is_running;
-	u8		paused;
-	u8		needs_nmi;
+	u8			is_running;
+	u8			paused;
+	u8			needs_nmi;
 
 	struct kvm_coalesced_mmio_ring	*ring;
 
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c..1ea56bb 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -128,7 +128,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->init		= vcpu_init;
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

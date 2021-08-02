Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6227C432BE
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 19:28:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61A75610FF
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 19:28:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 61A75610FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADD524A195;
	Mon,  2 Aug 2021 15:28:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7DFxsn2CiHOb; Mon,  2 Aug 2021 15:28:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0E0C49FB7;
	Mon,  2 Aug 2021 15:28:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03B85407F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 15:28:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yQqxmGwZEYOg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 15:28:13 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA6B0407EF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 15:28:13 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 z16-20020ac87cb00000b029025bf786be09so3319151qtv.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 12:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=7p7mJlnVfl7T+hlkAFYQVL3Is2jTnSQaIAIQgTOcTTk=;
 b=OY292XYyvnBQO68s2vxsf3lDot6Bl03ugOYkZXMJ9nkuBk+VuvbVvn/odIPpSKl276
 xD0eqPI8jPoX/TF86opk9ZaMJQWa2HRJOq94tzbxlPWK8vES8KnmkizzX+2ms4SdkJJ6
 OAEGDsS4vYub5LQa1QcPWHWhWX9ACr/85Dk+uBeK3Sgz0w17r8COtDiuMi5Eq4Hpqqcy
 FgTth+PT7AlHU0Y4O1Ql51fYFcVknWX7ukp6pFJ/ozpKLOPNo0Mma784d+wGq25wDBsO
 8sl1aV66fmgfyNYGSCjjzQaZZDi76dVnOSRnA0hS9eEjO/QAPnioTibV1YLced4eE/us
 9tLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=7p7mJlnVfl7T+hlkAFYQVL3Is2jTnSQaIAIQgTOcTTk=;
 b=QAQhlruPbpIpFywM3gEfoGt/HnGxgOxrvOEwOfrYMFGHegKuNx4POdZHovyhlyjQuO
 nYWACUDcc7OIljDVzn2jtau/MKUWt8mDiaifl85kv/pcLYO3OKuMp5d1+I5XGJSpjg5e
 rYqW6xrB6jJVeCFTtBBmw4g2Ahik1sBCifG3gSL18CR81iXdKJh3czS7W15ZpItW5w0V
 8dvCqyHP5c9txVpP+EvF9i8ZYbkdnoZJVt8V4DiaCzroMiIWseUgMbjNpoWPGDpdmim7
 DFDyBNdffi7mBLqhSw0gb1F9UijiAPaUr2QCTznDxEVvuR7tCCjn6CQXLxKNDoCZJWen
 rB7Q==
X-Gm-Message-State: AOAM532IxnsTxDuLPcg/FKXBSeTt+Mz/ae5A3hTAKW7hHUJlXrXF4x5X
 ThJEzjYey+Iojg1zZ1MRgt17bbImXnzzg7++iWailOokBQSaobzAyVAzmrIif5QfC+kipO48nXt
 8Ai1llL/h5UrVMX8P9RMTCf2VSXVsufyOiuJlM+sMWSkqsgQmiV1UWNI32JcKvLC15Fqj/g==
X-Google-Smtp-Source: ABdhPJwgN1HZ3KJQEcy/2zN9k/TS5BpBTtk4TBxtE7nS2taL/Exse1zhnY7xm/INDrcGXMRjZGi0yvlXbY0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:18c7:: with SMTP id
 cy7mr17647152qvb.59.1627932493300; Mon, 02 Aug 2021 12:28:13 -0700 (PDT)
Date: Mon,  2 Aug 2021 19:28:06 +0000
Message-Id: <20210802192809.1851010-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 0/3] KVM: arm64: Use generic guest entry infrastructure
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Shakeel Butt <shakeelb@google.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Guangyu Shi <guangyus@google.com>, Will Deacon <will@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

The arm64 kernel doesn't yet support the full generic entry
infrastructure. That being said, KVM/arm64 doesn't properly handle
TIF_NOTIFY_RESUME and could pick this up by switching to the generic
guest entry infrasturture.

Patch 1 adds a missing vCPU stat to ARM64 to record the number of signal
exits to userspace.

Patch 2 unhitches entry-kvm from entry-generic, as ARM64 doesn't
currently support the generic infrastructure.

Patch 3 replaces the open-coded entry handling with the generic xfer
function.

This series was tested on an Ampere Mt. Jade reference system. The
series cleanly applies to kvm/queue (note that this is deliberate as the
generic kvm stats patches have not yet propagated to kvm-arm/queue) at
the following commit:

8ad5e63649ff ("KVM: Don't take mmu_lock for range invalidation unless necessary")

v1 -> v2:
 - Address Jing's comment
 - Carry Jing's r-b tag

v2 -> v3:
 - Roll all exit conditions into kvm_vcpu_exit_request() (Marc)
 - Avoid needlessly checking for work twice (Marc)

v1: http://lore.kernel.org/r/20210729195632.489978-1-oupton@google.com
v2: http://lore.kernel.org/r/20210729220916.1672875-1-oupton@google.com

Oliver Upton (3):
  KVM: arm64: Record number of signal exits as a vCPU stat
  entry: KVM: Allow use of generic KVM entry w/o full generic support
  KVM: arm64: Use generic KVM xfer to guest work function

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Kconfig            |  1 +
 arch/arm64/kvm/arm.c              | 71 +++++++++++++++++++------------
 arch/arm64/kvm/guest.c            |  1 +
 include/linux/entry-kvm.h         |  6 ++-
 5 files changed, 52 insertions(+), 28 deletions(-)

-- 
2.32.0.554.ge1b32706d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

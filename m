Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6991CC63697
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:25:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D3A022261
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="HNhCr9vU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D3A022261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6B3D4B45E;
	Thu, 19 Nov 2020 11:25:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RmCqLQ30ZuQy; Thu, 19 Nov 2020 11:25:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 523924B3D9;
	Thu, 19 Nov 2020 11:25:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 671AE4B3D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:25:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yL0BWy8xLfvb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 11:25:49 -0500 (EST)
Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com
 [209.85.218.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 385254B2EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:25:49 -0500 (EST)
Received: by mail-ej1-f65.google.com with SMTP id f23so8776406ejk.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 08:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=2GruhQdqr+wzWu7YIuTjo4e/TRyXrwSpjT/ODeg/Yqc=;
 b=HNhCr9vU0ISFuiHpPTfBE/dnSa1k1AQmT5a5owhc4HAvKKm3lmsYZp8SXMp+lTOqLJ
 oA3puTIhotxShLQBAg0rlM4WDEQkkC69CqcXEaiU9EAiBKKxtasmjjIbIeazLFtic2MI
 fLz07UvbuvQYFFiUzTKn15TR5mxfbYbxOQpkI5/9WHICtRExdl10ClVPeje4PwMD++Sp
 5gJtKtlsgxdEDaopQgVhEbsCfANljY7EtRJZz+x93MNooDxOX9ReqlU+WdfT/OoDCbh6
 DZ4+nKQgm0TMuhm7MKG6SISpKF0WEI9VVfoZtlPQUmeHaXi/qPVmsTWyh3Hr2yUJQNso
 SF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=2GruhQdqr+wzWu7YIuTjo4e/TRyXrwSpjT/ODeg/Yqc=;
 b=E6b8GRNMKTB2Xgn3Uf88T5vNnWC7nmgEKqwvzmRtBTUdNcrn5TvG+Bmnn5OhWOqKBH
 UQ0Dd5mR7Jt47cWrR3iBGTY7Nb0x6nqgFEBWxYJ3S41pvG0R84eHBiDSM0q2BB4P2pWU
 Hnanjl0akPZWPdjjfuTI0Agb6y07TT3D7ipr3WTgg7wFq1LghA6BTOVhoXKuH39tPfYn
 R7DazjereXuRmoP2cvEm7n1aw8/RIQah9eX4it7Xbpegodwyr4aHItW47CiUP3GWuUrq
 kzwFQq5mu+m8/EL0cRvotLSyk/V0tuQfTKy7gRU5kqfqrlo227LyYYPuCNp50j4hK+H/
 EWwA==
X-Gm-Message-State: AOAM532W0jDdssWE7rziQImgwwZXcleJH2AebOOyyWbe21/rxp6pTcDk
 KgiKtOpQXd+OKZPDlHuUsgdGZE94FxtRIA==
X-Google-Smtp-Source: ABdhPJx5kfoZrvZqP/Uo4FFewwoV/LxEuk0ZaZ0aeXlkfVXWjL868auf9G7gfWTXVZ0FB7pclJWrVQ==
X-Received: by 2002:a17:906:3ec8:: with SMTP id
 d8mr29647604ejj.32.1605803147524; 
 Thu, 19 Nov 2020 08:25:47 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9843:cd3f:f36b:d55c])
 by smtp.gmail.com with ESMTPSA id 2sm66968ejw.65.2020.11.19.08.25.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 19 Nov 2020 08:25:46 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 0/6] kvm: arm64: Fix up hyp relocations
Date: Thu, 19 Nov 2020 16:25:37 +0000
Message-Id: <20201119162543.78001-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

Hi,

KVM nVHE hyp code runs under different VA mapping than the kernel, which
meant that .hyp.text code had to use PC-relative addressing because
relocations would produce a kernel VA. Programmers had to be extremely
careful with C semantics to not break this fragile setup. See
hyp_symbol_addr comments for details.

Now that we're moving to all nVHE hyp code/data being in separate ELF
sections from the rest of the kernel, it is becoming possible to revisit
relocations during early boot, filter those used by nVHE hyp and
converting those (already relocated) kern VAs to hyp VAs.

Sending this as an RFC, mainly to get feedback but also because it's
only lightly tested. It still feels hacky but much more robust than the
existing approach. The one place where I see somebody breaking this is
the list of ELF sections owned by ELF. That list is currently evolving
but should stabilize over time.

The patches are based on kvmarm/queue (with Marc's "Host EL2 entry
improvements") and my "Opt-in always-on nVHE hypervisor" v2 series.

-David

David Brazdil (6):
  kvm: arm64: Set up .hyp.rodata ELF section
  kvm: arm64: Fix up RELA relocations in hyp code/data
  kvm: arm64: Fix up RELR relocation in hyp code/data
  kvm: arm64: Remove patching of fn pointers in hyp
  kvm: arm64: Fix constant-pool users in hyp
  kvm: arm64: Remove hyp_symbol_addr

 arch/arm64/include/asm/kvm_asm.h         |  20 ----
 arch/arm64/include/asm/kvm_mmu.h         |  48 ++++-----
 arch/arm64/include/asm/sections.h        |   2 +-
 arch/arm64/kernel/image-vars.h           |   1 -
 arch/arm64/kernel/smp.c                  |   4 +-
 arch/arm64/kernel/vmlinux.lds.S          |   7 +-
 arch/arm64/kvm/arm.c                     |   7 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h  |   4 +-
 arch/arm64/kvm/hyp/nvhe/host.S           |  29 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       |  11 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c        |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S        |   1 +
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     |   4 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |   2 +-
 arch/arm64/kvm/va_layout.c               | 123 +++++++++++++++++++++--
 15 files changed, 175 insertions(+), 92 deletions(-)

-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

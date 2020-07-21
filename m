Return-Path: <SRS0=7ri5=BA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDCAC433E2
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 09:45:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C2DD2072E
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 09:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="pKahYClp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C2DD2072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C54124B110;
	Tue, 21 Jul 2020 05:44:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KkK6m472pMwx; Tue, 21 Jul 2020 05:44:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B94984B197;
	Tue, 21 Jul 2020 05:44:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C3F24B14C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 05:44:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sl4AK9w3pkFf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jul 2020 05:44:56 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D02844B110
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 05:44:56 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id 17so2218376wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 02:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=oay/q/Jq6u5HCNMFK6qus7veTfF7oH0EkEyRRbWbBuo=;
 b=pKahYClpT7rbPBcaiNecELPYrFpNr1sOL/KBnAvFlQ/TUhvOxhwaV1ieuOvT9p1us4
 7pAMGHA/F5puU5alUBQzKCc28k+Z7+mKr70H2brQsauG36WtQ6blvcQgr3ZF1Dr6dJaS
 NL9Gt6qiOUhFlbqwCHXnO0ZA2YCc5HCN5QvsQ1TrMrhwSb8hvm+Wwew6xBo0PTh1NWvE
 zM7e0VS6eULENmw536jEVb8MBPO5pzsXLmYGcyVGyt6wLUAOk9SdqPLtQfySwLojPCT1
 RxEs3sxrFuQdRj/H1OeiHeUP39Z3NLk78zuf6JvG/zOh96HuCYNOv3II/OKGccw/SIin
 tgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=oay/q/Jq6u5HCNMFK6qus7veTfF7oH0EkEyRRbWbBuo=;
 b=BmMUqdkUOnVE8qNzZ4vcDce/epp/bPDEC9Tp/dYtBuNkNofJbEO1dtFFSffkM1hhNq
 5GByxQyTJarX20n1MW9iLUwXAnwjKL5oBZyqyOZ8ckHhZKJqZnEiDRAjjG8SXrqvo86T
 oMVU+HPgIJOHD4U6hQ6WEUbptAw3RC1i91PUMQfLZVBy205NoxTQ1R8crzl+y44cJTgT
 Jdltc7AUIoua3dCneDHvjgLcIblpq0qHZtM9kSuOR0Mx+wxr6YN1aiCkN0kMcSZ/Ab1m
 N8HmsgMFCGUSk44z9ajZoYZN51XKdoLJAm9hfxleo8cKsOiQgJ/dXWsju16vrMZMT04R
 0fWA==
X-Gm-Message-State: AOAM531QyPs0jB9KWvfzmz5OlHPUTDonaxBE0v8dul46HlIueF1sIUQL
 asBxuE5/H4LzsY5G31DrCIGrgA==
X-Google-Smtp-Source: ABdhPJxngyOwJYmlqV/5VQl0CDeLGpyMwcxXJSKOOd8cTePn/msAa3i6Sezc+NNalflZifuYHyrtpQ==
X-Received: by 2002:a7b:c090:: with SMTP id r16mr3007999wmh.143.1595324695605; 
 Tue, 21 Jul 2020 02:44:55 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:cd93:4ca4:af31:19e5])
 by smtp.gmail.com with ESMTPSA id t3sm5442414wre.41.2020.07.21.02.44.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jul 2020 02:44:54 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/2] Unify non-VHE ASLR features behind CONFIG_RANDOMIZE_BASE
Date: Tue, 21 Jul 2020 10:44:43 +0100
Message-Id: <20200721094445.82184-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

There is currently no way to disable nVHE ASLR, e.g. for debugging, so the
first patch in this series makes it conditional on RANDOMIZE_BASE, same as
KASLR. Note that the 'nokaslr' command line flag has no effect here.

Second patch unifies the HARDEN_EL2_VECTORS errate for A57 and A72 behind
the same Kconfig for simplicity. Happy to make it just depend on
RANDOMIZE_BASE if having an option to keep randomization on but hardenning
off is preferred.

David Brazdil (2):
  KVM: arm64: Make nVHE ASLR conditional on RANDOMIZE_BASE
  KVM: arm64: Substitute RANDOMIZE_BASE for HARDEN_EL2_VECTORS

 arch/arm64/Kconfig             | 16 ----------------
 arch/arm64/include/asm/mmu.h   |  6 ++----
 arch/arm64/kernel/cpu_errata.c |  4 ++--
 arch/arm64/kvm/Kconfig         |  2 +-
 arch/arm64/kvm/va_layout.c     |  2 +-
 5 files changed, 6 insertions(+), 24 deletions(-)

-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

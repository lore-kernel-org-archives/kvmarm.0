Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD10AC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42D426137D
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 42D426137D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D32364B160;
	Tue, 19 Oct 2021 08:13:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VpPDbsJvawvc; Tue, 19 Oct 2021 08:13:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6D04B165;
	Tue, 19 Oct 2021 08:13:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B19D44B116
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jqS64fqJNzYf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:10 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E89EE4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:09 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 10-20020a5d47aa000000b001610cbda93dso10036569wrb.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tdsCErEUABqyyQ1mbx3uMSi/aufrxWWc3XxvUpZyi6c=;
 b=agqompm2B2MZmrGmB/gxpWpG6vgaVYlKU4CIg03TGpGC+4aalw5NfoiD3nd16AtPKC
 +DDl3VZfg72c4W3xGXNnVhohTo/s1mh5Cyu5/QSadO0RvwtMUqZBiqtMAx328Fh9wqjq
 O0Nnn+TUupK1jSkoQ6zAv3/qn9uizgYDbldXMVCRDlXhC3lCi4AOj3ogrxk1mN+ucv3t
 cBTjLmdxquTpk/VsYC9VrDb0/yJLDYC7h9Lyd93revkEa0NK2jXBGNPbXzqtFp+2iCfn
 x3H7XuI7FYVAgUe1wh0Gh6d7Wleobtrh8ZGRAvmytblQRuG07xpaCyWW6Wf03jkJTJVX
 x5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tdsCErEUABqyyQ1mbx3uMSi/aufrxWWc3XxvUpZyi6c=;
 b=oG/oZjdgWSeiYpL11iP2dGcH9BAwXHJ9GG8MwLeFDvW3qkW4wM4UuKk0/q4ufzdOtF
 9V8RwwJW8N3s/maiHSI4aGt64lH6ILS7w3Tc2KanncgOjERybdTRf4nZyHWkQRwaVFmr
 bbmCDDc9salfDmG6C5SgNHwPQenqmTS2aGKDylZwKmp/CL1u7Zk2nxye7iR2BtoWBeFY
 WY54lHOXGNRwRKu16pmGKTe9tfmhxFDf0sktGCoUIas2Jf81HvsQuA8iNG9kMEBW0iI+
 7U8UM1ov8u3x9wBuOPUsWLQL8LEy0/etgSWGmpafF30qmgVJi2ATAJxtVmL9cR0B61se
 jqcw==
X-Gm-Message-State: AOAM5327m5vIGw+zbirMMYjYoH3mHXNlODTOZTRDPbHXOIE2T9XqlAzU
 OUYwJDSxyT1kuDf3QgMYLYOUoV4SHgXS
X-Google-Smtp-Source: ABdhPJwSSTIWtOO8ktVy4rHrNPU+CIvJsJy3oLDvfo1jOaII6PMNjG5KAfWEfB/Wt+zdj/T+fCLv/8OQmHxo
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a1c:5417:: with SMTP id
 i23mr5564552wmb.17.1634645589172; Tue, 19 Oct 2021 05:13:09 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:50 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-2-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 01/15] KVM: arm64: Check if running in VHE from
 kvm_host_owns_hyp_mappings()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

The kvm_host_owns_hyp_mappings() function should return true if and only
if the host kernel is responsible for creating the hypervisor stage-1
mappings. That is only possible in standard non-VHE mode, or during boot
in protected nVHE mode. But either way, non of this makes sense in VHE,
so make sure to catch this case as well, hence making the function
return sensible values in any context (VHE or not).

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index da10996dcdf1..0019b2309f70 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -239,6 +239,9 @@ void free_hyp_pgds(void)
 
 static bool kvm_host_owns_hyp_mappings(void)
 {
+	if (is_kernel_in_hyp_mode())
+		return false;
+
 	if (static_branch_likely(&kvm_protected_mode_initialized))
 		return false;
 
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D6CC43219
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 19:38:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D363749EEE;
	Fri, 18 Mar 2022 15:38:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7qUY4JgdFrHs; Fri, 18 Mar 2022 15:38:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF68749F2C;
	Fri, 18 Mar 2022 15:38:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C75FF49ED1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 15:38:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uh8rNmyZ5MhU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 15:38:52 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD0AD49EE2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 15:38:52 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 y7-20020a92d207000000b002c7f55e413bso2179398ily.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 12:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wuK4ueNqZP0GzZsEOqe508HJuzt+R9wh2IWRVsBTI30=;
 b=DX/hQhQIL3T3in9mXK43MOUUG88eK+JlLFCWRmC0FpLYM4vyGZCwfBMTRtYjlueoDI
 cCntMu+NW9lzYQeW6XlbliSnyHGflRbaI44DbHPEKkHgRduAcBd9eaqAZA7S5/vBBusF
 UUzoE/U+TtgoeRR7xGpRiuKpA+Ggx1ybZWjgBcpsLUHkXNfBKg04wA5ho5dCPF+g/zj6
 04DCrGzhgUTStF/M0Zkx9/UzD6t70s33hNUXCT6V8au2ICW7TPX4vcQ9p5vluvLLgbXA
 KHSK/BfpfyQFOYHVdpXVDR/IoWYwnAhaBsuYeFGY+XVCOzdOenH2mSnWeNwg0VYZf8la
 yYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wuK4ueNqZP0GzZsEOqe508HJuzt+R9wh2IWRVsBTI30=;
 b=eQIlLsCl7u49yAgK8YLHJtY+heAK7X+ZrpU2GpEHDzg1gXtrpyorPOkQMnydWeL7Jd
 A6Q8kI8XaQw0LZycQKAXCBoh8eEnVB9kb0hOtW/cgH9q/n04m8SDg7pUADYidHER7xFB
 uOrNDW3VoG4uhPI5gXjaN4Q5Ir1ZJlG6O3Ehxgius5xfKZj6ctHc08NUydDBLJdCs6IE
 XxrCezRrM8dkx9RJ7kHqEaOHauEGiXNRSkJDsKghwfo9C8uP5WstEojz7iXuKb0iKua8
 iThT58+JHYxONnLQYM63OqgJF+txznnGRhccqSGivAl5efYWhIfgfsYAXFHhPYCAm8rO
 RYVg==
X-Gm-Message-State: AOAM530oHrGiJBgji30j2tl3vFFuBRf3VZq92r67DboToUas8qFgKki3
 OEvXBzOhEdS3U7kSrjnfr9VJQEGNI7lZVfF9ylauQk17G+1ebpFsIIW8hDDaeVKvHA0PwH/OHMh
 AZrVRPciN0DgkxC8sYqCdCgl5iuLXG2O4pToPqUVjIdrwgh/jo2UQCbYii8lejRD8pRJ80g==
X-Google-Smtp-Source: ABdhPJz9kr+l6ckzIE00y1HiGRsJeWLm1xQMEM8JkI13iYPFP4zi1a2CA2eGif9AMiNeTCZHstmnwiHQldE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:7106:0:b0:2c6:3167:ce83 with
 SMTP id
 m6-20020a927106000000b002c63167ce83mr5228453ilc.138.1647632332153; Fri, 18
 Mar 2022 12:38:52 -0700 (PDT)
Date: Fri, 18 Mar 2022 19:38:31 +0000
In-Reply-To: <20220318193831.482349-1-oupton@google.com>
Message-Id: <20220318193831.482349-3-oupton@google.com>
Mime-Version: 1.0
References: <20220318193831.482349-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 2/2] KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from
 AArch32
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

The SMCCC does not allow the SMC64 calling convention to be used from
AArch32. While KVM checks to see if the calling convention is allowed in
PSCI_1_0_FN_PSCI_FEATURES, it does not actually prevent calls to
unadvertised PSCI v1.0+ functions.

Check to see if the requested function is allowed from the guest's
execution state. Deny the call if it is not.

Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index cd3ee947485f..0d771468b708 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -318,6 +318,10 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 	if (minor > 1)
 		return -EINVAL;
 
+	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
+	if (val)
+		goto out;
+
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
 		val = minor == 0 ? KVM_ARM_PSCI_1_0 : KVM_ARM_PSCI_1_1;
@@ -378,6 +382,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		return kvm_psci_0_2_call(vcpu);
 	}
 
+out:
 	smccc_set_retval(vcpu, val, 0, 0, 0);
 	return ret;
 }
-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

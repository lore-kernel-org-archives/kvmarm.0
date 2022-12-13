Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AB2C10F31
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35D614B967;
	Mon, 12 Dec 2022 19:17:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pd0QpgNHVFNj; Mon, 12 Dec 2022 19:17:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12AD64B953;
	Mon, 12 Dec 2022 19:17:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26C2E4B93E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zJ1gnKmzS5Wl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:07 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D428D4B955
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:05 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 a5-20020a25af05000000b006e450a5e507so15036835ybh.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=M8gKXPtvSnujkFWzKh+1TE/D8A+unHwbuyURFcPqV7g=;
 b=oikR4k/YvNkMbE/UC5Bzf96qpIJXJtiLGFf80pbar3MbSe9xkR02tPegsy1MzPNRR1
 P/fMWRdmCHGRG+4PJC/RAb6f/NEYb7PQ365rsPpPKl8pDpDF9JnKgjnxoUL5hnPz5Xb6
 yoMSKg+Y0gISjOVsP4kt5i2sv2hP5zRNYjcFA15TS+vJvIu+ap5a/9+DImee/7HjS/Yb
 gs0wlNl86pWuU4fl75bzelkmpLN94j1fUy2W233vaON/4saTKkmge9ChxVbDRExK9IYF
 j5TnBzD4rBnxTOTGDNEtCTlBtPdi3Ztq5EGDj1efhIP6Gb2LPLoX+8LsYHJWr3TQSoEI
 LNWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=M8gKXPtvSnujkFWzKh+1TE/D8A+unHwbuyURFcPqV7g=;
 b=GxyX3d48PnBcWYy2h/bfe0/OPEHJawHivSkQnDecgC0McxDxrVfzGuDNuWWL9pg58/
 7e5zTw2mlDBABD10ZwhYvpMVAOo4wQlwx0S0A0i6bROWk0GsMFmXKnFO46zfPGbD+gkc
 nxAiY2ydf178lATE5dwYRe9YKWWcollpzZuiL5b3S/lY+3oAlyJHee4YOo3SoMKrRcTR
 wqtBSr3UkWkijSBm2vhkHR7kdab7lsbqZWi0xe0aVTIeMOdKm+V0X0DWTAOSbkrSo4b0
 ksq/MZhBOi7bMvgFOQ9sYpHHDo+kpfXPIUsnjZ85W4uFiH299Jkn8y5aujFRDjqIrryD
 PWRA==
X-Gm-Message-State: ANoB5pljDjD5eVbLoZgVNpmr6EuyPISbiOWgs5ayWqlnq8RN8jZwdKng
 mIlk4bnCwz66CtvEXO7slOv7J5taBjg=
X-Google-Smtp-Source: AA0mqf7Q9qI1wDH/dcWjWFM94U57KTqb7jtGhaAh76MhvnBCcz2/FuDXsNQTZH108HtSEVOKNLQckow7PUc=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:50cd:0:b0:707:18f:7226 with SMTP id
 e196-20020a2550cd000000b00707018f7226mr10335955ybb.505.1670890625378; Mon, 12
 Dec 2022 16:17:05 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:44 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-6-seanjc@google.com>
Subject: [PATCH 05/14] KVM: selftests: Fix a typo in x86-64's
 kvm_get_cpu_address_width()
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

Fix a == vs. = typo in kvm_get_cpu_address_width() that results in
@pa_bits being left unset if the CPU doesn't support enumerating its
MAX_PHY_ADDR.  Flagged by clang's unusued-value warning.

lib/x86_64/processor.c:1034:51: warning: expression result unused [-Wunused-value]
                *pa_bits == kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;

Fixes: 3bd396353d18 ("KVM: selftests: Add X86_FEATURE_PAE and use it calc "fallback" MAXPHYADDR")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c4d368d56cfe..acfa1d01e7df 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1031,7 +1031,7 @@ bool is_amd_cpu(void)
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 {
 	if (!kvm_cpu_has_p(X86_PROPERTY_MAX_PHY_ADDR)) {
-		*pa_bits == kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;
+		*pa_bits = kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;
 		*va_bits = 32;
 	} else {
 		*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

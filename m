Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AC115AC
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 00:17:06 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 195-20020a2505cc000000b0071163981d18so14854554ybf.13
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 16:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=rEh5mA6dlWKDCSl7KQ43rCJff6ymQJqEDgcFU+VZQgIxTvOBphONTOByntUTkfmxY3
         XWXjmI7Ye79e9eTEZdAArmcHYjzfL5GnjGD08VL9uBv3peYpVWHlKx3vwQGQzngHCHbI
         GzRQuKjS/sdQGb5pUDZgVuwdxSZO+Pq+tHT0BXBBcwq6Gf8m7/xDQEy8uT8/hhKemi7k
         EVGIotrBmwovilM47BlfXRO/MuJwnlZ8WqOfA14Mz9FxqB0LyjNrziw3g9v0b5tmDEnS
         s9CxysQ+5qGO6T3OqbP6LS7HNh1lX4dMPtsHD1bin6H1+FkLvKKHtiBPWmiS/bFz+DHp
         wIzA==
X-Gm-Message-State: ANoB5pn+B72ZMg4u08fxS0jEpii24q2Tp7iR7cakaunAN1zILJCphgPf
	iOLv1RHfusV6+dM+QTjr3hAOiOwOpgE=
X-Google-Smtp-Source: AA0mqf7Q9qI1wDH/dcWjWFM94U57KTqb7jtGhaAh76MhvnBCcz2/FuDXsNQTZH108HtSEVOKNLQckow7PUc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:50cd:0:b0:707:18f:7226 with SMTP id
 e196-20020a2550cd000000b00707018f7226mr10335955ybb.505.1670890625378; Mon, 12
 Dec 2022 16:17:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Dec 2022 00:16:44 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-6-seanjc@google.com>
Subject: [PATCH 05/14] KVM: selftests: Fix a typo in x86-64's kvm_get_cpu_address_width()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Tom Rix <trix@redhat.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ricardo Koller <ricarkol@google.com>, 
	Sean Christopherson <seanjc@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221213001644.FSJcZI_JpMTRMqlWw8hQ3ITgak14N2nEfTxVPeyvEHE@z>

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


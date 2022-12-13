Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845F115A8
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 00:17:00 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id 67-20020a621946000000b00575f8210320so910991pfz.10
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 16:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=50NFsGS1gSOqQ2w00aLYWRGBkzdJNxkXiT3Fli6/1cM=;
        b=RntXhatCOZ04vpV0zIzdgaGWEbEYWk8Tq2GqIJpFXE4mrCLaeCAJtuH3Pg5qOsSZzA
         1Gqy/YZa0zBtj07ZFJ3tG6JMU4KCwOCm/T5sRILXI0FlH/D3wvVplQBIPjqei4UiNSPI
         a4CMtR25N2guRMk4/FjZQT66KbdmGZvSmJlduBn3hy8nk92rzsUvPrUX7aO4GCwcug4r
         IISJJpierbdfQO0Tx5DjkAG7XdtEDOe0ET8V9SUwuL6ZIfaqYtasTr4PpcRAdWCxFgWs
         Kkr9KxexYZ3AH7JENAv+5XPPnw2pUX56FhSnDCQabgZG3QL18mqbMFLUmMRLOpQWMQ2/
         O29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=50NFsGS1gSOqQ2w00aLYWRGBkzdJNxkXiT3Fli6/1cM=;
        b=m4Q00nHts27BDZIvtZfaL34dXNJ8nFfUA3zxlmhBk+1tTeFT0dGWfM1/eqvgat863W
         BwgJ3VWZA8NbBqG1O74WwFY3CYD2qgvNCn1GPh/GZpdKeKueyPpg/kw+oJa4MO2gyhxp
         kqIbfNkyjdYslWiW0eYhudMGOhYzZwTFoOhxx1dr3hn8l/55HE4vl/lBglJzxnW4usNo
         4NJJU7U0y9IQH67QZHZ8yTvmTWNR3XqhBEj9D6WzRWDVdpCdi+aeNQ2T+NN6bRHvOElT
         k1PvjGf3fX09+LBl10H+igpTefc3W1mvD7D7NHfZHO19ha7iUFA9b8EiHY95UwDO2RUA
         wjog==
X-Gm-Message-State: ANoB5plDADsEZn5i3jd7eIbvmwxa1wYDleO2bO/Fgu1OVZR3BtVdW22Y
	GfVmUOSvR9yyOq4RhPAXioIRdLkh4RU=
X-Google-Smtp-Source: AA0mqf4F87lnfsrUQXXGQjwWJclGxioxHjaqJbg+kPkH4OzPOkmZnoLhZ3jfHM5GA0UKCp57pLd7VyYImGw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2ecb:b0:219:5b3b:2b9f with SMTP id
 h11-20020a17090a2ecb00b002195b3b2b9fmr4271pjs.2.1670890619791; Mon, 12 Dec
 2022 16:16:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Dec 2022 00:16:41 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-3-seanjc@google.com>
Subject: [PATCH 02/14] KVM: selftests: Delete dead code in x86_64/vmx_tsc_adjust_test.c
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
Message-ID: <20221213001641.wL15Yh5mhl5GoCaBINRl2J4y2DLSk1bU7o7i6zGpv8M@z>

Delete an unused struct definition in x86_64/vmx_tsc_adjust_test.c.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index 5943187e8594..ff8ecdf32ae0 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -49,11 +49,6 @@ enum {
 	NUM_VMX_PAGES,
 };
 
-struct kvm_single_msr {
-	struct kvm_msrs header;
-	struct kvm_msr_entry entry;
-} __attribute__((packed));
-
 /* The virtual machine object. */
 static struct kvm_vm *vm;
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog


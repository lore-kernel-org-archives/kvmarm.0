Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7959415A4
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 00:17:02 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id o5-20020a170903210500b0018f9edbba6eso2752637ple.11
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 16:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VfLoNklydv1Rx7BbDoYbdEShyybLFjnrLL1BXeied2s=;
        b=Np8Pq4oyEyyT2NyWGRKhWCpWIKtgc9sp8/et+JS0meGK40iG694E/NYaxXnGXI0TeV
         pAqfSNQC9vcFF79zhXWsirFoGVcn/ax8QgBGxRa1cPYoIDxMNNUz5Jy5AAULOm6SCGAc
         A2EcZLEvvZLS7jcBAxKT7lr/7OJrXxxqMEoWAQweL0OpkQpBF4AL+mTwyhLSigeUVQn6
         9Uvgy3sr74Bmqei662+yAOCZ0l8TL9YTXwynudahz8OX6nc2S0ETlzEpyU5P3RT68+za
         4pvvwlntGLripZEbM1cWf+TCuKTaMguNXMxoTUo9YXqHgb5qZ0Tn/RXjzCP4PZWndVdL
         rjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VfLoNklydv1Rx7BbDoYbdEShyybLFjnrLL1BXeied2s=;
        b=OzJJ74NTK/gnE8F8K7GqeVOkJCQZx9u0j/4q5G9olJZuSMugHCN8mvGclb37BeL22p
         D6rymqFBoD4p2sxyJER7Ug9LvElDelrfBqKINTaAdV3HdMTlOPREwpn02uAiemDN0zdw
         isEV53hxQSrZlBkBrsCnHHDlEiuCfu4QDZgaTFOsyrnJNh4QGMGx7X+sV+OzUt1wndEn
         pl0kK5A8/hxSQdwgxTTO6j/3azLHea1+7RAawhukzv8GqvRbVWPIJcxkbav/2O7hhqF4
         cqbcm+tPozJNa6V0hKnREQvsZDzLQ2lxFq5RVxTTG+CrDQAWCthtVhE63xRm+8GllZBK
         Gt8Q==
X-Gm-Message-State: ANoB5pko1hZmrIvhQ02TaeNgtdANykHfSoTmNKjjTvnDmEmO1S2LTH58
	s/6vV3v9xBGV0sBKC+hmZcNx0s8NWvc=
X-Google-Smtp-Source: AA0mqf7S5eF8bMFJxVX+zccSnQS8wrFbP/BiB/u3t9DV1AwKakqfaO4vcQavHYooXhlu853wx6mxrrDMel4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1010:b0:219:1d0a:34a6 with SMTP id
 gm16-20020a17090b101000b002191d0a34a6mr4049pjb.1.1670890621685; Mon, 12 Dec
 2022 16:17:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Dec 2022 00:16:42 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-4-seanjc@google.com>
Subject: [PATCH 03/14] KVM: selftests: Fix divide-by-zero bug in memslot_perf_test
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
Message-ID: <20221213001642.9L6xDikVqoyTXbVqWssDRlcsptlcjNoJfXMSGqv7afs@z>

Check that the number of pages per slot is non-zero in get_max_slots()
prior to computing the remaining number of pages.  clang generates code
that uses an actual DIV for calculating the remaining, which causes a #DE
if the total number of pages is less than the number of slots.

  traps: memslot_perf_te[97611] trap divide error ip:4030c4 sp:7ffd18ae58f0
         error:0 in memslot_perf_test[401000+cb000]

Fixes: a69170c65acd ("KVM: selftests: memslot_perf_test: Report optimal memory slots")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e698306bf49d..e6587e193490 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -265,6 +265,9 @@ static uint64_t get_max_slots(struct vm_data *data, uint32_t host_page_size)
 	slots = data->nslots;
 	while (--slots > 1) {
 		pages_per_slot = mempages / slots;
+		if (!pages_per_slot)
+			continue;
+
 		rempages = mempages % pages_per_slot;
 		if (check_slot_pages(host_page_size, guest_page_size,
 				     pages_per_slot, rempages))
-- 
2.39.0.rc1.256.g54fd8350bd-goog


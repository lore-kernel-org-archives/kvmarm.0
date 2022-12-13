Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E372C15A4
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 00:17:15 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id x21-20020a62fb15000000b0057451601be4so881624pfm.19
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 16:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nM41DSVBAJr+S3W93Zis4JAYC8eUvXamzXgPZLD06L8=;
        b=nYe6ZWOHPMJgTGksZPiEisBf6HPHtTh7LwnzxBJxPqoYHxDIXfUXIa80Wv8FT5deaA
         UzHNYFP0DWaotAozDYEqkVOhGC3cJzSjZIrX35uJMvKk0qzEdjbF5qj55iPpjtEz3ipO
         bm8VP2buvMYoUm5bBSsgzK0AvSdBMq0gU3WwNjXiGhrTir7XSUZ3UlUPkv2SzjZJXHyV
         BW7oqPIg9/2WzHp2xjLzs82Y3ewdbcwG+wxaYmUKR44YKrwYEmcWRcUYbv914+1ep3vj
         XM381ihLSB7s6K13WjVWXGmod93EwbDCFi3RC00C/qqJJxPj4hbmeVdBA7F4fDCsvIiB
         q4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nM41DSVBAJr+S3W93Zis4JAYC8eUvXamzXgPZLD06L8=;
        b=GV2giNFWhmpxfBFky2lVg+2PGkExQsIWQKH+1A/tYVL6/XAn/bokBfGMFdmU8R2nkz
         peOiDFZWhzmOstz+FBnqjTaDFAmKrhI3EnPKwfwlJAdegFcoKnexvvT+QDXjwBH6SYTg
         TKF18yB61NtvZzmcKD+IiVCiUY7WOZzoaghs+k7cV8araRYSh0qDQ/iprJ7EOZWRnz/d
         7/7h8X/264+/iMYgvZGnB09LrB4GnY4/YgoVUf4gfUgr/mje9AWxA/smVrGHxo3P2SHd
         +yoW4/l24HAVTqpm5k0WWIcdVEdR9ebXQCAv68fGyvlkKiHZXIj2QwrseTZjVXK9d7gQ
         JLug==
X-Gm-Message-State: ANoB5pnrXyy8BOcNUYbxJ7BvESHSzlppXpyvo8c/QVwEFUuZK/+alhdt
	hfl/JpFFfZCppSAcfBABRZvOUT9TgDw=
X-Google-Smtp-Source: AA0mqf6ZbJmcYrZNpc/Z0ppwmhrlHhb+cLSNTmH678oSo0UQF9b8LuTc9fdveE6JT7fYmZu7x1S++6s+7UY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c406:b0:189:6df9:4f85 with SMTP id
 k6-20020a170902c40600b001896df94f85mr62591897plk.27.1670890635443; Mon, 12
 Dec 2022 16:17:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Dec 2022 00:16:50 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-12-seanjc@google.com>
Subject: [PATCH 11/14] KVM: selftests: Disable "gnu-variable-sized-type-not-at-end"
 warning
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
Message-ID: <20221213001650.JbY8fZCO12Ys0rTatpZ_6q_mo-lcrtcC_TRxBZcgxLE@z>

Disable gnu-variable-sized-type-not-at-end so that tests and libraries
can create overlays of variable sized arrays at the end of structs when
using a fixed number of entries, e.g. to get/set a single MSR.

It's possible to fudge around the warning, e.g. by defining a custom
struct that hardcodes the number of entries, but that is a burden for
both developers and readers of the code.

lib/x86_64/processor.c:664:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct kvm_msrs header;
                                ^
lib/x86_64/processor.c:772:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct kvm_msrs header;
                                ^
lib/x86_64/processor.c:787:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct kvm_msrs header;
                                ^
3 warnings generated.

x86_64/hyperv_tlb_flush.c:54:18: warning: field 'hv_vp_set' with variable sized type 'struct hv_vpset'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
        struct hv_vpset hv_vp_set;
                        ^
1 warning generated.

x86_64/xen_shinfo_test.c:137:25: warning: field 'info' with variable sized type 'struct kvm_irq_routing'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
        struct kvm_irq_routing info;
                               ^
1 warning generated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 2487db21b177..9cff99a1cb2e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -196,6 +196,7 @@ else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
+	-Wno-gnu-variable-sized-type-not-at-end \
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-- 
2.39.0.rc1.256.g54fd8350bd-goog


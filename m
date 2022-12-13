Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A492BC00145
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BDF54B944;
	Mon, 12 Dec 2022 19:17:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Eb17revPhA2; Mon, 12 Dec 2022 19:17:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 759C64B938;
	Mon, 12 Dec 2022 19:17:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C664B93C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wMNKKy--bCdk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:00 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B6644B939
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:16:59 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 p17-20020a056a0026d100b005769067d113so921929pfw.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=DOvY7w0rRl2MxDLB0k3o2yUeh+erpcmsWDFuA702T6s=;
 b=l9bHJR0oKKynBT27/jXjQ30QimwweOaqtl3QWSLCU6FiFSKCA3rrt+E957wr1zpBhD
 p4waCGA7XG6QFQxmIYOYBakT8OP8vBme+ryoiFdvRCbt7Q2ZtXp4RLmkXlcugdy8NM6J
 MYhNQigzo87mMoFsVV3kq1X4lwNDqM8YgTEc4/zV1HBrccTtlep12cAiKHftvJ9PO0k2
 dGucFeV2hflrJde6Dcxo9dBUuMVUPRQOUE5HkYqU6f8H7eZCPwsf2UIaBzMv3IzDH+uX
 QKFy0hRnovAJqXB4b5KB6Lo+KRVs0lKzNC9qMNzoduiGQCZghvBOB/ql+Wco/Cgp8R+b
 el5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=DOvY7w0rRl2MxDLB0k3o2yUeh+erpcmsWDFuA702T6s=;
 b=Z3GdSTGbmG7S3gleJrwEPkK2VuX8qtccjWKNBXMYIxRywEZNsLNKdI7oBU8Ahe1/uz
 lGQeKieYQJ7MZt/vLp1lmiFOfd4MaDlnE2trmN8gmFfxh7z8dmRrx5kSRiZgANfqQ0vx
 Rjp2ZfWqf7CYfwEKPOhrUn8ewzi438mJws3ABXsuN/ZtFUvHHgb5L1c0IdyRHT3S4Xcj
 6uFSZUCRUqBE6OzgHRiqKbqBWCE33PLRhSSRHuBvANiOrVLXRrxBJ/1qaWU92ZTcYOrb
 Dljici2YRZouEi/QZ7K4DT4KYm6giNlYj4017nh6Uki3aTtCuUZ9A+3w4rH/K+7C2rZw
 sFUA==
X-Gm-Message-State: ANoB5pkquIWT0/Bauk1D97zFCqr3z3tzUGNrBA9mYWtQbZR9Elv2jmm2
 n/O6Uvaq8oa6YBYoNzGBbyXMqLRBu1U=
X-Google-Smtp-Source: AA0mqf4hBxtcZbd9UejO8wqEoLXBgUBqlQprFxOUH1fTAJDZ9Y1ut6pSZnFL0fRAkhQQsou2JfJD4SuBkEo=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9629:0:b0:576:8cdd:3f26 with SMTP id
 r9-20020aa79629000000b005768cdd3f26mr26606972pfg.59.1670890618334; Mon, 12
 Dec 2022 16:16:58 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:40 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-2-seanjc@google.com>
Subject: [PATCH 01/14] KVM: selftests: Define literal to asm constraint in
 aarch64 as unsigned long
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

Define a literal '0' asm input constraint to aarch64/page_fault_test's
guest_cas() as an unsigned long to make clang happy.

  tools/testing/selftests/kvm/aarch64/page_fault_test.c:120:16: error:
    value size does not match register size specified by the constraint
    and modifier [-Werror,-Wasm-operand-widths]
                       :: "r" (0), "r" (TEST_DATA), "r" (guest_test_memory));
                               ^
  tools/testing/selftests/kvm/aarch64/page_fault_test.c:119:15: note:
    use constraint modifier "w"
                       "casal %0, %1, [%2]\n"
                              ^~
                              %w0

Fixes: 35c581015712 ("KVM: selftests: aarch64: Add aarch64/page_fault_test")
Cc: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 95d22cfb7b41..beb944fa6fd4 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -117,7 +117,7 @@ static void guest_cas(void)
 	GUEST_ASSERT(guest_check_lse());
 	asm volatile(".arch_extension lse\n"
 		     "casal %0, %1, [%2]\n"
-		     :: "r" (0), "r" (TEST_DATA), "r" (guest_test_memory));
+		     :: "r" (0ul), "r" (TEST_DATA), "r" (guest_test_memory));
 	val = READ_ONCE(*guest_test_memory);
 	GUEST_ASSERT_EQ(val, TEST_DATA);
 }
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E442C00145
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 193594B943;
	Mon, 12 Dec 2022 19:17:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hpsj9DfOeajM; Mon, 12 Dec 2022 19:17:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FB7E4B96A;
	Mon, 12 Dec 2022 19:17:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D9C54B942
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F470zx10YeKW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:11 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34CAC4B966
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:11 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 cp23-20020a056a00349700b005775c52dbceso883109pfb.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=BpGd55nvKBNj0D/PIzME9gJqn/VBcBhffWATlQcE3Ss=;
 b=MGEbvBziCbhDXrzsRWJnhVDajcYBqH32IEoBgzIYBxRLKK4UKIXh6EcKFK5drrmpEA
 8MEpB2G2jJTC+KB8i8pUeFzabhMjuQrp51rHwAi9WxEkwVgMHq+hx6z1qCeb15tkk+/A
 xfO5l3wFXdCOVXkW9mIm6QIGoiMAxwFy5PqTjEG0lrociwfpJRcZuZCVQ4i6Dbk8e5Nz
 RN09Y8fL8D8Z9FfEVzlTciMOkDUqLCiIJjIPFMWWORLTDCS/wKvw2Usdvvi8wmeo9k3u
 WO7xbVQMKylVOulYnz+qg960NwHouXr7kHgcgEzUSk6QbZe3TdXOp/0yG8ARDmW0T2N0
 gIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=BpGd55nvKBNj0D/PIzME9gJqn/VBcBhffWATlQcE3Ss=;
 b=XiHgco/gWCqBgZYOJzBn2iBLaiLDoSIaZwJ7gWtpqycF/M8kgVYRXp1VGNzVqGkauE
 Bd6b7goSmKNxlPIglLfhaV2gEmv2kVUIxgLyVkrX+yBV3AislbodW39xiTKkIwElDRUo
 v5MxaJe4kEkNnQNuiDkJDQK94FaDBbdkdB1qrhfU5ib2C/0XDKBn+NU3P+rP6OdRFGq7
 AFVp9zMOd+fzukNR0hYZBvibOw26WzE8FQ0LeP8t2ZOY1I2Joj+Pyuh+o0cXr3IOwr0O
 h5de0Ev+ODteEMu2W5eceyfTS16dp8tzfIQz6Dnhx/1/lv8oBDHIIl3do6A0eJymXQzF
 VXYg==
X-Gm-Message-State: ANoB5pmwpk7bBOdnxeSNwlTCOfyyU5jCO/580WGpuc8L1g9MlcXeIdmA
 w/Tk9wWEQK2ZtdqKTrgs4Kea7wus2y4=
X-Google-Smtp-Source: AA0mqf7+dfd4rJNWoSbVdf58/T9pAFs7MpojsQi0gxbLVrmPbLQZm00Z8l7OQhKT1zAZsx9O/p+kfPEMGQc=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1010:b0:219:1d0a:34a6 with SMTP id
 gm16-20020a17090b101000b002191d0a34a6mr4054pjb.1.1670890630136; Mon, 12 Dec
 2022 16:17:10 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:47 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-9-seanjc@google.com>
Subject: [PATCH 08/14] KVM: selftests: Probe -no-pie with actual CFLAGS used
 to compile
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

Probe -no-pie with the actual set of CFLAGS used to compile the tests,
clang whines about -no-pie being unused if the tests are compiled with
-static.

  clang: warning: argument unused during compilation: '-no-pie'
  [-Wunused-command-line-argument]

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c22c3002492d..a6050dcc381a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -197,7 +197,7 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	$(KHDR_INCLUDES)
 
 no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
-        $(CC) -Werror -no-pie -x c - -o "$$TMP", -no-pie)
+        $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
 
 # On s390, build the testcases KVM-enabled
 pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

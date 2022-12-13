Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E6F15A4
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 00:17:10 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id g1-20020a636b01000000b00479222d9875so6005689pgc.12
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 16:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=GEgj8GGMDnFBd0bmy3eSmfj2Ufz1/Mi0fMZxcrNEAAB0I4KlBI02HLE24SMqy9wyZr
         2ugDYUuniZwumgVijxhOTESzFGjHFB2VRBgCUd7XLBwAVftaM+jpShMdldFjS021cyZQ
         bsA1b/inXSYQ+sO/fwybeIFBZo/vj78Wlp/0ALsqSjL8UgK8uuV2pyK0pQeALPUg6jeX
         LhmQQfoNiOk4JW7vmKiUO4GwUs6ASfQe0YxhSds/GCs94Nlzm6kOC8JFYNIdzzJc6+Aa
         SBgiGdmc0bx4GQIyoZKk6R/Je5sJ0JbwhlS1AI0lVmmYniSuGSX0AhhD2+SM/CVLx5oO
         oR+w==
X-Gm-Message-State: ANoB5plva+UFY6/EUZapMIC6NTr33WcnS3W+UYlfpWuyfUMhPfOC47m3
	/R4Pq5KcIuy+w08jkS3ZqmXu5XZXqyc=
X-Google-Smtp-Source: AA0mqf7+dfd4rJNWoSbVdf58/T9pAFs7MpojsQi0gxbLVrmPbLQZm00Z8l7OQhKT1zAZsx9O/p+kfPEMGQc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1010:b0:219:1d0a:34a6 with SMTP id
 gm16-20020a17090b101000b002191d0a34a6mr4054pjb.1.1670890630136; Mon, 12 Dec
 2022 16:17:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Dec 2022 00:16:47 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
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
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Tom Rix <trix@redhat.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ricardo Koller <ricarkol@google.com>, 
	Sean Christopherson <seanjc@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221213001647.SxQEa8IyH5AKfl49hWEhWOGJsU9croRPyy1ScKgtjY8@z>

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


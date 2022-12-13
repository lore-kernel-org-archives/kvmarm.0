Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BDC15A9
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 00:17:09 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-36810cfa61fso149224587b3.6
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 16:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dh9OV8WXLZqVkS0eTF+TxxkJJsKrkd0m2OX0yvUCB3o=;
        b=sw5AF+UJzrAam2lKYUO+DY3lJy12wG52jO14k7mzCjLcxxLIwp1wBpj6wVqYtqBXVF
         59vS4E7gW4naKYM6Hk7aGKYpNTStZA8AyeHKiS1Zp63lxywrCOInD4USN6MkBgBw4NoX
         eN2lxEjW9PEtkdVREzFNueicrHCc0exuvCAPIMk3YVVS7eklH+VcuXQPTh0ZS9Sd5LX8
         cGWE/0zqnV0g/j784hDl74HTeHWiysY9ZLAx8E3jTWdl+pYwXeHcFR4+9h/Mt74o1u5K
         B3cgL2TWXr+P5NwxWcePS55Ar3q2GV+q43pv8aj7jsOs55kDdd5RUw2jebRRAKHKGp8g
         1SMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dh9OV8WXLZqVkS0eTF+TxxkJJsKrkd0m2OX0yvUCB3o=;
        b=lAjIYQtNwE1RVLDpBwBKEr3NaXTf+em/hSZXELjQK/67/PeIRF9D6kOMw9lB/KJ1Av
         lgJPLPeWcm/rbmhmzGdKpEa+ZPM0NmxWqB4yzgjyX3yjO8+bPXwylEjnisQggu/E/oTN
         uyyM0GJ+jJns5U9RqKRo3OK+8F7v9CobUEuMWIsnptTwGXw0XStSbN8mVBpwZzM0GgRa
         Ni3BKq7CoN+mOm1wFixFnW94ekvlNy7O0pY/rN79IupBjfG1Nm0tT5swdecxuJCrPQ/c
         TGRYbtQgAB85kR+wlC0JRmnCspvSlWs7BFAhKwlXaYJpz3cuV92+vvSH7LrR0r083cVM
         Frww==
X-Gm-Message-State: ANoB5pmRdYR4o/Wfrd2rZEhy1YYCesiKE/112dJ1oydMMXwOj42IqmdN
	Ls6xm3y/28onFYXMeSdR17mfDVLH4v4=
X-Google-Smtp-Source: AA0mqf6PAlQug9BZraIHZdHpqKIVbXCcKOa0uk6qj29geZVqkrX39aClmamGhM5+3qzba2DS0aZNeAJ6gmU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ca0f:0:b0:38f:fa8e:99da with SMTP id
 m15-20020a0dca0f000000b0038ffa8e99damr12937224ywd.355.1670890628580; Mon, 12
 Dec 2022 16:17:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Dec 2022 00:16:46 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-8-seanjc@google.com>
Subject: [PATCH 07/14] KVM: selftests: Use proper function prototypes in
 probing code
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
Content-Transfer-Encoding: quoted-printable
Message-ID: <20221213001646.NTtYip1D3tXh2Oyr99HR0Qqs4LGoyBejT1mmU3eAr0Y@z>

Make the main() functions in the probing code proper prototypes so that
compiling the probing code with more strict flags won't generate false
negatives.

  <stdin>:1:5: error: function declaration isn=E2=80=99t a prototype [-Werr=
or=3Dstrict-prototypes]

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests=
/kvm/Makefile
index d761a77c3a80..c22c3002492d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -196,11 +196,11 @@ CFLAGS +=3D -Wall -Wstrict-prototypes -Wuninitialized=
 -O2 -g -std=3Dgnu99 \
 	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
 	$(KHDR_INCLUDES)
=20
-no-pie-option :=3D $(call try-run, echo 'int main() { return 0; }' | \
+no-pie-option :=3D $(call try-run, echo 'int main(void) { return 0; }' | \
         $(CC) -Werror -no-pie -x c - -o "$$TMP", -no-pie)
=20
 # On s390, build the testcases KVM-enabled
-pgste-option =3D $(call try-run, echo 'int main() { return 0; }' | \
+pgste-option =3D $(call try-run, echo 'int main(void) { return 0; }' | \
 	$(CC) -Werror -Wl$(comma)--s390-pgste -x c - -o "$$TMP",-Wl$(comma)--s390=
-pgste)
=20
 LDLIBS +=3D -ldl
--=20
2.39.0.rc1.256.g54fd8350bd-goog


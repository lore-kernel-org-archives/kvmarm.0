Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DE6125AC
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 15:20:08 +0000 (UTC)
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3176fe7b67bso1214870f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 08:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691767206; x=1692372006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qzePDYsycDhwr+IPrP4iKR8Awa/mk+LR9zGcfd9N2nE=;
        b=10PLZEHNHZ/ExNrV42MYDUP99UuAAVIdy55Hd7YOK/eHnLYUUyD7ve7NVrw3aO7CdM
         vWBMzbvzxgWLvhVnsphCgW8uohRzzBKAodzg63mpNv0kfIkeiZhzoClaIzj97HkkS2Lk
         iWbjWQuFhnLq9DvRa0wtjNDCeDyfnyv3WoXyhIp3GxwuB1sI2t8kz0UMxWfEap/n9djV
         /2cFEaEyzZxFkmBILF8aLsRKpkWrBu5Qa7Kzirz5w+TLtlCFMR/ay5oYyb0D9TOYaB/e
         ChrcClwsZwB85k4HDOSrHQdLnMpxjk/mslXOBnCi9KYIp7Vyxg9rq0If0NYuQ7ExjM+8
         kQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691767206; x=1692372006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qzePDYsycDhwr+IPrP4iKR8Awa/mk+LR9zGcfd9N2nE=;
        b=CVHBO4AVZHSgbDgj8T4fXctfcjPGNISJ7oZrV3ULRh3lCLgpZth3yDAnKXpnhgZ7V/
         a80XvSY5CF9/ImGZ7FHRLANhZViw6jYUlGSSOUN6tTVNFmkAPO9QCsS0US3+aXLJtl/X
         7DrtNA7PRInFHQdD6t+WPxY0Mcn05KC8Ce9iunjdjE4GYdo/vF4XEB3Xx99/2wJ2AHBL
         q0k0hOoz0y40UIlGoTBeswmdwCuCUmWX1SH07N4gvK+7f7jtX6I2Kidw9RMmLMvD9F8m
         bWRWi8jvA2uK9hSLFxMNP/NcRlr5WAz08FCazsBX0ptI4dU+HDbGpMU8Yc0gegPyLuc8
         9eDQ==
X-Gm-Message-State: AOJu0Yw9caOeAwc4lk3yDkzeD+WhwTT/OD+1N0LnIhPnMYPvoCs3T4mY
	c4T9oYoUC7BKtd+pCfHo9cRW8eGlkw==
X-Google-Smtp-Source: AGHT+IEGl+QWst925OBey2b/n22pg/pEC+s7Iu4Jwd9U6CEcZriGyM4oqqfEappi55i2VjBAWfl0++It4g==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:8dc0:5176:6fda:46a0])
 (user=elver job=sendgmr) by 2002:a05:6000:1819:b0:317:41be:d871 with SMTP id
 m25-20020a056000181900b0031741bed871mr16440wrh.14.1691767206297; Fri, 11 Aug
 2023 08:20:06 -0700 (PDT)
Date: Fri, 11 Aug 2023 17:18:41 +0200
In-Reply-To: <20230811151847.1594958-1-elver@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811151847.1594958-1-elver@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230811151847.1594958-4-elver@google.com>
Subject: [PATCH v4 4/4] hardening: Move BUG_ON_DATA_CORRUPTION to hardening options
From: Marco Elver <elver@google.com>
To: elver@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	llvm@lists.linux.dev, Dmitry Vyukov <dvyukov@google.com>, 
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

BUG_ON_DATA_CORRUPTION is turning detected corruptions of list data
structures from WARNings into BUGs. This can be useful to stop further
corruptions or even exploitation attempts.

However, the option has less to do with debugging than with hardening.
With the introduction of LIST_HARDENED, it makes more sense to move it
to the hardening options, where it selects LIST_HARDENED instead.

Without this change, combining BUG_ON_DATA_CORRUPTION with LIST_HARDENED
alone wouldn't be possible, because DEBUG_LIST would always be selected
by BUG_ON_DATA_CORRUPTION.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* New patch, after LIST_HARDENED was made independent of DEBUG_LIST, and
  now DEBUG_LIST depends on LIST_HARDENED.
---
 lib/Kconfig.debug          | 12 +-----------
 security/Kconfig.hardening | 10 ++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c38745ad46eb..c7348d1fabe5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1673,7 +1673,7 @@ menu "Debug kernel data structures"
 
 config DEBUG_LIST
 	bool "Debug linked list manipulation"
-	depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
+	depends on DEBUG_KERNEL
 	select LIST_HARDENED
 	help
 	  Enable this to turn on extended checks in the linked-list walking
@@ -1715,16 +1715,6 @@ config DEBUG_NOTIFIERS
 	  This is a relatively cheap check but if you care about maximum
 	  performance, say N.
 
-config BUG_ON_DATA_CORRUPTION
-	bool "Trigger a BUG when data corruption is detected"
-	select DEBUG_LIST
-	help
-	  Select this option if the kernel should BUG when it encounters
-	  data corruption in kernel memory structures when they get checked
-	  for validity.
-
-	  If unsure, say N.
-
 config DEBUG_MAPLE_TREE
 	bool "Debug maple trees"
 	depends on DEBUG_KERNEL
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index ffc3c702b461..2cff851ebfd7 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -290,6 +290,16 @@ config LIST_HARDENED
 
 	  If unsure, say N.
 
+config BUG_ON_DATA_CORRUPTION
+	bool "Trigger a BUG when data corruption is detected"
+	select LIST_HARDENED
+	help
+	  Select this option if the kernel should BUG when it encounters
+	  data corruption in kernel memory structures when they get checked
+	  for validity.
+
+	  If unsure, say N.
+
 endmenu
 
 config CC_HAS_RANDSTRUCT
-- 
2.41.0.694.ge786442a9b-goog


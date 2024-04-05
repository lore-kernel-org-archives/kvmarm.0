Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0E113D265
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307677; cv=none; b=ZgBXb7ztYa4vfQkCaWbCvOGwHz5VekdhYNIS7CTifZJwWoYHLpNYjwm1lKDucs/FnBESB3kSoNuLFvLBbgjgPhPgZvN1nEfSreWbopneo3YS6Mozd+AysqM1L3eYKLz7N1lBDg5J4hjBN7OHfvRnQss/UFXIZtdph98S+lKVE0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307677; c=relaxed/simple;
	bh=hU5DyQmB+0+LzoAbBVPYnqv0ir777ARq0XXH0tjCyAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fDY8bTjb1+mr2EdJhU7lT/dHV8TOqmZyo6JIAV0cGBz7S7wk7tHkRo/7NPDzjRPoExPsPAidXHq4O89PIFIGos8B8ZrQvWjFOjlQrskvQfJIn+mEHHzeqiPbswvt86udC/dMamdrUJC/m/ijHvGnd9zqL0QQsbqqADD4SecRals=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gUvGr9Di; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gUvGr9Di"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e74aa08d15so1506422b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307675; x=1712912475; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9O2yN202NqTro1AvvJbZu3/0EjKIcT0nZopuJ7bwyA=;
        b=gUvGr9DiYlqJjVG7leXK+7ZDVkII9BA7MUDPvMdIk714UuY7QnDESd8V4rGlqYIgnx
         J+H+HAt7oGcInVGTZe3Ci8LO/Wew0WGmg4mxmlWLs/8KhSt0ssZflIlku5nveeNLjClY
         Mj0fnG48bTK2cKnTDEbOC9UD5bjdcSY2GxDHbyuWjc2wJWe9nG/MHdVZrA4KBZoGYkut
         mD9WZsRwYGT80IlXxUThymKbH8BlA/Lg34lK2yP+/sOi5ZnSpbt3K84Nf35tqnuPEgvT
         6V766bO/txO0eRPlMOtl4zjEM5Phh4/XKwXQWKIYsQGLm5bCLJz7GjPsziKHb5xeqaIg
         TPgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307675; x=1712912475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q9O2yN202NqTro1AvvJbZu3/0EjKIcT0nZopuJ7bwyA=;
        b=hUCZpzaxaKXlempcOr60x3NiSRApDupSjh+5muTVgodNvw98wr0+4vYYjbFEDjXK/Y
         Eysi0BwKpb79YbTszQbBi/VP0evlgF3fvm9pG5F1k5Zb+zdOMlkJL00PmeOBhQvhOHHZ
         8zHD2F+HHTQRwE4x+Xbyday1Y13rYXld6ZZJtmwuXzpCncoKq63B+7U+4b+POsunbHXC
         i0JVNyFZVUbUtpGb7fLz5akel6+v9rM7dWPGLsj5Yi7k2ittYQQ7Eh6fTX7B/fNKUkvf
         D5g74nUtixhv3hu1LHElRuGa4UV1058g31zA6caYrtcbbfnUghQ8/BF+eh8QjPorQ4Aw
         0rpA==
X-Forwarded-Encrypted: i=1; AJvYcCUjLeuxOSqeTsp31buj46YYqj4Z0ZTfNpA6rqjFgBbEpH4VnpkggEVcg2ynAQVyKU43/WDNa/B8viWBjMFpOHxGBcXoruyB
X-Gm-Message-State: AOJu0YwvycFIqt79d8cxC+8vNsBtR+EDeQeW6TAkclZsvWPJY+13bybD
	NAeYd8SroFmg7/PHcArfVbMqAX5orLihrVWjSeR7VWd5S0rhXI4n
X-Google-Smtp-Source: AGHT+IG3iGQczT0lBc6+U4GYfzX73yWnuYF+Xus3bRqqURm/CLDRZv9h0qLlh8Hdhn5oQL0ovQ4TZg==
X-Received: by 2002:a05:6a20:9494:b0:1a7:30ce:4261 with SMTP id hs20-20020a056a20949400b001a730ce4261mr906687pzb.24.1712307675161;
        Fri, 05 Apr 2024 02:01:15 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:14 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 01/17] Add initial shellcheck checking
Date: Fri,  5 Apr 2024 19:00:33 +1000
Message-ID: <20240405090052.375599-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This adds a basic shellcheck sytle file, some directives to help
find scripts, and a make shellcheck target.

When changes settle down this could be made part of the standard
build / CI flow.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .shellcheckrc       | 32 ++++++++++++++++++++++++++++++++
 Makefile            |  4 ++++
 README.md           |  2 ++
 scripts/common.bash |  5 ++++-
 4 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 .shellcheckrc

diff --git a/.shellcheckrc b/.shellcheckrc
new file mode 100644
index 000000000..2a9a57c42
--- /dev/null
+++ b/.shellcheckrc
@@ -0,0 +1,32 @@
+# shellcheck configuration file
+external-sources=true
+
+# Optional extras --  https://www.shellcheck.net/wiki/Optional
+# Possibilities, e.g., -
+# quote‐safe‐variables
+# require-double-brackets
+# require-variable-braces
+# add-default-case
+
+# Disable SC2004 style? I.e.,
+# In run_tests.sh line 67:
+#            if (( $unittest_run_queues <= 0 )); then
+#                  ^------------------^ SC2004 (style): $/${} is unnecessary on arithmetic variables.
+disable=SC2004
+
+# Disable SC2034 - config.mak contains a lot of these unused variable errors.
+# Maybe we could have a script extract the ones used by shell script and put
+# them in a generated file, to re-enable the warning.
+#
+# In config.mak line 1:
+# SRCDIR=/home/npiggin/src/kvm-unit-tests
+# ^----^ SC2034 (warning): SRCDIR appears unused. Verify use (or export if used externally).
+disable=SC2034
+
+# Disable SC2086 for now, double quote to prevent globbing and word
+# splitting. There are lots of places that use it for word splitting
+# (e.g., invoking commands with arguments) that break. Should have a
+# more consistent approach for this (perhaps use arrays for such cases)
+# but for now disable.
+# SC2086 (info): Double quote to prevent globbing and word splitting.
+disable=SC2086
diff --git a/Makefile b/Makefile
index 4e0f54543..4863cfdc6 100644
--- a/Makefile
+++ b/Makefile
@@ -141,6 +141,10 @@ cscope:
 		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
 	cscope -bk
 
+.PHONY: shellcheck
+shellcheck:
+	shellcheck -a run_tests.sh */run */efi/run scripts/mkstandalone.sh
+
 .PHONY: tags
 tags:
 	ctags -R
diff --git a/README.md b/README.md
index 6e82dc225..77718675e 100644
--- a/README.md
+++ b/README.md
@@ -193,3 +193,5 @@ with `git config diff.orderFile scripts/git.difforder` enables it.
 
 We strive to follow the Linux kernels coding style so it's recommended
 to run the kernel's ./scripts/checkpatch.pl on new patches.
+
+Also run make shellcheck before submitting a patch.
diff --git a/scripts/common.bash b/scripts/common.bash
index ee1dd8659..3aa557c8c 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -82,8 +82,11 @@ function arch_cmd()
 }
 
 # The current file has to be the only file sourcing the arch helper
-# file
+# file. Shellcheck can't follow this so help it out. There doesn't appear to be a
+# way to specify multiple alternatives, so we will have to rethink this if things
+# get more complicated.
 ARCH_FUNC=scripts/${ARCH}/func.bash
 if [ -f "${ARCH_FUNC}" ]; then
+# shellcheck source=scripts/s390x/func.bash
 	source "${ARCH_FUNC}"
 fi
-- 
2.43.0


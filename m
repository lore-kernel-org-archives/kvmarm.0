Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A9E2CCA0
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407142; cv=none; b=igc9hO3xGdK+oaZg/mLixIQkvdxYXOwtRMS9LeGLHY80ScTvIBCz1v/1+rAbbMSGeEChFxyuj3svQ4WW/Jv7XcpmC9e6CPZYWnlC3ESwh8WSK/byU08S2tLhC4FHKEx7VFSRs/wtdZ+n1/5HXl0muTqncbV1f6L+jhsQcEa2F4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407142; c=relaxed/simple;
	bh=fQCsq+sZAe6QlgWYF8/YRGqIoB5/+pyiNJbHQETHeX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gc9WsDH6oOjNjECDMS7Wl7Ht6pN7aZ/tgTpVlsE2MwlNpqa+RVQY5uPg/F8ov3rjc91ooMzN3tW4qWJlUqU13PXmV5jVuvtis0ti4udwh8xwjA6XBtn4QxC6wtBw4ciLAvj6P7GSfTw/BRCZhh9dHckL1rM50RU+/lwLfz0OxpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KRCyC6Tk; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRCyC6Tk"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5dca1efad59so2267361a12.2
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407140; x=1713011940; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbXS3mPbclefehTNkJZ/z/tUSWiPiMKoUzf34+kT7OI=;
        b=KRCyC6TkB0f93jwuO79DP5MXl6aT4TKDgxC5AjwAwnZvwEXj+FW4LpTsLzoV7Cv56N
         fxAAeXwCOwLjzjIcAZDkJh5a3WajGkx9mehTnjfyQQpEi1dJ+45SVLnlaAxiFV807gwL
         /D9/bW2CrIuq9Bn3IALI0vUA2UA+ikL6ngfjq8fwqRxTOtJncTbSHXIL+3xUC0AakBId
         1HMldKMV1g/EUlI2eHXXjR4jr64u1W3eUS2yV/CjWpCSKJgxJ/Ev3BdoklOM0MZN6Rht
         +f//stPAcgMdiU6Ba9xL9G9QaMG0gsI0+4FTwm4OVvbcSVvdHxLgcuL/iqHltedMjALw
         ECpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407140; x=1713011940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IbXS3mPbclefehTNkJZ/z/tUSWiPiMKoUzf34+kT7OI=;
        b=CkcVlBPYPQn0Sh7N3Iw5agK5YR3YMKO9SQVpC2S1GHDkk0NCB/Dy3KF7aqtbj0EsGR
         Ecv1jwnjP8CM0LfEcZMbd+88a2SzNaq/4al4SxZE04rgYjcEm7rJU6RXClWhOsr3E2AI
         AlPo3DOHNQeZBc+imNfjoBJtdOwVa4xo+yik4LA1z/uQnD1kWp4ONLQfkSUdcW5IHrjZ
         l+nF9vB21B+T1XgKk+P2GJPUSVx7Rf0gG9eH++6JVeqxVpPIxm14nfWMDcdUl6nK/aIn
         P8r7ddLthnzorLvD6el9RnPJYo3cB5cz2A9r3TRT6DcskqlejIKvkFgXZXwF4Y6tqoQc
         /6QQ==
X-Forwarded-Encrypted: i=1; AJvYcCW40rV4Q/tvBoW+xhwWeqv2M644I1E0awVk5sO9E/nagr82wEUfetcXND3Lrrxd7o6oj1kWGHdZxyf4YtWLwGQCvymwC/18
X-Gm-Message-State: AOJu0YzAEE4jQMRQG4y1Q13mSAHEggp1I2zl8UtycDBCDfH61x11Dhuk
	2XomCi5RrLiq0iPB+PkMyFvVcHxDMBDc/bg3PMZXvkuHxoYOD86k
X-Google-Smtp-Source: AGHT+IGZuRmyUSURkYq7nO4hW7JRTEzJugpaiD6OSQX4jAsuLRrinwKGCqQjaKwfezP4e8hM/R6shA==
X-Received: by 2002:a17:90b:3795:b0:2a2:53ee:bd08 with SMTP id mz21-20020a17090b379500b002a253eebd08mr3514004pjb.8.1712407140290;
        Sat, 06 Apr 2024 05:39:00 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:38:59 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 01/14] Add initial shellcheck checking
Date: Sat,  6 Apr 2024 22:38:10 +1000
Message-ID: <20240406123833.406488-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
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
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .shellcheckrc       | 30 ++++++++++++++++++++++++++++++
 Makefile            |  4 ++++
 README.md           |  3 +++
 scripts/common.bash |  5 ++++-
 4 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 .shellcheckrc

diff --git a/.shellcheckrc b/.shellcheckrc
new file mode 100644
index 000000000..491af18bd
--- /dev/null
+++ b/.shellcheckrc
@@ -0,0 +1,30 @@
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
+# Disable SC2086 for now, double quote to prevent globbing and word
+# splitting. There are lots of places that use it for word splitting
+# (e.g., invoking commands with arguments) that break. Should have a
+# more consistent approach for this (perhaps use arrays for such cases)
+# but for now disable.
+# SC2086 (info): Double quote to prevent globbing and word splitting.
+disable=SC2086
+
+# Disable SC2235.  Most developers are used to seeing expressions
+# like a || (b && c), not a || { b && c ; }. The subshell overhead in
+# kvm-unit-tests is negligible as it's not shell-heavy in the first
+# place (time is dominated by qemu startup/shutdown and test execution)
+# SC2235 (style): Use { ..; } instead of (..) to avoid subshell overhead.
+disable=SC2235
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
index 6e82dc225..03ff5994e 100644
--- a/README.md
+++ b/README.md
@@ -193,3 +193,6 @@ with `git config diff.orderFile scripts/git.difforder` enables it.
 
 We strive to follow the Linux kernels coding style so it's recommended
 to run the kernel's ./scripts/checkpatch.pl on new patches.
+
+Also run make shellcheck before submitting a patch which touches bash
+scripts.
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


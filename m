Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B536EAA8;
	Fri, 20 Mar 2026 21:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774042181; cv=none; b=Ttajjw3Sy6sTwpzoHypnE1ZMB6A1NNua46+OeqdIJQJrRYiexm9GV2i49GchReG+E51HKepDsCTyzJz5gIGr5zUsVi8CoWYvP7w3HOW98AB8KQWoc8Za6RLqa6d8fK80918aRzk0EuGvls6nzMTtwrS8IJbt+817Cm8VEZCyLAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774042181; c=relaxed/simple;
	bh=XOXr5QvcaVf4iLyQhdg9jMkDSOx+EETplOSbicfRIaI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=FYYN1HHpfydGru/Ev1vlwyBOFiqAvREmQ2ae7kbkSZ3x0+5WgUdFqLJrOeWCSUxDJj1ZiK03bzw6KX70HAm+RcYQl0aMik/Hy8qbOGg3XfDJPlimAFDbJ5Tbxar3zEggynj6MEzFyzwJAJ9NBuZ1eJxDt04nXbSAYN3df8VO5Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vtt3VWXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vtt3VWXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35337C4CEF7;
	Fri, 20 Mar 2026 21:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774042181;
	bh=XOXr5QvcaVf4iLyQhdg9jMkDSOx+EETplOSbicfRIaI=;
	h=From:Date:Subject:To:Cc:From;
	b=Vtt3VWXtC13b2cGnkkGQ+YNOXvkLuK0B/8v/hZpKxxwkaNKrXlDujWtmfYAPBAo2f
	 oB6MhVBmVwAujXWs/BfNJSiqghOelEXe9EjU7sPceTKutrFh9Qq9H0J4/nN6WqackL
	 NU+zqreCKM8Uiwp77gUmBXDjWDWFFcH5N42qJortgGiJvCFcsWGQy96jqr3PrhqELS
	 A2UfdQgbHx4h7E8+2Q176v5O2ywH2U7/ldmH+kE7/jZwy4YcVz65oUxURkZnZ5Mc3e
	 aNhUko8LIEJgiL/tEN0pOMChSYT/LaiFJMB164WVsGGFPRKLHIGVe3alTGrP3Eh2z3
	 iWVqkKOt7aarQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 20 Mar 2026 14:29:33 -0700
Subject: [PATCH] tracing: Adjust cmd_check_undefined to show unexpected
 undefined symbols
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-cmd_check_undefined-verbose-v1-1-54fc5b061f94@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM4QqCMBSG4VuR87vBNtGgW4mQPOdbnqIZm0og3
 ntLfz7w8q6UkRSZLtVKCYtmHWOBO1XEwz0+YFSKyVvf2tpbw2/peAC/ujkKgkaIWZD6McOcxTX
 B1aF1jVA5fFIJvvv9ejuc5/4Jnv5L2rYfmioA+38AAAA=
X-Change-ID: 20260320-cmd_check_undefined-verbose-7d15f13f615d
To: Marc Zyngier <maz@kernel.org>, 
 Vincent Donnefort <vdonnefort@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1884; i=nathan@kernel.org;
 h=from:subject:message-id; bh=XOXr5QvcaVf4iLyQhdg9jMkDSOx+EETplOSbicfRIaI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJl79zjl3rN6+zfBad+X6Kk5V2Uy6l7Ghh7+8fIu2/W9j
 vHuPnGzO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEKhgY/gcoxWVEWP5IerB9
 c8ThbVea3nzhFIuuesT/ZFeuftgnVmFGhrdvfs+7cKN5G/uR+lTnkiy5SBev4P8XGM6w/7/P8lf
 djhkA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When the check_undefined command in kernel/trace/Makefile fails, there
is no output, making it hard to understand why the build failed. Capture
the output of the $(NM) + grep command and print it when failing to make
it clearer what the problem is.

Fixes: a717943d8ecc ("tracing: Check for undefined symbols in simple_ring_buffer")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Commit a717943d8ecc ("tracing: Check for undefined symbols in
simple_ring_buffer") and its follow up fixes are in the kvmarm tree so
this should go there as well. This is the rebased version of my
suggestion in the original thread:

https://lore.kernel.org/20260311221816.GA316631@ax162/
---
 kernel/trace/Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c5e14ffd36ee..d662c1a64cd5 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -174,7 +174,13 @@ UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sancov __sanitize
 		      $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
 
 quiet_cmd_check_undefined = NM      $<
-      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(addprefix -e , $(UNDEFINED_ALLOWLIST))`"
+      cmd_check_undefined = \
+          undefsyms=$$($(NM) -u $< | grep -v $(addprefix -e , $(UNDEFINED_ALLOWLIST)) || true); \
+          if [ -n "$$undefsyms" ]; then \
+              echo "Unexpected symbols in $<:" >&2; \
+              echo "$$undefsyms" >&2; \
+              false; \
+          fi
 
 $(obj)/%.o.checked: $(obj)/%.o $(obj)/undefsyms_base.o FORCE
 	$(call if_changed,check_undefined)

---
base-commit: e3d585ed3ff891a00c2284fef4be9cf8581735ab
change-id: 20260320-cmd_check_undefined-verbose-7d15f13f615d

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>


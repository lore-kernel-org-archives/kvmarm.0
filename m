Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6C93D9DDF
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 08:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790326589; cv=none; b=AQjSnHcui0iudjwkNEdPf2VU4tDzppY9f4NMQL4fjVHxMEXHtRIfhKB6kIIuYpdEBcs0wVzRPzt64123seju+1ttisSAQZuSrLYj06MqTS2f+oON2AY99752eKnVQHbjbzzArYQiZwvUk9Oa7LIDk7RzBF7EV0oB0JtM+1n+JpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790326589; c=relaxed/simple;
	bh=4ItXQAaVD3WTiZWusPDbpFOvpnrFX48KxY8M3INCb2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPV6jPrNjX/l95+SfxKpOjQBAXxmiXddDlVKFVZvxa1OrigzaYdDBaq7B6fJ7Y/CF0MGnfsmnGagtRV3DbWbkDMsYmRwK46coYfgDk09bgifk4nYnruFNZE0KSGPWq0PHS3qIrgMkzL3g0lO9xMvyiDvJToZpKenoRVzl3nJp1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kIInTsAM; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kIInTsAM"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccda24afso383963a91.3
        for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 01:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790326587; x=1790931387; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j1v+S80dUo//p+15Rqn0T4DE2Wzaj20kwbdF2DBjtus=;
        b=kIInTsAMnj+31ezm9rxTnicgca1Q03SaKRpqZfYQyKAtIu/c6P6ol/qpY6FilGJlA7
         kppFGZAPzHiGnEwljso97d4cSph3cPWPSVeouhsqvStWBL+CzD57Sz7/f4HK558KcPEb
         s+6OCx47TawIPDeGgYiU/Ab+b1krkuTTrPRhC7CtyeQlZU0evBYfK/Uv7eZ5H4f0DU0a
         NzcV1oWuW0u3nfG7Vkaw1nFBmyZU7UHnVgFaCs63wYTdG0ngLwVF4FwBvgREs6In8h26
         5ZaMBhKQqRwucjkKdTXPBn/KX9XZnqRo8Nkeel4dSJcX0bPe0uwdNNfvaVlItsnZTlLv
         6REQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790326587; x=1790931387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j1v+S80dUo//p+15Rqn0T4DE2Wzaj20kwbdF2DBjtus=;
        b=Jmsslvw8+GxKbuPzyEoqBtqVS9+XnD4L1+XZ1cQq+x79UuN/uL2XHnORD92yf/uC9F
         j0b1wyJEiSWeHWKj9kookPCbGBwNH0ZjA1wDXKdRSOWjCV+x/G8d0stjX3sEgW7r3TEs
         q+v/EC8NWhV4lMyZfQRIUpyKqZ9r7nmflHuaWtd+WgoSQjZGQwEeJ7J6m1Nhst8wTgav
         iQHWkgv1KoWRFD8730V+5N9NZa0XExumTdMsa4EYFsuHioE5oF+n9r14cKAUOWFz4nbw
         k5qaSSJ2l27yOkV9hMSgmwxfbU10q6us53IN4tH+7Pzci0RuyKNxQPKG0iUgENaGky23
         8C4g==
X-Forwarded-Encrypted: i=1; AKwUvBwYGffMafNdk+GXowrJobbSeF6v0/qB3VjMhbZ+LgSLSNS1YKYzV1qj0RFj0SCUfRnDy4bp2A4=@lists.linux.dev
X-Gm-Message-State: AFuF++kzptODJ9Mvdl9mkyDEmHV/IOSriE7/v8yfGXVh9JsoeeD4ZJFa
	/WdqN+2t9RtHMdkk0GlhI95OXmA6ItNHO7QrEML3s9XWRCxn5eQzEIJu
X-Gm-Gg: AYBFou0wmS5UqWXBX+T2GIDCKCJ/XvFwJYidwCziUpycLyTILIWPJI6DP5AvE8ryRYI
	TToBxFUVjuiRc+q6GYu4e6TAFZu1p/4COl09Da+8Apy5h9dV5OJyzba//ZGB6vS55rnfVGcdvtp
	ElIRUjXb+fBajkG1TgUDfhL7iyBLNwxfBtmB7loCIY+Cu5rgGd61egSMTudu6+wFxiCpA2n2lrl
	CWnideC0B8q5AXaF0k/HeUE+ZZYpOeMWWP31m2YweVBHM0n9w5DmLsKo0M/ZEUuv9zwFzC/KW/k
	p4GCC8lhLSB8V8a/4pON8PIb+paIpCAmVz1YqALGAgsZqwEC/ogptPybfgkhweH5nKSN3Tz3vJC
	nzUjIfoPmsY76kjn2iM3XU5lqDaOrzEmzebLNH0XHcHc5x33/y1HkgC5O6IqzwhnKsKIVzAgTq3
	DYQx23SWuroQEAYgwjXfQKQsgR0lsuxvXlZ4UJSV2vTgbZkSWD03y76yQ7/0Dfy+3f5JxLfSYKN
	3DqpfmtUweaNJheIRbHjmOyiuAEL6St3yvm576b/IbBKsU7X0i8ZjrQRN9jB42/RQlPAySbES7Q
	oOnxLjW7ROw/unlS2d7AxrUoXTOO5nNy0MfTE4XU5hnFxSuRvedBj3NC4Ceq
X-Received: by 2002:a17:90b:28c5:b0:39e:6a81:c923 with SMTP id 98e67ed59e1d1-3a098729524mr3899330a91.22.1790326586359;
        Fri, 25 Sep 2026 01:56:26 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976cacbesm9381069a91.13.2026.09.25.01.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 01:56:25 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: maz@kernel.org
Cc: oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [RFC PATCH] Documentation/process: Add a maintainer entry profile for KVM/arm64
Date: Fri, 25 Sep 2026 16:56:21 +0800
Message-ID: <20260925085621.562448-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <875wzu4vuv.wl-maz@kernel.org>
References: <20260924033536.3624334-1-matthias.goergens@gmail.com> <877bkb3zjq.wl-maz@kernel.org> <20260924083036.1744194-1-matthias.goergens@gmail.com> <875wzu4vuv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM/arm64 has no P: entry in MAINTAINERS, so nothing tells a contributor
that the kvmarm tree is used for integration only, or that most patches
are expected to be based on a tag from Linus' tree rather than on
kvmarm/next or linux-next.  Marc Zyngier said a profile would help and
pointed at the KVM x86 one as a starting point, noting where KVM/arm64
differs: the absence of topic branches, the references to documentation,
and the base for most patches.

Add a profile covering the trees and how changes flow through them, the
base for patches, recipients, subject prefixes, architecture references,
testing, key cycle dates and review cadence, and point the KVM/arm64
entry at it.

Link: https://lore.kernel.org/all/875wzu4vuv.wl-maz@kernel.org/
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
Marc, this is the profile you said would help, in the thread this
replies to.  Where you and Oliver haven't said anything on the list, it
follows the KVM x86 profile and general practice, so please correct
anything that doesn't match how you work.  Three things need your call
in particular; they are marked [?: ...] in the text:

- master: once it follows -rc1, should the profile mention it?

- Cross-tree changes: the draft says there are no standing topic
  branches for contributors, and that when a series also touches arm64
  code the maintainers may set up a shared stable branch on an -rc tag.
  Is that right?

- Cut-offs: which is the last -rc for new features, and when do you
  decide what goes into the merge window?

I've kept this RFC to the people in this thread.  Once you're happy
with it, I'll widen the circle to the documentation maintainers and
lists.

 .../process/maintainer-kvm-arm64.rst          | 163 ++++++++++++++++++
 MAINTAINERS                                   |   2 +
 2 files changed, 165 insertions(+)
 create mode 100644 Documentation/process/maintainer-kvm-arm64.rst

diff --git a/Documentation/process/maintainer-kvm-arm64.rst b/Documentation/process/maintainer-kvm-arm64.rst
new file mode 100644
index 000000000000..deba2f812cef
--- /dev/null
+++ b/Documentation/process/maintainer-kvm-arm64.rst
@@ -0,0 +1,163 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KVM/arm64
+=========
+
+This document describes how KVM/arm64 (``arch/arm64/kvm/`` and the other
+files listed under "KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" in
+MAINTAINERS) is maintained.  It supplements
+Documentation/process/submitting-patches.rst.
+
+Overview
+--------
+
+KVM/arm64 is maintained by Marc Zyngier and Oliver Upton, assisted by the
+reviewers listed in MAINTAINERS.  Patches are discussed on
+kvmarm@lists.linux.dev, and linux-arm-kernel@lists.infradead.org is Cc'd as
+well.
+
+Trees
+~~~~~
+
+The KVM/arm64 tree is::
+
+  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
+
+This tree is used for integration only: no development happens in it, and
+most patches should not be based on it (see `Base for patches`_).  Its
+branches are:
+
+``next``
+  Changes queued for the next merge window.  linux-next merges this branch.
+
+``fixes``
+  Fixes for the release currently in its -rc phase.  linux-next merges this
+  branch too.
+
+[?: ``master`` still points at a 2020 commit.  Once it follows -rc1, should
+this document mention it?]
+
+Changes leave the tree as signed tags, which are pulled into the main KVM tree
+(``git://git.kernel.org/pub/scm/virt/kvm/kvm.git``) and from there reach Linus
+Torvalds.
+
+Unlike the KVM x86 tree, KVM/arm64 has no standing topic branches for
+contributors to base their work on.  Where a series also touches code
+maintained elsewhere, most often the arm64 architecture code, the maintainers
+may set up a shared stable branch, based on an -rc tag, that both trees merge.
+Say in the cover letter which parts of a series touch other subsystems.
+[?: Is this an accurate description of topic branches and of how
+cross-tree changes are handled?]
+
+Base for patches
+~~~~~~~~~~~~~~~~
+
+Base your patches on a tag published in Linus Torvalds' tree.  Patches based
+on linux-next or on ``kvmarm/next`` are discouraged.
+
+If your series depends on something that is not yet in mainline, such as
+another series under review or work already queued in ``kvmarm/next``, say so
+in the cover letter and name exactly what it applies on top of.  The
+maintainers may also ask for a series to be rebased onto ``kvmarm/next`` when
+it conflicts with work queued there.
+
+Use ``git format-patch --base`` so that the base commit is recorded in the
+patches.
+
+Submit Checklist Addendum
+-------------------------
+
+Recipients and threading
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+Send the whole series to all of the maintainers and reviewers listed for
+KVM/arm64, not a selection of them.  Post each new version as a new thread,
+with a cover letter for anything longer than a single patch.
+
+Subject lines
+~~~~~~~~~~~~~
+
+Changes to KVM/arm64 use the ``KVM: arm64:`` prefix, often followed by a
+sub-topic such as ``nv:`` or ``vgic:``.  Selftest changes use ``KVM: arm64:
+selftests:`` or ``KVM: selftests:``.
+``git log --oneline`` on the files you touch shows what is in use.
+
+Architecture references
+~~~~~~~~~~~~~~~~~~~~~~~
+
+KVM/arm64 code tracks the Arm Architecture Reference Manual (the "Arm ARM",
+document DDI0487) closely.  Where a change depends on architected behavior,
+explain why the change is needed and cite the Arm ARM in the commit message
+or in a comment.  Section numbers change between revisions of the Arm ARM,
+so give the revision along with the section, for example ``DDI0487L.a
+D24.2.70``.
+
+This differs from KVM x86, whose profile asks contributors not to cite
+section numbers.
+
+Testing
+~~~~~~~
+
+Say in the cover letter how the series was tested: which tests, and on which
+hardware or model.  The KVM selftests (``tools/testing/selftests/kvm/``) and
+kvm-unit-tests are the usual test suites.  Put selftest changes in patches of
+their own, separate from the KVM changes.
+
+KVM/arm64 can run in several modes, which are described under
+``kvm-arm.mode=`` in Documentation/admin-guide/kernel-parameters.txt.  Test
+the modes your change can affect.
+
+Do not draw conclusions about performance on hardware from measurements made
+on a software model such as QEMU or the Arm FVP.
+
+Changes to nested virtualization in particular are unlikely to be merged
+without test coverage.  Depending on the change, selftests may not be enough;
+the maintainers may ask for testing with a VMM, for example.
+
+Userspace API
+~~~~~~~~~~~~~
+
+Document changes to the userspace API, usually in
+Documentation/virt/kvm/api.rst or in the files under
+Documentation/virt/kvm/devices/ and Documentation/virt/kvm/arm/.
+
+Fixes
+~~~~~
+
+Add a ``Fixes:`` tag for bug fixes.  If the fix should go to stable kernels,
+add ``Cc: stable@vger.kernel.org``; the maintainers may add it when applying
+if the bug calls for it.
+
+Key Cycle Dates
+---------------
+
+Fixes for the current release are queued on ``fixes`` and sent throughout
+the -rc phase.  Changes for the next merge window are queued on ``next``.
+
+[?: What are the cut-offs: the last -rc for submitting new features, and the
+last -rc at which the maintainers decide what goes into the next merge
+window?]
+
+Review Cadence
+--------------
+
+Unless the maintainers ask for a new version sooner, allow at least a week
+between versions of a series, and only post a new version once there has
+been enough review to justify it.  Posting more often
+delays review rather than speeding it up.
+
+Pinging a series that has had no response is fine.
+
+Applied patches are normally acknowledged in reply to the posting, naming the
+branch (``next`` or ``fixes``) and the commits.  Commit IDs can still change
+before they reach mainline.
+
+Minor problems are often fixed up by the maintainers when applying; if they
+say "no need to resend", don't.
+
+Security issues
+---------------
+
+Bugs that let a guest attack its host, or a nested guest attack its guest
+hypervisor, should be reported as described in
+Documentation/process/security-bugs.rst.
diff --git a/MAINTAINERS b/MAINTAINERS
index 140eafcbbd78..129d7ef2c3ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14301,7 +14301,9 @@ R:	Zenghui Yu <yuzenghui@huawei.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.linux.dev
 S:	Maintained
+P:	Documentation/process/maintainer-kvm-arm64.rst
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
+F:	Documentation/process/maintainer-kvm-arm64.rst
 F:	Documentation/virt/kvm/arm/
 F:	Documentation/virt/kvm/devices/arm*
 F:	arch/arm64/include/asm/kvm*

base-commit: 62f4c998b297cf233997a2b4cd6fc2d2df0319c9
-- 
2.55.0


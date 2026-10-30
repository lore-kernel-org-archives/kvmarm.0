Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793349240;
	b=kQF+4FIyBM8Rwwt03SocEnE8ou8drGwf6oZLdoU9y/f/gKvcxKL43pCO7o2G2PF6Ejnm
	 T5Vz/xqqNK7QNeciytMhe0lWG72ItB1QVY1XQ+rqtU5UJeqKjFhCHMKrHywmHdfG3aRd4
	 6RFSS4XhZzWdhCjEk5DMXTv/3ttXU3Qpf7PHvg0Mh1AcvoleOYN0awZF22cI3iwtY10ac
	 4K/KYEA9pcdLaa0R2nwDT3B6Q+F12xst7lzE0Go/HoS93XVd5DvHYpMANkpIJDW3LIvib
	 aowEQuC8/pgBv/sWv4vONYloY94saoCItB2cS+aIopBUtn8wAhF88wUl46oVWjFYlAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793349240;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fbEtnkUKPu+LL9E6R37XAYXOIcXTLbcLWYw0vich8Gw=;
	b=AvoM/1H+Qy5jOgc/50kKGpXetzb62HlizNWwA+8RsN6ASwI5VuB6q54+/DAMzaRMiCTq
	 4QFksgL3fshUdlwsYqr1qgpxIx3+Xb9PWw5Rdn9I0sSD/DFD31P3mEA16Stc6QJWaN9h5
	 wk40GXlTNDsZdUbSYdheRvdvp8xel7FTNPIsAjr4Ma4/ageesIGdBa2TKhG4JuW7JBh8H
	 RTjb5zDyU2FBdw5rcGwwfjpbdrfVGqwEPwzp6rT8Db4KAl952EMDVZHcbKHY5IuVr1n30
	 r4XLTKDtgCX9vF6fg21naESGfNCGbY0yJzz+JZN6YjBMEwqim3yrDRg8SQV5qlAyLwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="R81qjM/X";
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BC7606A31F
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 08:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46BC7606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R81qjM/X
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc147d86bebso322545a12.0
        for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 01:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793349238; x=1793954038; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fbEtnkUKPu+LL9E6R37XAYXOIcXTLbcLWYw0vich8Gw=;
        b=R81qjM/XDQWxpj+QWkOYT2HlKvDW7ON+U6OeXocT04QgK1t5RF8zWtr0bKEVUlhgoB
         4KAhCMb+jqk1hJyZBeyfpHU3RNp0L61G3d9TTh4Y52uOfeyKUymx2qVpwxM+OJAbea5B
         yQmdgpbtFXJBM9JmjW/1Fn1yi58X7/MsIKV5uy/qd4ePcCUBAnX/gwtVgWibsURc/SKN
         KyOa6Owa6Nar+G/Qd781bjjOuRJcxGkEzyFDMyF5DgbgiyVgIPUGLySCJ7q7g6YtOb89
         hdxke29AYr3t0a1SJzevtaXc2BVk8c1Ctr/e37crLc5e53UzdV6UVAAT8J4cTITo8d1k
         pgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793349238; x=1793954038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fbEtnkUKPu+LL9E6R37XAYXOIcXTLbcLWYw0vich8Gw=;
        b=b/2ShKapkJ1Fa3gmGdNI+nV8Cn9losDKKa8yhyRGckOPz5edzpR6uHaNy/kSd5bewz
         2307/97VHPb/Qz1gEp1jBfYABZyTaC6nqN0MO9+q4HL9VtEgn4mGWALlUu2JP7/ogdnJ
         lzhq03WtyCvLGAAq1JG59KNqnB1x1SlpuLdcK4qtVoSGZGuP8Mnhp2CFLT2vMTdv/egT
         FTM6cjurP+l7CLgkgvvI+OV9zxGeitcFn/WxgWeioL308IFszfC4rEqMWaQPSz05hQKk
         EJap/nlyMuVOjtbgCBeK9cfe6yJ0EmSRwsISmaAsJY/Z1gqmgogy0oQPUwfJCBHJc4zW
         GwEw==
X-Forwarded-Encrypted: i=1; AKwUvBxsnwjkZFB5v+Tu3Ap3HzB1kCaflCSIap5gi0y6ssF88fr4IZnoldb/bQJ39ozFHpqfn6J79D8=@lists.linux.dev
X-Gm-Message-State: AFq9FYLOR7VODLtgwjcGz4GUwCjuQqDmuQSPjRnhavzUd6lQsnjVQ/5G
	fDgO6T9RLGaG0Dqsb5mnRGrdNiEEcRLIGHg7KksrXX83S/vyUas38X81
X-Gm-Gg: AYBFou0GuPrYavB77S0hP/ps6QwlT/TW9monEGgdFMlUpsmN7U84DXUIjW8uwRbCKv5
	fJHkcAllIx+unsnOeIwl331frjugcgyknAHRow+NoT8voVAX0tsFnBjygBvcCasVPoYVlx++IwA
	Ah9KWoGtDUTGRRiPJT1lrZ6coGUBu/HOUY4pFWYXU2Aj9hAxDB2iVxUrLgOY2cF68oFGrAJfeCw
	aGKcNJyB5dNqx/YDCZgAH38LPJyoV5KGw4dyCVGG58LALd1sCSqMIFO7SXfU5pBuqb3geUsdTev
	8vj/TlSIWRg72aZ/cwGGvO5LdWv59KKhNTL0+ipClHkx+qqGV71wxsSxdxiOcfA+4CW39lGZrGc
	wbLncnQfN321g068S7K2YtyFGN8RJoIoOTW69ymWvqFQb/TezM7vaIQKrnQBySIGXSY4VWJTrRi
	tg+LGQm5U2t72ZVFZlFBmeBri1sfJXdu2+aeqm3nlMnS7IaYbNYDcgwjkg/atg4Ki1k70+eMMNo
	SxjtDDayJ0oHawVw5RJd/v7WDpoDcLgNKixKV0EfHbljjsJThjPTIZPtrKw7RdC4wcvmN2YcJ98
	MuHxccvNErvEQpH7QY+xnYPmPjhI0NYHCMzJZ1FSnKYnM0Ra2HeIJwadWS6Vb1AxxAq3LiQLrw7
	GMyrks9vcE19+FM5sQVdag7MuXGf7Ou3/MWSFbpI0uvX8IwiEcx+KemFKPMm/b31YtEQHSdndOA
	iGfxyeA77Swof7meXc5Yh7/uSSI1hZZSUS10U=
X-Received: by 2002:a17:90b:2f0f:b0:3a7:9ec3:ea0e with SMTP id 98e67ed59e1d1-3ae8974a292mr952529a91.22.1793349238418;
        Fri, 30 Oct 2026 01:33:58 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae85e4ff4csm1490961a91.1.2026.10.30.01.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:33:57 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org
Subject: [PATCH v2] Documentation/process: Add a maintainer entry profile for KVM/arm64
Date: Fri, 30 Oct 2026 16:33:51 +0800
Message-ID: <20261030083351.3040604-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM/arm64 has no P: entry in MAINTAINERS, so nothing tells a contributor
that the kvmarm tree is used for integration only, or what the
maintainers expect patches to be based on.  Marc Zyngier said a profile
would help.

Add one covering the trees, the base for patches, the submit checklist,
key cycle dates and review cadence, and point the KVM/arm64 entry at it.

Link: https://lore.kernel.org/all/875wzu4vuv.wl-maz@kernel.org/
Link: https://lore.kernel.org/all/87tsnb2dtq.wl-maz@kernel.org/
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
Changes since the RFC
(https://lore.kernel.org/all/20260925085621.562448-1-matthias.goergens@gmail.com/):

- Point at the MAINTAINERS entry instead of naming maintainers and lists.
- Describe master, topic branches and shared branches; drop the open
  questions, which the RFC's Sashiko review had also flagged.
- Base: prefer -rc1 to -rc3, not kvmarm/next; leave conflicts visible.
- Subject lines: capital letter after the prefixes.
- Architecture references: prefer rule identifiers; drop the comparison
  with KVM x86.
- Testing: selftests usually at the end of the series, reproducible
  performance measurements, tests encouraged rather than required for NV.
- Key cycle dates: no new features after -rc6; how fixes are sent.
- Review cadence: stability of commit IDs; answering bot reviews.
- Posted as a new thread, with the documentation maintainers and lists
  on Cc.

Steffen, Marc asked you for a short addition on KVM/arm64 on s390 for
the Trees section.  I've left it out and can add it as a follow-up.

Oliver, thanks for inviting an updated patch.  Corrections are welcome.

 .../process/maintainer-kvm-arm64.rst          | 181 ++++++++++++++++++
 MAINTAINERS                                   |   2 +
 2 files changed, 183 insertions(+)
 create mode 100644 Documentation/process/maintainer-kvm-arm64.rst

diff --git a/Documentation/process/maintainer-kvm-arm64.rst b/Documentation/process/maintainer-kvm-arm64.rst
new file mode 100644
index 0000000..3b0bb56
--- /dev/null
+++ b/Documentation/process/maintainer-kvm-arm64.rst
@@ -0,0 +1,181 @@
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
+The maintainers, reviewers and mailing lists for KVM/arm64 are listed in its
+MAINTAINERS entry.
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
+``master``
+  Follows the -rc tags in Linus Torvalds' tree.
+
+Changes leave the tree as signed tags, which are pulled into the main KVM tree
+(``git://git.kernel.org/pub/scm/virt/kvm/kvm.git``) and from there reach Linus
+Torvalds.
+
+Topic branches are managed by the maintainers in their private trees, and only
+the result of integrating them is pushed out.  The exception is shared
+branches, which are published when necessary.  Where a series also touches
+code maintained elsewhere, most often the arm64 architecture code, the
+maintainers may set up a shared stable branch, based on an -rc tag, that both
+trees merge.  Say in the cover letter which parts of a series touch other
+subsystems.
+
+Base for patches
+~~~~~~~~~~~~~~~~
+
+Base your patches on a tag published in Linus Torvalds' tree, preferably -rc1
+to -rc3.  If you rely on something merged later, for example a fix merged in
+-rc4, say why in the cover letter.  Patches based on linux-next are
+discouraged.
+
+Do not base patches on ``kvmarm/next`` either: it is rebuilt regularly, so a
+commit on it is generally the wrong base.  If your series conflicts with work
+queued there, leave the conflict for the maintainers to see, as it is a sign
+that something needs a closer look.  A proposed resolution is welcome.  The
+exception is a series that strictly continues one that has already been
+queued.
+
+If your series depends on something else that is not yet in mainline, such as
+another series under review, say so in the cover letter and name exactly what
+it applies on top of.
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
+not as a reply to the previous version, with a cover letter for anything
+longer than a single patch.
+
+Subject lines
+~~~~~~~~~~~~~
+
+Changes to KVM/arm64 use the ``KVM: arm64:`` prefix, often followed by a
+sub-topic such as ``nv:`` or ``vgic:``.  Selftest changes use ``KVM: arm64:
+selftests:`` or ``KVM: selftests:``.
+``git log --oneline`` on the files you touch shows what is in use.  The text
+after the prefixes starts with a capital letter, for example ``KVM: arm64: nv:
+Fix life cycle of the nested_mmus array``.
+
+Architecture references
+~~~~~~~~~~~~~~~~~~~~~~~
+
+KVM/arm64 code tracks the Arm Architecture Reference Manual (the "Arm ARM",
+document DDI0487) closely.  Where a change depends on architected behaviour,
+explain why the change is needed and cite the Arm ARM in the commit message
+or in a comment.  Where the rule has an identifier, such as ``R_QXXPC``, quote
+that: identifiers stay the same across revisions of the document, while
+section numbers do not.  Otherwise give the revision along with the section,
+for example ``DDI0487L.a D24.2.70``.  The same applies to other architecture
+documents.
+
+Testing
+~~~~~~~
+
+Say in the cover letter how the series was tested: which tests, and on which
+hardware or model.  The KVM selftests (``tools/testing/selftests/kvm/``) and
+kvm-unit-tests are the usual test suites.  Put selftest changes in patches of
+their own, separate from the KVM changes and usually at the end of the series.
+
+KVM/arm64 can run in several modes, which are described under
+``kvm-arm.mode=`` in Documentation/admin-guide/kernel-parameters.txt.  Test
+the modes your change can affect.
+
+If a patch aims to improve performance, describe exactly how you measured it,
+in enough detail for others to reproduce the results.  Measurements made on a
+software model such as QEMU or the Arm FVP say nothing about performance on
+hardware.
+
+New tests are encouraged, particularly for nested virtualisation, where
+coverage is poor.  Depending on the change, selftests may not be enough; the
+maintainers may ask for testing with a VMM, for example.
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
+Changes for the next merge window are queued on ``next``.  New features are
+usually not merged once -rc6 has been published; from then on, only fixes are
+queued.  This is not a hard rule, but posting a feature just before -rc6
+guarantees nothing.
+
+Fixes for the current release are queued on ``fixes`` and sent upstream at
+intervals that depend on how severe the bugs are.  There is no cut-off for
+fixes, but the maintainers may defer a low-priority fix to the next merge
+window.
+
+Review Cadence
+--------------
+
+Unless the maintainers ask for a new version sooner, allow at least a week
+between versions of a series, and only post a new version once there has
+been enough review to justify it.  Posting more often delays review rather
+than speeding it up.
+
+Pinging a series that has had no response is fine.
+
+Answer reviews from bots such as Sashiko as you would any other review, even
+if only to say that a finding is wrong.  Pre-existing problems that a bot
+points out, and that are unrelated to the series, need not be fixed in its
+initial posting.
+
+Applied patches are normally acknowledged in reply to the posting, naming the
+branch (``next`` or ``fixes``) and the commits.  The maintainers try not to
+change the commit IDs of applied patches, but the IDs of merge commits almost
+always change.
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
index 7a162e9..183bf34 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14596,7 +14596,9 @@ R:	Zenghui Yu <yuzenghui@huawei.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.linux.dev
 S:	Maintained
+P:	Documentation/process/maintainer-kvm-arm64.rst
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
+F:	Documentation/process/maintainer-kvm-arm64.rst
 F:	Documentation/virt/kvm/arm/
 F:	Documentation/virt/kvm/devices/arm*
 F:	arch/arm64/include/asm/kvm*

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
-- 
2.56.0


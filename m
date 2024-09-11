Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C59013C8F9
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726046057; cv=none; b=HNrlQd5dXuJ2uLd6DiCqFDTxHPOmzSZzDO/ii3Ot8fZyqbrzBuwcYHHwaQGz+40nYqW1+YD+rOJVY29hxixmXGecfXHBo+nu6be+hKWCPM07n08xQ3LjIIDteL0OMEfRS40JDcoijzsfzzvaNFinGm2E5EgPDchVlntN8PNSG3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726046057; c=relaxed/simple;
	bh=h5ySaVfM8I8xxT2S6UUVoBpC3hcCM3GhiFxSe7b4r/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oVWyspvM0en7rBpAGc+LEsTduUa1wYS+feUEQkSzAqVNuXNqs4fI/uP7/54hdpWdqDh3EpFoOaneuEYPGG0369N1O8qXSImpiF4S+CaaK126Q17wVNTKRj8CBfn7sN2vZ44M01UWm1B1QncFfviVd10QO03JtItTbcuUyS8yp5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oKszq2B1; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oKszq2B1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726046053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fyMdMsKCQOu5UpiuFGR47iMoCTLzsA/eJycU3Mv3Vbs=;
	b=oKszq2B1bo4frYhI+HQHEPnCnV3/e3p6ugg//2xh2MI4JsYftikgOuS1vQ+4oMt2JMkY9i
	VZQsA3cFF+ltiew9QSW8n05L1CiXrG5Wc4PEjk90wixvGnHNjYBMMwZmuVDiCTEREz0xec
	8qdsrA6rXSby9QN0vXw59rOVHlVWzcU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	lvivier@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v3 0/5] Support cross compiling with clang
Date: Wed, 11 Sep 2024 11:14:07 +0200
Message-ID: <20240911091406.134240-7-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Modify configure to allow --cc=clang and a cross-prefix to be specified
together (as well as --cflags). This allows compiling with clang, but
using cross binutils for everything else, including the linker. So far
tested on riscv 32- and 64-bit and aarch64 (with some hacks to the code
to get it to compile - which is why there's no gitlab-ci patch for aarch64
in this series). I suspect it should work for other architectures too.

v3:
 - Add README patch for cross-compiling, clang, and cross-clang [Nick]
 - Add comment to the commenting-out of mstrict-align [Nick]
 - Add the reason to ignore warnings vs. fix code to commit message of
   patch2
 - Picked up Nick's tags
v2:
 - fix building with clang and --config-efi by suppressing a warning
 - added riscv clang efi build to CI
 - picked up Thomas's tags

Andrew Jones (5):
  riscv: Drop mstrict-align
  Makefile: Prepare for clang EFI builds
  configure: Support cross compiling with clang
  riscv: gitlab-ci: Add clang build tests
  README: Add cross and clang recipes

 .gitlab-ci.yml | 43 +++++++++++++++++++++++++++++++++++++++++++
 Makefile       |  2 ++
 README.md      | 22 ++++++++++++++++++++++
 configure      | 11 ++++++++---
 riscv/Makefile |  4 +++-
 5 files changed, 78 insertions(+), 4 deletions(-)

-- 
2.46.0


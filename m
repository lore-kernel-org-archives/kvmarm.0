Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C3C5B1F0
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 19:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p2cQ4keh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700595016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yK0XaH7LVAZ6XwxQtO+PZOjDIuFVOFFLULOAhgoWiMg=;
	b=p2cQ4kehavoMPwZHGy272SVQexX++AT7afaXk66hEFRpAeifwUPu1pnBhkQy6I+XUGXLxD
	DagG5dVxE3MrkHro7pW6INV3UADhRfAYJzHJcnW/9pvLPsXria6RAn6+Q0HU0oJTvPQYzE
	nmtug801EnlGxgGG0QXlurCgT42JXWc=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-perf-users@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] perf build: Fixes for arm64 sysreg-defs build rules
Date: Tue, 21 Nov 2023 19:29:54 +0000
Message-ID: <20231121192956.919380-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Small series to address the issues Ian raised in [*]. Tested with
perf-targz-src-pkg and building arm64 KVM selftests.

[*] https://lore.kernel.org/linux-perf-users/CAP-5=fXxiOJMVqaH1JPU_K6+1GhaEgVeR7YyN+F0r7qTE8DGEw@mail.gmail.com/

Oliver Upton (2):
  tools perf: Add arm64 sysreg files to MANIFEST
  perf build: Ensure sysreg-defs Makefile respects output dir

 tools/arch/arm64/tools/Makefile      |  2 +-
 tools/perf/MANIFEST                  |  2 ++
 tools/perf/Makefile.perf             | 24 +++++++++++++++---------
 tools/perf/util/Build                |  2 +-
 tools/testing/selftests/kvm/Makefile |  5 +++--
 5 files changed, 22 insertions(+), 13 deletions(-)


base-commit: b85ea95d086471afb4ad062012a4d73cd328fa86
-- 
2.43.0.rc1.413.gea7ed67945-goog


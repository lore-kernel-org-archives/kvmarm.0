Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC305B1F3
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="paU2zdqh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700595018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kj9amk3sZHEhxmsx3Fn9wTkkDjnzbMy4CyCqBJxEZpc=;
	b=paU2zdqhbVaPHBdil4bk5Lo91CEa3CeRvhpHOgoX6WESS3FOVxUemJd4Xck//2nYj2Tlzt
	pTasWAA+ZG5w8LUmZeBGKBPlFZyNVMFK2aQ0zEpVJkULWOds2mY9pt7JuAZcbGkr9Nv4DI
	NKRy+zNVugBX0uU46kGEQ/ZOcKQtwbU=
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
Subject: [PATCH 1/2] tools perf: Add arm64 sysreg files to MANIFEST
Date: Tue, 21 Nov 2023 19:29:55 +0000
Message-ID: <20231121192956.919380-2-oliver.upton@linux.dev>
In-Reply-To: <20231121192956.919380-1-oliver.upton@linux.dev>
References: <20231121192956.919380-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Ian pointed out that source tarballs are incomplete as of commit
e2bdd172e665 ("perf build: Generate arm64's sysreg-defs.h and add to
include path"), since the source files needed from the kernel tree do
not appear in the manifest. Add them.

Reported-by: Ian Rogers <irogers@google.com>
Fixes: e2bdd172e665 ("perf build: Generate arm64's sysreg-defs.h and add to include path")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/perf/MANIFEST | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 1da7f4b91b4f..dc42de1785ce 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,3 +1,5 @@
+arch/arm64/tools/gen-sysreg.awk
+arch/arm64/tools/sysreg
 tools/perf
 tools/arch
 tools/scripts
-- 
2.43.0.rc1.413.gea7ed67945-goog


Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188A52E632
	for <kvmarm@lists.linux.dev>; Wed, 25 Oct 2023 19:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g1YIzv3U"
Date: Wed, 25 Oct 2023 19:07:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698260851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1z86aOessVJf1f7xTckw9Z9ZagBGFYnpPIX+SQ4dj5k=;
	b=g1YIzv3UzFcSTAdMrk9BTNrjuCINFTW1OhbSWcnaBmNZR5DUPH8XAefDSjxkTzC7PNSTf1
	Z+lz63/exdLv+COn2chrk19epNG27mgBhnjORcmE4cfuh6+GjAo5021Wn3MpPnMmEdjnjz
	ubr0VwIRVK0p6CXX0SH10P18OH7Q3Ok=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 3/5] KVM: selftests: Generate sysreg-defs.h and add to
 include path
Message-ID: <ZTlnbQ2U9ZaAkXYE@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-4-oliver.upton@linux.dev>
 <f25acdcb-269e-fae5-fbbc-54e8d6d05b23@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f25acdcb-269e-fae5-fbbc-54e8d6d05b23@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 25, 2023 at 10:02:36AM +0100, Aishwarya TCV wrote:
> On 11/10/2023 20:57, Oliver Upton wrote:
> > Start generating sysreg-defs.h for arm64 builds in anticipation of
> > updating sysreg.h to a version that depends on it.
> > 
> > Reviewed-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  tools/testing/selftests/kvm/Makefile | 23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> > 
> 
> Hi Oliver,
> 
> 
> Currently when building kselftest against next-master with arm64 arch
> and defconfig+kselftest-kvm  “make[4]: *** [Makefile:26: prepare] Error
> 2” is observed.

Looks like we're descending into tools/arch/arm64/tools/ w/
$(srctree) == ".", which I believe is coming from the top makefile. The
following diff fixes it for me, care to give it a go?

diff --git a/tools/arch/arm64/tools/Makefile b/tools/arch/arm64/tools/Makefile
index f867e6036c62..7f64b8bb5107 100644
--- a/tools/arch/arm64/tools/Makefile
+++ b/tools/arch/arm64/tools/Makefile
@@ -1,13 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
 
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(CURDIR)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
+ifeq ($(top_srcdir),)
+top_srcdir := $(patsubst %/,%,$(dir $(CURDIR)))
+top_srcdir := $(patsubst %/,%,$(dir $(top_srcdir)))
+top_srcdir := $(patsubst %/,%,$(dir $(top_srcdir)))
+top_srcdir := $(patsubst %/,%,$(dir $(top_srcdir)))
 endif
 
-include $(srctree)/tools/scripts/Makefile.include
+include $(top_srcdir)/tools/scripts/Makefile.include
 
 AWK	?= awk
 MKDIR	?= mkdir
@@ -19,10 +19,10 @@ else
 Q = @
 endif
 
-arm64_tools_dir = $(srctree)/arch/arm64/tools
+arm64_tools_dir = $(top_srcdir)/arch/arm64/tools
 arm64_sysreg_tbl = $(arm64_tools_dir)/sysreg
 arm64_gen_sysreg = $(arm64_tools_dir)/gen-sysreg.awk
-arm64_generated_dir = $(srctree)/tools/arch/arm64/include/generated
+arm64_generated_dir = $(top_srcdir)/tools/arch/arm64/include/generated
 arm64_sysreg_defs = $(arm64_generated_dir)/asm/sysreg-defs.h
 
 all: $(arm64_sysreg_defs)

-- 
Thanks,
Oliver

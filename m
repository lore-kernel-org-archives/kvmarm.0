Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2501F958
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279072; cv=none; b=lTKJAwgWFF2OMN/ap1WMgPCodzNZA57FvZm4cjwuEH4vhxxT1sQIL6K2i2aGKFGS7mjfEQkA1vbak0YuNvGuFBTuUaVZ8S8f4cwzy6NqPyosalPKxlSj9EAMYTrG9JnoTHh1N3vAvIGTBfzNAwY8EtsKhE+1Y1puBRIyNp8r7iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279072; c=relaxed/simple;
	bh=kkLHAT1aru4kqVRhTZTxDmoT7B2myDGPsJoLvPJ4LwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=F+xfe6zXfoYFIZPuxM324HF5K4TOR8jMHm6G6N0FVrc3c/IcsCcilQFLOD8+O3AJ7Hs5ZCsfkFrqaNnFhM0NvgQ6MfwuRZUIte493u3YuZV/mcqWURw5mO3Qh5FMqAouIuOk6LE16LpYQ7C1vhy9d6pnFxmVMgyL3AbuNgcfowU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=abiT3c/R; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="abiT3c/R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wp48M57+460gf0h/vogiX45XJW/w1v5ntdv821ynfeQ=;
	b=abiT3c/Rv209MgrKWt7WKdAoO6ptenT/EbJvxKeF0zuMnoCnATNPhuu9b8PueuQt5YrzJ0
	4Ej7TPjCTEgdtqEtdXI6XVGwxZRLk40dP+hwfLcKM6ngplM/TzyZZNxZOlfSScih/zF3HK
	PvRB36t6kTNtTviDjIDIjJ1Rdrt/Knw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 23/24] gitlab-ci: Add riscv64 tests
Date: Fri, 26 Jan 2024 15:23:48 +0100
Message-ID: <20240126142324.66674-49-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add build/run tests for riscv64. We would also add riscv32, but Fedora
doesn't package what we need for that.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 273ec9a7224b..71d986e9884e 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -87,6 +87,23 @@ build-ppc64le:
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
+# build-riscv32:
+# Fedora doesn't package a riscv32 compiler for QEMU. Oh, well.
+
+# Select 'rv64' with PROCESSOR_OVERRIDE in case QEMU is too old to have 'max'
+build-riscv64:
+ extends: .intree_template
+ script:
+ - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu
+ - ./configure --arch=riscv64 --cross-prefix=riscv64-linux-gnu-
+ - make -j2
+ - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\n" >test-env
+ - PROCESSOR_OVERRIDE=rv64 ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
+      selftest
+      sbi
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
 build-s390x:
  extends: .outoftree_template
  script:
-- 
2.43.0


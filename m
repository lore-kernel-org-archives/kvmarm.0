Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB06E17BC9
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 07:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080758; cv=none; b=FwTrRaHb38DSVRcEnDR6dNglZm4NC3pXC9Oeac73mW7hif6wWl5XvNX09orKMrfxcpfDof/sEO34nCOPDBRraMtwI195VylFhtOEQqpFhdZ9Coesu6zgwJMfiAX7TpB0fVbK/JqSFySo00mBpcpvVZYVp7HwDEdnTnLUY1WtMmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080758; c=relaxed/simple;
	bh=Devjl7AEn4NuxrRCNV7PfDwd8FyLGqavfbBk6E3H8Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=cflf9mFr3KWehXA260qUq9ssMTJzUbnuiWF/NSIWeO7zmfpWF62RtQlO2d/pLMvtLOOh2c30HZXqJj7hFl6S3yuPHQ2NRJl0KFZx17ivxiVd7epCL5BG56cjUeTEZTjU47cPKjIQ8WTu4pSOYPzVEO2E6iWOw+TSM3StX1s6SDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R0W5EcOK; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R0W5EcOK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wk3G2K/PNmaWscwPx5tsYexUNu/l41LUsS2Ns+QDkqI=;
	b=R0W5EcOKCWjIU43decL1zupRo2H4IjG90G5loHBvzcSbNR8JuMX9RVMj7QZLpFV6bhS0SU
	LPloZePb0yeK0Ugk2HETLSnSzNOPzJ12Ax2LQJSeKMkh0ojth1ZFHxO5SCr9//bkhHiEFK
	F5Jxmdj3H/B/TbziWxC1j1G7MzuaLng=
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
Subject: [kvm-unit-tests PATCH 23/24] gitlab-ci: Add riscv64 tests
Date: Wed, 24 Jan 2024 08:18:39 +0100
Message-ID: <20240124071815.6898-49-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
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
---
 .gitlab-ci.yml | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 273ec9a7224b..f3ec551a50f2 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -87,6 +87,22 @@ build-ppc64le:
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
+# build-riscv32:
+# Fedora doesn't package a riscv32 compiler for QEMU. Oh, well.
+
+build-riscv64:
+ extends: .intree_template
+ script:
+ - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu
+ - ./configure --arch=riscv64 --cross-prefix=riscv64-linux-gnu-
+ - make -j2
+ - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\n" >test-env
+ - ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
+      selftest
+      sbi
+      | tee results.txt
+ - if grep -q FAIL results.txt ; then exit 1 ; fi
+
 build-s390x:
  extends: .outoftree_template
  script:
-- 
2.43.0


Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14401CA69B
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 14:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725374393; cv=none; b=HOppzm0YqGgN0k7A5XNH1pBwaIapAlWKqyN9QfrgYbr24k3HZjmsZfbsfNZFIvkfygQM5aeXbNFhzoJ3bdHTx9tRKBy90Fb6Y6MiIKiEo17FlD5vy+0qWAJWW4Tk6SsmPVle9L2+tj0X+jCfHXVqxl3NZ0+zlU7iR4iX1ivB83A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725374393; c=relaxed/simple;
	bh=Q0jpZSdEq9UcPqSQtw8ICs4EGrluGAh7nPySsNoe7Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qw7df2ABWOrqyoSBX/ZPNW6tB+KfMfgAzh/s/BuKelK9vzhC5RR/rdgTnm4LQEo6Cn9PotI268u6gxb6e8yh8tEd6Jwq/DMXgMG93l0/ygUTfjdZAjTPOgufIj5/TOdwwJ5Dqyoy0ywiSwQl8eahQvfSdvVjEMQRJzl9psOpRVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qfQPriaM; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qfQPriaM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725374389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UoipvRa1rIlz02HbMk6/9TovCElSsYtUx+SlrCp58mM=;
	b=qfQPriaMG7F97zrrYRPeqmNAzZ2Fya7Tx/pPdqSt1GFpgUddaebwTjEIgXnEVgMXx9UAtj
	rtPDaZ3L84KS7pDp3kSEy4UmxXJrOBaUpqQG+3GKMvtaQHOHJev9H/ASPyhRExHSXUPKri
	ElCIqPlGyfKU0+3NNWojOHfKeSuUQwM=
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
Subject: [kvm-unit-tests PATCH 0/2] configure: Support CONFIG_* extension
Date: Tue,  3 Sep 2024 16:39:47 +0200
Message-ID: <20240903143946.834864-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

riscv already wants to change NR_CPUS sometimes, so a CONFIG_NR_CPUS,
which can be changed at compile time, would be helpful. We could just
provide support for that with the configure command line, but other
configurations will eventually come along (there are already two more
in another riscv branch). Add support for extending config.h with a
manually provided config.h-type file and also add support for using it
for CONFIG_NR_CPUS for riscv.

Andrew Jones (2):
  configure: Introduce add-config
  riscv: Make NR_CPUS configurable

 configure             | 17 ++++++++++++++++-
 lib/riscv/asm/setup.h |  3 ++-
 2 files changed, 18 insertions(+), 2 deletions(-)

-- 
2.46.0


Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAEB1E871
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 12:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730378396; cv=none; b=SwTXkbED7/F/pqnQpj8RBxIPuOU1+WIm1a5T5Zhq5sfLVFOLYrS1fprFT6v7m4sRTM0cfLjAydnF2ScgOxWUPyJyyFiB2c9w7W59dT975QfmfKb59m7YXX3zn/YovopY7ZoQ+Xrr7NDh1EnCSw4+mjiVdd0E42JE9TbSmi8AhtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730378396; c=relaxed/simple;
	bh=ZR4TEDlj7bF7F61cO/PbKGBbSv5Ft5be4PDXUyhKwR8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ndHGTuC+fuS9/43twUrkVIE6qaQrtWAIhmZTkNuoRTAY507Ox0R8oqVEtGZMDekxMjkXvxMeZnsopKsD5sjtanBz4GX3QMUX4un5Y8xflGb22WC61jG6U7SoCeU0MYmgX7u/7nCgjgIuWvuIdKQJM7IJZV+hBMVUlyYIPYoB6FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f8QBd4iU; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f8QBd4iU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730378391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gdF1Nr6kyU0rOKd8qve6B9gdfz/CzzuaXbgu4KJw9Ro=;
	b=f8QBd4iUEmBg1c9SPtebjDLldS2uk3P0nUG25gWpw6QCEwPcGkQgeguTJXltGQGh+0fVPr
	/veWG2siPI+ECkdaZkLLw0Cqn3vNiosKawwQ7KoVzYun/y91umf9gTD+AHUPD4FIfw+RVo
	XiutXurIIr/ohhk68BFKDWGbJUzdgZ4=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/3] lib/on-cpus: A couple of fixes
Date: Thu, 31 Oct 2024 13:39:49 +0100
Message-ID: <20241031123948.320652-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

While creating riscv SBI HSM tests a couple strange on-cpus behaviors
were observed. Fix 'em.

v2:
 - Added patch for barrier after func() [Alex]
 - Improved commit message for patch1 [Alex]

Andrew Jones (3):
  lib/on-cpus: Correct and simplify synchronization
  lib/on-cpus: Add barrier after func call
  lib/on-cpus: Fix on_cpumask

 lib/cpumask.h | 14 +++++++++++++
 lib/on-cpus.c | 56 ++++++++++++++++++++-------------------------------
 2 files changed, 36 insertions(+), 34 deletions(-)

-- 
2.47.0


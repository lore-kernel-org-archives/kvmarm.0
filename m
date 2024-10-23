Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701B212B71
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 13:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689450; cv=none; b=QRB43siiPJ0RjbqwZfS2HRpByJW6ljlfDSxYYOnbXhHBHtZA/XNzKTVSHoO+jZP4XQFbbY5CunNgXMfJOThEv/F3Ef4xIc9MeI2qr9DDi1E/fIE6xaWJpYrCJrH35Dj1V916WtixR3jyK1a2kVAQJa0VkMAto73aE4z92G0aCDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689450; c=relaxed/simple;
	bh=XY8XC+f+015iR5jNrhbsO8iF9wfNnGxN3MVqA41OaYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a42DdGh8qej8yYUU/bG1ZSScM5DrAOArK3CyrAqI3W1wYPgsj3H4F88vBYquhmjwZbtHJMiClz1qudERqavGIlgt7PjDnEe2Q6Rul8OOCoibrsDS9yDxJoX8FHD8RdvIQTt+Rqe0jgrya9B4N36cRbDTV157ito1gJR5WLygRLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=up3IwyMd; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="up3IwyMd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729689443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lZPwBMs7hy9HbGJzqbAYFNAsDsrWybNy8Qs2g3Lc1go=;
	b=up3IwyMdVOM7vxNGaMvujuYZ6Qqi5FhbgGVwBXFQNP/XC0/yBuFBMFpdbjJqR6aECHdygI
	zTfLOR4jYArwbhWjaQIuWoQ6XU81YIf0lTA6XVTxx1okETevzM2I/r7vHAjtWAxsfdBzuf
	TUH4Rzo9cJTlfo3GExOw9EUcUDw5twQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 0/2] lib/on-cpus: A couple of fixes
Date: Wed, 23 Oct 2024 15:17:19 +0200
Message-ID: <20241023131718.117452-4-andrew.jones@linux.dev>
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

Andrew Jones (2):
  lib/on-cpus: Correct and simplify synchronization
  lib/on-cpus: Fix on_cpumask

 lib/cpumask.h | 14 ++++++++++++++
 lib/on-cpus.c | 53 ++++++++++++++++++---------------------------------
 2 files changed, 33 insertions(+), 34 deletions(-)

-- 
2.47.0


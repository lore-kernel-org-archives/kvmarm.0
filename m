Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE716FE24
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 12:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712060521; cv=none; b=rAthIM34QtQheZMrOpuwWOVXWDP4UJY66fhyVwztuva1FiOLsoQqJOejBRXXAJazq1tgqBGhQKTXzC/rcJX0ZzhKnZ8e9iXakbky2VBxS7h16CZjykLGmolTILwAZCn03wlmLk3yOyb4YMDnsmapwmA3lRRiv5Vi56Ay4kddZLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712060521; c=relaxed/simple;
	bh=RuMZ3AipOXG1BU8iF69I1I8l5miPQlljEqLx5/h3fkI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=GzVA998fsh7z/qgNSdEyWTLzl/omoFZGbNkjaasce0GfYJlmN9zrJ4nfOs/I/WBcDmDFndKU4Hho8m4pmJou1V3Xsl4UivROtN42SbhN3YBDx/+SugqE7nBnML4kjKy17b9uqiEXDiOLPOJN7QaE+WwQc+01leIp90nLp0E9QkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xv7DeheC; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xv7DeheC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712060516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BE8AXApVaKcTEyASZg8vbc8GmgAWgG5SRbbkNpPATLk=;
	b=Xv7DeheCYhsT4b7AYKOoyVjlG5fd/I7yYqeGcnYuO6kBzL2dnU4e4tJetKxX/B8AwJLj96
	ePiYYX+BupjDYPmo2ryMWooUS1N0yR5X/UkBDDXv9Y8t+qOpKFT/5gL3r+JefRl/8VuAOQ
	8nFsiLTjyOx2k/QohaZ22SL+d5cjuhI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH 0/2] arm/arm64: Use 'max' cpu and gic types
Date: Tue,  2 Apr 2024 14:21:53 +0200
Message-ID: <20240402122153.101931-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The arm64 'max' CPU type enables all features, so it makes sense to use
it for testing to ensure we're testing the latest models. The 'max' GIC
is used to pick the latest GIC model by default which is better than
defaulting to gicv2 since it tests a later model and, when more
than 8 CPUs are configured, it'll actually work. We don't need to
convert 'max' to 'host' with KVM/HVF since 'max' is an alias for
'host' when those accelerators are enabled.

Andrew Jones (2):
  arm/arm64: Use 'max' gic type
  arm64: Use 'max' cpu type

 arm/run   | 8 +-------
 configure | 2 +-
 2 files changed, 2 insertions(+), 8 deletions(-)

-- 
2.44.0


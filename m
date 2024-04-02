Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2E74262
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712064468; cv=none; b=b0RkuP9AZicdFQE0eKZRMLxBS5XeCBBeFAkRA6zNDAoJIqXKmGDA+iYdTf6BOxDV1hEbmL1Ix7P+DDqNX2h5il2dBzLHndLr9RQ6FFKI7pOrBG2rRw7JR73SgzXJGBHceyOFSH6lOG6FN2gCFu+c6cZx2vxkccc7Y71cWoEabtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712064468; c=relaxed/simple;
	bh=A/rTTPqrCoyg36MgBTNf49qln1SSobbhglp59O+QlIY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=XMWewWYgUD3xhj9700jWt66BTTrSBvMHel2HDO6ajBP1c3rRtebByd2Aq5oYRu2en2w5VI6RGOpjhxnVY0bY7c8WEKyikn3XPcNNjiscR5Cl+jayU6/qYL8RRwJDjYVKchAo8McvF9zjZWAcNXuXcyOEMJQvk/wyM9NbJWjNpxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XWSA/VMJ; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XWSA/VMJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712064463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xzX+gZL9/KhMjnkbSvLboQKMddWxVBZs8UOodA2e+YA=;
	b=XWSA/VMJatrVF8cw00TRLRNsa978tFZXcVspKcHTk5s12n7gExqyC1321+X9XAG1wgIrjx
	v+N7WxYFeMwVaqMxVXD8NwJgc90jmlgauK9qvakT/wI1Oz3/za3MIHCyEnjaSDAKm5V6lq
	lxlbG7dFt2Q5yW4f1Y/C224b+L28bvk=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/2] arm/arm64: Use 'max' cpu and gic types
Date: Tue,  2 Apr 2024 15:27:40 +0200
Message-ID: <20240402132739.201939-5-andrew.jones@linux.dev>
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

v2:
 - Forgot to test with efi on v1 and testing now found an issue.
   Add a patch to allow '-cpu max', which has LPA2, to work with efi.

Andrew Jones (3):
  arm64: Prepare for LPA2
  arm/arm64: Use 'max' gic type
  arm64: Use 'max' cpu type

 arm/run                   |  8 +------
 configure                 |  2 +-
 lib/arm64/asm/processor.h | 49 +++++++++++++++++++++------------------
 3 files changed, 29 insertions(+), 30 deletions(-)

-- 
2.44.0


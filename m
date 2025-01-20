Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A041EB9F6
	for <kvmarm@lists.linux.dev>; Mon, 20 Jan 2025 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389919; cv=none; b=mL4AjI4Qn4YYM4q5dEu8bwm1LFDFf5yf2ECVoY73KtjJk7UXbTRlmz+3mVIDBCMNxbd8ZshbVo0et562pog65wp8eCzoPLBAjKhJxcUPHlyKXDCmmCV7kqfphzJ+H+2xPijFbUUoa33lezdUe4Xh/ZYuMwJL1HRBiCzdtMXTPHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389919; c=relaxed/simple;
	bh=vmWp/d3ggKFMlfuH8NdzhF5Bt/Nf1IIfjVydr8sC11E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IOM4BrkK1ZvrofYg6K+lZqtr2IzjceUrfvB6VWi4UjDsLdPTleqOuq+0/hgUIW050GRwrsDwbdOap00mpol2A7OdBppQD75jMOayK7j64KS1L7Cg4OFAyonF52ZUqTALLRkyrNRPFuFoRbBWOKWp/yChhYqaUZgtPoo4kCjF/z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74DD21063;
	Mon, 20 Jan 2025 08:19:00 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7C153F5A1;
	Mon, 20 Jan 2025 08:18:30 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: apatel@ventanamicro.com,
	andrew.jones@linux.dev,
	andre.przywara@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH kvmtool v1 0/2] Error handling fixes
Date: Mon, 20 Jan 2025 16:17:58 +0000
Message-ID: <20250120161800.30270-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two fixes for how kvmtool handles errors, both found while working on
integrating kvmtool with the kvm-unit-tests automatic test runner (patches
incoming).

The first patch is needed so kvm-unit-tests can detect when a test failed.

The second is just to make it easier to interpret a particular error message.

Alexandru Elisei (2):
  Propagate the error code from any VCPU thread
  Do not a print a warning on failing host<->guest address translation

 builtin-run.c         |  9 +++++----
 include/kvm/kvm-cpu.h |  2 +-
 kvm-cpu.c             | 17 ++++++++++-------
 kvm.c                 |  4 ++--
 4 files changed, 18 insertions(+), 14 deletions(-)


base-commit: 6d754d01fe2cb366f3b636d8a530f46ccf3b10d8
-- 
2.34.1


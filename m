Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5216131
	for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 03:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7wbfxMy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701228097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qn+4k3AM11LFL57uM6GEUi282zVBW5ZFN35fzgUwu4s=;
	b=H7wbfxMytQj+Spv3fLG/XCPGiD6gFpdamdKMEMH4hy0WlCytyxGFiMwDfDPldLdq6E6gF8
	V5PAw6bzlBSsKoQxS0ZAbZc/yZTXLVtvFrDr6GpiPzONsZrw/RTnHeTAzeeGO7esWCfa0y
	oYGcFfhqP13PhJ9OiUjQnfOx+Eg+1rg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-rcYgkwPFP7mWc4xYumLwag-1; Tue, 28 Nov 2023 22:21:31 -0500
X-MC-Unique: rcYgkwPFP7mWc4xYumLwag-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0A6180F82F;
	Wed, 29 Nov 2023 03:21:30 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66AD7492BFE;
	Wed, 29 Nov 2023 03:21:30 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Nico Boehr <nrb@linux.ibm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Ricardo Koller <ricarkol@google.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v1 0/3] arm64: runtime scripts improvements on efi
Date: Tue, 28 Nov 2023 22:21:20 -0500
Message-Id: <20231129032123.2658343-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

When I run the arm64 tests on efi, I found several runtime scripts issues. This
patch series try to fix all the issues.

The first patch add a missing error reporting.

The second patch skip the migration tests when run on efi since it will always
fail.

The thrid patch fix the issue when parallel running tests on efi.

Shaoqin Huang (3):
  runtime: Fix the missing last_line
  runtime: arm64: Skip the migration tests when run on EFI
  arm64: efi: Make running tests on EFI can be parallel

 arm/efi/run          | 16 +++++++++-------
 scripts/runtime.bash |  7 +++++++
 2 files changed, 16 insertions(+), 7 deletions(-)

-- 
2.40.1


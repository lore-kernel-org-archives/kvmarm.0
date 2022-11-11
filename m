Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A7B1B54A
	for <kvmarm@lists.linux.dev>; Fri, 11 Nov 2022 23:19:56 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668208794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U1SVQ+53JeaSnl/mk5LvPb98/eFUBJ5kc0qmJalJVWs=;
	b=KCkG+vpWHn6fOKTFYAqouxKFTb89yEJNg6JgS33w+TcJD3jPpaEufSv6ITxXslqTQSwp1d
	QTO5b/JXyQaucB4GtvkOcojBLdwAaupWTvUZ4dDkfaRCluFQ1VnUu19rgZWLyJPy6J3kQe
	864dtyWCUEPDGp3VmAZCZbHo5rx4Mkg=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: selftests: Enable access_tracking_perf_test for arm64
Date: Fri, 11 Nov 2022 23:19:44 +0000
Message-ID: <20221111231946.944807-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221111231944.kPfNXtdM--vgDNiWuK_JIxb60rI0haZTIg6p1xxsrZk@z>

Small series to add support for arm64 to access_tracking_perf_test.
Well, really this corrects a bug that is benign on x86, but you get the
point.

Tested on an Ampere Altra system w/ all supported guest modes for that
platform.

Oliver Upton (2):
  KVM: selftests: Allow >1 guest mode in access_tracking_perf_test
  KVM: selftests: Build access_tracking_perf_test for arm64

 tools/testing/selftests/kvm/Makefile                    | 1 +
 tools/testing/selftests/kvm/access_tracking_perf_test.c | 3 +++
 2 files changed, 4 insertions(+)


base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.38.1.431.g37b22c650d-goog


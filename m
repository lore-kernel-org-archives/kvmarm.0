Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BE2E818
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 08:35:11 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666946110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Yf+n15Bb2ai4QCnL88CYPPcwLq0iceY6iN9pF2k3P5Q=;
	b=j4kJJ3RLELiXfnfiOSev4HcPjbiLyo2ZYe9906cwpPEHi5GeHTEmxSnwfS96sVLJ7mjH1M
	UaQJZZS5mhInspdE4rPozTxnSUFZd4Se2DfO9BGIgRVW1UWkzvnbbQtjWa4twTwUAeFDEN
	JGF0EqGst0zc7IPKVcnxshyf3KI15Bo=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Quentin Perret <qperret@google.com>,
	kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: pKVM memory transitions cleanup
Date: Fri, 28 Oct 2022 08:34:46 +0000
Message-ID: <20221028083448.1998389-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221028083446.y5StoZSnUpbTAH1SEfUduz4HaWclSY3EQmY-WFaRNkA@z>

In order to help resolve my own bikeshedding on the outstanding pKVM
patches [1], small deck of patches to polish up the existing memory
transitions. Mainly:

 - Rejig the layout of pkvm_mem_transition
 - Stop using out pointers to get at the 'completer' addr
 - Use better-fitting terminology (source/target) to describe the
   addresses involved in a memory transition

Applies to 6.1-rc2. Politely compile tested, and that's just about it.

Oliver Upton (2):
  KVM: arm64: Clean out the odd handling of completer_addr
  KVM: arm64: Redefine pKVM memory transitions in terms of source/target

 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 124 +++++++++++---------------
 1 file changed, 52 insertions(+), 72 deletions(-)


base-commit: 247f34f7b80357943234f93f247a1ae6b6c3a740
-- 
2.38.1.273.g43a17bfeac-goog


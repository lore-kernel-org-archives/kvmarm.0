Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DEEF3D84
	for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 17:08:25 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 638A6FEC;
	Tue, 28 Feb 2023 09:09:02 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F2493F881;
	Tue, 28 Feb 2023 09:08:18 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v1 0/2] KVM: selftests: Fixes for broken tests
Date: Tue, 28 Feb 2023 17:07:54 +0000
Message-Id: <20230228170756.769461-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During the course of implementing FEAT_LPA2 within the arm64 KVM port, I found a
couple of issues within the KVM selftest code, which I thought were worth
posting independently. The LPA2 patches, for which I will post v2 in the next
few days, depend on these fixes for its testing.

Ryan Roberts (2):
  KVM: selftests: Fixup config fragment for access_tracking_perf_test
  KVM: selftests: arm64: Fix pte encode/decode for PA bits > 48

 tools/testing/selftests/kvm/config            |  1 +
 .../selftests/kvm/lib/aarch64/processor.c     | 32 ++++++++++++++-----
 2 files changed, 25 insertions(+), 8 deletions(-)

--
2.25.1


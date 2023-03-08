Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B9533DE
	for <kvmarm@lists.linux.dev>; Wed,  8 Mar 2023 11:10:21 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36EBE106F;
	Wed,  8 Mar 2023 03:10:59 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE95B3F71A;
	Wed,  8 Mar 2023 03:10:14 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 0/3] KVM: selftests: Fixes for broken tests
Date: Wed,  8 Mar 2023 11:09:45 +0000
Message-Id: <20230308110948.1820163-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Oliver,

Here is a respin of the KVM selftests fixes, with your nits addressed; I've
fixed the footer whitespace issue and I'm now using FIELD_GET() in the place
where you suggested and a couple of other places too. I've also included the 3rd
patch in this series (the ttbr0_el1 fix), which I originally sent separately -
this is now using FIELD_GET() too.

So this series superceeds [1] and [2].

Thanks,
Ryan

[1] https://lore.kernel.org/kvmarm/e8ed178a-0c67-3e00-a085-1d88fb3cb41f@arm.com/
[2] https://lore.kernel.org/kvmarm/20230302152033.242073-1-ryan.roberts@arm.com/

Ryan Roberts (3):
  KVM: selftests: Fixup config fragment for access_tracking_perf_test
  KVM: selftests: arm64: Fix pte encode/decode for PA bits > 48
  KVM: selftests: arm64: Fix ttbr0_el1 encoding for PA bits > 48

 tools/testing/selftests/kvm/config            |  1 +
 .../selftests/kvm/lib/aarch64/processor.c     | 39 ++++++++++++++-----
 2 files changed, 30 insertions(+), 10 deletions(-)

--
2.25.1


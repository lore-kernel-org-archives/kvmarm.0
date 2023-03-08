Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11FAC33DE
	for <kvmarm@lists.linux.dev>; Wed,  8 Mar 2023 11:10:23 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7283A113E;
	Wed,  8 Mar 2023 03:11:00 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F170C3F71A;
	Wed,  8 Mar 2023 03:10:15 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 1/3] KVM: selftests: Fixup config fragment for access_tracking_perf_test
Date: Wed,  8 Mar 2023 11:09:46 +0000
Message-Id: <20230308110948.1820163-2-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308110948.1820163-1-ryan.roberts@arm.com>
References: <20230308110948.1820163-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

access_tracking_perf_test requires CONFIG_IDLE_PAGE_TRACKING. However
this is missing from the config fragment, so add it in so that this test
is no longer skipped.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 tools/testing/selftests/kvm/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/config b/tools/testing/selftests/kvm/config
index d011b38e259e..8835fed09e9f 100644
--- a/tools/testing/selftests/kvm/config
+++ b/tools/testing/selftests/kvm/config
@@ -2,3 +2,4 @@ CONFIG_KVM=y
 CONFIG_KVM_INTEL=y
 CONFIG_KVM_AMD=y
 CONFIG_USERFAULTFD=y
+CONFIG_IDLE_PAGE_TRACKING=y
-- 
2.25.1


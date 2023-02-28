Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341E73D84
	for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 17:08:36 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FED4C14;
	Tue, 28 Feb 2023 09:09:18 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DADE3F881;
	Tue, 28 Feb 2023 09:08:34 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v1 1/2] KVM: selftests: Fixup config fragment for access_tracking_perf_test
Date: Tue, 28 Feb 2023 17:07:55 +0000
Message-Id: <20230228170756.769461-2-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230228170756.769461-1-ryan.roberts@arm.com>
References: <20230228170756.769461-1-ryan.roberts@arm.com>
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


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACF43C15
	for <kvmarm@lists.linux.dev>; Fri, 28 Apr 2023 12:05:20 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C68B715A1;
	Fri, 28 Apr 2023 05:06:04 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4DCF3F5A1;
	Fri, 28 Apr 2023 05:05:19 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	pbonzini@redhat.com,
	ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 28/29] lib: arm: Print test exit status
Date: Fri, 28 Apr 2023 13:04:04 +0100
Message-Id: <20230428120405.3770496-29-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

The arm tests can be run under kvmtool, which doesn't emulate a chr-testdev
device. Print the test exit status to make it possible for the runner
scripts to pick it up when they have support for it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index 19f93490..c15e57c4 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -149,6 +149,13 @@ extern void halt(int code);
 
 void exit(int code)
 {
+	/*
+	 * Print the test return code in the following format which is
+	 * consistent with powerpc and s390x. The runner can pick it
+	 * up when chr-testdev is not present.
+	 */
+	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
+
 	chr_testdev_exit(code);
 	psci_system_off();
 	halt(code);
-- 
2.25.1


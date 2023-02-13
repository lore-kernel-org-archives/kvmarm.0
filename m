Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14ADA256A
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:18:38 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E6561FC4;
	Mon, 13 Feb 2023 02:19:20 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AC643F703;
	Mon, 13 Feb 2023 02:18:36 -0800 (PST)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	pbonzini@redhat.com,
	ricarkol@google.com
Subject: [PATCH v4 29/30] lib: arm: Print test exit status
Date: Mon, 13 Feb 2023 10:17:58 +0000
Message-Id: <20230213101759.2577077-30-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
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


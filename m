Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9CF33D5
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 17:59:29 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D13782B;
	Fri, 27 Jan 2023 10:00:10 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B5BB3F5A1;
	Fri, 27 Jan 2023 09:59:28 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v5 0/2] arm: Add PSCI CPU_OFF test
Date: Fri, 27 Jan 2023 17:59:14 +0000
Message-Id: <20230127175916.65389-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The series adds a test for the PSCI function CPU_OFF. The test is
implemented in patch #2, "arm/psci: Add PSCI CPU_OFF test case".  Patch #1,
"arm/psci: Test that CPU 1 has been successfully brought online" is a
preparatory patch to allow the CPU_OFF test to run after the CPU_ON test.
Executing the CPU_OFF test after the CPU_ON test makes the most sense,
since CPU_OFF requires all the CPUs to be brought online before the test
can execute, and this is exactly what the CPU_ON test does.

I believe that proving that a CPU has been successfully offlined is an
undecidable problem - it might just be that the CPU is stuck at a higher
exception level doing something else entirely, and if the test were to wait
long enough, the CPU would return from the CPU_OFF call and start executing
code, thus failing to be offlined. Right now, the test waits for 100ms
after checking that all the other CPUs are offline. I thought this was a
good balance between making the test fast and being reasonably sure that
the offline succeeded. I'm open to suggestions here if anyone thinks
otherwise.

Tested for both the arm and arm64 architectures: on an x86 machine (qemu
with TCG), and a rockpro64 (qemu and kvmtool).

And Nikita is not longer at Arm, and I don't have a new email address where
she can be reached, so I didn't CC her.

Changelog:

v4 -> v5:
- Open code smp_prepare_secondary in psci.c instead of exposing it as a
  library function in the cpu_on test (Drew).
- Don't return early if a CPU failed to online CPU1 in the cpu_on test, and
  check the return values for the CPUs that succeeded to online CPU 1
  (Drew).
- Drop cpu_off_success in the cpu_off test in favour of checking
  AFFINITY_INFO and the cpu idle mask (Drew).
- Hopefully made the cpu_off test faster (Drew).

v3 -> v4:
- Moved ownership of the series to Alexandru Elisei. All bugs are mine.
- Moved the timeout for the CPU_ON test to patch #1.
- Changed the include order for arm/psic.c in patch #1 to order the headers
  alphabetically.
- Run the CPU_OFF test only if CPU_ON succeeds, because CPU_OFF expects all
  CPUs to be online, the test would otherwise hang forever.
- Minor style changes here and there.

v2 -> v3:
- Add timeout so that test does not hang if CPU1 fails to come online
- Remove unnecessary call of on_cpus() in the condition where target CPU is not online.

v1 -> v2:
- Modify PSCI CPU_ON test to ensure CPU 1 remains online after the execution of the test.
- Addition of PSCI CPU_OFF test and calling it after PSCI CPU_ON test has been executed.

Alexandru Elisei (1):
  arm/psci: Test that CPU 1 has been successfully brought online

Nikita Venkatesh (1):
  arm/psci: Add PSCI CPU_OFF test case

 arm/psci.c        | 132 +++++++++++++++++++++++++++++++++++++++-------
 lib/arm/asm/smp.h |   1 +
 lib/arm/smp.c     |  12 +++--
 lib/errata.h      |   2 +
 4 files changed, 125 insertions(+), 22 deletions(-)


base-commit: 2480430a36102f8ea276b3bfb1d64d5dacc23b8f
-- 
2.25.1


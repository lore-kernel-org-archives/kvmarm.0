From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/2] arm64: PMU: Sanitize usage of PMSELR_EL0.SEL
Date: Fri,  2 Dec 2016 15:50:57 +0000
Message-ID: <1480693859-27249-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B785640822
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2016 10:50:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PGD7Fo+zurL6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2016 10:50:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E57140796
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2016 10:50:28 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Itaru Kitayama <itaru.kitayama@riken.jp>, Catalin Marinas <catalin.marinas@arm.com>, Hoan Tran <hotran@apm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Tai Tri Nguyen <ttnguyen@apm.com>
List-Id: kvmarm@lists.cs.columbia.edu

An ugly interaction between the use of PMSELR_EL0 in a host kernel and
the use of PMXEVCNTR_EL0 in a guest has recently come to light [1],
leading to the guest taking an UNDEF exception in EL1 when using the
PMU.

The fix is pretty simple ("don't do that!"), making the PMU useable on
X-Gene, which seems to have a stricter (but nonetheless valid)
interpretation of the architecture.

Patches against 4.9-rc6.

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-November/022545.html

Marc Zyngier (2):
  arm64: PMU: Do not use PMSELR_EL0 to access PMCCFILTR_EL0
  arm64: PMU: Reset PMSELR_EL0 to a sane value at boot time

 arch/arm64/kernel/perf_event.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

-- 
2.1.4

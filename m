From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL 0/1] KVM/arm updates for 4.19-rc8
Date: Tue,  9 Oct 2018 13:26:10 +0100
Message-ID: <20181009122611.85534-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EDBC4A2A9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Oct 2018 08:26:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a0iMocN2KqOy for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Oct 2018 08:26:23 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62A1F4A1DC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Oct 2018 08:26:23 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

This is hopefully the last 4.19 update for KVM/arm. A single patch,
but one that fixes a rather silly 32bit bug (which I thought I had
fixed before sending the original 4.19 PR, but obviously didn't).

Please pull,

	M.

The following changes since commit 7876320f88802b22d4e2daf7eb027dd14175a0f8:

  Linux 4.19-rc4 (2018-09-16 11:52:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-4.19-2

for you to fetch changes up to ec876f4b252c4084acad259ce3e65ad97f44f040:

  ARM: KVM: Correctly order SGI register entries in the cp15 array (2018-10-09 11:55:47 +0100)

----------------------------------------------------------------
KVM/arm fixes for 4.19, take #2

- Correctly order GICv3 SGI registers in the cp15 array

----------------------------------------------------------------
Marc Zyngier (1):
      ARM: KVM: Correctly order SGI register entries in the cp15 array

 arch/arm/kvm/coproc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

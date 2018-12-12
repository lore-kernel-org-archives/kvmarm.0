From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 0/2] Fix KVM_GET_REG_LIST invalid register ID regression
Date: Wed, 12 Dec 2018 20:17:02 +0000
Message-ID: <1544645824-16461-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 955F24A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 15:17:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wusJp90zB9XZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 15:17:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 906584A1DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 15:17:15 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
that do not correspond to a single underlying architectural register.

This series proposed a fix for this regression along with some related
refactoring.

Comments welcome.

This series now looks straightforward, but has only been build-tested
so far.


Dave Martin (2):
  KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST
  KVM: arm64: Factor out KVM_GET_REG_LIST core register enumeration

 arch/arm64/kvm/guest.c | 74 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 62 insertions(+), 12 deletions(-)

-- 
2.1.4

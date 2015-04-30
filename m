From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCHv2 0/2] KVM: micro-optimization and interrupt disabling
Date: Thu, 30 Apr 2015 13:43:29 +0200
Message-ID: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22B2B4EFDF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 07:35:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jEFlHRauOBWA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2015 07:35:07 -0400 (EDT)
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40FB84EFDC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 07:35:06 -0400 (EDT)
Received: from /spool/local
 by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <borntraeger@de.ibm.com>;
 Thu, 30 Apr 2015 12:43:36 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com
 (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
 by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2DB7D219005C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 12:43:17 +0100 (BST)
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com
 [9.149.37.213])
 by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t3UBhY1c131432
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 11:43:34 GMT
Received: from d06av03.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av03.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t3UBhXKV004554
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 05:43:34 -0600
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-mips@linux-mips.org, KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cornelia.huck@de.ibm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This rework allows to avoid some cycles by not disabling interrupts
twice.

Christian Borntraeger (2):
  KVM: provide irq_unsafe kvm_guest_{enter|exit}
  KVM: arm/mips/x86/power use __kvm_guest_{enter|exit}

 arch/arm/kvm/arm.c         |  4 ++--
 arch/mips/kvm/mips.c       |  4 ++--
 arch/powerpc/kvm/powerpc.c |  2 +-
 arch/s390/kvm/kvm-s390.c   | 10 ++++++----
 arch/x86/kvm/x86.c         |  2 +-
 include/linux/kvm_host.h   | 27 ++++++++++++++++++---------
 6 files changed, 30 insertions(+), 19 deletions(-)

-- 
2.3.0

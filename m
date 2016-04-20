From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] arm64: KVM: Allow userspace to configure guest
 MPIDR_EL1
Date: Wed, 20 Apr 2016 18:33:54 +0100
Message-ID: <20160420183354.31f1bfbd@arm.com>
References: <1461161319-38835-1-git-send-email-ashoks@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F07D5407A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 13:32:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s3zVh1IDYcMs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2016 13:32:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84F1A407A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 13:32:03 -0400 (EDT)
In-Reply-To: <1461161319-38835-1-git-send-email-ashoks@broadcom.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ashok Kumar <ashoks@broadcom.com>
Cc: will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 20 Apr 2016 07:08:39 -0700
Ashok Kumar <ashoks@broadcom.com> wrote:

> For guests with NUMA configuration, Node ID needs to
> be recorded in the respective affinity byte of MPIDR_EL1.

As others have said before, the mapping between the NUMA hierarchy and
MPIDR_EL1 are completely arbitrary, and only the firmware description
can help the kernel in interpreting the affinity levels.

If you want any patch like this one to be considered, I'd like to see
the corresponding userspace that:

- programs the affinity into the vcpus,
- pins the vcpus to specific physical CPUs,
- exposes the corresponding firmware description (either DT or ACPI) to
  the kernel.

Short of having all these elements together, there is little point in
letting userspace messing with the guest's affinity registers.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.

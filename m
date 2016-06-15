From: ib10evp0@gmx.org
Subject: Re: Status of live migration on ARMv7
Date: Wed, 15 Jun 2016 09:57:38 +0200
Message-ID: <trinity-6221473b-321b-46e3-96bb-352ca845b317-1465977458891@3capp-gmx-bs76>
References: <trinity-d5cbcace-be15-4c67-b55c-1a70d1fb7c21-1465735240100@3capp-gmx-bs77>
 <20160614202025.226dd45d@arm.com>
 <trinity-6f860951-3365-4cc6-986a-3b19853fd387-1465937561349@3capp-gmx-bs24>,
 <20160614220940.171387d5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 564BC48529
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2016 03:53:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ETnE0NtnRQvr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jun 2016 03:53:08 -0400 (EDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1907849B2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2016 03:53:07 -0400 (EDT)
In-Reply-To: <20160614220940.171387d5@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc.

> I know it is available because I did review the code. Look for commits
> 
> 7276030 KVM: arm/arm64: Enable Dirty Page logging for ARMv8
> 15a49a4 KVM: arm: page logging 2nd stage fault handling
> 53c810c KVM: arm: dirty logging write protect support
> c647355 KVM: arm: Add initial dirty page locking support
> 
> as well as the generic infrastructure that precede them.

Thanks for your detailed response. It's all clear now.

Regards

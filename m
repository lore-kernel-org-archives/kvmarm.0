From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v8 01/16] FDT: introduce global phandle allocation
Date: Tue, 20 Dec 2016 10:43:39 +0100
Message-ID: <20161220094339.6yg624kev2wqxidt@kamzik.brq.redhat.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
 <20161104173203.21168-2-andre.przywara@arm.com>
 <be44a9ad-f820-9a62-9a5d-682867674e91@arm.com>
 <80430161-b363-4740-0eef-8cb73bc2ecbd@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0AEA4044D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2016 04:42:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6RunVDfKDGyR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Dec 2016 04:42:28 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2A9B40419
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2016 04:42:28 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <80430161-b363-4740-0eef-8cb73bc2ecbd@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 19, 2016 at 06:43:29PM +0000, Andre Przywara wrote:
> Well, yes. The problem is that AFAIK you cannot initialize an array
> easily with all the values getting set to something other than zero.

u32 phandles[PHANDLES_MAX] = { [0 ... PHANDLES_MAX-1] = FDT_INVALID_PHANDLE };

(Unrelated, but could you please add format.subjectprefix = PATCH kvmtool
 to your git config. I just suggested via a kvmtool README patch...)

Thanks,
drew

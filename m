From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 1/2] arm64: KVM: Optimize arm64 skip 30-50% vfp/simd
 save/restore on exits
Date: Wed, 19 Aug 2015 23:28:39 +0100
Message-ID: <20150819232839.69531eca@arm.com>
References: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
 <1437082178-11039-2-git-send-email-m.smarduch@samsung.com>
 <55C235B9.3000800@arm.com> <20150819174958.GA11518@cbox>
 <55D4FA88.5060305@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D33025CAE7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2015 18:15:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id so-nHp8qepRS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2015 18:15:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB0365CAE1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2015 18:15:29 -0400 (EDT)
In-Reply-To: <55D4FA88.5060305@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 19 Aug 2015 14:52:08 -0700
Mario Smarduch <m.smarduch@samsung.com> wrote:

> Hi Christoffer,
>    I'll test it and work with it.

FWIW, I've added these patches to both -queue and -next, and from the
tests Christoffer has run, it looks pretty good.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.

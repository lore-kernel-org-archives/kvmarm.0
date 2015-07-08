From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 08/11] KVM: arm: implement dirty bit mechanism for
 debug registers
Date: Wed, 8 Jul 2015 18:08:55 +0100
Message-ID: <20150708170855.GB6348@arm.com>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
 <1434969694-7432-9-git-send-email-zhichao.huang@linaro.org>
 <20150630092020.GP11332@cbox>
 <B3B5AB0D-020C-483D-A6DE-76E355865010@linaro.org>
 <20150703115611.GB14220@lvm>
 <5A7DE9A0-E7A6-40B0-80F9-896F7DED0E47@linaro.org>
 <20150707102405.GE23879@arm.com>
 <123AABA4-2C79-462D-91FC-56FB52DB972C@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 289F058163
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:57:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kNdl8LCarUQ8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 12:57:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F24AF5815C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:57:26 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <123AABA4-2C79-462D-91FC-56FB52DB972C@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "huangzhichao@huawei.com" <huangzhichao@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 08, 2015 at 11:50:22AM +0100, Zhichao Huang wrote:
> Are you happy with this?:

You miss the reserved breakpoint, I think.
I also still don't understand why this is preferable to trapping.

Will

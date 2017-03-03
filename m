From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH kvm-unit-tests v2 0/2] arm/arm64: introduce PSCI tests
Date: Fri, 3 Mar 2017 15:36:26 +0100
Message-ID: <20170303143625.GB23831@potion>
References: <20170303143057.27275-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF91E40C1C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Mar 2017 09:35:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FbYQMEZSTKSw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Mar 2017 09:35:15 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B73D40A54
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Mar 2017 09:35:14 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170303143057.27275-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Applied, thanks.


2017-03-03 15:30+0100, Andrew Jones:
> Andrew Jones (1):
>   arm/arm64: psci: support testing tcg
> 
> Levente Kurusa (1):
>   arm/arm64: Add PSCI tests
> 
>  arm/Makefile.common |   1 +
>  arm/psci.c          | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg   |   6 +++
>  3 files changed, 157 insertions(+)
>  create mode 100644 arm/psci.c
> 
> -- 
> 2.9.3
> 

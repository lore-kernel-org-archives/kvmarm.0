Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA56C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 18:36:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0790549ED7;
	Fri, 22 Apr 2022 14:36:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MZuR5MCWZ-B0; Fri, 22 Apr 2022 14:36:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB86D4B125;
	Fri, 22 Apr 2022 14:36:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B4714B106
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:36:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3YisZGoniLt0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 14:36:08 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74C8E4B103
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:36:08 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 32E46B8321E;
 Fri, 22 Apr 2022 18:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269B7C385A4;
 Fri, 22 Apr 2022 18:36:02 +0000 (UTC)
Date: Fri, 22 Apr 2022 19:35:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v14 00/39] arm64/sme: Initial support for the Scalable
 Matrix Extension
Message-ID: <YmL1j9KH7nRVUYih@arm.com>
References: <20220419112247.711548-1-broonie@kernel.org>
 <65c761cedb3b6e56f4a03fd196a3a767@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <65c761cedb3b6e56f4a03fd196a3a767@kernel.org>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Will Deacon <will@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Apr 22, 2022 at 06:10:27PM +0100, Marc Zyngier wrote:
> On 2022-04-19 12:22, Mark Brown wrote:
> > This series provides initial support for the ARMv9 Scalable Matrix
> > Extension (SME).  SME takes the approach used for vectors in SVE and
> > extends this to provide architectural support for matrix operations.  A
> > more detailed overview can be found in [1].
> 
> For the KVM patches:
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> 
> Catalin: the KVM patches are likely to slash a bit with the
> WFxT stuff as well. It'd be good to swap stable branches!

I queued patches 3-27 on the arm64 for-next/sme, the rest went on the
for-next/kselftest branch but b4 didn't handle this well.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

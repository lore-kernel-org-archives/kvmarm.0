Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03513C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 17:09:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 784E849F11;
	Wed,  2 Mar 2022 12:09:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EQSWO1t1OIYX; Wed,  2 Mar 2022 12:09:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8A349F0E;
	Wed,  2 Mar 2022 12:09:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98AC649F0E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:09:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SI7XwdOgO7Aq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 12:09:41 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7048649F04
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:09:41 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 00CBCB82106;
 Wed,  2 Mar 2022 17:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D45C004E1;
 Wed,  2 Mar 2022 17:09:35 +0000 (UTC)
Date: Wed, 2 Mar 2022 17:09:32 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 20/40] arm64/sme: Implement streaming SVE signal
 handling
Message-ID: <Yh+kzH88WFFNde4r@arm.com>
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-21-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220225165923.1474372-21-broonie@kernel.org>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

On Fri, Feb 25, 2022 at 04:59:03PM +0000, Mark Brown wrote:
> When in streaming mode we have the same set of SVE registers as we do in
> regular SVE mode with the exception of FFR and the use of the SME vector
> length. Provide signal handling for these registers by taking one of the
> reserved words in the SVE signal context as a flags field and defining a
> flag which is set for streaming mode. When the flag is set the vector
> length is set to the streaming mode vector length and we save and
> restore streaming mode data. We support entering or leaving streaming
> mode based on the value of the flag but do not support changing the
> vector length, this is not currently supported SVE signal handling.
> 
> We could instead allocate a separate record in the signal frame for the
> streaming mode SVE context but this inflates the size of the maximal signal
> frame required and adds complication when validating signal frames from
> userspace, especially given the current structure of the code.
> 
> Any implementation of support for streaming mode vectors in signals will
> have some potential for causing issues for applications that attempt to
> handle SVE vectors in signals, use streaming mode but do not understand
> streaming mode in their signal handling code, it is hard to identify a
> case that is clearly better than any other - they all have cases where
> they could cause unexpected register corruption or faults.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

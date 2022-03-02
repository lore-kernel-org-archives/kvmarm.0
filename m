Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EACEC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 17:11:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B29EB40D26;
	Wed,  2 Mar 2022 12:11:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GlvegVM7t+Bv; Wed,  2 Mar 2022 12:11:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8632140C1B;
	Wed,  2 Mar 2022 12:11:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBAB340C1B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:11:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O+-4BZ+EL3CD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 12:11:34 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B580740B03
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:11:34 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id F1BEAB82109;
 Wed,  2 Mar 2022 17:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8DEC340ED;
 Wed,  2 Mar 2022 17:11:28 +0000 (UTC)
Date: Wed, 2 Mar 2022 17:11:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 22/40] arm64/sme: Implement ptrace support for
 streaming mode SVE registers
Message-ID: <Yh+lPT/TJ4FQfIJ+@arm.com>
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-23-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220225165923.1474372-23-broonie@kernel.org>
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

On Fri, Feb 25, 2022 at 04:59:05PM +0000, Mark Brown wrote:
> The streaming mode SVE registers are represented using the same data
> structures as for SVE but since the vector lengths supported and in use
> may not be the same as SVE we represent them with a new type NT_ARM_SSVE.
> Unfortunately we only have a single 16 bit reserved field available in
> the header so there is no space to fit the current and maximum vector
> length for both standard and streaming SVE mode without redefining the
> structure in a way the creates a complicatd and fragile ABI. Since FFR
> is not present in streaming mode it is read and written as zero.
> 
> Setting NT_ARM_SSVE registers will put the task into streaming mode,
> similarly setting NT_ARM_SVE registers will exit it. Reads that do not
> correspond to the current mode of the task will return the header with
> no register data. For compatibility reasons on write setting no flag for
> the register type will be interpreted as setting SVE registers, though
> users can provide no register data as an alternative mechanism for doing
> so.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

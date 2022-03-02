Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8D6C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 17:23:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D75340256;
	Wed,  2 Mar 2022 12:23:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pMr2jvexvVsC; Wed,  2 Mar 2022 12:23:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88A9349E33;
	Wed,  2 Mar 2022 12:23:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E93C49E10
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:23:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bT8F29hmJmXm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 12:23:29 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37C9B40256
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:23:29 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 5E39BB8211A;
 Wed,  2 Mar 2022 17:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4782EC004E1;
 Wed,  2 Mar 2022 17:23:23 +0000 (UTC)
Date: Wed, 2 Mar 2022 17:23:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <Yh+oB9y0Y1qFv18U@arm.com>
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-7-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220225165923.1474372-7-broonie@kernel.org>
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

On Fri, Feb 25, 2022 at 04:58:49PM +0000, Mark Brown wrote:
> +4.  System call behaviour
> +-------------------------
> +
> +* On syscall PSTATE.ZA is preserved, if PSTATE.ZA==1 then the contents of the
> +  ZA matrix are preserved.
> +
> +* On syscall PSTATE.SM will be cleared and the SVE registers will be handled
> +  as normal.
> +
> +* Neither the SVE registers nor ZA are used to pass arguments to or receive
> +  results from any syscall.
> +
> +* On creation fork() or clone() the newly created process will have PSTATE.SM
> +  and PSTATE.ZA cleared.

Nitpick: I'd drop fork() from here as we don't implement the syscall on
arm64 and maybe just use clone() as an example, something like: "On
process creation (e.g. clone()), the newly created ...".

Otherwise the ABI looks fine to me, though I'd like the Szabolcs and
Luis to ack from the glibc/gdb side.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

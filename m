Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D2BC04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 17:45:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F604CA22;
	Wed, 27 Jul 2022 13:45:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2mvXefICm9fo; Wed, 27 Jul 2022 13:45:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 941914CA24;
	Wed, 27 Jul 2022 13:45:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 271444CA1F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 13:45:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j0JedYZZfduf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 13:44:59 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3DB44CA21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 13:44:59 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B9FBA61884;
 Wed, 27 Jul 2022 17:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A19C433C1;
 Wed, 27 Jul 2022 17:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658943898;
 bh=AWPi2RklWEjJYdEzBQpvRo0y/4ESXyMm2zfHiG6ND9g=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=etgrUijw96ihMWnWUPv3FzrcFwxEpRCLr+oOGWV72DLbEwxwtQoDFJM2MeWFySaPz
 VOKAb1tMManT0QS58XVOGXyj9H0HwmLcEWPFE0ZEhzvjaSYj+yuU0h6DIGWD/wdTUY
 QohUfPXgUiTr4YYnUsJ8JZ6f0CDJkba73puBdNfNaYBF3QRpvNbQ6SULjYluTHjVw9
 PCOgvcY43jreB4bOKDQRGIRcGzD0xcub70nrEW6QcXwulyfR8oghe+BEMQs3fZM9rz
 GupPSX/fAsMDZKY6sD2oyk3LG3L7A//Q4t8iqRIM5W+iXv/s8UU2Oo7/u9gXWVVYmJ
 97ORi+2uluY0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oGl5c-00ATqn-6O;
 Wed, 27 Jul 2022 18:44:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: tabba@google.com, oliver.upton@linux.dev, broonie@kernel.org,
 Kalesh Singh <kaleshsingh@google.com>, mark.rutland@arm.com,
 madvenka@linux.microsoft.com
Subject: Re: [PATCH v6 00/17] KVM nVHE Hypervisor stack unwinder
Date: Wed, 27 Jul 2022 18:44:53 +0100
Message-Id: <165894387426.1300284.3994289980983137161.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
References: <20220726073750.3219117-1-kaleshsingh@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tabba@google.com, oliver.upton@linux.dev, broonie@kernel.org,
 kaleshsingh@google.com, mark.rutland@arm.com, madvenka@linux.microsoft.com,
 andreyknvl@gmail.com, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 wangkefeng.wang@huawei.com, catalin.marinas@arm.com, vincenzo.frascino@arm.com,
 ast@kernel.org, kernel-team@android.com, elver@google.com, mhiramat@kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 android-mm@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: android-mm@google.com, wangkefeng.wang@huawei.com, kernel-team@android.com,
 catalin.marinas@arm.com, elver@google.com, ast@kernel.org,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org, vincenzo.frascino@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com
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

On Tue, 26 Jul 2022 00:37:33 -0700, Kalesh Singh wrote:
> This is v6 of nVHE stacktrace support. The series is based on
> arm64 for-next/stacktrace.
> 
> The previous versions were posted at:
> v5: https://lore.kernel.org/r/20220721055728.718573-1-kaleshsingh@google.com/
> v4: https://lore.kernel.org/r/20220715061027.1612149-1-kaleshsingh@google.com/
> v3: https://lore.kernel.org/r/20220607165105.639716-1-kaleshsingh@google.com/
> v2: https://lore.kernel.org/r/20220502191222.4192768-1-kaleshsingh@google.com/
> v1: https://lore.kernel.org/r/20220427184716.1949239-1-kaleshsingh@google.com/
> 
> [...]

Applied to next, thanks!

[01/17] arm64: stacktrace: Add shared header for common stack unwinding code
        commit: 6bf212c89c48458d8deef1c973678c62528dab04
[02/17] arm64: stacktrace: Factor out on_accessible_stack_common()
        commit: 15a59f19a015185bff90a68f601caec151dea4b4
[03/17] arm64: stacktrace: Factor out unwind_next_common()
        commit: be63c647fd28d25484257f5f36a008db7d99991d
[04/17] arm64: stacktrace: Handle frame pointer from different address spaces
        commit: 5b1b08619f50422c3e43d1fd7af257595a9e4a67
[05/17] arm64: stacktrace: Factor out common unwind()
        commit: f51e7146740514347d6c5526a2c393e224a19c0d
[06/17] arm64: stacktrace: Add description of stacktrace/common.h
        commit: 051ece6758cc10c2a6f1700ffe86d23fbb0b2553
[07/17] KVM: arm64: On stack overflow switch to hyp overflow_stack
        commit: 548ec3336f323db56260b312c232ab37285f0284
[08/17] KVM: arm64: Stub implementation of non-protected nVHE HYP stack unwinder
        commit: 573e1e8275f7167ddd533c6e4e0f500f8be4d974
[09/17] KVM: arm64: Prepare non-protected nVHE hypervisor stacktrace
        commit: 879e5ac7b2e4db05799a905b5a07fc9e5dedf651
[10/17] KVM: arm64: Implement non-protected nVHE hyp stack unwinder
        commit: db129d486ebdf4e3168282236f9d9008b42cac7e
[11/17] KVM: arm64: Introduce hyp_dump_backtrace()
        commit: 314a61dc31845c233e47c53db3fe6f34284034f4
[12/17] KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
        commit: 72adac1bd234002a65cef738e0eebfd6c2ce2e30
[13/17] KVM: arm64: Allocate shared pKVM hyp stacktrace buffers
        commit: 6928bcc84bc4bd9a24a1cb1986418c3de76e1d99
[14/17] KVM: arm64: Stub implementation of pKVM HYP stack unwinder
        commit: 25aa73b6db1831527cd4f14bf0ddf8dceadec802
[15/17] KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
        commit: 871c5d931417d3c0e1aa32c9e04da1dc74703843
[16/17] KVM: arm64: Implement protected nVHE hyp stack unwinder
        commit: 75e9459e48d4867caf549e388bd4faabe1dbcbd3
[17/17] KVM: arm64: Introduce pkvm_dump_backtrace()
        commit: 3a7e1b55aad45c0cf86bd4e2f212bb9a61905142

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

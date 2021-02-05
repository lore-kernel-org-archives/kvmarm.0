Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDE8C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 14:05:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DFD164FCC
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 14:05:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DFD164FCC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=marcan.st
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 919444B3EF;
	Fri,  5 Feb 2021 09:05:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CzYF3mUpcaqF; Fri,  5 Feb 2021 09:05:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83E634B3E1;
	Fri,  5 Feb 2021 09:05:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 349084B3CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 07:01:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8gm9n8Qnw9pG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 07:01:54 -0500 (EST)
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A91854B390
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 07:01:54 -0500 (EST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (4096 bits))
 (No client certificate requested)
 (Authenticated sender: marcan@marcan.st)
 by mail.marcansoft.com (Postfix) with ESMTPSA id 7297B42056;
 Fri,  5 Feb 2021 12:01:48 +0000 (UTC)
Subject: Re: [PATCH v6 05/21] arm64: Initialise as nVHE before switching to VHE
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
References: <20210201115637.3123740-1-maz@kernel.org>
 <20210201115637.3123740-6-maz@kernel.org>
From: Hector Martin 'marcan' <marcan@marcan.st>
Message-ID: <1dbffcd4-5b20-404c-94af-c985a96785e2@marcan.st>
Date: Fri, 5 Feb 2021 21:01:46 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210201115637.3123740-6-maz@kernel.org>
Content-Language: es-ES
X-Mailman-Approved-At: Fri, 05 Feb 2021 09:05:24 -0500
Cc: kernel-team@android.com, Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Will Deacon <will@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Prasad Sodagudi <psodagud@codeaurora.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 01/02/2021 20.56, Marc Zyngier wrote:
> As we are aiming to be able to control whether we enable VHE or
> not, let's always drop down to EL1 first, and only then upgrade
> to VHE if at all possible.
> 
> This means that if the kernel is booted at EL2, we always start
> with a nVHE init, drop to EL1 to initialise the the kernel, and
> only then upgrade the kernel EL to EL2 if possible (the process
> is obviously shortened for secondary CPUs).

Unfortunately, this is going to break on Apple SoCs, where it turns out 
HCR_EL2.E2H is hard-wired to 1 - there is no nVHE mode. :(

 >>> mrs(HCR_EL2) & (1<<34)
0x400000000
 >>> msr(HCR_EL2, mrs(HCR_EL2) & ~(1<<34))
 >>> mrs(HCR_EL2) & (1<<34)
0x400000000

-- 
Hector Martin "marcan" (marcan@marcan.st)
Public Key: https://mrcn.st/pub
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

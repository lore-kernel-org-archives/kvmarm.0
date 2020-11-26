Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1276C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 16:20:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41575207BC
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 16:20:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbY5++SR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41575207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0DAF4BF8D;
	Thu, 26 Nov 2020 11:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XxVm7W1R95aP; Thu, 26 Nov 2020 11:20:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C79FC4BEAF;
	Thu, 26 Nov 2020 11:20:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 662154BEAD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 11:20:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VD6KPeYoUwFC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 11:19:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8290E4BEAC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 11:19:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4D1E4207BC;
 Thu, 26 Nov 2020 16:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606407598;
 bh=ndZG1t6GX24rtYFtgwoylSOLLR+0rulFS7DxFgbvXNo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=gbY5++SR3vNOtbMoB4xpEm/VEC6LVzSf4wFcDTs8Ksqjw7lWuG8ErnYiM88/diAgh
 CwFHY46uwK1EMJOBTB+X0eW8BflTc4pPNZJzZL/R4rwtmB3zk81GFcfjjWlvtsGzMV
 ITl065COD8OebFRSGxHoiQDl1Q1CKrjCt/ES4hKk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kiJzw-00Dr0o-2I; Thu, 26 Nov 2020 16:19:56 +0000
MIME-Version: 1.0
Date: Thu, 26 Nov 2020 16:19:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 00/23] Opt-in always-on nVHE hypervisor
In-Reply-To: <20201126155746.GU4327@casper.infradead.org>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155746.GU4327@casper.infradead.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <6a2a14af06232cdf2f5146cd8ec6fc35@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: willy@infradead.org, dbrazdil@google.com,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, dennis@kernel.org, tj@kernel.org, cl@linux.com,
 mark.rutland@arm.com, lorenzo.pieralisi@arm.com, sudeep.holla@arm.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 2020-11-26 15:57, Matthew Wilcox wrote:
> On Thu, Nov 26, 2020 at 03:53:58PM +0000, David Brazdil wrote:
>> The hypervisor starts trapping host SMCs and intercepting host's PSCI
>> CPU_ON/SUSPEND calls. It replaces the host's entry point with its own,
>> initializes the EL2 state of the new CPU and installs the nVHE hyp 
>> vector
>> before ERETing to the host's entry point.
> 
> I hate CPU people.  This is complete gibberish to anyone who doesn't
> already have their head deep in ... whatever you're talking about.

What I hate the most is people having a go at other people because they
don't understand what is being discussed. Who is at fault there?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

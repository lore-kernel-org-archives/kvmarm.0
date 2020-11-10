Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A9BC4742C
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 11:19:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 15BD320659
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 11:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yeQSXFy2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15BD320659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8738C4B80A;
	Tue, 10 Nov 2020 06:19:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Lt6DWyUMViP; Tue, 10 Nov 2020 06:19:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F01C4B7F5;
	Tue, 10 Nov 2020 06:19:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E45F04B7CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 06:19:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DrOJUfbqG+Vm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 06:19:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8263D4B415
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 06:19:00 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 02E5D20659;
 Tue, 10 Nov 2020 11:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605007139;
 bh=V+uHbdDrM/jaXwqO4pqWQzjL1Up7i3JN4LAYXoQ2Oew=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=yeQSXFy2W4PDXQzMfbGwukbiIgeh+NHzOf9c34dw0x4NGJg9e5KZvMMY15cajk1xm
 ONxT65MzXwgo6W4kBXUuZqMpMLY5mCqv1qEO40DLlN1ZGN/lsYxCglUAfFttmkG78k
 ymwFb968JDcgPO2dnp6FEhINlQvm8kFPsYhkbAVM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcRfs-009QfH-P3; Tue, 10 Nov 2020 11:18:56 +0000
MIME-Version: 1.0
Date: Tue, 10 Nov 2020 11:18:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 00/24] Opt-in always-on nVHE hypervisor
In-Reply-To: <20201110101542.GA17572@infradead.org>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201110101542.GA17572@infradead.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b174c468e3df6dc7874b9ab886b38009@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: hch@infradead.org, dbrazdil@google.com,
 kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com, kernel-team@android.com,
 lorenzo.pieralisi@arm.com, qwandor@google.com, suzuki.poulose@arm.com,
 qperret@google.com, linux-kernel@vger.kernel.org, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, tj@kernel.org,
 dennis@kernel.org, cl@linux.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, ascull@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-11-10 10:15, Christoph Hellwig wrote:
> On Mon, Nov 09, 2020 at 11:32:09AM +0000, David Brazdil wrote:
>> As we progress towards being able to keep guest state private to the
>> host running nVHE hypervisor, this series allows the hypervisor to
>> install itself on newly booted CPUs before the host is allowed to run
>> on them.
> 
> Why?  I thought we were trying to kill nVHE off now that newer CPUs
> provide the saner virtualization extensions?

We can't kill nVHE at all, because that is the only game in town.
You can't even buy a decent machine with VHE, no matter how much money
you put on the table.

nVHE is here for the foreseeable future, and we even use its misfeatures
to our advantage in order to offer confidential VMs. See Will's 
presentation
at KVM forum a couple of weeks ago for the gory details.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

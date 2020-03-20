Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186AEC4332D
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:17:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCCBA20781
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6AVOYnW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCCBA20781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 473484A49F;
	Fri, 20 Mar 2020 05:17:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M-b5QRugp9pA; Fri, 20 Mar 2020 05:17:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 735274B083;
	Fri, 20 Mar 2020 05:17:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43A464A4FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:17:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A+gARX20aX6u for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 05:17:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A1794A49F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:17:33 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 18EB320739;
 Fri, 20 Mar 2020 09:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584695852;
 bh=zsT/U58gg36/Uj1CBfv4DlLvkJ01kHhfUVbHRubrzTo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Y6AVOYnW9tiHmtVZ9MVy83Nhq+E8DkwcAnBBy0JfLhTHNp9Ltl+RsgKfnhEwRb9WG
 X12/cWpMptvQNyfIzoKAdWWwgJ5NwIdFBabRJFSGMvy+EPreSyCHzQkslphTWNmKY0
 Ki/zXZ7G5LUWyWnYhBDLDwMUkgwkZj1PTMqfDLHI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jFDmU-00EC7b-9Z; Fri, 20 Mar 2020 09:17:30 +0000
MIME-Version: 1.0
Date: Fri, 20 Mar 2020 09:17:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 19/23] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
In-Reply-To: <9fb8c267-5483-f260-6e37-5e8734b38928@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-20-maz@kernel.org>
 <8a6cf87a-7eee-5502-3b54-093ea0ab5e2d@redhat.com>
 <877ba4711c6b9456314ea580b9c4718c@kernel.org>
 <9fb8c267-5483-f260-6e37-5e8734b38928@redhat.com>
Message-ID: <46802b9895a72c374b86399ca008b89a@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, lorenzo.pieralisi@arm.com,
 jason@lakedaemon.net, kvm@vger.kernel.org, suzuki.poulose@arm.com,
 linux-kernel@vger.kernel.org, rrichter@marvell.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, yuzenghui@huawei.com, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
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

Hi Eric,

On 2020-03-19 20:13, Auger Eric wrote:
> Hi Marc,
> 
> On 3/19/20 8:52 PM, Marc Zyngier wrote:
>> The assumption here is that we're coming vgic_v4_configure_vsgis(),
>> which starts
>> by stopping the whole guest. My guess is that it should be safe 
>> enough, but
>> maybe you are thinking of something else?
> I don't have a specific case in mind. Just preferred asking to make
> sure. Usually when touching those fields we take the lock (that's also
> the case in vgic_debug_show for instance).

Ah, good thing you mention the debug interface. I think it is the only
thing that can run behind our back... Fair enough, I'll add the locking.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

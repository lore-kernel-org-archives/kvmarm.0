Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8AAC433EF
	for <kvmarm@archiver.kernel.org>; Sun, 15 May 2022 10:29:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E18C4B14C;
	Sun, 15 May 2022 06:29:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CRiEQKmOsmTI; Sun, 15 May 2022 06:29:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C23E4B131;
	Sun, 15 May 2022 06:29:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 583C04B121
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 06:29:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KzX0KOedW48y for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2022 06:29:09 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C8444B08B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 06:29:09 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B8ADEB80BFA;
 Sun, 15 May 2022 10:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6959DC385B8;
 Sun, 15 May 2022 10:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652610545;
 bh=kZSItU+61wlId66o1ggrNbpWgwZX8AYojjQ/+zKix28=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=aTLAu351HbNFnUwxSp/3rTBKvkGYxosd8OBAofcb1vczamjB4T8eLJds5h9SgvV7a
 stSgfn/S24lFeTxCbV5+m6MvdRs9E9/JMwDKYETaxH5av3aV41NHINHDnrgTQxie/v
 2owUzs4KEPdbRIX8MqMqbAhNm3Y4ROTud1SeKHDvlPnS9EGYH+Xr2SWWuINCQhm2lP
 rputeF9T6pNZHIq5bn5oAQ3IGMCQzi2VGGsuEbpFgGoYf7951oDRtkib0xBrGNgT11
 CnIif8PcD0sLNStvZIK2jeiDoOYKvxxMYd9fj9SG/wdCo2Dfc0xgEUkqkiD656P8FF
 yKesVFlsnoOgA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nqBUk-00BPVm-IL; Sun, 15 May 2022 11:29:02 +0100
MIME-Version: 1.0
Date: Sun, 15 May 2022 11:29:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: Do not communicate host pmu event
 changes by accessing hyp data
In-Reply-To: <20220510095710.148178-1-tabba@google.com>
References: <20220510095710.148178-1-tabba@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <0b9180b7b093e4fb6d7394041b526c96@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: tabba@google.com, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, qperret@google.com, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 drjones@redhat.com, oupton@google.com, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, catalin.marinas@arm.com, will@kernel.org,
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

Hi Fuad,

On 2022-05-10 10:57, Fuad Tabba wrote:
> Hi,
> 
> This series changes the way KVM communicates host pmu event changes to 
> the
> hypervisor in nvhe and protected mode. Instead of accessing hyp data 
> directly
> from the host, the data is passed to hyp via the loaded vcpu. This 
> provides
> more isolation between the host and the hypervisor, and allows us to 
> use pmu in
> protected mode.
> 
> This series is based on kvmarm/next (8c22fd2d4cfa).

In the future, please don't do that. *Always* base your patches
on something stable (preferably an early -rc, as I usually start
pulling stuff in around -rc3).

kvmarm/next is a moving target, and basing things on top of it
results in an uncontrolled dependency chain. If your series depends
on something and makes it impossible to base your patches on an rc,
please state so (this isn't the case here).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

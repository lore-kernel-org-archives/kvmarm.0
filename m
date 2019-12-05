Return-Path: <SRS0=0kEf=Z3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286EFC43603
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 09:02:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98B3D205ED
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 09:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hOAWg22N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98B3D205ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A0A14A982;
	Thu,  5 Dec 2019 04:02:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I3ge63mk3Oy0; Thu,  5 Dec 2019 04:02:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F19F4AE96;
	Thu,  5 Dec 2019 04:02:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 844604AE8D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 04:02:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SOxrmZRnqdgg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Dec 2019 04:02:38 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87CBE4A982
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 04:02:38 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EA035205ED;
 Thu,  5 Dec 2019 09:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1575536557;
 bh=IegRoMB/1Q1fRaPPqw8Gvk6tJnrbo+VYNJkThGWkX78=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hOAWg22NhSCrXMFC8ojXb8dJREu5nEV6aGcQg8f1YrwCh1LW7FM3d72d7RZ+mZHZa
 /4soWC1ihRSIBsdfmQkz3s0YiLdUpgVzWWRHGdAhRWlyOK4GBRB0jKRiW6Pm6gRBq0
 ZKiONXU6Fa+5gEsiYN/wqU8x/gAphf4z8YQjo2fc=
Date: Thu, 5 Dec 2019 09:02:32 +0000
From: Will Deacon <will@kernel.org>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [RFC 3/3] KVM: arm64: pmu: Enforce PMEVTYPER evtCount size
Message-ID: <20191205090232.GC8606@willie-the-truck>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-4-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191204204426.9628-4-eric.auger@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

On Wed, Dec 04, 2019 at 09:44:26PM +0100, Eric Auger wrote:
> ARMv8.1-PMU supports 16-bit evtCount whereas 8.0 only supports
> 10 bits.
> 
> On Seatlle which has an 8.0 PMU implementation, evtCount[15:10]
> are not read as 0, as expected. Fix that by applying a mask on
> the selected event that depends on the PMU version.

Are you sure about that? These bits are RES0 in 8.0 afaict, so this would be
a CPU erratum. Have you checked the SDEN document (I haven't)?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=6eMA=7N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393B2C433E0
	for <kvmarm@archiver.kernel.org>; Sun, 31 May 2020 12:44:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC00720776
	for <kvmarm@archiver.kernel.org>; Sun, 31 May 2020 12:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vFlD0XZG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC00720776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF984B27E;
	Sun, 31 May 2020 08:44:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bpTBjtJScalc; Sun, 31 May 2020 08:44:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A380E4B284;
	Sun, 31 May 2020 08:44:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 619184B1D2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 May 2020 08:44:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kq6fh7PvlYTB for <kvmarm@lists.cs.columbia.edu>;
 Sun, 31 May 2020 08:44:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 316AC4B17B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 May 2020 08:44:43 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E5C5620707;
 Sun, 31 May 2020 12:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590929082;
 bh=2vL02Vz4eW1dAdaOSuiF9dEX0n59BC4p/43yQ+cQhzE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=vFlD0XZGL4swONxoZWY9HC8REfRlBdsTA/uPXgH0nN3NiBqWmIm/6Bqq7Fqfq3W3Q
 9PQgssKMp9KkuRXfuwkerCfpuPIB4sKNb6UXA6JD1ryjLTpw/nKpLpEnV+IQQDBgdL
 MeJ+uYq9xKf0P/tZBkcFdBnkJ+PGMUfcRsO2Rsg4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jfNKS-00Ggkq-8R; Sun, 31 May 2020 13:44:40 +0100
MIME-Version: 1.0
Date: Sun, 31 May 2020 13:44:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFCv2 9/9] arm64: Support async page fault
In-Reply-To: <d0bfb944-b50a-608a-7dcc-5a409cdc4524@redhat.com>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-10-gshan@redhat.com>
 <81adf013-3de7-23e6-7648-8aec821b033c@redhat.com>
 <a6addc25-29af-3690-8392-efa5e8381e98@redhat.com>
 <8ab64c6a-582b-691d-79ab-21cdc0455cd3@redhat.com>
 <6a4a82a4-af01-98c2-c854-9199f55f7bd3@redhat.com>
 <6965aaf641a23fab64fbe2ceeb790272@kernel.org>
 <d0bfb944-b50a-608a-7dcc-5a409cdc4524@redhat.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <4337cca152df47c93d96e092189a0e36@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, gshan@redhat.com,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 2020-05-29 12:11, Paolo Bonzini wrote:
> On 29/05/20 11:41, Marc Zyngier wrote:
>>>> 
>>>> 
>>>> For x86 the advantage is that the processor can take care of raising 
>>>> the
>>>> stage2 page fault in the guest, so it's faster.
>>>> 
>>> I think there might be too much overhead if the page can be populated
>>> quickly by host. For example, it's fast to populate the pages if 
>>> swapin
>>> isn't involved.
> 
> Those would still be handled by the host.  Only those that are not
> present in the host (which you can see through the MMU notifier) would
> be routed to the guest.  You can do things differently between "not
> present fault because the page table does not exist" and "not present
> fault because the page is missing in the host".
> 
>>> If I'm correct enough, it seems arm64 doesn't have similar mechanism,
>>> routing stage2 page fault to guest.
>> 
>> Indeed, this isn't a thing on arm64. Exception caused by a S2 fault 
>> are
>> always routed to EL2.
> 
> Is there an ARM-approved way to reuse the S2 fault syndromes to detect
> async page faults?

It would mean being able to set an ESR_EL2 register value into ESR_EL1,
and there is nothing in the architecture that would allow that, with
the exception of nested virt: a VHE guest hypervisor running at EL1
must be able to observe S2 faults for its own S2, as synthesized by
the host hypervisor.

The trouble is that:
- there is so far no commercially available CPU supporting NV
- even if you could get hold of such a machine, there is no
   guarantee that such "EL2 syndrome at EL1" is valid outside of
   the nested context
- this doesn't solve the issue for non-NV CPUs anyway

> (By the way, another "modern" use for async page faults is for postcopy
> live migration).

Right. That's definitely a more interesting version of "swap-in".

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

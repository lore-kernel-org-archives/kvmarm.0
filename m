Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39539C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 14:15:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 803EC64F4A
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 14:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 803EC64F4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1E24B0BC;
	Tue,  2 Feb 2021 09:15:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YVwNCuyBGk0i; Tue,  2 Feb 2021 09:15:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDFF94B174;
	Tue,  2 Feb 2021 09:15:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC92F4B18D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 09:15:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MjjlYITHZfgp for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 09:15:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E23F4B174
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 09:15:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D925E64E2B;
 Tue,  2 Feb 2021 14:15:17 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l6wSZ-00BVy2-W6; Tue, 02 Feb 2021 14:15:16 +0000
MIME-Version: 1.0
Date: Tue, 02 Feb 2021 14:15:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [PATCH v16 0/9] Enable ptp_kvm for arm/arm64
In-Reply-To: <20201209060932.212364-1-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <74108ee1d0021acbdd7aed5b467e5432@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org,
 yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
 pbonzini@redhat.com, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com,
 steven.price@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: justin.he@arm.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
 richardcochran@gmail.com, linux-kernel@vger.kernel.org, steven.price@arm.com,
 Andre.Przywara@arm.com, john.stultz@linaro.org, yangbo.lu@nxp.com,
 pbonzini@redhat.com, tglx@linutronix.de, nd@arm.com, will@kernel.org,
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

On 2020-12-09 06:09, Jianyong Wu wrote:
> Currently, we offen use ntp (sync time with remote network clock)
> to sync time in VM. But the precision of ntp is subject to network 
> delay
> so it's difficult to sync time in a high precision.
> 
> kvm virtual ptp clock (ptp_kvm) offers another way to sync time in VM,
> as the remote clock locates in the host instead of remote network 
> clock.
> It targets to sync time between guest and host in virtualization
> environment and in this way, we can keep the time of all the VMs 
> running
> in the same host in sync. In general, the delay of communication 
> between
> host and guest is quiet small, so ptp_kvm can offer time sync precision
> up to in order of nanosecond. Please keep in mind that ptp_kvm just
> limits itself to be a channel which transmit the remote clock from
> host to guest and leaves the time sync jobs to an application, eg. 
> chrony,
> in usersapce in VM.
> 
> How ptp_kvm works:
> After ptp_kvm initialized, there will be a new device node under
> /dev called ptp%d. A guest userspace service, like chrony, can use this
> device to get host walltime, sometimes also counter cycle, which 
> depends
> on the service it calls. Then this guest userspace service can use 
> those
> data to do the time sync for guest.
> here is a rough sketch to show how kvm ptp clock works.
> 
> |----------------------------|              
> |--------------------------|
> |       guest userspace      |              |          host            
> |
> |ioctl -> /dev/ptp%d         |              |                          
> |
> |       ^   |                |              |                          
> |
> |----------------------------|              |                          
> |
> |       |   | guest kernel   |              |                          
> |
> |       |   V      (get host walltime/counter cycle)                   
> |
> |      ptp_kvm -> hypercall - - - - - - - - - - ->hypercall service    
> |
> |                         <- - - - - - - - - - - -                     
> |
> |----------------------------|              
> |--------------------------|
> 
> 1. time sync service in guest userspace call ptp device through 
> /dev/ptp%d.
> 2. ptp_kvm module in guest receives this request then invoke hypercall 
> to route
> into host kernel to request host walltime/counter cycle.
> 3. ptp_kvm hypercall service in host response to the request and send 
> data back.
> 4. ptp (not ptp_kvm) in guest copy the data to userspace.
> 
> This ptp_kvm implementation focuses itself to step 2 and 3 and step 2 
> works
> in guest comparing step 3 works in host kernel.

FWIW, and in order to speed up the review, I've posted a reworked
version[0] of this series with changes that address the comments
I had for on v16.

Thanks,

         M.

[0] https://lore.kernel.org/r/20210202141204.3134855-1-maz@kernel.org
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

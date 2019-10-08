Return-Path: <SRS0=tYEe=YB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EAFECE58E
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 12:04:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A0BE206C2
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 12:04:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="H2N0z2tH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A0BE206C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B63014A90F;
	Tue,  8 Oct 2019 08:04:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jFegdOqCrOSC; Tue,  8 Oct 2019 08:04:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 968DB4A8FA;
	Tue,  8 Oct 2019 08:04:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 062684A8C0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 08:04:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id me2rw4ZHHHHR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Oct 2019 08:04:03 -0400 (EDT)
Received: from smtp-fw-4101.amazon.com (smtp-fw-4101.amazon.com [72.21.198.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00C394A8BB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 08:04:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1570536242; x=1602072242;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=qOiNgtO/sVW6L11wtzZylE/HYq5xG4Py3mmZco6FqFk=;
 b=H2N0z2tHtI9WYRCjoVH91hXfEdcCGTVWVbzc9hmsxK/rIJN97Yk9y7Cy
 xsKcb52WqgVV0upUm8mvDobhkdVf9A4+pyB64tvLA1MPaqN+XGUpP9vmB
 oFjJ7K1mKBs961mr1JjCt37pTZwe3yPSob2E1Y0gvKDD0QxJQcbC0H6Br w=;
X-IronPort-AV: E=Sophos;i="5.67,270,1566864000"; d="scan'208";a="790658646"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.124.125.6])
 by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP;
 08 Oct 2019 12:04:02 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
 by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS
 id AF416A1C3A; Tue,  8 Oct 2019 12:03:32 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 8 Oct 2019 12:03:32 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.30) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 8 Oct 2019 12:03:28 +0000
Subject: Re: [PATCH v2 1/2] KVM: arm/arm64: Allow reporting non-ISV data
 aborts to userspace
To: Christoffer Dall <christoffer.dall@arm.com>, <kvmarm@lists.cs.columbia.edu>
References: <20191008093640.26519-1-christoffer.dall@arm.com>
 <20191008093640.26519-2-christoffer.dall@arm.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <eb25aac5-e773-ca8b-0782-7b05b211bac6@amazon.com>
Date: Tue, 8 Oct 2019 14:03:25 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191008093640.26519-2-christoffer.dall@arm.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.30]
X-ClientProxiedBy: EX13D06UWA004.ant.amazon.com (10.43.160.164) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Precedence: Bulk
Cc: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, Heinrich
 Schuchardt <xypron.glpk@gmx.de>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
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



On 08.10.19 11:36, Christoffer Dall wrote:
> For a long time, if a guest accessed memory outside of a memslot using
> any of the load/store instructions in the architecture which doesn't
> supply decoding information in the ESR_EL2 (the ISV bit is not set), the
> kernel would print the following message and terminate the VM as a
> result of returning -ENOSYS to userspace:
> 
>    load/store instruction decoding not implemented
> 
> The reason behind this message is that KVM assumes that all accesses
> outside a memslot is an MMIO access which should be handled by
> userspace, and we originally expected to eventually implement some sort
> of decoding of load/store instructions where the ISV bit was not set.
> 
> However, it turns out that many of the instructions which don't provide
> decoding information on abort are not safe to use for MMIO accesses, and
> the remaining few that would potentially make sense to use on MMIO
> accesses, such as those with register writeback, are not used in
> practice.  It also turns out that fetching an instruction from guest
> memory can be a pretty horrible affair, involving stopping all CPUs on
> SMP systems, handling multiple corner cases of address translation in
> software, and more.  It doesn't appear likely that we'll ever implement
> this in the kernel.
> 
> What is much more common is that a user has misconfigured his/her guest
> and is actually not accessing an MMIO region, but just hitting some
> random hole in the IPA space.  In this scenario, the error message above
> is almost misleading and has led to a great deal of confusion over the
> years.
> 
> It is, nevertheless, ABI to userspace, and we therefore need to
> introduce a new capability that userspace explicitly enables to change
> behavior.
> 
> This patch introduces KVM_CAP_ARM_NISV_TO_USER (NISV meaning Non-ISV)
> which does exactly that, and introduces a new exit reason to report the
> event to userspace.  User space can then emulate an exception to the
> guest, restart the guest, suspend the guest, or take any other
> appropriate action as per the policy of the running system.
> 
> Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>

Reviewed-by: Alexander Graf <graf@amazon.com>


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

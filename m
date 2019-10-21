Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82964CA9EAF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 20:21:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0F9E2067B
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 20:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="IJE0YtQ2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0F9E2067B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 619544A9EE;
	Mon, 21 Oct 2019 16:21:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QUtZSbnMt39f; Mon, 21 Oct 2019 16:21:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5330E4A947;
	Mon, 21 Oct 2019 16:21:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23A854A854
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 16:21:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3v1jIzUHWli7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 16:21:23 -0400 (EDT)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02B174A80E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 16:21:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1571689282; x=1603225282;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=//AVD64BG2EXBrwZcTZzGcKkjD8j4/kb8bB+DMg9IjA=;
 b=IJE0YtQ21++KkqMkOGzew5EOikZV5QSNAK+5DqgEX2u6AsQVchwFxMjJ
 7HdrHqBXDzFPcLU3oOqzCtKsRpIhBBWQjSgq3Z1oxJISS9QsW+RermiYa
 TkUoNVVPTy6AdhAavXGCuBb3XOpt7xQ9V0yAEMpxSFa+ifbOsZbTgrvlE U=;
X-IronPort-AV: E=Sophos;i="5.67,324,1566864000"; d="scan'208";a="425612074"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.124.125.6])
 by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP;
 21 Oct 2019 20:21:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
 by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS
 id D30B5A243E; Mon, 21 Oct 2019 20:21:17 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 21 Oct 2019 20:21:17 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.8) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 21 Oct 2019 20:21:12 +0000
Subject: Re: [PATCH v3 2/2] KVM: arm/arm64: Allow user injection of external
 data aborts
To: Christoffer Dall <christoffer.dall@arm.com>, <kvmarm@lists.cs.columbia.edu>
References: <20191011110709.2764-1-christoffer.dall@arm.com>
 <20191011110709.2764-3-christoffer.dall@arm.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <26fb84dc-17c8-355e-b88b-e6e0b332998b@amazon.com>
Date: Mon, 21 Oct 2019 22:21:09 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011110709.2764-3-christoffer.dall@arm.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D29UWC002.ant.amazon.com (10.43.162.254) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Cc: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, Heinrich
 Schuchardt <xypron.glpk@gmx.de>, linux-arm-kernel@lists.infradead.org
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



On 11.10.19 13:07, Christoffer Dall wrote:
> In some scenarios, such as buggy guest or incorrect configuration of the
> VMM and firmware description data, userspace will detect a memory access
> to a portion of the IPA, which is not mapped to any MMIO region.
> 
> For this purpose, the appropriate action is to inject an external abort
> to the guest.  The kernel already has functionality to inject an
> external abort, but we need to wire up a signal from user space that
> lets user space tell the kernel to do this.
> 
> It turns out, we already have the set event functionality which we can
> perfectly reuse for this.
> 
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

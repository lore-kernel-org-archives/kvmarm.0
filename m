Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FEBC433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 12:32:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0C8B20767
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 12:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Ei+hiISm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0C8B20767
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AC574B2CB;
	Wed,  2 Sep 2020 08:32:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fxo-ztHw1bu9; Wed,  2 Sep 2020 08:32:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E2254B2C5;
	Wed,  2 Sep 2020 08:32:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 647844B2BC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 08:23:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bfDG0pxlAKAn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 08:23:11 -0400 (EDT)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66DED4B2B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 08:23:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1599049392; x=1630585392;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=aaMnmyUtzKB+LBJO6DfMwrUDuuweN8BDnKWIu/3fO5k=;
 b=Ei+hiISmIQceyPXHjUeZO13OAW+kvneJUE7cMCc1SKP7A19PDWkAvmsl
 +xQWMjL7o2xYRAwRaLSXEi5T633pElkaqeplhx59V7umjtiO7kF/nRjQW
 reMu2T+87yKTceg1oqMPrceTBakt3Or0TMSqyzBXMzQRwTnbE7Rvygiln Y=;
X-IronPort-AV: E=Sophos;i="5.76,383,1592870400"; d="scan'208";a="51447181"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO
 email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.43.8.2])
 by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP;
 02 Sep 2020 12:23:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
 by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS
 id E8310A1991; Wed,  2 Sep 2020 12:23:07 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 12:23:07 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.6) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 12:23:04 +0000
Subject: Re: [PATCH v2 1/2] KVM: arm64: Add PMU event filtering infrastructure
To: Marc Zyngier <maz@kernel.org>
References: <20200309124837.19908-1-maz@kernel.org>
 <20200309124837.19908-2-maz@kernel.org>
 <70e712fc-6789-2384-c21c-d932b5e1a32f@redhat.com>
 <0027398587e8746a6a7459682330855f@kernel.org>
 <7c9e2e55-95c8-a212-e566-c48f5d3bc417@redhat.com>
 <470c88271ef8c4f92ecf990b7b86658e@kernel.org>
 <0647b63c-ac27-8ec9-c9da-9a5e5163cb5d@amazon.com>
 <18b9ff6f9a65546f55dd2e7019d48986@kernel.org>
From: Alexander Graf <graf@amazon.com>
Message-ID: <e9d669ee-5e95-e526-fc0e-ccb4ce0bc7e1@amazon.com>
Date: Wed, 2 Sep 2020 14:23:02 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <18b9ff6f9a65546f55dd2e7019d48986@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.6]
X-ClientProxiedBy: EX13D50UWA004.ant.amazon.com (10.43.163.5) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
X-Mailman-Approved-At: Wed, 02 Sep 2020 08:32:18 -0400
Cc: kvm@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
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



On 20.08.20 09:37, Marc Zyngier wrote:
> 
> On 2020-08-19 00:24, Alexander Graf wrote:
>> Hi Marc,
> 
> [...]
> 
>> I haven't seen a v3 follow-up after this. Do you happen to have that
>> somewhere in a local branch and just need to send it out or would you
>> prefer if I pick up v2 and address the comments?
> 
> I'll look into it.

Thank you :)


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

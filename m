Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D92DC64E7B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:59:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 716EE206A5
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:59:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GBZd5ctS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 716EE206A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C797A4BEAD;
	Tue,  1 Dec 2020 08:59:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3t84WUVATqfZ; Tue,  1 Dec 2020 08:59:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D64AB4BEBA;
	Tue,  1 Dec 2020 08:59:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DBC14BEAC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:59:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id brpIzO4505k2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 08:59:08 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EE584BA00
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:59:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1606831148;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PwJG1illbebhBKC5v2IxyfNes6/XlUwSexlIWlX8yvI=;
 b=GBZd5ctS6YlYF8LKVjybLXTh3I48iCpAR6J7/9MIuz4CxSzut+dPi78Wd2pD8wupSEglPj
 hjbKXtLjkw+dRhtgEJGfb71Nz6/Ex4fPu2Y2KLwk1jyUY2jqrpeLfPI9TEhN4DZID1qUwi
 HLbRBScZtamSa1tBimr480GAqEL9uis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-wovMo1sZOu2TKbhHgVoPFw-1; Tue, 01 Dec 2020 08:59:03 -0500
X-MC-Unique: wovMo1sZOu2TKbhHgVoPFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FF338558E9;
 Tue,  1 Dec 2020 13:59:00 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A8A1A5C1BB;
 Tue,  1 Dec 2020 13:58:53 +0000 (UTC)
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To: Xingang Wang <wangxingang5@huawei.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
Date: Tue, 1 Dec 2020 14:58:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: xieyingtai@huawei.com, jean-philippe@linaro.org, kvm@vger.kernel.org,
 maz@kernel.org, joro@8bytes.org, will@kernel.org,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 vivek.gautam@arm.com, alex.williamson@redhat.com, zhangfei.gao@linaro.org,
 robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

Hi Xingang,

On 12/1/20 2:33 PM, Xingang Wang wrote:
> Hi Eric
> 
> On  Wed, 18 Nov 2020 12:21:43, Eric Auger wrote:
>> @@ -1710,7 +1710,11 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>> 	 * insertion to guarantee those are observed before the TLBI. Do be
>> 	 * careful, 007.
>> 	 */
>> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>> +	if (ext_asid >= 0) { /* guest stage 1 invalidation */
>> +		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
>> +		cmd.tlbi.asid	= ext_asid;
>> +		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
>> +	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> 
> Found a problem here, the cmd for guest stage 1 invalidation is built,
> but it is not delivered to smmu.
> 

Thank you for the report. I will fix that soon. With that fixed, have
you been able to run vSVA on top of the series. Do you need other stuff
to be fixed at SMMU level? As I am going to respin soon, please let me
know what is the best branch to rebase to alleviate your integration.

Best Regards

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

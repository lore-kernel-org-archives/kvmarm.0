Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E061C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 18:00:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E7C323A34
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 18:00:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E7C323A34
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE1584B240;
	Thu, 14 Jan 2021 13:00:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lQbRwk276H+S; Thu, 14 Jan 2021 13:00:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9590D4B203;
	Thu, 14 Jan 2021 13:00:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA9B4B203
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 13:00:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id azC-AnXBcRl0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 13:00:50 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B0B4B166
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 13:00:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610647250;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xPOwXiPpI33hw2u5OYDJ4rIdtWWBfrW2gYhDEz40K0Y=;
 b=SUIqVB3mbOjEdwPq6DxRnNeWNlRNgyjbYckinK8LyNeLr8vLl9KDuKvtdchEEch74EZB34
 SZpdNYR6Qv/X2/oCOREg8GG/FhHLUkSU2GGeAWM0Q6D/EQNbYKQJ7pNdNmhfaokZ3QKwQo
 Rw9Hj3dSatozOjB1DqLwZKNtheeyneo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-UM3Y5cjwNZq5qZ3ZC6LI1A-1; Thu, 14 Jan 2021 13:00:45 -0500
X-MC-Unique: UM3Y5cjwNZq5qZ3ZC6LI1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F09A893FCA;
 Thu, 14 Jan 2021 18:00:22 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2702F7D564;
 Thu, 14 Jan 2021 18:00:14 +0000 (UTC)
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
 <20201204095338.GA1912466@myrica>
 <2de03a797517452cbfeab022e12612b7@huawei.com>
 <0bf50dd6-ef3c-7aba-cbc1-1c2e17088470@redhat.com>
 <d68b6269-ee99-9ed7-de30-867e4519d104@redhat.com>
 <YACAXaG+opCwDFTL@larix.localdomain>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <8697431a-d30c-c84c-58ff-e2bfcfe19ec2@redhat.com>
Date: Thu, 14 Jan 2021 19:00:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <YACAXaG+opCwDFTL@larix.localdomain>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: Xieyingtai <xieyingtai@huawei.com>, wangxingang <wangxingang5@huawei.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 qubingbing <qubingbing@hisilicon.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
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

Hi Jean,

On 1/14/21 6:33 PM, Jean-Philippe Brucker wrote:
> Hi Eric,
> 
> On Thu, Jan 14, 2021 at 05:58:27PM +0100, Auger Eric wrote:
>>>>  The uacce-devel branches from
>>>>> https://github.com/Linaro/linux-kernel-uadk do provide this at the moment
>>>>> (they track the latest sva/zip-devel branch
>>>>> https://jpbrucker.net/git/linux/ which is roughly based on mainline.)
>> As I plan to respin shortly, please could you confirm the best branch to
>> rebase on still is that one (uacce-devel from the linux-kernel-uadk git
>> repo). Is it up to date? Commits seem to be quite old there.
> 
> Right I meant the uacce-devel-X branches. The uacce-devel-5.11 branch
> currently has the latest patches

OK thanks!

Eric
> 
> Thanks,
> Jean
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

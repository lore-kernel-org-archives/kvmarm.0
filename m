Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A843BC433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:38:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 078CA6108F
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:38:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 078CA6108F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57EF04B61B;
	Thu,  1 Apr 2021 05:38:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NUpu3kAV33bi; Thu,  1 Apr 2021 05:38:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59EA64B5F8;
	Thu,  1 Apr 2021 05:38:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B8044B5F8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 05:38:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7g+BYLHmq0Pv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 05:38:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD964B5A6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 05:38:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617269916;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3Hn127n4+W9QT98rMhYkTztLXr0yp9CQW2nFtLHdNsg=;
 b=d4Z95KKoEwCMl/HS/89evr5HV4UsIT7BpqxKrPrkosXYZyDkByV08MJmfXyj6Erw/fRKxE
 4x+0eC9Ybhx67eIq4tFQU1j9RYitT4+zv10uJcHiC7VraJOn/Pdbo/XZodhs6I/HYO7c1u
 q/tNLZZpebjpWkDtt7jZANHnjSRytNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-duJBAVOJMpCjeWyJ694eNA-1; Thu, 01 Apr 2021 05:38:34 -0400
X-MC-Unique: duJBAVOJMpCjeWyJ694eNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBE96107B7C3;
 Thu,  1 Apr 2021 09:38:30 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 189EB5C8AB;
 Thu,  1 Apr 2021 09:38:18 +0000 (UTC)
Subject: Re: [PATCH v14 06/13] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-7-eric.auger@redhat.com>
 <7a270196-2a8d-1b23-ee5f-f977c53d2134@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <8350e4e2-4607-cfd7-b1a7-1470bf18da6d@redhat.com>
Date: Thu, 1 Apr 2021 11:38:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <7a270196-2a8d-1b23-ee5f-f977c53d2134@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: kvm@vger.kernel.org, vivek.gautam@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com, jean-philippe@linaro.org, yi.l.liu@intel.com,
 wangxingang5@huawei.com, maz@kernel.org, joro@8bytes.org, vsethi@nvidia.com,
 zhangfei.gao@linaro.org, jacob.jun.pan@linux.intel.com, will@kernel.org,
 nicoleotsuka@gmail.com, alex.williamson@redhat.com,
 linux-kernel@vger.kernel.org, lushenming@huawei.com,
 iommu@lists.linux-foundation.org, robin.murphy@arm.com
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgWmVuZ2h1aSwKCk9uIDMvMzAvMjEgMTE6MTcgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gT24g
MjAyMS8yLzI0IDQ6NTYsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+IEBAIC0xOTM2LDcgKzE5NTAsMTIg
QEAgc3RhdGljIHZvaWQKPj4gYXJtX3NtbXVfdGxiX2ludl9yYW5nZV9kb21haW4odW5zaWduZWQg
bG9uZyBpb3ZhLCBzaXplX3Qgc2l6ZSwKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIH0sCj4+IMKgwqDC
oMKgwqAgfTsKPj4gwqAgLcKgwqDCoCBpZiAoc21tdV9kb21haW4tPnN0YWdlID09IEFSTV9TTU1V
X0RPTUFJTl9TMSkgewo+PiArwqDCoMKgIGlmIChleHRfYXNpZCA+PSAwKSB7wqAgLyogZ3Vlc3Qg
c3RhZ2UgMSBpbnZhbGlkYXRpb24gKi8KPj4gK8KgwqDCoMKgwqDCoMKgIGNtZC5vcGNvZGXCoMKg
wqAgPSBzbW11X2RvbWFpbi0+c21tdS0+ZmVhdHVyZXMgJgo+PiBBUk1fU01NVV9GRUFUX0UySCA/
Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIENNRFFfT1BfVExCSV9FTDJf
VkEgOiBDTURRX09QX1RMQklfTkhfVkE7Cj4gCj4gSWYgSSB1bmRlcnN0YW5kIGl0IGNvcnJlY3Rs
eSwgdGhlIHRydWUgbmVzdGVkIG1vZGUgZWZmZWN0aXZlbHkgZ2l2ZXMgdXMKPiBhICpOUy1FTDEq
IFN0cmVhbVdvcmxkLiBXZSBzaG91bGQgdGhlcmVmb3JlIHVzZSBDTURRX09QX1RMQklfTkhfVkEg
dG8KPiBpbnZhbGlkYXRlIHRoZSBzdGFnZS0xIE5TLUVMMSBlbnRyaWVzLCBubyBtYXR0ZXIgRTJI
IGlzIHNlbGVjdGVkIG9yIG5vdC4KPiAKClllcyBhdCB0aGUgbW9tZW50IHlvdSdyZSByaWdodC4g
U3VwcG9ydCBmb3IgbmVzdGVkIHZpcnQgbWF5IGluZHVjZSBzb21lCmNoYW5nZXMgaGVyZSBidXQg
d2UgYXJlIG5vdCB0aGVyZS4gSSB3aWxsIGZpeCBpdCBhbmQgYWRkIGEgY29tbWVudC4KVGhhbmsg
eW91IQoKQmVzdCBSZWdhcmRzCgpFcmljCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K

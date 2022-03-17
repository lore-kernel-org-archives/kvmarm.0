Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DC0C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 07:28:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B44E4A014;
	Thu, 17 Mar 2022 03:28:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pTfiGAhv3opu; Thu, 17 Mar 2022 03:27:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B20F749F56;
	Thu, 17 Mar 2022 03:27:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 126CE49F2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 03:27:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pQBNyxraJsPc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 03:27:52 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 642CD49EF6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 03:27:52 -0400 (EDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.56])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KJzBJ2QRZzcb7p;
 Thu, 17 Mar 2022 15:22:48 +0800 (CST)
Received: from kwepemm600020.china.huawei.com (7.193.23.147) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 15:27:47 +0800
Received: from [10.174.187.192] (10.174.187.192) by
 kwepemm600020.china.huawei.com (7.193.23.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 15:27:46 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Report an error on GICv4.1 vcpu de-schedule
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>, <maz@kernel.org>
Message-ID: <4aae10ba-b39a-5f84-754b-69c2eb0a2c03@huawei.com>
Date: Thu, 17 Mar 2022 15:27:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.174.187.192]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600020.china.huawei.com (7.193.23.147)
X-CFilter-Loop: Reflected
Cc: chengjian8@huawei.com, Martin.Weidmann@arm.com
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyY++8jAoKVGhlIHBhdGNoICJLVk06IGFybTY0OiBEZWxheSB0aGUgcG9sbGluZyBvZiB0
aGUgR0lDUl9WUEVOREJBU0VSLkRpcnR5CmJpdCIoNTdlM2NlYmQwMjJmYmMwMzVkY2YxOTBhYzc4
OWZkMmZmYzc0N2Y1YikgcmVtb3ZlIHRoZSBwb2xsaW5nIG9mCkdJQ1JfVlBFTkRCQVNFUi5EaXJ0
eSBiaXQgaW4gdmNwdV9sb2FkKCkgLCB3aGlsZSBjaGVjayB0aGUgVlBUIHBhcnNpbmcKcmVhZHkg
aW4ga3ZtX3ZnaWNfZmx1c2hfaHdzdGF0ZSgpIGZvciBiZXR0ZXIgcGVyZm9ybWFuY2UuCgpNb3N0
IHRpbWUgaXQgd29ya3MsIGJ1dCB3ZSBoYXZlIG1ldCBhbiBlcnJvciBvbiBvdXIgaGFyZHdhcmUg
cmVjZW50bHkuCkluIHByZWVtcHRhYmxlIGtlcm5lbCwgdGhlIHZjcHUgY2FuIGJlIHByZWVtcHRl
ZCBiZXR3ZWVuIHZjcHVfbG9hZCBhbmQKa3ZtX3ZnaWNfZmx1c2hfaHdzdGF0ZS4gQXMgYSByZXN1
bHQsIGl0IGdldCBkZS1zY2hlZHVsZWQgYW5kCml0c19jbGVhcl92cGVuZF92YWxpZCgpIGlzIGNh
bGxlZAoKCXZhbCA9IGdpY3JfcmVhZF92cGVuZGJhc2VyKHZscGlfYmFzZSArIEdJQ1JfVlBFTkRC
QVNFUik7Cgl2YWwgJj0gfkdJQ1JfVlBFTkRCQVNFUl9WYWxpZDsKCXZhbCAmPSB+Y2xyOwoJdmFs
IHw9IHNldDsKCWdpY3Jfd3JpdGVfdnBlbmRiYXNlcih2YWwsIHZscGlfYmFzZSArIEdJQ1JfVlBF
TkRCQVNFUik7CgoKVGhlIGZ1bmN0aW9uIGNsZWFycyBWYWxpZCBiaXQgbWVhbndoaWxlIEdJQ1Jf
VlBFTkRCQVNFUl9EaXJ0eQptYXliZSBzdGlsbCAxLCB3aGljaCBjYXVzZSB0aGUgc3Vic2VxdWVu
dCBHSUNSX1ZQRU5EQkFTRVJfRGlydHkgcG9sbGluZwpmYWlsIGFuZCByZXBvcnQgIiJJVFMgdmly
dHVhbCBwZW5kaW5nIHRhYmxlIG5vdCBjbGVhbmluZyIuCgpXZSBoYXZlIGNvbW11bmljYXRlZCB3
aXRoIE1hcnRpbiBmcm9tIEFSTSBhbmQgZ2V0IHRoZSBjb25jbHVzaW9uCnRoYXQgd2Ugc2hvdWxk
IG5vdCBjaGFuZ2UgdmFsaWQgYml0IHdoaWxlIHRoZSBkaXJ0eSBiaXQgbm90IGNsZWFy4oCU4oCU
CiJUaGUgZGlydHkgYml0IHJlcG9ydHMgd2hldGhlciB0aGUgbGFzdCBzY2hlZHVsZSAvZGUtc2No
ZWR1bGUKb3BlcmF0aW9uIGhhcyBjb21wbGV0ZWQuVGhlIHJlc3RyaWN0aW9uIG9uIG5vdCBjaGFu
Z2luZyBWYWxpZCB3aGVuIERpcnR5CmlzIDEsIGlzIHNvIHRoYXQgaGFyZHdhcmUgY2FuIGFsd2F5
cyBjb21wbGV0ZSB0aGUgbGFzdCBvcGVyYXRpb24gZm9yCnN0YXJ0aW5nIHRoZSBuZXh0Ii4KCkkg
dGhpbmsgbWF5YmUgd2UgY2FuIGNoZWNrIGRpcnR5IGJpdCBjbGVhciBiZWZvcmUgY2xlYXJpbmcg
dGhlIHZhbGlkIGJpdAppbiBpdHNfY2xlYXJfdnBlbmRfdmFsaWQoKSBjb2RlLiBIb3BlIHRvIGtu
b3cgeW91ciBvcGluaW9uIGFib3V0IHRoaXMKaXNzdWUuCgpUaGFua3MsCkppbmd5aQoKCgoKCgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

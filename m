Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D9EC4332B
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 03:53:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5713020722
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 03:53:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5713020722
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F58F4A4A0;
	Thu, 19 Mar 2020 23:53:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EnuLwmxeoUiL; Thu, 19 Mar 2020 23:53:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F8A84AF1F;
	Thu, 19 Mar 2020 23:53:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DFDC4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 23:53:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gd55RuTuGyOh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2020 23:53:24 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0197F4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 23:53:23 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 1046441C18B5189ACC3F;
 Fri, 20 Mar 2020 11:53:20 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 11:53:12 +0800
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To: Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
Date: Fri, 20 Mar 2020 11:53:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <4a06fae9c93e10351276d173747d17f4@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert
 Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyYywKCk9uIDIwMjAvMy8xOSAyMDoxMCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBCdXQg
SSB3b25kZXIgdGhhdCBzaG91bGQgd2UgdXNlIG5hc3NnaXJlcSB0byAqb25seSoga2VlcCB0cmFj
ayB3aGF0Cj4+IHRoZSBndWVzdCBoYWQgd3JpdHRlbiBpbnRvIHRoZSBHSUNEX0NUTFIubkFTU0dJ
cmVxLsKgIElmIG5vdCwgd2UgbWF5Cj4+IGxvc2UgdGhlIGd1ZXN0LXJlcXVlc3QgYml0IGFmdGVy
IG1pZ3JhdGlvbiBhbW9uZyBob3N0cyB3aXRoIGRpZmZlcmVudAo+PiBoYXNfZ2ljdjRfMSBzZXR0
aW5ncy4KPiAKPiBJJ20gdW5zdXJlIG9mIHdoYXQgeW91J3JlIHN1Z2dlc3RpbmcgaGVyZS4gSWYg
dXNlcnNwYWNlIHRyaWVzIHRvIHNldAo+IEdJQ0RfQ1RMUi5uQVNTR0lyZXEgb24gYSBub24tNC4x
IGhvc3QsIHRoaXMgYml0IHdpbGwgbm90IGxhdGNoLgoKVGhpcyBpcyBleGFjdGx5IHdoYXQgSSAq
d2FzKiBjb25jZXJuaW5nIGFib3V0LgoKPiBVc2Vyc3BhY2UgY2FuIGNoZWNrIHRoYXQgYXQgcmVz
dG9yZSB0aW1lLiBPciB3ZSBjb3VsZCBmYWlsIHRoZQo+IHVzZXJzcGFjZSB3cml0ZSwgd2hpY2gg
aXMgYSBiaXQgb2RkICh0aGUgYml0IGlzIG90aGVyd2lzZSBSRVMwKS4KPiAKPiBDb3VsZCB5b3Ug
Y2xhcmlmeSB5b3VyIHByb3Bvc2FsPwoKTGV0J3MgYXNzdW1lIHR3byBob3N0cyBiZWxvdy4gJ2hh
c19naWN2NF8xJyBpcyB0cnVlIG9uIGhvc3QtQSB3aGlsZQppdCBpcyBmYWxzZSBvbiBob3N0LUIg
YmVjYXVzZSBvZiBsYWNrIG9mIEhXIHN1cHBvcnQgb3IgdGhlIGtlcm5lbApwYXJhbWV0ZXIgImt2
bS1hcm0udmdpY192NF9lbmFibGU9MCIuCgpJZiB3ZSBtaWdyYXRlIGd1ZXN0IHRocm91Z2ggQS0+
Qi0+QSwgd2UgbWF5IGVuZC11cCBsb3NlIHRoZSBpbml0aWFsCmd1ZXN0LXJlcXVlc3QgIm5BU1NH
SXJlcT0xIiBhbmQgZG9uJ3QgdXNlIGRpcmVjdCB2U0dJIGRlbGl2ZXJ5IGZvcgp0aGlzIGd1ZXN0
IHdoZW4gaXQncyBtaWdyYXRlZCBiYWNrIHRvIGhvc3QtQS4KClRoaXMgY2FuIGJlICJmaXhlZCIg
Ynkga2VlcCB0cmFjayBvZiB3aGF0IGd1ZXN0IGhhZCB3cml0dGVuIGludG8KbkFTU0dJcmVxLiBB
bmQgd2UgbmVlZCB0byBldmFsdWF0ZSB0aGUgbmVlZCBmb3IgdXNpbmcgZGlyZWN0IHZTR0kKZm9y
IGEgc3BlY2lmaWVkIGd1ZXN0IGJ5ICdoYXNfZ2ljdjRfMSAmJiBuYXNzZ2lyZXEnLgoKQnV0IGlm
IGl0J3MgZXhwZWN0ZWQgdGhhdCAiaWYgdXNlcnNwYWNlIHRyaWVzIHRvIHNldCBuQVNTR0lyZXEg
b24KYSBub24tNC4xIGhvc3QsIHRoaXMgYml0IHdpbGwgbm90IGxhdGNoIiwgdGhlbiB0aGlzIHNo
b3VsZG4ndCBiZQphIHByb2JsZW0gYXQgYWxsLgoKQW55d2F5IHRoaXMgaXMgbm90IGEgYmlnIGRl
YWwgdG8gbWUgYW5kIEkgd29uJ3QgY29tcGxhaW4gYWJvdXQgaXQKaW4gdGhlIGZ1dHVyZSA7LSkg
RWl0aGVyIHdheSwgZm9yIHRoaXMgcGF0Y2g6CgpSZXZpZXdlZC1ieTogWmVuZ2h1aSBZdSA8eXV6
ZW5naHVpQGh1YXdlaS5jb20+CgoKVGhhbmtzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K

Return-Path: <SRS0=HtNg=W7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE295C3A5A8
	for <kvmarm@archiver.kernel.org>; Wed,  4 Sep 2019 15:53:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58B472339D
	for <kvmarm@archiver.kernel.org>; Wed,  4 Sep 2019 15:53:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58B472339D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E464A599;
	Wed,  4 Sep 2019 11:53:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y6V-KVP2JTCt; Wed,  4 Sep 2019 11:53:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0BDF4A596;
	Wed,  4 Sep 2019 11:53:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 023B04A596
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Sep 2019 11:53:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7bXY2NC4nbL3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Sep 2019 11:53:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC6444A542
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Sep 2019 11:53:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BB8728;
 Wed,  4 Sep 2019 08:53:05 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C969A3F246;
 Wed,  4 Sep 2019 08:53:03 -0700 (PDT)
Subject: Re: [PATCH v4 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To: Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-6-steven.price@arm.com>
 <d55d091f-1c0f-9c47-b7b2-95c87285335d@huawei.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <d68fd0f8-a01f-0939-8493-865c4f037783@arm.com>
Date: Wed, 4 Sep 2019 16:53:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d55d091f-1c0f-9c47-b7b2-95c87285335d@huawei.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

T24gMDMvMDkvMjAxOSAxMDoxNCwgWmVuZ2h1aSBZdSB3cm90ZToKPiBPbiAyMDE5LzgvMzAgMTY6
NDIsIFN0ZXZlbiBQcmljZSB3cm90ZToKPj4gSW1wbGVtZW50IHRoZSBzZXJ2aWNlIGNhbGwgZm9y
IGNvbmZpZ3VyaW5nIGEgc2hhcmVkIHN0cnVjdHVyZSBiZXR3ZWVuIGEKPj4gVkNQVSBhbmQgdGhl
IGh5cGVydmlzb3IgaW4gd2hpY2ggdGhlIGh5cGVydmlzb3IgY2FuIHdyaXRlIHRoZSB0aW1lCj4+
IHN0b2xlbiBmcm9tIHRoZSBWQ1BVJ3MgZXhlY3V0aW9uIHRpbWUgYnkgb3RoZXIgdGFza3Mgb24g
dGhlIGhvc3QuCj4+Cj4+IFRoZSBoeXBlcnZpc29yIGFsbG9jYXRlcyBtZW1vcnkgd2hpY2ggaXMg
cGxhY2VkIGF0IGFuIElQQSBjaG9zZW4gYnkgdXNlcgo+PiBzcGFjZS4KPiAKPiBJdCBzZWVtcyB0
aGF0IG5vIGFsbG9jYXRpb24gaGFwcGVucyBpbiB0aGUgaHlwZXJ2aXNvciBjb2RlLsKgIFVzZXIg
c3BhY2UKPiB3aWxsIGRvIGl0IGluc3RlYWQ/CgpBaCwgeWVzIEkgc2hvdWxkIHVwZGF0ZSB0aGUg
Y29tbWl0IG1lc3NhZ2UuIFVzZXIgc3BhY2UgZG9lcyBub3cgYWxsb2NhdGUKdGhlIG1lbW9yeS4g
VGhhbmtzIGZvciBzcG90dGluZyB0aGF0LgoKU3RldmUKCj4+IFRoZSBoeXBlcnZpc29yIHRoZW4g
dXBkYXRlcyB0aGUgc2hhcmVkIHN0cnVjdHVyZSB1c2luZwo+PiBrdm1fcHV0X2d1ZXN0KCkgdG8g
ZW5zdXJlIHNpbmdsZSBjb3B5IGF0b21pY2l0eSBvZiB0aGUgNjQtYml0IHZhbHVlCj4+IHJlcG9y
dGluZyB0aGUgc3RvbGVuIHRpbWUgaW4gbmFub3NlY29uZHMuCj4+Cj4+IFdoZW5ldmVyIHN0b2xl
biB0aW1lIGlzIGVuYWJsZWQgYnkgdGhlIGd1ZXN0LCB0aGUgc3RvbGVuIHRpbWUgY291bnRlciBp
cwo+PiByZXNldC4KPj4KPj4gVGhlIHN0b2xlbiB0aW1lIGl0c2VsZiBpcyByZXRyaWV2ZWQgZnJv
bSB0aGUgc2NoZWRfaW5mbyBzdHJ1Y3R1cmUKPj4gbWFpbnRhaW5lZCBieSB0aGUgTGludXggc2No
ZWR1bGVyIGNvZGUuIFdlIGVuYWJsZSBTQ0hFRFNUQVRTIHdoZW4KPj4gc2VsZWN0aW5nIEtWTSBL
Y29uZmlnIHRvIGVuc3VyZSB0aGlzIHZhbHVlIGlzIG1lYW5pbmdmdWwuCj4+Cj4+IFNpZ25lZC1v
ZmYtYnk6IFN0ZXZlbiBQcmljZSA8c3RldmVuLnByaWNlQGFybS5jb20+Cj4gCj4gVGhhbmtzLAo+
IHplbmdodWkKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

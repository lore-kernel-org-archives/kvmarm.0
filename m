Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED86C64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 12:25:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 554582222A
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 12:25:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 554582222A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ADC04B354;
	Wed,  2 Dec 2020 07:25:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dS59cZmY8J1v; Wed,  2 Dec 2020 07:25:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A01EB4B33C;
	Wed,  2 Dec 2020 07:25:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C883C4C10E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 06:40:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F9t872hPLayO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 06:40:31 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E76A4BDCB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 06:40:30 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ClgBR4j31z6vLd;
 Tue,  1 Dec 2020 19:39:59 +0800 (CST)
Received: from [10.174.184.209] (10.174.184.209) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Dec 2020 19:40:14 +0800
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
To: Marc Zyngier <maz@kernel.org>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
 <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
 <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
 <48c10467-30f3-9b5c-bbcb-533a51516dc5@huawei.com>
 <2ad38077300bdcaedd2e3b073cd36743@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <9b80d460-e149-20c8-e9b3-e695310b4ed1@huawei.com>
Date: Tue, 1 Dec 2020 19:40:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <2ad38077300bdcaedd2e3b073cd36743@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.209]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Wed, 02 Dec 2020 07:25:22 -0500
Cc: Neo Jia <cjia@nvidia.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

T24gMjAyMC8xMi8xIDE4OjU1LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAyMC0xMS0zMCAw
NzoyMywgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gCj4gSGkgU2hlbm1pbmcsCj4gCj4+IFdlIGFyZSBw
b25kZXJpbmcgb3ZlciB0aGlzIHByb2JsZW0gdGhlc2UgZGF5cywgYnV0IHN0aWxsIGRvbid0IGdl
dCBhCj4+IGdvb2Qgc29sdXRpb24uLi4KPj4gQ291bGQgeW91IGdpdmUgdXMgc29tZSBhZHZpY2Ug
b24gdGhpcz8KPj4KPj4gT3IgY291bGQgd2UgbW92ZSB0aGUgcmVzdG9yaW5nIG9mIHRoZSBwZW5k
aW5nIHN0YXRlcyAoaW5jbHVkZSB0aGUgc3luYwo+PiBmcm9tIGd1ZXN0IFJBTSBhbmQgdGhlIHRy
YW5zZmVyIHRvIEhXKSB0byB0aGUgR0lDIFZNIHN0YXRlIGNoYW5nZSBoYW5kbGVyLAo+PiB3aGlj
aCBpcyBjb21wbGV0ZWx5IGNvcnJlc3BvbmRpbmcgdG8gc2F2ZV9wZW5kaW5nX3RhYmxlcyAobW9y
ZSBzeW1tZXRyaWM/KQo+PiBhbmQgZG9uJ3QgZXhwb3NlIEdJQ3Y0Li4uCj4gCj4gV2hhdCBpcyAi
dGhlIEdJQyBWTSBzdGF0ZSBjaGFuZ2UgaGFuZGxlciI/IElzIHRoYXQgYSBRRU1VIHRoaW5nPwoK
WWVhaCwgaXQgaXMgYSBhIFFFTVUgdGhpbmcuLi4KCj4gV2UgZG9uJ3QgcmVhbGx5IGhhdmUgdGhh
dCBjb25jZXB0IGluIEtWTSwgc28gSSdkIGFwcHJlY2lhdGUgaWYgeW91IGNvdWxkCj4gYmUgYSBi
aXQgbW9yZSBleHBsaWNpdCBvbiB0aGlzLgoKTXkgdGhvdWdodCBpcyB0byBhZGQgYSBuZXcgaW50
ZXJmYWNlICh0byBRRU1VKSBmb3IgdGhlIHJlc3RvcmluZyBvZiB0aGUgcGVuZGluZwpzdGF0ZXMs
IHdoaWNoIGlzIGNvbXBsZXRlbHkgY29ycmVzcG9uZGluZyB0byBLVk1fREVWX0FSTV9WR0lDX1NB
VkVfUEVORElOR19UQUJMRVMuLi4KQW5kIGl0IGlzIGNhbGxlZCBmcm9tIHRoZSBHSUMgVk0gc3Rh
dGUgY2hhbmdlIGhhbmRsZXIgaW4gUUVNVSwgd2hpY2ggaXMgaGFwcGVuaW5nCmFmdGVyIHRoZSBy
ZXN0b3JpbmcgKGNhbGwga3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoKSkgYnV0IGJlZm9yZSB0
aGUgc3RhcnRpbmcKKHJ1bm5pbmcpIG9mIHRoZSBWRklPIGRldmljZS4KClRoYW5rcywKU2hlbm1p
bmcKCj4gCj4gVGhhbmtzLAo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=

Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B1DC64E90
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 12:25:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CF532222A
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 12:25:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CF532222A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C53884B35D;
	Wed,  2 Dec 2020 07:25:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IIx7keeSDnVt; Wed,  2 Dec 2020 07:25:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF43C4B345;
	Wed,  2 Dec 2020 07:25:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 625EB4C1E2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 07:15:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7nrIScBVsUy6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 07:15:28 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98E874B9DD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 07:15:28 -0500 (EST)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Clgyx4s0YzhlQd;
 Tue,  1 Dec 2020 20:15:05 +0800 (CST)
Received: from [10.174.184.209] (10.174.184.209) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Dec 2020 20:15:15 +0800
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
 <9b80d460-e149-20c8-e9b3-e695310b4ed1@huawei.com>
 <274dafb2e21f49326a64bb575e668793@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <59ec07e5-c017-8644-b96f-e87fe600c490@huawei.com>
Date: Tue, 1 Dec 2020 20:15:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <274dafb2e21f49326a64bb575e668793@kernel.org>
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

T24gMjAyMC8xMi8xIDE5OjUwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAyMC0xMi0wMSAx
MTo0MCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4+IE9uIDIwMjAvMTIvMSAxODo1NSwgTWFyYyBaeW5n
aWVyIHdyb3RlOgo+Pj4gT24gMjAyMC0xMS0zMCAwNzoyMywgU2hlbm1pbmcgTHUgd3JvdGU6Cj4+
Pgo+Pj4gSGkgU2hlbm1pbmcsCj4+Pgo+Pj4+IFdlIGFyZSBwb25kZXJpbmcgb3ZlciB0aGlzIHBy
b2JsZW0gdGhlc2UgZGF5cywgYnV0IHN0aWxsIGRvbid0IGdldCBhCj4+Pj4gZ29vZCBzb2x1dGlv
bi4uLgo+Pj4+IENvdWxkIHlvdSBnaXZlIHVzIHNvbWUgYWR2aWNlIG9uIHRoaXM/Cj4+Pj4KPj4+
PiBPciBjb3VsZCB3ZSBtb3ZlIHRoZSByZXN0b3Jpbmcgb2YgdGhlIHBlbmRpbmcgc3RhdGVzIChp
bmNsdWRlIHRoZSBzeW5jCj4+Pj4gZnJvbSBndWVzdCBSQU0gYW5kIHRoZSB0cmFuc2ZlciB0byBI
VykgdG8gdGhlIEdJQyBWTSBzdGF0ZSBjaGFuZ2UgaGFuZGxlciwKPj4+PiB3aGljaCBpcyBjb21w
bGV0ZWx5IGNvcnJlc3BvbmRpbmcgdG8gc2F2ZV9wZW5kaW5nX3RhYmxlcyAobW9yZSBzeW1tZXRy
aWM/KQo+Pj4+IGFuZCBkb24ndCBleHBvc2UgR0lDdjQuLi4KPj4+Cj4+PiBXaGF0IGlzICJ0aGUg
R0lDIFZNIHN0YXRlIGNoYW5nZSBoYW5kbGVyIj8gSXMgdGhhdCBhIFFFTVUgdGhpbmc/Cj4+Cj4+
IFllYWgsIGl0IGlzIGEgYSBRRU1VIHRoaW5nLi4uCj4+Cj4+PiBXZSBkb24ndCByZWFsbHkgaGF2
ZSB0aGF0IGNvbmNlcHQgaW4gS1ZNLCBzbyBJJ2QgYXBwcmVjaWF0ZSBpZiB5b3UgY291bGQKPj4+
IGJlIGEgYml0IG1vcmUgZXhwbGljaXQgb24gdGhpcy4KPj4KPj4gTXkgdGhvdWdodCBpcyB0byBh
ZGQgYSBuZXcgaW50ZXJmYWNlICh0byBRRU1VKSBmb3IgdGhlIHJlc3RvcmluZyBvZgo+PiB0aGUg
cGVuZGluZyBzdGF0ZXMsIHdoaWNoIGlzIGNvbXBsZXRlbHkgY29ycmVzcG9uZGluZyB0bwo+PiBL
Vk1fREVWX0FSTV9WR0lDX1NBVkVfUEVORElOR19UQUJMRVMuLi4KPj4gQW5kIGl0IGlzIGNhbGxl
ZCBmcm9tIHRoZSBHSUMgVk0gc3RhdGUgY2hhbmdlIGhhbmRsZXIgaW4gUUVNVSwgd2hpY2gKPj4g
aXMgaGFwcGVuaW5nIGFmdGVyIHRoZSByZXN0b3JpbmcgKGNhbGwga3ZtX3ZnaWNfdjRfc2V0X2Zv
cndhcmRpbmcoKSkKPj4gYnV0IGJlZm9yZSB0aGUgc3RhcnRpbmcgKHJ1bm5pbmcpIG9mIHRoZSBW
RklPIGRldmljZS4KPiAKPiBSaWdodCwgdGhhdCBtYWtlcyBzZW5zZS4gSSBzdGlsbCB3b25kZXIg
aG93IG11Y2ggdGhlIEdJQyBzYXZlL3Jlc3RvcmUKPiBzdHVmZiBkaWZmZXJzIGZyb20gb3RoZXIg
YXJjaGl0ZWN0dXJlcyB0aGF0IGltcGxlbWVudCBzaW1pbGFyIGZlYXR1cmVzLAo+IHN1Y2ggYXMg
eDg2IHdpdGggVlQtRC4KCkkgYW0gbm90IGZhbWlsaWFyIHdpdGggaXQuLi4KCj4gCj4gSXQgaXMg
b2J2aW91c2x5IHRvbyBsYXRlIHRvIGNoYW5nZSB0aGUgdXNlcnNwYWNlIGludGVyZmFjZSwgYnV0
IEkgd29uZGVyCj4gd2hldGhlciB3ZSBtaXNzZWQgc29tZXRoaW5nIGF0IHRoZSB0aW1lLgoKVGhl
IGludGVyZmFjZSBzZWVtcyB0byBiZSByZWFsbHkgYXN5bW1ldHJpY2FsPy4uLgoKT3IgaXMgdGhl
cmUgYSBwb3NzaWJpbGl0eSB0aGF0IHdlIGNvdWxkIGtub3cgd2hpY2ggaXJxIGlzIGh3IGJlZm9y
ZSB0aGUgVkZJTwpkZXZpY2UgY2FsbHMga3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoKT8KClRo
YW5rcywKU2hlbm1pbmcKCj4gCj4gVGhhbmtzLAo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

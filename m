Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A32C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 13:09:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69D74246CA
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 13:09:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69D74246CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95E364B6FE;
	Tue, 17 Nov 2020 08:09:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N0EOP3M+JejN; Tue, 17 Nov 2020 08:09:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64C5F4B729;
	Tue, 17 Nov 2020 08:09:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7EB4B729
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 08:09:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tMMVL5M0mCoQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 08:09:37 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A250A4B808
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 08:09:37 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cb5qs1QJ5zkZ6f;
 Tue, 17 Nov 2020 21:09:13 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 17 Nov 2020 21:09:22 +0800
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Forbid invalid userspace
 Redistributor accesses
To: Marc Zyngier <maz@kernel.org>
References: <20201113142801.1659-1-yuzenghui@huawei.com>
 <20201113142801.1659-2-yuzenghui@huawei.com>
 <724c43702b52aac0d3c9beb9604d1bfb@kernel.org>
 <584b7ff1-ecf2-b0ec-cea3-ccc29902f43a@huawei.com>
 <cc45285fe491aff5c28a24f94c124508@kernel.org>
 <7e58200c-814e-3598-155a-9a7e6cc24374@huawei.com>
 <c20865a267e44d1e2c0d52ce4e012263@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e7263d49-e80a-1ad2-c256-979c1ee213fa@huawei.com>
Date: Tue, 17 Nov 2020 21:09:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <c20865a267e44d1e2c0d52ce4e012263@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

T24gMjAyMC8xMS8xNyAxNjo0OSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFplbmdodWksCj4g
Cj4gT24gMjAyMC0xMS0xNiAxNDo1NywgWmVuZ2h1aSBZdSB3cm90ZToKPj4gSGkgTWFyYywKPj4K
Pj4gT24gMjAyMC8xMS8xNiAyMjoxMCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+IE15IHRha2Ug
aXMgdGhhdCBvbmx5IGlmIHRoZSAiW1JlXURpc3RyaWJ1dG9yIGJhc2UgYWRkcmVzcyIgaXMgc3Bl
Y2lmaWVkCj4+Pj4gaW4gdGhlIHN5c3RlbSBtZW1vcnkgbWFwLCB3aWxsIHRoZSB1c2VyLXByb3Zp
ZGVkIGt2bV9kZXZpY2VfYXR0ci5vZmZzZXQKPj4+PiBtYWtlIHNlbnNlLiBBbmQgd2UgY2FuIHRo
ZW4gaGFuZGxlIHRoZSBhY2Nlc3MgdG8gdGhlIHJlZ2lzdGVyIHdoaWNoIGlzCj4+Pj4gZGVmaW5l
ZCBieSAiYmFzZSBhZGRyZXNzICsgb2Zmc2V0Ii4KPj4+Cj4+PiBJJ2QgdGVuZCB0byBhZ3JlZSwg
YnV0IGl0IGlzIGp1c3QgdGhhdCB0aGlzIGlzIGEgbGFyZ2UgY2hhbmdlIGF0IC1yYzQuCj4+PiBJ
J2QgcmF0aGVyIGhhdmUgYSBxdWljayBmaXggZm9yIDUuMTAsIGFuZCBhIG1vcmUgaW52YXNpdmUg
Y2hhbmdlIGZvciAKPj4+IDUuMTEsCj4+PiBzcGFubmluZyBhbGwgdGhlIHBvc3NpYmxlIHZnaWMg
ZGV2aWNlcy4KPj4KPj4gU28geW91IHByZWZlciBmaXhpbmcgaXQgYnkgInJldHVybiBhIHZhbHVl
IHRoYXQgZG9lc24ndCBoYXZlIHRoZSBMYXN0Cj4+IGJpdCBzZXQiIGZvciB2NS4xMD8gSSdtIG9r
IHdpdGggaXQgYW5kIGNhbiBzZW5kIHYyIGZvciBpdC4KPiAKPiBDb29sLiBUaGFua3MgZm9yIHRo
YXQuCj4gCj4+IEJ0dywgbG9va2luZyBhZ2FpbiBhdCB0aGUgd2F5IHdlIGhhbmRsZSB0aGUgdXNl
ci1yZWFkaW5nIG9mIEdJQ1JfVFlQRVIKPj4KPj4gwqDCoMKgwqB2Z2ljX21taW9fcmVhZF92M3Jf
dHlwZXIodmNwdSwgYWRkciwgbGVuKQo+Pgo+PiBpdCBzZWVtcyB0aGF0IEBhZGRyIGlzIGFjdHVh
bGx5IHRoZSAqb2Zmc2V0KiBvZiBHSUNSX1RZUEVSICgweDAwMDgpIGFuZAo+PiBAYWRkciBpcyB1
bmxpa2VseSB0byBiZSBlcXVhbCB0byBsYXN0X3JkaXN0X3R5cGVyLCB3aGljaCBpcyB0aGUgKkdQ
QSogb2YKPj4gdGhlIGxhc3QgUkQuIExvb2tzIGxpa2UgdGhlIHVzZXItcmVhZGluZyBvZiBHSUNS
X1RZUEVSLkxhc3QgaXMgYWx3YXlzCj4+IGJyb2tlbj8KPiAKPiBJIHRoaW5rIHlvdSBhcmUgcmln
aHQuIFNvbWVob3csIHdlIGRvbid0IHNlZW0gdG8gdHJhY2sgdGhlIGluZGV4IG9mCj4gdGhlIFJE
IGluIHRoZSByZWdpb24sIHNvIHdlIGNhbiBuZXZlciBjb21wdXRlIHRoZSBhZGRyZXNzIG9mIHRo
ZSBSRAo+IGV2ZW4gaWYgdGhlIGJhc2UgYWRkcmVzcyBpcyBzZXQuCj4gCj4gTGV0J3MgZHJvcCB0
aGUgcmVwb3J0aW5nIG9mIExhc3QgZm9yIHVzZXJzcGFjZSBmb3Igbm93LCBhcyBpdCBuZXZlcgo+
IHdvcmtlZC4gSWYgeW91IHBvc3QgYSBwYXRjaCBhZGRyZXNzaW5nIHRoYXQgcXVpY2tseSwgSSds
bCBnZXQgaXQgdG8KPiBQYW9sbyBieSB0aGUgZW5kIG9mIHRoZSB3ZWVrICh0aGVyZSdzIGFub3Ro
ZXIgZml4IHRoYXQgbmVlZHMgbWVyZ2luZykuCgpPSy4gSSdsbCBmaXggaXQgYnkgcHJvdmlkaW5n
IGEgdWFjY2Vzc19yZWFkIGNhbGxiYWNrIGZvciBHSUNSX1RZUEVSLgoKClRoYW5rcywKWmVuZ2h1
aQoKPiAKPiBFcmljOiBkbyB3ZSBoYXZlIGFueSB0ZXN0IGNvdmVyaW5nIHRoZSB1c2Vyc3BhY2Ug
QVBJPwo+IAo+IFRoYW5rcywKPiAKPiAgwqDCoMKgwqDCoMKgwqAgTS4KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

Return-Path: <SRS0=aIiX=IH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7DBC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 09:02:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B03064F89
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 09:02:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B03064F89
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAC9F4B55E;
	Tue,  9 Mar 2021 04:02:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bcAN8qBWHqIE; Tue,  9 Mar 2021 04:02:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A83CE4B521;
	Tue,  9 Mar 2021 04:02:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E454B51A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 04:02:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fJGZO6TWyN02 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 04:02:35 -0500 (EST)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E8BB4B2F6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 04:02:34 -0500 (EST)
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.55])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Dvq0C3dsFz143DX;
 Tue,  9 Mar 2021 16:59:39 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 9 Mar 2021 17:02:30 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 17:02:30 +0800
Subject: Re: [PATCH 2/2] KVM: arm64: Skip the cache flush when coalescing
 tables into a block
To: Marc Zyngier <maz@kernel.org>
References: <20210125141044.380156-1-wangyanan55@huawei.com>
 <20210125141044.380156-3-wangyanan55@huawei.com>
 <20210308163454.GA26561@willie-the-truck>
 <8a947c73-16e9-7ca7-c185-d4c951938505@huawei.com>
 <87y2ewyawn.wl-maz@kernel.org>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <fbdd19aa-fae6-0613-d5ec-dd062c66514a@huawei.com>
Date: Tue, 9 Mar 2021 17:02:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87y2ewyawn.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Ck9uIDIwMjEvMy85IDE2OjQzLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gVHVlLCAwOSBNYXIg
MjAyMSAwODozNDo0MyArMDAwMCwKPiAid2FuZ3lhbmFuIChZKSIgPHdhbmd5YW5hbjU1QGh1YXdl
aS5jb20+IHdyb3RlOgo+Pgo+PiBPbiAyMDIxLzMvOSAwOjM0LCBXaWxsIERlYWNvbiB3cm90ZToK
Pj4+IE9uIE1vbiwgSmFuIDI1LCAyMDIxIGF0IDEwOjEwOjQ0UE0gKzA4MDAsIFlhbmFuIFdhbmcg
d3JvdGU6Cj4+Pj4gQWZ0ZXIgZGlydHktbG9nZ2luZyBpcyBzdG9wcGVkIGZvciBhIFZNIGNvbmZp
Z3VyZWQgd2l0aCBodWdlIG1hcHBpbmdzLAo+Pj4+IEtWTSB3aWxsIHJlY292ZXIgdGhlIHRhYmxl
IG1hcHBpbmdzIGJhY2sgdG8gYmxvY2sgbWFwcGluZ3MuIEFzIHdlIG9ubHkKPj4+PiByZXBsYWNl
IHRoZSBleGlzdGluZyBwYWdlIHRhYmxlcyB3aXRoIGEgYmxvY2sgZW50cnkgYW5kIHRoZSBjYWNo
ZWFiaWxpdHkKPj4+PiBoYXMgbm90IGJlZW4gY2hhbmdlZCwgdGhlIGNhY2hlIG1haW50ZW5hbmNl
IG9wcmVhdGlvbnMgY2FuIGJlIHNraXBwZWQuCj4+Pj4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBZYW5h
biBXYW5nIDx3YW5neWFuYW41NUBodWF3ZWkuY29tPgo+Pj4+IC0tLQo+Pj4+ICAgIGFyY2gvYXJt
NjQva3ZtL21tdS5jIHwgMTIgKysrKysrKysrLS0tCj4+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDkg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPj4+Pgo+Pj4+IGRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2t2bS9tbXUuYyBiL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4+Pj4gaW5kZXggOGU4NTQ5
ZWExZDcwLi4zN2I0MjdkY2JjNGYgMTAwNjQ0Cj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vbW11
LmMKPj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS9tbXUuYwo+Pj4+IEBAIC03NDQsNyArNzQ0LDcg
QEAgc3RhdGljIGludCB1c2VyX21lbV9hYm9ydChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHBoeXNf
YWRkcl90IGZhdWx0X2lwYSwKPj4+PiAgICB7Cj4+Pj4gICAgCWludCByZXQgPSAwOwo+Pj4+ICAg
IAlib29sIHdyaXRlX2ZhdWx0LCB3cml0YWJsZSwgZm9yY2VfcHRlID0gZmFsc2U7Cj4+Pj4gLQli
b29sIGV4ZWNfZmF1bHQ7Cj4+Pj4gKwlib29sIGV4ZWNfZmF1bHQsIGFkanVzdF9odWdlcGFnZTsK
Pj4+PiAgICAJYm9vbCBkZXZpY2UgPSBmYWxzZTsKPj4+PiAgICAJdW5zaWduZWQgbG9uZyBtbXVf
c2VxOwo+Pj4+ICAgIAlzdHJ1Y3Qga3ZtICprdm0gPSB2Y3B1LT5rdm07Cj4+Pj4gQEAgLTg3Miwx
MiArODcyLDE4IEBAIHN0YXRpYyBpbnQgdXNlcl9tZW1fYWJvcnQoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBwaHlzX2FkZHJfdCBmYXVsdF9pcGEsCj4+Pj4gICAgCQltYXJrX3BhZ2VfZGlydHkoa3Zt
LCBnZm4pOwo+Pj4+ICAgIAl9Cj4+Pj4gICAgLQlpZiAoZmF1bHRfc3RhdHVzICE9IEZTQ19QRVJN
ICYmICFkZXZpY2UpCj4+Pj4gKwkvKgo+Pj4+ICsJICogVGhlcmUgaXMgbm8gbmVjZXNzaXR5IHRv
IHBlcmZvcm0gY2FjaGUgbWFpbnRlbmFuY2Ugb3BlcmF0aW9ucyBpZiB3ZQo+Pj4+ICsJICogd2ls
bCBvbmx5IHJlcGxhY2UgdGhlIGV4aXN0aW5nIHRhYmxlIG1hcHBpbmdzIHdpdGggYSBibG9jayBt
YXBwaW5nLgo+Pj4+ICsJICovCj4+Pj4gKwlhZGp1c3RfaHVnZXBhZ2UgPSBmYXVsdF9ncmFudWxl
IDwgdm1hX3BhZ2VzaXplID8gdHJ1ZSA6IGZhbHNlOwo+Pj4gbml0OiB5b3UgZG9uJ3QgbmVlZCB0
aGUgJz8gdHJ1ZSA6IGZhbHNlJyBwYXJ0Cj4+Pgo+Pj4gVGhhdCBzYWlkLCB5b3VyIHByZXZpb3Vz
IHBhdGNoIGNoZWNrcyBmb3IgJ2ZhdWx0X2dyYW51bGUgPiB2bWFfcGFnZXNpemUnLAo+Pj4gc28g
SSdtIG5vdCBzdXJlIHRoZSBsb2NhbCB2YXJpYWJsZSBoZWxwcyBhbGwgdGhhdCBtdWNoIGhlcmUg
YmVjYXVzZSBpdAo+Pj4gb2JzY3VyZXMgdGhlIHNpemUgY2hlY2tzIGluIG15IG9waW5pb24uIEl0
IHdvdWxkIGJlIG1vcmUgc3RyYWlnaHQtZm9yd2FyZAo+Pj4gaWYgd2UgY291bGQgc3RydWN0dXJl
IHRoZSBsb2dpYyBhczoKPj4+Cj4+Pgo+Pj4gCWlmIChmYXVsdF9ncmFudWxlIDwgdm1hX3BhZ2Vz
aXplKSB7Cj4+Pgo+Pj4gCX0gZWxzZSBpZiAoZmF1bHRfZ3JhbnVsZSA+IHZtYV9wYWdlX3NpemUp
IHsKPj4+Cj4+PiAJfSBlbHNlIHsKPj4+Cj4+PiAJfQo+Pj4KPj4+IFdpdGggc29tZSBjb21tZW50
cyBkZXNjcmliaW5nIHdoYXQgd2UgY2FuIGluZmVyIGFib3V0IHRoZSBtZW1jYWNoZSBhbmQgY2Fj
aGUKPj4+IG1haW50ZW5hbmNlIHJlcXVpcmVtZW50cyBmb3IgZWFjaCBjYXNlLgo+PiBUaGFua3Mg
Zm9yIHlvdXIgc3VnZ2VzdGlvbiBoZXJlLCBXaWxsLgo+PiBCdXQgSSBoYXZlIHJlc2VudCBhbm90
aGVyIG5ld2VyIHNlcmllcyBbMV0gKEtWTTogYXJtNjQ6IEltcHJvdmUKPj4gZWZmaWNpZW5jeSBv
ZiBzdGFnZTIgcGFnZSB0YWJsZSkKPj4gcmVjZW50bHksIHdoaWNoIGhhcyB0aGUgc2FtZSB0aGVt
ZSBidXQgZGlmZmVyZW50IHNvbHV0aW9ucyB0aGF0IEkKPj4gdGhpbmsgYXJlIGJldHRlci4KPj4g
WzFdCj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMTAyMDgxMTIyNTAuMTYzNTY4
LTEtd2FuZ3lhbmFuNTVAaHVhd2VpLmNvbS8KPj4KPj4gQ291bGQgeW91IHBsZWFzZSBjb21tZW50
IG9uIHRoYXQgc2VyaWVzID/CoCBJIHRoaW5rIGl0IGNhbiBiZSBmb3VuZCBpbgo+PiB5b3VyIGlu
Ym94IDopLgo+IFRoZXJlIHdlcmUgYWxyZWFkeSBhIGJ1bmNoIG9mIGNvbW1lbnRzIG9uIHRoYXQg
c2VyaWVzLCBhbmQgSSBzdG9wcGVkCj4gYXQgdGhlIHBvaW50IHdoZXJlIHRoZSBjYWNoZSBtYWlu
dGVuYW5jZSB3YXMgYnJva2VuLiBQbGVhc2UgcmVzcGluCj4gdGhhdCBzZXJpZXMgaWYgeW91IHdh
bnQgZnVydGhlciBmZWVkYmFjayBvbiBpdC4KT2ssIEkgd2lsbCBzZW5kIGEgbmV3IHZlcnNpb24g
bGF0ZXIuCj4KPiBJbiB0aGUgZnV0dXJlLCBpZiB5b3UgZGVwcmVjYXRlIGEgc2VyaWVzICh3aGlj
aCBpcyBjb21wbGV0ZWx5Cj4gdW5kZXJzdGFuZGFibGUpLCBwbGVhc2UgbGVhdmUgYSBub3RlIG9u
IHRoZSBsaXN0IHdpdGggYSBwb2ludGVyIHRvIHRoZQo+IG5ldyBzZXJpZXMgc28gdGhhdCBwZW9w
bGUgZG9uJ3Qgd2FzdGUgdGltZSByZXZpZXdpbmcgYW4gb2Jzb2xldGUKPiBzZXJpZXMuIE9yIHBv
c3QgdGhlIG5ldyBzZXJpZXMgd2l0aCBhIG5ldyB2ZXJzaW9uIG51bWJlciBzbyB0aGF0IGl0IGlz
Cj4gb2J2aW91cyB0aGF0IHRoZSBvcmlnaW5hbCBzZXJpZXMgaGFzIGJlZW4gc3VwZXJzZWRlZC4K
SSBhcG9sb2dpemUgZm9yIHRoaXMsIEkgd2lsbCBiZSBtb3JlIGNhcmVmdWwgaW4gdGhlIGZ1dHVy
ZS4KClRoYW5rcywKCllhbmFuCj4gVGhhbmtzLAo+Cj4gCU0uCj4KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==

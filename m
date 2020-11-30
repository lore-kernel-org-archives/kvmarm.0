Return-Path: <SRS0=p1b3=FE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D50C64E8A
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 09:40:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35A2C20825
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 09:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35A2C20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FAF84D5BD;
	Mon, 30 Nov 2020 04:40:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0uZ1VUMATrDk; Mon, 30 Nov 2020 04:40:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8FB84D5BA;
	Mon, 30 Nov 2020 04:40:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C6204DDE5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 02:23:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OGMxqBWtgxqt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2020 02:23:37 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA2384B3E8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 02:23:36 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CkxXN6vK8zLxYq;
 Mon, 30 Nov 2020 15:23:00 +0800 (CST)
Received: from [10.174.184.228] (10.174.184.228) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Nov 2020 15:23:18 +0800
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
 <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
 <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
Message-ID: <48c10467-30f3-9b5c-bbcb-533a51516dc5@huawei.com>
Date: Mon, 30 Nov 2020 15:23:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.184.228]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Mon, 30 Nov 2020 04:40:37 -0500
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

T24gMjAyMC8xMS8yNCAyMToxMiwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gT24gMjAyMC8xMS8yNCAx
Njo0NCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBPbiAyMDIwLTExLTI0IDA4OjEwLCBTaGVubWlu
ZyBMdSB3cm90ZToKPj4+IE9uIDIwMjAvMTEvMjMgMTc6MjcsIE1hcmMgWnluZ2llciB3cm90ZToK
Pj4+PiBPbiAyMDIwLTExLTIzIDA2OjU0LCBTaGVubWluZyBMdSB3cm90ZToKPj4+Pj4gRnJvbTog
WmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+Pj4+Cj4+Pj4+IFdoZW4gc2V0dGlu
ZyB0aGUgZm9yd2FyZGluZyBwYXRoIG9mIGEgVkxQSSwgaXQgaXMgbW9yZSBjb25zaXN0ZW50IHRv
Cj4+Pj4KPj4+PiBJJ20gbm90IHN1cmUgaXQgaXMgbW9yZSBjb25zaXN0ZW50LiBJdCBpcyBhICpu
ZXcqIGJlaGF2aW91ciwgYmVjYXVzZSBpdCBvbmx5Cj4+Pj4gbWF0dGVycyBmb3IgbWlncmF0aW9u
LCB3aGljaCBoYXMgYmVlbiBzbyBmYXIgdW5zdXBwb3J0ZWQuCj4+Pgo+Pj4gQWxyaWdodCwgY29u
c2lzdGVudCBtYXkgbm90IGJlIGFjY3VyYXRlLi4uCj4+PiBCdXQgSSBoYXZlIGRvdWJ0IHRoYXQg
d2hldGhlciB0aGVyZSBpcyByZWFsbHkgbm8gbmVlZCB0byB0cmFuc2ZlciB0aGUKPj4+IHBlbmRp
bmcgc3RhdGVzCj4+PiBmcm9tIGt2bSd2Z2ljIHRvIFZQVCBpbiBzZXRfZm9yd2FyZGluZyByZWdh
cmRsZXNzIG9mIG1pZ3JhdGlvbiwgYW5kIHRoZSBzaW1pbGFyCj4+PiBmb3IgdW5zZXRfZm9yd2Fy
ZGluZy4KPj4KPj4gSWYgeW91IGhhdmUgdG8gdHJhbnNmZXIgdGhhdCBzdGF0ZSBvdXRzaWRlIG9m
IHRoZSBhIHNhdmUvcmVzdG9yZSwgaXQgbWVhbnMgdGhhdAo+PiB5b3UgaGF2ZSBtaXNzZWQgdGhl
IHByb2dyYW1taW5nIG9mIHRoZSBQQ0kgZW5kcG9pbnQuIFRoaXMgaXMgYW4gZXN0YWJsaXNoZWQK
Pj4gcmVzdHJpY3Rpb24gdGhhdCB0aGUgTVNJIHByb2dyYW1taW5nIG11c3Qgb2NjdXIgKmFmdGVy
KiB0aGUgdHJhbnNsYXRpb24gaGFzCj4+IGJlZW4gZXN0YWJsaXNoZWQgdXNpbmcgTUFQSS9NQVBU
SSAoc2VlIHRoZSBsYXJnZSBjb21tZW50IGF0IHRoZSBiZWdpbm5pbmcgb2YKPj4gdmdpYy12NC5j
KS4KPj4KPj4gSWYgeW91IHdhbnQgdG8gcmV2aXNpdCB0aGlzLCBmYWlyIGVub3VnaC4gQnV0IHlv
dSB3aWxsIG5lZWQgYSBsb3QgbW9yZSB0aGFuCj4+IGp1c3Qgb3Bwb3J0dW5pc3RpY2FsbHkgdHJh
bnNmZXIgdGhlIHBlbmRpbmcgc3RhdGUuCj4gCj4gVGhhbmtzLCBJIHdpbGwgbG9vayBhdCB3aGF0
IHlvdSBtZW50aW9uZWQuCj4gCj4+Cj4+Pgo+Pj4+Cj4+Pj4+IGFsc28gdHJhbnNmZXIgdGhlIHBl
bmRpbmcgc3RhdGUgZnJvbSBpcnEtPnBlbmRpbmdfbGF0Y2ggdG8gVlBUIChlc3BlY2lhbGx5Cj4+
Pj4+IGluIG1pZ3JhdGlvbiwgdGhlIHBlbmRpbmcgc3RhdGVzIG9mIFZMUElzIGFyZSByZXN0b3Jl
ZCBpbnRvIGt2beKAmXMgdmdpYwo+Pj4+PiBmaXJzdCkuIEFuZCB3ZSBjdXJyZW50bHkgc2VuZCAi
SU5UK1ZTWU5DIiB0byB0cmlnZ2VyIGEgVkxQSSB0byBwZW5kaW5nLgo+Pj4+Pgo+Pj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4+Pj4gU2lnbmVk
LW9mZi1ieTogU2hlbm1pbmcgTHUgPGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4KPj4+Pj4gLS0tCj4+
Pj4+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMgfCAxMiArKysrKysrKysrKysKPj4+
Pj4gwqAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQo+Pj4+Pgo+Pj4+PiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMgYi9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtdjQuYwo+Pj4+PiBpbmRleCBiNWZhNzNjOWZkMzUuLmNjM2FiOWNlYTE4MiAxMDA2NDQK
Pj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKPj4+Pj4gKysrIGIvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKPj4+Pj4gQEAgLTQxOCw2ICs0MTgsMTggQEAgaW50
IGt2bV92Z2ljX3Y0X3NldF9mb3J3YXJkaW5nKHN0cnVjdCBrdm0gKmt2bSwgaW50IHZpcnEsCj4+
Pj4+IMKgwqDCoMKgIGlycS0+aG9zdF9pcnHCoMKgwqAgPSB2aXJxOwo+Pj4+PiDCoMKgwqDCoCBh
dG9taWNfaW5jKCZtYXAudnBlLT52bHBpX2NvdW50KTsKPj4+Pj4KPj4+Pj4gK8KgwqDCoCAvKiBU
cmFuc2ZlciBwZW5kaW5nIHN0YXRlICovCj4+Pj4+ICvCoMKgwqAgcmV0ID0gaXJxX3NldF9pcnFj
aGlwX3N0YXRlKGlycS0+aG9zdF9pcnEsCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBJUlFDSElQX1NUQVRFX1BFTkRJTkcsCj4+Pj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpcnEtPnBlbmRpbmdfbGF0Y2gpOwo+Pj4+PiArwqDC
oMKgIFdBUk5fUkFURUxJTUlUKHJldCwgIklSUSAlZCIsIGlycS0+aG9zdF9pcnEpOwo+Pj4+PiAr
Cj4+Pj4+ICvCoMKgwqAgLyoKPj4+Pj4gK8KgwqDCoMKgICogTGV0IGl0IGJlIHBydW5lZCBmcm9t
IGFwX2xpc3QgbGF0ZXIgYW5kIGRvbid0IGJvdGhlcgo+Pj4+PiArwqDCoMKgwqAgKiB0aGUgTGlz
dCBSZWdpc3Rlci4KPj4+Pj4gK8KgwqDCoMKgICovCj4+Pj4+ICvCoMKgwqAgaXJxLT5wZW5kaW5n
X2xhdGNoID0gZmFsc2U7Cj4+Pj4KPj4+PiBJdCBvY2N1cnMgdG8gbWUgdGhhdCBjYWxsaW5nIGlu
dG8gaXJxX3NldF9pcnFjaGlwX3N0YXRlKCkgZm9yIGEgbGFyZ2UKPj4+PiBudW1iZXIgb2YgaW50
ZXJydXB0cyBjYW4gdGFrZSBhIHNpZ25pZmljYW50IGFtb3VudCBvZiB0aW1lLiBJdCBpcyBhbHNv
Cj4+Pj4gb2RkIHRoYXQgeW91IGR1bXAgdGhlIFZQVCB3aXRoIHRoZSBWUEUgdW5tYXBwZWQsIGJ1
dCByZWx5IG9uIHRoZSBWUEUKPj4+PiBiZWluZyBtYXBwZWQgZm9yIHRoZSBvcHBvc2l0ZSBvcGVy
YXRpb24uCj4+Pj4KPj4+PiBTaG91bGRuJ3QgdGhlc2UgYmUgc3ltbWV0cmljLCBhbGwgcGVyZm9y
bWVkIHdoaWxlIHRoZSBWUEUgaXMgdW5tYXBwZWQ/Cj4+Pj4gSXQgd291bGQgYWxzbyBzYXZlIGEg
bG90IG9mIElUUyB0cmFmZmljLgo+Pj4+Cj4+Pgo+Pj4gTXkgdGhvdWdodCB3YXMgdG8gdXNlIHRo
ZSBleGlzdGluZyBpbnRlcmZhY2UgZGlyZWN0bHkgd2l0aG91dCB1bm1hcHBpbmcuLi4KPj4+Cj4+
PiBJZiB5b3Ugd2FudCB0byB1bm1hcCB0aGUgdlBFIGFuZCBwb2tlIHRoZSBWUFQgaGVyZSwgYXMg
SSBzYWlkIGluIHRoZSBjb3Zlcgo+Pj4gbGV0dGVyLCBzZXQvdW5zZXRfZm9yd2FyZGluZyBtaWdo
dCBhbHNvIGJlIGNhbGxlZCB3aGVuIGFsbCBkZXZpY2VzIGFyZSBydW5uaW5nCj4+PiBhdCBub3Jt
YWwgcnVuIHRpbWUsIGluIHdoaWNoIGNhc2UgdGhlIHVubWFwcGluZyBvZiB0aGUgdlBFIGlzIG5v
dCBhbGxvd2VkLi4uCj4+Cj4+IE5vLCBJJ20gc3VnZ2VzdGluZyB0aGF0IHlvdSBkb24ndCBkbyBh
bnl0aGluZyBoZXJlLCBidXQgaW5zdGVhZCBhcyBhIGJ5LXByb2R1Y3QKPj4gb2YgcmVzdG9yaW5n
IHRoZSBJVFMgdGFibGVzLiBXaGF0IGdvZXMgd3JvbmcgaWYgeW91IHVzZSB0aGUKPj4gS1ZNX0RF
Vl9BUk1fSVRTX1JFU1RPUkVfVEFCTEUgYmFja2VuZCBpbnN0ZWFkPwo+IAo+IFRoZXJlIGlzIGFu
IGlzc3VlIGlmIHdlIGRvIGl0IGluIHRoZSByZXN0b3Jpbmcgb2YgdGhlIElUUyB0YWJsZXM6IHRo
ZSB0cmFuc2ZlcnJpbmcKPiBvZiB0aGUgcGVuZGluZyBzdGF0ZSBuZWVkcyB0aGUgaXJxIHRvIGJl
IG1hcmtlZCBhcyBodyBiZWZvcmUsIHdoaWNoIGlzIGRvbmUgYnkgdGhlCj4gcGFzcy10aHJvdWdo
IGRldmljZSwgYnV0IHRoZSBjb25maWd1cmluZyBvZiB0aGUgZm9yd2FyZGluZyBwYXRoIG9mIHRo
ZSBWTFBJIGRlcGVuZHMKPiBvbiB0aGUgcmVzdG9yaW5nIG9mIHRoZSB2Z2ljIGZpcnN0Li4uIEl0
IGlzIGEgY2lyY3VsYXIgZGVwZW5kZW5jeS4KPiAKCkhpIE1hcmMsCgpXZSBhcmUgcG9uZGVyaW5n
IG92ZXIgdGhpcyBwcm9ibGVtIHRoZXNlIGRheXMsIGJ1dCBzdGlsbCBkb24ndCBnZXQgYSBnb29k
IHNvbHV0aW9uLi4uCkNvdWxkIHlvdSBnaXZlIHVzIHNvbWUgYWR2aWNlIG9uIHRoaXM/CgpPciBj
b3VsZCB3ZSBtb3ZlIHRoZSByZXN0b3Jpbmcgb2YgdGhlIHBlbmRpbmcgc3RhdGVzIChpbmNsdWRl
IHRoZSBzeW5jIGZyb20gZ3Vlc3QKUkFNIGFuZCB0aGUgdHJhbnNmZXIgdG8gSFcpIHRvIHRoZSBH
SUMgVk0gc3RhdGUgY2hhbmdlIGhhbmRsZXIsIHdoaWNoIGlzIGNvbXBsZXRlbHkKY29ycmVzcG9u
ZGluZyB0byBzYXZlX3BlbmRpbmdfdGFibGVzIChtb3JlIHN5bW1ldHJpYz8pIGFuZCBkb24ndCBl
eHBvc2UgR0lDdjQuLi4KClRoYW5rcywKU2hlbm1pbmcKCj4+Cj4+PiBBbm90aGVyIHBvc3NpYmxl
IHNvbHV0aW9uIGlzIHRvIGFkZCBhIG5ldyBkZWRpY2F0ZWQgaW50ZXJmYWNlIHRvIFFFTVUKPj4+
IHRvIHRyYW5zZmVyCj4+PiB0aGVzZSBwZW5kaW5nIHN0YXRlcyB0byBIVyBpbiBHSUMgVk0gc3Rh
dGUgY2hhbmdlIGhhbmRsZXIgY29ycmVzcG9uZGluZyB0bwo+Pj4gc2F2ZV9wZW5kaW5nX3RhYmxl
cz8KPj4KPj4gVXNlcnNwYWNlIGhhcyBubyB3YXkgdG8ga25vdyB3ZSB1c2UgR0lDdjQsIGFuZCBJ
IGludGVuZCB0byBrZWVwIGl0Cj4+IGNvbXBsZXRlbHkgb3V0IG9mIHRoZSBsb29wLiBUaGUgQVBJ
IGlzIGFscmVhZHkgcHJldHR5IHRvcnR1b3VzLCBhbmQKPj4gSSByZWFsbHkgZG9uJ3Qgd2FudCB0
byBhZGQgYW55IGV4dHJhIGNvbXBsZXhpdHkgdG8gaXQuCj4+Cj4+IFRoYW5rcywKPj4KPj4gwqDC
oMKgwqDCoMKgwqAgTS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

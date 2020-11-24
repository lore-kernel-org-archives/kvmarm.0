Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB07C64E7A
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 436DA20757
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 436DA20757
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C59284BDB4;
	Tue, 24 Nov 2020 09:49:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q5PGLlJbuWNZ; Tue, 24 Nov 2020 09:49:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4624BDB0;
	Tue, 24 Nov 2020 09:49:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A8F54BCC7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 08:12:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7AQ9k83eX-ja for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 08:12:21 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BC004BBE5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 08:12:21 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CgPYk74vlzhfq2;
 Tue, 24 Nov 2020 21:11:54 +0800 (CST)
Received: from [10.174.187.74] (10.174.187.74) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 21:12:04 +0800
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
To: Marc Zyngier <maz@kernel.org>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
 <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
Date: Tue, 24 Nov 2020 21:12:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Tue, 24 Nov 2020 09:49:14 -0500
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

T24gMjAyMC8xMS8yNCAxNjo0NCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjAtMTEtMjQg
MDg6MTAsIFNoZW5taW5nIEx1IHdyb3RlOgo+PiBPbiAyMDIwLzExLzIzIDE3OjI3LCBNYXJjIFp5
bmdpZXIgd3JvdGU6Cj4+PiBPbiAyMDIwLTExLTIzIDA2OjU0LCBTaGVubWluZyBMdSB3cm90ZToK
Pj4+PiBGcm9tOiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4+Pgo+Pj4+IFdo
ZW4gc2V0dGluZyB0aGUgZm9yd2FyZGluZyBwYXRoIG9mIGEgVkxQSSwgaXQgaXMgbW9yZSBjb25z
aXN0ZW50IHRvCj4+Pgo+Pj4gSSdtIG5vdCBzdXJlIGl0IGlzIG1vcmUgY29uc2lzdGVudC4gSXQg
aXMgYSAqbmV3KiBiZWhhdmlvdXIsIGJlY2F1c2UgaXQgb25seQo+Pj4gbWF0dGVycyBmb3IgbWln
cmF0aW9uLCB3aGljaCBoYXMgYmVlbiBzbyBmYXIgdW5zdXBwb3J0ZWQuCj4+Cj4+IEFscmlnaHQs
IGNvbnNpc3RlbnQgbWF5IG5vdCBiZSBhY2N1cmF0ZS4uLgo+PiBCdXQgSSBoYXZlIGRvdWJ0IHRo
YXQgd2hldGhlciB0aGVyZSBpcyByZWFsbHkgbm8gbmVlZCB0byB0cmFuc2ZlciB0aGUKPj4gcGVu
ZGluZyBzdGF0ZXMKPj4gZnJvbSBrdm0ndmdpYyB0byBWUFQgaW4gc2V0X2ZvcndhcmRpbmcgcmVn
YXJkbGVzcyBvZiBtaWdyYXRpb24sIGFuZCB0aGUgc2ltaWxhcgo+PiBmb3IgdW5zZXRfZm9yd2Fy
ZGluZy4KPiAKPiBJZiB5b3UgaGF2ZSB0byB0cmFuc2ZlciB0aGF0IHN0YXRlIG91dHNpZGUgb2Yg
dGhlIGEgc2F2ZS9yZXN0b3JlLCBpdCBtZWFucyB0aGF0Cj4geW91IGhhdmUgbWlzc2VkIHRoZSBw
cm9ncmFtbWluZyBvZiB0aGUgUENJIGVuZHBvaW50LiBUaGlzIGlzIGFuIGVzdGFibGlzaGVkCj4g
cmVzdHJpY3Rpb24gdGhhdCB0aGUgTVNJIHByb2dyYW1taW5nIG11c3Qgb2NjdXIgKmFmdGVyKiB0
aGUgdHJhbnNsYXRpb24gaGFzCj4gYmVlbiBlc3RhYmxpc2hlZCB1c2luZyBNQVBJL01BUFRJIChz
ZWUgdGhlIGxhcmdlIGNvbW1lbnQgYXQgdGhlIGJlZ2lubmluZyBvZgo+IHZnaWMtdjQuYykuCj4g
Cj4gSWYgeW91IHdhbnQgdG8gcmV2aXNpdCB0aGlzLCBmYWlyIGVub3VnaC4gQnV0IHlvdSB3aWxs
IG5lZWQgYSBsb3QgbW9yZSB0aGFuCj4ganVzdCBvcHBvcnR1bmlzdGljYWxseSB0cmFuc2ZlciB0
aGUgcGVuZGluZyBzdGF0ZS4KClRoYW5rcywgSSB3aWxsIGxvb2sgYXQgd2hhdCB5b3UgbWVudGlv
bmVkLgoKPiAKPj4KPj4+Cj4+Pj4gYWxzbyB0cmFuc2ZlciB0aGUgcGVuZGluZyBzdGF0ZSBmcm9t
IGlycS0+cGVuZGluZ19sYXRjaCB0byBWUFQgKGVzcGVjaWFsbHkKPj4+PiBpbiBtaWdyYXRpb24s
IHRoZSBwZW5kaW5nIHN0YXRlcyBvZiBWTFBJcyBhcmUgcmVzdG9yZWQgaW50byBrdm3igJlzIHZn
aWMKPj4+PiBmaXJzdCkuIEFuZCB3ZSBjdXJyZW50bHkgc2VuZCAiSU5UK1ZTWU5DIiB0byB0cmln
Z2VyIGEgVkxQSSB0byBwZW5kaW5nLgo+Pj4+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogWmVuZ2h1aSBZ
dSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogU2hlbm1pbmcgTHUg
PGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4KPj4+PiAtLS0KPj4+PiDCoGFyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy12NC5jIHwgMTIgKysrKysrKysrKysrCj4+Pj4gwqAxIGZpbGUgY2hhbmdlZCwgMTIg
aW5zZXJ0aW9ucygrKQo+Pj4+Cj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMv
dmdpYy12NC5jIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKPj4+PiBpbmRleCBiNWZh
NzNjOWZkMzUuLmNjM2FiOWNlYTE4MiAxMDA2NDQKPj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtdjQuYwo+Pj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4+
Pj4gQEAgLTQxOCw2ICs0MTgsMTggQEAgaW50IGt2bV92Z2ljX3Y0X3NldF9mb3J3YXJkaW5nKHN0
cnVjdCBrdm0gKmt2bSwgaW50IHZpcnEsCj4+Pj4gwqDCoMKgwqAgaXJxLT5ob3N0X2lyccKgwqDC
oCA9IHZpcnE7Cj4+Pj4gwqDCoMKgwqAgYXRvbWljX2luYygmbWFwLnZwZS0+dmxwaV9jb3VudCk7
Cj4+Pj4KPj4+PiArwqDCoMKgIC8qIFRyYW5zZmVyIHBlbmRpbmcgc3RhdGUgKi8KPj4+PiArwqDC
oMKgIHJldCA9IGlycV9zZXRfaXJxY2hpcF9zdGF0ZShpcnEtPmhvc3RfaXJxLAo+Pj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBJUlFDSElQX1NUQVRFX1BFTkRJTkcs
Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlycS0+cGVuZGlu
Z19sYXRjaCk7Cj4+Pj4gK8KgwqDCoCBXQVJOX1JBVEVMSU1JVChyZXQsICJJUlEgJWQiLCBpcnEt
Pmhvc3RfaXJxKTsKPj4+PiArCj4+Pj4gK8KgwqDCoCAvKgo+Pj4+ICvCoMKgwqDCoCAqIExldCBp
dCBiZSBwcnVuZWQgZnJvbSBhcF9saXN0IGxhdGVyIGFuZCBkb24ndCBib3RoZXIKPj4+PiArwqDC
oMKgwqAgKiB0aGUgTGlzdCBSZWdpc3Rlci4KPj4+PiArwqDCoMKgwqAgKi8KPj4+PiArwqDCoMKg
IGlycS0+cGVuZGluZ19sYXRjaCA9IGZhbHNlOwo+Pj4KPj4+IEl0IG9jY3VycyB0byBtZSB0aGF0
IGNhbGxpbmcgaW50byBpcnFfc2V0X2lycWNoaXBfc3RhdGUoKSBmb3IgYSBsYXJnZQo+Pj4gbnVt
YmVyIG9mIGludGVycnVwdHMgY2FuIHRha2UgYSBzaWduaWZpY2FudCBhbW91bnQgb2YgdGltZS4g
SXQgaXMgYWxzbwo+Pj4gb2RkIHRoYXQgeW91IGR1bXAgdGhlIFZQVCB3aXRoIHRoZSBWUEUgdW5t
YXBwZWQsIGJ1dCByZWx5IG9uIHRoZSBWUEUKPj4+IGJlaW5nIG1hcHBlZCBmb3IgdGhlIG9wcG9z
aXRlIG9wZXJhdGlvbi4KPj4+Cj4+PiBTaG91bGRuJ3QgdGhlc2UgYmUgc3ltbWV0cmljLCBhbGwg
cGVyZm9ybWVkIHdoaWxlIHRoZSBWUEUgaXMgdW5tYXBwZWQ/Cj4+PiBJdCB3b3VsZCBhbHNvIHNh
dmUgYSBsb3Qgb2YgSVRTIHRyYWZmaWMuCj4+Pgo+Pgo+PiBNeSB0aG91Z2h0IHdhcyB0byB1c2Ug
dGhlIGV4aXN0aW5nIGludGVyZmFjZSBkaXJlY3RseSB3aXRob3V0IHVubWFwcGluZy4uLgo+Pgo+
PiBJZiB5b3Ugd2FudCB0byB1bm1hcCB0aGUgdlBFIGFuZCBwb2tlIHRoZSBWUFQgaGVyZSwgYXMg
SSBzYWlkIGluIHRoZSBjb3Zlcgo+PiBsZXR0ZXIsIHNldC91bnNldF9mb3J3YXJkaW5nIG1pZ2h0
IGFsc28gYmUgY2FsbGVkIHdoZW4gYWxsIGRldmljZXMgYXJlIHJ1bm5pbmcKPj4gYXQgbm9ybWFs
IHJ1biB0aW1lLCBpbiB3aGljaCBjYXNlIHRoZSB1bm1hcHBpbmcgb2YgdGhlIHZQRSBpcyBub3Qg
YWxsb3dlZC4uLgo+IAo+IE5vLCBJJ20gc3VnZ2VzdGluZyB0aGF0IHlvdSBkb24ndCBkbyBhbnl0
aGluZyBoZXJlLCBidXQgaW5zdGVhZCBhcyBhIGJ5LXByb2R1Y3QKPiBvZiByZXN0b3JpbmcgdGhl
IElUUyB0YWJsZXMuIFdoYXQgZ29lcyB3cm9uZyBpZiB5b3UgdXNlIHRoZQo+IEtWTV9ERVZfQVJN
X0lUU19SRVNUT1JFX1RBQkxFIGJhY2tlbmQgaW5zdGVhZD8KClRoZXJlIGlzIGFuIGlzc3VlIGlm
IHdlIGRvIGl0IGluIHRoZSByZXN0b3Jpbmcgb2YgdGhlIElUUyB0YWJsZXM6IHRoZSB0cmFuc2Zl
cnJpbmcKb2YgdGhlIHBlbmRpbmcgc3RhdGUgbmVlZHMgdGhlIGlycSB0byBiZSBtYXJrZWQgYXMg
aHcgYmVmb3JlLCB3aGljaCBpcyBkb25lIGJ5IHRoZQpwYXNzLXRocm91Z2ggZGV2aWNlLCBidXQg
dGhlIGNvbmZpZ3VyaW5nIG9mIHRoZSBmb3J3YXJkaW5nIHBhdGggb2YgdGhlIFZMUEkgZGVwZW5k
cwpvbiB0aGUgcmVzdG9yaW5nIG9mIHRoZSB2Z2ljIGZpcnN0Li4uIEl0IGlzIGEgY2lyY3VsYXIg
ZGVwZW5kZW5jeS4KCj4gCj4+IEFub3RoZXIgcG9zc2libGUgc29sdXRpb24gaXMgdG8gYWRkIGEg
bmV3IGRlZGljYXRlZCBpbnRlcmZhY2UgdG8gUUVNVQo+PiB0byB0cmFuc2Zlcgo+PiB0aGVzZSBw
ZW5kaW5nIHN0YXRlcyB0byBIVyBpbiBHSUMgVk0gc3RhdGUgY2hhbmdlIGhhbmRsZXIgY29ycmVz
cG9uZGluZyB0bwo+PiBzYXZlX3BlbmRpbmdfdGFibGVzPwo+IAo+IFVzZXJzcGFjZSBoYXMgbm8g
d2F5IHRvIGtub3cgd2UgdXNlIEdJQ3Y0LCBhbmQgSSBpbnRlbmQgdG8ga2VlcCBpdAo+IGNvbXBs
ZXRlbHkgb3V0IG9mIHRoZSBsb29wLiBUaGUgQVBJIGlzIGFscmVhZHkgcHJldHR5IHRvcnR1b3Vz
LCBhbmQKPiBJIHJlYWxseSBkb24ndCB3YW50IHRvIGFkZCBhbnkgZXh0cmEgY29tcGxleGl0eSB0
byBpdC4KPiAKPiBUaGFua3MsCj4gCj4gwqDCoMKgwqDCoMKgwqAgTS4KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

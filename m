Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00988C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 10:48:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 525D265021
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 10:48:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 525D265021
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4D24B33D;
	Fri, 12 Mar 2021 05:48:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gebp-LT+6F83; Fri, 12 Mar 2021 05:48:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44C034B219;
	Fri, 12 Mar 2021 05:48:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07D004B1A4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 05:48:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hh4Zy2DWEBum for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 05:48:42 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 425274B199
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 05:48:41 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DxjCv5Q4pzmWPx;
 Fri, 12 Mar 2021 18:46:19 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 18:48:29 +0800
Subject: Re: [PATCH v3 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state
 to physical side
To: Marc Zyngier <maz@kernel.org>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-4-lushenming@huawei.com> <87tupif3x3.wl-maz@kernel.org>
 <0820f429-4c29-acd6-d9e0-af9f6deb68e4@huawei.com>
 <87k0qcg2s6.wl-maz@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <aecfbf72-c653-e967-b539-89f629b52cde@huawei.com>
Date: Fri, 12 Mar 2021 18:48:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87k0qcg2s6.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMS8zLzEyIDE3OjA1LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gVGh1LCAxMSBNYXIg
MjAyMSAxMjozMjowNyArMDAwMCwKPiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29t
PiB3cm90ZToKPj4KPj4gT24gMjAyMS8zLzExIDE3OjE0LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+
PiBPbiBXZWQsIDI3IEphbiAyMDIxIDEyOjEzOjM2ICswMDAwLAo+Pj4gU2hlbm1pbmcgTHUgPGx1
c2hlbm1pbmdAaHVhd2VpLmNvbT4gd3JvdGU6Cj4+Pj4KPj4+PiBGcm9tOiBaZW5naHVpIFl1IDx5
dXplbmdodWlAaHVhd2VpLmNvbT4KPj4+Pgo+Pj4+IFdoZW4gc2V0dGluZyB0aGUgZm9yd2FyZGlu
ZyBwYXRoIG9mIGEgVkxQSSAoc3dpdGNoIHRvIHRoZSBIVyBtb2RlKSwKPj4+PiB3ZSBjb3VsZCBh
bHNvIHRyYW5zZmVyIHRoZSBwZW5kaW5nIHN0YXRlIGZyb20gaXJxLT5wZW5kaW5nX2xhdGNoIHRv
Cj4+Pj4gVlBUIChlc3BlY2lhbGx5IGluIG1pZ3JhdGlvbiwgdGhlIHBlbmRpbmcgc3RhdGVzIG9m
IFZMUElzIGFyZSByZXN0b3JlZAo+Pj4+IGludG8ga3Zt4oCZcyB2Z2ljIGZpcnN0KS4gQW5kIHdl
IGN1cnJlbnRseSBzZW5kICJJTlQrVlNZTkMiIHRvIHRyaWdnZXIKPj4+PiBhIFZMUEkgdG8gcGVu
ZGluZy4KPj4+Pgo+Pj4+IFNpZ25lZC1vZmYtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3
ZWkuY29tPgo+Pj4+IFNpZ25lZC1vZmYtYnk6IFNoZW5taW5nIEx1IDxsdXNoZW5taW5nQGh1YXdl
aS5jb20+Cj4+Pj4gLS0tCj4+Pj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jIHwgMTQg
KysrKysrKysrKysrKysKPj4+PiAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKykKPj4+
Pgo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYyBiL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4+Pj4gaW5kZXggYWMwMjliYTNkMzM3Li5hMzU0MmFm
NmYwNGEgMTAwNjQ0Cj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKPj4+
PiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwo+Pj4+IEBAIC00NDksNiArNDQ5
LDIwIEBAIGludCBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZyhzdHJ1Y3Qga3ZtICprdm0sIGlu
dCB2aXJxLAo+Pj4+ICAJaXJxLT5ob3N0X2lycQk9IHZpcnE7Cj4+Pj4gIAlhdG9taWNfaW5jKCZt
YXAudnBlLT52bHBpX2NvdW50KTsKPj4+PiAgCj4+Pj4gKwkvKiBUcmFuc2ZlciBwZW5kaW5nIHN0
YXRlICovCj4+Pj4gKwlpZiAoaXJxLT5wZW5kaW5nX2xhdGNoKSB7Cj4+Pj4gKwkJcmV0ID0gaXJx
X3NldF9pcnFjaGlwX3N0YXRlKGlycS0+aG9zdF9pcnEsCj4+Pj4gKwkJCQkJICAgIElSUUNISVBf
U1RBVEVfUEVORElORywKPj4+PiArCQkJCQkgICAgaXJxLT5wZW5kaW5nX2xhdGNoKTsKPj4+PiAr
CQlXQVJOX1JBVEVMSU1JVChyZXQsICJJUlEgJWQiLCBpcnEtPmhvc3RfaXJxKTsKPj4+PiArCj4+
Pj4gKwkJLyoKPj4+PiArCQkgKiBMZXQgaXQgYmUgcHJ1bmVkIGZyb20gYXBfbGlzdCBsYXRlciBh
bmQgZG9uJ3QgYm90aGVyCj4+Pj4gKwkJICogdGhlIExpc3QgUmVnaXN0ZXIuCj4+Pj4gKwkJICov
Cj4+Pj4gKwkJaXJxLT5wZW5kaW5nX2xhdGNoID0gZmFsc2U7Cj4+Pgo+Pj4gTkFLLiBJZiB0aGUg
aW50ZXJydXB0IGlzIG9uIHRoZSBBUCBsaXN0LCBpdCBtdXN0IGJlIHBydW5lZCBmcm9tIGl0Cj4+
PiAqaW1tZWRpYXRlbHkqLiBUaGUgb25seSBjYXNlIHdoZXJlIGl0IGNhbiBiZSAhcGVuZGluZyBh
bmQgc3RpbGwgb24gdGhlCj4+PiBBUCBsaXN0IGlzIGluIGludGVydmFsIGJldHdlZW4gc3luYyBh
bmQgcHJ1bmUuIElmIHdlIHN0YXJ0IG1lc3NpbmcKPj4+IHdpdGggdGhpcywgd2UgY2FuJ3QgcmVh
c29uIGFib3V0IHRoZSBzdGF0ZSBvZiB0aGlzIGxpc3QgYW55bW9yZS4KPj4+Cj4+PiBDb25zaWRl
ciBjYWxsaW5nIHZnaWNfcXVldWVfaXJxX3VubG9jaygpIGhlcmUuCj4+Cj4+IFRoYW5rcyBmb3Ig
Z2l2aW5nIGEgaGludCwgYnV0IGl0IHNlZW1zIHRoYXQgdmdpY19xdWV1ZV9pcnFfdW5sb2NrKCkg
b25seQo+PiBxdWV1ZXMgYW4gSVJRIGFmdGVyIGNoZWNraW5nLCBkaWQgeW91IG1lYW4gdmdpY19w
cnVuZV9hcF9saXN0KCkgaW5zdGVhZD8KPiAKPiBObywgSSByZWFsbHkgbWVhbiB2Z2ljX3F1ZXVl
X2lycV91bmxvY2soKS4gSXQgY2FuIGJlIHVzZWQgdG8gcmVtb3ZlCj4gdGhlIHBlbmRpbmcgc3Rh
dGUgZnJvbSBhbiBpbnRlcnJ1cHQsIGFuZCBkcm9wIGl0IGZyb20gdGhlIEFQCj4gbGlzdC4gVGhp
cyBpcyBleGFjdGx5IHdoYXQgaGFwcGVucyB3aGVuIGNsZWFyaW5nIHRoZSBwZW5kaW5nIHN0YXRl
IG9mCj4gYSBsZXZlbCBpbnRlcnJ1cHQsIGZvciBleGFtcGxlLgoKSGksIEkgaGF2ZSBnb25lIHRo
cm91Z2ggdmdpY19xdWV1ZV9pcnFfdW5sb2NrIG1vcmUgdGhhbiBvbmNlLCBidXQgc3RpbGwgY2Fu
J3QKZmluZCB0aGUgcGxhY2UgaW4gaXQgdG8gZHJvcCBhbiBJUlEgZnJvbSB0aGUgQVAgbGlzdC4u
LiBEaWQgSSBtaXNzIHNvbWV0aGluZyA/Li4uCk9yIGNvdWxkIHlvdSBoZWxwIHRvIHBvaW50IGl0
IG91dD8gVGhhbmtzIHZlcnkgbXVjaCBmb3IgdGhpcyEKClNoZW5taW5nCgo+IAo+IAlNLgo+IApf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

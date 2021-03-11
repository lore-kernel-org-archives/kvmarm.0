Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8F1C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 12:32:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DFB0164FE0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 12:32:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFB0164FE0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 500044B691;
	Thu, 11 Mar 2021 07:32:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tpBJP6jyjELO; Thu, 11 Mar 2021 07:32:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52C104B682;
	Thu, 11 Mar 2021 07:32:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 587274B615
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 07:32:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eEMpdIrkwxXQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 07:32:20 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 374DB4B579
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 07:32:20 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dx7ZX3jllz16Hkl;
 Thu, 11 Mar 2021 20:30:28 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 20:32:07 +0800
Subject: Re: [PATCH v3 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state
 to physical side
To: Marc Zyngier <maz@kernel.org>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-4-lushenming@huawei.com> <87tupif3x3.wl-maz@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <0820f429-4c29-acd6-d9e0-af9f6deb68e4@huawei.com>
Date: Thu, 11 Mar 2021 20:32:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87tupif3x3.wl-maz@kernel.org>
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

T24gMjAyMS8zLzExIDE3OjE0LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gV2VkLCAyNyBKYW4g
MjAyMSAxMjoxMzozNiArMDAwMCwKPiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29t
PiB3cm90ZToKPj4KPj4gRnJvbTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+
Cj4+IFdoZW4gc2V0dGluZyB0aGUgZm9yd2FyZGluZyBwYXRoIG9mIGEgVkxQSSAoc3dpdGNoIHRv
IHRoZSBIVyBtb2RlKSwKPj4gd2UgY291bGQgYWxzbyB0cmFuc2ZlciB0aGUgcGVuZGluZyBzdGF0
ZSBmcm9tIGlycS0+cGVuZGluZ19sYXRjaCB0bwo+PiBWUFQgKGVzcGVjaWFsbHkgaW4gbWlncmF0
aW9uLCB0aGUgcGVuZGluZyBzdGF0ZXMgb2YgVkxQSXMgYXJlIHJlc3RvcmVkCj4+IGludG8ga3Zt
4oCZcyB2Z2ljIGZpcnN0KS4gQW5kIHdlIGN1cnJlbnRseSBzZW5kICJJTlQrVlNZTkMiIHRvIHRy
aWdnZXIKPj4gYSBWTFBJIHRvIHBlbmRpbmcuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFplbmdodWkg
WXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+PiBTaWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8
bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+PiAtLS0KPj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy12NC5jIHwgMTQgKysrKysrKysrKysrKysKPj4gIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRp
b25zKCspCj4+Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYyBi
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4+IGluZGV4IGFjMDI5YmEzZDMzNy4uYTM1
NDJhZjZmMDRhIDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwo+
PiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwo+PiBAQCAtNDQ5LDYgKzQ0OSwy
MCBAQCBpbnQga3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoc3RydWN0IGt2bSAqa3ZtLCBpbnQg
dmlycSwKPj4gIAlpcnEtPmhvc3RfaXJxCT0gdmlycTsKPj4gIAlhdG9taWNfaW5jKCZtYXAudnBl
LT52bHBpX2NvdW50KTsKPj4gIAo+PiArCS8qIFRyYW5zZmVyIHBlbmRpbmcgc3RhdGUgKi8KPj4g
KwlpZiAoaXJxLT5wZW5kaW5nX2xhdGNoKSB7Cj4+ICsJCXJldCA9IGlycV9zZXRfaXJxY2hpcF9z
dGF0ZShpcnEtPmhvc3RfaXJxLAo+PiArCQkJCQkgICAgSVJRQ0hJUF9TVEFURV9QRU5ESU5HLAo+
PiArCQkJCQkgICAgaXJxLT5wZW5kaW5nX2xhdGNoKTsKPj4gKwkJV0FSTl9SQVRFTElNSVQocmV0
LCAiSVJRICVkIiwgaXJxLT5ob3N0X2lycSk7Cj4+ICsKPj4gKwkJLyoKPj4gKwkJICogTGV0IGl0
IGJlIHBydW5lZCBmcm9tIGFwX2xpc3QgbGF0ZXIgYW5kIGRvbid0IGJvdGhlcgo+PiArCQkgKiB0
aGUgTGlzdCBSZWdpc3Rlci4KPj4gKwkJICovCj4+ICsJCWlycS0+cGVuZGluZ19sYXRjaCA9IGZh
bHNlOwo+IAo+IE5BSy4gSWYgdGhlIGludGVycnVwdCBpcyBvbiB0aGUgQVAgbGlzdCwgaXQgbXVz
dCBiZSBwcnVuZWQgZnJvbSBpdAo+ICppbW1lZGlhdGVseSouIFRoZSBvbmx5IGNhc2Ugd2hlcmUg
aXQgY2FuIGJlICFwZW5kaW5nIGFuZCBzdGlsbCBvbiB0aGUKPiBBUCBsaXN0IGlzIGluIGludGVy
dmFsIGJldHdlZW4gc3luYyBhbmQgcHJ1bmUuIElmIHdlIHN0YXJ0IG1lc3NpbmcKPiB3aXRoIHRo
aXMsIHdlIGNhbid0IHJlYXNvbiBhYm91dCB0aGUgc3RhdGUgb2YgdGhpcyBsaXN0IGFueW1vcmUu
Cj4gCj4gQ29uc2lkZXIgY2FsbGluZyB2Z2ljX3F1ZXVlX2lycV91bmxvY2soKSBoZXJlLgoKVGhh
bmtzIGZvciBnaXZpbmcgYSBoaW50LCBidXQgaXQgc2VlbXMgdGhhdCB2Z2ljX3F1ZXVlX2lycV91
bmxvY2soKSBvbmx5CnF1ZXVlcyBhbiBJUlEgYWZ0ZXIgY2hlY2tpbmcsIGRpZCB5b3UgbWVhbiB2
Z2ljX3BydW5lX2FwX2xpc3QoKSBpbnN0ZWFkPwoKVGhhbmtzIGEgbG90IGZvciB0aGUgY29tbWVu
dHMhIDotKQpTaGVubWluZwoKPiAKPiBUaGFua3MsCj4gCj4gCU0uCj4gCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

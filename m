Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF189C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 11:40:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38784229C7
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 11:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38784229C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7772B4B259;
	Tue,  5 Jan 2021 06:40:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Eur+C7TE-VPN; Tue,  5 Jan 2021 06:40:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D263D4B262;
	Tue,  5 Jan 2021 06:40:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1A814B15A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 06:40:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rg7G7+TwRWK2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 06:40:17 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 857774B156
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 06:40:17 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 017BB22286;
 Tue,  5 Jan 2021 11:40:16 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kwkhB-005Q61-Lt; Tue, 05 Jan 2021 11:40:14 +0000
MIME-Version: 1.0
Date: Tue, 05 Jan 2021 11:40:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v2 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
In-Reply-To: <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-3-lushenming@huawei.com>
 <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <6f09084b32e239176b3f9b4b00874a51@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, eric.auger@redhat.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
 lorenzo.pieralisi@arm.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMS0wMS0wNSAwOToxMywgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjEtMDEtMDQg
MDg6MTYsIFNoZW5taW5nIEx1IHdyb3RlOgo+PiBBZnRlciBwYXVzaW5nIGFsbCB2Q1BVcyBhbmQg
ZGV2aWNlcyBjYXBhYmxlIG9mIGludGVycnVwdGluZywgaW4gb3JkZXIKPj4gdG8gc2F2ZSB0aGUg
aW5mb3JtYXRpb24gb2YgYWxsIGludGVycnVwdHMsIGJlc2lkZXMgZmx1c2hpbmcgdGhlIAo+PiBw
ZW5kaW5nCj4+IHN0YXRlcyBpbiBrdm3igJlzIHZnaWMsIHdlIGFsc28gdHJ5IHRvIGZsdXNoIHRo
ZSBzdGF0ZXMgb2YgVkxQSXMgaW4gdGhlCj4+IHZpcnR1YWwgcGVuZGluZyB0YWJsZXMgaW50byBn
dWVzdCBSQU0sIGJ1dCB3ZSBuZWVkIHRvIGhhdmUgR0lDdjQuMSBhbmQKPj4gc2FmZWx5IHVubWFw
IHRoZSB2UEVzIGZpcnN0Lgo+PiAKPj4gU2lnbmVkLW9mZi1ieTogU2hlbm1pbmcgTHUgPGx1c2hl
bm1pbmdAaHVhd2VpLmNvbT4KPj4gLS0tCj4+ICBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMu
YyB8IDU4IAo+PiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLQo+PiAgMSBmaWxl
IGNoYW5nZWQsIDUyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4+IAo+PiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMgCj4+IGIvYXJjaC9hcm02NC9rdm0v
dmdpYy92Z2ljLXYzLmMKPj4gaW5kZXggOWNkZjM5YTk0YTYzLi5hNThjOTQxMjdjYjAgMTAwNjQ0
Cj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCj4+ICsrKyBiL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12My5jCj4+IEBAIC0xLDYgKzEsOCBAQAo+PiAgLy8gU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQo+PiAKPj4gICNpbmNsdWRlIDxsaW51eC9pcnFj
aGlwL2FybS1naWMtdjMuaD4KPj4gKyNpbmNsdWRlIDxsaW51eC9pcnEuaD4KPj4gKyNpbmNsdWRl
IDxsaW51eC9pcnFkb21haW4uaD4KPj4gICNpbmNsdWRlIDxsaW51eC9rdm0uaD4KPj4gICNpbmNs
dWRlIDxsaW51eC9rdm1faG9zdC5oPgo+PiAgI2luY2x1ZGUgPGt2bS9hcm1fdmdpYy5oPgo+PiBA
QCAtMzU2LDYgKzM1OCwzOCBAQCBpbnQgdmdpY192M19scGlfc3luY19wZW5kaW5nX3N0YXR1cyhz
dHJ1Y3Qga3ZtCj4+ICprdm0sIHN0cnVjdCB2Z2ljX2lycSAqaXJxKQo+PiAgCXJldHVybiAwOwo+
PiAgfQo+PiAKPj4gKy8qCj4+ICsgKiBUaGUgZGVhY3RpdmF0aW9uIG9mIHRoZSBkb29yYmVsbCBp
bnRlcnJ1cHQgd2lsbCB0cmlnZ2VyIHRoZQo+PiArICogdW5tYXBwaW5nIG9mIHRoZSBhc3NvY2lh
dGVkIHZQRS4KPj4gKyAqLwo+PiArc3RhdGljIHZvaWQgdW5tYXBfYWxsX3ZwZXMoc3RydWN0IHZn
aWNfZGlzdCAqZGlzdCkKPj4gK3sKPj4gKwlzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2M7Cj4+ICsJaW50
IGk7Cj4+ICsKPj4gKwlpZiAoIWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5oYXNfZ2ljdjRfMSkKPj4g
KwkJcmV0dXJuOwo+PiArCj4+ICsJZm9yIChpID0gMDsgaSA8IGRpc3QtPml0c192bS5ucl92cGVz
OyBpKyspIHsKPj4gKwkJZGVzYyA9IGlycV90b19kZXNjKGRpc3QtPml0c192bS52cGVzW2ldLT5p
cnEpOwo+PiArCQlpcnFfZG9tYWluX2RlYWN0aXZhdGVfaXJxKGlycV9kZXNjX2dldF9pcnFfZGF0
YShkZXNjKSk7Cj4+ICsJfQo+PiArfQo+PiArCj4+ICtzdGF0aWMgdm9pZCBtYXBfYWxsX3ZwZXMo
c3RydWN0IHZnaWNfZGlzdCAqZGlzdCkKPj4gK3sKPj4gKwlzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2M7
Cj4+ICsJaW50IGk7Cj4+ICsKPj4gKwlpZiAoIWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5oYXNfZ2lj
djRfMSkKPj4gKwkJcmV0dXJuOwo+PiArCj4+ICsJZm9yIChpID0gMDsgaSA8IGRpc3QtPml0c192
bS5ucl92cGVzOyBpKyspIHsKPj4gKwkJZGVzYyA9IGlycV90b19kZXNjKGRpc3QtPml0c192bS52
cGVzW2ldLT5pcnEpOwo+PiArCQlpcnFfZG9tYWluX2FjdGl2YXRlX2lycShpcnFfZGVzY19nZXRf
aXJxX2RhdGEoZGVzYyksIGZhbHNlKTsKPj4gKwl9Cj4+ICt9Cj4+ICsKPj4gIC8qKgo+PiAgICog
dmdpY192M19zYXZlX3BlbmRpbmdfdGFibGVzIC0gU2F2ZSB0aGUgcGVuZGluZyB0YWJsZXMgaW50
byBndWVzdCAKPj4gUkFNCj4+ICAgKiBrdm0gbG9jayBhbmQgYWxsIHZjcHUgbG9jayBtdXN0IGJl
IGhlbGQKPj4gQEAgLTM2NSwxNCArMzk5LDE4IEBAIGludCB2Z2ljX3YzX3NhdmVfcGVuZGluZ190
YWJsZXMoc3RydWN0IGt2bSAqa3ZtKQo+PiAgCXN0cnVjdCB2Z2ljX2Rpc3QgKmRpc3QgPSAma3Zt
LT5hcmNoLnZnaWM7Cj4+ICAJc3RydWN0IHZnaWNfaXJxICppcnE7Cj4+ICAJZ3BhX3QgbGFzdF9w
dHIgPSB+KGdwYV90KTA7Cj4+IC0JaW50IHJldDsKPj4gKwlpbnQgcmV0ID0gMDsKPj4gIAl1OCB2
YWw7Cj4+IAo+PiArCS8qIEFzIGEgcHJlcGFyYXRpb24gZm9yIGdldHRpbmcgYW55IFZMUEkgc3Rh
dGVzLiAqLwo+PiArCXVubWFwX2FsbF92cGVzKGRpc3QpOwo+IAo+IFdoYXQgaWYgdGhlIFZQRXMg
YXJlIG5vdCBtYXBwZWQgeWV0PyBJcyBpdCBwb3NzaWJsZSB0byBzbmFwc2hvdCBhIFZNCj4gdGhh
dCBoYXMgbm90IHJ1biBhdCBhbGw/CgpNb3JlIHF1ZXN0aW9uczogd2hhdCBoYXBwZW5zIHRvIHZT
R0lzIHRoYXQgd2VyZSBtYXBwZWQgdG8gdGhlIFZQRXM/CkNhbiB0aGV5IHNhZmVseSBiZSByZXN0
YXJ0ZWQ/IFRoZSBzcGVjIGlzIG5vdCBzYXlpbmcgbXVjaCBvbiB0aGUgCnN1YmplY3QuCgpPbmNl
IHRoZSB1bm1hcCBoYXMgdGFrZW4gcGxhY2UsIGl0IHdvbid0IGJlIHBvc3NpYmxlIHRvIHJlYWQg
dGhlaXIgc3RhdGUKdmlhIEdJQ1JfVlNHSVJQRU5ELCBhbmQgb25seSB0aGUgbWVtb3J5IHN0YXRl
IGNhbiBiZSB1c2VkLiBUaGlzIHByb2JhYmx5Cm5lZWRzIHRvIGJlIHRyYWNrZWQgYXMgd2VsbC4K
ClRoYW5rcywKCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxs
cyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

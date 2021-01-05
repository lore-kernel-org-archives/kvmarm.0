Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374F5C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 13:48:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7D3222AAB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 13:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7D3222AAB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E05C4B279;
	Tue,  5 Jan 2021 08:48:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6cnm8MnsxGnA; Tue,  5 Jan 2021 08:48:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32AB84B328;
	Tue,  5 Jan 2021 08:48:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 801674B263
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 08:48:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KMhxXzV4-9ey for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 08:48:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27E234B262
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 08:48:00 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0DBB32226A;
 Tue,  5 Jan 2021 13:47:59 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kwmgk-005ROK-Rr; Tue, 05 Jan 2021 13:47:57 +0000
MIME-Version: 1.0
Date: Tue, 05 Jan 2021 13:47:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v2 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
In-Reply-To: <0fa19ab1-60ba-9067-e1aa-ee78191c52ed@huawei.com>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-3-lushenming@huawei.com>
 <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
 <0fa19ab1-60ba-9067-e1aa-ee78191c52ed@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <13d4e6de8653528aa71b07a2cfaa3552@kernel.org>
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

T24gMjAyMS0wMS0wNSAxMzowMiwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gT24gMjAyMS8xLzUgMTc6
MTMsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMS0wMS0wNCAwODoxNiwgU2hlbm1pbmcg
THUgd3JvdGU6Cj4+PiBBZnRlciBwYXVzaW5nIGFsbCB2Q1BVcyBhbmQgZGV2aWNlcyBjYXBhYmxl
IG9mIGludGVycnVwdGluZywgaW4gb3JkZXIKPj4+IHRvIHNhdmUgdGhlIGluZm9ybWF0aW9uIG9m
IGFsbCBpbnRlcnJ1cHRzLCBiZXNpZGVzIGZsdXNoaW5nIHRoZSAKPj4+IHBlbmRpbmcKPj4+IHN0
YXRlcyBpbiBrdm3igJlzIHZnaWMsIHdlIGFsc28gdHJ5IHRvIGZsdXNoIHRoZSBzdGF0ZXMgb2Yg
VkxQSXMgaW4gdGhlCj4+PiB2aXJ0dWFsIHBlbmRpbmcgdGFibGVzIGludG8gZ3Vlc3QgUkFNLCBi
dXQgd2UgbmVlZCB0byBoYXZlIEdJQ3Y0LjEgCj4+PiBhbmQKPj4+IHNhZmVseSB1bm1hcCB0aGUg
dlBFcyBmaXJzdC4KPj4+IAo+Pj4gU2lnbmVkLW9mZi1ieTogU2hlbm1pbmcgTHUgPGx1c2hlbm1p
bmdAaHVhd2VpLmNvbT4KPj4+IC0tLQo+Pj4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMu
YyB8IDU4IAo+Pj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KPj4+IMKgMSBm
aWxlIGNoYW5nZWQsIDUyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4+PiAKPj4+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYyAKPj4+IGIvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLXYzLmMKPj4+IGluZGV4IDljZGYzOWE5NGE2My4uYTU4Yzk0MTI3Y2Iw
IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMKPj4+ICsrKyBi
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCj4+PiBAQCAtMSw2ICsxLDggQEAKPj4+IMKg
Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQo+Pj4gCj4+PiDCoCNpbmNs
dWRlIDxsaW51eC9pcnFjaGlwL2FybS1naWMtdjMuaD4KPj4+ICsjaW5jbHVkZSA8bGludXgvaXJx
Lmg+Cj4+PiArI2luY2x1ZGUgPGxpbnV4L2lycWRvbWFpbi5oPgo+Pj4gwqAjaW5jbHVkZSA8bGlu
dXgva3ZtLmg+Cj4+PiDCoCNpbmNsdWRlIDxsaW51eC9rdm1faG9zdC5oPgo+Pj4gwqAjaW5jbHVk
ZSA8a3ZtL2FybV92Z2ljLmg+Cj4+PiBAQCAtMzU2LDYgKzM1OCwzOCBAQCBpbnQgdmdpY192M19s
cGlfc3luY19wZW5kaW5nX3N0YXR1cyhzdHJ1Y3Qga3ZtCj4+PiAqa3ZtLCBzdHJ1Y3QgdmdpY19p
cnEgKmlycSkKPj4+IMKgwqDCoMKgIHJldHVybiAwOwo+Pj4gwqB9Cj4+PiAKPj4+ICsvKgo+Pj4g
KyAqIFRoZSBkZWFjdGl2YXRpb24gb2YgdGhlIGRvb3JiZWxsIGludGVycnVwdCB3aWxsIHRyaWdn
ZXIgdGhlCj4+PiArICogdW5tYXBwaW5nIG9mIHRoZSBhc3NvY2lhdGVkIHZQRS4KPj4+ICsgKi8K
Pj4+ICtzdGF0aWMgdm9pZCB1bm1hcF9hbGxfdnBlcyhzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0KQo+
Pj4gK3sKPj4+ICvCoMKgwqAgc3RydWN0IGlycV9kZXNjICpkZXNjOwo+Pj4gK8KgwqDCoCBpbnQg
aTsKPj4+ICsKPj4+ICvCoMKgwqAgaWYgKCFrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0
XzEpCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+Pj4gKwo+Pj4gK8KgwqDCoCBmb3IgKGkg
PSAwOyBpIDwgZGlzdC0+aXRzX3ZtLm5yX3ZwZXM7IGkrKykgewo+Pj4gK8KgwqDCoMKgwqDCoMKg
IGRlc2MgPSBpcnFfdG9fZGVzYyhkaXN0LT5pdHNfdm0udnBlc1tpXS0+aXJxKTsKPj4+ICvCoMKg
wqDCoMKgwqDCoCBpcnFfZG9tYWluX2RlYWN0aXZhdGVfaXJxKGlycV9kZXNjX2dldF9pcnFfZGF0
YShkZXNjKSk7Cj4+PiArwqDCoMKgIH0KPj4+ICt9Cj4+PiArCj4+PiArc3RhdGljIHZvaWQgbWFw
X2FsbF92cGVzKHN0cnVjdCB2Z2ljX2Rpc3QgKmRpc3QpCj4+PiArewo+Pj4gK8KgwqDCoCBzdHJ1
Y3QgaXJxX2Rlc2MgKmRlc2M7Cj4+PiArwqDCoMKgIGludCBpOwo+Pj4gKwo+Pj4gK8KgwqDCoCBp
ZiAoIWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5oYXNfZ2ljdjRfMSkKPj4+ICvCoMKgwqDCoMKgwqDC
oCByZXR1cm47Cj4+PiArCj4+PiArwqDCoMKgIGZvciAoaSA9IDA7IGkgPCBkaXN0LT5pdHNfdm0u
bnJfdnBlczsgaSsrKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqAgZGVzYyA9IGlycV90b19kZXNjKGRp
c3QtPml0c192bS52cGVzW2ldLT5pcnEpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGlycV9kb21haW5f
YWN0aXZhdGVfaXJxKGlycV9kZXNjX2dldF9pcnFfZGF0YShkZXNjKSwgZmFsc2UpOwo+Pj4gK8Kg
wqDCoCB9Cj4+PiArfQo+Pj4gKwo+Pj4gwqAvKioKPj4+IMKgICogdmdpY192M19zYXZlX3BlbmRp
bmdfdGFibGVzIC0gU2F2ZSB0aGUgcGVuZGluZyB0YWJsZXMgaW50byBndWVzdCAKPj4+IFJBTQo+
Pj4gwqAgKiBrdm0gbG9jayBhbmQgYWxsIHZjcHUgbG9jayBtdXN0IGJlIGhlbGQKPj4+IEBAIC0z
NjUsMTQgKzM5OSwxOCBAQCBpbnQgdmdpY192M19zYXZlX3BlbmRpbmdfdGFibGVzKHN0cnVjdCBr
dm0gCj4+PiAqa3ZtKQo+Pj4gwqDCoMKgwqAgc3RydWN0IHZnaWNfZGlzdCAqZGlzdCA9ICZrdm0t
PmFyY2gudmdpYzsKPj4+IMKgwqDCoMKgIHN0cnVjdCB2Z2ljX2lycSAqaXJxOwo+Pj4gwqDCoMKg
wqAgZ3BhX3QgbGFzdF9wdHIgPSB+KGdwYV90KTA7Cj4+PiAtwqDCoMKgIGludCByZXQ7Cj4+PiAr
wqDCoMKgIGludCByZXQgPSAwOwo+Pj4gwqDCoMKgwqAgdTggdmFsOwo+Pj4gCj4+PiArwqDCoMKg
IC8qIEFzIGEgcHJlcGFyYXRpb24gZm9yIGdldHRpbmcgYW55IFZMUEkgc3RhdGVzLiAqLwo+Pj4g
K8KgwqDCoCB1bm1hcF9hbGxfdnBlcyhkaXN0KTsKPj4gCj4+IFdoYXQgaWYgdGhlIFZQRXMgYXJl
IG5vdCBtYXBwZWQgeWV0PyBJcyBpdCBwb3NzaWJsZSB0byBzbmFwc2hvdCBhIFZNCj4+IHRoYXQg
aGFzIG5vdCBydW4gYXQgYWxsPwo+IAo+IFdoYXQgSSBzZWUgaW4gUUVNVSBpcyB0aGF0IHRoZSBz
YXZpbmcgb2YgdGhlIHBlbmRpbmcgdGFibGVzIHdvdWxkIG9ubHkgCj4gYmUKPiBjYWxsZWQgd2hl
biBzdG9wcGluZyB0aGUgVk0gYW5kIGl0IG5lZWRzIHRoZSBjdXJyZW50IFZNIHN0YXRlIHRvIGJl
IAo+IFJVTk5JTkcuCgpTdXJlLCBidXQgdGhhdCdzIHdoYXQgUUVNVSBkb2VzLCBhbmQgYSBkaWZm
ZXJlbnQgdXNlcnNwYWNlIGNvdWxkIHdlbGwgZG8Kc29tZXRoaW5nIGRpZmZlcmVudC4gSXQgbG9v
a3MgdG8gbWUgdGhhdCBJIHNob3VsZCBiZSBhYmxlIHRvIHN0YXJ0IChvcgpldmVuIHJlc3RvcmUp
IGEgZ3Vlc3QsIGFuZCBzbmFwc2hvdCBpdCBpbW1lZGlhdGVseS4gSGVyZSwgSSdtIHByZXR0eQpz
dXJlIHRoaXMgd291bGRuJ3QgZG8gdGhlIHJpZ2h0IHRoaW5nIChJIGhhdmUgdGhlIHN1c3BpY2lv
biB0aGF0IHRoZQpkb29yYmVsbHMgYXJlIG5vdCBhbGxvY2F0ZWQsIGFuZCB0aGF0IHdlJ2xsIGVu
ZC11cCB3aXRoIGFuIE9vcHMgYXQgdW5tYXAKdGltZSwgdGhvdWdoIEkgaGF2ZW4ndCBpbnZlc3Rp
Z2F0ZWQgaXQgdG8gYmUgc3VyZSkuCgo+PiAKPj4+ICsKPj4+IMKgwqDCoMKgIGxpc3RfZm9yX2Vh
Y2hfZW50cnkoaXJxLCAmZGlzdC0+bHBpX2xpc3RfaGVhZCwgbHBpX2xpc3QpIHsKPj4+IMKgwqDC
oMKgwqDCoMKgwqAgaW50IGJ5dGVfb2Zmc2V0LCBiaXRfbnI7Cj4+PiDCoMKgwqDCoMKgwqDCoMKg
IHN0cnVjdCBrdm1fdmNwdSAqdmNwdTsKPj4+IMKgwqDCoMKgwqDCoMKgwqAgZ3BhX3QgcGVuZGJh
c2UsIHB0cjsKPj4+IMKgwqDCoMKgwqDCoMKgwqAgYm9vbCBzdG9yZWQ7Cj4+PiArwqDCoMKgwqDC
oMKgwqAgYm9vbCBpc19wZW5kaW5nID0gaXJxLT5wZW5kaW5nX2xhdGNoOwo+Pj4gCj4+PiDCoMKg
wqDCoMKgwqDCoMKgIHZjcHUgPSBpcnEtPnRhcmdldF92Y3B1Owo+Pj4gwqDCoMKgwqDCoMKgwqDC
oCBpZiAoIXZjcHUpCj4+PiBAQCAtMzg3LDI0ICs0MjUsMzIgQEAgaW50IHZnaWNfdjNfc2F2ZV9w
ZW5kaW5nX3RhYmxlcyhzdHJ1Y3Qga3ZtIAo+Pj4gKmt2bSkKPj4+IMKgwqDCoMKgwqDCoMKgwqAg
aWYgKHB0ciAhPSBsYXN0X3B0cikgewo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9
IGt2bV9yZWFkX2d1ZXN0X2xvY2soa3ZtLCBwdHIsICZ2YWwsIDEpOwo+Pj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGlmIChyZXQpCj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHJldHVybiByZXQ7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gb3V0
Owo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxhc3RfcHRyID0gcHRyOwo+Pj4gwqDCoMKg
wqDCoMKgwqDCoCB9Cj4+PiAKPj4+IMKgwqDCoMKgwqDCoMKgwqAgc3RvcmVkID0gdmFsICYgKDFV
IDw8IGJpdF9ucik7Cj4+PiAtwqDCoMKgwqDCoMKgwqAgaWYgKHN0b3JlZCA9PSBpcnEtPnBlbmRp
bmdfbGF0Y2gpCj4+PiArCj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGlycS0+aHcpCj4+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB2Z2ljX3Y0X2dldF92bHBpX3N0YXRlKGlycSwgJmlzX3BlbmRp
bmcpOwo+PiAKPj4gWW91IGRvbid0IGNoZWNrIHRoZSByZXR1cm4gdmFsdWUgaGVyZSwgc28gSSB3
b25kZXIgd2h5IHRoZSBjaGVja3MKPj4gaW4gdmdpY192NF9nZXRfdmxwaV9zdGF0ZSgpLgo+IAo+
IFNpbmNlIEkgaGF2ZSBhbHJlYWR5IGNoZWNrZWQgdGhlIGNvbmRpdGlvbiBhbmQgcmVwb3J0ZWQg
aW4gCj4gc2F2ZV9pdHNfdGFibGVzCj4gKHBhdGNoIDQpLCBJIGp1c3QgY2hlY2sgaW4gZ2V0X3Zs
cGlfc3RhdGUgYW5kIGRvbid0IHJlcG9ydCBhZ2FpbiBoZXJlLgoKU3VyZSwgYnV0IHdoeSB0aGUg
Y2hlY2tzIGFuZCB0aGUgcmV0dXJuIHZhbHVlIHRoZW4/IEknZCByYXRoZXIgeW91IGNoZWNrIAph
bGwKdGhlIHJlbGV2YW50IGNvbmRpdGlvbnMgaW4gb25lIHBsYWNlLgoKPiAKPj4gCj4+IEFub3Ro
ZXIgdGhpbmcgdGhhdCB3b3JyaWVzIG1lIGlzIHRoYXQgdmdpY192NF9nZXRfdmxwaV9zdGF0ZSgp
IGRvZXNuJ3QKPj4gaGF2ZSBhbnkgY2FjaGUgaW52YWxpZGF0aW9uLCBhbmQgY2FuIGVuZC11cCBo
aXR0aW5nIGluIHRoZSBDUFUgY2FjaGUKPj4gKHRoZXJlIGlzIG5vIGd1YXJhbnRlZSBvZiBjb2hl
cmVuY3kgYmV0d2VlbiB0aGUgR0lDIGFuZCB0aGUgQ1BVLCBvbmx5Cj4+IHRoYXQgdGhlIEdJQyB3
aWxsIGhhdmUgZmx1c2hlZCBpdHMgY2FjaGVzKS4KPj4gCj4+IEknZCBleHBlY3QgdGhpcyB0byBo
YXBwZW4gYXQgdW5tYXAgdGltZSwgdGhvdWdoLCBpbiBvcmRlciB0byBhdm9pZAo+PiByZXBlYXRl
ZCBzaW5nbGUgYnl0ZSBpbnZhbGlkYXRpb25zLgo+IAo+IE9rLCBJIHdpbGwgYWRkIGEgY2FjaGUg
aW52YWxpZGF0aW9uIGF0IHVubWFwIHRpbWUuCgpJIGd1ZXNzIGEgc2Vuc2libGUgcGxhY2UgdG8g
ZG8gdGhhdCB3b3VsZCBiZSBhdCBkZWFjdGl2YXRpb24gdGltZS4KSSBjYW1lIHVwIHdpdGggdGhl
IGZvbGxvd2luZyBoYWNrLCBjb21wbGV0ZWx5IHVudGVzdGVkLgoKSWYgdGhhdCB3b3JrcyBmb3Ig
eW91LCBJJ2xsIHR1cm4gaXQgaW50byBhIHByb3BlciBwYXRjaCB0aGF0IHlvdQpjYW4gY2Fycnkg
d2l0aCB0aGUgc2VyaWVzIChJIG1heSB0dXJuIGl0IGludG8gYSBfX2ludmFsX2RjYWNoZV9hcmVh
CmNhbGwgaWYgSSBjYW4gZmluZCB0aGUgZXF1aXZhbGVudCAzMmJpdCkuCgpUaGFua3MsCgogICAg
ICAgICBNLgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jIApi
L2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jCmluZGV4IDdkYjYwMjQzNGFjNS4uMmRi
ZWYxMjdjYTE1IDEwMDY0NAotLS0gYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYwor
KysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYwpAQCAtNDU1Miw2ICs0NTUyLDEw
IEBAIHN0YXRpYyB2b2lkIGl0c192cGVfaXJxX2RvbWFpbl9kZWFjdGl2YXRlKHN0cnVjdCAKaXJx
X2RvbWFpbiAqZG9tYWluLAoKICAJCWl0c19zZW5kX3ZtYXBwKGl0cywgdnBlLCBmYWxzZSk7CiAg
CX0KKworCWlmIChmaW5kXzRfMV9pdHMoKSAmJiAhYXRvbWljX3JlYWQodnBlLT52bWFwcF9jb3Vu
dCkpCisJCWdpY19mbHVzaF9kY2FjaGVfdG9fcG9jKHBhZ2VfYWRkcmVzcyh2cGUtPnZwdF9wYWdl
KSwKKwkJCQkJTFBJX1BFTkRCQVNFX1NaKTsKICB9CgogIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaXJx
X2RvbWFpbl9vcHMgaXRzX3ZwZV9kb21haW5fb3BzID0gewoKCi0tIApKYXp6IGlzIG5vdCBkZWFk
LiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K

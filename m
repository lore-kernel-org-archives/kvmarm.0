Return-Path: <SRS0=2z/n=4T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19630C3F2CE
	for <kvmarm@archiver.kernel.org>; Mon,  2 Mar 2020 02:40:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3296246BF
	for <kvmarm@archiver.kernel.org>; Mon,  2 Mar 2020 02:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3296246BF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD6A4ACF2;
	Sun,  1 Mar 2020 21:40:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9a7QIDuIYxXH; Sun,  1 Mar 2020 21:40:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED88C4AF37;
	Sun,  1 Mar 2020 21:40:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26CA64AF48
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Mar 2020 21:40:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q53PzChmxIKV for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 Mar 2020 21:40:42 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A62CE4ACF2
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Mar 2020 21:40:42 -0500 (EST)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 66F8A3F26BA126D15212;
 Mon,  2 Mar 2020 10:40:39 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 2 Mar 2020
 10:40:32 +0800
Subject: Re: [PATCH v4 16/20] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
To: Marc Zyngier <maz@kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-17-maz@kernel.org>
 <6798eb13-a7e9-2a92-91b2-9b657962ea79@huawei.com>
 <7aa668a5920b8deb8c2ee2fec3ef69b3@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <865e3cc6-19e3-a1ec-84a6-8c15ad738345@huawei.com>
Date: Mon, 2 Mar 2020 10:40:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <7aa668a5920b8deb8c2ee2fec3ef69b3@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert
 Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
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

SGkgTWFyYywKCk9uIDIwMjAvMi8yOSAzOjE2LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkgWmVu
Z2h1aSwKPiAKPiBPbiAyMDIwLTAyLTIwIDAzOjU1LCBaZW5naHVpIFl1IHdyb3RlOgo+PiBIaSBN
YXJjLAo+Pgo+PiBPbiAyMDIwLzIvMTQgMjI6NTcsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IElu
IG9yZGVyIHRvIGxldCBhIGd1ZXN0IGJ1eSBpbiB0aGUgbmV3LCBhY3RpdmUtbGVzcyBTR0lzLCB3
ZQo+Pj4gbmVlZCB0byBiZSBhYmxlIHRvIHN3aXRjaCBiZXR3ZWVuIHRoZSB0d28gbW9kZXMuCj4+
Pgo+Pj4gSGFuZGxlIHRoaXMgYnkgc3RvcHBpbmcgYWxsIGd1ZXN0IGFjdGl2aXR5LCB0cmFuc2Zl
ciB0aGUgc3RhdGUKPj4+IGZyb20gb25lIG1vZGUgdG8gdGhlIG90aGVyLCBhbmQgcmVzdW1lIHRo
ZSBndWVzdC4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPgo+Pgo+PiBbLi4uXQo+Pgo+Pj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS92Z2ljL3Zn
aWMtdjMuYyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtdjMuYwo+Pj4gaW5kZXggMWJjMDliNTIz
NDg2Li4yYzlmYzEzZTJjNTkgMTAwNjQ0Cj4+PiAtLS0gYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2lj
LXYzLmMKPj4+ICsrKyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtdjMuYwo+Pj4gQEAgLTU0MCw2
ICs1NDAsOCBAQCBpbnQgdmdpY192M19tYXBfcmVzb3VyY2VzKHN0cnVjdCBrdm0gKmt2bSkKPj4+
IMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4+IMKgwqDCoMKgwqAgfQo+Pj4gwqAgK8Kg
wqDCoCBpZiAoa3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLmhhc19naWN2NF8xKQo+Pj4gK8KgwqDCoMKg
wqDCoMKgIHZnaWNfdjRfY29uZmlndXJlX3ZzZ2lzKGt2bSk7Cj4+PiDCoMKgwqDCoMKgIGRpc3Qt
PnJlYWR5ID0gdHJ1ZTsKPj4+IMKgwqDCoCBvdXQ6Cj4+Cj4+IElzIHRoZXJlIGFueSByZWFzb24g
dG8gaW52b2tlIHZnaWNfdjRfY29uZmlndXJlX3ZzZ2lzKCkgaGVyZT8KPj4gVGhpcyBpcyBjYWxs
ZWQgb24gdGhlIGZpcnN0IFZDUFUgcnVuLCB0aHJvdWdoIGt2bV92Z2ljX21hcF9yZXNvdXJjZXMo
KS4KPj4gU2hvdWxkbid0IHRoZSB2U0dJIGNvbmZpZ3VyYXRpb24gb25seSBkcml2ZW4gYnkgYSBH
SUNEX0NUTFIubkFTU0dJcmVxCj4+IHdyaXRpbmcgKGZyb20gZ3Vlc3QsIG9yIGZyb20gdXNlcnNw
YWNlIG1heWJlKT8KPiAKPiBXaGF0IEknbSB0cnlpbmcgdG8gY2F0Y2ggaGVyZSBpcyB0aGUgZ3Vl
c3QgdGhhdCBoYXMgYmVlbiByZXN0b3JlZCB3aXRoCj4gbkFTU0dJcmVxIHNldC4gQXQgdGhlIG1v
bWVudCwgd2UgZG9uJ3QgZG8gYW55dGhpbmcgb24gdGhlIHVzZXJzcGFjZQo+IHNpZGUsIGJlY2F1
c2UgdGhlIHZtbSBjb3VsZCBkZWNpZGUgdG8gd3JpdGUgdGhhdCBwYXJ0aWN1bGFyIGJpdAo+IG11
bHRpcGxlIHRpbWVzLCBhbmQgc3dpdGNoaW5nIGJldHdlZW4gdGhlIHR3byBtb2RlcyBpcyBleHBl
bnNpdmUgKG5vdAo+IHRvIG1lbnRpb24gdGhhdCBhbGwgdGhlIHZjcHVzIG1heSBub3QgaGF2ZSBi
ZWVuIGNyZWF0ZWQgeWV0KS4KPiAKPiBNb3ZpbmcgaXQgdG8gdGhlIGZpcnN0IHJ1biBtYWtlcyBh
bGwgdGhlc2UgcGl0ZmFsbHMgZ28gYXdheSAod2UgaGF2ZSB0aGUKPiBmaW5hbCBuQVNTU0dJcmVx
IHZhbHVlLCBhbmQgYWxsIHRoZSB2Y3B1cyBhcmUgYWNjb3VudGVkIGZvcikuCgpTbyB3aGF0IHdp
bGwgaGFwcGVuIG9uIHJlc3RvcmF0aW9uIGlzIChyb3VnaGx5KToKCiAgLSBmb3IgR0lDUl9JU1BF
TlIwOiBXZSB3aWxsIHJlc3RvcmUgdGhlIHBlbmRpbmcgc3RhdHVzIG9mIHZTR0lzIGludG8KICAg
IHNvZnR3YXJlIHBlbmRpbmdfbGF0Y2gsIGp1c3QgbGlrZSB3aGF0IHdlJ3ZlIGRvbmUgZm9yIG5v
cm1hbCBTR0lzLgogIC0gZm9yIEdJQ0RfQ1RMUi5uQVNTR0lyZXE6IFdlIHdpbGwgb25seSByZWNv
cmQgdGhlIHdyaXR0ZW4gdmFsdWUuCiAgICAoTm90ZSB0byBteXNlbGY6IE5vIGludm9jYXRpb24g
b2YgY29uZmlndXJlX3ZzZ2lzKCkgaW4gdWFjY2Vzc193cml0ZQogICAgIGNhbGxiYWNrLCBJIHBy
ZXZpb3VzbHkgbWl4ZWQgaXQgdXAgd2l0aCB0aGUgZ3Vlc3Qgd3JpdGUgY2FsbGJhY2suKQogIC0g
RmluYWxseSwgeW91IGNob29zZSB0aGUgZmlyc3QgdmNwdSBydW4gYXMgdGhlIGFwcHJvcHJpYXRl
IHBvaW50IHRvCiAgICBwb3RlbnRpYWxseSBmbHVzaCB0aGUgcGVuZGluZyBzdGF0dXMgdG8gSFcg
YWNjb3JkaW5nIHRvIHRoZSBmaW5hbAogICAgbkFTU0dJcmVxIHZhbHVlLgoKPiAKPiBEb2VzIHRo
aXMgbWFrZSBzZW5zZSB0byB5b3U/CgpZZWFoLCBpdCBzb3VuZHMgbGlrZSBhIGdvb2QgaWRlYSEg
QW5kIHBsZWFzZSBpZ25vcmUgd2hhdCBJJ3ZlIHJlcGxpZWQgdG8KcGF0Y2ggIzE1LCBJIG9idmlv
dXNseSBtaXNzZWQgeW91ciBpbnRlbnRpb24gYXQgdGhhdCB0aW1lLCBzb3JyeS4uLgoKQnV0IGNh
biB3ZSBtb3ZlIHRoaXMgaHVuayB0byBzb21lIHBsYWNlcyBtb3JlIGFwcHJvcHJpYXRlLCBmb3Ig
ZXhhbXBsZSwKcHV0IGl0IHRvZ2V0aGVyIHdpdGggdGhlIEdJQ0RfQ1RMUidzIHVhY2Nlc3Nfd3Jp
dGUgY2hhbmdlPyBJdCBtaWdodCBtYWtlCnRoaW5ncyBhIGJpdCBjbGVhcmVyIGZvciBvdGhlciBy
ZXZpZXdlcnMuIDotKQoKClRoYW5rcywKWmVuZ2h1aQoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==

Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098E7C2D0DB
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 11:34:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B801208E4
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 11:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B801208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 051234AF02;
	Mon, 20 Jan 2020 06:34:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UXpbho2pFGW7; Mon, 20 Jan 2020 06:34:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C254AEF1;
	Mon, 20 Jan 2020 06:34:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8E714AEF1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 06:34:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id egbwZmdsbeYO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 06:34:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F054AEEA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 06:34:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30C4F30E;
 Mon, 20 Jan 2020 03:34:47 -0800 (PST)
Received: from [10.2.69.39] (unknown [10.2.69.39])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B137B3F68E;
 Mon, 20 Jan 2020 03:34:46 -0800 (PST)
Subject: Re: [PATCH] ARM: virt: Relax arch timer version check during early
 boot
To: Marc Zyngier <maz@kernel.org>
References: <1579097798-106243-1-git-send-email-vladimir.murzin@arm.com>
 <eb889279-87f2-d674-9299-169794c285eb@arm.com>
 <d4b8bb91f95385682f20c9dc5c6f5e50@kernel.org>
From: Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <38a43fed-1c7a-69ea-3662-e17f13ca74d6@arm.com>
Date: Mon, 20 Jan 2020 11:34:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d4b8bb91f95385682f20c9dc5c6f5e50@kernel.org>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCk9uIDEvMjAvMjAgMTE6MTQgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSBW
bGFkaW1pciwKPiAKPiBPbiAyMDIwLTAxLTIwIDExOjQ2LCBWbGFkaW1pciBNdXJ6aW4gd3JvdGU6
Cj4+ICsgTWFyYwo+PiArIGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKPj4KPj4gT24gMS8x
NS8yMCAyOjE2IFBNLCBWbGFkaW1pciBNdXJ6aW4gd3JvdGU6Cj4+PiBVcGRhdGVzIHRvIHRoZSBH
ZW5lcmljIFRpbWVyIGFyY2hpdGVjdHVyZSBhbGxvdyBJRF9QRlIxLkdlblRpbWVyIHRvCj4+PiBo
YXZlIHZhbHVlcyBvdGhlciB0aGFuIDAgb3IgMS4gQXQgdGhlIG1vbWVudCwgTGludXggaXMgcXVp
dGUgc3RyaWN0IGluCj4+PiB0aGUgd2F5IGl0IGhhbmRsZXMgdGhpcyBmaWVsZCBhdCBlYXJseSBi
b290IGFuZCB3aWxsIG5vdCBjb25maWd1cmUKPj4+IGFyY2ggdGltZXIgaWYgaXQgZG9lc24ndCBm
aW5kIHRoZSB2YWx1ZSAxLgo+Pj4KPj4+IFNpbmNlIGhlcmUgdXNlIHViZnggZm9yIGFyY2ggdGlt
ZXIgdmVyc2lvbiBleHRyYWN0aW9uIChoeWItc3R1YiBidWlsZAo+Pj4gd2l0aCAtbWFyY2g9YXJt
djctYSwgc28gaXQgaXMgc2FmZSkKPj4+Cj4+PiBUbyBoZWxwIGJhY2twb3J0cyAoZXZlbiB0aG91
Z2ggdGhlIGNvZGUgd2FzIGNvcnJlY3QgYXQgdGhlIHRpbWUgb2Ygd3JpdGluZykKPj4+IEZpeGVz
OiA4ZWM1OGJlOWYzZmYgKCJBUk06IHZpcnQ6IGFyY2hfdGltZXJzOiBlbmFibGUgYWNjZXNzIHRv
IHBoeXNpY2FsIHRpbWVycyIpCj4+PiBTaWduZWQtb2ZmLWJ5OiBWbGFkaW1pciBNdXJ6aW4gPHZs
YWRpbWlyLm11cnppbkBhcm0uY29tPgo+IAo+IEknbSBub3Qgb3Bwb3NlZCB0byBzdWNoIGEgY2hh
bmdlLCBidXQgaXQnZCBiZSBnb29kIHRvIGRvY3VtZW50IHdoYXQgb3RoZXIgdmFsdWVzCj4gYXJl
IGV4cGVjdGVkIGhlcmUsIGFzIHRoZSBjdXJyZW50IChSZXYgRV9hKSBBUk0gQVJNIG9ubHkgbWVu
dGlvbnMgdmFsdWVzIDAgYW5kIDEuCgpUaGF0IHRydWUsIEFSTSBBUk0gZG9lc24ndCBtZW50aW9u
IGl0IHlldC4gT1RPSCwgc2hvdWxkIHdlIHJlYWxseSBjYXJlIGFib3V0IGV4YWN0CnZhbHVlcyBh
cyBzb29uIGl0IHN0YXlzIGNvbXBhdGlibGU/CgpDaGVlcnMKVmxhZGltaXIKCj4gCj4gVGhhbmtz
LAo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCj4gCj4+PiAtLS0KPj4+IMKgYXJjaC9hcm0va2VybmVs
L2h5cC1zdHViLlMgfCA3ICsrKy0tLS0KPj4+IMKgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9u
cygrKSwgNCBkZWxldGlvbnMoLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm0va2VybmVs
L2h5cC1zdHViLlMgYi9hcmNoL2FybS9rZXJuZWwvaHlwLXN0dWIuUwo+Pj4gaW5kZXggYWU1MDIw
My4uNjYwN2ZhOCAxMDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJtL2tlcm5lbC9oeXAtc3R1Yi5TCj4+
PiArKysgYi9hcmNoL2FybS9rZXJuZWwvaHlwLXN0dWIuUwo+Pj4gQEAgLTE0NiwxMCArMTQ2LDkg
QEAgQVJNX0JFOChvcnLCoMKgwqAgcjcsIHI3LCAjKDEgPDwgMjUpKcKgwqDCoMKgIEAgSFNDVExS
LkVFCj4+PiDCoCNpZiAhZGVmaW5lZChaSU1BR0UpICYmIGRlZmluZWQoQ09ORklHX0FSTV9BUkNI
X1RJTUVSKQo+Pj4gwqDCoMKgwqAgQCBtYWtlIENOVFBfKiBhbmQgQ05UUENUIGFjY2Vzc2libGUg
ZnJvbSBQTDEKPj4+IMKgwqDCoMKgIG1yY8KgwqDCoCBwMTUsIDAsIHI3LCBjMCwgYzEsIDHCoMKg
wqAgQCBJRF9QRlIxCj4+PiAtwqDCoMKgIGxzcsKgwqDCoCByNywgIzE2Cj4+PiAtwqDCoMKgIGFu
ZMKgwqDCoCByNywgIzB4Zgo+Pj4gLcKgwqDCoCBjbXDCoMKgwqAgcjcsICMxCj4+PiAtwqDCoMKg
IGJuZcKgwqDCoCAxZgo+Pj4gK8KgwqDCoCB1YmZ4wqDCoMKgIHI3LCByNywgIzE2LCAjNAo+Pj4g
K8KgwqDCoCB0ZXHCoMKgwqAgcjcsICMwCj4+PiArwqDCoMKgIGJlccKgwqDCoCAxZgo+Pj4gwqDC
oMKgwqAgbXJjwqDCoMKgIHAxNSwgNCwgcjcsIGMxNCwgYzEsIDDCoMKgwqAgQCBDTlRIQ1RMCj4+
PiDCoMKgwqDCoCBvcnLCoMKgwqAgcjcsIHI3LCAjM8KgwqDCoMKgwqDCoMKgIEAgUEwxUENFTiB8
IFBMMVBDVEVOCj4+PiDCoMKgwqDCoCBtY3LCoMKgwqAgcDE1LCA0LCByNywgYzE0LCBjMSwgMMKg
wqDCoCBAIENOVEhDVEwKPj4+Cj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K

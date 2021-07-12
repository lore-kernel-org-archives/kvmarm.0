Return-Path: <SRS0=bTo6=ME=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080BFC07E9A
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 15:50:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FC3361242
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 15:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FC3361242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDF9D40CC5;
	Mon, 12 Jul 2021 11:50:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KXIgrA+kZyDM; Mon, 12 Jul 2021 11:50:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C3E34083E;
	Mon, 12 Jul 2021 11:50:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAF6C40569
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 11:50:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SJhT5pBy8viO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Jul 2021 11:50:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6228340294
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 11:50:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03ABE1FB;
 Mon, 12 Jul 2021 08:50:32 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32FA83F774;
 Mon, 12 Jul 2021 08:50:29 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Disabling disabled PMU counters wastes a
 lot of time
To: Robin Murphy <robin.murphy@arm.com>,
 Alexandre Chartre <alexandre.chartre@oracle.com>, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20210712151700.654819-1-alexandre.chartre@oracle.com>
 <d4646297-da3a-c629-d0b2-b830cce6a656@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <90b0b99b-505c-c46c-6c2c-a45192135f5a@arm.com>
Date: Mon, 12 Jul 2021 16:51:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d4646297-da3a-c629-d0b2-b830cce6a656@arm.com>
Content-Language: en-US
Cc: konrad.wilk@oracle.com
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

SGkgUm9iaW4sCgpPbiA3LzEyLzIxIDQ6NDQgUE0sIFJvYmluIE11cnBoeSB3cm90ZToKPiBPbiAy
MDIxLTA3LTEyIDE2OjE3LCBBbGV4YW5kcmUgQ2hhcnRyZSB3cm90ZToKPj4gSW4gYSBLVk0gZ3Vl
c3Qgb24gYXJtNjQsIHBlcmZvcm1hbmNlIGNvdW50ZXJzIGludGVycnVwdHMgaGF2ZSBhbgo+PiB1
bm5lY2Vzc2FyeSBvdmVyaGVhZCB3aGljaCBzbG93cyBkb3duIGV4ZWN1dGlvbiB3aGVuIHVzaW5n
IHRoZSAicGVyZgo+PiByZWNvcmQiIGNvbW1hbmQgYW5kIGxpbWl0cyB0aGUgInBlcmYgcmVjb3Jk
IiBzYW1wbGluZyBwZXJpb2QuCj4+Cj4+IFRoZSBwcm9ibGVtIGlzIHRoYXQgd2hlbiBhIGd1ZXN0
IFZNIGRpc2FibGVzIGNvdW50ZXJzIGJ5IGNsZWFyaW5nIHRoZQo+PiBQTUNSX0VMMC5FIGJpdCAo
Yml0IDApLCBLVk0gd2lsbCBkaXNhYmxlIGFsbCBjb3VudGVycyBkZWZpbmVkIGluCj4+IFBNQ1Jf
RUwwIGV2ZW4gaWYgdGhleSBhcmUgbm90IGVuYWJsZWQgaW4gUE1DTlRFTlNFVF9FTDAuCj4+Cj4+
IEtWTSBkaXNhYmxlcyBhIGNvdW50ZXIgYnkgY2FsbGluZyBpbnRvIHRoZSBwZXJmIGZyYW1ld29y
aywgaW4gcGFydGljdWxhcgo+PiBieSBjYWxsaW5nIHBlcmZfZXZlbnRfY3JlYXRlX2tlcm5lbF9j
b3VudGVyKCkgd2hpY2ggaXMgYSB0aW1lIGNvbnN1bWluZwo+PiBvcGVyYXRpb24uIFNvLCBmb3Ig
ZXhhbXBsZSwgd2l0aCBhIE5lb3ZlcnNlIE4xIENQVSBjb3JlIHdoaWNoIGhhcyA2IGV2ZW50Cj4+
IGNvdW50ZXJzIGFuZCBvbmUgY3ljbGUgY291bnRlciwgS1ZNIHdpbGwgYWx3YXlzIGRpc2FibGUg
YWxsIDcgY291bnRlcnMKPj4gZXZlbiBpZiBvbmx5IG9uZSBpcyBlbmFibGVkLgo+Pgo+PiBUaGlz
IHR5cGljYWxseSBoYXBwZW5zIHdoZW4gdXNpbmcgdGhlICJwZXJmIHJlY29yZCIgY29tbWFuZCBp
biBhIGd1ZXN0Cj4+IFZNOiBwZXJmIHdpbGwgZGlzYWJsZSBhbGwgZXZlbnQgY291bnRlcnMgd2l0
aCBQTUNOVEVOVFNFVF9FTDAgYW5kIG9ubHkKPj4gdXNlcyB0aGUgY3ljbGUgY291bnRlci4gQW5k
IHdoZW4gdXNpbmcgdGhlICJwZXJmIHJlY29yZCIgLUYgb3B0aW9uIHdpdGgKPj4gYSBoaWdoIHBy
b2ZpbGluZyBmcmVxdWVuY3ksIHRoZSBvdmVyaGVhZCBvZiBLVk0gZGlzYWJsaW5nIGFsbCBjb3Vu
dGVycwo+PiBpbnN0ZWFkIG9mIG9uZSBvbiBldmVyeSBjb3VudGVyIGludGVycnVwdCBiZWNvbWVz
IHZlcnkgbm90aWNlYWJsZS4KPj4KPj4gVGhlIHByb2JsZW0gaXMgZml4ZWQgYnkgaGF2aW5nIEtW
TSBkaXNhYmxlIG9ubHkgY291bnRlcnMgd2hpY2ggYXJlCj4+IGVuYWJsZWQgaW4gUE1DTlRFTlNF
VF9FTDAuIElmIGEgY291bnRlciBpcyBub3QgZW5hYmxlZCBpbiBQTUNOVEVOU0VUX0VMMAo+PiB0
aGVuIEtWTSB3aWxsIG5vdCBlbmFibGUgaXQgd2hlbiBzZXR0aW5nIFBNQ1JfRUwwLkUgYW5kIGl0
IHdpbGwgcmVtYWluCj4+IGRpc2FibGVkIGFzIGxvbmcgYXMgaXQgaXMgbm90IGVuYWJsZWQgaW4g
UE1DTlRFTlNFVF9FTDAuIFNvIHRoZXJlIGlzCj4+IGVmZmVjdGl2ZWx5IG5vIG5lZWQgdG8gZGlz
YWJsZSBhIGNvdW50ZXIgd2hlbiBjbGVhcmluZyBQTUNSX0VMMC5FIGlmIGl0Cj4+IGlzIG5vdCBl
bmFibGVkIFBNQ05URU5TRVRfRUwwLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcmUgQ2hh
cnRyZSA8YWxleGFuZHJlLmNoYXJ0cmVAb3JhY2xlLmNvbT4KPj4gLS0tCj4+IFRoZSBwYXRjaCBp
cyBiYXNlZCBvbgo+PiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9tYXovYXJtLXBsYXRmb3Jtcy5naXQvbG9nLz9oPWt2bS1hcm02NC9wbXUvcmVzZXQtdmFs
dWVzCj4+Cj4+IMKgIGFyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMgfCA4ICsrKysrLS0tCj4+IMKg
IDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4+Cj4+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jIGIvYXJjaC9hcm02NC9rdm0vcG11
LWVtdWwuYwo+PiBpbmRleCBmYWU0ZTk1YjU4NmMuLjFmMzE3YzNkYWM2MSAxMDA2NDQKPj4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS9wbXUt
ZW11bC5jCj4+IEBAIC01NjMsMjEgKzU2MywyMyBAQCB2b2lkIGt2bV9wbXVfc29mdHdhcmVfaW5j
cmVtZW50KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gdTY0IHZhbCkKPj4gwqDCoCAqLwo+PiDC
oCB2b2lkIGt2bV9wbXVfaGFuZGxlX3BtY3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgdmFs
KQo+PiDCoCB7Cj4+IC3CoMKgwqAgdW5zaWduZWQgbG9uZyBtYXNrID0ga3ZtX3BtdV92YWxpZF9j
b3VudGVyX21hc2sodmNwdSk7Cj4+ICvCoMKgwqAgdW5zaWduZWQgbG9uZyBtYXNrOwo+PiDCoMKg
wqDCoMKgIGludCBpOwo+PiDCoCDCoMKgwqDCoMKgIGlmICh2YWwgJiBBUk1WOF9QTVVfUE1DUl9F
KSB7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fcG11X2VuYWJsZV9jb3VudGVyX21hc2sodmNw
dSwKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX192Y3B1X3N5c19yZWcodmNw
dSwgUE1DTlRFTlNFVF9FTDApKTsKPj4gwqDCoMKgwqDCoCB9IGVsc2Ugewo+PiAtwqDCoMKgwqDC
oMKgwqAga3ZtX3BtdV9kaXNhYmxlX2NvdW50ZXJfbWFzayh2Y3B1LCBtYXNrKTsKPj4gK8KgwqDC
oMKgwqDCoMKgIGt2bV9wbXVfZGlzYWJsZV9jb3VudGVyX21hc2sodmNwdSwKPj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgX192Y3B1X3N5c19yZWcodmNwdSwgUE1DTlRFTlNFVF9FTDAp
KTsKPj4gwqDCoMKgwqDCoCB9Cj4+IMKgIMKgwqDCoMKgwqAgaWYgKHZhbCAmIEFSTVY4X1BNVV9Q
TUNSX0MpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fcG11X3NldF9jb3VudGVyX3ZhbHVlKHZj
cHUsIEFSTVY4X1BNVV9DWUNMRV9JRFgsIDApOwo+PiDCoCDCoMKgwqDCoMKgIGlmICh2YWwgJiBB
Uk1WOF9QTVVfUE1DUl9QKSB7Cj4+IC3CoMKgwqDCoMKgwqDCoCBtYXNrICY9IH5CSVQoQVJNVjhf
UE1VX0NZQ0xFX0lEWCk7Cj4+ICvCoMKgwqDCoMKgwqDCoCBtYXNrID0ga3ZtX3BtdV92YWxpZF9j
b3VudGVyX21hc2sodmNwdSkKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJiBCSVQoQVJNVjhf
UE1VX0NZQ0xFX0lEWCk7Cj4KPiBUaGlzIGxvb2tzIHN1c3BpY2lvdXNseSBvcHBvc2l0ZSBvZiB3
aGF0IGl0IHJlcGxhY2VzOyAKCkl0IGFsd2F5cyBzZXRzIHRoZSBiaXQsIHdoaWNoIGdvZXMgYWdh
aW5zdCB0aGUgYXJjaGl0ZWN0dXJlIGFuZCB0aGUgY29kZSBpdCB3YXMKcmVwbGFjaW5nLCB5ZXMu
Cgo+IGhvd2V2ZXIgZGlkIHdlIGV2ZW4gbmVlZCB0byBkbyBhIGJpdHdpc2Ugb3BlcmF0aW9uIGhl
cmUgaW4gdGhlIGZpcnN0IHBsYWNlPwo+IENvdWxkbid0IHdlIHNraXAgdGhlIGN5Y2xlIGNvdW50
ZXIgYnkganVzdCBsaW1pdGluZyB0aGUgZm9yX2VhY2hfc2V0X2JpdAo+IGl0ZXJhdGlvbiBiZWxv
dyB0byAzMSBiaXRzPwoKVG8gcXVvdGUgbXlzZWxmIFsxXToKCiJFbnRlcnRhaW5lZCB0aGUgaWRl
YSBvZiByZXN0cmljdGluZyB0aGUgbnVtYmVyIG9mIGJpdHMgaW4gZm9yX2VhY2hfc2V0X2JpdCgp
IHRvCjMxIHNpbmNlIExpbnV4IChhbmQgdGhlIGFyY2hpdGVjdHVyZSwgdG8gc29tZSBkZWdyZWUp
IHRyZWF0cyB0aGUgY3ljbGUgY291bnQKcmVnaXN0ZXIgYXMgdGhlIDMybmQgZXZlbnQgY291bnRl
ci4gU2V0dGxlZCBvbiB0aGlzIGFwcHJvYWNoIGJlY2F1c2UgSSB0aGluayBpdCdzCmNsZWFyZXIu
IgoKVG8gZXhwYW5kIG9uIHRoYXQsIGluY29ycmVjdGx5IHJlc2V0dGluZyB0aGUgY3ljbGUgY291
bnRlciB3YXMgaW50cm9kdWNlZCBieSBhCnJlZmFjdG9yaW5nLCBzbyBJIHByZWZlcnJlZCBtYWtp
bmcgaXQgdmVyeSBjbGVhciB0aGF0IFBNQ1JfRUwwLlAgaXMgbm90IHN1cHBvc2VkCnRvIGNsZWFy
IHRoZSBjeWNsZSBjb3VudGVyLgoKWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bWFybS8y
MDIxMDYxODEwNTEzOS44Mzc5NS0xLWFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbS8KClRoYW5rcywK
CkFsZXgKCj4KPiBSb2Jpbi4KPgo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgZm9yX2VhY2hfc2V0X2Jp
dChpLCAmbWFzaywgMzIpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9wbXVfc2V0
X2NvdW50ZXJfdmFsdWUodmNwdSwgaSwgMCk7Cj4+IMKgwqDCoMKgwqAgfQo+Pgo+PiBiYXNlLWNv
bW1pdDogODNmODcwYTY2MzU5Mjc5N2M1NzY4NDZkYjM2MTFlMGExNjY0ZWRhMgo+PgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

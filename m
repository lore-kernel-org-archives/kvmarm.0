Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896FEC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 12:40:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E530C64F9A
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 12:39:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E530C64F9A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FBE84B22B;
	Wed,  3 Feb 2021 07:39:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h7AP9Ky3-G28; Wed,  3 Feb 2021 07:39:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CC1E4B26A;
	Wed,  3 Feb 2021 07:39:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E8B24B22C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 07:39:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FtgtiKNhzcM9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 07:39:56 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D9504B22B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 07:39:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612355996;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7I0Ccsfbksiom0KDSfGuPHiDPSZnaJLN1wCUx9nAHbU=;
 b=fp8BzVsJVMWkQyrLR9gEKiZ2yWwibxxGXKYz5jv2lrcI2TeMV9YcmUNVBcynzT8MD4aVni
 qMZiGg5I8ExARBHQGLKEIWQiu4+vUaeOhPvbCcoS3NiAJtSp7tHLO0Tu8Cprqa460yDtDJ
 7sEApdxuZORCIHaWEz9TBxgTXtdEboQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-wXH1N1duOtGpGOtTPjY5cg-1; Wed, 03 Feb 2021 07:39:52 -0500
X-MC-Unique: wXH1N1duOtGpGOtTPjY5cg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E54B419611C2;
 Wed,  3 Feb 2021 12:39:50 +0000 (UTC)
Received: from [10.36.113.43] (ovpn-113-43.ams2.redhat.com [10.36.113.43])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF0427770F;
 Wed,  3 Feb 2021 12:39:48 +0000 (UTC)
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
To: Marc Zyngier <maz@kernel.org>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
 <adbdbfbcecb65a1eca21afa622679836@kernel.org>
 <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
 <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <d9f8b79a-74de-0058-aa14-4ed5ec3b6aab@redhat.com>
Date: Wed, 3 Feb 2021 13:39:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

SGksCgpPbiAyLzMvMjEgMTI6MjAgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIxLTAy
LTAzIDExOjA3LCBBdWdlciBFcmljIHdyb3RlOgo+PiBIaSBNYXJjLAo+PiBPbiAyLzMvMjEgMTE6
MzYgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IEhpIEVyaWMsCj4+Pgo+Pj4gT24gMjAyMS0w
MS0yNyAxNzo1MywgQXVnZXIgRXJpYyB3cm90ZToKPj4+PiBIaSBNYXJjLAo+Pj4+Cj4+Pj4gT24g
MS8yNS8yMSAxOjI2IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4+IFVwZ3JhZGluZyB0aGUg
UE1VIGNvZGUgZnJvbSBBUk12OC4xIHRvIEFSTXY4LjQgdHVybnMgb3V0IHRvIGJlCj4+Pj4+IHBy
ZXR0eSBlYXN5LiBBbGwgdGhhdCBpcyByZXF1aXJlZCBpcyBzdXBwb3J0IGZvciBQTU1JUl9FTDEs
IHdoaWNoCj4+Pj4+IGlzIHJlYWQtb25seSwgYW5kIGZvciB3aGljaCByZXR1cm5pbmcgMCBpcyBh
IHZhbGlkIG9wdGlvbiBhcyBsb25nCj4+Pj4+IGFzIHdlIGRvbid0IGFkdmVydGlzZSBTVEFMTF9T
TE9UIGFzIGFuIGltcGxlbWVudGVkIGV2ZW50Lgo+Pj4+Pgo+Pj4+PiBMZXQncyBqdXN0IGRvIHRo
YXQgYW5kIGFkanVzdCB3aGF0IHdlIHJldHVybiB0byB0aGUgZ3Vlc3QuCj4+Pj4+Cj4+Pj4+IFNp
Z25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4+Pj4+IC0tLQo+Pj4+
PiDCoGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmggfMKgIDMgKysrCj4+Pj4+IMKgYXJj
aC9hcm02NC9rdm0vcG11LWVtdWwuY8KgwqDCoMKgwqDCoCB8wqAgNiArKysrKysKPj4+Pj4gwqBh
cmNoL2FybTY0L2t2bS9zeXNfcmVncy5jwqDCoMKgwqDCoMKgIHwgMTEgKysrKysrKy0tLS0KPj4+
Pj4gwqAzIGZpbGVzIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4+
Pj4+Cj4+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+
Pj4+IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaAo+Pj4+PiBpbmRleCA4YjVlN2U1
YzNjYzguLjJmYjNmMzg2NTg4YyAxMDA2NDQKPj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9zeXNyZWcuaAo+Pj4+PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5o
Cj4+Pj4+IEBAIC04NDYsNyArODQ2LDEwIEBACj4+Pj4+Cj4+Pj4+IMKgI2RlZmluZSBJRF9ERlIw
X1BFUkZNT05fU0hJRlTCoMKgwqDCoMKgwqDCoCAyNAo+Pj4+Pgo+Pj4+PiArI2RlZmluZSBJRF9E
RlIwX1BFUkZNT05fOF8wwqDCoMKgwqDCoMKgwqAgMHgzCj4+Pj4+IMKgI2RlZmluZSBJRF9ERlIw
X1BFUkZNT05fOF8xwqDCoMKgwqDCoMKgwqAgMHg0Cj4+Pj4+ICsjZGVmaW5lIElEX0RGUjBfUEVS
Rk1PTl84XzTCoMKgwqDCoMKgwqDCoCAweDUKPj4+Pj4gKyNkZWZpbmUgSURfREZSMF9QRVJGTU9O
XzhfNcKgwqDCoMKgwqDCoMKgIDB4Ngo+Pj4+Pgo+Pj4+PiDCoCNkZWZpbmUgSURfSVNBUjRfU1dQ
X0ZSQUNfU0hJRlTCoMKgwqDCoMKgwqDCoCAyOAo+Pj4+PiDCoCNkZWZpbmUgSURfSVNBUjRfUFNS
X01fU0hJRlTCoMKgwqDCoMKgwqDCoCAyNAo+Pj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9r
dm0vcG11LWVtdWwuYyBiL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+Pj4gaW5kZXggMzk4
ZjZkZjFiYmU0Li43MmNkNzA0YTgzNjggMTAwNjQ0Cj4+Pj4+IC0tLSBhL2FyY2gvYXJtNjQva3Zt
L3BtdS1lbXVsLmMKPj4+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+Pj4+PiBA
QCAtNzk1LDYgKzc5NSwxMiBAQCB1NjQga3ZtX3BtdV9nZXRfcG1jZWlkKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwKPj4+Pj4gYm9vbCBwbWNlaWQxKQo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgIGJhc2Ug
PSAwOwo+Pj4+PiDCoMKgwqDCoCB9IGVsc2Ugewo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgIHZhbCA9
IHJlYWRfc3lzcmVnKHBtY2VpZDFfZWwwKTsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qCj4+Pj4+
ICvCoMKgwqDCoMKgwqDCoMKgICogRG9uJ3QgYWR2ZXJ0aXNlIFNUQUxMX1NMT1QsIGFzIFBNTUlS
X0VMMCBpcyBoYW5kbGVkCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgICogYXMgUkFaCj4+Pj4+ICvC
oMKgwqDCoMKgwqDCoMKgICovCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAodmNwdS0+a3ZtLT5h
cmNoLnBtdXZlciA+PSBJRF9BQTY0REZSMF9QTVVWRVJfOF80KQo+Pj4+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB2YWwgJj0gfkJJVF9VTEwoQVJNVjhfUE1VVjNfUEVSRkNUUl9TVEFMTF9TTE9U
IC0gMzIpOwo+Pj4+IHdoYXQgYWJvdXQgdGhlIFNUQUxMX1NMT1RfQkFDS0VORCBhbmQgRlJPTlRF
TkQgZXZlbnRzIHRoZW4/Cj4+Pgo+Pj4gQXJlbid0IHRoZXNlIGEgbWFuZGF0b3J5IEFSTXY4LjEg
ZmVhdHVyZT8gSSBkb24ndCBzZWUgYSByZWFzb24gdG8KPj4+IGRyb3AgdGhlbS4KPj4KPj4gSSB1
bmRlcnN0YW5kIHRoZSAzIGFyZSBsaW5rZWQgdG9nZXRoZXIuCj4+Cj4+IEluIEQ3LjExIGl0IGlz
IHNhaWQKPj4gIgo+PiBXaGVuIGFueSBvZiB0aGUgZm9sbG93aW5nIGNvbW1vbiBldmVudHMgYXJl
IGltcGxlbWVudGVkLCBhbGwgdGhyZWUgb2YKPj4gdGhlbSBhcmUgaW1wbGVtZW50ZWQ6Cj4+IDB4
MDAzRCAsIFNUQUxMX1NMT1RfQkFDS0VORCwgTm8gb3BlcmF0aW9uIHNlbnQgZm9yIGV4ZWN1dGlv
biBvbiBhIFNsb3QKPj4gZHVlIHRvIHRoZSBiYWNrZW5kLAo+PiAweDAwM0UgLCBTVEFMTF9TTE9U
X0ZST05URU5ELCBObyBvcGVyYXRpb24gc2VudCBmb3IgZXhlY3V0aW9uIG9uIGEgU2xvdAo+PiBk
dWUgdG8gdGhlIGZyb250ZW5kLgo+PiAweDAwM0YgLCBTVEFMTF9TTE9ULCBObyBvcGVyYXRpb24g
c2VudCBmb3IgZXhlY3V0aW9uIG9uIGEgU2xvdC4KPj4gIgo+IAo+IFRoZXkgYXJlIGxpbmtlZCBp
biB0aGUgc2Vuc2UgdGhhdCB0aGV5IHJlcG9ydCByZWxhdGVkIGV2ZW50cywgYnV0IHRoZXkKPiBk
b24ndCBoYXZlIHRvIGJlIGltcGxlbWVudGVkIGluIHRoZSBzYW1lIGxldmVsIG9mIHRoZSBhcmNo
aXRlY3VyZSwgaWYgb25seQo+IGJlY2F1c2UgQkFDS0VORC9GUk9OVEVORCB3ZXJlIGludHJvZHVj
ZWR3YXkgYmVmb3JlIEFSTXY4LjQuCj4gCj4gV2hhdCB0aGUgYXJjaGl0ZWN0dXJlIHNheXMgaXM6
Cj4gCj4gLSBGb3IgRkVBVF9QTVV2M3AxIChBUk12OC4xKToKPiDCoCAiVGhlIFNUQUxMX0ZST05U
RU5EIGFuZCBTVEFMTF9CQUNLRU5EIGV2ZW50cyBhcmUgcmVxdWlyZWQgdG8gYmUKPiDCoMKgIGlt
cGxlbWVudGVkLiIgKEEyLjQuMSwgRERJMDQ4N0cuYSkKT0sKPiAKPiAtIEZvciBGRUFUX1BNVXYz
cDQgKEFSTXY4LjQpOgo+IMKgICJJZiBGRUFUX1BNVXYzcDQgaXMgaW1wbGVtZW50ZWQ6Cj4gwqDC
oCAtIElmIFNUQUxMX1NMT1QgaXMgbm90IGltcGxlbWVudGVkLCBpdCBpcyBJTVBMRU1FTlRBVElP
TiBERUZJTkVECj4gd2hldGhlciB0aGUgUE1NSVIgU3lzdGVtIHJlZ2lzdGVycyBhcmUgaW1wbGVt
ZW50ZWQuCj4gwqDCoCAtIElmIFNUQUxMX1NMT1QgaXMgaW1wbGVtZW50ZWQsIHRoZW4gdGhlIFBN
TUlSIFN5c3RlbSByZWdpc3RlcnMgYXJlCj4gaW1wbGVtZW50ZWQuIiAoRDctMjg3MywgRERJMDQ4
N0cuYSkKPiAKPiBTbyB3aGlsZSBCQUNLRU5EL0ZST05URU5EIGFyZSByZXF1aXJlZCBpbiBhbiBB
Uk12OC40IGltcGxlbWVudGF0aW9uCj4gYnkgdmlydHVlIG9mIGJlaW5nIG1hbmRhdG9yeSBpbiBB
Uk12OC4xLCBTVEFMTF9TTE9UIGlzbid0IGF0IGFueSBwb2ludC4KQnV0IHRoZW4gaG93IGRvIHlv
dSB1bmRlcnN0YW5kICJXaGVuIGFueSBvZiB0aGUgZm9sbG93aW5nIGNvbW1vbiBldmVudHMKYXJl
IGltcGxlbWVudGVkLCBhbGwgdGhyZWUgb2YgdGhlbSBhcmUgaW1wbGVtZW50ZWQiPwoKRXJpYwo+
IAo+IFRoYW5rcywKPiAKPiDCoMKgwqDCoMKgwqDCoMKgIE0uCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K

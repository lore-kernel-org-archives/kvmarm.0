Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDCEC34047
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 18:15:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 84554208C4
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 18:15:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84554208C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E54224AF29;
	Tue, 18 Feb 2020 13:15:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o7NCGf6W-2Ul; Tue, 18 Feb 2020 13:15:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC0014AF2D;
	Tue, 18 Feb 2020 13:15:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DBA94AF21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 13:15:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9cvWGc8Z+YJC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 13:15:16 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 620264AF0E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 13:15:16 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8CE831B;
 Tue, 18 Feb 2020 10:15:15 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C3603F68F;
 Tue, 18 Feb 2020 10:15:14 -0800 (PST)
Subject: Re: [PATCH 1/5] KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
To: Robin Murphy <robin.murphy@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-2-maz@kernel.org>
 <c1bd5c57-666e-0d54-1e7c-e45d0535ffe3@arm.com>
 <a02252f6-1e9a-2a35-9944-f23e161583ab@arm.com>
From: James Morse <james.morse@arm.com>
Message-ID: <bf599b74-6ead-8722-d4d4-870a0cabc213@arm.com>
Date: Tue, 18 Feb 2020 18:15:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a02252f6-1e9a-2a35-9944-f23e161583ab@arm.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

SGkgUm9iaW4sCgpPbiAxOC8wMi8yMDIwIDE4OjAxLCBSb2JpbiBNdXJwaHkgd3JvdGU6Cj4gT24g
MTgvMDIvMjAyMCA1OjQzIHBtLCBKYW1lcyBNb3JzZSB3cm90ZToKPj4gT24gMTYvMDIvMjAyMCAx
ODo1MywgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gVGhlIEFBcmNoMzIgQ1AxNCBEQkdESURSIGhh
cyBiaXQgMTUgc2V0IHRvIFJFUzEsIHdoaWNoIG91ciBjdXJyZW50Cj4+PiBlbXVsYXRpb24gZG9l
c24ndCBzZXQuIEp1c3QgYWRkIHRoZSBtaXNzaW5nIGJpdC4KCj4+PiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPj4+IGlu
ZGV4IDNlOTA5YjExN2YwYy4uZGE4MmM0YjAzYWFiIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02
NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+Pj4g
QEAgLTE2NTgsNyArMTY1OCw3IEBAIHN0YXRpYyBib29sIHRyYXBfZGJnaWRyKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBwLT5yZWd2YWwgPSAoKCgoZGZyID4+
IElEX0FBNjRERlIwX1dSUFNfU0hJRlQpICYgMHhmKSA8PCAyOCkgfAo+Pj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICgoKGRmciA+PiBJRF9BQTY0REZSMF9CUlBTX1NISUZU
KSAmIDB4ZikgPDwgMjQpIHwKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAoKChkZnIgPj4gSURfQUE2NERGUjBfQ1RYX0NNUFNfU0hJRlQpICYgMHhmKSA8PCAyMCkKPj4+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8ICg2IDw8IDE2KSB8IChlbDMgPDwg
MTQpIHwgKGVsMyA8PCAxMikpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHwgKDYgPDwgMTYpIHwgKDEgPDwgMTUpIHwgKGVsMyA8PCAxNCkgfCAoZWwzIDw8IDEyKSk7Cj4+
Cj4+IEhtbW0sIHdoZXJlIGVsMyBpczoKPj4gfCB1MzIgZWwzID0gISFjcHVpZF9mZWF0dXJlX2V4
dHJhY3RfdW5zaWduZWRfZmllbGQocGZyLCBJRF9BQTY0UEZSMF9FTDNfU0hJRlQpOwo+Pgo+PiBB
cmVuJ3Qgd2UgZGVwZW5kaW5nIG9uIHRoZSBjb21waWxlcnMgJ3RydWUnIGJlaW5nIDEgaGVyZT8K
PiAKPiBQcmV0dHkgbXVjaCwgYnV0IHRoYW5rZnVsbHkgdGhlIG9ubHkgY29tcGlsZXJzIHdlIHN1
cHBvcnQgYXJlIEMgY29tcGlsZXJzOgo+IAo+ICJUaGUgcmVzdWx0IG9mIHRoZSBsb2dpY2FsIG5l
Z2F0aW9uIG9wZXJhdG9yICEgaXMgMCBpZiB0aGUgdmFsdWUgb2YgaXRzIG9wZXJhbmQgY29tcGFy
ZXMKPiB1bmVxdWFsIHRvIDAsIDEgaWYgdGhlIHZhbHVlIG9mIGl0cyBvcGVyYW5kIGNvbXBhcmVz
IGVxdWFsIHRvIDAuIFRoZSByZXN1bHQgaGFzIHR5cGUgaW50LiIKCkV4Y2VsbGVudC4gSSB0aG91
Z2h0IHRoaXMgd2FzIHRoZSBzb3J0IG9mIHRoaW5nIHRoYXQgY291bGRuJ3QgYmUgZGVwZW5kZWQg
b24hCgoKPiBBbmQgbm93IEkgaGF2ZSB5b3UgdG8gdGhhbmsgZm9yIGZsYXNoYmFja3MgdG8gYml0
d2lzZSBsb2dpY2FsIG9wZXJhdG9ycyBpbiBWaXN1YWwgQmFzaWMuLi4gOlAKCi4uLiBzb3JyeT8K
CgoKVGhhbmtzLAoKSmFtZXMKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

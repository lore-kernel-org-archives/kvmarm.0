Return-Path: <SRS0=CuDs=DH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5313C4727E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Sep 2020 10:46:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5DB3207F7
	for <kvmarm@archiver.kernel.org>; Wed, 30 Sep 2020 10:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5DB3207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD104B2C8;
	Wed, 30 Sep 2020 06:46:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u4thBNYkoV2r; Wed, 30 Sep 2020 06:46:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFB034B1F4;
	Wed, 30 Sep 2020 06:46:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF11F4B1F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 06:45:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H15TGajkZB20 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2020 06:45:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 760DC4B1DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 06:45:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 098E4D6E;
 Wed, 30 Sep 2020 03:45:58 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0092B3F70D;
 Wed, 30 Sep 2020 03:45:56 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Ensure user_mem_abort() return value is
 initialised
To: Will Deacon <will@kernel.org>, maz@kernel.org
References: <20200930102442.16142-1-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <addce3ac-85a8-21b1-7326-c86fc3b6952a@arm.com>
Date: Wed, 30 Sep 2020 11:47:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200930102442.16142-1-will@kernel.org>
Content-Language: en-US
Cc: kernel test robot <lkp@intel.com>, Will Deacon <willdeacon@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Dan Carpenter <dan.carpenter@oracle.com>
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

SGkgV2lsbCzCoAoKT24gOS8zMC8yMCAxMToyNCBBTSwgV2lsbCBEZWFjb24gd3JvdGU6Cj4gRnJv
bTogV2lsbCBEZWFjb24gPHdpbGxkZWFjb25AZ29vZ2xlLmNvbT4KPgo+IElmIGEgY2hhbmdlIGlu
IHRoZSBNTVUgbm90aWZpZXIgc2VxdWVuY2UgbnVtYmVyIGZvcmNlcyB1c2VyX21lbV9hYm9ydCgp
Cj4gdG8gcmV0dXJuIGVhcmx5IHdoZW4gYXR0ZW1wdGluZyB0byBoYW5kbGUgYSBzdGFnZS0yIGZh
dWx0LCB3ZSByZXR1cm4KPiB1bmluaXRpYWxpc2VkIHN0YWNrIHRvIGt2bV9oYW5kbGVfZ3Vlc3Rf
YWJvcnQoKSwgd2hpY2ggY291bGQgcG90ZW50aWFsbHkKPiByZXN1bHQgaW4gdGhlIGluamVjdGlv
biBvZiBhbiBleHRlcm5hbCBhYm9ydCBpbnRvIHRoZSBndWVzdCBvciBhIHNwdXJpb3VzCj4gcmV0
dXJuIHRvIHVzZXJzcGFjZS4gTmVpdGhlciBvciB0aGVzZSBhcmUgd2hhdCB3ZSB3YW50IHRvIGRv
Lgo+Cj4gSW5pdGlhbGlzZSAncmV0JyB0byAwIGluIHVzZXJfbWVtX2Fib3J0KCkgc28gdGhhdCBi
YWlsaW5nIGR1ZSB0byBhCj4gY2hhbmdlIGluIHRoZSBNTVUgbm90cmlmaWVyIHNlcXVlbmNlIG51
bWJlciBpcyB0cmVhdGVkIGFzIHRob3VnaCB0aGUKPiBmYXVsdCB3YXMgaGFuZGxlZC4KPgo+IENj
OiBHYXZpbiBTaGFuIDxnc2hhbkByZWRoYXQuY29tPgo+IENjOiBBbGV4YW5kcnUgRWxpc2VpIDxh
bGV4YW5kcnUuZWxpc2VpQGFybS5jb20+Cj4gUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90
IDxsa3BAaW50ZWwuY29tPgo+IFJlcG9ydGVkLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVu
dGVyQG9yYWNsZS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogV2lsbCBEZWFjb24gPHdpbGxAa2VybmVs
Lm9yZz4KPiAtLS0KPgo+IEFwcGxpZXMgb24gdG9wIG9mIGt2bWFybS9uZXh0Lgo+Cj4gIGFyY2gv
YXJtNjQva3ZtL21tdS5jIHwgMiArLQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9tbXUuYyBiL2Fy
Y2gvYXJtNjQva3ZtL21tdS5jCj4gaW5kZXggYzVjMjZhOWNiODViLi5hODE2Y2I4ZTYxOWIgMTAw
NjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vbW11LmMKPiArKysgYi9hcmNoL2FybTY0L2t2bS9t
bXUuYwo+IEBAIC03NDIsNyArNzQyLDcgQEAgc3RhdGljIGludCB1c2VyX21lbV9hYm9ydChzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsIHBoeXNfYWRkcl90IGZhdWx0X2lwYSwKPiAgCQkJICBzdHJ1Y3Qg
a3ZtX21lbW9yeV9zbG90ICptZW1zbG90LCB1bnNpZ25lZCBsb25nIGh2YSwKPiAgCQkJICB1bnNp
Z25lZCBsb25nIGZhdWx0X3N0YXR1cykKPiAgewo+IC0JaW50IHJldDsKPiArCWludCByZXQgPSAw
Owo+ICAJYm9vbCB3cml0ZV9mYXVsdCwgd3JpdGFibGUsIGZvcmNlX3B0ZSA9IGZhbHNlOwo+ICAJ
Ym9vbCBleGVjX2ZhdWx0Owo+ICAJYm9vbCBkZXZpY2UgPSBmYWxzZTsKClRoaXMgbWF0Y2hlcyB0
aGUgY3VycmVudCBiZWhhdmlvciBvZiB1c2VyX21lbV9hYm9ydCgpLCB3aGVyZSByZXQgPSAwIGZy
b20gdGhlIGNhbGwKdG8ga3ZtX21tdV90b3B1cF9tZW1vcnlfY2FjaGUoKSwgd2hpY2ggd2FzIG1h
ZGUgY29uZGl0aW9uYWwgYnkgdGhlIEVMMiBwYWdlIHRhYmxlCnJld3JpdGUuIEl0IG1ha2VzIHNl
bnNlIHRvIG1lIC0gd2UgcmV0dXJuIHRvIHRoZSBndWVzdCBhbmQgdGFrZSB0aGUgZmF1bHQgYWdh
aW4KdW50aWwgdGhlIGNoYW5nZXMgdG8gdGhlIHRyYW5zbGF0aW9uIHRhYmxlcyBoYXZlIGJlZW4g
ZXhlY3V0ZWQgKG1tdV9ub3RpZmllcl9zZXEKcmVtYWlucyB0aGUgc2FtZSBhbmQgbW11X25vdGlm
aWVyX2NvdW50ID09IDApOgoKUmV2aWV3ZWQtYnk6IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRy
dS5lbGlzZWlAYXJtLmNvbT4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

Return-Path: <SRS0=pXP7=GJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E519C433DB
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 16:32:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05E1523132
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 16:32:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05E1523132
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 549D84B3AB;
	Wed,  6 Jan 2021 11:32:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a4thPaFUfto7; Wed,  6 Jan 2021 11:32:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24AAA4B336;
	Wed,  6 Jan 2021 11:32:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33FAB4B31A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 11:32:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id udi9jEtdEdvu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jan 2021 11:32:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FEC84B2EF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 11:32:25 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66309106F;
 Wed,  6 Jan 2021 08:32:24 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E07033F719;
 Wed,  6 Jan 2021 08:32:22 -0800 (PST)
Subject: Re: [PATCH 1/9] KVM: arm64: vgic-v3: Fix some error codes when
 setting RDIST base
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-2-eric.auger@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <fa73780d-b72b-6810-460e-5ed1057df093@arm.com>
Date: Wed, 6 Jan 2021 16:32:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201212185010.26579-2-eric.auger@redhat.com>
Content-Language: en-US
Cc: shuah@kernel.org, pbonzini@redhat.com
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

SGkgRXJpYywKCk9uIDEyLzEyLzIwIDY6NTAgUE0sIEVyaWMgQXVnZXIgd3JvdGU6Cj4gS1ZNX0RF
Vl9BUk1fVkdJQ19HUlBfQUREUiBncm91cCBkb2Mgc2F5cyB3ZSBzaG91bGQgcmV0dXJuCj4gLUVF
WElTVCBpbiBjYXNlIHRoZSBiYXNlIGFkZHJlc3Mgb2YgdGhlIHJlZGlzdCBpcyBhbHJlYWR5IHNl
dC4KPiBXZSBjdXJyZW50bHkgcmV0dXJuIC1FSU5WQUwuCj4KPiBIb3dldmVyIHdlIG5lZWQgdG8g
cmV0dXJuIC1FSU5WQUwgaW4gY2FzZSBhIGxlZ2FjeSBSRURJU1QgYWRkcmVzcwo+IGlzIGF0dGVt
cHRlZCB0byBiZSBzZXQgd2hpbGUgUkVESVNUX1JFR0lPTlMgd2VyZSBzZXQuIFRoaXMgY2FzZQo+
IGlzIGRpc2NyaW1pbmF0ZWQgYnkgbG9va2luZyBhdCB0aGUgY291bnQgZmllbGQuCj4KPiBTaWdu
ZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4gLS0tCj4gIGFy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMgfCA5ICsrKysrKystLQo+ICAxIGZpbGUg
Y2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+Cj4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMgYi9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtbW1pby12My5jCj4gaW5kZXggMTVhNmM5OGVlOTJmLi44ZThhODYyZGVmNzYgMTAwNjQ0
Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLW1taW8tdjMuYwo+ICsrKyBiL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMKPiBAQCAtNzkyLDggKzc5MiwxMyBAQCBzdGF0
aWMgaW50IHZnaWNfdjNfaW5zZXJ0X3JlZGlzdF9yZWdpb24oc3RydWN0IGt2bSAqa3ZtLCB1aW50
MzJfdCBpbmRleCwKPiAgCWludCByZXQ7Cj4gIAo+ICAJLyogc2luZ2xlIHJkaXN0IHJlZ2lvbiBh
bHJlYWR5IHNldCA/Ki8KPiAtCWlmICghY291bnQgJiYgIWxpc3RfZW1wdHkocmRfcmVnaW9ucykp
Cj4gLQkJcmV0dXJuIC1FSU5WQUw7Cj4gKwlpZiAoIWNvdW50ICYmICFsaXN0X2VtcHR5KHJkX3Jl
Z2lvbnMpKSB7Cj4gKwkJcmRyZWcgPSBsaXN0X2xhc3RfZW50cnkocmRfcmVnaW9ucywKPiArCQkJ
CSAgICAgICBzdHJ1Y3QgdmdpY19yZWRpc3RfcmVnaW9uLCBsaXN0KTsKPiArCQlpZiAocmRyZWct
PmNvdW50KQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsgLyogTWl4aW5nIFJFRElTVCBhbmQgUkVESVNU
X1JFR0lPTiBBUEkgKi8KPiArCQlyZXR1cm4gLUVFWElTVDsKPiArCX0KCkEgZmV3IGluc3RydWN0
aW9ucyBiZWxvdzoKCsKgwqDCoCBpZiAobGlzdF9lbXB0eShyZF9yZWdpb25zKSkgewrCoMKgwqAg
wqDCoMKgIFsuLl0KwqDCoMKgIH0gZWxzZSB7CsKgwqDCoCDCoMKgwqAgcmRyZWcgPSBsaXN0X2xh
c3RfZW50cnkocmRfcmVnaW9ucywKwqDCoMKgIMKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgwqDCoCBz
dHJ1Y3QgdmdpY19yZWRpc3RfcmVnaW9uLCBsaXN0KTsKwqDCoMKgIMKgwqDCoCBbLi5dCgrCoMKg
wqAgwqDCoMKgIC8qIENhbm5vdCBhZGQgYW4gZXhwbGljaXRseSBzaXplZCByZWdpb25zIGFmdGVy
IGxlZ2FjeSByZWdpb24gKi8KwqDCoMKgIMKgwqDCoCBpZiAoIXJkcmVnLT5jb3VudCkKwqDCoMKg
IMKgwqDCoCDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7CsKgwqDCoCB9CgpJc24ndCB0aGlzIHRlc3Rp
bmcgZm9yIHRoZSBzYW1lIHRoaW5nLCBidXQgdXNpbmcgdGhlIG9wcG9zaXRlIGNvbmRpdGlvbj8g
T3IgYW0gSQptaXN1bmRlcnN0YW5kaW5nIHRoZSBjb2RlIChxdWl0ZSBsaWtlbHkpPwoKTG9va3Mg
dG8gbWUgbGlrZSBLVk1fREVWX0FSTV9WR0lDX0dSUF9BRERSKEtWTV9WR0lDX1YzX0FERFJfVFlQ
RV9SRURJU1R7LF9SRUdJT059KQp1c2VkIHRvIHJldHVybiAtRUVYSVNUIChmcm9tIHZnaWNfY2hl
Y2tfaW9hZGRyKCkpIGJlZm9yZSBjb21taXQgY2NjMjdiZjViZTdiNwooIktWTTogYXJtL2FybTY0
OiBIZWxwZXIgdG8gcmVnaXN0ZXIgYSBuZXcgcmVkaXN0cmlidXRvciByZWdpb24iKSB3aGljaCBh
ZGRlZCB0aGUKdmdpY192M19pbnNlcnRfcmVkaXN0X3JlZ2lvbigpIGZ1bmN0aW9uLCBzbyBicmlu
Z2luZyBiYWNrIHRoZSAtRUVYSVNUIHJldHVybiBjb2RlCmxvb2tzIHRoZSByaWdodCB0aGluZyB0
byBtZS4KClRoYW5rcywKQWxleAo+ICAKPiAgCS8qIGNyb3NzIHRoZSBlbmQgb2YgbWVtb3J5ID8g
Ki8KPiAgCWlmIChiYXNlICsgc2l6ZSA8IGJhc2UpCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=

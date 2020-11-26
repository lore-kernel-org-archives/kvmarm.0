Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA9FC56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:52:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71795221E2
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:52:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71795221E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC50B4BEA8;
	Thu, 26 Nov 2020 10:52:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rb-DXZi0XPrL; Thu, 26 Nov 2020 10:52:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C56974B9FA;
	Thu, 26 Nov 2020 10:52:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83C584B904
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:52:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MN3st5bGG8VX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:52:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 625794B8FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:52:46 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED0A731B;
 Thu, 26 Nov 2020 07:52:45 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4156A3F23F;
 Thu, 26 Nov 2020 07:52:45 -0800 (PST)
Subject: Re: [PATCH 6/8] KVM: arm64: Remove dead PMU sysreg decoding code
To: Marc Zyngier <maz@kernel.org>
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-7-maz@kernel.org>
 <1ed6dfd6-4ace-a562-bc2f-054a5c853fa6@arm.com>
 <3ae09ecc95b732129f71076b4b59c873@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b05e1334-e7d0-5c00-3442-d383d0358bcd@arm.com>
Date: Thu, 26 Nov 2020 15:54:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <3ae09ecc95b732129f71076b4b59c873@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

SGkgTWFyYywKCk9uIDExLzI2LzIwIDM6MzQgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSBB
bGV4LAo+Cj4gT24gMjAyMC0xMS0yNiAxNToxOCwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4g
SGkgTWFyYywKPj4KPj4gSSBjaGVja2VkIGFuZCBpbmRlZWQgdGhlIHJlbWFpbmluZyBjYXNlcyBj
b3ZlciBhbGwgcmVnaXN0ZXJzIHRoYXQgdXNlCj4+IHRoaXMgYWNjZXNzb3IuCj4+Cj4+IEhvd2V2
ZXIsIEknbSBhIGJpdCB0b3JuIGhlcmUuIFRoZSB3YXJuaW5nIHRoYXQgSSBnb3Qgd2hlbiB0cnlp
bmcgdG8gcnVuIGEgZ3Vlc3QKPj4gd2l0aCB0aGUgUE1VIGZlYXR1cmUgZmxhZyBzZXQsIGJ1dCBu
b3QgaW5pdGlhbGl6ZWQgKHJlcG9ydGVkIGF0IFsxXSkKPj4gd2FzIGFsc28gbm90Cj4+IHN1cHBv
c2VkIHRvIGV2ZXIgYmUgcmVhY2hlZDoKPj4KPj4gc3RhdGljIHUzMiBrdm1fcG11X2V2ZW50X21h
c2soc3RydWN0IGt2bSAqa3ZtKQo+PiB7Cj4+IMKgwqDCoCBzd2l0Y2ggKGt2bS0+YXJjaC5wbXV2
ZXIpIHsKPj4gwqDCoMKgIGNhc2UgMTrCoMKgwqAgwqDCoMKgIMKgwqDCoCAvKiBBUk12OC4wICov
Cj4+IMKgwqDCoCDCoMKgwqAgcmV0dXJuIEdFTk1BU0soOSwgMCk7Cj4+IMKgwqDCoCBjYXNlIDQ6
wqDCoMKgIMKgwqDCoCDCoMKgwqAgLyogQVJNdjguMSAqLwo+PiDCoMKgwqAgY2FzZSA1OsKgwqDC
oCDCoMKgwqAgwqDCoMKgIC8qIEFSTXY4LjQgKi8KPj4gwqDCoMKgIGNhc2UgNjrCoMKgwqAgwqDC
oMKgIMKgwqDCoCAvKiBBUk12OC41ICovCj4+IMKgwqDCoCDCoMKgwqAgcmV0dXJuIEdFTk1BU0so
MTUsIDApOwo+PiDCoMKgwqAgZGVmYXVsdDrCoMKgwqAgwqDCoMKgIC8qIFNob3VsZG4ndCBiZSBo
ZXJlLCBqdXN0IGZvciBzYW5pdHkgKi8KPj4gwqDCoMKgIMKgwqDCoCBXQVJOX09OQ0UoMSwgIlVu
a25vd24gUE1VIHZlcnNpb24gJWRcbiIsIGt2bS0+YXJjaC5wbXV2ZXIpOwo+PiDCoMKgwqAgwqDC
oMKgIHJldHVybiAwOwo+PiDCoMKgwqAgfQo+PiB9Cj4+Cj4+IEkgcmVhbGl6ZSBpdCdzIG5vdCBl
eGFjdGx5IHRoZSBzYW1lIHRoaW5nIGFuZCBJJ2xsIGxlYXZlIGl0IHVwIHRvIHlvdQo+PiBpZiB5
b3Ugd2FudAo+PiB0byBhZGQgYSB3YXJuaW5nIGZvciB0aGUgY2FzZXMgdGhhdCBzaG91bGQgbmV2
ZXIgaGFwcGVuLiBJJ20gZmluZSBlaXRoZXIgd2F5Ogo+Cj4gSSBhbHJlYWR5IGhhdmUgcXVldWVk
IHN1Y2ggYSB3YXJuaW5nWzFdLiBJdCB0dXJucyBvdXQgdGhhdCBMTFZNIHdhcm5zCj4gaWR4IGNh
biBiZSBsZWZ0IHVuaW5pdGlhbGl6ZWQsIGFuZCBzaG91dHMuIExldCBtZSBrbm93IGlmIHRoYXQg
d29ya3MKPiBmb3IgeW91LgoKTG9va3MgZ29vZCB0byBtZSwgdW5zaWduZWQgbG9uZyBpcyA2NCBi
aXRzIGFuZCBpbnN0cnVjdGlvbnMgYXJlIDMyIGJpdHMsIHNvIHdlJ2xsCm5ldmVyIHJ1biBpbnRv
IGEgc2l0dWF0aW9uIHdoZXJlIGEgdmFsaWQgZW5jb2RpbmcgaXMgfjBVTC4KCllvdSBjYW4gYWRk
IG15IFJldmlld2VkLWJ5IHRvIHRoaXMgcGF0Y2ggKGFuZCB0byB0aGUgb25lIGF0IFsxXSBpZiBp
dCdzIHN0aWxsCnBvc3NpYmxlKS4KClRoYW5rcywKCkFsZXgKCj4KPiBUaGFua3MsCj4KPiDCoMKg
wqDCoMKgwqDCoCBNLgo+Cj4gWzFdCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvbWF6L2FybS1wbGF0Zm9ybXMuZ2l0L2NvbW1pdC8/aD1rdm0tYXJtNjQv
cG11LXVuZGVmJmlkPWFmN2VmZjcwZWFmOGYyODE3OTMzNGY1YWVhYmI3MGEzMDYyNDJjODMKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

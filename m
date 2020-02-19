Return-Path: <SRS0=1n5P=4H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BD3C3404D
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 10:18:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CCECB24670
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 10:18:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCECB24670
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A1074AF22;
	Wed, 19 Feb 2020 05:18:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vn3EZWpfyF4s; Wed, 19 Feb 2020 05:18:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29A074AF25;
	Wed, 19 Feb 2020 05:18:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 950804AF21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 05:18:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8g0+fbZKEXsd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 05:18:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 654264AF0F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 05:18:53 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2B341FB;
 Wed, 19 Feb 2020 02:18:52 -0800 (PST)
Received: from [172.16.1.159] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E9F33F6CF;
 Wed, 19 Feb 2020 02:18:50 -0800 (PST)
Subject: Re: [PATCH 3/5] kvm: arm64: Limit PMU version to ARMv8.1
To: Marc Zyngier <maz@kernel.org>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-4-maz@kernel.org>
 <eb0294ef-5ad2-9940-2d59-b92220948ffc@arm.com>
 <c0a848e3ababff4ee9ecaa4b246d5875@kernel.org>
From: James Morse <james.morse@arm.com>
Openpgp: preference=signencrypt
Message-ID: <ed7f31d5-9a2b-6ea0-85f8-74fcd7d9ac61@arm.com>
Date: Wed, 19 Feb 2020 10:18:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c0a848e3ababff4ee9ecaa4b246d5875@kernel.org>
Content-Language: en-US
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

SGkgTWFyYywKCk9uIDIvMTkvMjAgOTo0NiBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIw
MjAtMDItMTggMTc6NDMsIEphbWVzIE1vcnNlIHdyb3RlOgo+PiBIaSBNYXJjLAo+Pgo+PiBPbiAx
Ni8wMi8yMDIwIDE4OjUzLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiBPdXIgUE1VIGNvZGUgaXMg
b25seSBpbXBsZW1lbnRpbmcgdGhlIEFSTXY4LjEgZmVhdHVyZXMsIHNvIGxldCdzCj4+PiBzdGlj
ayB0byB0aGlzIHdoZW4gcmVwb3J0aW5nIHRoZSBmZWF0dXJlIHNldCB0byB0aGUgZ3Vlc3QuCj4+
Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQv
a3ZtL3N5c19yZWdzLmMKPj4+IGluZGV4IDY4MmZlZGQ3NzAwZi4uMDZiMmQwZGM2YzczIDEwMDY0
NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gKysrIGIvYXJjaC9hcm02
NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gQEAgLTEwOTMsNiArMTA5MywxMSBAQCBzdGF0aWMgdTY0IHJl
YWRfaWRfcmVnKGNvbnN0IHN0cnVjdCBrdm1fdmNwdQo+Pj4gKnZjcHUsCj4+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEZFQVRVUkUoSURfQUE2NElTQVIxX0dQQSkgfAo+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBGRUFUVVJFKElEX0FBNjRJU0FSMV9H
UEkpKTsKPj4+IMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+PiArwqDCoMKgIGNhc2UgU1lTX0lE
X0FBNjRERlIwX0VMMToKPj4+ICvCoMKgwqDCoMKgwqDCoCAvKiBMaW1pdCBQTVUgdG8gQVJNdjgu
MSAqLwo+Pgo+PiBOb3QganVzdCBsaW1pdCwgYnV0IHVwZ3JhZGUgdG9vISAoZm9yY2U/KQo+PiBU
aGlzIGxvb2tzIHNhZmUgYmVjYXVzZSBBUk1WOF9QTVVfRVZUWVBFX0VWRU5UIGFsd2F5cyBpbmNs
dWRlcyB0aGUKPj4gZXh0cmEgYml0cyB0aGlzIGFkZGVkLCBhbmQgdGhlIHJlZ2lzdGVyIGlzIGFs
d2F5cyB0cmFwcGVkLgo+IAo+IFRoYXQncyBkZWZpbml0ZWx5IG5vdCB3aGF0IEkgaW50ZW5kZWQh
IExldCBtZSBmaXggdGhhdCBvbmUuCgpXaGF0IGdvZXMgd3Jvbmc/CgpUaGUgcmVnaXN0ZXIgZGVz
Y3JpcHRpb24gc2F5cyB0byBzdXBwb3J0IHY4LjEgeW91IG5lZWQ6CnwgRXh0ZW5kZWQgMTYtYml0
IFBNRVZUWVBFUjxuPl9FTDAuZXZ0Q291bnQgZmllbGQKfCBJZiBFTDIgaXMgaW1wbGVtZW50ZWQs
IHRoZSBNRENSX0VMMi5IUE1EIGNvbnRyb2wgYml0CgpJdCBsb29rcyBsaWtlIHRoZSBleHRlbmRl
ZCBQTUVWVFlQRVIgd291bGQgd29yayB2aWEgdGhlIGVtdWxhdGlvbiwgYW5kCkVMMiBndWVzdHMg
YXJlIHRvdGFsbHkgY3JhenkuCgpJcyB0aGUgU1RBTExfKiBiaXRzIGluIEFSTXY4LjEtUE1VIHRo
ZSBwcm9ibGVtLCAuLi4gb3IgdGhlIGV4dHJhIHdvcmsKZm9yIE5WPwoKCj4+IFRoZSBQTVUgdmVy
c2lvbiBpcyBhbHNvIHJlYWRhYmxlIHZpYSBJRF9ERlIwX0VMMS5QZXJmTW9uLCBzaG91bGQgdGhh
dAo+PiBiZSBzYW5pdGlzZWQgdG8gYmUgdGhlIHNhbWU/IChJIGRvbid0IHRoaW5rIHdlJ3ZlIGhp
ZGRlbiBhbiBhYXJjaDY0Cj4+IGZlYXR1cmUgdGhhdCBhbHNvIGV4aXN0ZWQgaW4gYWFyY2gzMiBi
ZWZvcmUpLgo+IAo+IEluZGVlZCwgeWV0IGFub3RoZXIgb3ZlcnNpZ2h0LiBJJ2xsIGZpeCB0aGF0
IHRvby4KCihXZWlyZCB2YXJpYXRpb24gaW4gdGhlIGFhcmNoMzIgYW5kIGFhcmNoNjQgSUQgcmVn
aXN0ZXJzIGlzbid0IHNvbWV0aGluZwpJIGNhcmUgYWJvdXQgLi4uIHdobyB3b3VsZCBldmVyIGxv
b2sgYXQgYm90aD8pCgoKClRoYW5rcywKCkphbWVzCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=

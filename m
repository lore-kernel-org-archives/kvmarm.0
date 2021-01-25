Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93354C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 16:57:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 016192223E
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 16:57:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 016192223E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5104B442;
	Mon, 25 Jan 2021 11:57:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Uk1AVarcrhV; Mon, 25 Jan 2021 11:57:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C9DC4B60D;
	Mon, 25 Jan 2021 11:57:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 788574B442
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 11:57:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o4vwWZzHdZK2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 11:57:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C404B42F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 11:57:02 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFA5511FB;
 Mon, 25 Jan 2021 08:57:01 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAB733F68F;
 Mon, 25 Jan 2021 08:57:00 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 10/12] arm64: gic: its-trigger: Don't
 trigger the LPI while it is pending
To: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
 drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
 <20201217141400.106137-11-alexandru.elisei@arm.com>
 <d24f7bf4-2a38-22f8-68e6-98940c61c65a@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3bc9e5ce-345b-505a-ffd3-a96b531124d6@arm.com>
Date: Mon, 25 Jan 2021 16:57:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <d24f7bf4-2a38-22f8-68e6-98940c61c65a@arm.com>
Content-Language: en-US
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

SGkgQW5kcmUsCgpPbiAxMi8xOC8yMCA2OjE1IFBNLCBBbmRyw6kgUHJ6eXdhcmEgd3JvdGU6Cj4g
T24gMTcvMTIvMjAyMCAxNDoxMywgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gVGhlIGl0cy10
cmlnZ2VyIHRlc3QgY2hlY2tzIHRoYXQgTFBJIDgxOTUgaXMgbm90IGRlbGl2ZXJlZCB0byB0aGUg
Q1BVIHdoaWxlCj4+IGl0IGlzIGRpc2FibGVkIGF0IHRoZSBJVFMgbGV2ZWwuIEFmdGVyIHRoYXQg
aXQgaXMgcmUtZW5hYmxlZCBhbmQgdGhlIHRlc3QKPj4gY2hlY2tzIHRoYXQgdGhlIGludGVycnVw
dCBpcyBwcm9wZXJseSBhc3NlcnRlZC4gQWZ0ZXIgaXQncyByZS1lbmFibGVkIGFuZAo+PiBiZWZv
cmUgdGhlIHN0YXRzIGFyZSBleGFtaW5lZCwgdGhlIHRlc3QgdHJpZ2dlcnMgdGhlIGludGVycnVw
dCBhZ2Fpbiwgd2hpY2gKPj4gY2FuIGxlYWQgdG8gdGhlIHNhbWUgaW50ZXJydXB0IGJlaW5nIGRl
bGl2ZXJlZCB0d2ljZTogb25jZSBhZnRlciB0aGUKPj4gY29uZmlndXJhdGlvbiBpbnZhbGlkYXRp
b24gYW5kIGJlZm9yZSB0aGUgSU5UIGNvbW1hbmQsIGFuZCBvbmNlIGFmdGVyIHRoZQo+PiBJTlQg
Y29tbWFuZC4KPj4KPj4gR2V0IHJpZCBvZiB0aGUgSU5UIGNvbW1hbmQgYWZ0ZXIgdGhlIGludGVy
cnVwdCBpcyByZS1lbmFibGVkIHRvIHByZXZlbnQgdGhlCj4gVGhpcyBpcyBjb25mdXNpbmcgdG8g
cmVhZCwgc2luY2UgeW91IGRvbid0IHJlbW92ZSBhbnl0aGluZyBpbiB0aGUgcGF0Y2guCj4gQ2Fu
IHlvdSByZXdvcmQgdGhpcz8gU29tZXRoaW5nIGxpa2UgIkJlZm9yZSBleHBsaWNpdGx5IHRyaWdn
ZXJpbmcgdGhlCj4gaW50ZXJydXB0LCBjaGVjayB0aGF0IHRoZSB1bm1hc2tpbmcgd29ya2VkLCAu
Li4iCgpUaGF0J3MgYSBnb29kIHBvaW50LCBJJ2xsIHJld29yZCBpdC4KCj4KPj4gTFBJIGZyb20g
YmVpbmcgYXNzZXJ0ZWQgdHdpY2UgYW5kIGFkZCBhIHNlcGFyYXRlIGNoZWNrIHRvIHRlc3QgdGhh
dCB0aGUgSU5UCj4+IGNvbW1hbmQgc3RpbGwgd29ya3MgZm9yIHRoZSBub3cgcmUtZW5hYmxlZCBM
UEkgODE5NS4KPj4KPj4gQ0M6IEF1Z2VyIEVyaWMgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPj4g
U3VnZ2VzdGVkLWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4gU2lnbmVk
LW9mZi1ieTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPgo+IE90
aGVyd2lzZSB0aGlzIGxvb2tzIGZpbmUsIGJ1dCBJIHRoaW5rIHRoZXJlIGlzIGFub3RoZXIgZmxh
dzogVGhlcmUgaXMKPiBubyByZXF1aXJlbWVudCB0aGF0IGFuIElOVihBTEwpIGlzICpuZWVkZWQq
IHRvIHVwZGF0ZSB0aGUgc3RhdHVzLCBpdAo+IGNvdWxkIGFsc28gdXBkYXRlIGFueXRpbWUgKHRo
aW5rOiAiY2FjaGUgaW52YWxpZGF0ZSIpLgo+Cj4gVGhlIEtWTSBJVFMgZW11bGF0aW9uICpvbmx5
KiBib3RoZXJzIHRvIHJlYWQgdGhlIG1lbW9yeSBvbiBhbiBJTlYoQUxMKQo+IGNvbW1hbmQsIHNv
IHRoYXQgbWF0Y2hlcyB0aGUgdGVzdC4gQnV0IHRoYXQncyBub3QgaG93IHVuaXQtdGVzdHMgc2hv
dWxkCj4gd29yayA7LSkKPgo+IEJ1dCB0aGF0J3MgYSBzZXBhcmF0ZSBpc3N1ZSwganVzdCBtZW50
aW9uaW5nIHRoaXMgdG8gbm90IGZvcmdldCBhYm91dCBpdC4KClRoYXQncyBhIGdvb2QgcG9pbnQs
IEkgbXVzdCBhZG1pdCB0aGF0IEkgZGlkbid0IGNoZWNrIGhvdyBjYWNoaW5nIGlzIGRlZmluZWQg
YnkKdGhlIGFyY2hpdGVjdHVyZS4gSSB3b3VsZCBwcmVmZXIgY3JlYXRpbmcgYSBwYXRjaCBpbmRl
cGVuZGVudCBvZiB0aGlzIHNlcmllcyB0bwpjaGFuZ2Ugd2hhdCB0ZXN0X2l0c190cmlnZ2VyKCkg
Y2hlY2tzIGZvciwgdG8gZ2V0IGlucHV0IGZyb20gRXJpYyBqdXN0IGZvciB0aGF0CnBhcnRpY3Vs
YXIgY2hhbmdlLgoKVGhhbmtzLApBbGV4Cj4KPiBGb3IgdGhpcyBwYXRjaCwgd2l0aCB0aGUgbWVz
c2FnZSBmaXhlZDoKPgo+IFJldmlld2VkLWJ5OiBBbmRyZSBQcnp5d2FyYSA8YW5kcmUucHJ6eXdh
cmFAYXJtLmNvbT4KPgo+IENoZWVycywKPiBBbmRyZQo+Cj4+IC0tLQo+PiAgYXJtL2dpYy5jIHwg
MyArKysKPj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdp
dCBhL2FybS9naWMuYyBiL2FybS9naWMuYwo+PiBpbmRleCBmYjkxODYxOTAwYjcuLmFhM2FhMTc2
Mzk4NCAxMDA2NDQKPj4gLS0tIGEvYXJtL2dpYy5jCj4+ICsrKyBiL2FybS9naWMuYwo+PiBAQCAt
ODA1LDYgKzgwNSw5IEBAIHN0YXRpYyB2b2lkIHRlc3RfaXRzX3RyaWdnZXIodm9pZCkKPj4gIAo+
PiAgCS8qIE5vdyBjYWxsIHRoZSBpbnZhbGwgYW5kIGNoZWNrIHRoZSBMUEkgaGl0cyAqLwo+PiAg
CWl0c19zZW5kX2ludmFsbChjb2wzKTsKPj4gKwlscGlfc3RhdHNfZXhwZWN0KDMsIDgxOTUpOwo+
PiArCWNoZWNrX2xwaV9zdGF0cygiZGV2Mi9ldmVudGlkPTIwIHBlbmRpbmcgTFBJIGlzIHJlY2Vp
dmVkIik7Cj4+ICsKPj4gIAlscGlfc3RhdHNfZXhwZWN0KDMsIDgxOTUpOwo+PiAgCWl0c19zZW5k
X2ludChkZXYyLCAyMCk7Cj4+ICAJY2hlY2tfbHBpX3N0YXRzKCJkZXYyL2V2ZW50aWQ9MjAgbm93
IHRyaWdnZXJzIGFuIExQSSIpOwo+PgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K

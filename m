Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8D1C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 09:17:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C28C22D2A
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 09:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C28C22D2A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2B784B2FB;
	Tue, 12 Jan 2021 04:17:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RlINSGDGoZC2; Tue, 12 Jan 2021 04:17:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88F7C4B2BA;
	Tue, 12 Jan 2021 04:17:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB9D4B2B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 04:17:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WlnJiH27MoJk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 04:17:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A31BF4B2B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 04:17:30 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 032B531B;
 Tue, 12 Jan 2021 01:17:30 -0800 (PST)
Received: from [10.57.39.145] (unknown [10.57.39.145])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7AA5F3F719;
 Tue, 12 Jan 2021 01:17:27 -0800 (PST)
Subject: Re: [PATCH v3 09/21] arm64: cpufeature: Add global feature override
 facility
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
References: <20210111132811.2455113-1-maz@kernel.org>
 <20210111132811.2455113-10-maz@kernel.org> <20210111184154.GC17941@gaia>
 <129db8bd3913a90c96d4cfe4f55e27a0@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <a122aa5c-4af9-e236-db82-db0ed885e0a5@arm.com>
Date: Tue, 12 Jan 2021 09:17:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <129db8bd3913a90c96d4cfe4f55e27a0@kernel.org>
Content-Language: en-GB
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, kernel-team@android.com,
 linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Ajay Patil <pajay@qti.qualcomm.com>, Will Deacon <will@kernel.org>,
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

SGkgTWFyYywKCk9uIDEvMTEvMjEgNzo0OCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIENh
dGFsaW4sCj4gCj4gT24gMjAyMS0wMS0xMSAxODo0MSwgQ2F0YWxpbiBNYXJpbmFzIHdyb3RlOgo+
PiBIaSBNYXJjLAo+Pgo+PiBPbiBNb24sIEphbiAxMSwgMjAyMSBhdCAwMToyNzo1OVBNICswMDAw
LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiBBZGQgYSBmYWNpbGl0eSB0byBnbG9iYWxseSBvdmVy
cmlkZSBhIGZlYXR1cmUsIG5vIG1hdHRlciB3aGF0Cj4+PiB0aGUgSFcgc2F5cy4gWWVzLCB0aGlz
IGlzIGRhbmdlcm91cy4KPj4KPj4gWWVhaCwgaXQncyBkYW5nZXJvdXMuIFdlIGNhbiBtYWtlIGl0
IGxlc3Mgc28gaWYgd2Ugb25seSBhbGxvdyBzYWZlCj4+IHZhbHVlcyAoZS5nLiBsb3dlciBpZiBG
VFJfVU5TSUdORUQpLgo+IAo+IE15IHBsYW4gd2FzIGFsc28gdG8gYWxsb3cgbm9uLXNhZmUgdmFs
dWVzIGluIG9yZGVyIHRvIHRyaWdnZXIgZmVhdHVyZXMKPiB0aGF0IGFyZSBub3QgYWR2ZXJ0aXNl
ZCBieSB0aGUgSFcuIEJ1dCBJIGNhbiB1bmRlcnN0YW5kIGlmIHlvdSBhcmUKPiByZWx1Y3RhbnQg
dG8gYWxsb3cgc3VjaCB0aGluZyEgOkQKPiAKPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL2NwdWZlYXR1cmUuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1ZmVhdHVy
ZS5oCj4+PiBpbmRleCA5YTU1NTgwOWI4OWMuLjQ2NWQyY2I2M2JmYyAxMDA2NDQKPj4+IC0tLSBh
L2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oCj4+PiArKysgYi9hcmNoL2FybTY0
L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaAo+Pj4gQEAgLTc1LDYgKzc1LDggQEAgc3RydWN0IGFy
bTY0X2Z0cl9yZWcgewo+Pj4gwqDCoMKgwqAgdTY0wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHN5c192YWw7Cj4+PiDCoMKgwqDCoCB1NjTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdXNlcl92YWw7Cj4+PiDCoMKgwqDCoCBjb25zdCBzdHJ1Y3QgYXJtNjRfZnRyX2JpdHPCoMKg
wqAgKmZ0cl9iaXRzOwo+Pj4gK8KgwqDCoCB1NjTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKm92ZXJyaWRlX3ZhbDsKPj4+ICvCoMKgwqAgdTY0wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgICpvdmVycmlkZV9tYXNrOwo+Pj4gwqB9Owo+Pgo+PiBBdCB0aGUgYXJtNjRfZnRyX3Jl
ZyBsZXZlbCwgd2UgZG9uJ3QgaGF2ZSBhbnkgaW5mb3JtYXRpb24gYWJvdXQgdGhlIHNhZmUKPj4g
dmFsdWVzIGZvciBhIGZlYXR1cmUuIENvdWxkIHdlIGluc3RlYWQgbW92ZSB0aGlzIHRvIGFybTY0
X2Z0cl9iaXRzPyBXZQo+PiBwcm9iYWJseSBvbmx5IG5lZWQgYSBzaW5nbGUgZmllbGQuIFdoZW4g
cG9wdWxhdGluZyB0aGUgZmVhdHVyZSB2YWx1ZXMsCj4+IHdlIGNhbiBtYWtlIHN1cmUgaXQgZG9l
c24ndCBnbyBhYm92ZSB0aGUgaGFyZHdhcmUgb25lLgo+Pgo+PiBJIGF0dGVtcHRlZCBhIGZlYXR1
cmUgbW9kaWZpY2F0aW9uIGZvciBNVEUgaGVyZSwgdGhvdWdoIEkgZHJvcHBlZCB0aGUKPj4gZW50
aXJlIHNlcmllcyBpbiB0aGUgbWVhbnRpbWUgYXMgd2UgY2xhcmlmaWVkIHRoZSBBUk0gQVJNOgo+
Pgo+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1hcm0ta2VybmVsLzIwMjAwNTE1MTcx
NjEyLjEwMjAtMjQtY2F0YWxpbi5tYXJpbmFzQGFybS5jb20vCj4+Cj4+IFNyaW5pdmFzIGNvcGll
ZCBpdCBpbiBoaXMgcGF0Y2ggKGJ1dCBmb3Jnb3QgdG8gZ2l2ZSBjcmVkaXQgOykpOgo+Pgo+PiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1hcm0tbXNtLzE2MTAxNTIxNjMtMTY1NTQtMy1n
aXQtc2VuZC1lbWFpbC1zcmFtYW5hQGNvZGVhdXJvcmEub3JnLwo+Pgo+PiBUaGUgYWJvdmUgYWRk
cyBhIGZpbHRlciBmdW5jdGlvbiBidXQsIGluc3RlYWQsIGp1c3QgdXNlIHlvdXIgbWVjaGFuaXNt
IGluCj4+IHRoaXMgc2VyaWVzIGZvciBpZHJlZy5mZWF0dXJlIHNldHRpbmcgdmlhIGNtZGxpbmUu
IFRoZSBhcm02NF9mdHJfdmFsdWUoKQo+PiBmdW5jdGlvbiBleHRyYWN0cyB0aGUgaGFyZHdhcmUg
dmFsdWUgYW5kIGxvd2VycyBpdCBpZiBhIGNtZGxpbmUgYXJndW1lbnQKPj4gd2FzIHBhc3NlZC4K
PiAKPiBPbmUgdGhpbmcgaXMgdGhhdCBpdCBpcyBub3QgYWx3YXlzIHBvc3NpYmxlIHRvIHNhbml0
aXNlIHRoZSB2YWx1ZSBwYXNzZWQKPiBpZiBpdCBpcyByZXF1aXJlZCB2ZXJ5IGVhcmx5IG9uLCBh
cyBJIGRvIHdpdGggVkhFLiBCdXQgaW4gdGhhdCBjYXNlCj4gSSBhY3R1YWxseSBjaGVjayB0aGF0
IHdlIGFyZSBWSEUgY2FwYWJsZSBiZWZvcmUgc3RhcnRpbmcgdG8gcG9rZSBhdAo+IFZIRS1zcGVj
aWZpYyBzdGF0ZS4KPiAKPiBJIGNhbWUgdXAgd2l0aCB0aGUgZm9sbG93aW5nIHBhdGNoIG9uIHRv
cCwgd2hpY2ggcHJlc2VydmVzIHRoZSBjdXJyZW50Cj4gZ2xvYmFsIGFwcHJvYWNoIChubyBwZXIg
YXJtNjRfZnRyX2JpdHMgc3RhdGUpLCBidXQgY2hlY2tzIChhbmQgYWx0ZXJzKQo+IHRoZSBvdmVy
cmlkZSBhcyBpdCBpdGVyYXRlcyB0aHJvdWdoIHRoZSB2YXJpb3VzIGZpZWxkcy4KPiAKPiBGb3Ig
ZXhhbXBsZSwgaWYgSSBwYXNzICJhcm02NC5ub3BhdXRoIGt2bS1hcm0ubW9kZT1udmhlIGlkX2Fh
NjRwZnIxLmJ0PTUiCj4gdG8gdGhlIEZWUCwgSSBnZXQgdGhlIGZvbGxvd2luZyBvdXRwdXQ6Cj4g
Cj4gW8KgwqDCoCAwLjAwMDAwMF0gQ1BVIGZlYXR1cmVzOiBTWVNfSURfQUE2NElTQVIxX0VMMVsz
MToyOF06IGZvcmNlZCBmcm9tIDEgdG8gMAo+IFvCoMKgwqAgMC4wMDAwMDBdIENQVSBmZWF0dXJl
czogU1lTX0lEX0FBNjRJU0FSMV9FTDFbMTE6OF06IGZvcmNlZCBmcm9tIDEgdG8gMAo+IFvCoMKg
wqAgMC4wMDAwMDBdIENQVSBmZWF0dXJlczogU1lTX0lEX0FBNjRNTUZSMV9FTDFbMTE6OF06IGZv
cmNlZCBmcm9tIDEgdG8gMAo+IFvCoMKgwqAgMC4wMDAwMDBdIENQVSBmZWF0dXJlczogU1lTX0lE
X0FBNjRQRlIxX0VMMVszOjBdOiBub3QgZm9yY2luZyAxIHRvIDUKPiBbwqDCoMKgIDAuMDAwMDAw
XSBDUFUgZmVhdHVyZXM6IGRldGVjdGVkOiBHSUMgc3lzdGVtIHJlZ2lzdGVyIENQVSBpbnRlcmZh
Y2UKPiBbwqDCoMKgIDAuMDAwMDAwXSBDUFUgZmVhdHVyZXM6IGRldGVjdGVkOiBIYXJkd2FyZSBk
aXJ0eSBiaXQgbWFuYWdlbWVudAo+IFvCoMKgwqAgMC4wMDAwMDBdIENQVSBmZWF0dXJlczogZGV0
ZWN0ZWQ6IFNwZWN0cmUtdjQKPiBbwqDCoMKgIDAuMDAwMDAwXSBDUFUgZmVhdHVyZXM6IGRldGVj
dGVkOiBCcmFuY2ggVGFyZ2V0IElkZW50aWZpY2F0aW9uCj4gCj4gc2hvd2luZyB0aGF0IHRoZSBQ
QUMgZmVhdHVyZXMgaGF2ZSBiZWVuIGRvd25ncmFkZWQsIHRvZ2V0aGVyIHdpdGggVkhFLAo+IGJ1
dCB0aGF0IEJUSSBpcyBzdGlsbCBkZXRlY3RlZCBhcyB2YWx1ZSA1IHdhcyBvYnZpb3VzbHkgYm9n
dXMuCj4gCj4gVGhvdWdodHM/Cj4gCj4gIMKgwqDCoMKgwqDCoMKgIE0uCj4gCj4gZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQva2VybmVsL2NwdWZlYXR1cmUuYyBiL2FyY2gvYXJtNjQva2VybmVsL2Nw
dWZlYXR1cmUuYwo+IGluZGV4IDg5NGFmNjBiOTY2OS4uMDBkOTllNTkzYjY1IDEwMDY0NAo+IC0t
LSBhL2FyY2gvYXJtNjQva2VybmVsL2NwdWZlYXR1cmUuYwo+ICsrKyBiL2FyY2gvYXJtNjQva2Vy
bmVsL2NwdWZlYXR1cmUuYwo+IEBAIC03NzQsNiArNzc0LDcgQEAgc3RhdGljIHZvaWQgX19pbml0
IGluaXRfY3B1X2Z0cl9yZWcodTMyIHN5c19yZWcsIHU2NCBuZXcpCj4gIMKgwqDCoMKgIHU2NCBz
dHJpY3RfbWFzayA9IH4weDBVTEw7Cj4gIMKgwqDCoMKgIHU2NCB1c2VyX21hc2sgPSAwOwo+ICDC
oMKgwqDCoCB1NjQgdmFsaWRfbWFzayA9IDA7Cj4gK8KgwqDCoCB1NjQgb3ZlcnJpZGVfdmFsID0g
MCwgb3ZlcnJpZGVfbWFzayA9IDA7Cj4gCj4gIMKgwqDCoMKgIGNvbnN0IHN0cnVjdCBhcm02NF9m
dHJfYml0cyAqZnRycDsKPiAgwqDCoMKgwqAgc3RydWN0IGFybTY0X2Z0cl9yZWcgKnJlZyA9IGdl
dF9hcm02NF9mdHJfcmVnKHN5c19yZWcpOwo+IEBAIC03ODEsOSArNzgyLDM1IEBAIHN0YXRpYyB2
b2lkIF9faW5pdCBpbml0X2NwdV9mdHJfcmVnKHUzMiBzeXNfcmVnLCB1NjQgbmV3KQo+ICDCoMKg
wqDCoCBpZiAoIXJlZykKPiAgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm47Cj4gCj4gK8KgwqDCoCBp
ZiAocmVnLT5vdmVycmlkZV9tYXNrICYmIHJlZy0+b3ZlcnJpZGVfdmFsKSB7Cj4gK8KgwqDCoMKg
wqDCoMKgIG92ZXJyaWRlX21hc2sgPSAqcmVnLT5vdmVycmlkZV9tYXNrOwo+ICvCoMKgwqDCoMKg
wqDCoCBvdmVycmlkZV92YWwgPSAqcmVnLT5vdmVycmlkZV92YWw7Cj4gK8KgwqDCoCB9Cj4gKwo+
ICDCoMKgwqDCoCBmb3IgKGZ0cnAgPSByZWctPmZ0cl9iaXRzOyBmdHJwLT53aWR0aDsgZnRycCsr
KSB7Cj4gIMKgwqDCoMKgwqDCoMKgwqAgdTY0IGZ0cl9tYXNrID0gYXJtNjRfZnRyX21hc2soZnRy
cCk7Cj4gIMKgwqDCoMKgwqDCoMKgwqAgczY0IGZ0cl9uZXcgPSBhcm02NF9mdHJfdmFsdWUoZnRy
cCwgbmV3KTsKPiArwqDCoMKgwqDCoMKgwqAgczY0IGZ0cl9vdnIgPSBhcm02NF9mdHJfdmFsdWUo
ZnRycCwgb3ZlcnJpZGVfdmFsKTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgIGlmICgoZnRyX21hc2sg
JiBvdmVycmlkZV9tYXNrKSA9PSBmdHJfbWFzaykgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGlmIChmdHJfb3ZyIDwgZnRyX25ldykgewoKSGVyZSB3ZSBhc3N1bWUgdGhhdCBhbGwgdGhlIGZl
YXR1cmVzIGFyZSBGVFJfTE9XRVJfU0FGRS4gV2UgY291bGQKcHJvYmFibHkgdXNlIGFybTY0X2Z0
cl9zYWZlX3ZhbHVlKGZ0cnAsIGZ0cl9uZXcsIGZ0cl9vdnIpIGhlcmUgPwpUaGF0IHdvdWxkIGNv
dmVyIHVzIGZvciBib3RoIEhJR0hFUl9TQUZFIGFuZCBMT1dFUl9TQUZFIGZlYXR1cmVzLgpIb3dl
dmVyIHRoYXQgbWF5IGJlIHJlc3RyaWN0aXZlIGZvciBGVFJfRVhBQ1QsIGFzIHdlIHRoZSBzYWZl
CnZhbHVlIHdvdWxkIGJlIHNldCB0byAiZnRyLT5zYWZlX3ZhbCIuIEkgZ3Vlc3MgdGhhdCBtYXkg
YmUgYmV0dGVyCnRoYW4gZm9yY2luZyB0byB1c2UgYW4gdW5zYWZlIHZhbHVlIGZvciB0aGUgYm9v
dCBDUFUsIHdoaWNoIGNvdWxkCmFueXdheSBjb25mbGljdCB3aXRoIHRoZSBvdGhlciBDUFVzIGFu
ZCBldmVudHVhbGx5IHRyaWdnZXIgdGhlCmZ0ciBhbHVlIHRvIGJlIHNhZmVfdmFsLgoKaS5lLAoJ
ZnRyX3ZhbCA9IGFybTY0X2Z0cl9zYWZlX3ZhbHVlKGZ0cnAsIGZ0cl9vdnIsIGZ0cl9uZXcpOwoK
ClN1enVraQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

Return-Path: <SRS0=cH1E=H6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0E0C433E0
	for <kvmarm@archiver.kernel.org>; Sun, 28 Feb 2021 11:12:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F2EE64E59
	for <kvmarm@archiver.kernel.org>; Sun, 28 Feb 2021 11:12:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F2EE64E59
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB5F54B48E;
	Sun, 28 Feb 2021 06:12:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AMBb-9xL01ku; Sun, 28 Feb 2021 06:12:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EA924B48F;
	Sun, 28 Feb 2021 06:12:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13C384B48E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Feb 2021 06:12:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3PnkUok64oxR for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Feb 2021 06:12:02 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D0CE4B486
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Feb 2021 06:12:01 -0500 (EST)
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DpLK54CSsz5XW2;
 Sun, 28 Feb 2021 19:10:17 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Sun, 28 Feb 2021 19:11:56 +0800
Subject: Re: [RFC PATCH 3/4] KVM: arm64: Install the block entry before
 unmapping the page mappings
To: <kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
 kvm <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210208112250.163568-1-wangyanan55@huawei.com>
 <20210208112250.163568-4-wangyanan55@huawei.com>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <97be4a95-de4f-96f9-1eca-142e9fee8ff6@huawei.com>
Date: Sun, 28 Feb 2021 19:11:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210208112250.163568-4-wangyanan55@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

Ck9uIDIwMjEvMi84IDE5OjIyLCBZYW5hbiBXYW5nIHdyb3RlOgo+IFdoZW4gS1ZNIG5lZWRzIHRv
IGNvYWxlc2NlIHRoZSBub3JtYWwgcGFnZSBtYXBwaW5ncyBpbnRvIGEgYmxvY2sgbWFwcGluZywK
PiB3ZSBjdXJyZW50bHkgaW52YWxpZGF0ZSB0aGUgb2xkIHRhYmxlIGVudHJ5IGZpcnN0IGZvbGxv
d2VkIGJ5IGludmFsaWRhdGlvbgo+IG9mIFRMQiwgdGhlbiB1bm1hcCB0aGUgcGFnZSBtYXBwaW5n
cywgYW5kIGluc3RhbGwgdGhlIGJsb2NrIGVudHJ5IGF0IGxhc3QuCj4KPiBJdCB3aWxsIGNvc3Qg
YSBsb25nIHRpbWUgdG8gdW5tYXAgdGhlIG51bWVyb3VzIHBhZ2UgbWFwcGluZ3MsIHdoaWNoIG1l
YW5zCj4gdGhlcmUgd2lsbCBiZSBhIGxvbmcgcGVyaW9kIHdoZW4gdGhlIHRhYmxlIGVudHJ5IGNh
biBiZSBmb3VuZCBpbnZhbGlkLgo+IElmIG90aGVyIHZDUFVzIGFjY2VzcyBhbnkgZ3Vlc3QgcGFn
ZSB3aXRoaW4gdGhlIGJsb2NrIHJhbmdlIGFuZCBmaW5kIHRoZQo+IHRhYmxlIGVudHJ5IGludmFs
aWQsIHRoZXkgd2lsbCBhbGwgZXhpdCBmcm9tIGd1ZXN0IHdpdGggYSB0cmFuc2xhdGlvbiBmYXVs
dAo+IHdoaWNoIGlzIG5vdCBuZWNlc3NhcnkuIEFuZCBLVk0gd2lsbCBtYWtlIGVmZm9ydHMgdG8g
aGFuZGxlIHRoZXNlIGZhdWx0cywKPiBlc3BlY2lhbGx5IHdoZW4gcGVyZm9ybWluZyBDTU9zIGJ5
IGJsb2NrIHJhbmdlLgo+Cj4gU28gbGV0J3MgcXVpY2tseSBpbnN0YWxsIHRoZSBibG9jayBlbnRy
eSBhdCBmaXJzdCB0byBlbnN1cmUgdW5pbnRlcnJ1cHRlZAo+IG1lbW9yeSBhY2Nlc3Mgb2YgdGhl
IG90aGVyIHZDUFVzLCBhbmQgdGhlbiB1bm1hcCB0aGUgcGFnZSBtYXBwaW5ncyBhZnRlcgo+IGlu
c3RhbGxhdGlvbi4gVGhpcyB3aWxsIHJlZHVjZSBtb3N0IG9mIHRoZSB0aW1lIHdoZW4gdGhlIHRh
YmxlIGVudHJ5IGlzCj4gaW52YWxpZCwgYW5kIGF2b2lkIG1vc3Qgb2YgdGhlIHVubmVjZXNzYXJ5
IHRyYW5zbGF0aW9uIGZhdWx0cy4KQlRXOiBIZXJlIHNob3cgdGhlIGJlbmVmaXQgb2YgdGhpcyBw
YXRjaCBhbG9uZSBmb3IgcmVmZXJlbmNlICh0ZXN0aW5nIApiYXNlZCBvbiBwYXRjaDEpIC4KVGhp
cyBwYXRjaCBhaW1zIHRvIHNwZWVkIHVwIHRoZSByZWNvbnN0cnVjdGlvbiBvZiBibG9jayAKbWFw
cGluZ3MoZXNwZWNpYWxseSBmb3IgMUcgYmxvY2tzKQphZnRlciB0aGV5IGhhdmUgYmVlbiBzcGxp
dCwgYW5kIHRoZSBmb2xsb3dpbmcgdGVzdCByZXN1bHRzIHJlcHJlc2VudCB0aGUgCnNpZ25pZmlj
YW50IGNoYW5nZS4KU2VsZnRlc3Q6IApodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjEw
MjA4MDkwODQxLjMzMzcyNC0xLXdhbmd5YW5hbjU1QGh1YXdlaS5jb20vIAoKCi0tLQoKaGFyZHdh
cmUgcGxhdGZvcm06IEhpU2lsaWNvbiBLdW5wZW5nOTIwIFNlcnZlcihGV0Igbm90IHN1cHBvcnRl
ZCkKaG9zdCBrZXJuZWw6IExpbnV4IG1haW5saW5lIHY1LjExLXJjNiAod2l0aCBzZXJpZXMgb2Yg
Cmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMTAxMTQxMjEzNTAuMTIzNjg0LTQtd2FuZ3lh
bmFuNTVAaHVhd2VpLmNvbSAKYXBwbGllZCkKCm11bHRpcGxlIHZjcHVzIGNvbmN1cnJlbnRseSBh
Y2Nlc3MgMjBHIG1lbW9yeS4KZXhlY3V0aW9uIHRpbWUgb2YgS1ZNIHJlY29uc3RpdHV0aW5nIHRo
ZSBibG9jayBtYXBwaW5ncyBhZnRlciBkaXJ0eSAKbG9nZ2luZy4KCmNtZGxpbmU6IC4va3ZtX3Bh
Z2VfdGFibGVfdGVzdCAtbSA0IC10IDIgLWcgMUcgLXMgMjBHIC12IDIwCiDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAoMjAgdmNwdXMsIDIwRyBtZW1vcnksIGJsb2NrIG1hcHBpbmdzKEhVR0VUTEIgMUcp
KQpCZWZvcmUgcGF0Y2g6IEtWTV9BREpVU1RfTUFQUElOR1M6IDIuODgxcyAyLjg4M3MgMi44ODVz
IDIuODc5cyAyLjg4MnMKQWZ0ZXLCoCBwYXRjaDogS1ZNX0FESlVTVF9NQVBQSU5HUzogMC4zMTBz
IDAuMzAxcyAwLjMxMnMgMC4yOTlzIDAuMzA2c8KgIAoqYXZlcmFnZSA4OSUgaW1wcm92ZW1lbnQq
CgpjbWRsaW5lOiAuL2t2bV9wYWdlX3RhYmxlX3Rlc3QgLW0gNCAtdCAyIC1nIDFHIC1zIDIwRyAt
diA0MAogwqDCoMKgwqDCoMKgwqDCoMKgwqAgKDQwIHZjcHVzLCAyMEcgbWVtb3J5LCBibG9jayBt
YXBwaW5ncyhIVUdFVExCIDFHKSkKQmVmb3JlIHBhdGNoOiBLVk1fQURKVVNUX01BUFBJTkdTOiAy
Ljk1NHMgMi45NTVzIDIuOTQ5cyAyLjk1MXMgMi45NTNzCkFmdGVywqAgcGF0Y2g6IEtWTV9BREpV
U1RfTUFQUElOR1M6IDAuMzgxcyAwLjM2NnMgMC4zODFzIDAuMzgwcyAwLjM3OHPCoCAKKmF2ZXJh
Z2UgODclIGltcHJvdmVtZW50KgoKY21kbGluZTogLi9rdm1fcGFnZV90YWJsZV90ZXN0IC1tIDQg
LXQgMiAtZyAxRyAtcyAyMEcgLXYgNjAKIMKgwqDCoMKgwqDCoMKgwqDCoMKgICg2MCB2Y3B1cywg
MjBHIG1lbW9yeSwgYmxvY2sgbWFwcGluZ3MoSFVHRVRMQiAxRykpCkJlZm9yZSBwYXRjaDogS1ZN
X0FESlVTVF9NQVBQSU5HUzogMy4xMThzIDMuMTEycyAzLjEzMHMgMy4xMjhzIDMuMTE5cwpBZnRl
csKgIHBhdGNoOiBLVk1fQURKVVNUX01BUFBJTkdTOiAwLjUyNHMgMC41MzRzIDAuNTM2cyAwLjUy
NXMgMC41MzlzwqAgCiphdmVyYWdlIDgzJSBpbXByb3ZlbWVudCoKCi0tLQoKVGhhbmtzLAoKWWFu
YW4KPgo+IFNpZ25lZC1vZmYtYnk6IFlhbmFuIFdhbmcgPHdhbmd5YW5hbjU1QGh1YXdlaS5jb20+
Cj4gLS0tCj4gICBhcmNoL2FybTY0L2t2bS9oeXAvcGd0YWJsZS5jIHwgMjYgKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxNCBk
ZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oeXAvcGd0YWJsZS5j
IGIvYXJjaC9hcm02NC9rdm0vaHlwL3BndGFibGUuYwo+IGluZGV4IDc4YTU2MDQ0NmY4MC4uMzA4
YzM2YjljZDIxIDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cC9wZ3RhYmxlLmMKPiAr
KysgYi9hcmNoL2FybTY0L2t2bS9oeXAvcGd0YWJsZS5jCj4gQEAgLTQzNCw2ICs0MzQsNyBAQCBz
dHJ1Y3Qgc3RhZ2UyX21hcF9kYXRhIHsKPiAgIAlrdm1fcHRlX3QJCQlhdHRyOwo+ICAgCj4gICAJ
a3ZtX3B0ZV90CQkJKmFuY2hvcjsKPiArCWt2bV9wdGVfdAkJCSpmb2xsb3c7Cj4gICAKPiAgIAlz
dHJ1Y3Qga3ZtX3MyX21tdQkJKm1tdTsKPiAgIAlzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUJ
Km1lbWNhY2hlOwo+IEBAIC01NTMsMTUgKzU1NCwxNCBAQCBzdGF0aWMgaW50IHN0YWdlMl9tYXBf
d2Fsa190YWJsZV9wcmUodTY0IGFkZHIsIHU2NCBlbmQsIHUzMiBsZXZlbCwKPiAgIAlpZiAoIWt2
bV9ibG9ja19tYXBwaW5nX3N1cHBvcnRlZChhZGRyLCBlbmQsIGRhdGEtPnBoeXMsIGxldmVsKSkK
PiAgIAkJcmV0dXJuIDA7Cj4gICAKPiAtCWt2bV9zZXRfaW52YWxpZF9wdGUocHRlcCk7Cj4gLQo+
ICAgCS8qCj4gLQkgKiBJbnZhbGlkYXRlIHRoZSB3aG9sZSBzdGFnZS0yLCBhcyB3ZSBtYXkgaGF2
ZSBudW1lcm91cyBsZWFmCj4gLQkgKiBlbnRyaWVzIGJlbG93IHVzIHdoaWNoIHdvdWxkIG90aGVy
d2lzZSBuZWVkIGludmFsaWRhdGluZwo+IC0JICogaW5kaXZpZHVhbGx5Lgo+ICsJICogSWYgd2Ug
bmVlZCB0byBjb2FsZXNjZSBleGlzdGluZyB0YWJsZSBlbnRyaWVzIGludG8gYSBibG9jayBoZXJl
LAo+ICsJICogdGhlbiBpbnN0YWxsIHRoZSBibG9jayBlbnRyeSBmaXJzdCBhbmQgdGhlIHN1Yi1s
ZXZlbCBwYWdlIG1hcHBpbmdzCj4gKwkgKiB3aWxsIGJlIHVubWFwcGVkIGxhdGVyLgo+ICAgCSAq
Lwo+IC0Ja3ZtX2NhbGxfaHlwKF9fa3ZtX3RsYl9mbHVzaF92bWlkLCBkYXRhLT5tbXUpOwo+ICAg
CWRhdGEtPmFuY2hvciA9IHB0ZXA7Cj4gKwlkYXRhLT5mb2xsb3cgPSBrdm1fcHRlX2ZvbGxvdygq
cHRlcCk7Cj4gKwlzdGFnZTJfY29hbGVzY2VfdGFibGVzX2ludG9fYmxvY2soYWRkciwgbGV2ZWws
IHB0ZXAsIGRhdGEpOwo+ICAgCXJldHVybiAwOwo+ICAgfQo+ICAgCj4gQEAgLTYxNCwyMCArNjE0
LDE4IEBAIHN0YXRpYyBpbnQgc3RhZ2UyX21hcF93YWxrX3RhYmxlX3Bvc3QodTY0IGFkZHIsIHU2
NCBlbmQsIHUzMiBsZXZlbCwKPiAgIAkJCQkgICAgICBrdm1fcHRlX3QgKnB0ZXAsCj4gICAJCQkJ
ICAgICAgc3RydWN0IHN0YWdlMl9tYXBfZGF0YSAqZGF0YSkKPiAgIHsKPiAtCWludCByZXQgPSAw
Owo+IC0KPiAgIAlpZiAoIWRhdGEtPmFuY2hvcikKPiAgIAkJcmV0dXJuIDA7Cj4gICAKPiAtCWZy
ZWVfcGFnZSgodW5zaWduZWQgbG9uZylrdm1fcHRlX2ZvbGxvdygqcHRlcCkpOwo+IC0JcHV0X3Bh
Z2UodmlydF90b19wYWdlKHB0ZXApKTsKPiAtCj4gLQlpZiAoZGF0YS0+YW5jaG9yID09IHB0ZXAp
IHsKPiArCWlmIChkYXRhLT5hbmNob3IgIT0gcHRlcCkgewo+ICsJCWZyZWVfcGFnZSgodW5zaWdu
ZWQgbG9uZylrdm1fcHRlX2ZvbGxvdygqcHRlcCkpOwo+ICsJCXB1dF9wYWdlKHZpcnRfdG9fcGFn
ZShwdGVwKSk7Cj4gKwl9IGVsc2Ugewo+ICsJCWZyZWVfcGFnZSgodW5zaWduZWQgbG9uZylkYXRh
LT5mb2xsb3cpOwo+ICAgCQlkYXRhLT5hbmNob3IgPSBOVUxMOwo+IC0JCXJldCA9IHN0YWdlMl9t
YXBfd2Fsa19sZWFmKGFkZHIsIGVuZCwgbGV2ZWwsIHB0ZXAsIGRhdGEpOwo+ICAgCX0KPiAgIAo+
IC0JcmV0dXJuIHJldDsKPiArCXJldHVybiAwOwo+ICAgfQo+ICAgCj4gICAvKgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

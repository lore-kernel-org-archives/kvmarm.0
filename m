Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C2AC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 12:32:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0AD2D64FE5
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 12:32:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AD2D64FE5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DD964B615;
	Thu, 11 Mar 2021 07:32:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ob7cjJWglORQ; Thu, 11 Mar 2021 07:32:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22A3A4B673;
	Thu, 11 Mar 2021 07:32:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43B6A4B579
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 07:32:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3bOe+za5vsjp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 07:32:02 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 488BA4B578
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 07:32:02 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Dx7Z970zlz7p3Q;
 Thu, 11 Mar 2021 20:30:09 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 20:31:49 +0800
Subject: Re: [PATCH v3 2/4] KVM: arm64: GICv4.1: Try to save hw pending state
 in save_pending_tables
To: Marc Zyngier <maz@kernel.org>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-3-lushenming@huawei.com> <87v99yf450.wl-maz@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <3b47598f-0795-a165-1a64-abe02258b306@huawei.com>
Date: Thu, 11 Mar 2021 20:31:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87v99yf450.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMS8zLzExIDE3OjA5LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gV2VkLCAyNyBKYW4g
MjAyMSAxMjoxMzozNSArMDAwMCwKPiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29t
PiB3cm90ZToKPj4KPj4gQWZ0ZXIgcGF1c2luZyBhbGwgdkNQVXMgYW5kIGRldmljZXMgY2FwYWJs
ZSBvZiBpbnRlcnJ1cHRpbmcsIGluIG9yZGVyCj4+IHRvIHNhdmUgdGhlIGluZm9ybWF0aW9uIG9m
IGFsbCBpbnRlcnJ1cHRzLCBiZXNpZGVzIGZsdXNoaW5nIHRoZSBwZW5kaW5nCj4+IHN0YXRlcyBp
biBrdm3igJlzIHZnaWMsIHdlIGFsc28gdHJ5IHRvIGZsdXNoIHRoZSBzdGF0ZXMgb2YgVkxQSXMg
aW4gdGhlCj4+IHZpcnR1YWwgcGVuZGluZyB0YWJsZXMgaW50byBndWVzdCBSQU0sIGJ1dCB3ZSBu
ZWVkIHRvIGhhdmUgR0lDdjQuMSBhbmQKPj4gc2FmZWx5IHVubWFwIHRoZSB2UEVzIGZpcnN0Lgo+
Pgo+PiBBcyBmb3IgdGhlIHNhdmluZyBvZiBWU0dJcywgd2hpY2ggbmVlZHMgdGhlIHZQRXMgdG8g
YmUgbWFwcGVkIGFuZCBtaWdodAo+PiBjb25mbGljdCB3aXRoIHRoZSBzYXZpbmcgb2YgVkxQSXMs
IGJ1dCBzaW5jZSB3ZSB3aWxsIG1hcCB0aGUgdlBFcyBiYWNrCj4+IGF0IHRoZSBlbmQgb2Ygc2F2
ZV9wZW5kaW5nX3RhYmxlcyBhbmQgYm90aCBzYXZpbmdzIHJlcXVpcmUgdGhlIGt2bS0+bG9jawo+
PiB0byBiZSBoZWxkIChvbmx5IGhhcHBlbiBzZXJpYWxseSksIGl0IHdpbGwgd29yayBmaW5lLgo+
Pgo+PiBTaWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+
PiAtLS0KPj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jIHwgNjEgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0KPj4gIDEgZmlsZSBjaGFuZ2VkLCA1NSBpbnNlcnRpb25z
KCspLCA2IGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXYzLmMgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwo+PiBpbmRleCA1Mjkx
NWIzNDIzNTEuLjA2YjExNjJiN2EwYSAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXYzLmMKPj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMKPj4gQEAg
LTEsNiArMSw4IEBACj4+ICAvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5
Cj4+ICAKPj4gICNpbmNsdWRlIDxsaW51eC9pcnFjaGlwL2FybS1naWMtdjMuaD4KPj4gKyNpbmNs
dWRlIDxsaW51eC9pcnEuaD4KPj4gKyNpbmNsdWRlIDxsaW51eC9pcnFkb21haW4uaD4KPj4gICNp
bmNsdWRlIDxsaW51eC9rdm0uaD4KPj4gICNpbmNsdWRlIDxsaW51eC9rdm1faG9zdC5oPgo+PiAg
I2luY2x1ZGUgPGt2bS9hcm1fdmdpYy5oPgo+PiBAQCAtMzU2LDYgKzM1OCwzMiBAQCBpbnQgdmdp
Y192M19scGlfc3luY19wZW5kaW5nX3N0YXR1cyhzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCB2Z2lj
X2lycSAqaXJxKQo+PiAgCXJldHVybiAwOwo+PiAgfQo+PiAgCj4+ICsvKgo+PiArICogVGhlIGRl
YWN0aXZhdGlvbiBvZiB0aGUgZG9vcmJlbGwgaW50ZXJydXB0IHdpbGwgdHJpZ2dlciB0aGUKPj4g
KyAqIHVubWFwcGluZyBvZiB0aGUgYXNzb2NpYXRlZCB2UEUuCj4+ICsgKi8KPj4gK3N0YXRpYyB2
b2lkIHVubWFwX2FsbF92cGVzKHN0cnVjdCB2Z2ljX2Rpc3QgKmRpc3QpCj4+ICt7Cj4+ICsJc3Ry
dWN0IGlycV9kZXNjICpkZXNjOwo+PiArCWludCBpOwo+PiArCj4+ICsJZm9yIChpID0gMDsgaSA8
IGRpc3QtPml0c192bS5ucl92cGVzOyBpKyspIHsKPj4gKwkJZGVzYyA9IGlycV90b19kZXNjKGRp
c3QtPml0c192bS52cGVzW2ldLT5pcnEpOwo+PiArCQlpcnFfZG9tYWluX2RlYWN0aXZhdGVfaXJx
KGlycV9kZXNjX2dldF9pcnFfZGF0YShkZXNjKSk7Cj4+ICsJfQo+PiArfQo+PiArCj4+ICtzdGF0
aWMgdm9pZCBtYXBfYWxsX3ZwZXMoc3RydWN0IHZnaWNfZGlzdCAqZGlzdCkKPj4gK3sKPj4gKwlz
dHJ1Y3QgaXJxX2Rlc2MgKmRlc2M7Cj4+ICsJaW50IGk7Cj4+ICsKPj4gKwlmb3IgKGkgPSAwOyBp
IDwgZGlzdC0+aXRzX3ZtLm5yX3ZwZXM7IGkrKykgewo+PiArCQlkZXNjID0gaXJxX3RvX2Rlc2Mo
ZGlzdC0+aXRzX3ZtLnZwZXNbaV0tPmlycSk7Cj4+ICsJCWlycV9kb21haW5fYWN0aXZhdGVfaXJx
KGlycV9kZXNjX2dldF9pcnFfZGF0YShkZXNjKSwgZmFsc2UpOwo+PiArCX0KPj4gK30KPj4gKwo+
PiAgLyoqCj4+ICAgKiB2Z2ljX3YzX3NhdmVfcGVuZGluZ190YWJsZXMgLSBTYXZlIHRoZSBwZW5k
aW5nIHRhYmxlcyBpbnRvIGd1ZXN0IFJBTQo+PiAgICoga3ZtIGxvY2sgYW5kIGFsbCB2Y3B1IGxv
Y2sgbXVzdCBiZSBoZWxkCj4+IEBAIC0zNjUsMTQgKzM5MywyNiBAQCBpbnQgdmdpY192M19zYXZl
X3BlbmRpbmdfdGFibGVzKHN0cnVjdCBrdm0gKmt2bSkKPj4gIAlzdHJ1Y3QgdmdpY19kaXN0ICpk
aXN0ID0gJmt2bS0+YXJjaC52Z2ljOwo+PiAgCXN0cnVjdCB2Z2ljX2lycSAqaXJxOwo+PiAgCWdw
YV90IGxhc3RfcHRyID0gfihncGFfdCkwOwo+PiAtCWludCByZXQ7Cj4+ICsJYm9vbCB2bHBpX2F2
YWlsID0gZmFsc2U7Cj4+ICsJaW50IHJldCA9IDA7Cj4+ICAJdTggdmFsOwo+PiAgCj4+ICsJLyoK
Pj4gKwkgKiBBcyBhIHByZXBhcmF0aW9uIGZvciBnZXR0aW5nIGFueSBWTFBJIHN0YXRlcy4KPj4g
KwkgKiBUaGUgdmdpYyBpbml0aWFsaXplZCBjaGVjayBlbnN1cmVzIHRoYXQgdGhlIGFsbG9jYXRp
b24gYW5kCj4+ICsJICogZW5hYmxpbmcgb2YgdGhlIGRvb3JiZWxscyBoYXZlIGFscmVhZHkgYmVl
biBkb25lLgo+PiArCSAqLwo+PiArCWlmIChrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0
XzEgJiYgIVdBUk5fT04oIXZnaWNfaW5pdGlhbGl6ZWQoa3ZtKSkpIHsKPiAKPiBTaG91bGQgd2Ug
YmFpbCBvdXQgaWYgd2UgZXZlciBzcG90ICF2Z2ljX2luaXRpYWxpemVkKCk/IEluIGdlbmVyYWws
IEkKPiBmaW5kIHRoZSBkb3VibGUgbmVnYXRpb24gaG9ycmlibGUgdG8gcmVhZCkuCgpPaywgSSB3
aWxsIGNoYW5nZSBpdC4KCj4gCj4+ICsJCXVubWFwX2FsbF92cGVzKGRpc3QpOwo+PiArCQl2bHBp
X2F2YWlsID0gdHJ1ZTsKPj4gKwl9Cj4+ICsKPj4gIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGlycSwg
JmRpc3QtPmxwaV9saXN0X2hlYWQsIGxwaV9saXN0KSB7Cj4+ICAJCWludCBieXRlX29mZnNldCwg
Yml0X25yOwo+PiAgCQlzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHU7Cj4+ICAJCWdwYV90IHBlbmRiYXNl
LCBwdHI7Cj4+ICAJCWJvb2wgc3RvcmVkOwo+PiArCQlib29sIGlzX3BlbmRpbmcgPSBpcnEtPnBl
bmRpbmdfbGF0Y2g7Cj4+ICAKPj4gIAkJdmNwdSA9IGlycS0+dGFyZ2V0X3ZjcHU7Cj4+ICAJCWlm
ICghdmNwdSkKPj4gQEAgLTM4NywyNCArNDI3LDMzIEBAIGludCB2Z2ljX3YzX3NhdmVfcGVuZGlu
Z190YWJsZXMoc3RydWN0IGt2bSAqa3ZtKQo+PiAgCQlpZiAocHRyICE9IGxhc3RfcHRyKSB7Cj4+
ICAJCQlyZXQgPSBrdm1fcmVhZF9ndWVzdF9sb2NrKGt2bSwgcHRyLCAmdmFsLCAxKTsKPj4gIAkJ
CWlmIChyZXQpCj4+IC0JCQkJcmV0dXJuIHJldDsKPj4gKwkJCQlnb3RvIG91dDsKPj4gIAkJCWxh
c3RfcHRyID0gcHRyOwo+PiAgCQl9Cj4+ICAKPj4gIAkJc3RvcmVkID0gdmFsICYgKDFVIDw8IGJp
dF9ucik7Cj4+IC0JCWlmIChzdG9yZWQgPT0gaXJxLT5wZW5kaW5nX2xhdGNoKQo+PiArCj4+ICsJ
CWlmIChpcnEtPmh3ICYmIHZscGlfYXZhaWwpCj4+ICsJCQl2Z2ljX3Y0X2dldF92bHBpX3N0YXRl
KGlycSwgJmlzX3BlbmRpbmcpOwo+IAo+IEtlZXAgdGhlICdpc19wZW5kaW5nID0gaXJxLT5wZW5k
aW5nX2xhdGNoOycgc3RhdGVtZW50IGNsb3NlIHRvIHRoZSBWUFQKPiByZWFkLCBzaW5jZSB0aGV5
IHJlcHJlc2VudCB0aGUgc2FtZSBzdGF0ZS4KCk9rLCBtYWtlIHNlbnNlLgoKPiAKPj4gKwo+PiAr
CQlpZiAoc3RvcmVkID09IGlzX3BlbmRpbmcpCj4+ICAJCQljb250aW51ZTsKPj4gIAo+PiAtCQlp
ZiAoaXJxLT5wZW5kaW5nX2xhdGNoKQo+PiArCQlpZiAoaXNfcGVuZGluZykKPj4gIAkJCXZhbCB8
PSAxIDw8IGJpdF9ucjsKPj4gIAkJZWxzZQo+PiAgCQkJdmFsICY9IH4oMSA8PCBiaXRfbnIpOwo+
PiAgCj4+ICAJCXJldCA9IGt2bV93cml0ZV9ndWVzdF9sb2NrKGt2bSwgcHRyLCAmdmFsLCAxKTsK
Pj4gIAkJaWYgKHJldCkKPj4gLQkJCXJldHVybiByZXQ7Cj4+ICsJCQlnb3RvIG91dDsKPj4gIAl9
Cj4+IC0JcmV0dXJuIDA7Cj4+ICsKPj4gK291dDoKPj4gKwlpZiAodmxwaV9hdmFpbCkKPj4gKwkJ
bWFwX2FsbF92cGVzKGRpc3QpOwo+IAo+IEkgaGF2ZSBhc2tlZCB0aGF0IHF1ZXN0aW9uIGluIHRo
ZSBwYXN0OiBpcyBpdCBhY3R1YWxseSBzYWZlIHRvIHJlbWFwCj4gdGhlIHZQRXMgYW5kIGV4cGVj
dCB0aGVtIHRvIGJlIHJ1bm5hYmxlCgpJbiBteSBvcGluaW9uLCBsb2dpY2FsbHkgaXQgY2FuIHdv
cmssIGJ1dCB0aGVyZSBtaWdodCBiZSBwcm9ibGVtcyBsaWtlIHRoZQpvbmUgYmVsb3cgdGhhdCBJ
IGRpZG4ndCBub3RpY2UuLi4KCj4gCj4gQWxzbywgdGhlIGN1cnJlbnQgY29kZSBhc3N1bWVzIHRo
YXQgVk1BUFAuUFRaIGNhbiBiZSBhZHZlcnRpc2VkIGlmIGEKPiBWUFQgaXMgbWFwcGVkIGZvciB0
aGUgZmlyc3QgdGltZS4gQ2xlYXJseSwgaXQgaXMgdW5saWtlbHkgdGhhdCB0aGUgVlBUCj4gd2ls
bCBiZSBvbmx5IHBvcHVsYXRlZCB3aXRoIDBzLCBzbyB5b3UnbGwgZW5kIHVwIHdpdGggc3RhdGUg
Y29ycnVwdGlvbgo+IG9uIHRoZSBmaXJzdCByZW1hcC4KCk9oLCB0aGFua3MgZm9yIHBvaW50aW5n
IGl0IG91dC4KQW5kIGlmIHdlIGFsd2F5cyBzaWduYWwgUFRaIHdoZW4gYWxsb2MgPSAxLCBkb2Vz
IGl0IG1lYW4gdGhhdCB3ZSBjYW4ndCByZW1hcCB0aGUKdlBFIHdoZW4gdGhlIFZQVCBpcyBub3Qg
ZW1wdHksIHRodXMgdGhlcmUgaXMgbm8gY2hhbmNlIHRvIGdldCB0aGUgVkxQSSBzdGF0ZT8KQ291
bGQgd2UganVzdCBhc3N1bWUgdGhhdCB0aGUgVlBUIGlzIG5vdCBlbXB0eSB3aGVuIGZpcnN0IG1h
cHBpbmcgdGhlIHZQRT8KClRoYW5rcywKU2hlbm1pbmcKCj4gCj4gVGhhbmtzLAo+IAo+IAlNLgo+
IApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

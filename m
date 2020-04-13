Return-Path: <SRS0=hjn/=55=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4BDC2BBC7
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 09:10:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D87D20731
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 09:10:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D87D20731
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E994B1D3;
	Mon, 13 Apr 2020 05:10:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AbkI9YAxMRJO; Mon, 13 Apr 2020 05:09:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 738B74B1DA;
	Mon, 13 Apr 2020 05:09:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C53454B15A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 05:07:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mgyScHBdqkls for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2020 05:07:37 -0400 (EDT)
Received: from out30-131.freemail.mail.aliyun.com
 (out30-131.freemail.mail.aliyun.com [115.124.30.131])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFEDA4B156
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 05:07:36 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R671e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01355;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=19; SR=0;
 TI=SMTPD_---0TvMk-zp_1586768848; 
Received: from 30.27.118.45(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0TvMk-zp_1586768848) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 13 Apr 2020 17:07:29 +0800
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To: Marc Zyngier <maz@kernel.org>
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
 <17097df45c7fe76ee3c09ac180b844d2@kernel.org>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <a06c5435-8790-a970-519b-92ea4ee70f7d@linux.alibaba.com>
Date: Mon, 13 Apr 2020 17:07:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <17097df45c7fe76ee3c09ac180b844d2@kernel.org>
X-Mailman-Approved-At: Mon, 13 Apr 2020 05:09:56 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
 kvmarm@lists.cs.columbia.edu, mingo@redhat.com, bp@alien8.de,
 linux-arm-kernel@lists.infradead.org, hpa@zytor.com, pbonzini@redhat.com,
 vkuznets@redhat.com, tglx@linutronix.de, jmattson@google.com
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

CgpPbiAyMDIwLzQvMTMgMTY6NTYsIE1hcmMgWnluZ2llciB3cm90ZToKPiBUaWFuamlhLAo+IAo+
IE9uIDIwMjAtMDQtMTMgMDQ6NDUsIFRpYW5qaWEgWmhhbmcgd3JvdGU6Cj4+IGt2bV9hcmNoX3Zj
cHVfaW9jdGxfcnVuKCkgaXMgb25seSBjYWxsZWQgaW4gdGhlIGZpbGUga3ZtX21haW4uYywKPj4g
d2hlcmUgdmNwdS0+cnVuIGlzIHRoZSBrdm1fcnVuIHBhcmFtZXRlciwgc28gaXQgaGFzIGJlZW4g
cmVwbGFjZWQuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFRpYW5qaWEgWmhhbmcgPHRpYW5qaWEuemhh
bmdAbGludXguYWxpYmFiYS5jb20+Cj4+IC0tLQo+PiDCoGFyY2gveDg2L2t2bS94ODYuYyB8IDgg
KysrKy0tLS0KPj4gwqB2aXJ0L2t2bS9hcm0vYXJtLmMgfCAyICstCj4+IMKgMiBmaWxlcyBjaGFu
Z2VkLCA1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMKPj4gaW5kZXggM2JmMmVjYWZk
MDI3Li43MGUzZjRhYmJkNGQgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYwo+PiAr
KysgYi9hcmNoL3g4Ni9rdm0veDg2LmMKPj4gQEAgLTg3MjYsMTggKzg3MjYsMTggQEAgaW50IGt2
bV9hcmNoX3ZjcHVfaW9jdGxfcnVuKHN0cnVjdCBrdm1fdmNwdQo+PiAqdmNwdSwgc3RydWN0IGt2
bV9ydW4gKmt2bV9ydW4pCj4+IMKgwqDCoMKgwqDCoMKgwqAgciA9IC1FQUdBSU47Cj4+IMKgwqDC
oMKgwqDCoMKgwqAgaWYgKHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKSB7Cj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCByID0gLUVJTlRSOwo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2Y3B1
LT5ydW4tPmV4aXRfcmVhc29uID0gS1ZNX0VYSVRfSU5UUjsKPj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAga3ZtX3J1bi0+ZXhpdF9yZWFzb24gPSBLVk1fRVhJVF9JTlRSOwo+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKyt2Y3B1LT5zdGF0LnNpZ25hbF9leGl0czsKPj4gwqDCoMKgwqDCoMKg
wqDCoCB9Cj4+IMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+IMKgwqDCoMKgIH0KPj4KPj4g
LcKgwqDCoCBpZiAodmNwdS0+cnVuLT5rdm1fdmFsaWRfcmVncyAmIH5LVk1fU1lOQ19YODZfVkFM
SURfRklFTERTKSB7Cj4+ICvCoMKgwqAgaWYgKGt2bV9ydW4tPmt2bV92YWxpZF9yZWdzICYgfktW
TV9TWU5DX1g4Nl9WQUxJRF9GSUVMRFMpIHsKPj4gwqDCoMKgwqDCoMKgwqDCoCByID0gLUVJTlZB
TDsKPj4gwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4gwqDCoMKgwqAgfQo+Pgo+PiAtwqDC
oMKgIGlmICh2Y3B1LT5ydW4tPmt2bV9kaXJ0eV9yZWdzKSB7Cj4+ICvCoMKgwqAgaWYgKGt2bV9y
dW4tPmt2bV9kaXJ0eV9yZWdzKSB7Cj4+IMKgwqDCoMKgwqDCoMKgwqAgciA9IHN5bmNfcmVncyh2
Y3B1KTsKPj4gwqDCoMKgwqDCoMKgwqDCoCBpZiAociAhPSAwKQo+PiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZ290byBvdXQ7Cj4+IEBAIC04NzY3LDcgKzg3NjcsNyBAQCBpbnQga3ZtX2FyY2hf
dmNwdV9pb2N0bF9ydW4oc3RydWN0IGt2bV92Y3B1Cj4+ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3J1biAq
a3ZtX3J1bikKPj4KPj4gwqBvdXQ6Cj4+IMKgwqDCoMKgIGt2bV9wdXRfZ3Vlc3RfZnB1KHZjcHUp
Owo+PiAtwqDCoMKgIGlmICh2Y3B1LT5ydW4tPmt2bV92YWxpZF9yZWdzKQo+PiArwqDCoMKgIGlm
IChrdm1fcnVuLT5rdm1fdmFsaWRfcmVncykKPj4gwqDCoMKgwqDCoMKgwqDCoCBzdG9yZV9yZWdz
KHZjcHUpOwo+PiDCoMKgwqDCoCBwb3N0X2t2bV9ydW5fc2F2ZSh2Y3B1KTsKPj4gwqDCoMKgwqAg
a3ZtX3NpZ3NldF9kZWFjdGl2YXRlKHZjcHUpOwo+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJt
L2FybS5jIGIvdmlydC9rdm0vYXJtL2FybS5jCj4+IGluZGV4IDQ4ZDBlYzQ0YWQ3Ny4uYWI5ZDc5
NjZhNGM4IDEwMDY0NAo+PiAtLS0gYS92aXJ0L2t2bS9hcm0vYXJtLmMKPj4gKysrIGIvdmlydC9r
dm0vYXJtL2FybS5jCj4+IEBAIC02NTksNyArNjU5LDcgQEAgaW50IGt2bV9hcmNoX3ZjcHVfaW9j
dGxfcnVuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gc3RydWN0IGt2bV9ydW4gKnJ1bikKPj4g
wqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Owo+Pgo+PiDCoMKgwqDCoCBpZiAocnVuLT5leGl0
X3JlYXNvbiA9PSBLVk1fRVhJVF9NTUlPKSB7Cj4+IC3CoMKgwqDCoMKgwqDCoCByZXQgPSBrdm1f
aGFuZGxlX21taW9fcmV0dXJuKHZjcHUsIHZjcHUtPnJ1bik7Cj4+ICvCoMKgwqDCoMKgwqDCoCBy
ZXQgPSBrdm1faGFuZGxlX21taW9fcmV0dXJuKHZjcHUsIHJ1bik7Cj4+IMKgwqDCoMKgwqDCoMKg
wqAgaWYgKHJldCkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+IMKg
wqDCoMKgIH0KPiAKPiBEbyB5b3UgaGF2ZSBhbnkgbnVtYmVyIHN1cHBvcnRpbmcgdGhlIGlkZWEg
dGhhdCB5b3UgYXJlIG9wdGltaXppbmcgYW55dGhpbmcKPiBoZXJlPyBQZXJmb3JtYW5jZSwgY29k
ZSBzaXplLCByZWdpc3RlciBwcmVzc3VyZSBvciBhbnkgb3RoZXIgcmVsZXZhbnQgCj4gbWV0cmlj
Pwo+IAo+IFRoYW5rcywKPiAKPiAgwqDCoMKgwqDCoMKgwqAgTS4KClRoaXMgaXMgb25seSBhIHNp
bXBsaWZpZWQgaW1wbGVtZW50YXRpb24gb2YgdGhlIGZ1bmN0aW9uLCB0aGUgaW1wYWN0IG9uIApw
ZXJmb3JtYW5jZSBhbmQgcmVnaXN0ZXIgcHJlc3N1cmUgY2FuIGJlIGlnbm9yZWQuCgpUaGFua3Ms
ClRpYW5qaWEKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

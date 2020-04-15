Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA8EC2BB85
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DAD5120775
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RiCeefqe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAD5120775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9259E4B241;
	Wed, 15 Apr 2020 05:23:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oLszwmyJhrmc; Wed, 15 Apr 2020 05:23:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 630984B228;
	Wed, 15 Apr 2020 05:23:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C58CC4B17F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 04:30:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tDVSHi6e6WnQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 04:30:12 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC52B4B176
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 04:30:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586939412;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JM3vltnSQeQHbyK1dZxQXkvEx4sl9ZGuP7RHLsjmkZo=;
 b=RiCeefqeN0xM0QLxOuea3ScEkNkiZAu1zEUteu0DXZiRRKYUjhjjEkpvxqe0cp3yTJOphM
 tr5F//BC+9UCetg5/1c53fD3whPU9uhvV4qT7MnLEIRcNVnLNP9kQoGh0USgRHFkhmEkbc
 uGH99DSgrYqPnwLi+X7qnbvSqjeMJNs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-ycu5H-vdOeyEa6RrTjZ5DA-1; Wed, 15 Apr 2020 04:30:10 -0400
X-MC-Unique: ycu5H-vdOeyEa6RrTjZ5DA-1
Received: by mail-wm1-f69.google.com with SMTP id c196so2751291wmd.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 01:30:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=bLmrOkcXJQ/8f3TsPjBB59Qp6PFUF6WHach7rOTidPU=;
 b=r6uRrFXRdicpOfXX579P90sbcOnPIwoZHTipFNMQmTDr+XD44HaQaBBk8u9fX6kna6
 kSHk/02qXd0nR8rmnX2m6Wv39PsJLSfNfN60lefU2jimfzFqqwmusNSG2xqLfctoKx8P
 vK0yx7y5IXcl05XGNZwZkP3OsI/5lhNwjU7WkP0SAv1GMB/OkqBiteeHZm5ZWeZqKJLq
 zDFEk4lRujhHxsUEOs+MA5+dugEEfe33Ive2VVaB55sITl1z9T6r9ol+Bcpr7xr7Mu8c
 089rQ8DVutMBTqA+8OhMyowKO1nCPV7OIh556mPYOsw/KwOrnpHWJg5aUE5unLLr7VVu
 +n1g==
X-Gm-Message-State: AGi0PubYHIaXukau1Ive+ID4hENzA63d3Tmi/QqzJvvTJHeUNs3Ww880
 QjrMl7fbb360O7UE6i1R1ecY6VrERsY+yXEH8SPLtIrx4R7slGv5XjZh7KGYAmzEZ/75y7KfoBR
 kYBgyYIRUNJylsoQBjbvC2sQQ
X-Received: by 2002:a1c:b445:: with SMTP id d66mr4126798wmf.187.1586939409340; 
 Wed, 15 Apr 2020 01:30:09 -0700 (PDT)
X-Google-Smtp-Source: APiQypI1/GFDfyQOLK5J6+00PCnZPj8fmTN9rFZPV07c4zGKdQlKsQOx+NrwNSeq7rAzMZDiU7ufeQ==
X-Received: by 2002:a1c:b445:: with SMTP id d66mr4126760wmf.187.1586939409106; 
 Wed, 15 Apr 2020 01:30:09 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.238])
 by smtp.gmail.com with ESMTPSA id g25sm8724053wmh.24.2020.04.15.01.30.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 15 Apr 2020 01:30:08 -0700 (PDT)
Subject: Re: [PATCH v2] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
 kvm@vger.kernel.org
References: <20200414155625.20559-1-eesposit@redhat.com>
 <b479e7ff-4534-5ced-e19b-2a2914905a8b@amsat.org>
From: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <992ede27-3eae-f2da-ad38-1d3498853ad2@redhat.com>
Date: Wed, 15 Apr 2020 10:30:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b479e7ff-4534-5ced-e19b-2a2914905a8b@amsat.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Wed, 15 Apr 2020 05:23:47 -0400
Cc: kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

CgpPbiA0LzE1LzIwIDg6MzYgQU0sIFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIHdyb3RlOgo+IE9u
IDQvMTQvMjAgNTo1NiBQTSwgRW1hbnVlbGUgR2l1c2VwcGUgRXNwb3NpdG8gd3JvdGU6Cj4+IFRo
ZSBtYWNyb3MgVk1fU1RBVCBhbmQgVkNQVV9TVEFUIGFyZSByZWR1bmRhbnRseSBpbXBsZW1lbnRl
ZCBpbiBtdWx0aXBsZQo+PiBmaWxlcywgZWFjaCB1c2VkIGJ5IGEgZGlmZmVyZW50IGFyY2hpdGVj
dXJlIHRvIGluaXRpYWxpemUgdGhlIGRlYnVnZnMKPj4gZW50cmllcyBmb3Igc3RhdGlzdGljcy4g
U2luY2UgdGhleSBhbGwgaGF2ZSB0aGUgc2FtZSBwdXJwb3NlLCB0aGV5IGNhbiBiZQo+PiB1bmlm
aWVkIGluIGEgc2luZ2xlIGNvbW1vbiBkZWZpbml0aW9uIGluIGluY2x1ZGUvbGludXgva3ZtX2hv
c3QuaAo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBFbWFudWVsZSBHaXVzZXBwZSBFc3Bvc2l0byA8ZWVz
cG9zaXRAcmVkaGF0LmNvbT4KPj4gLS0tCj4+ICAgYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYyAgICB8
ICAyMyArKy0tLQo+PiAgIGFyY2gvbWlwcy9rdm0vbWlwcy5jICAgICAgfCAgNjEgKysrKysrLS0t
LS0tCj4+ICAgYXJjaC9wb3dlcnBjL2t2bS9ib29rM3MuYyB8ICA2MSArKysrKystLS0tLS0KPj4g
ICBhcmNoL3Bvd2VycGMva3ZtL2Jvb2tlLmMgIHwgIDQxICsrKystLS0tCj4+ICAgYXJjaC9zMzkw
L2t2bS9rdm0tczM5MC5jICB8IDIwMyArKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0t
LS0tLQo+PiAgIGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAgfCAgODAgKysrKysrKy0tLS0tLS0t
Cj4+ICAgaW5jbHVkZS9saW51eC9rdm1faG9zdC5oICB8ICAgNSArCj4+ICAgNyBmaWxlcyBjaGFu
Z2VkLCAyMzEgaW5zZXJ0aW9ucygrKSwgMjQzIGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYyBiL2FyY2gvYXJtNjQva3ZtL2d1ZXN0LmMKPj4gaW5k
ZXggMjNlYmU1MTQxMGYwLi44NDE3YjIwMGJlYzkgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gvYXJtNjQv
a3ZtL2d1ZXN0LmMKPj4gKysrIGIvYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYwo+PiBAQCAtMjksMjAg
KzI5LDE3IEBACj4+ICAgCj4+ICAgI2luY2x1ZGUgInRyYWNlLmgiCj4+ICAgCj4+IC0jZGVmaW5l
IFZNX1NUQVQoeCkgeyAjeCwgb2Zmc2V0b2Yoc3RydWN0IGt2bSwgc3RhdC54KSwgS1ZNX1NUQVRf
Vk0gfQo+PiAtI2RlZmluZSBWQ1BVX1NUQVQoeCkgeyAjeCwgb2Zmc2V0b2Yoc3RydWN0IGt2bV92
Y3B1LCBzdGF0LngpLCBLVk1fU1RBVF9WQ1BVIH0KPj4gLQo+PiAgIHN0cnVjdCBrdm1fc3RhdHNf
ZGVidWdmc19pdGVtIGRlYnVnZnNfZW50cmllc1tdID0gewo+PiAtCVZDUFVfU1RBVChoYWx0X3N1
Y2Nlc3NmdWxfcG9sbCksCj4+IC0JVkNQVV9TVEFUKGhhbHRfYXR0ZW1wdGVkX3BvbGwpLAo+PiAt
CVZDUFVfU1RBVChoYWx0X3BvbGxfaW52YWxpZCksCj4+IC0JVkNQVV9TVEFUKGhhbHRfd2FrZXVw
KSwKPj4gLQlWQ1BVX1NUQVQoaHZjX2V4aXRfc3RhdCksCj4+IC0JVkNQVV9TVEFUKHdmZV9leGl0
X3N0YXQpLAo+PiAtCVZDUFVfU1RBVCh3ZmlfZXhpdF9zdGF0KSwKPj4gLQlWQ1BVX1NUQVQobW1p
b19leGl0X3VzZXIpLAo+PiAtCVZDUFVfU1RBVChtbWlvX2V4aXRfa2VybmVsKSwKPj4gLQlWQ1BV
X1NUQVQoZXhpdHMpLAo+PiArCVZDUFVfU1RBVCgiaGFsdF9zdWNjZXNzZnVsX3BvbGwiLCBoYWx0
X3N1Y2Nlc3NmdWxfcG9sbCksCj4+ICsJVkNQVV9TVEFUKCJoYWx0X2F0dGVtcHRlZF9wb2xsIiwg
aGFsdF9hdHRlbXB0ZWRfcG9sbCksCj4+ICsJVkNQVV9TVEFUKCJoYWx0X3BvbGxfaW52YWxpZCIs
IGhhbHRfcG9sbF9pbnZhbGlkKSwKPj4gKwlWQ1BVX1NUQVQoImhhbHRfd2FrZXVwIiwgaGFsdF93
YWtldXApLAo+PiArCVZDUFVfU1RBVCgiaHZjX2V4aXRfc3RhdCIsIGh2Y19leGl0X3N0YXQpLAo+
PiArCVZDUFVfU1RBVCgid2ZlX2V4aXRfc3RhdCIsIHdmZV9leGl0X3N0YXQpLAo+PiArCVZDUFVf
U1RBVCgid2ZpX2V4aXRfc3RhdCIsIHdmaV9leGl0X3N0YXQpLAo+PiArCVZDUFVfU1RBVCgibW1p
b19leGl0X3VzZXIiLCBtbWlvX2V4aXRfdXNlciksCj4+ICsJVkNQVV9TVEFUKCJtbWlvX2V4aXRf
a2VybmVsIiwgbW1pb19leGl0X2tlcm5lbCksCj4+ICsJVkNQVV9TVEFUKCJleGl0cyIsIGV4aXRz
KSwKPj4gICAJeyBOVUxMIH0KPj4gICB9Owo+IAo+IFBhdGNoIGVhc2lseSByZXZpZXdlZCB3aXRo
IC0td29yZC1kaWZmLgo+IAo+IFsuLi5dCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2
bV9ob3N0LmggYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKPj4gaW5kZXggNmQ1OGJlYjY1NDU0
Li4yZTZlYWQ4NzI5NTcgMTAwNjQ0Cj4+IC0tLSBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+
PiArKysgYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKPj4gQEAgLTExMzAsNiArMTEzMCwxMSBA
QCBzdHJ1Y3Qga3ZtX3N0YXRzX2RlYnVnZnNfaXRlbSB7Cj4+ICAgI2RlZmluZSBLVk1fREJHRlNf
R0VUX01PREUoZGJnZnNfaXRlbSkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIFwKPj4gICAJKChkYmdmc19pdGVtKS0+bW9kZSA/IChkYmdmc19pdGVtKS0+bW9kZSA6IDA2
NDQpCj4+ICAgCj4+ICsjZGVmaW5lIFZNX1NUQVQobiwgeCwgLi4uKSAJCQkJCQkJCQkJCQkJICAg
XAo+PiArCXsgbiwgb2Zmc2V0b2Yoc3RydWN0IGt2bSwgc3RhdC54KSwgS1ZNX1NUQVRfVk0sICMj
IF9fVkFfQVJHU19fIH0KPj4gKyNkZWZpbmUgVkNQVV9TVEFUKG4sIHgsIC4uLikJCQkJCQkJCQkJ
CQkgICBcCj4gCj4gTm90IHN1cmUgd2hpbGUgeW91IHVzZSBzbyBtYW55IHdoaXRlc3BhY2VzIGhl
cmUuLi4gKG1heWJlIFBhb2xvIGNhbgo+IHN0cmlwIHNvbWUgd2hlbiBhcHBseWluZz8pLgoKSSBo
b25lc3RseSBhbSBub3Qgc3VyZSB3aHkgaXQgYWRkZWQgZmV3IG1vcmUgc3BhY2VzIHRoYW4gSSB3
YW50ZWQsIGJ1dCAKdGhlIGlkZWEgd2FzIHRvIGZvbGxvdyB0aGUgS1ZNX0RCR0ZTX0dFVF9NT0RF
IG1hY3JvIGFib3ZlIGFuZCBwdXQgdGhlIApiYWNrc2xhc2ggYXQgdGhlIGVuZCBvZiB0aGUgbGlu
ZSAoODB0aCBjaGFyKS4KCj4gCj4gT3RoZXJ3aXNlIGl0IGxvb2tzIG5pY2VyIHRoYXQgdjEsIHRo
YW5rcy4KPiAKPiBSZXZpZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPGY0YnVnQGFt
c2F0Lm9yZz4KPiAKPj4gKwl7IG4sIG9mZnNldG9mKHN0cnVjdCBrdm1fdmNwdSwgc3RhdC54KSwg
S1ZNX1NUQVRfVkNQVSwgIyMgX19WQV9BUkdTX18gfQo+PiArCj4+ICAgZXh0ZXJuIHN0cnVjdCBr
dm1fc3RhdHNfZGVidWdmc19pdGVtIGRlYnVnZnNfZW50cmllc1tdOwo+PiAgIGV4dGVybiBzdHJ1
Y3QgZGVudHJ5ICprdm1fZGVidWdmc19kaXI7Cj4+ICAgCj4+Cj4gCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K

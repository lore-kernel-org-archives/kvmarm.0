Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0DFC2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 11:08:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B1E724653
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 11:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aO6tCxEV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B1E724653
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80AAF4AFF7;
	Tue, 21 Jan 2020 06:08:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HCCuTi4Kos5q; Tue, 21 Jan 2020 06:08:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2E374AFEB;
	Tue, 21 Jan 2020 06:08:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C274AFE9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 06:08:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7PMvgBxYS2rV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 06:08:07 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF4FD4AFE5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 06:08:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579604887;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=sngbJ+Kyu9/Mq5RVvCDBtxR0cwUMu/3ilD0iozKavMc=;
 b=aO6tCxEVxER5KFLIY9xN0txBNQuh7XyalM7ZJhYBozANda3TxPyriD7tKiqjkeC55sR8/w
 YRICUM+G2dqz1jKXtSU+a62Hwipxm7T4nPXklI6C5Ove+NkfcsAFS0TzMc3o9w6LdcwXsQ
 Im5gBiLa5OVUx+yQWCv2XjgXnmR3iAo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-w1m1oRTkP_OdefCfDpObPQ-1; Tue, 21 Jan 2020 06:08:05 -0500
Received: by mail-wr1-f69.google.com with SMTP id f15so1170217wrr.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 03:08:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=x7jZw/H2y5zeqQuje6kJm5arA3TA0C7bKtuRivqDv8Y=;
 b=MkP0EcSQZlgqhkRWzpWbCQkMtbI8ee3FjGlEcqFnDzl5mXRllzUGZY+b0kUi1zH38g
 xgBAPtaeENw2Xy2vIZ3Z++4nv+fyxoe6mxUzjQjvF+CWiPhuxOLG4ANhH7jd8QqOyw4V
 xBten9ZptTxflLPLzd8P2NBMKv7VmFT96OBRCCLHQdHPDF9ghu/s+D1QxjEHDTPEA9Bl
 CPPWnqYtjZm0Fcb5GeTA3GaVXFh1DmYi08KSbuDUEyrKloFxXaP2+aIV4O4JDCuRKcos
 mJRJznpaAp5mVTtxz8m/10CbCMQa0AVbi0tpZJQ4V19qC20WwcOuQL+rLvzivqRwhg9I
 2b6A==
X-Gm-Message-State: APjAAAU4KkHtvkx7egQR/9yFe3XtyVwMLHcmf8jN9WbuIbTNiSEq4SoG
 WiEsJiarJGUiA8lqHhqAXVuLJiUeQdlUkBqjo1iuumpfCjHudu3ttMpjhFrq9YcnVFIp4yP8ZcI
 mqYKZ5iq1s/gC/tAWWmanRjh7
X-Received: by 2002:a5d:5091:: with SMTP id a17mr4584298wrt.362.1579604884296; 
 Tue, 21 Jan 2020 03:08:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqyrSJw1xVD8KtI/DVSDHhO4SUvtdN2Xqf5CmpjkIe8Jj2CEEstdjLnJnkKwuFepClVNL9qC7A==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr4584254wrt.362.1579604883939; 
 Tue, 21 Jan 2020 03:08:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id l15sm49716775wrv.39.2020.01.21.03.08.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 03:08:03 -0800 (PST)
Subject: Re: [PATCH v2 15/45] KVM: PPC: Move kvm_vcpu_init() invocation to
 common code
To: Paul Mackerras <paulus@ozlabs.org>,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-16-sean.j.christopherson@intel.com>
 <20200120033402.GC14307@blackberry>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <07329402-25a3-874a-5e79-d35900668f1d@redhat.com>
Date: Tue, 21 Jan 2020 12:08:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200120033402.GC14307@blackberry>
Content-Language: en-US
X-MC-Unique: w1m1oRTkP_OdefCfDpObPQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, James Hogan <jhogan@kernel.org>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAvMDEvMjAgMDQ6MzQsIFBhdWwgTWFja2VycmFzIHdyb3RlOgo+IE9uIFdlZCwgRGVjIDE4
LCAyMDE5IGF0IDAxOjU1OjAwUE0gLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+
IE1vdmUgdGhlIGt2bV9jcHVfe3VufWluaXQoKSBjYWxscyB0byBjb21tb24gUFBDIGNvZGUgYXMg
YW4gaW50ZXJtZWRpYXRlCj4+IHN0ZXAgdG93YXJkcyByZW1vdmluZyBrdm1fY3B1X3t1bn1pbml0
KCkgYWx0b2dldGhlci4KPj4KPj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuCj4+Cj4+
IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNv
bkBpbnRlbC5jb20+Cj4gCj4gVGhpcyBkb2Vzbid0IGNvbXBpbGU6Cj4gCj4gICBDQyBbTV0gIGFy
Y2gvcG93ZXJwYy9rdm0vYm9vazNzLm8KPiAvaG9tZS9wYXVsdXMva2VybmVsL2t2bS9hcmNoL3Bv
d2VycGMva3ZtL2Jvb2szcy5jOiBJbiBmdW5jdGlvbiDigJhrdm1wcGNfY29yZV92Y3B1X2NyZWF0
ZeKAmToKPiAvaG9tZS9wYXVsdXMva2VybmVsL2t2bS9hcmNoL3Bvd2VycGMva3ZtL2Jvb2szcy5j
Ojc5NDo5OiBlcnJvcjog4oCYa3Zt4oCZIHVuZGVjbGFyZWQgKGZpcnN0IHVzZSBpbiB0aGlzIGZ1
bmN0aW9uKQo+ICAgcmV0dXJuIGt2bS0+YXJjaC5rdm1fb3BzLT52Y3B1X2NyZWF0ZSh2Y3B1KTsK
PiAgICAgICAgICBeCj4gL2hvbWUvcGF1bHVzL2tlcm5lbC9rdm0vYXJjaC9wb3dlcnBjL2t2bS9i
b29rM3MuYzo3OTQ6OTogbm90ZTogZWFjaCB1bmRlY2xhcmVkIGlkZW50aWZpZXIgaXMgcmVwb3J0
ZWQgb25seSBvbmNlIGZvciBlYWNoIGZ1bmN0aW9uIGl0IGFwcGVhcnMgaW4KPiAvaG9tZS9wYXVs
dXMva2VybmVsL2t2bS9hcmNoL3Bvd2VycGMva3ZtL2Jvb2szcy5jOjc5NToxOiB3YXJuaW5nOiBj
b250cm9sIHJlYWNoZXMgZW5kIG9mIG5vbi12b2lkIGZ1bmN0aW9uIFstV3JldHVybi10eXBlXQo+
ICB9Cj4gIF4KPiBtYWtlWzNdOiAqKiogWy9ob21lL3BhdWx1cy9rZXJuZWwva3ZtL3NjcmlwdHMv
TWFrZWZpbGUuYnVpbGQ6MjY2OiBhcmNoL3Bvd2VycGMva3ZtL2Jvb2szcy5vXSBFcnJvciAxCj4g
Cj4+IGRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMva3ZtL2Jvb2szcy5jIGIvYXJjaC9wb3dlcnBj
L2t2bS9ib29rM3MuYwo+PiBpbmRleCAxMzM4NTY1NmI5MGQuLjVhZDIwZmMwYzZhMSAxMDA2NDQK
Pj4gLS0tIGEvYXJjaC9wb3dlcnBjL2t2bS9ib29rM3MuYwo+PiArKysgYi9hcmNoL3Bvd2VycGMv
a3ZtL2Jvb2szcy5jCj4+IEBAIC03ODksMTAgKzc4OSw5IEBAIHZvaWQga3ZtcHBjX2RlY3JlbWVu
dGVyX2Z1bmMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+PiAgCWt2bV92Y3B1X2tpY2sodmNwdSk7
Cj4+ICB9Cj4+ICAKPj4gLWludCBrdm1wcGNfY29yZV92Y3B1X2NyZWF0ZShzdHJ1Y3Qga3ZtICpr
dm0sIHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gLQkJCSAgICB1bnNpZ25lZCBpbnQgaWQpCj4+
ICtpbnQga3ZtcHBjX2NvcmVfdmNwdV9jcmVhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+PiAg
ewo+PiAtCXJldHVybiBrdm0tPmFyY2gua3ZtX29wcy0+dmNwdV9jcmVhdGUoa3ZtLCB2Y3B1LCBp
ZCk7Cj4+ICsJcmV0dXJuIGt2bS0+YXJjaC5rdm1fb3BzLT52Y3B1X2NyZWF0ZSh2Y3B1KTsKPiAK
PiBOZWVkcyBzL2t2bS92Y3B1LT5rdm0vIGhlcmUuCj4gCj4gWW91IGFsc28gbmVlZCB0byBjaGFu
Z2UgdGhlIGRlY2xhcmF0aW9uIG9mIHRoZSB2Y3B1X2NyZWF0ZSBmdW5jdGlvbgo+IHBvaW50ZXIg
aW4gdGhlIGt2bXBwY19vcHMgc3RydWN0IGluIGt2bV9wcGMuaCB0byBoYXZlIGp1c3QgdGhlIHZj
cHUKPiBwYXJhbWV0ZXIgaW5zdGVhZCBvZiAzIHBhcmFtZXRlcnMuCgpTcXVhc2hlZDoKCmRpZmYg
LS1naXQgYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20va3ZtX3BwYy5oIGIvYXJjaC9wb3dlcnBj
L2luY2x1ZGUvYXNtL2t2bV9wcGMuaAppbmRleCAzNzRlNGI4MzVmZjAuLmJjMjQ5NGU1NzEwYSAx
MDA2NDQKLS0tIGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2t2bV9wcGMuaAorKysgYi9hcmNo
L3Bvd2VycGMvaW5jbHVkZS9hc20va3ZtX3BwYy5oCkBAIC0yNzMsOCArMjczLDcgQEAgc3RydWN0
IGt2bXBwY19vcHMgewogCXZvaWQgKCppbmplY3RfaW50ZXJydXB0KShzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIGludCB2ZWMsIHU2NCBzcnIxX2ZsYWdzKTsKIAl2b2lkICgqc2V0X21zcikoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCB1NjQgbXNyKTsKIAlpbnQgKCp2Y3B1X3J1bikoc3RydWN0IGt2bV9y
dW4gKnJ1biwgc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKLQlpbnQgKCp2Y3B1X2NyZWF0ZSkoc3Ry
dWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCi0JCQkgICB1bnNpZ25lZCBpbnQg
aWQpOworCWludCAoKnZjcHVfY3JlYXRlKShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwogCXZvaWQg
KCp2Y3B1X2ZyZWUpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7CiAJaW50ICgqY2hlY2tfcmVxdWVz
dHMpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7CiAJaW50ICgqZ2V0X2RpcnR5X2xvZykoc3RydWN0
IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX2RpcnR5X2xvZyAqbG9nKTsKZGlmZiAtLWdpdCBhL2FyY2gv
cG93ZXJwYy9rdm0vYm9vazNzLmMgYi9hcmNoL3Bvd2VycGMva3ZtL2Jvb2szcy5jCmluZGV4IDVh
ZDIwZmMwYzZhMS4uM2Y3YWRjYjBmZjYzIDEwMDY0NAotLS0gYS9hcmNoL3Bvd2VycGMva3ZtL2Jv
b2szcy5jCisrKyBiL2FyY2gvcG93ZXJwYy9rdm0vYm9vazNzLmMKQEAgLTc5MSw3ICs3OTEsNyBA
QCB2b2lkIGt2bXBwY19kZWNyZW1lbnRlcl9mdW5jKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIAog
aW50IGt2bXBwY19jb3JlX3ZjcHVfY3JlYXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKLQly
ZXR1cm4ga3ZtLT5hcmNoLmt2bV9vcHMtPnZjcHVfY3JlYXRlKHZjcHUpOworCXJldHVybiB2Y3B1
LT5rdm0tPmFyY2gua3ZtX29wcy0+dmNwdV9jcmVhdGUodmNwdSk7CiB9CiAKIHZvaWQga3ZtcHBj
X2NvcmVfdmNwdV9mcmVlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKZGlmZiAtLWdpdCBhL2FyY2gv
cG93ZXJwYy9rdm0vYm9va2UuYyBiL2FyY2gvcG93ZXJwYy9rdm0vYm9va2UuYwppbmRleCBkZDc0
NDBlNTBjN2EuLmQ0MTc2NTE1N2YwZSAxMDA2NDQKLS0tIGEvYXJjaC9wb3dlcnBjL2t2bS9ib29r
ZS5jCisrKyBiL2FyY2gvcG93ZXJwYy9rdm0vYm9va2UuYwpAQCAtMjExNiw3ICsyMTE2LDcgQEAg
aW50IGt2bXBwY19jb3JlX2luaXRfdm0oc3RydWN0IGt2bSAqa3ZtKQogCiBpbnQga3ZtcHBjX2Nv
cmVfdmNwdV9jcmVhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogewotCXJldHVybiBrdm0tPmFy
Y2gua3ZtX29wcy0+dmNwdV9jcmVhdGUodmNwdSk7CisJcmV0dXJuIHZjcHUtPmt2bS0+YXJjaC5r
dm1fb3BzLT52Y3B1X2NyZWF0ZSh2Y3B1KTsKIH0KIAogdm9pZCBrdm1wcGNfY29yZV92Y3B1X2Zy
ZWUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==

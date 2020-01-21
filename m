Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC98C2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 11:05:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D9DC20882
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 11:05:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g2go21lr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D9DC20882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 031C24AFEC;
	Tue, 21 Jan 2020 06:05:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YVuiC0mj3ZfM; Tue, 21 Jan 2020 06:05:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53DD94AFDB;
	Tue, 21 Jan 2020 06:05:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EDF64AFAC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 06:05:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jrXgJW9xglxl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 06:05:07 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC1E4AFA9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 06:05:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579604707;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GHlDobO7oHY+nQ+axF+VLoIhwWmOeoHVcejl/AsTEGk=;
 b=g2go21lrjHr6vO5JbWZ01MVpX0LMUDd0lWp/pzMYZOpcWcN+0xNYVYDTIv70Hudm+oAUmp
 qIof7an3fLaZ/tnjke2BlBsETO9bt2BoVxPIVMA6pTntKuO174ab4+jSgv5/DA0fn4ZEtP
 tq0sRCNtQdvygfukJO66Y3eCJx+fEbY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-s5g7oVGTM-uhG-N6OzBqGg-1; Tue, 21 Jan 2020 06:05:04 -0500
Received: by mail-wm1-f71.google.com with SMTP id o24so322171wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 03:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=d9MsVbaNk7uS2Z+64id6QtYbk8dUZDS6e1+y0CQGu/U=;
 b=dFAVbzhIDi/jHDC305Voqhyb7mExZkctZ1FaEwFrrOUbLWY7sb0MzgI+fZNS9SLeVC
 OYHaEGSATkApALBamXsA9bNIdtykqQLd3dfS0pe7ChpYiT6DwA7WOMf85IgkIxoaWiOy
 BvctkTaAPlvEBfZrCLVu6Nxrr5Ccu+yi7S6RVSO/xrfa6MofMYgmsuq912CH8pc8pACU
 EmJn/dDfcmvCvOTLr4qtfHS0qvR57RgoN3A7Nvs+T81nK9mCYo7gyzLGc8/VwcpbylAU
 WRTDZ+QWV/hNUJ/BwaFP9atQbayN6PUqhSBzR9M45j3ZzhGPrwRsol5oVYNcbl2mhMKK
 trqw==
X-Gm-Message-State: APjAAAUOC9oDl9KgOQGmIE090XPd85S+N8r7pGRAUibDLF447+6cH5O/
 mkc1/MPf8pOvuXXnc8aVxrCAlW9XH5lZ7KWAlN96cXoU32NzDHYy0yXJWXBurgcdUFl3iz3yzms
 QSFlbF2j9cDh3Qpg7Zym8F6fK
X-Received: by 2002:adf:978c:: with SMTP id s12mr4583928wrb.408.1579604702659; 
 Tue, 21 Jan 2020 03:05:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqxC6B3CUIhPHui5yyVc53K8mg8DvgmB+n/aXEy4G4Rxw9ic8vDj4v06pAmlaTd9zgfxWEA28g==
X-Received: by 2002:adf:978c:: with SMTP id s12mr4583882wrb.408.1579604702280; 
 Tue, 21 Jan 2020 03:05:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id s8sm50551793wrt.57.2020.01.21.03.05.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 03:05:01 -0800 (PST)
Subject: Re: [PATCH v2 12/45] KVM: PPC: Allocate vcpu struct in common PPC code
To: Paul Mackerras <paulus@ozlabs.org>,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-13-sean.j.christopherson@intel.com>
 <20200120040412.GF14307@blackberry>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fcd2aaf1-6f6e-303a-d7c6-f6b0c0a4555c@redhat.com>
Date: Tue, 21 Jan 2020 12:05:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200120040412.GF14307@blackberry>
Content-Language: en-US
X-MC-Unique: s5g7oVGTM-uhG-N6OzBqGg-1
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

T24gMjAvMDEvMjAgMDU6MDQsIFBhdWwgTWFja2VycmFzIHdyb3RlOgo+IE9uIFdlZCwgRGVjIDE4
LCAyMDE5IGF0IDAxOjU0OjU3UE0gLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+
IE1vdmUgYWxsb2NhdGlvbiBvZiBhbGwgZmxhdm9ycyBvZiBQUEMgdkNQVXMgdG8gY29tbW9uIFBQ
QyBjb2RlLiAgQWxsCj4+IHZhcmlhbnRzIGVpdGhlciBhbGxvY2F0ZSAnc3RydWN0IGt2bV92Y3B1
JyBkaXJlY3RseSwgb3IgcmVxdWlyZSB0aGF0Cj4+IHRoZSBlbWJlZGRlZCAnc3RydWN0IGt2bV92
Y3B1JyBtZW1iZXIgYmUgbG9jYXRlZCBhdCBvZmZzZXQgMCwgaS5lLgo+PiBndWFyYW50ZWUgdGhh
dCB0aGUgYWxsb2NhdGlvbiBjYW4gYmUgZGlyZWN0bHkgaW50ZXJwcmV0ZWQgYXMgYSAnc3RydWN0
Cj4+IGt2bV92Y3B1JyBvYmplY3QuCj4+Cj4+IFJlbW92ZSB0aGUgbWVzc2FnZSBmcm9tIHRoZSBi
dWlsZC10aW1lIGFzc2VydGlvbiByZWdhcmRpbmcgcGxhY2VtZW50IG9mCj4+IHRoZSBzdHJ1Y3Qs
IGFzIGNvbXBhdGliaWxpdHkgd2l0aCB0aGUgYXJjaCB1c2VyY29weSByZWdpb24gaXMgbm8gbG9u
Z2VyCj4+IHRoZSBzb2xlIGRlcGVuZGVudCBvbiAnc3RydWN0IGt2bV92Y3B1JyBiZWluZyBhdCBv
ZmZzZXQgemVyby4KPj4KPj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vh
bi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4KPiAKPiBUaGlzIGZhaWxzIHRvIGNvbXBpbGUg
Zm9yIEJvb2sgRSBjb25maWdzOgo+IAo+ICAgQ0MgICAgICBhcmNoL3Bvd2VycGMva3ZtL2U1MDAu
bwo+IC9ob21lL3BhdWx1cy9rZXJuZWwva3ZtL2FyY2gvcG93ZXJwYy9rdm0vZTUwMC5jOiBJbiBm
dW5jdGlvbiDigJhrdm1wcGNfY29yZV92Y3B1X2NyZWF0ZV9lNTAw4oCZOgo+IC9ob21lL3BhdWx1
cy9rZXJuZWwva3ZtL2FyY2gvcG93ZXJwYy9rdm0vZTUwMC5jOjQ2NDo5OiBlcnJvcjogcmV0dXJu
IG1ha2VzIGludGVnZXIgZnJvbSBwb2ludGVyIHdpdGhvdXQgYSBjYXN0IFstV2Vycm9yPWludC1j
b252ZXJzaW9uXQo+ICAgcmV0dXJuIHZjcHU7Cj4gICAgICAgICAgXgo+IGNjMTogYWxsIHdhcm5p
bmdzIGJlaW5nIHRyZWF0ZWQgYXMgZXJyb3JzCj4gbWFrZVszXTogKioqIFsvaG9tZS9wYXVsdXMv
a2VybmVsL2t2bS9zY3JpcHRzL01ha2VmaWxlLmJ1aWxkOjI2NjogYXJjaC9wb3dlcnBjL2t2bS9l
NTAwLm9dIEVycm9yIDEKPiAKPiBUaGVyZSBpcyBhICJyZXR1cm4gdmNwdSIgc3RhdGVtZW50IGlu
IGt2bXBwY19jb3JlX3ZjcHVfY3JlYXRlX2U1MDAoKSwKPiBhbmQgYW5vdGhlciBpbiBrdm1wcGNf
Y29yZV92Y3B1X2NyZWF0ZV9lNTAwbWMoKSwgd2hpY2ggYm90aCBuZWVkIHRvIGJlCj4gY2hhbmdl
ZCB0byAicmV0dXJuIDAiLgo+IAo+IChCeSB0aGUgd2F5LCBJIGRvIGFwcHJlY2lhdGUgeW91IGZp
eGluZyB0aGUgUFBDIGNvZGUsIGV2ZW4gaWYgdGhlcmUKPiBhcmUgc29tZSBlcnJvcnMuKQoKU3F1
YXNoZWQ6CgpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2t2bS9lNTAwLmMgYi9hcmNoL3Bvd2Vy
cGMva3ZtL2U1MDAuYwppbmRleCA5NmQ5Y2RlM2QyZTMuLmY1ZGQyYzdhZGNkNCAxMDA2NDQKLS0t
IGEvYXJjaC9wb3dlcnBjL2t2bS9lNTAwLmMKKysrIGIvYXJjaC9wb3dlcnBjL2t2bS9lNTAwLmMK
QEAgLTQ2MSw3ICs0NjEsNyBAQCBzdGF0aWMgaW50IGt2bXBwY19jb3JlX3ZjcHVfY3JlYXRlX2U1
MDAoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiAJCWdvdG8gdW5pbml0
X3RsYjsKIAl9CiAKLQlyZXR1cm4gdmNwdTsKKwlyZXR1cm4gMDsKIAogdW5pbml0X3RsYjoKIAlr
dm1wcGNfZTUwMF90bGJfdW5pbml0KHZjcHVfZTUwMCk7CmRpZmYgLS1naXQgYS9hcmNoL3Bvd2Vy
cGMva3ZtL2U1MDBtYy5jIGIvYXJjaC9wb3dlcnBjL2t2bS9lNTAwbWMuYwppbmRleCBhZWE1ODhm
NzNiZjcuLjdjMGQzOTJmNjY3YSAxMDA2NDQKLS0tIGEvYXJjaC9wb3dlcnBjL2t2bS9lNTAwbWMu
YworKysgYi9hcmNoL3Bvd2VycGMva3ZtL2U1MDBtYy5jCkBAIC0zMjcsNyArMzI3LDcgQEAgc3Rh
dGljIGludCBrdm1wcGNfY29yZV92Y3B1X2NyZWF0ZV9lNTAwbWMoc3RydWN0IGt2bSAqa3ZtLCBz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUKIAkJZ290byB1bmluaXRfdGxiOwogCX0KIAotCXJldHVybiB2
Y3B1OworCXJldHVybiAwOwogCiB1bmluaXRfdGxiOgogCWt2bXBwY19lNTAwX3RsYl91bmluaXQo
dmNwdV9lNTAwKTsKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DD5C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 08:41:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1154B1E2;
	Mon, 29 Nov 2021 03:41:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5Eh3E7Cq8hD1; Mon, 29 Nov 2021 03:41:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC98D4B217;
	Mon, 29 Nov 2021 03:41:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D55514B27C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 17:16:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YP-9RClh6IAP for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Nov 2021 17:16:33 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 563714B25A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 17:16:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638137793;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4dDgSQ/8TweS/kg7WcZSSnDUpsnRjzcTHNmiNwKkyh0=;
 b=bAY3cMhEZjqUutmMXPKBehrtXOIt3n3SDAI/hk/o8kttF+IruglmUCRNFI0AgopebADw4N
 Vm7L0Nj7h53Xke/eJYHtledgLwtvuEouFRCqFWjUZFOSplSTYUquqLbt228/2VVzM+yxmV
 GYJQbUpLQxZTVNiwtxBHyx4F1mSTShY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-95-8nKb2QCzNQClj-d059dZtw-1; Sun, 28 Nov 2021 17:16:29 -0500
X-MC-Unique: 8nKb2QCzNQClj-d059dZtw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 935911808322;
 Sun, 28 Nov 2021 22:16:24 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 0B8E810016F2;
 Sun, 28 Nov 2021 22:16:02 +0000 (UTC)
Message-ID: <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 29 Nov 2021 00:16:01 +0200
In-Reply-To: <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mailman-Approved-At: Mon, 29 Nov 2021 03:41:49 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

T24gV2VkLCAyMDIxLTEwLTI3IGF0IDE2OjQwICswMzAwLCBNYXhpbSBMZXZpdHNreSB3cm90ZToK
PiBPbiBGcmksIDIwMjEtMTAtMDggYXQgMTk6MTIgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6Cj4gPiBJbnZva2UgdGhlIGFyY2ggaG9va3MgZm9yIGJsb2NrK3VuYmxvY2sgaWYgYW5k
IG9ubHkgaWYgS1ZNIGFjdHVhbGx5Cj4gPiBhdHRlbXB0cyB0byBibG9jayB0aGUgdkNQVS4gIFRo
ZSBvbmx5IG5vbi1ub3AgaW1wbGVtZW50YXRpb24gaXMgb24geDg2LAo+ID4gc3BlY2lmaWNhbGx5
IFNWTSdzIEFWSUMsIGFuZCB0aGVyZSBpcyBubyBuZWVkIHRvIHB1dCB0aGUgQVZJQyBwcmlvciB0
bwo+ID4gaGFsdC1wb2xsaW5nIGFzIEtWTSB4ODYncyBrdm1fdmNwdV9oYXNfZXZlbnRzKCkgd2ls
bCBzY291ciB0aGUgZnVsbCB2SVJSCj4gPiB0byBmaW5kIHBlbmRpbmcgSVJRcyByZWdhcmRsZXNz
IG9mIHdoZXRoZXIgdGhlIEFWSUMgaXMgbG9hZGVkLyJydW5uaW5nIi4KPiA+IAo+ID4gVGhlIHBy
aW1hcnkgbW90aXZhdGlvbiBpcyB0byBhbGxvdyBmdXR1cmUgY2xlYW51cCB0byBzcGxpdCBvdXQg
ImJsb2NrIgo+ID4gZnJvbSAiaGFsdCIsIGJ1dCB0aGlzIGlzIGFsc28gbGlrZWx5IGEgc21hbGwg
cGVyZm9ybWFuY2UgYm9vc3Qgb24geDg2IFNWTQo+ID4gd2hlbiBoYWx0LXBvbGxpbmcgaXMgc3Vj
Y2Vzc2Z1bC4KPiA+IAo+ID4gQWRqdXN0IHRoZSBwb3N0LWJsb2NrIHBhdGggdG8gdXBkYXRlICJj
dXIiIGFmdGVyIHVuYmxvY2tpbmcsIGkuZS4gaW5jbHVkZQo+ID4gQVZJQyBsb2FkIHRpbWUgaW4g
aGFsdF93YWl0X25zIGFuZCBoYWx0X3dhaXRfaGlzdCwgc28gdGhhdCB0aGUgYmVoYXZpb3IKPiA+
IGlzIGNvbnNpc3RlbnQuICBNb3ZpbmcganVzdCB0aGUgcHJlLWJsb2NrIGFyY2ggaG9vayB3b3Vs
ZCByZXN1bHQgaW4gb25seQo+ID4gdGhlIEFWSUMgcHV0IGxhdGVuY3kgYmVpbmcgaW5jbHVkZWQg
aW4gdGhlIGhhbHRfd2FpdCBzdGF0cy4gIFRoZXJlIGlzIG5vCj4gPiBvYnZpb3VzIGV2aWRlbmNl
IHRoYXQgb25lIHdheSBvciB0aGUgb3RoZXIgaXMgY29ycmVjdCwgc28ganVzdCBlbnN1cmUgS1ZN
Cj4gPiBpcyBjb25zaXN0ZW50Lgo+ID4gCj4gPiBOb3RlLCB4ODYgaGFzIHR3byBzZXBhcmF0ZSBw
YXRocyBmb3IgaGFuZGxpbmcgQVBJQ3Ygd2l0aCByZXNwZWN0IHRvIHZDUFUKPiA+IGJsb2NraW5n
LiAgVk1YIHVzZXMgaG9va3MgaW4geDg2J3MgdmNwdV9ibG9jaygpLCB3aGlsZSBTVk0gdXNlcyB0
aGUgYXJjaAo+ID4gaG9va3MgaW4ga3ZtX3ZjcHVfYmxvY2soKS4gIFByaW9yIHRvIHRoaXMgcGF0
aCwgdGhlIHR3byBwYXRocyB3ZXJlIG1vcmUKPiA+IG9yIGxlc3MgZnVuY3Rpb25hbGx5IGlkZW50
aWNhbC4gIFRoYXQgaXMgdmVyeSBtdWNoIG5vdCB0aGUgY2FzZSBhZnRlcgo+ID4gdGhpcyBwYXRj
aCwgYXMgdGhlIGhvb2tzIHVzZWQgYnkgVk1YIF9tdXN0XyBmaXJlIGJlZm9yZSBoYWx0LXBvbGxp
bmcuCj4gPiB4ODYncyBlbnRpcmUgbWVzcyB3aWxsIGJlIGNsZWFuZWQgdXAgaW4gZnV0dXJlIHBh
dGNoZXMuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tPgo+ID4gLS0tCj4gPiAgdmlydC9rdm0va3ZtX21haW4uYyB8IDcgKysrKy0t
LQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4g
PiAKPiA+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21h
aW4uYwo+ID4gaW5kZXggZjkwYjNlZDA1NjI4Li4yMjdmNmJiZTA3MTYgMTAwNjQ0Cj4gPiAtLS0g
YS92aXJ0L2t2bS9rdm1fbWFpbi5jCj4gPiArKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCj4gPiBA
QCAtMzIzNSw4ICszMjM1LDYgQEAgdm9pZCBrdm1fdmNwdV9ibG9jayhzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpCj4gPiAgCWJvb2wgd2FpdGVkID0gZmFsc2U7Cj4gPiAgCXU2NCBibG9ja19uczsKPiA+
ICAKPiA+IC0Ja3ZtX2FyY2hfdmNwdV9ibG9ja2luZyh2Y3B1KTsKPiA+IC0KPiA+ICAJc3RhcnQg
PSBjdXIgPSBwb2xsX2VuZCA9IGt0aW1lX2dldCgpOwo+ID4gIAlpZiAoZG9faGFsdF9wb2xsKSB7
Cj4gPiAgCQlrdGltZV90IHN0b3AgPSBrdGltZV9hZGRfbnMoa3RpbWVfZ2V0KCksIHZjcHUtPmhh
bHRfcG9sbF9ucyk7Cj4gPiBAQCAtMzI1Myw2ICszMjUxLDcgQEAgdm9pZCBrdm1fdmNwdV9ibG9j
ayhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4gPiAgCQl9IHdoaWxlIChrdm1fdmNwdV9jYW5fcG9s
bChjdXIsIHN0b3ApKTsKPiA+ICAJfQo+ID4gIAo+ID4gKwlrdm1fYXJjaF92Y3B1X2Jsb2NraW5n
KHZjcHUpOwo+ID4gIAo+ID4gIAlwcmVwYXJlX3RvX3JjdXdhaXQod2FpdCk7Cj4gPiAgCWZvciAo
OzspIHsKPiA+IEBAIC0zMjY1LDYgKzMyNjQsOSBAQCB2b2lkIGt2bV92Y3B1X2Jsb2NrKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSkKPiA+ICAJCXNjaGVkdWxlKCk7Cj4gPiAgCX0KPiA+ICAJZmluaXNo
X3JjdXdhaXQod2FpdCk7Cj4gPiArCj4gPiArCWt2bV9hcmNoX3ZjcHVfdW5ibG9ja2luZyh2Y3B1
KTsKPiA+ICsKPiA+ICAJY3VyID0ga3RpbWVfZ2V0KCk7Cj4gPiAgCWlmICh3YWl0ZWQpIHsKPiA+
ICAJCXZjcHUtPnN0YXQuZ2VuZXJpYy5oYWx0X3dhaXRfbnMgKz0KPiA+IEBAIC0zMjczLDcgKzMy
NzUsNiBAQCB2b2lkIGt2bV92Y3B1X2Jsb2NrKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiA+ICAJ
CQkJa3RpbWVfdG9fbnMoY3VyKSAtIGt0aW1lX3RvX25zKHBvbGxfZW5kKSk7Cj4gPiAgCX0KPiA+
ICBvdXQ6Cj4gPiAtCWt2bV9hcmNoX3ZjcHVfdW5ibG9ja2luZyh2Y3B1KTsKPiA+ICAJYmxvY2tf
bnMgPSBrdGltZV90b19ucyhjdXIpIC0ga3RpbWVfdG9fbnMoc3RhcnQpOwo+ID4gIAo+ID4gIAkv
Kgo+IAo+IE1ha2VzIHNlbnNlLgo+IAo+IFJldmlld2VkLWJ5OiBNYXhpbSBMZXZpdHNreSA8bWxl
dml0c2tAcmVkaGF0LmNvbT4KPiAKPiBCZXN0IHJlZ2FyZHMsCj4gCU1heGltIExldml0c2t5CgoK
U28uLi4KCkxhc3Qgd2VlayBJIGRlY2lkZWQgdG8gc3R1ZHkgYSBiaXQgaG93IEFWSUMgYmVoYXZl
cyB3aGVuIHZDUFVzIGFyZSBub3QgMTAwJSBydW5uaW5nCihha2Egbm8gY3B1X3BtPW9uKSwgdG8g
bW9zdGx5IHVuZGVyc3RhbmQgdGhlaXIgc28tY2FsbGVkICdHQSBsb2cnIHRoaW5nLgogCihUaGlz
IHRoaW5nIGlzIHRoYXQgd2hlbiB5b3UgdGVsbCB0aGUgSU9NTVUgdGhhdCBhIHZDUFUgaXMgbm90
IHJ1bm5pbmcsCnRoZSBJT01NVSBzdGFydHMgbG9nZ2luZyBhbGwgaW5jb21pbmcgcGFzc2VkLXRo
cm91Z2ggaW50ZXJydXB0cyB0byBhIHJpbmcgYnVmZmVyLAphbmQgcmFpc2VzIGl0cyBvd24gaW50
ZXJydXB0LCB3aGljaOKAmXMgaGFuZGxlciBpcyBzdXBwb3NlZCB0byB3YWtlIHVwIHRoZSBWTSdz
IHZDUFUuKQogClRoYXQgbGVkIHRvIG1lIGRpc2NvdmVyaW5nIHRoYXQgQU1EJ3MgSU9NTVUgaXMg
dG90YWxseSBidXN0ZWQgYWZ0ZXIgYSBzdXNwZW5kL3Jlc3VtZSBjeWNsZSwKZml4aW5nIHdoaWNo
IHRvb2sgbWUgZmV3IGRheXMgKGFuZCBtb3N0IG9mIHRoZSB0aW1lIEkgd29ycmllZCB0aGF0IGl0
J3Mgc29tZSBzb3J0IG9mIGEgQklPUyBidWcgd2hpY2ggbm9ib2R5IHdvdWxkIGZpeCwKYXMgdGhl
IElPTU1VIGludGVycnVwdCBkZWxpdmVyeSB3YXMgdG90YWxseSBidXN0ZWQgYWZ0ZXIgcmVzdW1l
LCBzb21ldGltZXMgZXZlbiBwb3dlciBjeWNsZSBkaWRuJ3QgaGVscAp0byByZXZpdmUgaXQgLSBw
aGV3Li4uKS4gCkx1Y2tpbHkgSSBkaWQgZml4IGl0LCBhbmQgcGF0Y2hlcyBhcmUgd2FpdGluZyBm
b3IgdGhlIHJldmlldyB1cHN0cmVhbS4KKGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2tl
cm5lbC9tc2c0MTUzNDg4Lmh0bWwpCiAKIApBbm90aGVyIHRoaW5nIEkgZGlzY292ZXJlZCB0aGF0
IHRoaXMgcGF0Y2ggc2VyaWVzIHRvdGFsbHkgYnJlYWtzIG15IFZNcywgd2l0aG91dCBjcHVfcG09
b24KVGhlIHdob2xlIHNlcmllcyAoSSBkaWRuJ3QgeWV0IGJpc2VjdCBpdCkgbWFrZXMgZXZlbiBt
eSBmZWRvcmEzMiBWTSBiZSB2ZXJ5IGxhZ2d5LCBhbG1vc3QgdW51c2FibGUsCmFuZCBpdCBvbmx5
IGhhcyBvbmUgcGFzc2VkLXRocm91Z2ggZGV2aWNlLCBhIG5pYykuCiAKSWYgSSBhcHBseSB0aG91
Z2ggb25seSB0aGUgcGF0Y2ggc2VyaWVzIHVwIHRvIHRoaXMgcGF0Y2gsIG15IGZlZG9yYSBWTSBz
ZWVtcyB0byB3b3JrIGZpbmUsIGJ1dApteSB3aW5kb3dzIFZNIHN0aWxsIGxvY2tzIHVwIGhhcmQg
d2hlbiBJIHJ1biAnTGF0ZW5jeVRvcCcgaW4gaXQsIHdoaWNoIGRvZXNuJ3QgaGFwcGVuIHdpdGhv
dXQgdGhpcyBwYXRjaC4KIAogClNvIGZhciB0aGUgc3ltcHRvbXMgSSBzZWUgaXMgdGhhdCBvbiBW
Q1BVIDAsIElTUiBoYXMgcXVpdGUgaGlnaCBpbnRlcnJ1cHQgKDB4ZTEgbGFzdCB0aW1lIEkgc2Vl
biBpdCksClRQUiBhbmQgUFBSIGFyZSAweGUwIChhbHRob3VnaCBJIGhhdmUgc2VlbiBUUFIgdG8g
aGF2ZSBkaWZmZXJlbnQgdmFsdWVzKSwgYW5kIElSUiBoYXMgcGxlbnR5IG9mIGludGVycnVwdHMK
d2l0aCBsb3dlciBwcmlvcml0eS4gVGhlIFZNIHNlZW1zIHRvIGJlIHN0dWNrIGluIHRoaXMgY2Fz
ZS4gQXMgaWYgaXRzIEVPSSBnb3QgbG9zdCBvciBzb21ldGhpbmcgaXMgcHJldmVudGluZwp0aGUg
SVJRIGhhbmRsZXIgZnJvbSBpc3N1aW5nIEVPSS4KIApMYXRlbmN5VG9wIGRvZXMgaW5zdGFsbCBz
b21lIGZvcm0gb2YgYSBrZXJuZWwgZHJpdmVyIHdoaWNoIGxpa2VseSBkb2VzIG1lZGRsZSB3aXRo
IGludGVycnVwdHMgKG1heWJlIGl0IHNlbmRzIGxvdHMgb2Ygc2VsZiBJUElzPykuCiAKMTAwJSBy
ZXByb2R1Y2libGUgYXMgc29vbiBhcyBJIHN0YXJ0IG1vbml0b3Jpbmcgd2l0aCBMYXRlbmN5VG9w
LgogCiAKV2l0aG91dCB0aGlzIHBhdGNoIGl0IHdvcmtzIChvciBpZiBkaXNhYmxpbmcgaGFsdCBw
b2xsaW5nKSwKIApidXQgSSBzdGlsbCBkaWQgbWFuYWdlIHRvIGxvY2t1cCB0aGUgVk0gZmV3IHRp
bWVzIHN0aWxsLCBhZnRlciBsb3Qgb2YgcmFuZG9tIGNsaWNraW5nL3N0YXJ0aW5nIHVwIHZhcmlv
dXMgYXBwcyB3aGlsZSBMYXRlbmN5VG9wIHdhcyBydW5uaW5nLApldGMsIGJ1dCBpbiB0aGlzIGNh
c2Ugd2hlbiBJIGR1bXAgbG9jYWwgYXBpYyB2aWEgcWVtdSdzIGhtcCBpbnRlcmZhY2UgdGhlIFZN
IGluc3RhbnRseSByZXZpdmVzLCB3aGljaCBtaWdodCBiZSBlaXRoZXIgc2FtZSBidWcKd2hpY2gg
Z290IGFtcGxpZmllZCBieSB0aGlzIHBhdGNoIG9yIHNvbWV0aGluZyBlbHNlLgpUaGF0IHdhcyB0
ZXN0ZWQgb24gdGhlIHB1cmUgNS4xNS4wIGtlcm5lbCB3aXRob3V0IGFueSBwYXRjaGVzLgogCkl0
IGlzIHBvc3NpYmxlIHRoYXQgdGhpcyBpcyBhIGJ1ZyBpbiBMYXRlbmN5VG9wIHRoYXQganVzdCBn
b3QgZXhwb3NlZCBieSBkaWZmZXJlbnQgdGltaW5nLgogClRoZSB3aW5kb3dzIFZNIGRvZXMgaGF2
ZSBHUFUgYW5kIGZldyBVU0IgY29udHJvbGxlcnMgcGFzc2VkIHRvIGl0LCBhbmQgd2l0aG91dCB0
aGVtLCBpbiBwdXJlIFZNIG1vZGUsIGFzIEkgY2FsbCBpdCwKdGhlIExhdGVuY3lUb3Agc2VlbXMg
dG8gd29yay4KIAoKVG9tb3Jyb3cgSSdsbCBnaXZlIGl0IGEgbW9yZSBmb3JtYWwgaW52ZXN0aWdh
dGlvbi4KIApCZXN0IHJlZ2FyZHMsCglNYXhpbSBMZXZpdHNreQoKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=

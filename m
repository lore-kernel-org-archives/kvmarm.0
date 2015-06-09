From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 03/10] KVM: arm/arm64: vgic: Convert struct vgic_lr to use
 bitfields
Date: Tue, 09 Jun 2015 14:12:19 +0100
Message-ID: <87twuh6n64.fsf@linaro.org>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F305B53FC8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 09:01:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2IYfcQ9DIGMP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2015 09:01:41 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 531A153F87
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 09:01:40 -0400 (EDT)
In-reply-to: <1433783045-8002-4-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Ck1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+IHdyaXRlczoKCj4gQXMgd2UncmUg
YWJvdXQgdG8gY3JhbSBtb3JlIGluZm9ybWF0aW9uIGluIHRoZSB2Z2ljX2xyIHN0cnVjdHVyZQo+
IChIVyBpbnRlcnJ1cHQgbnVtYmVyIGFuZCBhZGRpdGlvbmFsIHN0YXRlIGluZm9ybWF0aW9uKSwg
d2Ugc3dpdGNoCj4gdG8gYSBsYXlvdXQgc2ltaWxhciB0byB0aGUgSFcnczoKPgo+IC0gdXNlIGJp
dGZpZWxkcyB0byBzYXZlIHNwYWNlICh3ZSBkb24ndCBuZWVkIG1vcmUgdGhhbiAxMCBiaXRzCj4g
ICB0byByZXByZXNlbnQgdGhlIGlycSBudW1iZXJzKQo+IC0gc291cmNlIENQVSBhbmQgSFcgaW50
ZXJydXB0IGNhbiBzaGFyZSB0aGUgc2FtZSBmaWVsZCwgYXMKPiAgIGEgU0dJIGRvZXNuJ3QgaGF2
ZSBhIHBoeXNpY2FsIGxpbmUuCj4KPiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hcmMu
enluZ2llckBhcm0uY29tPgpSZXZpZXdlZC1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBs
aW5hcm8ub3JnPgoKPiAtLS0KPiAgaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaCB8IDEwICsrKysrKyst
LS0KPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPgo+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oIGIvaW5jbHVkZS9rdm0vYXJtX3Zn
aWMuaAo+IGluZGV4IDEzM2VhMDAuLjRmOWZhMWQgMTAwNjQ0Cj4gLS0tIGEvaW5jbHVkZS9rdm0v
YXJtX3ZnaWMuaAo+ICsrKyBiL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgKPiBAQCAtOTUsMTEgKzk1
LDE1IEBAIGVudW0gdmdpY190eXBlIHsKPiAgI2RlZmluZSBMUl9TVEFURV9BQ1RJVkUJCSgxIDw8
IDEpCj4gICNkZWZpbmUgTFJfU1RBVEVfTUFTSwkJKDMgPDwgMCkKPiAgI2RlZmluZSBMUl9FT0lf
SU5UCQkoMSA8PCAyKQo+ICsjZGVmaW5lIExSX0hXCQkJKDEgPDwgMykKPiAgCj4gIHN0cnVjdCB2
Z2ljX2xyIHsKPiAtCXUxNglpcnE7Cj4gLQl1OAlzb3VyY2U7Cj4gLQl1OAlzdGF0ZTsKPiArCXVu
c2lnbmVkIGlycToxMDsKPiArCXVuaW9uIHsKPiArCQl1bnNpZ25lZCBod2lycToxMDsKPiArCQl1
bnNpZ25lZCBzb3VyY2U6ODsKPiArCX07Cj4gKwl1bnNpZ25lZCBzdGF0ZTo0Owo+ICB9Owo+ICAK
PiAgc3RydWN0IHZnaWNfdm1jciB7CgotLSAKQWxleCBCZW5uw6llCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=

From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 05/26] KVM: arm64: Add missing #include of
 <linux/bitmap.h> to kvm_host.h
Date: Wed, 20 Feb 2019 15:23:50 +0000
Message-ID: <20190220152349.GE4763@lakrids.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-6-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28BA84A3B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 10:23:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iHUW-DtWnqMe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Feb 2019 10:23:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E85454A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 10:23:54 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1550519559-15915-6-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gTW9uLCBGZWIgMTgsIDIwMTkgYXQgMDc6NTI6MThQTSArMDAwMCwgRGF2ZSBNYXJ0aW4gd3Jv
dGU6Cj4ga3ZtX2hvc3QuaCB1c2VzIERFQ0xBUkVfQklUTUFQKCkgdG8gZGVjbGFyZSB0aGUgZmVh
dHVyZXMgbWVtYmVyIG9mCj4gc3RydWN0IHZjcHVfYXJjaCwgYnV0IHRoZSBjb3JyZXNwb25kaW5n
ICNpbmNsdWRlIGZvciB0aGlzIGlzCj4gbWlzc2luZy4KPiAKPiBUaGlzIHBhdGNoIGFkZHMgYSBz
dWl0YWJsZSAjaW5jbHVkZSBmb3IgPGxpbnV4L2JpdG1hcC5oPi4gIEFsdGhvdWdoCj4gdGhlIGhl
YWRlciBidWlsZHMgd2l0aG91dCBpdCB0b2RheSwgdGhpcyBzaG91bGQgaGVscCB0byBhdm9pZAo+
IGZ1dHVyZSBzdXJwcmlzZXMuCj4gCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUu
TWFydGluQGFybS5jb20+Cj4gUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVA
bGluYXJvLm9yZz4KPiAtLS0KPiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwg
MSArCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQo+IAo+IGRpZmYgLS1naXQgYS9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2t2bV9ob3N0LmgKPiBpbmRleCA3NzMyZDBiLi44NDA1NmE0IDEwMDY0NAo+IC0tLSBhL2FyY2gv
YXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20va3ZtX2hvc3QuaAo+IEBAIC0yMiw2ICsyMiw3IEBACj4gICNpZm5kZWYgX19BUk02NF9LVk1f
SE9TVF9IX18KPiAgI2RlZmluZSBfX0FSTTY0X0tWTV9IT1NUX0hfXwo+ICAKPiArI2luY2x1ZGUg
PGxpbnV4L2JpdG1hcC5oPgo+ICAjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KPiAgI2luY2x1ZGUg
PGxpbnV4L2t2bV90eXBlcy5oPgo+ICAjaW5jbHVkZSA8YXNtL2NwdWZlYXR1cmUuaD4KCkZyb20g
YSBxdWljayBzY2FuIG9mIHRoZSBmaWxlLCB3ZSdyZSBhbHNvIG1pc3Npbmc6CgojaW5jbHVkZSA8
bGludXgvanVtcF9sYWJlbC5oPgojaW5jbHVkZSA8bGludXgvcGVyY3B1Lmg+CiNpbmNsdWRlIDxs
aW51eC90aHJlYWRfaW5mby5oPgoKI2luY2x1ZGUgPGFzbS9iYXJyaWVyLmg+CgouLi4gd2hpY2gg
bWlnaHQgYmUgd29ydGggYWRkaW5nIGF0IHRoZSBzYW1lIHRpbWUuCgpUaGFua3MsCk1hcmsuCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 05/26] KVM: arm64: Add missing #include of
 <linux/bitmap.h> to kvm_host.h
Date: Tue, 26 Feb 2019 12:31:45 +0000
Message-ID: <20190226123145.GB17422@lakrids.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-6-git-send-email-Dave.Martin@arm.com>
 <20190220152349.GE4763@lakrids.cambridge.arm.com>
 <20190226120616.GG3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190226120616.GG3567@e103592.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gVHVlLCBGZWIgMjYsIDIwMTkgYXQgMTI6MDY6MTZQTSArMDAwMCwgRGF2ZSBNYXJ0aW4gd3Jv
dGU6Cj4gT24gV2VkLCBGZWIgMjAsIDIwMTkgYXQgMDM6MjM6NTBQTSArMDAwMCwgTWFyayBSdXRs
YW5kIHdyb3RlOgo+ID4gT24gTW9uLCBGZWIgMTgsIDIwMTkgYXQgMDc6NTI6MThQTSArMDAwMCwg
RGF2ZSBNYXJ0aW4gd3JvdGU6Cj4gPiA+IGt2bV9ob3N0LmggdXNlcyBERUNMQVJFX0JJVE1BUCgp
IHRvIGRlY2xhcmUgdGhlIGZlYXR1cmVzIG1lbWJlciBvZgo+ID4gPiBzdHJ1Y3QgdmNwdV9hcmNo
LCBidXQgdGhlIGNvcnJlc3BvbmRpbmcgI2luY2x1ZGUgZm9yIHRoaXMgaXMKPiA+ID4gbWlzc2lu
Zy4KPiA+ID4gCj4gPiA+IFRoaXMgcGF0Y2ggYWRkcyBhIHN1aXRhYmxlICNpbmNsdWRlIGZvciA8
bGludXgvYml0bWFwLmg+LiAgQWx0aG91Z2gKPiA+ID4gdGhlIGhlYWRlciBidWlsZHMgd2l0aG91
dCBpdCB0b2RheSwgdGhpcyBzaG91bGQgaGVscCB0byBhdm9pZAo+ID4gPiBmdXR1cmUgc3VycHJp
c2VzLgo+ID4gPiAKPiA+ID4gU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGlu
QGFybS5jb20+Cj4gPiA+IFJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxp
bmFyby5vcmc+Cj4gPiA+IC0tLQo+ID4gPiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9z
dC5oIHwgMSArCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKPiA+ID4gCj4g
PiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPiA+ID4gaW5kZXggNzczMmQwYi4uODQwNTZh
NCAxMDA2NDQKPiA+ID4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCj4g
PiA+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+ID4gPiBAQCAtMjIs
NiArMjIsNyBAQAo+ID4gPiAgI2lmbmRlZiBfX0FSTTY0X0tWTV9IT1NUX0hfXwo+ID4gPiAgI2Rl
ZmluZSBfX0FSTTY0X0tWTV9IT1NUX0hfXwo+ID4gPiAgCj4gPiA+ICsjaW5jbHVkZSA8bGludXgv
Yml0bWFwLmg+Cj4gPiA+ICAjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KPiA+ID4gICNpbmNsdWRl
IDxsaW51eC9rdm1fdHlwZXMuaD4KPiA+ID4gICNpbmNsdWRlIDxhc20vY3B1ZmVhdHVyZS5oPgo+
ID4gCj4gPiBGcm9tIGEgcXVpY2sgc2NhbiBvZiB0aGUgZmlsZSwgd2UncmUgYWxzbyBtaXNzaW5n
Ogo+ID4gCj4gPiAjaW5jbHVkZSA8YXNtL2JhcnJpZXIuaD4KPiAKPiBbLi4uXQo+IAo+ID4gI2lu
Y2x1ZGUgPGxpbnV4L2p1bXBfbGFiZWwuaD4KPiA+ICNpbmNsdWRlIDxsaW51eC9wZXJjcHUuaD4K
PiAKPiBEb25lIGZvciB0aG9zZSB0aHJlZS4KCkdyZWF0LgoKPiA+ICNpbmNsdWRlIDxsaW51eC90
aHJlYWRfaW5mby5oPgo+IAo+IFNpbmNlIGNvbW1pdCBlNmI2NzNiNzQxZWEgKCJLVk06IGFybTY0
OiBPcHRpbWlzZSBGUFNJTUQgaGFuZGxpbmcgdG8KPiByZWR1Y2UgZ3Vlc3QvaG9zdCB0aHJhc2hp
bmciLCB3ZSBkbyBoYXZlIDxhc20vdGhyZWFkX2luZm8uaD4uCj4gCj4gU2luY2UgdGhpcyBoZWFk
ZXIgaXMgbm90IGdlbmVyaWMsIHRoaXMgc2VlbXMgcmVhc29uYWJsZS4gIElzIHRoZXJlCj4gc29t
ZXRoaW5nIGZyb20gPGxpbnV4L3RocmVhZF9pbmZvLmg+IHVzZWQgaGVyZSB0aGF0IEknbSBtaXNz
aW5nPwoKSSB0aGluayBJIGp1c3QgY29uZnVzZWQgbXlzZWxmOyA8YXNtL3RocmVhZF9pbmZvLmg+
IHNlZW1zIHN1ZmZpY2llbnQuCgpUaGFua3MsCk1hcmsuCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdAps
aW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVh
ZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVsCg==

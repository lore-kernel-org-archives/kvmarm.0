From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v3 2/2] arm/arm64: KVM: enable 32 bits kvm vcpu events
 support
Date: Fri, 12 Oct 2018 15:36:14 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F201ECC805@dggema523-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: "christoffer.dall@arm.com" <christoffer.dall@arm.com>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "drjones@redhat.com" <drjones@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

SGkgSmFtZXMsDQoNCj4gSGkgRG9uZ2ppdSBHZW5nLA0KPiANCj4gT24gMTEvMTAvMjAxOCAyMDow
NywgRG9uZ2ppdSBHZW5nIHdyb3RlOg0KPiA+IFRoZSBjb21taXQgNTM5YWVlMGVkYjlmICgiS1ZN
OiBhcm02NDogU2hhcmUgdGhlIHBhcnRzIG9mIGdldC9zZXQNCj4gPiBldmVudHMgdXNlZnVsIHRv
IDMyYml0Iikgc2hhcmVzIHRoZSBnZXQvc2V0IGV2ZW50cyBoZWxwZXIgZm9yIGFybTY0DQo+ID4g
YW5kIGFybTMyLA0KPiANCj4gT29wcy4gSSBldmlkZW50bHkgZGlkbid0IHRlc3QgdGhpcyBiaXQu
IExvb2tzIGxpa2UgSSBqdXN0IGRlcGVuZGVkIG9uIHRoZSBzeW1ib2wgdG8gYmUgZGVmaW5lZCwg
SSBkaWRuJ3QgY2hlY2sgdGhlIENBUCB3YXMgZXhwb3NlZC4NCg0KWWVzLCB5b3UgZG8gbm90IGNo
ZWNrIHRoZSBDQVAgd2hlbiB5b3UgdGVzdCBpdC4NCg0KPiANCj4gDQo+ID4gaXQgaXMgYmV0dGVy
IGFsc28gc2hhcmUgdGhlIGNoZWNrDQo+ID4gZm9yIHZjcHUgZXZlbnRzIGNhcGFiaWxpdHkgdG8g
ZW5hYmxlIDMyIGJpdCBrdm0gdmNwdSBldmVudHMgc3VwcG9ydC4NCj4gDQo+IG5vdCBqdXN0IGJl
dHRlciwgbmVjZXNzYXJ5IGZvciBjb3JyZWN0bHktd3JpdHRlbiB1c2VyLXNwYWNlIHRvIGtub3cg
dGhlIGZlYXR1cmUgaXMgc3VwcG9ydGVkLiBUaGlzIGxhc3QgYml0IHdvdWxkIGJlIGNsZWFyZXIg
YXM6ICJidXQgZm9yZ290IHRvDQo+IHNoYXJlIHRoZSBjYXAgZXh0ZW5zaW9uIGNvZGUuIg0KDQpP
aywgd2lsbCB1cGRhdGUgaXQuDQoNCj4gDQo+IA0KPiBUaGFua3MgZm9yIGNhdGNoaW5nIHRoaXMh
DQoNCllvdSBhcmUgd2VsY29tZQ0KDQo+IA0KPiBBY2tlZC1ieTogSmFtZXMgTW9yc2UgPGphbWVz
Lm1vcnNlQGFybS5jb20+DQo+IA0KPiANCj4gVGhhbmtzLA0KPiANCj4gSmFtZXMNCg0K

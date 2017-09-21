From: Alan Hayward <Alan.Hayward@arm.com>
Subject: Re: [PATCH v2 14/28] arm64/sve: Backend logic for setting the vector
 length
Date: Thu, 21 Sep 2017 11:57:24 +0000
Message-ID: <E7AEE685-0814-4308-97D2-4AC095A52ED2@arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-15-git-send-email-Dave.Martin@arm.com>
 <FC5BA359-D37C-493C-87CD-146B83D3CCB5@arm.com>
 <20170920110902.GG24231@e103592.cambridge.arm.com>
 <E82895B2-3F95-4A54-8703-D654221F8CBA@arm.com>
 <20170921111937.GA17434@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170921111937.GA17434@e103592.cambridge.arm.com>
Content-Language: en-US
Content-ID: <C72B5FFA24A00B4E816F0BD2F22B9E01@eurprd08.prod.outlook.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave P Martin <Dave.Martin@arm.com>
Cc: Dave Martin <dave.martin@foss.arm.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, "gdb@sourceware.org" <gdb@sourceware.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Yao Qi <Yao.Qi@arm.com>, Will Deacon <Will.Deacon@arm.com>, Richard Sandiford <Richard.Sandiford@arm.com>, nd <nd@arm.com>, =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

DQo+IE9uIDIxIFNlcCAyMDE3LCBhdCAxMjoxOSwgRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFy
bS5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBTZXAgMjAsIDIwMTcgYXQgMDY6MDg6MjFQTSAr
MDAwMCwgQWxhbiBIYXl3YXJkIHdyb3RlOg0KPj4gDQo+Pj4gT24gMjAgU2VwIDIwMTcsIGF0IDEy
OjA5LCBEYXZlIE1hcnRpbiA8ZGF2ZS5tYXJ0aW5AZm9zcy5hcm0uY29tPiB3cm90ZToNCj4gDQo+
IFsuLi5dDQo+IA0KPj4+PiBHaXZlbiwgc3ZlX3NldF92ZWN0b3JfbGVuZ3RoIGlzIGNhbGxlZCB3
aGVuIHNldHRpbmcgdGhlIHZlY3RvciBsZW5ndGggaW4NCj4+Pj4gUFRSQUNFX1NFVFJFR1NFVCwg
aXQgbG9va3MgdG8gbWUgbGlrZSBpZiB5b3Ugc2V0IFZMIHRvIGEgdmFsdWUgdGhhdOKAmXMgbm90
DQo+Pj4+IHN1cHBvcnRlZCBieSB0aGUgaGFyZHdhcmUsIHRoZW4gaXTigJlzIGdvaW5nIHRvIHJv
dW5kIGRvd24gdG8gdGhlIHByZXZpb3VzIHZhbHVlLg0KPj4+PiBJcyB0aGF0IGNvcnJlY3Q/IEni
gJltIG5vdCBzdXJlIGlmIHRoYXTigJlzIGV4cGxhaW5lZCBpbiB0aGUgZG9jcz8NCj4+PiANCj4+
PiBEb2VzIHRoaXMgY292ZXIgaXQ/DQo+Pj4gDQo+Pj4gIk9uIHN1Y2Nlc3MsIHRoZSBjYWxsaW5n
IHRocmVhZCdzIHZlY3RvciBsZW5ndGggaXMgY2hhbmdlZCB0byB0aGUNCj4+PiBsYXJnZXN0IHZh
bHVlIHN1cHBvcnRlZCBieSB0aGUgc3lzdGVtIHRoYXQgaXMgbGVzcyB0aGFuIG9yIGVxdWFsIHRv
IHZsLiINCj4+PiANCj4+PiAoRm9yIHB0cmFjZSwgSSBqdXN0IGNyb3NzLXJlZmVyZW5jZSB0aGUg
UFJfU1ZFX1NFVF9WTCBiZWhhdmlvdXIsIGFib3ZlLikNCj4+IA0KPj4gRm9yIHB0cmFjZSBpcyBp
dCB3b3J0aCBtZW50aW9uaW5nIHVzZXIgc2hvdWxkIGRvIGEgR0VUIGFmdGVyIGEgU0VUIHRvIGNv
bmZpcm0NCj4+IHdoYXQgVkwgdmFsdWUgd2FzIGFjdHVhbGx5IHNldD8NCj4gDQo+IFRoaXMgc2Vl
bXMgd29ydGggYSBjbGFyaWZpY2F0aW9uIC0tIEknZCB0aG91Z2h0IHRoaXMgd2FzIGFscmVhZHkN
Cj4gbWVudGlvbmVkLCBidXQgaXQgaXNuJ3QuDQo+IA0KPiBIb3cgYWJvdXQ6DQo+IA0KPiAgVGhl
IGNhbGxlciBtdXN0IG1ha2UgYSBmdXJ0aGVyIEdFVFJFR1NFVCBjYWxsIGlmIGl0IG5lZWRzIHRv
IGtub3cgd2hhdCBWTCBpcw0KPiAgYWN0dWFsbHkgc2V0IGJ5IFNFVFJFR1NFVCwgdW5sZXNzIGlz
IGl0IGtub3duIGluIGFkdmFuY2UgdGhhdCB0aGUgcmVxdWVzdGVkDQo+ICBWTCBpcyBzdXBwb3J0
ZWQuDQo+IA0KDQpMb29rcyBnb29kIHRvIG1lLg0KDQoNCkFsYW4u

From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v10 16/18] KVM: arm64: Remove redundant *exit_code changes
 in fpsimd_guest_exit()
Date: Thu, 24 May 2018 16:02:28 +0100
Message-ID: <87y3g9rta3.fsf@linaro.org>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-17-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-reply-to: <1527005119-6842-17-git-send-email-Dave.Martin@arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IEluIGZpeHVwX2d1
ZXN0X2V4aXQoKSwgdGhlcmUgYXJlIGEgY291cGxlIG9mIGNhc2VzIHdoZXJlIGFmdGVyCj4gY2hl
Y2tpbmcgd2hhdCB0aGUgZXhpdCBjb2RlIHdhcywgd2UgYXNzaWduIGl0IGV4cGxpY2l0bHkgd2l0
aCB0aGUKPiB2YWx1ZSBpdCBhbHJlYWR5IGhhZC4KPgo+IEFzc3VtaW5nIHRoaXMgaXMgbm90IGlu
ZGljYXRpdmUgb2YgYSBidWcsIHRoZXNlIGFzc2lnbm1lbnRzIGFyZSBub3QKPiBuZWVkZWQuCj4K
PiBUaGlzIHBhdGNoIHJlbW92ZXMgdGhlIHJlZHVuZGFudCBhc3NpZ25tZW50cywgYW5kIHNpbXBs
aWZpZXMgc29tZQo+IGlmLW5lc3RpbmcgdGhhdCBiZWNvbWVzIHRyaXZpYWwgYXMgYSByZXN1bHQu
Cj4KPiBObyBmdW5jdGlvbmFsIGNoYW5nZS4KPgo+IFNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGlu
IDxEYXZlLk1hcnRpbkBhcm0uY29tPgo+IEFja2VkLWJ5OiBNYXJjIFp5bmdpZXIgPG1hcmMuenlu
Z2llckBhcm0uY29tPgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGlu
YXJvLm9yZz4KCi0tCkFsZXggQmVubsOpZQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KbGludXgtYXJtLWtlcm5lbCBtYWlsaW5nIGxpc3QKbGludXgtYXJt
LWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21h
aWxtYW4vbGlzdGluZm8vbGludXgtYXJtLWtlcm5lbAo=
